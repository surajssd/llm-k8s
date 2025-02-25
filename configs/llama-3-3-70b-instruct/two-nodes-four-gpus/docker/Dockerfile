FROM vllm/vllm-openai:v0.7.3

RUN pip install 'ray[default]' aiohttp_cors

COPY ray_init.sh /vllm-workspace/ray_init.sh
