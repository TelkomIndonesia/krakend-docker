#!/bin/bash
set -euo pipefail

KRAKEND_KCL_FILE="${KRAKEND_KCL_FILE:-""}"
if [ -f "$KRAKEND_KCL_FILE" ]; then 
    kcl run "$KRAKEND_KCL_FILE" --format json --output /etc/krakend/krakend.json
fi

exec krakend $@