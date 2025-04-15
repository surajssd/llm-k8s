
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
| tp4_pp2_optimized_IB_qps_01  | 1xStandard_ND96asr_v4-GPUDirect-RDMA-Infiniband x 2 |         200 |       0.924709 |               197.55  |              394.786 |          110.089 |            97.1478 |         229.352 |          44.0363 |            43.8254 |         51.2966 |         43.9828 |           42.5766 |        89.4988 |
| tp4_pp2_optimized_IB_qps_04  | 1xStandard_ND96asr_v4-GPUDirect-RDMA-Infiniband x 2 |         200 |       2.5417   |               543.112 |             1085.24  |          114.88  |           103.09   |         243.349 |          57.8201 |            59.0994 |         70.0526 |         57.5791 |           56.0936 |       157.018  |
| tp4_pp2_optimized_IB_qps_16  | 1xStandard_ND96asr_v4-GPUDirect-RDMA-Infiniband x 2 |         200 |       3.79431  |               811.3   |             1620.61  |          127.477 |           115.769  |         241.926 |          67.7359 |            67.2365 |         96.6957 |         64.8638 |           63.1964 |       145.998  |
| tp4_pp2_optimized_IB_qps_inf | 1xStandard_ND96asr_v4-GPUDirect-RDMA-Infiniband x 2 |         200 |       4.37087  |               933.925 |             1866.21  |          970.551 |          1002.31   |        1232.27  |          78.2115 |            71.5752 |        167.409  |         66.5477 |           65.5461 |        89.3575 |

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
{"latency": {}, "throughput": {}, "serving": {"Test name": {"0": "tp4_pp2_optimized_IB_qps_01", "1": "tp4_pp2_optimized_IB_qps_16", "2": "tp4_pp2_optimized_IB_qps_inf", "3": "tp4_pp2_optimized_IB_qps_04"}, "GPU": {"0": "Standard_ND96asr_v4-GPUDirect-RDMA-Infiniband x 2", "1": "Standard_ND96asr_v4-GPUDirect-RDMA-Infiniband x 2", "2": "Standard_ND96asr_v4-GPUDirect-RDMA-Infiniband x 2", "3": "Standard_ND96asr_v4-GPUDirect-RDMA-Infiniband x 2"}, "# of req.": {"0": 200, "1": 200, "2": 200, "3": 200}, "Tput (req/s)": {"0": 0.9247087073539347, "1": 3.794314379904193, "2": 4.370874723511406, "3": 2.5417049715204167}, "Output Tput (tok/s)": {"0": 197.55014469555786, "1": 811.3003007111146, "2": 933.9248021726821, "3": 543.1115183144826}, "Total Tput (tok/s)": {"0": 394.7858884306154, "1": 1620.6085863727794, "2": 1866.2105263240474, "3": 1085.2444802149298}, "Mean TTFT (ms)": {"0": 110.08901771998353, "1": 127.47713538500649, "2": 970.550653354976, "3": 114.87958173006518}, "Median TTFT (ms)": {"0": 97.14781100046821, "1": 115.76942749979935, "2": 1002.3081180006557, "3": 103.0901485000868}, "P99 TTFT (ms)": {"0": 229.352112778979, "1": 241.92609732010152, "2": 1232.2654208600034, "3": 243.34946868944823}, "Mean TPOT (ms)": {"0": 44.036275993568225, "1": 67.73594918647083, "2": 78.21149142652132, "3": 57.82005997403114}, "Median TPOT (ms)": {"0": 43.82540199661651, "1": 67.23653573249308, "2": 71.57516219128438, "3": 59.0993932545702}, "P99 TPOT (ms)": {"0": 51.29663850319903, "1": 96.69574010718601, "2": 167.40895294022275, "3": 70.052579895352}, "Mean ITL (ms)": {"0": 43.982763818139084, "1": 64.8638232319334, "2": 66.54770885482164, "3": 57.57912277444978}, "Median ITL (ms)": {"0": 42.57663700082048, "1": 63.19635800082324, "2": 65.54605800010904, "3": 56.09362249924743}, "P99 ITL (ms)": {"0": 89.49878271967444, "1": 145.99836950994361, "2": 89.35747172055926, "3": 157.0182241001021}}}
```

You can also check the raw experiment data in the Artifact tab of the Buildkite page.
