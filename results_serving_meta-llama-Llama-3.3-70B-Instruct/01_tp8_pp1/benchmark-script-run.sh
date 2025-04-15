✗ kubectl -n vllm-benchmark \
    exec -it $POD_NAME \
    -- bash /root/scripts/run_vllm_upstream_benchmark.sh

HF_TOKEN is set and valid.
Running over qps list 01
~/vllm/benchmarks /vllm-workspace
Running test case serving_meta-llama-Llama-3.3-70B-Instruct_tp8_pp1_sharegpt with qps 01
Client command: python3 benchmark_serving.py         --save-result         --base-url http://llama-3-3-70b-instruct.default:8000         --result-dir /root/vllm/.buildkite/results/         --result-filename tp8_pp1_qps_01.json         --request-rate 01         --model=meta-llama/Llama-3.3-70B-Instruct         --backend=vllm         --dataset-name=sharegpt         --dataset-path=/root/sharegpt.json         --num-prompts=200
INFO 04-14 14:11:28 [__init__.py:239] Automatically detected platform cuda.
Namespace(backend='vllm', base_url='http://llama-3-3-70b-instruct.default:8000', host='127.0.0.1', port=8000, endpoint='/v1/completions', dataset_name='sharegpt', dataset_path='/root/sharegpt.json', max_concurrency=None, model='meta-llama/Llama-3.3-70B-Instruct', tokenizer=None, use_beam_search=False, num_prompts=200, logprobs=None, request_rate=1.0, burstiness=1.0, seed=0, trust_remote_code=False, disable_tqdm=False, profile=False, save_result=True, save_detailed=False, metadata=None, result_dir='/root/vllm/.buildkite/results/', result_filename='tp8_pp1_qps_01.json', ignore_eos=False, percentile_metrics='ttft,tpot,itl', metric_percentiles='99', goodput=None, sonnet_input_len=550, sonnet_output_len=150, sonnet_prefix_len=200, sharegpt_output_len=None, random_input_len=1024, random_output_len=128, random_range_ratio=1.0, random_prefix_len=0, hf_subset=None, hf_split=None, hf_output_len=None, tokenizer_mode='auto', served_model_name=None, lora_modules=None)
tokenizer_config.json: 100%|████████████████████████████████████████████████████████████████████████████████████████████| 55.4k/55.4k [00:00<00:00, 6.20MB/s]
tokenizer.json: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████| 17.2M/17.2M [00:00<00:00, 124MB/s]
special_tokens_map.json: 100%|████████████████████████████████████████████████████████████████████████████████████████████| 68.0/68.0 [00:00<00:00, 1.08MB/s]
Starting initial single prompt test run...
Initial test run completed. Starting main benchmark run...
Traffic request rate: 1.0
Burstiness factor: 1.0 (Poisson process)
Maximum request concurrency: None
100%|██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 200/200 [03:25<00:00,  1.03s/it]
============ Serving Benchmark Result ============
Successful requests:                     200
Benchmark duration (s):                  205.22
Total input tokens:                      42659
Total generated tokens:                  42722
Request throughput (req/s):              0.97
Output token throughput (tok/s):         208.18
Total Token throughput (tok/s):          416.05
---------------Time to First Token----------------
Mean TTFT (ms):                          65.26
Median TTFT (ms):                        56.37
P99 TTFT (ms):                           143.80
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          24.56
Median TPOT (ms):                        24.54
P99 TPOT (ms):                           28.03
---------------Inter-token Latency----------------
Mean ITL (ms):                           24.48
Median ITL (ms):                         24.31
P99 ITL (ms):                            42.96
==================================================
/vllm-workspace
~/vllm/benchmarks /vllm-workspace
Running test case serving_meta-llama-Llama-3.3-70B-Instruct_tp8_pp1_sharegpt with qps 04
Client command: python3 benchmark_serving.py         --save-result         --base-url http://llama-3-3-70b-instruct.default:8000         --result-dir /root/vllm/.buildkite/results/         --result-filename tp8_pp1_qps_04.json         --request-rate 04         --model=meta-llama/Llama-3.3-70B-Instruct         --backend=vllm         --dataset-name=sharegpt         --dataset-path=/root/sharegpt.json         --num-prompts=200
INFO 04-14 14:15:09 [__init__.py:239] Automatically detected platform cuda.
Namespace(backend='vllm', base_url='http://llama-3-3-70b-instruct.default:8000', host='127.0.0.1', port=8000, endpoint='/v1/completions', dataset_name='sharegpt', dataset_path='/root/sharegpt.json', max_concurrency=None, model='meta-llama/Llama-3.3-70B-Instruct', tokenizer=None, use_beam_search=False, num_prompts=200, logprobs=None, request_rate=4.0, burstiness=1.0, seed=0, trust_remote_code=False, disable_tqdm=False, profile=False, save_result=True, save_detailed=False, metadata=None, result_dir='/root/vllm/.buildkite/results/', result_filename='tp8_pp1_qps_04.json', ignore_eos=False, percentile_metrics='ttft,tpot,itl', metric_percentiles='99', goodput=None, sonnet_input_len=550, sonnet_output_len=150, sonnet_prefix_len=200, sharegpt_output_len=None, random_input_len=1024, random_output_len=128, random_range_ratio=1.0, random_prefix_len=0, hf_subset=None, hf_split=None, hf_output_len=None, tokenizer_mode='auto', served_model_name=None, lora_modules=None)
Starting initial single prompt test run...
Initial test run completed. Starting main benchmark run...
Traffic request rate: 4.0
Burstiness factor: 1.0 (Poisson process)
Maximum request concurrency: None
100%|██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 200/200 [01:02<00:00,  3.18it/s]
============ Serving Benchmark Result ============
Successful requests:                     200
Benchmark duration (s):                  62.99
Total input tokens:                      42659
Total generated tokens:                  42449
Request throughput (req/s):              3.18
Output token throughput (tok/s):         673.92
Total Token throughput (tok/s):          1351.17
---------------Time to First Token----------------
Mean TTFT (ms):                          50.33
Median TTFT (ms):                        49.50
P99 TTFT (ms):                           67.56
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          27.08
Median TPOT (ms):                        27.35
P99 TPOT (ms):                           27.91
---------------Inter-token Latency----------------
Mean ITL (ms):                           27.10
Median ITL (ms):                         27.19
P99 ITL (ms):                            29.63
==================================================
/vllm-workspace
~/vllm/benchmarks /vllm-workspace
Running test case serving_meta-llama-Llama-3.3-70B-Instruct_tp8_pp1_sharegpt with qps 16
Client command: python3 benchmark_serving.py         --save-result         --base-url http://llama-3-3-70b-instruct.default:8000         --result-dir /root/vllm/.buildkite/results/         --result-filename tp8_pp1_qps_16.json         --request-rate 16         --model=meta-llama/Llama-3.3-70B-Instruct         --backend=vllm         --dataset-name=sharegpt         --dataset-path=/root/sharegpt.json         --num-prompts=200
INFO 04-14 14:16:26 [__init__.py:239] Automatically detected platform cuda.
Namespace(backend='vllm', base_url='http://llama-3-3-70b-instruct.default:8000', host='127.0.0.1', port=8000, endpoint='/v1/completions', dataset_name='sharegpt', dataset_path='/root/sharegpt.json', max_concurrency=None, model='meta-llama/Llama-3.3-70B-Instruct', tokenizer=None, use_beam_search=False, num_prompts=200, logprobs=None, request_rate=16.0, burstiness=1.0, seed=0, trust_remote_code=False, disable_tqdm=False, profile=False, save_result=True, save_detailed=False, metadata=None, result_dir='/root/vllm/.buildkite/results/', result_filename='tp8_pp1_qps_16.json', ignore_eos=False, percentile_metrics='ttft,tpot,itl', metric_percentiles='99', goodput=None, sonnet_input_len=550, sonnet_output_len=150, sonnet_prefix_len=200, sharegpt_output_len=None, random_input_len=1024, random_output_len=128, random_range_ratio=1.0, random_prefix_len=0, hf_subset=None, hf_split=None, hf_output_len=None, tokenizer_mode='auto', served_model_name=None, lora_modules=None)
Starting initial single prompt test run...
Initial test run completed. Starting main benchmark run...
Traffic request rate: 16.0
Burstiness factor: 1.0 (Poisson process)
Maximum request concurrency: None
100%|██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 200/200 [00:31<00:00,  6.33it/s]
============ Serving Benchmark Result ============
Successful requests:                     200
Benchmark duration (s):                  31.58
Total input tokens:                      42659
Total generated tokens:                  42770
Request throughput (req/s):              6.33
Output token throughput (tok/s):         1354.37
Total Token throughput (tok/s):          2705.22
---------------Time to First Token----------------
Mean TTFT (ms):                          59.58
Median TTFT (ms):                        58.10
P99 TTFT (ms):                           120.34
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          31.58
Median TPOT (ms):                        31.68
P99 TPOT (ms):                           36.51
---------------Inter-token Latency----------------
Mean ITL (ms):                           31.25
Median ITL (ms):                         30.42
P99 ITL (ms):                            40.34
==================================================
/vllm-workspace
~/vllm/benchmarks /vllm-workspace
Running test case serving_meta-llama-Llama-3.3-70B-Instruct_tp8_pp1_sharegpt with qps inf
Client command: python3 benchmark_serving.py         --save-result         --base-url http://llama-3-3-70b-instruct.default:8000         --result-dir /root/vllm/.buildkite/results/         --result-filename tp8_pp1_qps_inf.json         --request-rate inf         --model=meta-llama/Llama-3.3-70B-Instruct         --backend=vllm         --dataset-name=sharegpt         --dataset-path=/root/sharegpt.json         --num-prompts=200
INFO 04-14 14:17:10 [__init__.py:239] Automatically detected platform cuda.
Namespace(backend='vllm', base_url='http://llama-3-3-70b-instruct.default:8000', host='127.0.0.1', port=8000, endpoint='/v1/completions', dataset_name='sharegpt', dataset_path='/root/sharegpt.json', max_concurrency=None, model='meta-llama/Llama-3.3-70B-Instruct', tokenizer=None, use_beam_search=False, num_prompts=200, logprobs=None, request_rate=inf, burstiness=1.0, seed=0, trust_remote_code=False, disable_tqdm=False, profile=False, save_result=True, save_detailed=False, metadata=None, result_dir='/root/vllm/.buildkite/results/', result_filename='tp8_pp1_qps_inf.json', ignore_eos=False, percentile_metrics='ttft,tpot,itl', metric_percentiles='99', goodput=None, sonnet_input_len=550, sonnet_output_len=150, sonnet_prefix_len=200, sharegpt_output_len=None, random_input_len=1024, random_output_len=128, random_range_ratio=1.0, random_prefix_len=0, hf_subset=None, hf_split=None, hf_output_len=None, tokenizer_mode='auto', served_model_name=None, lora_modules=None)
Starting initial single prompt test run...
Initial test run completed. Starting main benchmark run...
Traffic request rate: inf
Burstiness factor: 1.0 (Poisson process)
Maximum request concurrency: None
100%|██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 200/200 [00:23<00:00,  8.40it/s]
============ Serving Benchmark Result ============
Successful requests:                     200
Benchmark duration (s):                  23.81
Total input tokens:                      42659
Total generated tokens:                  42398
Request throughput (req/s):              8.40
Output token throughput (tok/s):         1780.36
Total Token throughput (tok/s):          3571.67
---------------Time to First Token----------------
Mean TTFT (ms):                          360.36
Median TTFT (ms):                        349.85
P99 TTFT (ms):                           450.38
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          39.06
Median TPOT (ms):                        36.97
P99 TPOT (ms):                           75.77
---------------Inter-token Latency----------------
Mean ITL (ms):                           34.19
Median ITL (ms):                         35.05
P99 ITL (ms):                            43.60
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
| tp8_pp1_qps_01  | 1xStandard_ND96asr_v4 x 1 |         200 |       0.974567 |               208.177 |              416.047 |          65.2578 |            56.3722 |        143.801  |          24.5644 |            24.5413 |         28.0336 |         24.4782 |           24.3097 |        42.9578 |
| tp8_pp1_qps_04  | 1xStandard_ND96asr_v4 x 1 |         200 |       3.17519  |               673.918 |             1351.17  |          50.3255 |            49.5001 |         67.5639 |          27.0833 |            27.3485 |         27.9128 |         27.1039 |           27.1927 |        29.63   |
| tp8_pp1_qps_16  | 1xStandard_ND96asr_v4 x 1 |         200 |       6.33325  |              1354.37  |             2705.22  |          59.5779 |            58.1    |        120.336  |          31.5751 |            31.6757 |         36.511  |         31.2547 |           30.4248 |        40.3428 |
| tp8_pp1_qps_inf | 1xStandard_ND96asr_v4 x 1 |         200 |       8.3983   |              1780.36  |             3571.67  |         360.361  |           349.846  |        450.379  |          39.0627 |            36.9731 |         75.7652 |         34.1889 |           35.0514 |        43.5951 |

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
{"latency": {}, "throughput": {}, "serving": {"Test name": {"0": "tp8_pp1_qps_inf", "1": "tp8_pp1_qps_16", "2": "tp8_pp1_qps_04", "3": "tp8_pp1_qps_01"}, "GPU": {"0": "Standard_ND96asr_v4 x 1", "1": "Standard_ND96asr_v4 x 1", "2": "Standard_ND96asr_v4 x 1", "3": "Standard_ND96asr_v4 x 1"}, "# of req.": {"0": 200, "1": 200, "2": 200, "3": 200}, "Tput (req/s)": {"0": 8.398304797910107, "1": 6.333249923861803, "2": 3.1751913448302957, "3": 0.9745666315653629}, "Output Tput (tok/s)": {"0": 1780.3566341089636, "1": 1354.3654962178466, "2": 673.9184869835061, "3": 208.17717816867716}, "Total Tput (tok/s)": {"0": 3571.6730559792, "1": 2705.21603872795, "2": 1351.170924879084, "3": 416.0473678484113}, "Mean TTFT (ms)": {"0": 360.36056903502185, "1": 59.57789878501217, "2": 50.32546663501307, "3": 65.25777634499718}, "Median TTFT (ms)": {"0": 349.84637349998593, "1": 58.10000099995705, "2": 49.50005649993727, "3": 56.37217849994158}, "P99 TTFT (ms)": {"0": 450.3786364301777, "1": 120.3358004201981, "2": 67.56385031015722, "3": 143.80068917976584}, "Mean TPOT (ms)": {"0": 39.06266014106353, "1": 31.575131005299614, "2": 27.083319078977674, "3": 24.564414268982127}, "Median TPOT (ms)": {"0": 36.973057458311075, "1": 31.675739874099968, "2": 27.348463269617604, "3": 24.541288629103175}, "P99 TPOT (ms)": {"0": 75.76524432244929, "1": 36.510955727119054, "2": 27.912823145449423, "3": 28.033566246584865}, "Mean ITL (ms)": {"0": 34.188907868808926, "1": 31.254736291848793, "2": 27.103891616876638, "3": 24.478183568764482}, "Median ITL (ms)": {"0": 35.05137500019373, "1": 30.424775500023316, "2": 27.19267299994499, "3": 24.309653000045728}, "P99 ITL (ms)": {"0": 43.595131400124956, "1": 40.34279973975571, "2": 29.629998059913305, "3": 42.95781370012719}}}
```

You can also check the raw experiment data in the Artifact tab of the Buildkite page.

Results are saved in /root/results-serving_meta-llama-Llama-3.3-70B-Instruct_tp8_pp1_sharegpt.tar.gz
