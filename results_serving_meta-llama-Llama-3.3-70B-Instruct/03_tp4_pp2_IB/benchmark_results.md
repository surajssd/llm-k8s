
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

| Test name                                                          | GPU                                                 |   # of req. |   Tput (req/s) |   Output Tput (tok/s) |   Total Tput (tok/s) |   Mean TTFT (ms) |   Median TTFT (ms) |   P99 TTFT (ms) |   Mean TPOT (ms) |   Median TPOT (ms) |   P99 TPOT (ms) |   Mean ITL (ms) |   Median ITL (ms) |   P99 ITL (ms) |
|:-------------------------------------------------------------------|:----------------------------------------------------|------------:|---------------:|----------------------:|---------------------:|-----------------:|-------------------:|----------------:|-----------------:|-------------------:|----------------:|----------------:|------------------:|---------------:|
| tp4_pp2_non_optimized_IB_qps_01  | 1xStandard_ND96asr_v4-IB-trial-1 x 2 |         200 |       0.925294 |               197.902 |              395.263 |          109.874 |            97.4938 |         220.933 |          43.8879 |            43.6895 |         51.168  |         43.8176 |           42.4069 |         88.375 |
| tp4_pp2_non_optimized_IB_qps_04  | 1xStandard_ND96asr_v4-IB-trial-1 x 2 |         200 |       2.53255  |               537.926 |             1078.11  |          115.73  |           104.931  |         248.544 |          57.6677 |            58.6623 |         70.703  |         57.5216 |           56.4525 |        144.563 |
| tp4_pp2_non_optimized_IB_qps_16  | 1xStandard_ND96asr_v4-IB-trial-1 x 2 |         200 |       3.79371  |               811.341 |             1620.52  |          124.249 |           111.787  |         259.593 |          68.3793 |            67.8591 |         90.7486 |         65.436  |           63.8284 |        166.965 |
| tp4_pp2_non_optimized_IB_qps_inf | 1xStandard_ND96asr_v4-IB-trial-1 x 2 |         200 |       4.38419  |               930.413 |             1865.54  |          870.411 |           893.141  |        1213.84  |          79.5803 |            72.8739 |        182.905  |         67.3208 |           65.9644 |        104.189 |

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
{"latency": {}, "throughput": {}, "serving": {"Test name": {"0": "tp4_pp2_non_optimized_IB_qps_01", "1": "tp4_pp2_non_optimized_IB_qps_16", "2": "tp4_pp2_non_optimized_IB_qps_inf", "3": "tp4_pp2_non_optimized_IB_qps_04"}, "GPU": {"0": "Standard_ND96asr_v4-IB-trial-1 x 2", "1": "Standard_ND96asr_v4-IB-trial-1 x 2", "2": "Standard_ND96asr_v4-IB-trial-1 x 2", "3": "Standard_ND96asr_v4-IB-trial-1 x 2"}, "# of req.": {"0": 200, "1": 200, "2": 200, "3": 200}, "Tput (req/s)": {"0": 0.9252941316144377, "1": 3.79370813470199, "2": 4.384189453327111, "3": 2.532547753596563}, "Output Tput (tok/s)": {"0": 197.90190886969594, "1": 811.3413902280412, "2": 930.4126857850796, "3": 537.925805602678}, "Total Tput (tok/s)": {"0": 395.26252067239744, "1": 1620.5203668193021, "2": 1865.5383752324858, "3": 1078.1055787060568}, "Mean TTFT (ms)": {"0": 109.87438224503421, "1": 124.2492660300195, "2": 870.4108890200678, "3": 115.7298648048345}, "Median TTFT (ms)": {"0": 97.49378749984317, "1": 111.78667549938837, "2": 893.1407009995382, "3": 104.93067449897353}, "P99 TTFT (ms)": {"0": 220.9331577912234, "1": 259.59292217983597, "2": 1213.8436117099263, "3": 248.54378834994338}, "Mean TPOT (ms)": {"0": 43.88791989348178, "1": 68.37933144855863, "2": 79.58026313185233, "3": 57.66766941388919}, "Median TPOT (ms)": {"0": 43.68951223705339, "1": 67.8590755282266, "2": 72.8739474022069, "3": 58.66229391837721}, "P99 TPOT (ms)": {"0": 51.16798036970481, "1": 90.7486310285354, "2": 182.90461366881368, "3": 70.70302883035235}, "Mean ITL (ms)": {"0": 43.81761668543291, "1": 65.43596600310045, "2": 67.32078907191614, "3": 57.5216223699768}, "Median ITL (ms)": {"0": 42.406869999467744, "1": 63.82844200015825, "2": 65.96442299996852, "3": 56.45246399944881}, "P99 ITL (ms)": {"0": 88.37504975053889, "1": 166.96471587965777, "2": 104.18858402972546, "3": 144.56322779951734}}}
```

You can also check the raw experiment data in the Artifact tab of the Buildkite page.
