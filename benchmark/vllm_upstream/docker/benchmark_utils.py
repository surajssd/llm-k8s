import pandas as pd
import io
import os
import plotly.express as px
import plotly.graph_objects as go

def get_root_dir():
    default_root_dir = "/root/genai-perf-results/artifacts"
    # See if there is an environment variable set for the root directory
    root_dir = os.getenv('GENAI_PERF_ROOT_DIR')
    if root_dir:
        return root_dir.strip('\'"')
    return default_root_dir

def model_name_prefix():
    model_name_prefix = os.getenv('GENAI_PERF_MODEL_NAME_PREFIX')
    if model_name_prefix:
        return model_name_prefix.strip('\'"')
    raise ValueError("Environment variable GENAI_PERF_MODEL_NAME_PREFIX is not set. Please set it to the model name prefix.")

def get_hour_cost() -> float:
    hourly_cost = os.getenv('INSTANCE_HOURLY_COST')
    if hourly_cost:
        return float(hourly_cost.strip('\'"'))
    return 0

def parse_data(file_path):
    # Create a StringIO buffer
    buffer = io.StringIO()
    with open(file_path, 'rt') as file:
        for i, line in enumerate(file):
            if i not in [7,8]:
                buffer.write(line)
    # Make sure to reset the buffer's position to the beginning before reading
    buffer.seek(0)
    # Read the buffer into a pandas DataFrame
    df = pd.read_csv(buffer)
    return df

def safe_float(val):
    return float(str(val).replace(',', ''))

def get_metadata(file_path):
    # The file path ends with .csv, but we wanna open the .json file
    json_file_path = file_path.replace('.csv', '.json')
    if not os.path.exists(json_file_path):
        return None
    with open(json_file_path, 'r') as json_file:
        metadata = json_file.read()
    return metadata

def token_length(input_output_pair) -> int:
    match input_output_pair:
        case "256_256":
            return 512
        case "256_8":
            return 264
        case "1024_256":
            return 1280
        case _:
            return 0

def get_use_case(input_output_pair) -> str:
    match input_output_pair:
        case "256_256":
            return "Translation (256/256)"
        case "256_8":
            return "Text classification (256/8)"
        case "1024_256":
            return "Text summary (1024/256)"
        case _:
            return "Unknown"

def load_all_data(input_output_pairs, concurrencies, root_dir, directory_prefix, hourly_cost, percent_gpu_used=1):
    """Load and process all performance data"""
    all_data = {}
    for input_output_pair in input_output_pairs:
        TPS = []
        TTFT = []
        Latency = []
        ITL = []
        Request = []
        metadata = []
        TOC = []

        total_tokens = token_length(input_output_pair)

        for con in concurrencies:
            file = os.path.join(root_dir, directory_prefix+str(con), input_output_pair + "_genai_perf.csv")
            df = parse_data(file)

            TPS.append(safe_float(df.iloc[7]['avg']))
            TTFT.append(safe_float(df.iloc[0]['avg']))
            Latency.append(safe_float(df.iloc[2]['avg']))
            ITL.append(safe_float(df.iloc[3]['avg']))

            rps = safe_float(df.iloc[8]['avg'])
            Request.append(rps)

            metadata.append(get_metadata(file))

            # Formula is here: https://developer.nvidia.com/blog/benchmarking-llm-inference-costs-for-smarter-scaling-and-deployment
            cost = (hourly_cost * 1000000) / (rps * 3600 * total_tokens)
            cost = cost * percent_gpu_used
            TOC.append(cost)

        all_data[input_output_pair] = {
            'TPS': TPS,
            'TTFT': TTFT,
            'Latency': Latency,
            'ITL': ITL,
            'Request': Request,
            'concurrencies': concurrencies,
            'TOC': TOC
        }
    return all_data

def create_scatter_plot(all_data, input_output_pairs, x_key, y_key, x_title, y_title, plot_title):
    """Create a standardized scatter plot"""
    fig = go.Figure()
    for input_output_pair in input_output_pairs:
        data = all_data[input_output_pair]
        fig.add_trace(go.Scatter(
            x=data[x_key],
            y=data[y_key],
            mode='lines+markers+text',
            text=data['concurrencies'],
            textposition="top center",
            name=get_use_case(input_output_pair),
            line=dict(width=2)
        ))
    fig.update_layout(
        xaxis_title=x_title,
        yaxis_title=y_title,
        title=plot_title
    )
    return fig

