# Once vLLM moves to Ubuntu 24.04, we can use the vLLM image again.
# FROM vllm/vllm-openai:v0.10.0

FROM nvcr.io/nvidia/tritonserver:25.06-py3-sdk

ENV VLLM_VERSION=0.10.0 \
    VLLM_CODE="/root/vllm" \
    SHAREGPT_DATASET_URL="https://huggingface.co/datasets/anon8231489123/ShareGPT_Vicuna_unfiltered/resolve/main/ShareGPT_V3_unfiltered_cleaned_split.json"

# Download the sharegpt dataset
RUN curl -L \
    -o /root/sharegpt.json "${SHAREGPT_DATASET_URL}"

# Download the VLLM code
RUN TMP_DIR=$(mktemp -d) && \
    cd "${TMP_DIR}" && \
    curl -LO "https://github.com/vllm-project/vllm/releases/download/v${VLLM_VERSION}/vllm-${VLLM_VERSION}.tar.gz" && \
    tar -xvzf "vllm-${VLLM_VERSION}.tar.gz" && \
    rm "vllm-${VLLM_VERSION}.tar.gz" && \
    mv vllm-* "${VLLM_CODE}" && \
    cd / && \
    rm -rf "${TMP_DIR}"

COPY *  /root/scripts/

# Install pip & other dependencies
RUN pip install \
    tabulate \
    pandas \
    datasets \
    git+https://github.com/neuralmagic/guidellm.git \
    notebook \
    vllm && \
    apt-get update && \
    apt-get -y install jq tree tmux

WORKDIR /root
