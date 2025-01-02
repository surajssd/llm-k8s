#!/usr/bin/env bash

set -euo pipefail
set -x

nvkind cluster create
nvkind cluster print-gpus
