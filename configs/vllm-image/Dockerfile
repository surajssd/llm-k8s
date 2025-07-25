FROM vllm/vllm-openai:v0.10.0

RUN pip install 'ray[default]' aiohttp_cors && \
    apt update && apt install -y iproute2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