# Constants
DEFAULT_INPUT_OUTPUT = [
    "256_256",
    "256_8",
    "1024_256",
]

DEFAULT_CONCURRENCIES = [1, 2, 5, 10, 50, 100, 250]

def plot_everything(all_data, prefix):
    # TTFT vs. TPS
    fig = create_scatter_plot(
        all_data,
        DEFAULT_INPUT_OUTPUT,
        'TTFT',
        'TPS',
        "⏱️ Time to first token (ms) [lower is better]",
        "🚀 Tokens/s (TPS): Total System",
        f"{prefix}: TTFT vs. TPS for all input/output pairs"
    )
    fig.show()

    # TTFT vs. Cost
    fig = create_scatter_plot(
        all_data,
        DEFAULT_INPUT_OUTPUT,
        'TTFT',
        'TOC',
        "⏱️ Time to first token (ms) [lower is better]",
        "💰 Cost: $ / 1M tokens",
        f"{prefix}: TTFT vs. Cost for all input/output pairs"
    )
    fig.show()

    # TTFT vs. Req / s
    fig = create_scatter_plot(
        all_data,
        DEFAULT_INPUT_OUTPUT,
        'TTFT',
        'Request',
        "⏱️ Time to first token (ms) [lower is better]",
        "📊 Request / sec [higher is better]",
        f"{prefix}: TTFT vs. Request / sec for all input/output pairs"
    )
    fig.show()

    # Latency vs. TPS
    fig = create_scatter_plot(
        all_data,
        DEFAULT_INPUT_OUTPUT,
        'Latency',
        'TPS',
        "🐌 Latency (ms) [lower is better]",
        "🚀 Tokens/s (TPS): Total System",
        f"{prefix}: Latency vs. TPS for all input/output pairs"
    )
    fig.show()

    # Latency vs. Cost
    fig = create_scatter_plot(
        all_data,
        DEFAULT_INPUT_OUTPUT,
        'Latency',
        'TOC',
        "🐌 Latency (ms) [lower is better]",
        "💰 Cost: $ / 1M tokens",
        f"{prefix}: Latency vs. Cost for all input/output pairs"
    )
    fig.show()

    # ITL vs. TPS
    fig = create_scatter_plot(
        all_data,
        DEFAULT_INPUT_OUTPUT,
        'ITL',
        'TPS',
        "⛓️ ITL (ms) [lower is better]",
        "🚀 Tokens/s (TPS): Total System",
        f"{prefix}: ITL vs. TPS for all input/output pairs"
    )
    fig.show()

    # ITL vs. Cost
    fig = create_scatter_plot(
        all_data,
        DEFAULT_INPUT_OUTPUT,
        'ITL',
        'TOC',
        "⛓️ ITL (ms) [lower is better]",
        "💰 Cost: $ / 1M tokens",
        f"{prefix}: ITL vs. Cost for all input/output pairs"
    )
    fig.show()

    # Request vs. TPS
    fig = create_scatter_plot(
        all_data,
        DEFAULT_INPUT_OUTPUT,
        'Request',
        'TPS',
        "📊 Request / sec [higher is better]",
        "🚀 Tokens/s (TPS): Total System",
        f"{prefix}: Request vs. TPS for all input/output pairs"
    )
    fig.show()

    # Request vs. TTFT
    fig = create_scatter_plot(
        all_data,
        DEFAULT_INPUT_OUTPUT,
        'Request',
        'TTFT',
        "📊 Request / sec [higher is better]",
        "⏱️ Time to first token (ms) [lower is better]",
        f"{prefix}: Request vs. TTFT for all input/output pairs"
    )
    fig.show()

    # Request vs. ITL
    fig = create_scatter_plot(
        all_data,
        DEFAULT_INPUT_OUTPUT,
        'Request',
        'ITL',
        "📊 Request / sec [higher is better]",
        "⛓️ ITL (ms) [lower is better]",
        f"{prefix}: Request vs. ITL for all input/output pairs"
    )
