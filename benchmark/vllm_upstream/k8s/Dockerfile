ARG VLLM_VERSION=0.7.3

FROM vllm/vllm-openai:v${VLLM_VERSION}

ENV VLLM_VERSION=${VLLM_VERSION} \
    VLLM_CODE="/root/vllm" \
    SHAREGPT_DATASET_URL="https://huggingface.co/datasets/anon8231489123/ShareGPT_Vicuna_unfiltered/resolve/main/ShareGPT_V3_unfiltered_cleaned_split.json"

# Download the sharegpt dataset
RUN curl -L \
    -o /root/sharegpt.json "${SHAREGPT_DATASET_URL}"

# Download the VLLM code
RUN TMP_DIR=$(mktemp -d) && \
    pushd "${TMP_DIR}" && \
    curl -LO "https://github.com/vllm-project/vllm/releases/download/v${VLLM_VERSION}/vllm-${VLLM_VERSION}.tar.gz" && \
    tar -xvzf "vllm-${VLLM_VERSION}.tar.gz" && \
    rm "vllm-${VLLM_VERSION}.tar.gz" && \
    mv vllm-* "${VLLM_CODE}" && \
    popd && \
    rm -rf "${TMP_DIR}"

# Install pip & other dependencies
RUN pip install tabulate pandas datasets && \
    apt-get update && apt-get -y install jq
