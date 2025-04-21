
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

| Test name                                                  | GPU                          |   # of req. |   Tput (req/s) |   Output Tput (tok/s) |   Total Tput (tok/s) |   Mean TTFT (ms) |   Median TTFT (ms) |   P99 TTFT (ms) |   Mean TPOT (ms) |   Median TPOT (ms) |   P99 TPOT (ms) |   Mean ITL (ms) |   Median ITL (ms) |   P99 ITL (ms) |
|:-----------------------------------------------------------|:-----------------------------|------------:|---------------:|----------------------:|---------------------:|-----------------:|-------------------:|----------------:|-----------------:|-------------------:|----------------:|----------------:|------------------:|---------------:|
| serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_01  | 1xib-Standard_ND96asr_v4 x 2 |         200 |       0.651377 |               139.014 |              292.722 |          227.47  |            203.671 |        1241.54  |          137.99  |            137.408 |         162.498 |         136.986 |           128.114 |        278.476 |
| serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_04  | 1xib-Standard_ND96asr_v4 x 2 |         200 |       1.18058  |               250.23  |              528.818 |          227.527 |            219.97  |         449.453 |          167.116 |            164.781 |         235.652 |         155.036 |           139.355 |        430.007 |
| serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_16  | 1xib-Standard_ND96asr_v4 x 2 |         200 |       1.46607  |               311.019 |              656.974 |          239.256 |            233.958 |         342.987 |          228.171 |            169.589 |         628.591 |         158.357 |           141.627 |        776.336 |
| serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_inf | 1xib-Standard_ND96asr_v4 x 2 |         200 |       1.57666  |               335.703 |              707.755 |         1838.06  |           1882.46  |        2667.65  |          170.38  |            148.324 |         471.125 |         144.155 |           141.769 |        166.42  |

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
{"latency": {}, "throughput": {}, "serving": {"Test name": {"0": "serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_inf", "1": "serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_04", "2": "serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_16", "3": "serving_deepseek-ai-DeepSeek-V2.5_tp8_pp2_sharegpt_qps_01"}, "GPU": {"0": "ib-Standard_ND96asr_v4 x 2", "1": "ib-Standard_ND96asr_v4 x 2", "2": "ib-Standard_ND96asr_v4 x 2", "3": "ib-Standard_ND96asr_v4 x 2"}, "# of req.": {"0": 200, "1": 200, "2": 200, "3": 200}, "Tput (req/s)": {"0": 1.5766606401731489, "1": 1.1805817160141518, "2": 1.4660661099539998, "3": 0.6513771685045269}, "Output Tput (tok/s)": {"0": 335.7025835056669, "1": 250.23019761777954, "2": 311.0185948961913, "3": 139.0136584163936}, "Total Tput (tok/s)": {"0": 707.7550780705257, "1": 528.817968054219, "2": 656.9735451925864, "3": 292.72238575424933}, "Mean TTFT (ms)": {"0": 1838.0622782349883, "1": 227.5274549800224, "2": 239.2556627650265, "3": 227.4703368749806}, "Median TTFT (ms)": {"0": 1882.4594789998628, "1": 219.97036899983868, "2": 233.95759600043675, "3": 203.6709174999487}, "P99 TTFT (ms)": {"0": 2667.6450628802104, "1": 449.45297280995595, "2": 342.9873392893657, "3": 1241.5408530999225}, "Mean TPOT (ms)": {"0": 170.37956874797084, "1": 167.11607583777084, "2": 228.17121810451414, "3": 137.98958250224254}, "Median TPOT (ms)": {"0": 148.32368449723873, "1": 164.78083675452385, "2": 169.58904850702328, "3": 137.40774158858838}, "P99 TPOT (ms)": {"0": 471.12467792497324, "1": 235.65231788493517, "2": 628.590636492744, "3": 162.49795580367203}, "Mean ITL (ms)": {"0": 144.15495247126285, "1": 155.0355169040555, "2": 158.35680763702663, "3": 136.9862377000447}, "Median ITL (ms)": {"0": 141.768747000242, "1": 139.35549599955266, "2": 141.627447999781, "3": 128.11423600032867}, "P99 ITL (ms)": {"0": 166.42040517005626, "1": 430.0070693003363, "2": 776.3359202393622, "3": 278.475786300387}}}
```

You can also check the raw experiment data in the Artifact tab of the Buildkite page.

