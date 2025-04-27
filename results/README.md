# Inference Benchmarks GuideLLM vs. Inference Perf

This document contains the results of the inference benchmarks comparing the performance of [GuideLLM](https://github.com/neuralmagic/guidellm) and [Inference Perf](https://github.com/kubernetes-sigs/inference-perf) with and without InfiniBand (IB) support.

You can find how to reproduce results [here](reproduce-results.sh).

## Inferece Perf

### No IB

| qps | total_requests | avg_prompt_tokens  | avg_output_tokens  | avg_time_per_request |
|-----|----------------|--------------------|--------------------|----------------------|
| 1   | 30             | 2.0                | 30.0               | 4.202913660966805    |
| 2   | 52             | 2.0                | 30.0               | 4.278307224769185    |
| 4   | 116            | 2.0                | 30.0               | 5.539329888956939    |
| 8   | 232            | 2.0                | 30.0               | 6.373378577879317    |
| 16  | 478            | 2.0                | 30.0               | 13.11741881918619    |
| 32  | 1048           | 2.0                | 30.0               | 14.00620739284638    |
| 64  | 1888           | 2.0254237288135593 | 29.99364406779661  | 13.517128890727232   |
| 128 | 3796           | 2.017913593256059  | 29.99841938883035  | 34.44164316218467    |
| 256 | 7602           | 2.0320968166272033 | 29.999079189686924 | 77.57944635678506    |
| 275 | 8155           | 2.029920294297977  | 29.998405885959535 | 87.41208369252128    |

### IB

| qps | total_requests | avg_prompt_tokens  | avg_output_tokens  | avg_time_per_request |
|-----|----------------|--------------------|--------------------|----------------------|
| 1   | 31             | 2.0                | 30.0               | 4.246130865516138    |
| 2   | 66             | 2.0                | 30.0               | 4.778317809196978    |
| 4   | 120            | 2.0                | 30.0               | 4.998442869533377    |
| 8   | 262            | 2.0                | 30.0               | 6.78952510045418     |
| 16  | 478            | 2.0                | 30.0               | 12.83315562270921    |
| 32  | 1003           | 2.0                | 30.0               | 13.968554007363899   |
| 64  | 1877           | 2.0255727224294087 | 30.0               | 13.448727644415552   |
| 128 | 3884           | 2.0175077239958807 | 30.0               | 36.61685651079068    |
| 256 | 7586           | 2.032164513577643  | 29.99841813867651  | 81.03532881966292    |
| 275 | 8298           | 2.0294046758255    | 29.998433357435527 | 90.58022213568655    |

See the visualization of the inference perf results [here](inference-perf-results.png).

## GuideLLM

### No IB

```
Benchmarks Metadata:
    Run id:31a16140-ea84-4242-a63e-2a0477f88f85
    Duration:310.6 seconds
    Profile:type=sweep, strategies=['synchronous', 'throughput', 'constant', 'constant', 'constant', 'constant', 'constant', 'constant', 'constant', 'constant'], max_concurrency=None
    Args:max_number=None, max_duration=30.0, warmup_number=None, warmup_duration=None, cooldown_number=None, cooldown_duration=None
    Worker:type_='generative_requests_worker' backend_type='openai_http' backend_target='http://deepseek-v2-5-leader.default:8000' backend_model='deepseek-ai/DeepSeek-V2.5' backend_info={'max_output_tokens': 16384, 'timeout': 300, 'http2': True, 'authorization': False,
    'organization': None, 'project': None, 'text_completions_path': '/v1/completions', 'chat_completions_path': '/v1/chat/completions'}
    Request Loader:type_='generative_request_loader' data='prompt_tokens=256,output_tokens=128' data_args=None processor='deepseek-ai/DeepSeek-V2.5' processor_args=None
    Extras:tag=no-infiniband, metadata={'infiniband': 'not-supported'}

Benchmarks Info

====================================================================================================================================================
Metadata                                      |||| Requests Made  ||| Prompt Tok/Req ||| Output Tok/Req ||| Prompt Tok Total||| Output Tok Total  ||
    Benchmark| Start Time| End Time| Duration (s)|  Comp|  Inc|  Err|  Comp|   Inc| Err|  Comp|   Inc| Err|  Comp|    Inc| Err|   Comp|    Inc|  Err
-------------|-----------|---------|-------------|------|-----|-----|------|------|----|------|------|----|------|-------|----|-------|-------|-----
  synchronous|   11:33:36| 11:34:06|         29.8|     1|    1|    0| 257.0| 256.0| 0.0| 128.0|  23.0| 0.0|   257|    256|   0|    128|     23|    0
   throughput|   11:34:06| 11:34:36|         29.8|   224|  512|    0| 257.0| 256.0| 0.0| 128.0| 116.2| 0.0| 57571| 131072|   0|  28672|  59472|    0
constant@0.99|   11:34:42| 11:35:11|         29.0|    11|   18|    0| 257.0| 256.0| 0.0| 128.0|  64.6| 0.0|  2827|   4608|   0|   1408|   1163|    0
constant@1.93|   11:35:12| 11:35:42|         29.9|    20|   38|    0| 257.0| 256.0| 0.0| 128.0|  63.3| 0.0|  5140|   9728|   0|   2560|   2406|    0
constant@2.88|   11:35:42| 11:36:12|         29.9|    22|   66|    0| 257.0| 256.0| 0.0| 128.0|  63.4| 0.0|  5654|  16896|   0|   2816|   4186|    0
constant@3.82|   11:36:13| 11:36:43|         29.8|    19|   98|    0| 257.0| 256.0| 0.0| 128.0|  61.5| 0.0|  4883|  25088|   0|   2432|   6029|    0
constant@4.77|   11:36:43| 11:37:13|         29.8|     7|  139|    0| 257.3| 256.0| 0.0| 128.0|  61.2| 0.0|  1801|  35584|   0|    896|   8509|    0
constant@5.71|   11:37:14| 11:37:44|         29.9|     0|  174|    0|   0.0| 256.0| 0.0|   0.0|  58.1| 0.0|     0|  44544|   0|      0|  10104|    0
constant@6.66|   11:37:45| 11:38:15|         29.9|     0|  203|    0|   0.0| 256.0| 0.0|   0.0|  49.7| 0.0|     0|  51968|   0|      0|  10080|    0
constant@7.60|   11:38:16| 11:38:46|         29.8|     0|  234|    0|   0.0| 256.0| 0.0|   0.0|  42.0| 0.0|     0|  59904|   0|      0|   9827|    0
====================================================================================================================================================

Benchmarks Stats

==========================================================================================================================================================
Metadata     | Request Stats         || Out Tok/sec| Tot Tok/sec| Req Latency (ms)  ||| TTFT (ms)           ||| ITL (ms)          ||| TPOT (ms)         ||
    Benchmark| Per Second| Concurrency|        mean|        mean|  mean| median|   p99|   mean| median|    p99|  mean| median|   p99|  mean| median|   p99
-------------|-----------|------------|------------|------------|------|-------|------|-------|-------|-------|------|-------|------|------|-------|------
  synchronous|       0.04|        1.00|         5.1|        25.6| 25.01|  25.01| 25.01|  289.2|  289.2|  289.2| 194.7|  194.7| 194.7| 193.2|  193.2| 193.2
   throughput|       7.60|      215.12|       973.0|      4873.1| 28.30|  28.28| 28.58| 2292.2| 2239.4| 3377.2| 204.8|  204.4| 210.5| 203.2|  202.8| 208.9
constant@0.99|       0.39|        7.00|        50.2|       251.4| 17.85|  17.85| 18.02|  212.0|  208.9|  261.6| 138.9|  138.9| 139.9| 137.8|  137.8| 138.8
constant@1.93|       0.68|       13.33|        86.6|       433.7| 19.71|  19.70| 20.02|  202.2|  205.6|  288.4| 153.6|  153.5| 156.1| 152.4|  152.3| 154.9
constant@2.88|       0.74|       16.68|        94.5|       473.2| 22.59|  22.62| 22.98|  211.5|  207.1|  272.2| 176.2|  176.0| 179.2| 174.8|  174.6| 177.8
constant@3.82|       0.64|       16.19|        82.0|       410.9| 25.25|  25.21| 25.69|  230.9|  211.7|  426.9| 197.0|  196.3| 201.0| 195.5|  194.8| 199.4
constant@4.77|       0.24|        6.89|        30.1|       151.1| 29.26|  29.25| 29.32|  350.4|  358.6|  445.7| 227.6|  227.4| 228.9| 225.8|  225.6| 227.1
constant@5.71|       0.00|        0.00|         0.0|         0.0|  0.00|   0.00|  0.00|    0.0|    0.0|    0.0|   0.0|    0.0|   0.0|   0.0|    0.0|   0.0
constant@6.66|       0.00|        0.00|         0.0|         0.0|  0.00|   0.00|  0.00|    0.0|    0.0|    0.0|   0.0|    0.0|   0.0|   0.0|    0.0|   0.0
constant@7.60|       0.00|        0.00|         0.0|         0.0|  0.00|   0.00|  0.00|    0.0|    0.0|    0.0|   0.0|    0.0|   0.0|   0.0|    0.0|   0.0
==========================================================================================================================================================
```

### IB

```
Benchmarks Metadata:
    Run id:19a15041-fa43-4fc7-8506-aacb3fafd1ee
    Duration:310.0 seconds
    Profile:type=sweep, strategies=['synchronous', 'throughput', 'constant', 'constant', 'constant', 'constant', 'constant', 'constant', 'constant', 'constant'], max_concurrency=None
    Args:max_number=None, max_duration=30.0, warmup_number=None, warmup_duration=None, cooldown_number=None, cooldown_duration=None
    Worker:type_='generative_requests_worker' backend_type='openai_http' backend_target='http://deepseek-v2-5-leader.default:8000' backend_model='deepseek-ai/DeepSeek-V2.5' backend_info={'max_output_tokens': 16384, 'timeout': 300, 'http2': True, 'authorization': False,
    'organization': None, 'project': None, 'text_completions_path': '/v1/completions', 'chat_completions_path': '/v1/chat/completions'}
    Request Loader:type_='generative_request_loader' data='prompt_tokens=256,output_tokens=128' data_args=None processor='deepseek-ai/DeepSeek-V2.5' processor_args=None
    Extras:tag=infiniband, metadata={'infiniband': 'supported'}


Benchmarks Info:
====================================================================================================================================================
Metadata                                      |||| Requests Made  ||| Prompt Tok/Req ||| Output Tok/Req ||| Prompt Tok Total||| Output Tok Total  ||
    Benchmark| Start Time| End Time| Duration (s)|  Comp|  Inc|  Err|  Comp|   Inc| Err|  Comp|   Inc| Err|  Comp|    Inc| Err|   Comp|    Inc|  Err
-------------|-----------|---------|-------------|------|-----|-----|------|------|----|------|------|----|------|-------|----|-------|-------|-----
  synchronous|   12:49:37| 12:50:07|         29.6|     0|    1|    0|   0.0| 256.0| 0.0|   0.0| 127.0| 0.0|     0|    256|   0|      0|    127|    0
   throughput|   12:50:07| 12:50:37|         29.9|   220|  512|    0| 257.0| 256.0| 0.0| 128.0| 116.1| 0.0| 56543| 131072|   0|  28160|  59466|    0
constant@0.93|   12:50:44| 12:51:12|         28.9|    11|   16|    0| 257.0| 256.0| 0.0| 128.0|  64.5| 0.0|  2827|   4096|   0|   1408|   1032|    0
constant@1.87|   12:51:13| 12:51:43|         29.9|    20|   36|    0| 257.0| 256.0| 0.0| 128.0|  63.2| 0.0|  5140|   9216|   0|   2560|   2275|    0
constant@2.80|   12:51:43| 12:52:13|         29.8|    22|   63|    0| 257.0| 256.0| 0.0| 128.0|  62.0| 0.0|  5654|  16128|   0|   2816|   3907|    0
constant@3.73|   12:52:14| 12:52:44|         29.8|    19|   95|    0| 257.1| 256.0| 0.0| 128.0|  60.4| 0.0|  4885|  24320|   0|   2432|   5739|    0
constant@4.66|   12:52:44| 12:53:14|         29.9|     7|  136|    0| 257.0| 256.0| 0.0| 128.0|  60.8| 0.0|  1799|  34816|   0|    896|   8263|    0
constant@5.60|   12:53:15| 12:53:45|         29.8|     0|  171|    0|   0.0| 256.0| 0.0|   0.0|  58.4| 0.0|     0|  43776|   0|      0|   9979|    0
constant@6.53|   12:53:46| 12:54:16|         29.9|     0|  199|    0|   0.0| 256.0| 0.0|   0.0|  51.0| 0.0|     0|  50944|   0|      0|  10147|    0
constant@7.46|   12:54:17| 12:54:46|         29.5|     0|  229|    0|   0.0| 256.0| 0.0|   0.0|  43.3| 0.0|     0|  58624|   0|      0|   9915|    0
====================================================================================================================================================


Benchmarks Stats:
==========================================================================================================================================================
Metadata     | Request Stats         || Out Tok/sec| Tot Tok/sec| Req Latency (ms)  ||| TTFT (ms)           ||| ITL (ms)          ||| TPOT (ms)         ||
    Benchmark| Per Second| Concurrency|        mean|        mean|  mean| median|   p99|   mean| median|    p99|  mean| median|   p99|  mean| median|   p99
-------------|-----------|------------|------------|------------|------|-------|------|-------|-------|-------|------|-------|------|------|-------|------
  synchronous|       0.00|        0.00|         0.0|         0.0|  0.00|   0.00|  0.00|    0.0|    0.0|    0.0|   0.0|    0.0|   0.0|   0.0|    0.0|   0.0
   throughput|       7.46|      216.84|       955.1|      4783.2| 29.06|  28.97| 29.47| 1990.0| 2059.8| 3210.1| 213.1|  213.4| 227.5| 211.5|  211.7| 225.7
constant@0.93|       0.39|        6.85|        49.3|       246.8| 17.79|  17.78| 18.32|  234.3|  204.5|  428.5| 138.3|  138.2| 141.2| 137.2|  137.1| 140.1
constant@1.87|       0.67|       13.20|        86.3|       432.3| 19.57|  19.57| 19.78|  214.1|  204.0|  326.6| 152.4|  152.5| 153.9| 151.2|  151.4| 152.7
constant@2.80|       0.74|       16.58|        95.0|       475.7| 22.34|  22.33| 22.70|  228.9|  213.7|  411.9| 174.1|  173.9| 177.4| 172.8|  172.6| 176.0
constant@3.73|       0.64|       16.10|        82.3|       412.3| 25.03|  24.97| 25.51|  256.3|  256.0|  421.1| 195.1|  195.0| 199.4| 193.5|  193.5| 197.9
constant@4.66|       0.24|        6.83|        30.2|       151.3| 28.93|  28.94| 29.13|  259.4|  261.7|  298.8| 225.7|  225.6| 227.4| 224.0|  223.8| 225.7
constant@5.60|       0.00|        0.00|         0.0|         0.0|  0.00|   0.00|  0.00|    0.0|    0.0|    0.0|   0.0|    0.0|   0.0|   0.0|    0.0|   0.0
constant@6.53|       0.00|        0.00|         0.0|         0.0|  0.00|   0.00|  0.00|    0.0|    0.0|    0.0|   0.0|    0.0|   0.0|   0.0|    0.0|   0.0
constant@7.46|       0.00|        0.00|         0.0|         0.0|  0.00|   0.00|  0.00|    0.0|    0.0|    0.0|   0.0|    0.0|   0.0|   0.0|    0.0|   0.0
==========================================================================================================================================================
```

See the visualization of the GuideLLM results [here](guidellm-ib-vs-no-ib.pdf).

## Grafana

- Kubernetes / Networking
  - Cluster
    - noIB: <https://snapshots.raintank.io/dashboard/snapshot/JZAMCncIPJAfMopiZyDUtkOlgmOTSzoD>
    - IB: <https://snapshots.raintank.io/dashboard/snapshot/iFfNXOizotQEnRbPdtzuCkeHycGATTmw>
  - Namespace (Pods)
    - noIB: <https://snapshots.raintank.io/dashboard/snapshot/cUUTgmTIUV4MiBzWVIoGTG8Hsrtn9aij>
    - IB: <https://snapshots.raintank.io/dashboard/snapshot/QLfA2as55z4EoZP9Jf4zlg6oEWUiqu09>
- Ray Dashboard
  - noIB: <https://snapshots.raintank.io/dashboard/snapshot/j88xd3lTYhZdBi3DEuqr49jWfgCQaVk6>
  - IB: <https://snapshots.raintank.io/dashboard/snapshot/TOnvEXzk5Kv1xr9oAuM3H9wHW74X6SU9>
- vLLM
  - noIB: <https://snapshots.raintank.io/dashboard/snapshot/VxOwdopoS8gmS3nKCNwCuPROR5vxJs33>
  - IB: <https://snapshots.raintank.io/dashboard/snapshot/rVBcqQHk8gRdS8P0Mtp5lDGIOBirDW7K>
- NVIDIA DCGM Exporter Dashboard
  - noIB: <http://localhost:3000/dashboard/snapshot/zFZrTYTQivR6ShojvMIGynegBfFZISaY>
  - IB: <https://snapshots.raintank.io/dashboard/snapshot/0lKqQTIwImdDnFfbSzX2WiZSiJCPI6GE>
- NVIDIA DCGM Exporter
  - noIB: <https://snapshots.raintank.io/dashboard/snapshot/G0QzVoliNtCSGpehqtE0EXECkjKp2BlR>
  - IB: <https://snapshots.raintank.io/dashboard/snapshot/VToBHzkKcXsdByLPaIXYoVSn5hr24ike>
