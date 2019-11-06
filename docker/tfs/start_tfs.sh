#!/bin/bash

echo tensorflow_model_server --rest_api_timeout_in_ms=${REST_API_TIMOUT} --port=8500 --rest_api_port=8501 --model_name=${MODEL_NAME} --model_base_path=${MODEL_BASE_PATH}/${MODEL_NAME} "$@"
tensorflow_model_server --rest_api_timeout_in_ms=${REST_API_TIMOUT} --port=8500 --rest_api_port=8501 --model_name=${MODEL_NAME} --model_base_path=${MODEL_BASE_PATH}/${MODEL_NAME} "$@"
