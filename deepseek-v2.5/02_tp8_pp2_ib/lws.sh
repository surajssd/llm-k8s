➜  llm-k8s git:(main) ✗ k exec -it deepseek-v2-5-0 -- bash
root@deepseek-v2-5-0:/vllm-workspace# bash /vllm-workspace/examples/online_serving/multi-node-serving.sh leader --ray_cluster_size=$LWS_GROUP_SIZE --dashboard-host=0.0.0.0 --metrics-export-port=8080;
Enable usage stats collection? This prompt will auto-proceed in 10 seconds to avoid blocking cluster startup. Confirm [Y/n]: Y
Usage stats collection is enabled. To disable this, add `--disable-usage-stats` to the command that starts the cluster, or run the following command: `ray disable-usage-stats` before starting the cluster. See https://docs.ray.io/en/master/cluster/usage-stats.html for more details.

Local node IP: 10.244.2.62
[2025-04-20 16:46:38,300 W 39 39] global_state_accessor.cc:429: Retrying to get node with node ID 120edfb38c504e0494eb4c253105322039774e52ba2efedbed38e3ea

--------------------
Ray runtime started.
--------------------
Next steps
  To add another node to this Ray cluster, run
    ray start --address='10.244.2.62:6379'

  To connect to this Ray cluster:
    import ray
    ray.init()

  To submit a Ray job using the Ray Jobs CLI:
    RAY_ADDRESS='http://10.244.2.62:8265' ray job submit --working-dir . -- python my_script.py

  See https://docs.ray.io/en/latest/cluster/running-applications/job-submission/index.html
  for more information on submitting Ray jobs to the Ray cluster.
  To terminate the Ray runtime, run
    ray stop

  To view the status of the cluster, use
    ray status

  To monitor and debug Ray, view the dashboard at
  10.244.2.62:8265
  If connection to the dashboard fails, check your firewall settings and network configuration.
2025-04-20 16:46:39,823 INFO worker.py:1654 -- Connecting to existing Ray cluster at address: 10.244.2.62:6379...
2025-04-20 16:46:39,835 INFO worker.py:1832 -- Connected to Ray cluster. View the dashboard at http://10.244.2.62:8265
All ray workers are active and the ray cluster is initialized successfully.
root@deepseek-v2-5-0:/vllm-workspace#
root@deepseek-v2-5-0:/vllm-workspace# python3 -m vllm.entrypoints.openai.api_server \
    --port 8000 \
    --model deepseek-ai/DeepSeek-V2.5 \
    --tensor-parallel-size 8 \
    --pipeline-parallel-size 2 \
    --enable-prefix-caching \
    --max-model-len 8192 \
    --enforce-eager \
    --trust-remote-code
