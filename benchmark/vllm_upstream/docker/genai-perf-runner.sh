#!/usr/bin/env bash

set -euo pipefail

: "${GENAI_PERF_ROOT_DIR:=/root/genai-perf-results}"
PLOTS="${GENAI_PERF_ROOT_DIR}/plots"
mkdir -p "$PLOTS"

: "${TEST_METRICS_URL:=${TEST_SERVER_URL}/metrics}"

declare -A useCases

# Populate the array with use case descriptions and their specified input/output lengths
useCases["Translation"]="256/256"
useCases["Text classification"]="256/8"
useCases["Text summary"]="1024/256"

# Function to execute genAI-perf with the input/output lengths as arguments
runBenchmark() {
    local description="$1"
    local lengths="${useCases[$description]}"
    IFS='/' read -r inputLength outputLength <<<"$lengths"

    echo "⏳ Running genAI-perf for $description with input length $inputLength and output length $outputLength"
    #Runs
    for concurrency in 1 2 5 10 50 100 250; do
        echo "⏳ Running with concurrency $concurrency"
        local INPUT_SEQUENCE_LENGTH=$inputLength
        local INPUT_SEQUENCE_STD=0
        local OUTPUT_SEQUENCE_LENGTH=$outputLength
        local CONCURRENCY=$concurrency

        genai-perf profile \
            -m "$MODEL_NAME" \
            --endpoint-type chat \
            --streaming \
            --server-metrics-url "$TEST_METRICS_URL" \
            --url "$TEST_SERVER_URL" \
            --extra-inputs "max_tokens:$OUTPUT_SEQUENCE_LENGTH" \
            --extra-inputs "min_tokens:$OUTPUT_SEQUENCE_LENGTH" \
            --extra-inputs ignore_eos:true \
            --output-tokens-mean "$OUTPUT_SEQUENCE_LENGTH" \
            --synthetic-input-tokens-mean "$INPUT_SEQUENCE_LENGTH" \
            --synthetic-input-tokens-stddev "$INPUT_SEQUENCE_STD" \
            --artifact-dir "$GENAI_PERF_ROOT_DIR" \
            --concurrency "$CONCURRENCY" \
            --profile-export-file "${INPUT_SEQUENCE_LENGTH}_${OUTPUT_SEQUENCE_LENGTH}.json" \
            --measurement-interval 20000 \
            --tokenizer "$MODEL_NAME" \
            --tokenizer-trust-remote-code \
            -- \
            -v \
            --max-threads=256

        echo "✅ Completed benchmark for $description with concurrency $concurrency"
    done
}

pushd "$GENAI_PERF_ROOT_DIR"

# Iterate over all defined use cases and run the benchmark script for each
for description in "${!useCases[@]}"; do
    runBenchmark "$description"
done

popd
