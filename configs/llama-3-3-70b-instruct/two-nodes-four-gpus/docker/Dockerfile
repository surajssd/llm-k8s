FROM vllm/vllm-openai:v0.8.1

RUN pip install 'ray[default]' aiohttp_cors && \
    apt update && apt install -y iproute2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ray_init.sh /vllm-workspace/ray_init.sh