INFO 04-20 16:46:52 [__init__.py:239] Automatically detected platform cuda.
INFO 04-20 16:46:54 [api_server.py:1034] vLLM API server version 0.8.3
INFO 04-20 16:46:54 [api_server.py:1035] args: Namespace(host=None, port=8000, uvicorn_log_level='info', disable_uvicorn_access_log=False, allow_credentials=False, allowed_origins=['*'], allowed_methods=['*'], allowed_headers=['*'], api_key=None, lora_modules=None, prompt_adapters=None, chat_template=None, chat_template_content_format='auto', response_role='assistant', ssl_keyfile=None, ssl_certfile=None, ssl_ca_certs=None, enable_ssl_refresh=False, ssl_cert_reqs=0, root_path=None, middleware=[], return_tokens_as_token_ids=False, disable_frontend_multiprocessing=False, enable_request_id_headers=False, enable_auto_tool_choice=False, tool_call_parser=None, tool_parser_plugin='', model='deepseek-ai/DeepSeek-V2.5', task='auto', tokenizer=None, hf_config_path=None, skip_tokenizer_init=False, revision=None, code_revision=None, tokenizer_revision=None, tokenizer_mode='auto', trust_remote_code=True, allowed_local_media_path=None, download_dir=None, load_format='auto', config_format=<ConfigFormat.AUTO: 'auto'>, dtype='auto', kv_cache_dtype='auto', max_model_len=8192, guided_decoding_backend='xgrammar', logits_processor_pattern=None, model_impl='auto', distributed_executor_backend=None, pipeline_parallel_size=2, tensor_parallel_size=8, data_parallel_size=1, enable_expert_parallel=False, max_parallel_loading_workers=None, ray_workers_use_nsight=False, block_size=None, enable_prefix_caching=True, prefix_caching_hash_algo='builtin', disable_sliding_window=False, use_v2_block_manager=True, num_lookahead_slots=0, seed=None, swap_space=4, cpu_offload_gb=0, gpu_memory_utilization=0.9, num_gpu_blocks_override=None, max_num_batched_tokens=None, max_num_partial_prefills=1, max_long_partial_prefills=1, long_prefill_token_threshold=0, max_num_seqs=None, max_logprobs=20, disable_log_stats=False, quantization=None, rope_scaling=None, rope_theta=None, hf_overrides=None, enforce_eager=True, max_seq_len_to_capture=8192, disable_custom_all_reduce=False, tokenizer_pool_size=0, tokenizer_pool_type='ray', tokenizer_pool_extra_config=None, limit_mm_per_prompt=None, mm_processor_kwargs=None, disable_mm_preprocessor_cache=False, enable_lora=False, enable_lora_bias=False, max_loras=1, max_lora_rank=16, lora_extra_vocab_size=256, lora_dtype='auto', long_lora_scaling_factors=None, max_cpu_loras=None, fully_sharded_loras=False, enable_prompt_adapter=False, max_prompt_adapters=1, max_prompt_adapter_token=0, device='auto', num_scheduler_steps=1, use_tqdm_on_load=True, multi_step_stream_outputs=True, scheduler_delay_factor=0.0, enable_chunked_prefill=None, speculative_config=None, model_loader_extra_config=None, ignore_patterns=[], preemption_mode=None, served_model_name=None, qlora_adapter_name_or_path=None, show_hidden_metrics_for_version=None, otlp_traces_endpoint=None, collect_detailed_traces=None, disable_async_output_proc=False, scheduling_policy='fcfs', scheduler_cls='vllm.core.scheduler.Scheduler', override_neuron_config=None, override_pooler_config=None, compilation_config=None, kv_transfer_config=None, worker_cls='auto', worker_extension_cls='', generation_config='auto', override_generation_config=None, enable_sleep_mode=False, calculate_kv_scales=False, additional_config=None, enable_reasoning=False, reasoning_parser=None, disable_cascade_attn=False, disable_log_requests=False, max_log_len=None, disable_fastapi_docs=False, enable_prompt_tokens_details=False, enable_server_load_tracking=False)
config.json: 100%|██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 1.55k/1.55k [00:00<00:00, 20.2MB/s]
configuration_deepseek.py: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 10.3k/10.3k [00:00<00:00, 86.7MB/s]
A new version of the following files was downloaded from https://huggingface.co/deepseek-ai/DeepSeek-V2.5:
- configuration_deepseek.py
. Make sure to double-check they do not contain any added malicious code. To avoid downloading new versions of the code file, you can pin a revision.
INFO 04-20 16:46:55 [config.py:209] Replacing legacy 'type' key with 'rope_type'
INFO 04-20 16:47:03 [config.py:600] This model supports multiple tasks: {'generate', 'embed', 'classify', 'score', 'reward'}. Defaulting to 'generate'.
WARNING 04-20 16:47:03 [arg_utils.py:1708] Pipeline Parallelism without Ray distributed executor is not supported by the V1 Engine. Falling back to V0.
INFO 04-20 16:47:03 [config.py:1600] Defaulting to use ray for distributed inference
INFO 04-20 16:47:03 [llm_engine.py:242] Initializing a V0 LLM engine (v0.8.3) with config: model='deepseek-ai/DeepSeek-V2.5', speculative_config=None, tokenizer='deepseek-ai/DeepSeek-V2.5', skip_tokenizer_init=False, tokenizer_mode=auto, revision=None, override_neuron_config=None, tokenizer_revision=None, trust_remote_code=True, dtype=torch.bfloat16, max_seq_len=8192, download_dir=None, load_format=LoadFormat.AUTO, tensor_parallel_size=8, pipeline_parallel_size=2, disable_custom_all_reduce=False, quantization=None, enforce_eager=True, kv_cache_dtype=auto,  device_config=cuda, decoding_config=DecodingConfig(guided_decoding_backend='xgrammar', reasoning_backend=None), observability_config=ObservabilityConfig(show_hidden_metrics=False, otlp_traces_endpoint=None, collect_model_forward_time=False, collect_model_execute_time=False), seed=None, served_model_name=deepseek-ai/DeepSeek-V2.5, num_scheduler_steps=1, multi_step_stream_outputs=True, enable_prefix_caching=True, chunked_prefill_enabled=False, use_async_output_proc=False, disable_mm_preprocessor_cache=False, mm_processor_kwargs=None, pooler_config=None, compilation_config={"splitting_ops":[],"compile_sizes":[],"cudagraph_capture_sizes":[],"max_capture_size":0}, use_cached_outputs=False,
tokenizer_config.json: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 2.94k/2.94k [00:00<00:00, 48.4MB/s]
tokenizer.json: 100%|███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 4.61M/4.61M [00:00<00:00, 24.9MB/s]
generation_config.json: 100%|███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 181/181 [00:00<00:00, 2.67MB/s]
2025-04-20 16:47:04,621 INFO worker.py:1654 -- Connecting to existing Ray cluster at address: 10.244.2.62:6379...
2025-04-20 16:47:04,633 INFO worker.py:1832 -- Connected to Ray cluster. View the dashboard at http://10.244.2.62:8265
INFO 04-20 16:47:04 [ray_utils.py:335] No current placement group found. Creating a new placement group.
INFO 04-20 16:47:04 [ray_distributed_executor.py:176] use_ray_spmd_worker: False
(pid=657) INFO 04-20 16:47:08 [__init__.py:239] Automatically detected platform cuda.
(pid=627, ip=10.244.1.107) INFO 04-20 16:47:14 [__init__.py:239] Automatically detected platform cuda. [repeated 8x across cluster] (Ray deduplicates logs by default. Set RAY_DEDUP_LOGS=0 to disable log deduplication, or see https://docs.ray.io/en/master/ray-observability/user-guides/configure-logging.html#log-deduplication for more options.)
INFO 04-20 16:47:16 [ray_distributed_executor.py:352] non_carry_over_env_vars from config: set()
INFO 04-20 16:47:16 [ray_distributed_executor.py:354] Copying the following environment variables to workers: ['LD_LIBRARY_PATH', 'VLLM_USAGE_SOURCE', 'VLLM_WORKER_MULTIPROC_METHOD', 'VLLM_USE_V1']
INFO 04-20 16:47:16 [ray_distributed_executor.py:357] If certain env vars should NOT be copied to workers, add them to /root/.config/vllm/ray_non_carry_over_env_vars.json file
INFO 04-20 16:47:17 [cuda.py:191] Using Triton MLA backend.
(RayWorkerWrapper pid=663) INFO 04-20 16:47:17 [cuda.py:191] Using Triton MLA backend.
WARNING 04-20 16:47:18 [triton_decode_attention.py:44] The following error message 'operation scheduled before its operands' can be ignored.
(RayWorkerWrapper pid=663) WARNING 04-20 16:47:18 [triton_decode_attention.py:44] The following error message 'operation scheduled before its operands' can be ignored.
(pid=632, ip=10.244.1.107) INFO 04-20 16:47:14 [__init__.py:239] Automatically detected platform cuda. [repeated 7x across cluster]
   INFO 04-20 16:47:23 [utils.py:990] Found nccl from library libnccl.so.2
INFO 04-20 16:47:23 [pynccl.py:69] vLLM is using nccl==2.21.5
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Bootstrap : Using eth0:10.244.2.62<0>
deepseek-v2-5-0:5969:5969 [0] NCCL INFO NET/Plugin: No plugin found (libnccl-net.so)
deepseek-v2-5-0:5969:5969 [0] NCCL INFO NET/Plugin: Plugin load returned 2 : libnccl-net.so: cannot open shared object file: No such file or directory : when loading libnccl-net.so
deepseek-v2-5-0:5969:5969 [0] NCCL INFO NET/Plugin: Using internal network plugin.
deepseek-v2-5-0:5969:5969 [0] NCCL INFO cudaDriverVersion 12080
NCCL version 2.21.5+cuda12.4
(RayWorkerWrapper pid=663) INFO 04-20 16:47:23 [utils.py:990] Found nccl from library libnccl.so.2
(RayWorkerWrapper pid=663) INFO 04-20 16:47:23 [pynccl.py:69] vLLM is using nccl==2.21.5
(RayWorkerWrapper pid=633, ip=10.244.1.107) INFO 04-20 16:47:18 [cuda.py:191] Using Triton MLA backend. [repeated 14x across cluster]
(RayWorkerWrapper pid=631, ip=10.244.1.107) WARNING 04-20 16:47:18 [triton_decode_attention.py:44] The following error message 'operation scheduled before its operands' can be ignored. [repeated 14x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Bootstrap : Using eth0:10.244.1.107<0>
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO NET/Plugin: No plugin found (libnccl-net.so)
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO NET/Plugin: Plugin load returned 2 : libnccl-net.so: cannot open shared object file: No such file or directory : when loading libnccl-net.so
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO NET/Plugin: Using internal network plugin.
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO cudaDriverVersion 12080
(RayWorkerWrapper pid=626, ip=10.244.1.107) NCCL version 2.21.5+cuda12.4
deepseek-v2-5-0:5969:5969 [0] NCCL INFO NCCL_IB_DISABLE set by environment to 0.
deepseek-v2-5-0:5969:5969 [0] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB [1]mlx5_1:1/IB [2]mlx5_2:1/IB [3]mlx5_3:1/IB [4]mlx5_4:1/IB [5]mlx5_5:1/IB [6]mlx5_6:1/IB [7]mlx5_7:1/IB [RO]; OOB eth0:10.244.2.62<0>
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Using non-device net plugin version 0
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Using network IB
deepseek-v2-5-0:5969:5969 [0] NCCL INFO DMA-BUF is available on GPU device 0
deepseek-v2-5-0:5969:5969 [0] NCCL INFO ncclCommInitRank comm 0x4b8e2080 rank 0 nranks 8 cudaDev 0 nvmlDev 0 busId 100000 commId 0xc13f651b1c793497 - Init START
deepseek-v2-5-0:5969:5969 [0] NCCL INFO NCCL_CUMEM_ENABLE set by environment to 0.
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Setting affinity for GPU 0 to ffff,ff000000
deepseek-v2-5-0:5969:5969 [0] NCCL INFO NVLS multicast support is not available on dev 0
deepseek-v2-5-0:5969:5969 [0] NCCL INFO comm 0x4b8e2080 rank 0 nRanks 8 nNodes 1 localRanks 8 localRank 0 MNNVL 0
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 00/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 01/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 02/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 03/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 04/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 05/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 06/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 07/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 08/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 09/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 10/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 11/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 12/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 13/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 14/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 15/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 16/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 17/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 18/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 19/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 20/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 21/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 22/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 23/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Trees [0] 1/-1/-1->0->-1 [1] 1/-1/-1->0->-1 [2] 1/-1/-1->0->-1 [3] 1/-1/-1->0->-1 [4] 1/-1/-1->0->-1 [5] 1/-1/-1->0->-1 [6] 1/-1/-1->0->-1 [7] 1/-1/-1->0->-1 [8] 1/-1/-1->0->-1 [9] 1/-1/-1->0->-1 [10] 1/-1/-1->0->-1 [11] 1/-1/-1->0->-1 [12] 1/-1/-1->0->-1 [

  13] 1/-1/-1->0->-1 [14] 1/-1/-1->0->-1 [15] 1/-1/-1->0->-1 [16] 1/-1/-1->0->-1 [17] 1/-1/-1->0->-1 [18] 1/-1/-1->0->-1 [19] 1/-1/-1->0->-1 [20] 1/-1/-1->0->-1 [21] 1/-1/-1->0->-1 [22] 1/-1/-1->0->-1 [23] 1/-1/-1->0->-1
deepseek-v2-5-0:5969:5969 [0] NCCL INFO P2P Chunksize set to 524288
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 00/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 01/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 02/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 03/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 04/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 05/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 06/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 07/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 08/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 09/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 10/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 11/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 12/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 13/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 14/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 15/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 16/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 17/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 18/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 19/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 20/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 21/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 22/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 23/0 : 0[0] -> 1[1] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO NCCL_IB_DISABLE set by environment to 0.
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB [1]mlx5_1:1/IB [2]mlx5_2:1/IB [3]mlx5_3:1/IB [4]mlx5_4:1/IB [5]mlx5_5:1/IB [6]mlx5_6:1/IB [7]mlx5_7:1/IB [RO]; OOB eth0:10.244.1.107<0>
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Using non-device net plugin version 0
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Using network IB
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO DMA-BUF is available on GPU device 1
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO ncclCommInitRank comm 0xe79fb10 rank 1 nranks 8 cudaDev 1 nvmlDev 1 busId 200000 commId 0xc9d8ed7b94ebce1c - Init START
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO NCCL_CUMEM_ENABLE set by environment to 0.
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Setting affinity for GPU 1 to ffff,ff000000
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO NVLS multicast support is not available on dev 1
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO comm 0xe79fb10 rank 1 nRanks 8 nNodes 1 localRanks 8 localRank 1 MNNVL 0
(
  RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Trees [0] 2/-1/-1->1->0 [1] 2/-1/-1->1->0 [2] 2/-1/-1->1->0 [3] 2/-1/-1->1->0 [4] 2/-1/-1->1->0 [5] 2/-1/-1->1->0 [6] 2/-1/-1->1->0 [7] 2/-1/-1->1->0 [8] 2/-1/-1->1->0 [9] 2/-1/-1->1->0 [10] 2/-1/-1->1->0 [11] 2/-1/-1->1->0 [12] 2/-1/-1->1->0 [13] 2/-1/-1->1->0 [14] 2/-1/-1->1->0 [15] 2/-1/-1->1->0 [16] 2/-1/-1->1->0 [17] 2/-1/-1->1->0 [18] 2/-1/-1->1->0 [19] 2/-1/-1->1->0 [20] 2/-1/-1->1->0 [21] 2/-1/-1->1->0 [22] 2/-1/-1->1->0 [23] 2/-1/-1->1->0
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO P2P Chunksize set to 524288
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 00/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 01/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 02/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 03/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 04/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 05/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 06/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 07/0 : 1[1] -> 2[2] via P2P/IPC/read


(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 08/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 09/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 10/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 11/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 12/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 13/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 14/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 15/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 16/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 17/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 18/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 19/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 20/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 21/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 22/0 : 1[1] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 23/0 : 1[1] -
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 00/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 01/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 02/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 03/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 04/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 05/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 06/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 07/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 08/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 09/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 10/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 11/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 12/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 13/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 14/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 15/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 16/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 17/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 18/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 19/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 20/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 21/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 22/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 23/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepse
(RayWorkerWrapper pid=628, ip=10.244.1.107) deepseek-v2-5-0-1:628:628 [2] NCCL INFO Setting affinity for GPU 2 to ffffff
(RayWorkerWrapper pid=628, ip=10.244.1.107) deepseek-v2-5-0-1:628:628 [2] NCCL INFO Channel 23/0 : 2[2] -> 3[3
(RayWorkerWrapper pid=630, ip=10.244.1.107) deepseek-v2-5-0-1:630:630 [4] NCCL INFO Channe
(RayWorkerWrapper pid=633, ip=10.244.1.107) deepseek-v2-5-0-1:633:633 [7
(RayWorkerWrapper pid=632, ip=10.244.1.107) deepseek-v2-5-0-1:632:632 [6] NCCL INFO Channel 23/0
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Connected all rings
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO Connect
(RayWorkerWrapper pid=661) deepseek-v2-5-0:661:661 [2] NCCL INFO Connected all rings
(RayWorkerWrapper pid=661) deepsee
(RayWorkerWrapper pid=658) deepseek-v2-5-0:658:658 [7]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO Connected all
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Connected all trees
deepseek-v2-5-0:5969:5969 [0] NCCL INFO threadThresholds 8/8/64 | 64/8/64 | 512 | 512
deepseek-v2-5-0:5969:5969 [0] NCCL INFO 24 coll channels, 24 collnet channels, 0 nvls channels, 32 p2p channels, 32 p2p channels per peer
deepseek-v2-5-0:5969:5969 [0] NCCL INFO TUNER/Plugin: Plugin load returned 2 : libnccl-net.so: cannot open shared object file: No such file or directory : when loading libnccl-tuner.so
deepseek-v2-5-0:5969:5969 [0] NCCL INFO TUNER/Plugin: Using internal tuner plugin.
deepseek-v2-5-0:5969:5969 [0] NCCL INFO ncclCommInitRank comm 0x4b8e2080 rank 0 nranks 8 cudaDev 0 nvmlDev 0 busId 100000 commId 0xc13f651b1c793497 - Init COMPLETE
INFO 04-20 16:47:24 [custom_all_reduce_utils.py:206] generating GPU P2P access cache in /root/.cache/vllm/gpu_p2p_access_cache_for_0,1,2,3,4,5,6,7.json
(RayWorkerWrapper pid=626, ip=10.244.1.107) INFO 04-20 16:47:24 [custom_all_reduce_utils.py:206] generating GPU P2P access cache in /root/.cache/vllm/gpu_p2p_access_cache_for_0,1,2,3,4,5,6,7.json
INFO 04-20 16:48:04 [custom_all_reduce_utils.py:244] reading GPU P2P access cache from /root/.cache/vllm/gpu_p2p_access_cache_for_0,1,2,3,4,5,6,7.json
(RayWorkerWrapper pid=627, ip=10.244.1.107) INFO 04-20 16:48:04 [custom_all_reduce_utils.py:244] reading GPU P2P access cache from /root/.cache/vllm/gpu_p2p_access_cache_for_0,1,2,3,4,5,6,7.json
(RayWorkerWrapper pid=631, ip=10.244.1.107) INFO 04-20 16:47:23 [utils.py:990] Found nccl from library libnccl.so.2 [repeated 14x across cluster]
(RayWorkerWrapper pid=631, ip=10.244.1.107) INFO 04-20 16:47:23 [pynccl.py:69] vLLM is using nccl==2.21.5 [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO Bootstrap : Using eth0:10.244.2.62<0> [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO NET/Plugin: No plugin found (libnccl-net.so) [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO NET/Plugin: Plugin load returned 2 : libnccl-net.so: cannot open shared object file: No such file or directory : when loading libnccl-net.so [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO NET/Plugin: Using internal network plugin. [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO cudaDriverVersion 12080 [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO NCCL_IB_DISABLE set by environment to 0. [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB [1]mlx5_1:1/IB [2]mlx5_2:1/IB [3]mlx5_3:1/IB [4]mlx5_4:1/IB [5]mlx5_5:1/IB [6]mlx5_6:1/IB [7]mlx5_7:1/IB [RO]; OOB eth0:10.244.2.62<0> [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO Using non-device net plugin version 0 [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO Using network IB [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO DMA-BUF is available on GPU device 6 [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO ncclCommInitRank comm 0x339e6bd0 rank 6 nranks 8 cudaDev 6 nvmlDev 6 busId d00000 commId 0xc13f651b1c793497 - Init START [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO NCCL_CUMEM_ENABLE set by environment to 0. [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO Setting affinity for GPU 6 to ff,ffff0000,00000000 [repeated 10x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO NVLS multicast support is not available on dev 6 [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO comm 0x339e6bd0 rank 6 nRanks 8 nNodes 1 localRanks 8 localRank 6 MNNVL 0 [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO Trees [0] 7/-1/-1->6->5 [1] 7/-1/-1->6->5 [2] 7/-1/-1->6->5 [3] 7/-1/-1->6->5 [4] 7/-1/-1->6->5 [5] 7/-1/-1->6->5 [6] 7/-1/-1->6->5 [7] 7/-1/-1->6->5 [8] 7/-1/-1->6->5 [9] 7/-1/-1->6->5 [10] 7/-1/-1->6->5 [11] 7/-1/-1->6->5 [12] 7/-1/-1->6->5 [13] 7/-1/-1->6->5 [14] 7/-1/-1->6->5 [15] 7/-1/-1->6->5 [16] 7/-1/-1->6->5 [17] 7/-1/-1->6->5 [18] 7/-1/-1->6->5 [19] 7/-1/-1->6->5 [20] 7/-1/-1->6->5 [21] 7/-1/-1->6->5 [22] 7/-1/-1->6->5 [23] 7/-1/-1->6->5 [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO P2P Chunksize set to 524288 [repeated 14x across cluster]
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:660 [6] NCCL INFO Channel 23/0 : 6[6] -> 7[7] via P2P/IPC/read [repeated 310x across cluster]
(RayWorkerWrapper pid=670) deepseek-v2-5-0:670:670 [3] NCCL INFO Setting affinity for GPU 3 to ffffff [repeated 3x across cluster]
(RayWorkerWrapper pid=629, ip=10.244.1.107) deepseek-v2-5-0-1:629:629 [3] NCCL INFO Channel 23/0 : 3[3] -> 4[4
(RayWorkerWrapper pid=631, ip=10.244.1.107) deepseek-v2-5-0-1:631:631 [5] NCCL INFO Channe
(RayWorkerWrapper pid=673) deepseek-v2-5-0:673:673 [5] NCCL INFO Connect
(RayWorkerWrapper pid=659) deepseek-v2-5-0:659:659 [1] NCCL INFO Connected all rings [repeated 2x across cluster]
(RayWorkerWrapper pid=670) deepsee
INFO 04-20 16:48:04 [shm_broadcast.py:264] vLLM message queue communication handle: Handle(local_reader_ranks=[1, 2, 3, 4, 5, 6, 7], buffer_handle=(7, 4194304, 6, 'psm_233f75f2'), local_subscribe_addr='ipc:///tmp/e1aa2924-f123-4851-b7f6-810fedea91f6', remote_subscribe_addr=None, remote_addr_ipv6=False)
INFO 04-20 16:48:04 [utils.py:990] Found nccl from library libnccl.so.2
INFO 04-20 16:48:04 [pynccl.py:69] vLLM is using nccl==2.21.5
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Using non-device net plugin version 0
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Using network IB
deepseek-v2-5-0:5969:5969 [0] NCCL INFO DMA-BUF is available on GPU device 0
(RayWorkerWrapper pid=663) ed all rings
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO Connected all trees
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO threadThresholds 8/8/64 | 64/8/64 | 512 | 512
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO 24 coll channels, 24 collnet channels, 0 nvls channels, 32 p2p channels, 32 p2p channels per peer
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO TUNER/Plugin: Plugin load returned 2 : libnccl-net.so: cannot open shared object file: No such file or directory : when loading libnccl-tuner.so
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO TUNER/Plugin: Using internal tuner plugin.
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO ncclCommInitRank comm 0x33fcce20 rank 4 nranks 8 cudaDev 4 nvmlDev 4 busId b00000 commId 0xc13f651b1c793497 - Init COMPLETE
(RayWorkerWrapper pid=663) NCCL version 2.21.5+cuda12.4
(RayWorkerWrapper pid=660)  rings
deepseek-v2-5-0:5969:5969 [0] NCCL INFO ncclCommInitRank comm 0x524462e0 rank 0 nranks 2 cudaDev 0 nvmlDev 0 busId 100000 commId 0x9bdf58487a45133a - Init START
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Setting affinity for GPU 0 to ffff,ff000000
deepseek-v2-5-0:5969:5969 [0] NCCL INFO comm 0x524462e0 rank 0 nRanks 2 nNodes 2 localRanks 1 localRank 0 MNNVL 0
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 00/02 :    0   1
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 01/02 :    0   1
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Trees [0] 1/-1/-1->0->-1 [1] -1/-1/-1->0->1
deepseek-v2-5-0:5969:5969 [0] NCCL INFO P2P Chunksize set to 131072
deepseek-v2-5-0:5969:5969 [0] NCCL INFO NCCL_NET_GDR_LEVEL set by environment to SYS
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 00/0 : 1[0] -> 0[0] [receive] via NET/IB/0/GDRDMA
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 01/0 : 1[0] -> 0[0] [receive] via NET/IB/0/GDRDMA
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 00/0 : 0[0] -> 1[0] [send] via NET/IB/0/GDRDMA
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Channel 01/0 : 0[0] -> 1[0] [send] via NET/IB/0/GDRDMA
(RayWorkerWrapper pid=627, ip=10.244.1.107) > 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO NCCL_NET_GDR_LEVEL set by environment to SYS
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 00/0 : 0[1] -> 1[1] [receive] via NET/IB/1/GDRDMA
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 01/0 : 0[1] -> 1[1] [receive] via NET/IB/1/GDRDMA
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 00/0 : 1[1] -> 0[1] [send] via NET/IB/1/GDRDMA
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO Channel 01/0 : 1[1] -> 0[1] [send] via NET/IB/1/GDRDMA
(RayWorkerWrapper pid=627, ip=10.244.1.107) dee
(RayWorkerWrapper pid=626, ip=10.244.1.107) INFO 04-20 16:48:04 [shm_broadcast.py:264] vLLM message queue communication handle: Handle(local_reader_ranks=[1, 2, 3, 4, 5, 6, 7], buffer_handle=(7, 4194304, 6, 'psm_c0252c1d'), local_subscribe_addr='ipc:///tmp/2378f560-c31e-4dce-ade5-f96a0aa76348', remote_subscribe_addr=None, remote_addr_ipv6=False)
(RayWorkerWrapper pid=628, ip=10.244.1.107) ] via P2P/IPC/read
(RayWorkerWrapper pid=628, ip=10.244.1.107) deepseek-v2-5-
(RayWorkerWrapper pid=629, ip=10.244.1.107) deepseek-v2-5-
(RayWorkerWrapper pid=630, ip=10.244.1.107) l 23/0 : 4[4] -> 5[5] via P2P/IPC/read
(RayWorkerWrapper pid=630, ip=10.244.1.107) deepseek-v2-5-0-1:630:630 [4] NCCL
(RayWorkerWrapper pid=633, ip=10.244.1.107) ] NCCL INFO Channel 23/0 : 7[7] -> 0[0] via P2P/IPC/read
(RayWorkerWrapper pid=633, ip=10.244.1.107) deepseek-v2-5-0-1:633:INFO 04-20 16:48:04 [parallel_state.py:957] rank 15 in world size 16 is assigned as DP rank 0, PP rank 1, TP rank 7
(RayWorkerWrapper pid=632, ip=10.244.1.107)  : 6[6] -> 7[7] via P2P/IPC/read
(RayWorkerWrapper pid=632, ip=10.244.1.107) deepseek-v2-5-0-1:632:632 [6] NCCL INFO Connect
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Connected all rings
deepseek-v2-5-0:5969:5969 [0] NCCL INFO Connected all trees
deepseek-v2-5-0:5969:5969 [0] NCCL INFO threadThresholds 8/8/64 | 16/8/64 | 512 | 512
deepseek-v2-5-0:5969:5969 [0] NCCL INFO 2 coll channels, 2 collnet channels, 0 nvls channels, 2 p2p channels, 2 p2p channels per peer
deepseek-v2-5-0:5969:5969 [0] NCCL INFO ncclCommInitRank comm 0x524462e0 rank 0 nranks 2 cudaDev 0 nvmlDev 0 busId 100000 commId 0x9bdf58487a45133a - Init COMPLETE
INFO 04-20 16:48:04 [parallel_state.py:957] rank 0 in world size 16 is assigned as DP rank 0, PP rank 0, TP rank 0
INFO 04-20 16:48:04 [model_runner.py:1110] Starting to load model deepseek-ai/DeepSeek-V2.5...
(RayWorkerWrapper pid=663) INFO 04-20 16:48:04 [parallel_state.py:957] rank 4 in world size 16 is assigned as DP rank 0, PP rank 0, TP rank 4
(RayWorkerWrapper pid=663) INFO 04-20 16:48:04 [model_runner.py:1110] Starting to load model deepseek-ai/DeepSeek-V2.5...
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO ncclCommInitRank comm 0x3fc66150 rank 1 nranks 2 cudINFO 04-20 16:48:04 [parallel_state.py:957] rank 8 in world size 16 is assigned as DP rank 0, PP rank 1, TP rank 0
INFO 04-20 16:48:05 [weight_utils.py:265] Using model weights format ['*.safetensors']
(RayWorkerWrapper pid=661) INFO 04-20 16:48:05 [weight_utils.py:265] Using model weights format ['*.safetensors']
model-00001-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.59G/8.59G [00:13<00:00, 632MB/s]
model-00002-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:09<00:00, 864MB/s]
model-00003-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 738MB/s]
model-00004-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:14<00:00, 609MB/s]
model-00005-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.59G/8.59G [00:13<00:00, 645MB/s]
model-00006-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:13<00:00, 622MB/s]
model-00007-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:15<00:00, 539MB/s]
model-00008-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:15<00:00, 552MB/s]
model-00009-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 694MB/s]
model-00010-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 734MB/s]
model-00011-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 738MB/s]
model-00012-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:13<00:00, 632MB/s]
model-00013-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 768MB/s]
model-00014-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 718MB/s]
model-00015-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 720MB/s]
model-00016-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 702MB/s]
model-00017-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.59G/8.59G [00:11<00:00, 728MB/s]
model-00018-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 737MB/s]
model-00019-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 690MB/s]
model-00020-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:14<00:00, 582MB/s]
model-00021-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:15<00:00, 555MB/s]
model-00022-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 710MB/s]
model-00023-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 741MB/s]
model-00024-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 712MB/s]
model-00025-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:13<00:00, 647MB/s]
model-00026-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:10<00:00, 822MB/s]
model-00027-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 699MB/s]
model-00028-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 667MB/s]
model-00029-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.59G/8.59G [00:12<00:00, 709MB/s]
model-00030-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 781MB/s]
model-00031-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 747MB/s]
model-00032-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 715MB/s]
model-00033-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 687MB/s]
model-00034-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:10<00:00, 786MB/s]
model-00035-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 771MB/s]
model-00036-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 743MB/s]
model-00037-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 699MB/s]
model-00038-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 701MB/s]
model-00039-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 723MB/s]
model-00040-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 745MB/s]
model-00041-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.59G/8.59G [00:11<00:00, 719MB/s]
model-00042-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 709MB/s]
model-00043-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 711MB/s]
model-00044-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 666MB/s]
model-00045-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 746MB/s]
model-00046-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 720MB/s]
model-00047-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 692MB/s]
model-00048-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:10<00:00, 857MB/s]
model-00049-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 779MB/s]
model-00050-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 717MB/s]
model-00051-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 674MB/s]
model-00052-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:12<00:00, 685MB/s]
model-00053-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.61G/8.61G [00:12<00:00, 685MB/s]
model-00054-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 8.60G/8.60G [00:11<00:00, 781MB/s]
model-00055-of-000055.safetensors: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▉| 6.89G/6.89G [00:10<00:00, 671MB/s]
INFO 04-20 16:59:28 [weight_utils.py:281] Time spent downloading weights for deepseek-ai/DeepSeek-V2.5: 683.050328 seconds
model.safetensors.index.json: 100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 2.66M/2.66M [00:00<00:00, 46.6MB/s]
Loading safetensors checkpoint shards:   0% Completed | 0/55 [00:00<?, ?it/s]
(RayWorkerWrapper pid=633, ip=10.244.1.107) INFO 04-20 16:59:28 [weight_utils.py:281] Time spent downloading weights for deepseek-ai/DeepSeek-V2.5: 683.173844 seconds
(RayWorkerWrapper pid=660) INFO 04-20 16:48:04 [custom_all_reduce_utils.py:244] reading GPU P2P access cache from /root/.cache/vllm/gpu_p2p_access_cache_for_0,1,2,3,4,5,6,7.json [repeated 14x across cluster]
(RayWorkerWrapper pid=631, ip=10.244.1.107) INFO 04-20 16:48:04 [utils.py:990] Found nccl from library libnccl.so.2 [repeated 15x across cluster]
(RayWorkerWrapper pid=631, ip=10.244.1.107) INFO 04-20 16:48:04 [pynccl.py:69] vLLM is using nccl==2.21.5 [repeated 15x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Using non-device net plugin version 0 [repeated 8x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Using network IB [repeated 8x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO DMA-BUF is available on GPU device 0 [repeated 8x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO ncclCommInitRank comm 0x3fc66150 rank 1 nranks 2 cudaDev 0 nvmlDev 0 busId 100000 commId 0x9bdf58487a45133a - Init START [repeated 8x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Setting affinity for GPU 0 to ffff,ff000000 [repeated 6x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO comm 0x3fc66150 rank 1 nRanks 2 nNodes 2 localRanks 1 localRank 0 MNNVL 0 [repeated 8x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Trees [0] -1/-1/-1->1->0 [1] 0/-1/-1->1->-1 [repeated 8x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO P2P Chunksize set to 131072 [repeated 8x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 23/0 : 0[0] -> 1[1] via P2P/IPC/read [repeated 356x across cluster]
(RayWorkerWrapper pid=629, ip=10.244.1.107) deepseek-v2-5-0-1:629:629 [3] NCCL INFO Setting affinity for GPU 3 to ffffff [repeated 2x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Connected all rings [repeated 13x across cluster]
(RayWorkerWrapper pid=673) ed all rings
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Connected all trees [repeated 15x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO threadThresholds 8/8/64 | 16/8/64 | 512 | 512 [repeated 15x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO 2 coll channels, 2 collnet channels, 0 nvls channels, 2 p2p channels, 2 p2p channels per peer [repeated 15x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO TUNER/Plugin: Plugin load returned 2 : libnccl-net.so: cannot open shared object file: No such file or directory : when loading libnccl-tuner.so [repeated 14x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO TUNER/Plugin: Using internal tuner plugin. [repeated 14x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO ncclCommInitRank comm 0x3b28a5d0 rank 0 nranks 8 cudaDev 0 nvmlDev 0 busId 100000 commId 0xc9d8ed7b94ebce1c - Init COMPLETE [repeated 14x across cluster]
(RayWorkerWrapper pid=660) NCCL version 2.21.5+cuda12.4 [repeated 6x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO NCCL_NET_GDR_LEVEL set by environment to SYS [repeated 7x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 01/0 : 0[0] -> 1[0] [receive] via NET/IB/0/GDRDMA [repeated 14x across cluster]
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Channel 01/0 : 1[0] -> 0[0] [send] via NET/IB/0/GDRDMA [repeated 14x across cluster]
(RayWorkerWrapper pid=629, ip=10.244.1.107) ] via P2P/IPC/read
(RayWorkerWrapper pid=631, ip=10.244.1.107) l 23/0 : 5[5] -> 6[6] via P2P/IPC/read
(RayWorkerWrapper pid=631, ip=10.244.1.107) deepseek-v2-5-0-1:631:631 [5] NCCL
(RayWorkerWrapper pid=631, ip=10.244.1.107) INFO 04-20 16:48:04 [parallel_state.py:957] rank 13 in world size 16 is assigned as DP rank 0, PP rank 1, TP rank 5 [repeated 12x across cluster]
(RayWorkerWrapper pid=631, ip=10.244.1.107) INFO 04-20 16:48:04 [model_runner.py:1110] Starting to load model deepseek-ai/DeepSeek-V2.5... [repeated 14x across cluster]
(RayWorkerWrapper pid=670) INFO 04-20 16:48:05 [weight_utils.py:265] Using model weights format ['*.safetensors'] [repeated 14x across cluster]
Loading safetensors checkpoint shards:   2% Completed | 1/55 [00:02<02:03,  2.29s/it]
Loading safetensors checkpoint shards:   4% Completed | 2/55 [00:02<00:55,  1.04s/it]
Loading safetensors checkpoint shards:   5% Completed | 3/55 [00:06<02:07,  2.45s/it]
Loading safetensors checkpoint shards:   7% Completed | 4/55 [00:06<01:20,  1.58s/it]
Loading safetensors checkpoint shards:  13% Completed | 7/55 [00:06<00:29,  1.64it/s]
Loading safetensors checkpoint shards:  18% Completed | 10/55 [00:11<00:44,  1.02it/s]
Loading safetensors checkpoint shards:  20% Completed | 11/55 [00:15<01:09,  1.59s/it]
Loading safetensors checkpoint shards:  22% Completed | 12/55 [00:15<00:56,  1.30s/it]
Loading safetensors checkpoint shards:  25% Completed | 14/55 [00:19<01:05,  1.59s/it]
Loading safetensors checkpoint shards:  27% Completed | 15/55 [00:19<00:52,  1.30s/it]
(RayWorkerWrapper pid=633, ip=10.244.1.107) INFO 04-20 16:59:48 [loader.py:447] Loading weights took 20.07 seconds
(RayWorkerWrapper pid=633, ip=10.244.1.107) INFO 04-20 16:59:48 [model_runner.py:1146] Model loading took 28.4772 GiB and 704.046883 seconds
Loading safetensors checkpoint shards:  29% Completed | 16/55 [00:24<01:15,  1.94s/it]
Loading safetensors checkpoint shards:  31% Completed | 17/55 [00:24<00:57,  1.52s/it]
Loading safetensors checkpoint shards:  33% Completed | 18/55 [00:28<01:21,  2.19s/it]
Loading safetensors checkpoint shards:  35% Completed | 19/55 [00:32<01:39,  2.76s/it]
(RayWorkerWrapper pid=663) INFO 04-20 17:00:04 [loader.py:447] Loading weights took 34.97 seconds [repeated 2x across cluster]
(RayWorkerWrapper pid=673) INFO 04-20 16:59:49 [model_runner.py:1146] Model loading took 27.6330 GiB and 704.227824 seconds
(RayWorkerWrapper pid=661) INFO 04-20 17:00:04 [model_runner.py:1146] Model loading took 27.6330 GiB and 719.632403 seconds
Loading safetensors checkpoint shards:  36% Completed | 20/55 [00:36<01:49,  3.13s/it]
Loading safetensors checkpoint shards:  38% Completed | 21/55 [00:36<01:18,  2.30s/it]
Loading safetensors checkpoint shards:  40% Completed | 22/55 [00:38<01:07,  2.06s/it]
Loading safetensors checkpoint shards:  42% Completed | 23/55 [00:40<01:03,  1.99s/it]
Loading safetensors checkpoint shards:  44% Completed | 24/55 [00:43<01:16,  2.48s/it]
Loading safetensors checkpoint shards:  45% Completed | 25/55 [00:44<00:54,  1.81s/it]
Loading safetensors checkpoint shards:  47% Completed | 26/55 [00:46<00:53,  1.84s/it]
Loading safetensors checkpoint shards:  49% Completed | 27/55 [00:46<00:43,  1.57s/it]
Loading safetensors checkpoint shards:  51% Completed | 28/55 [00:47<00:37,  1.39s/it]
Loading safetensors checkpoint shards:  53% Completed | 29/55 [00:50<00:46,  1.78s/it]
Loading safetensors checkpoint shards:  55% Completed | 30/55 [00:50<00:32,  1.32s/it]
Loading safetensors checkpoint shards:  60% Completed | 33/55 [00:50<00:13,  1.67it/s]
Loading safetensors checkpoint shards:  64% Completed | 35/55 [00:53<00:15,  1.30it/s]
Loading safetensors checkpoint shards:  65% Completed | 36/55 [00:56<00:26,  1.38s/it]
Loading safetensors checkpoint shards:  67% Completed | 37/55 [00:57<00:20,  1.13s/it]
Loading safetensors checkpoint shards:  69% Completed | 38/55 [01:00<00:28,  1.70s/it]
Loading safetensors checkpoint shards:  71% Completed | 39/55 [01:00<00:21,  1.33s/it]
Loading safetensors checkpoint shards:  75% Completed | 41/55 [01:01<00:11,  1.17it/s]
Loading safetensors checkpoint shards:  76% Completed | 42/55 [01:01<00:09,  1.31it/s]
Loading safetensors checkpoint shards:  78% Completed | 43/55 [01:02<00:09,  1.27it/s]
Loading safetensors checkpoint shards:  80% Completed | 44/55 [01:06<00:18,  1.66s/it]
Loading safetensors checkpoint shards:  82% Completed | 45/55 [01:09<00:20,  2.03s/it]
Loading safetensors checkpoint shards:  84% Completed | 46/55 [01:13<00:23,  2.57s/it]
Loading safetensors checkpoint shards:  85% Completed | 47/55 [01:14<00:16,  2.02s/it]
Loading safetensors checkpoint shards:  91% Completed | 50/55 [01:14<00:04,  1.07it/s]
Loading safetensors checkpoint shards:  96% Completed | 53/55 [01:17<00:01,  1.02it/s]
Loading safetensors checkpoint shards:  98% Completed | 54/55 [01:19<00:01,  1.05s/it]
Loading safetensors checkpoint shards: 100% Completed | 55/55 [01:19<00:00,  1.14it/s]

Loading safetensors checkpoint shards: 100% Completed | 55/55 [01:19<00:00,  1.44s/it]

INFO 04-20 17:00:47 [loader.py:447] Loading weights took 79.31 seconds
INFO 04-20 17:00:47 [model_runner.py:1146] Model loading took 27.6330 GiB and 763.166885 seconds
(RayWorkerWrapper pid=627, ip=10.244.1.107) WARNING 04-20 17:00:54 [fused_moe.py:659] Using default MoE config. Performance might be sub-optimal! Config file not found at /usr/local/lib/python3.12/dist-packages/vllm/model_executor/layers/fused_moe/configs/E=160,N=192,device_name=NVIDIA_A100-SXM4-40GB.json
(RayWorkerWrapper pid=631, ip=10.244.1.107) INFO 04-20 17:00:08 [loader.py:447] Loading weights took 38.84 seconds [repeated 12x across cluster]
(RayWorkerWrapper pid=629, ip=10.244.1.107) INFO 04-20 17:00:08 [model_runner.py:1146] Model loading took 28.4772 GiB and 723.639309 seconds [repeated 12x across cluster]
WARNING 04-20 17:00:54 [fused_moe.py:659] Using default MoE config. Performance might be sub-optimal! Config file not found at /usr/local/lib/python3.12/dist-packages/vllm/model_executor/layers/fused_moe/configs/E=160,N=192,device_name=NVIDIA_A100-SXM4-40GB.json
(RayWorkerWrapper pid=626, ip=10.244.1.107) aDev 0 nvmlDev 0 busId 100000 commId 0x9bdf58487a45133a - Init COMPLETE
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:626 [0] NCCL INFO Comm config Blocking set to 1

(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Using non-device net plugin version 0
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Using network IB
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO DMA-BUF is available on GPU device 0
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO ncclCommInitRank comm 0x61f44bf0 rank 0 nranks 8 cudaDev 0 nvmlDev 0 busId 100000 commId 0x91a762ddf9b5c019 - Init START
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Setting affinity for GPU 0 to ffff,ff000000
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO NVLS multicast support is not available on dev 0
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO comm 0x61f44bf0 rank 0 nRanks 8 nNodes 1 localRanks 8 localRank 0 MNNVL 0
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 00/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 01/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 02/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 03/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 04/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 05/24 :    0   1   2   3   4   5   6   7

(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 06/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 07/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 08/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 09/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 10/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 11/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 12/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 13/24 :    0   1   2   3   4   5   6   7

(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 14/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 15/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 16/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 17/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 18/24 :    0   1   2   3   4   5   6   7

(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 19/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 20/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 21/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 22/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 23/24 :    0   1   2   3   4   5   6   7
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Trees [0] 1/-1/-1->0->-1 [1] 1/-1/-1->0->-1 [2] 1/-1/-1->0->-1 [3] 1/-1/-1->0->-1 [4] 1/-1/-1->0->-1 [5] 1/-1/-1->0->-1 [6] 1/-1/-1->0->-1 [7] 1/-1/-1->0->-1 [8] 1/-1/-1->0->-1 [9] 1/-1/-1->0->-1 [10] 1/-1/-1->0->-1 [11] 1/-1/-1->0->-1 [12] 1/-1/-1->0->-1 [13] 1/-1/-1->0->-1 [14] 1/-1/-1->0->-1 [15] 1/-1/-1->0->-1 [16] 1/-1/-1->0->-1 [17] 1/-1/-1->0->-1 [18] 1/-1/-1->0->-1 [19] 1/-1/-1->0->-1 [20] 1/-1/-1->0->-1 [21] 1/-1/-1->0->-1 [22] 1/-1/-1->0->-1 [23] 1/-1/-1->0->-1
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO P2P Chunksize set to 524288
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 00/0 : 0[0] -> 1[1] via P2P/IPC/read
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 01/0 : 0[0] -> 1[1] via P2P/IPC/read
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 02/0 : 0[0] -> 1[1] via P2P/IPC/read
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 03/0 : 0[0] -> 1[1] via P2P/IPC/read
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 04/0 : 0[0] -> 1[1] via P2P/IPC/read
(RayWorkerWrapper pid=626, ip=10.244.1.107) deepseek-v2-5-0-1:626:15081 [0] NCCL INFO Channel 05/0 : 0[0] -> 1[1] via
(RayWorkerWrapper pid=627, ip=10.244.1.107) pseek-v2-5-0-1:627:627 [1] NCCL INFO Connected all trees
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO threadThresholds 8/8/64 | 16/8/64 | 512 | 512
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO 2 coll channels, 2 collnet channels, 0 nvls channels, 2 p2p channels, 2 p2p channels per peer
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:627 [1] NCCL INFO ncclCommInitRank comm 0x13184050 rank 1 nranks 2 cudaDev 1 nvmlDev 1 busId 200000 commId 0xeb2017ca963a5ff3 - Init COMPLETE
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepsee
(RayWorkerWrapper pid=628, ip=10.244.1.107) deepseek-v2-5-0-1:628:15084 [2] NCCL INFO Setting affinity for GPU 2 to ffffff
(RayWorkerWrapper pid=628, ip=10.244.1.107) deepseek-v2-5-0-1:628:15084 [2] NCCL INFO Connected all rings
(RayWorkerWrapper pid=628, ip=10.244.1.107) deepseek-v2-5-0-1:628:15084 [2] NCCL INFO
(RayWorkerWrapper pid=630, ip=10.244.1.107)  INFO Connected all rings
(RayWorkerWrapper pid=630, ip=10.244.1.107) deepseek-v2-5-0-1:630:15087 [4] NCCL INFO Channel 01/0 : 4[4] -> 3[3

(RayWorkerWrapper pid=633, ip=10.244.1.107) deepseek-v2-5-0-1:633:15086 [7] NCCL I
(RayWorkerWrapper pid=632, ip=10.244.1.107) ed all rings
(RayWorkerWrapper pid=632, ip=10.244.1.107) d
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-v2-5-0-1:627:1
(RayWorkerWrapper pid=627, ip=10.244.1.107) deepseek-
(RayWorkerWrapper pid=628, ip=10.244.1.107)  Channel 02/0 : 2[2] -> 1[1] via P2P/IPC/read
(RayWorkerWrapper pid=628, ip=10.244.1.107) deepseek-v2-5-0-1:628:15113
(RayWorkerWrapper pid=629, ip=10.244.1.107) deepseek-v2-5-0-1:629:15120

(RayWorkerWrapper pid=630, ip=10.244.1.107) ] via P2P/IPC/read
(RayWorkerWrapper pid=630, ip=10.244.1.107) deepseek-v2-5-0-1:630:15115 [4] NCCL INFO Channel 19/1
(RayWorkerWrapper pid=633, ip=10.244.1.107) NFO Channel 01/0 : 7[7] -> 6[6] via P2P/IPC/read
(RayWorkerWrapper pid=633, ip=10.244.1.107) deepseek-v2-5-0-1:633:15
INFO 04-20 17:00:56 [worker.py:267] Memory profiling takes 8.55 seconds

INFO 04-20 17:00:56 [worker.py:267] the current vLLM instance can use total_gpu_memory (39.49GiB) x gpu_memory_utilization (0.90) = 35.55GiB
INFO 04-20 17:00:56 [worker.py:267] model weights take 27.63GiB; non_torch_memory takes 0.93GiB; PyTorch activation peak memory takes 1.27GiB; the rest of the memory reserved for KV Cache is 5.71GiB.
(RayWorkerWrapper pid=627, ip=10.244.1.107) INFO 04-20 17:00:56 [worker.py:267] Memory profiling takes 8.59 seconds
(RayWorkerWrapper pid=627, ip=10.244.1.107) INFO 04-20 17:00:56 [worker.py:267] the current vLLM instance can use total_gpu_memory (39.49GiB) x gpu_memory_utilization (0.90) = 35.55GiB
(RayWorkerWrapper pid=627, ip=10.244.1.107) INFO 04-20 17:00:56 [worker.py:267] model weights take 28.48GiB; non_torch_memory takes 2.15GiB; PyTorch activation peak memory takes 1.35GiB; the rest of the memory reserved for KV Cache is 3.58GiB.
INFO 04-20 17:00:56 [executor_base.py:112] # cuda blocks: 5302, # CPU blocks: 7767

INFO 04-20 17:00:56 [executor_base.py:117] Maximum concurrency for 8192 tokens per request: 10.36x
INFO 04-20 17:01:03 [llm_engine.py:448] init engine (profile, create kv cache, warmup model) took 15.63 seconds
WARNING 04-20 17:01:03 [config.py:1088] Default sampling parameters have been overridden by the model's Hugging Face generation config recommended from the model creator. If this is not intended, please relaunch vLLM instance with `--generation-config vllm`.
INFO 04-20 17:01:03 [serving_chat.py:117] Using default chat sampling params from model: {'temperature': 0.3, 'top_p': 0.95}

INFO 04-20 17:01:04 [serving_completion.py:61] Using default completion sampling params from model: {'temperature': 0.3, 'top_p': 0.95}
INFO 04-20 17:01:04 [api_server.py:1081] Starting vLLM API server on http://0.0.0.0:8000
INFO 04-20 17:01:04 [launcher.py:26] Available routes are:
INFO 04-20 17:01:04 [launcher.py:34] Route: /openapi.json, Methods: HEAD, GET
INFO 04-20 17:01:04 [launcher.py:34] Route: /docs, Methods: HEAD, GET
INFO 04-20 17:01:04 [launcher.py:34] Route: /docs/oauth2-redirect, Methods: HEAD, GET
INFO 04-20 17:01:04 [launcher.py:34] Route: /redoc, Methods: HEAD, GET

INFO 04-20 17:01:04 [launcher.py:34] Route: /health, Methods: GET
INFO 04-20 17:01:04 [launcher.py:34] Route: /load, Methods: GET
INFO 04-20 17:01:04 [launcher.py:34] Route: /ping, Methods: POST, GET
INFO 04-20 17:01:04 [launcher.py:34] Route: /tokenize, Methods: POST
INFO 04-20 17:01:04 [launcher.py:34] Route: /detokenize, Methods: POST
INFO 04-20 17:01:04 [launcher.py:34] Route: /v1/models, Methods: GET
INFO 04-20 17:01:04 [launcher.py:34] Route: /version, Methods: GET
INFO 04-20 17:01:04 [launcher.py:34] Route: /v1/chat/completions, Methods: POST
INFO 04-20 17:01:04 [launcher.py:34] Route: /v1/completions, Methods: POST
INFO 04-20 17:01:04 [launcher.py:34] Route: /v1/embeddings, Methods: POST
INFO 04-20 17:01:04 [launcher.py:34] Route: /pooling, Methods: POST
INFO 04-20 17:01:04 [launcher.py:34] Route: /score, Methods: POST
INFO 04-20 17:01:04 [launcher.py:34] Route: /v1/score, Methods: POST

INFO 04-20 17:01:04 [launcher.py:34] Route: /v1/audio/transcriptions, Methods: POST
INFO 04-20 17:01:04 [launcher.py:34] Route: /rerank, Methods: POST
INFO 04-20 17:01:04 [launcher.py:34] Route: /v1/rerank, Methods: POST
INFO 04-20 17:01:04 [launcher.py:34] Route: /v2/rerank, Methods: POST
INFO 04-20 17:01:04 [launcher.py:34] Route: /invocations, Methods: POST
INFO:     Started server process [5969]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO 04-20 17:17:47 [chat_utils.py:396] Detected the chat template content format to be 'string'. You can set `--chat-template-content-format` to override this.
INFO 04-20 17:17:47 [logger.py:39] Received request chatcmpl-2f958238775949b7b02fb311fd07b471: prompt: '<｜begin▁of▁sentence｜><｜User｜>Explain the origin of Llama the animal?<｜Assistant｜>', params: SamplingParams(n=1, presence_penalty=0.0, frequency_penalty=0.0, repetition_penalty=1.0, temperature=0.3, top_p=0.95, top_k=-1, min_p=0.0, seed=None, stop=[], stop_token_ids=[], bad_words=[], include_stop_str_in_output=False, ignore_eos=False, max_tokens=8180, min_tokens=0, logprobs=None, prompt_logprobs=None, skip_special_tokens=True, spaces_between_special_tokens=True, truncate_prompt_tokens=None, guided_decoding=None, extra_args=None), prompt_token_ids: None, lora_request: None, prompt_adapter_request: None.
INFO 04-20 17:17:47 [async_llm_engine.py:211] Added request chatcmpl-2f958238775949b7b02fb311fd07b471.
deepseek-v2-5-0:5969:23340 [0] NCCL INFO Comm config Blocking set to 1
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Using non-device net plugin version 0

deepseek-v2-5-0:5969:23342 [0] NCCL INFO Using network IB
deepseek-v2-5-0:5969:23342 [0] NCCL INFO DMA-BUF is available on GPU device 0
deepseek-v2-5-0:5969:23342 [0] NCCL INFO ncclCommInitRank comm 0x7ec4a8014c20 rank 0 nranks 8 cudaDev 0 nvmlDev 0 busId 100000 commId 0xda1101530f2d86b0 - Init START
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Setting affinity for GPU 0 to ffff,ff000000
deepseek-v2-5-0:5969:23342 [0] NCCL INFO NVLS multicast support is not available on dev 0
deepseek-v2-5-0:5969:23342 [0] NCCL INFO comm 0x7ec4a8014c20 rank 0 nRanks 8 nNodes 1 localRanks 8 localRank 0 MNNVL 0
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 00/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 01/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 02/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 03/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 04/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 05/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 06/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 07/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 08/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 09/24 :    0   1   2   3   4   5   6   7

deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 10/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 11/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 12/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 13/24 :    0   1   2   3   4   5   6   7

deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 14/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 15/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 16/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 17/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 18/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 19/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 20/24 :    0   1   2   3   4   5   6   7

deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 21/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 22/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 23/24 :    0   1   2   3   4   5   6   7
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Trees [0] 1/-1/-1->0->-1 [1] 1/-1/-1->0->-1 [2] 1/-1/-1->0->-1 [3] 1/-1/-1->0->-1 [4] 1/-1/-1->0->-1 [5] 1/-1/-1->0->-1 [6] 1/-1/-1->0->-1 [7] 1/-1/-1->0->-1 [8] 1/-1/-1->0->-1 [9] 1/-1/-1->0->-1 [10] 1/-1/-1->0->-1 [11] 1/-1/-1->0->-1 [12] 1/-1/-1->0->-1 [13] 1/-1/-1->0->-1 [14] 1/-1/-1->0->-1 [15] 1/-1/-1->0->-1 [16] 1/-1/-1->0->-1 [17] 1/-1/-1->0->-1 [18] 1/-1/-1->0->-1 [19] 1/-1/-1->0->-1 [20] 1/-1/-1->0->-1 [21] 1/-1/-1->0->-1 [22] 1/-1/-1->0->-1 [23] 1/-1/-1->0->-1

deepseek-v2-5-0:5969:23342 [0] NCCL INFO P2P Chunksize set to 524288
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 00/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 01/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 02/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 03/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 04/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 05/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 06/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 07/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 08/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 09/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 10/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 11/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 12/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 13/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 14/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 15/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 16/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 17/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 18/0 : 0[0] -> 1[1] via P2P/IPC/read

deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 19/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 20/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 21/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 22/0 : 0[0] -> 1[1] via P2P/IPC/read
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Channel 23/0 : 0[0] -> 1[1] via P2P/IPC/read
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO NCCL_NET_GDR_LEVEL set by environment to SYS
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO Channel 00/0 : 1[4] -> 0[4] [receive] via NET/IB/4/GDRDMA
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO Channel 01/0 : 1[4] -> 0[4] [receive] via NET/IB/4/GDRDMA
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO Channel 00/0 : 0[4] -> 1[4] [send] via NET/IB/4/GDRDMA
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO Channel 01/0 : 0[4] -> 1[4] [send] via NET/IB/4/GDRDMA
(RayWorkerWrapper pid=660) WARNING 04-20 17:00:55 [fused_moe.py:659] Using default MoE config. Performance might be sub-optimal! Config file not found at /usr/local/lib/python3.12/dist-packages/vllm/model_executor/layers/fused_moe/configs/E=160,N=192,device_name=NVIDIA_A100-SXM4-40GB.json [repeated 14x across cluster]

 (RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO Comm config Blocking set to 1 [repeated 8x across cluster]
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:23349 [4] NCCL INFO Using non-device net plugin version 0 [repeated 9x across cluster]
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:23349 [4] NCCL INFO Using network IB [repeated 9x across cluster]
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:23349 [4] NCCL INFO DMA-BUF is available on GPU device 4 [repeated 9x across cluster]
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:23349 [4] NCCL INFO ncclCommInitRank comm 0x58281620 rank 4 nranks 8 cudaDev 4 nvmlDev 4 busId b00000 commId 0xda1101530f2d86b0 - Init START [repeated 9x across cluster]
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:23349 [4] NCCL INFO Setting affinity for GPU 4 to ffffff00,00000000,00000000 [repeated 7x across cluster]
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:23349 [4] NCCL INFO NVLS multicast support is not available on dev 4 [repeated 8x across cluster]
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:23349 [4] NCCL INFO comm 0x58281620 rank 4 nRanks 8 nNodes 1 localRanks 8 localRank 4 MNNVL 0 [repeated 9x across cluster]
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:23349 [4] NCCL INFO Channel 11/0 : 4[4] [repeated 3x across cluster]
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:23349 [4] NCCL INFO Trees [0] 5/-1/-1->4->3 [1] 5/-1/-1->4->3 [2] 5/-1/-1->4->3 [3] 5/-1/-1->4->3 [4] 5/-1/-1->4->3 [5] 5/-1/-1->4->3 [6] 5/-1/-1->4->3 [7] 5/-1/-1->4->3 [8] 5/-1/-1->4->3 [9] 5/-1/-1->4->3 [10] 5/-1/-1->4->3 [11] 5/-1/-1->4->3 [12] 5/-1/-1->4->3 [13] 5/-1/-1->4->3 [14] 5/-1/-1->4->3 [15] 5/-1/-1->4->3 [16] 5/-1/-1->4->3 [17] 5/-1/-1->4->3 [18] 5/-1/-1->4->3 [19] 5/-1/-1->4->3 [20] 5/-1/-1->4->3 [21] 5/-1/-1->4->3 [22] 5/-1/-1->4->3 [23] 5/-1/-1->4->3 [repeated 9x across cluster]

(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:23349 [4] NCCL INFO P2P Chunksize set to 524288 [repeated 9x across cluster]
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:23349 [4] NCCL INFO Channel 10/0 : 4[4] -> 5[5] via P2P/IPC/read [repeated 479x across cluster]
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO Connected all trees [repeated 14x across cluster]
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO threadThresholds 8/8/64 | 16/8/64 | 512 | 512 [repeated 14x across cluster]
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO 2 coll channels, 2 collnet channels, 0 nvls channels, 2 p2p channels, 2 p2p channels per peer [repeated 14x across cluster]
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO ncclCommInitRank comm 0x389a1760 rank 0 nranks 2 cudaDev 4 nvmlDev 4 busId b00000 commId 0xd11ca206049505d1 - Init COMPLETE [repeated 14x across cluster]
(RayWorkerWrapper pid=629, ip=10.244.1.107) deepseek-v2-5-0-1:629:15088 [3] NCCL INFO Setting affinity for GPU 3 to ffffff
(RayWorkerWrapper pid=663) deepseek-v2-5-0:663:663 [4] NCCL INFO Connected all rings [repeated 8x across cluster]
(RayWorkerWrapper pid=629, ip=10.244.1.107) deepseek-v2-5-0-1:629:15088 [3] NCCL INFO
(RayWorkerWrapper pid=631, ip=10.244.1.107)  INFO Connected all rings
(RayWorkerWrapper pid=631, ip=10.244.1.107) deepseek-v2-5-0-1:631:15085 [5] NCCL INFO Channel 01/0 : 5[5] -> 4[4
(RayWorkerWrapper pid=629, ip=10.244.1.107)  Channel 02/0 : 3[3] -> 2[2] via P2P/IPC/read
(RayWorkerWrapper pid=631, ip=10.244.1.107) ] via P2P/IPC/read
(RayWorkerWrapper pid=631, ip=10.244.1.107) deepseek-v2-5-0-1:631:15117 [5] NCCL INFO Channel 19/1
(RayWorkerWrapper pid=661) INFO 04-20 17:00:56 [worker.py:267] Memory profiling takes 8.62 seconds [repeated 14x across cluster]
(RayWorkerWrapper pid=661) INFO 04-20 17:00:56 [worker.py:267] the current vLLM instance can use total_gpu_memory (39.49GiB) x gpu_memory_utilization (0.90) = 35.55GiB [repeated 14x across cluster]
(RayWorkerWrapper pid=661) INFO 04-20 17:00:56 [worker.py:267] model weights take 27.63GiB; non_torch_memory takes 1.07GiB; PyTorch activation peak memory takes 1.27GiB; the rest of the memory reserved for KV Cache is 5.57GiB. [repeated 14x across cluster]
(RayWorkerWrapper pid=661) deepseek-v2-5-0:661:661 [2] NCCL INFO Setting affinity for GPU 2 to ffffff
(RayWorkerWrapper pid=661) deepseek-v2-5-0:661:23346 [2] NCCL INFO Setting affinity for GPU 2 to ffffff
(RayWorkerWrapper pid=661) deepseek-v2-5-
(RayWorkerWrapper pid=670) deepseek-v2-5-
(RayWorkerWrapper pid=658) deepseek-v2-5-0:658:23343 [7] NCCL INFO Channel
(RayWorkerWrapper pid=660) deepseek-v2-5-0:660:23348 [6] NCCL INFO Channel 11/0 : 6[6] -> 7[7] via P
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Connected all rings
deepseek-v2-5-0:5969:23342 [0] NCCL INFO Connected all trees
deepseek-v2-5-0:5969:23342 [0] NCCL INFO threadThresholds 8/8/64 | 64/8/64 | 512 | 512
deepseek-v2-5-0:5969:23342 [0] NCCL INFO 24 coll channels, 24 collnet channels, 0 nvls channels, 32 p2p channels, 32 p2p channels per peer
deepseek-v2-5-0:5969:23342 [0] NCCL INFO ncclCommInitRank comm 0x7ec4a8014c20 rank 0 nranks 8 cudaDev 0 nvmlDev 0 busId 100000 commId 0xda1101530f2d86b0 - Init COMPLETE
/usr/local/lib/python3.12/dist-packages/vllm/distributed/parallel_state.py:411: UserWarning: The given buffer is not writable, and PyTorch does not support non-writable tensors. This means you can write to the underlying (supposedly non-writable) buffer using the tensor. You may want to copy the buffer to protect its data or make it writable before converting it to a tensor. This type of warning will be suppressed for the rest of this program. (Triggered internally at /pytorch/torch/csrc/utils/tensor_new.cpp:1561.)
  object_tensor = torch.frombuffer(pickle.dumps(obj), dtype=torch.uint8)
[rank0]:[W420 17:17:49.920912155 ProcessGroupNCCL.cpp:3436] Warning: TORCH_NCCL_AVOID_RECORD_STREAMS=1 has no effect for point-to-point collectives. (function operator())
deepseek-v2-5-0:5969:23340 [0] NCCL INFO Comm config Blocking set to 1
deepseek-v2-5-0:5969:23440 [0] NCCL INFO Using non-device net plugin version 0
deepseek-v2-5-0:5969:23440 [0] NCCL INFO Using network IB
deepseek-v2-5-0:5969:23440 [0] NCCL INFO DMA-BUF is available on GPU device 0
deepseek-v2-5-0:5969:23440 [0] NCCL INFO ncclCommInitRank comm 0x7ec4ab0772a0 rank 0 nranks 2 cudaDev 0 nvmlDev 0 busId 100000 commId 0xf3e517aa6c3e9c19 - Init START
deepseek-v2-5-0:5969:23440 [0] NCCL INFO Setting affinity for GPU 0 to ffff,ff000000
deepseek-v2-5-0:5969:23440 [0] NCCL INFO comm 0x7ec4ab0772a0 rank 0 nRanks 2 nNodes 2 localRanks 1 localRank 0 MNNVL 0
deepseek-v2-5-0:5969:23440 [0] NCCL INFO Channel 00/02 :    0   1
deepseek-v2-5-0:5969:23440 [0] NCCL INFO Channel 01/02 :    0   1
deepseek-v2-5-0:5969:23440 [0] NCCL INFO Trees [0] 1/-1/-1->0->-1 [1] -1/-1/-1->0->1
deepseek-v2-5-0:5969:23440 [0] NCCL INFO P2P Chunksize set to 131072
deepseek-v2-5-0:5969:23440 [0] NCCL INFO Channel 00/0 : 1[0] -> 0[0] [receive] via NET/IB/0/GDRDMA
deepseek-v2-5-0:5969:23440 [0] NCCL INFO Channel 01/0 : 1[0] -> 0[0] [receive] via NET/IB/0/GDRDMA
deepseek-v2-5-0:5969:23440 [0] NCCL INFO Channel 00/0 : 0[0] -> 1[0] [send] via NET/IB/0/GDRDMA
deepseek-v2-5-0:5969:23440 [0] NCCL INFO Channel 01/0 : 0[0] -> 1[0] [send] via NET/IB/0/GDRDMA
(RayWorkerWrapper pid=628, ip=10.244.1.107) [rank10]:[W420 17:17:49.001266022 ProcessGroupNCCL.cpp:3436] Warning: TORCH_NCCL_AVOID_RECORD_STREAMS=1 has no effect for point-to-point collectives. (function operator())
(RayWorkerWrapper pid=626, ip=10.244.1.107)  P2P/IPC/read
(RayWorkerWrapper pid=630, ip=10.244.1.107)  : 4[4] -> 0[0] via P2P/IPC/read
(RayWorkerWrapper pid=632, ip=10.244.1.107) P2P/IPC/read
deepseek-v2-5-0:5969:23440 [0] NCCL INFO Connected all rings
deepseek-v2-5-0:5969:23440 [0] NCCL INFO Connected all trees
deepseek-v2-5-0:5969:23440 [0] NCCL INFO threadThresholds 8/8/64 | 16/8/64 | 512 | 512
deepseek-v2-5-0:5969:23440 [0] NCCL INFO 2 coll channels, 2 collnet channels, 0 nvls channels, 2 p2p channels, 2 p2p channels per peer
(RayWorkerWrapper pid=663)  -> 5[5] via P2P/IPC/read
(RayWorkerWrapper pid=663) /usr/local/lib/python3.12/dist-packages/vllm/distributed/parallel_state.py:411: UserWarning: The given buffer is not writable, and PyTorch does not support non-writable tensors. This means you can write to the underlying (supposedly non-writable) buffer using the tensor. You may want to copy the buffer to protect its data or make it writable before converting it to a tensor. This type of warning will be suppressed for the rest of this program. (Triggered internally at /pytorch/torch/csrc/utils/tensor_new.cpp:1561.)
(RayWorkerWrapper pid=663)   object_tensor = torch.frombuffer(pickle.dumps(obj), dtype=torch.uint8)
(RayWorkerWrapper pid=660) 2P/IPC/read
deepseek-v2-5-0:5969:23440 [0] NCCL INFO ncclCommInitRank comm 0x7ec4ab0772a0 rank 0 nranks 2 cudaDev 0 nvmlDev 0 busId 100000 commId 0xf3e517aa6c3e9c19 - Init COMPLETE
deepseek-v2-5-0:5969:23467 [0] NCCL INFO Channel 00/1 : 0[0] -> 1[0] [send] via NET/IB/0/GDRDMA/Shared
deepseek-v2-5-0:5969:23467 [0] NCCL INFO Channel 01/1 : 0[0] -> 1[0] [send] via NET/IB/1/GDRDMA/Shared
INFO 04-20 17:17:49 [metrics.py:488] Avg prompt throughput: 2.2 tokens/s, Avg generation throughput: 0.2 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.0%, CPU KV cache usage: 0.0%.
INFO 04-20 17:17:49 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:17:59 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 0.1 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.0%, CPU KV cache usage: 0.0%.
INFO 04-20 17:17:59 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:18:04 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 2.2 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.0%, CPU KV cache usage: 0.0%.
INFO 04-20 17:18:04 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:18:10 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 5.0 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.1%, CPU KV cache usage: 0.0%.
INFO 04-20 17:18:10 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:18:15 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 4.6 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.1%, CPU KV cache usage: 0.0%.
INFO 04-20 17:18:15 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:18:20 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 4.8 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.1%, CPU KV cache usage: 0.0%.
INFO 04-20 17:18:20 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:18:25 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 4.9 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.2%, CPU KV cache usage: 0.0%.
INFO 04-20 17:18:25 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:18:30 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 4.6 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.2%, CPU KV cache usage: 0.0%.
INFO 04-20 17:18:30 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:18:35 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 4.9 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.2%, CPU KV cache usage: 0.0%.
INFO 04-20 17:18:35 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:18:40 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 4.8 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.2%, CPU KV cache usage: 0.0%.
INFO 04-20 17:18:40 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:18:45 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 4.6 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.3%, CPU KV cache usage: 0.0%.
INFO 04-20 17:18:45 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:18:52 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 2.9 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.3%, CPU KV cache usage: 0.0%.
INFO 04-20 17:18:52 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:18:58 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 4.7 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.3%, CPU KV cache usage: 0.0%.
INFO 04-20 17:18:58 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:19:03 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 5.0 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.4%, CPU KV cache usage: 0.0%.
INFO 04-20 17:19:03 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:19:08 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 4.8 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.4%, CPU KV cache usage: 0.0%.
INFO 04-20 17:19:08 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:19:13 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 4.8 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.4%, CPU KV cache usage: 0.0%.
INFO 04-20 17:19:13 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:19:14 [async_llm_engine.py:179] Finished request chatcmpl-2f958238775949b7b02fb311fd07b471.
INFO:     127.0.0.1:36506 - "POST /v1/chat/completions HTTP/1.1" 200 OK
INFO 04-20 17:19:24 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 0.3 tokens/s, Running: 0 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.0%, CPU KV cache usage: 0.0%.
INFO 04-20 17:19:24 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:19:34 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 0.0 tokens/s, Running: 0 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.0%, CPU KV cache usage: 0.0%.
INFO 04-20 17:19:34 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:29:54 [logger.py:39] Received request cmpl-1c38d9e3bdf8442a9fd01e94d553fc0b-0: prompt: 'Do you know the book Traction by Gino Wickman', params: SamplingParams(n=1, presence_penalty=0.0, frequency_penalty=0.0, repetition_penalty=1.0, temperature=0.0, top_p=1.0, top_k=-1, min_p=0.0, seed=None, stop=[], stop_token_ids=[], bad_words=[], include_stop_str_in_output=False, ignore_eos=False, max_tokens=120, min_tokens=0, logprobs=None, prompt_logprobs=None, skip_special_tokens=True, spaces_between_special_tokens=True, truncate_prompt_tokens=None, guided_decoding=None, extra_args=None), prompt_token_ids: [100000, 4453, 340, 1006, 254, 2135, 323, 6504, 457, 452, 3098, 59500, 1414], lora_request: None, prompt_adapter_request: None.
INFO:     10.244.1.54:41422 - "POST /v1/completions HTTP/1.1" 200 OK
INFO 04-20 17:29:54 [async_llm_engine.py:211] Added request cmpl-1c38d9e3bdf8442a9fd01e94d553fc0b-0.
INFO 04-20 17:29:59 [metrics.py:488] Avg prompt throughput: 2.5 tokens/s, Avg generation throughput: 4.5 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.1%, CPU KV cache usage: 0.0%.
INFO 04-20 17:29:59 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:30:04 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 4.8 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.1%, CPU KV cache usage: 0.0%.
INFO 04-20 17:30:04 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:30:09 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 4.9 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.1%, CPU KV cache usage: 0.0%.
INFO 04-20 17:30:09 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
INFO 04-20 17:30:14 [metrics.py:488] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 5.1 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.1%, CPU KV cache usage: 0.0%.
INFO 04-20 17:30:14 [metrics.py:504] Prefix cache hit rate: GPU: 0.00%, CPU: 0.00%
...
