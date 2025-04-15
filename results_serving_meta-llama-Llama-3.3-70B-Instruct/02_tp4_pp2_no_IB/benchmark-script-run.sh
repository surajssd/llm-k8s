✗ kubectl -n vllm-benchmark \
    exec -it $POD_NAME \
    -- bash /root/scripts/run_vllm_upstream_benchmark.sh
HF_TOKEN is set and valid.
Running over qps list 01
~/vllm/benchmarks /vllm-workspace
Running test case serving_tp4_pp2_no_IB with qps 01
Client command: python3 benchmark_serving.py         --save-result         --base-url http://llama-3-3-70b-instruct-leader.default:8000         --result-dir /root/vllm/.buildkite/results/         --result-filename tp4_pp2_no_IB_qps_01.json         --request-rate 01         --model=meta-llama/Llama-3.3-70B-Instruct         --backend=vllm         --dataset-name=sharegpt         --dataset-path=/root/sharegpt.json         --num-prompts=200
INFO 04-14 15:15:48 [__init__.py:239] Automatically detected platform cuda.
Namespace(backend='vllm', base_url='http://llama-3-3-70b-instruct-leader.default:8000', host='127.0.0.1', port=8000, endpoint='/v1/completions', dataset_name='sharegpt', dataset_path='/root/sharegpt.json', max_concurrency=None, model='meta-llama/Llama-3.3-70B-Instruct', tokenizer=None, use_beam_search=False, num_prompts=200, logprobs=None, request_rate=1.0, burstiness=1.0, seed=0, trust_remote_code=False, disable_tqdm=False, profile=False, save_result=True, save_detailed=False, metadata=None, result_dir='/root/vllm/.buildkite/results/', result_filename='tp4_pp2_no_IB_qps_01.json', ignore_eos=False, percentile_metrics='ttft,tpot,itl', metric_percentiles='99', goodput=None, sonnet_input_len=550, sonnet_output_len=150, sonnet_prefix_len=200, sharegpt_output_len=None, random_input_len=1024, random_output_len=128, random_range_ratio=1.0, random_prefix_len=0, hf_subset=None, hf_split=None, hf_output_len=None, tokenizer_mode='auto', served_model_name=None, lora_modules=None)
tokenizer_config.json: 100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 55.4k/55.4k [00:00<00:00, 7.30MB/s]
tokenizer.json: 100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 17.2M/17.2M [00:00<00:00, 107MB/s]
special_tokens_map.json: 100%|██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 68.0/68.0 [00:00<00:00, 980kB/s]
Starting initial single prompt test run...
Initial test run completed. Starting main benchmark run...
Traffic request rate: 1.0
Burstiness factor: 1.0 (Poisson process)
Maximum request concurrency: None
100%|███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 200/200 [03:35<00:00,  1.08s/it]
============ Serving Benchmark Result ============
Successful requests:                     200
Benchmark duration (s):                  215.73
Total input tokens:                      42659
Total generated tokens:                  42706
Request throughput (req/s):              0.93
Output token throughput (tok/s):         197.96
Total Token throughput (tok/s):          395.70
---------------Time to First Token----------------
Mean TTFT (ms):                          112.55
Median TTFT (ms):                        97.29
P99 TTFT (ms):                           224.11
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          44.15
Median TPOT (ms):                        44.04
P99 TPOT (ms):                           52.42
---------------Inter-token Latency----------------
Mean ITL (ms):                           44.11
Median ITL (ms):                         42.60
P99 ITL (ms):                            95.82
==================================================
/vllm-workspace
~/vllm/benchmarks /vllm-workspace
Running test case serving_tp4_pp2_no_IB with qps 04
Client command: python3 benchmark_serving.py         --save-result         --base-url http://llama-3-3-70b-instruct-leader.default:8000         --result-dir /root/vllm/.buildkite/results/         --result-filename tp4_pp2_no_IB_qps_04.json         --request-rate 04         --model=meta-llama/Llama-3.3-70B-Instruct         --backend=vllm         --dataset-name=sharegpt         --dataset-path=/root/sharegpt.json         --num-prompts=200
INFO 04-14 15:19:42 [__init__.py:239] Automatically detected platform cuda.
Namespace(backend='vllm', base_url='http://llama-3-3-70b-instruct-leader.default:8000', host='127.0.0.1', port=8000, endpoint='/v1/completions', dataset_name='sharegpt', dataset_path='/root/sharegpt.json', max_concurrency=None, model='meta-llama/Llama-3.3-70B-Instruct', tokenizer=None, use_beam_search=False, num_prompts=200, logprobs=None, request_rate=4.0, burstiness=1.0, seed=0, trust_remote_code=False, disable_tqdm=False, profile=False, save_result=True, save_detailed=False, metadata=None, result_dir='/root/vllm/.buildkite/results/', result_filename='tp4_pp2_no_IB_qps_04.json', ignore_eos=False, percentile_metrics='ttft,tpot,itl', metric_percentiles='99', goodput=None, sonnet_input_len=550, sonnet_output_len=150, sonnet_prefix_len=200, sharegpt_output_len=None, random_input_len=1024, random_output_len=128, random_range_ratio=1.0, random_prefix_len=0, hf_subset=None, hf_split=None, hf_output_len=None, tokenizer_mode='auto', served_model_name=None, lora_modules=None)
Starting initial single prompt test run...
Initial test run completed. Starting main benchmark run...
Traffic request rate: 4.0
Burstiness factor: 1.0 (Poisson process)
Maximum request concurrency: None
100%|███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 200/200 [01:18<00:00,  2.54it/s]
============ Serving Benchmark Result ============
Successful requests:                     200
Benchmark duration (s):                  78.88
Total input tokens:                      42659
Total generated tokens:                  42604
Request throughput (req/s):              2.54
Output token throughput (tok/s):         540.12
Total Token throughput (tok/s):          1080.94
---------------Time to First Token----------------
Mean TTFT (ms):                          114.26
Median TTFT (ms):                        103.23
P99 TTFT (ms):                           244.96
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          58.11
Median TPOT (ms):                        59.54
P99 TPOT (ms):                           71.10
---------------Inter-token Latency----------------
Mean ITL (ms):                           57.81
Median ITL (ms):                         56.12
P99 ITL (ms):                            152.16
==================================================
/vllm-workspace
~/vllm/benchmarks /vllm-workspace
Running test case serving_tp4_pp2_no_IB with qps 16
Client command: python3 benchmark_serving.py         --save-result         --base-url http://llama-3-3-70b-instruct-leader.default:8000         --result-dir /root/vllm/.buildkite/results/         --result-filename tp4_pp2_no_IB_qps_16.json         --request-rate 16         --model=meta-llama/Llama-3.3-70B-Instruct         --backend=vllm         --dataset-name=sharegpt         --dataset-path=/root/sharegpt.json         --num-prompts=200
INFO 04-14 15:21:16 [__init__.py:239] Automatically detected platform cuda.
Namespace(backend='vllm', base_url='http://llama-3-3-70b-instruct-leader.default:8000', host='127.0.0.1', port=8000, endpoint='/v1/completions', dataset_name='sharegpt', dataset_path='/root/sharegpt.json', max_concurrency=None, model='meta-llama/Llama-3.3-70B-Instruct', tokenizer=None, use_beam_search=False, num_prompts=200, logprobs=None, request_rate=16.0, burstiness=1.0, seed=0, trust_remote_code=False, disable_tqdm=False, profile=False, save_result=True, save_detailed=False, metadata=None, result_dir='/root/vllm/.buildkite/results/', result_filename='tp4_pp2_no_IB_qps_16.json', ignore_eos=False, percentile_metrics='ttft,tpot,itl', metric_percentiles='99', goodput=None, sonnet_input_len=550, sonnet_output_len=150, sonnet_prefix_len=200, sharegpt_output_len=None, random_input_len=1024, random_output_len=128, random_range_ratio=1.0, random_prefix_len=0, hf_subset=None, hf_split=None, hf_output_len=None, tokenizer_mode='auto', served_model_name=None, lora_modules=None)
Starting initial single prompt test run...
Initial test run completed. Starting main benchmark run...
Traffic request rate: 16.0
Burstiness factor: 1.0 (Poisson process)
Maximum request concurrency: None
100%|███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 200/200 [00:53<00:00,  3.74it/s]
============ Serving Benchmark Result ============
Successful requests:                     200
Benchmark duration (s):                  53.54
Total input tokens:                      42659
Total generated tokens:                  42855
Request throughput (req/s):              3.74
Output token throughput (tok/s):         800.41
Total Token throughput (tok/s):          1597.16
---------------Time to First Token----------------
Mean TTFT (ms):                          139.73
Median TTFT (ms):                        122.40
P99 TTFT (ms):                           395.34
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          70.70
Median TPOT (ms):                        70.15
P99 TPOT (ms):                           105.13
---------------Inter-token Latency----------------
Mean ITL (ms):                           66.93
Median ITL (ms):                         65.01
P99 ITL (ms):                            179.42
==================================================
/vllm-workspace
~/vllm/benchmarks /vllm-workspace
Running test case serving_tp4_pp2_no_IB with qps inf
Client command: python3 benchmark_serving.py         --save-result         --base-url http://llama-3-3-70b-instruct-leader.default:8000         --result-dir /root/vllm/.buildkite/results/         --result-filename tp4_pp2_no_IB_qps_inf.json         --request-rate inf         --model=meta-llama/Llama-3.3-70B-Instruct         --backend=vllm         --dataset-name=sharegpt         --dataset-path=/root/sharegpt.json         --num-prompts=200
INFO 04-14 15:22:25 [__init__.py:239] Automatically detected platform cuda.
Namespace(backend='vllm', base_url='http://llama-3-3-70b-instruct-leader.default:8000', host='127.0.0.1', port=8000, endpoint='/v1/completions', dataset_name='sharegpt', dataset_path='/root/sharegpt.json', max_concurrency=None, model='meta-llama/Llama-3.3-70B-Instruct', tokenizer=None, use_beam_search=False, num_prompts=200, logprobs=None, request_rate=inf, burstiness=1.0, seed=0, trust_remote_code=False, disable_tqdm=False, profile=False, save_result=True, save_detailed=False, metadata=None, result_dir='/root/vllm/.buildkite/results/', result_filename='tp4_pp2_no_IB_qps_inf.json', ignore_eos=False, percentile_metrics='ttft,tpot,itl', metric_percentiles='99', goodput=None, sonnet_input_len=550, sonnet_output_len=150, sonnet_prefix_len=200, sharegpt_output_len=None, random_input_len=1024, random_output_len=128, random_range_ratio=1.0, random_prefix_len=0, hf_subset=None, hf_split=None, hf_output_len=None, tokenizer_mode='auto', served_model_name=None, lora_modules=None)
Starting initial single prompt test run...
Initial test run completed. Starting main benchmark run...
Traffic request rate: inf
Burstiness factor: 1.0 (Poisson process)
Maximum request concurrency: None
100%|███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 200/200 [00:46<00:00,  4.26it/s]
============ Serving Benchmark Result ============
Successful requests:                     200
Benchmark duration (s):                  46.97
Total input tokens:                      42659
Total generated tokens:                  42749
Request throughput (req/s):              4.26
Output token throughput (tok/s):         910.14
Total Token throughput (tok/s):          1818.37
---------------Time to First Token----------------
Mean TTFT (ms):                          1016.56
Median TTFT (ms):                        1026.91
P99 TTFT (ms):                           1387.45
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          84.94
Median TPOT (ms):                        76.49
P99 TPOT (ms):                           211.60
---------------Inter-token Latency----------------
Mean ITL (ms):                           69.61
Median ITL (ms):                         67.00
P99 ITL (ms):                            92.52
==================================================
/vllm-workspace
~/vllm/.buildkite /vllm-workspace
/vllm-workspace

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

