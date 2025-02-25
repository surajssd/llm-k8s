#!/usr/bin/env bash
# Inspired by:
# https://github.com/vllm-project/vllm/blob/1f0ae3ed0aa9af7f5e88e56f5c960cc919c2f090/.buildkite/nightly-benchmarks/scripts/run-performance-benchmarks.sh#L374

set -euo pipefail

# Check if the DEBUG env var is set to true
if [ "${DEBUG:-false}" = "true" ]; then
  set -x
fi

# Check if the required env vars are set
: "${VLLM_CODE:?Environment variable VLLM_CODE not set}"
: "${HF_TOKEN:?Environment variable HF_TOKEN not set}"
: "${MODEL_NAME:?Environment variable MODEL_NAME not set}"
: "${TENSOR_PARALLEL_SIZE:?Environment variable TENSOR_PARALLEL_SIZE not set}"
: "${PIPELINE_PARALLEL_SIZE:?Environment variable PIPELINE_PARALLEL_SIZE not set}"
: "${TEST_SERVER_URL:?Environment variable TEST_SERVER_URL not set}"
: "${GPU_VM_SKU:?Environment variable GPU_VM_SKU not set}"

VLLM_BENCHMARK_CODE="${VLLM_CODE}/benchmarks"
BUILD_KITE_ROOT="${VLLM_CODE}/.buildkite"
RESULTS_FOLDER="${BUILD_KITE_ROOT}/results/"
mkdir -p $RESULTS_FOLDER

function check_hf_token() {
  # check if HF_TOKEN is available and valid
  if [[ -z "$HF_TOKEN" ]]; then
    echo "Error: HF_TOKEN is not set."
    exit 1
  elif [[ ! "$HF_TOKEN" =~ ^hf_ ]]; then
    echo "Error: HF_TOKEN does not start with 'hf_'."
    exit 1
  else
    echo "HF_TOKEN is set and valid."
  fi
}

function run_serving_tests() {
  # Generate the test name and replace the '/' with '-'
  test_name=$(echo "serving_${MODEL_NAME}_tp${TENSOR_PARALLEL_SIZE}_pp${PIPELINE_PARALLEL_SIZE}_sharegpt" | tr '/' '-')

  # Request rates to test
  qps_list=(01 04 16 inf)
  echo "Running over qps list $qps_list"

  # iterate over different QPS
  for qps in "${qps_list[@]}"; do
    new_test_name=$test_name"_qps_"$qps

    pushd $VLLM_BENCHMARK_CODE
    client_command="python3 benchmark_serving.py \
        --save-result \
        --base-url ${TEST_SERVER_URL} \
        --result-dir ${RESULTS_FOLDER} \
        --result-filename ${new_test_name}.json \
        --request-rate $qps \
        --model=${MODEL_NAME} \
        --backend=vllm \
        --dataset-name=sharegpt \
        --dataset-path=/root/sharegpt.json \
        --num-prompts=200"

    echo "Running test case $test_name with qps $qps"
    echo "Client command: $client_command"

    bash -c "$client_command"
    popd

    # record the benchmarking commands
    gpu_type="${GPU_VM_SKU} x ${PIPELINE_PARALLEL_SIZE}"
    jq_output=$(jq -n \
      --arg client "$client_command" \
      --arg gpu_type "$gpu_type" \
      '{
          client_command: $client,
          gpu_type: $gpu_type
        }')
    echo "$jq_output" >"$RESULTS_FOLDER/${new_test_name}.commands"

  done

}

function collate_results() {
  pushd "${BUILD_KITE_ROOT}"
  python3 /root/scripts/convert-results-json-to-markdown.py
  popd

  cat "${RESULTS_FOLDER}/benchmark_results.md"

  cp -r "${RESULTS_FOLDER}" "results-${test_name}"
  tar czf "/root/results-${test_name}.tar.gz" "results-${test_name}"
  echo "Results are saved in /root/results-${test_name}.tar.gz"
}

function main() {
  # prepare for benchmarking
  check_hf_token

  # run benchmarking tests
  run_serving_tests

  # collate results
  collate_results
}

main
