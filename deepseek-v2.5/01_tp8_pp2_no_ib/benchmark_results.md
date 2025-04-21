
## Latency tests

- Input length: 32 tokens.
- Output length: 128 tokens.
- Batch size: fixed (8).
- Models: llama-3.1 8B, llama-3 70B, mixtral 8x7B.
- Evaluation metrics: end-to-end latency (mean, median, p99).



## Throughput tests

- Input length: randomly sample 200 prompts from ShareGPT dataset (with fixed random seed).
- Output length: the corresponding output length of these 200 prompts.
- Batch size: dynamically determined by vllm to achieve maximum throughput.
- Models: llama-3.1 8B, llama-3 70B, mixtral 8x7B.
- Evaluation metrics: throughput.



## Serving tests

- Input length: randomly sample 200 prompts from ShareGPT dataset (with fixed random seed).
- Output length: the corresponding output length of these 200 prompts.
- Batch size: dynamically determined by vllm and the arrival pattern of the requests.
- **Average QPS (query per second)**: 1, 4, 16 and inf. QPS = inf means all requests come at once. For other QPS values, the arrival time of each query is determined using a random Poisson process (with fixed random seed).
- Models: llama-3.1 8B, llama-3 70B, mixtral 8x7B.
- We also added a speculative decoding test for llama-3 70B, under QPS 2
- Evaluation metrics: throughput, TTFT (time to the first token, with mean, median and p99), ITL (inter-token latency, with mean, median and p99).

| Test name                                                  | GPU                             |   # of req. |   Tput (req/s) |   Output Tput (tok/s) |   Total Tput (tok/s) |   Mean TTFT (ms) |   Median TTFT (ms) |   P99 TTFT (ms) |   Mean TPOT (ms) |   Median TPOT (ms) |   P99 TPOT (ms) |   Mean ITL (ms) |   Median ITL (ms) |   P99 ITL (ms) |
|:-----------------------------------------------------------|:--------------------------------|------------:|---------------:|----------------------:|---------------------:|-----------------:|-------------------:|----------------:|-----------------:|-------------------:|----------------:|----------------:|------------------:|---------------:|
| serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_01  | 1xno-ib-Standard_ND96asr_v4 x 2 |         200 |       0.646012 |               137.901 |              290.344 |          236.677 |            215.085 |        1302.77  |          139.814 |            139.073 |         165.73  |         138.785 |           129.591 |        286.317 |
| serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_04  | 1xno-ib-Standard_ND96asr_v4 x 2 |         200 |       1.17664  |               250.984 |              528.643 |          237.706 |            223.34  |         703.65  |          173.128 |            170.547 |         232.624 |         158.083 |           141.287 |        451.196 |
| serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_16  | 1xno-ib-Standard_ND96asr_v4 x 2 |         200 |       1.46822  |               312.342 |              658.806 |          246.536 |            242.183 |         397.258 |          235.883 |            170.223 |         758.732 |         160.798 |           143.171 |        723.514 |
| serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_inf | 1xno-ib-Standard_ND96asr_v4 x 2 |         200 |       1.57831  |               332.795 |              705.238 |         1746.93  |           1643.29  |        2415.8   |          165.243 |            148.692 |         378.552 |         144.618 |           142.733 |        175.876 |

## json version of the benchmarking tables

This section contains the data of the markdown tables above in JSON format.
You can load the benchmarking tables into pandas dataframes as follows:

```python
import json
import pandas as pd

benchmarking_results_json = """The json string"""
benchmarking_results = json.loads(benchmarking_results_json)
latency_results = pd.DataFrame.from_dict(benchmarking_results["latency"])
throughput_results = pd.DataFrame.from_dict(benchmarking_results["throughput"])
serving_results = pd.DataFrame.from_dict(benchmarking_results["serving"])
```

The json string for all benchmarking tables:

```json
{"latency": {}, "throughput": {}, "serving": {"Test name": {"0": "serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_inf", "1": "serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_04", "2": "serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_16", "3": "serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_01"}, "GPU": {"0": "no-ib-Standard_ND96asr_v4 x 2", "1": "no-ib-Standard_ND96asr_v4 x 2", "2": "no-ib-Standard_ND96asr_v4 x 2", "3": "no-ib-Standard_ND96asr_v4 x 2"}, "# of req.": {"0": 200, "1": 200, "2": 200, "3": 200}, "Tput (req/s)": {"0": 1.5783142962853098, "1": 1.1766439365211216, "2": 1.468222656412066, "3": 0.6460120963119033}, "Output Tput (tok/s)": {"0": 332.795460943239, "1": 250.98403487963785, "2": 312.34234681182085, "3": 137.9009721392204}, "Total Tput (tok/s)": {"0": 705.2381770091649, "1": 528.6425878002095, "2": 658.8061881586581, "3": 290.3436765664218}, "Mean TTFT (ms)": {"0": 1746.9318987299926, "1": 237.70570729000156, "2": 246.5362340549973, "3": 236.6770997449987}, "Median TTFT (ms)": {"0": 1643.2945829999426, "1": 223.3403375000762, "2": 242.1831200001634, "3": 215.08480900001814}, "P99 TTFT (ms)": {"0": 2415.798339080029, "1": 703.650007379991, "2": 397.25756394026575, "3": 1302.7685389300552}, "Mean TPOT (ms)": {"0": 165.24337870132945, "1": 173.12829061579276, "2": 235.88335644599937, "3": 139.81350262282567}, "Median TPOT (ms)": {"0": 148.69220395241942, "1": 170.54721971024378, "2": 170.22252761884855, "3": 139.07252231626438}, "P99 TPOT (ms)": {"0": 378.55161128501345, "1": 232.6240094058092, "2": 758.7318589340167, "3": 165.7304836604579}, "Mean ITL (ms)": {"0": 144.6180005657716, "1": 158.0826950697817, "2": 160.7979810031879, "3": 138.78487663942295}, "Median ITL (ms)": {"0": 142.73341299985987, "1": 141.28654900014226, "2": 143.17061899964756, "3": 129.5905679999123}, "P99 ITL (ms)": {"0": 175.87617270005467, "1": 451.19584720014245, "2": 723.5138443600408, "3": 286.31702052003675}}}
```

You can also check the raw experiment data in the Artifact tab of the Buildkite page.