| Test name                                                          | GPU                       |   # of req. |   Tput (req/s) |   Output Tput (tok/s) |   Total Tput (tok/s) |   Mean TTFT (ms) |   Median TTFT (ms) |   P99 TTFT (ms) |   Mean TPOT (ms) |   Median TPOT (ms) |   P99 TPOT (ms) |   Mean ITL (ms) |   Median ITL (ms) |   P99 ITL (ms) |
|:-------------------------------------------------------------------|:--------------------------|------------:|---------------:|----------------------:|---------------------:|-----------------:|-------------------:|----------------:|-----------------:|-------------------:|----------------:|----------------:|------------------:|---------------:|
| tp4_pp2_no_IB_qps_01  | 1xStandard_ND96asr_v4 x 2 |         200 |       0.927083 |               197.96  |              395.702 |          112.546 |             97.294 |         224.11  |          44.1484 |            44.0356 |         52.4201 |         44.1057 |           42.599  |        95.8214 |
| tp4_pp2_no_IB_qps_04  | 1xStandard_ND96asr_v4 x 2 |         200 |       2.53555  |               540.122 |             1080.94  |          114.265 |            103.232 |         244.961 |          58.1053 |            59.5392 |         71.1041 |         57.813  |           56.1168 |       152.158  |
| tp4_pp2_no_IB_qps_16  | 1xStandard_ND96asr_v4 x 2 |         200 |       3.73543  |               800.41  |             1597.16  |          139.728 |            122.404 |         395.341 |          70.695  |            70.1526 |        105.133  |         66.9264 |           65.0063 |       179.416  |
| tp4_pp2_no_IB_qps_inf | 1xStandard_ND96asr_v4 x 2 |         200 |       4.25808  |               910.144 |             1818.37  |         1016.56  |           1026.91  |        1387.45  |          84.9447 |            76.4875 |        211.605  |         69.61   |           66.9992 |        92.5158 |

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
{"latency": {}, "throughput": {}, "serving": {"Test name": {"0": "tp4_pp2_no_IB_qps_01", "1": "tp4_pp2_no_IB_qps_16", "2": "tp4_pp2_no_IB_qps_inf", "3": "tp4_pp2_no_IB_qps_04"}, "GPU": {"0": "Standard_ND96asr_v4 x 2", "1": "Standard_ND96asr_v4 x 2", "2": "Standard_ND96asr_v4 x 2", "3": "Standard_ND96asr_v4 x 2"}, "# of req.": {"0": 200, "1": 200, "2": 200, "3": 200}, "Tput (req/s)": {"0": 0.927082696171368, "1": 3.7354348131448685, "2": 4.258081816517671, "3": 2.5355471020263534}, "Output Tput (tok/s)": {"0": 197.9599681134722, "1": 800.4102945866167, "2": 910.1436978715695, "3": 540.1222436736538}, "Total Tput (tok/s)": {"0": 395.70207179334415, "1": 1597.1598630563515, "2": 1818.3712589257061, "3": 1080.9417628003648}, "Mean TTFT (ms)": {"0": 112.54634028501641, "1": 139.72769470999538, "2": 1016.5552598499652, "3": 114.26462734999404}, "Median TTFT (ms)": {"0": 97.29397000046447, "1": 122.40424650008208, "2": 1026.9114015000014, "3": 103.23233049939518}, "P99 TTFT (ms)": {"0": 224.11016458079757, "1": 395.34062331931636, "2": 1387.4476577806945, "3": 244.96087586044263}, "Mean TPOT (ms)": {"0": 44.14835973583927, "1": 70.6950422403065, "2": 84.94467329375385, "3": 58.1053245359712}, "Median TPOT (ms)": {"0": 44.035557910379126, "1": 70.15256023000563, "2": 76.48754510805935, "3": 59.539237318389574}, "P99 TPOT (ms)": {"0": 52.420137621374174, "1": 105.13255287149671, "2": 211.60490782501734, "3": 71.10408331817656}, "Mean ITL (ms)": {"0": 44.10574301489207, "1": 66.92635843666612, "2": 69.60998572993496, "3": 57.812996666328814}, "Median ITL (ms)": {"0": 42.598970499966526, "1": 65.00634599979094, "2": 66.9991820004725, "3": 56.116805500096234}, "P99 ITL (ms)": {"0": 95.82135385035015, "1": 179.415
74535976537, "2": 92.5158026799545, "3": 152.15843627002872}}}
```

You can also check the raw experiment data in the Artifact tab of the Buildkite page.

Results are saved in /root/results-serving_tp4_pp2_no_IB.tar.gz
