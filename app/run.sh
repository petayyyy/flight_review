#!/bin/bash

PORT_VALUE=${PORT:-5006}
DOMAIN_VALUE=${DOMAIN:-*}

WORK_PATH=/opt/service
DATA_PATH=${WORK_PATH}/data

# app setup
if [ ! -d ${DATA_PATH} ]; then
	mkdir -p ${DATA_PATH}
fi

if [ ! -f ${DATA_PATH}/logs.sqlite ]; then
	python3 ${WORK_PATH}/setup_db.py
fi

if [ -n "${USE_PROXY}" ]; then
	echo "Use Proxy!"

	WS_ORIGIN_VALUE=${BOKEH_ALLOW_WS_ORIGIN:-${DOMAIN_VALUE}}
	if [ "${WS_ORIGIN_VALUE}" = "0.0.0.0" ] || [ "${WS_ORIGIN_VALUE}" = "*" ]; then
		WS_ORIGIN_VALUE="*"
	fi

	python3 ${WORK_PATH}/serve.py \
		--port=${PORT_VALUE} \
		--address=0.0.0.0 \
		--allow-websocket-origin=${WS_ORIGIN_VALUE} \
		--use-xheaders
else
	python3 ${WORK_PATH}/serve.py --port=${PORT_VALUE}
fi
