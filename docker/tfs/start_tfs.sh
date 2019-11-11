#!/bin/bash

BATCH_PARAMETER_FILE='/tmp/batch_params.txt'
BASE_COMMAND="tensorflow_model_server --rest_api_timeout_in_ms=${REST_API_TIMEOUT} --port=8500 --rest_api_port=8501 --model_name=${MODEL_NAME} --model_base_path=${MODEL_BASE_PATH}/${MODEL_NAME}"

if [ "$ENABLE_BATCHING" = 'true' ]; then
  HAS_PARAMETERS=false
  BASE_COMMAND="$BASE_COMMAND --enable_batching=true"
  if [ ! -z "$MAX_BATCH_SIZE" ]; then
    echo "max_batch_size { value: $MAX_BATCH_SIZE }" >> $BATCH_PARAMETER_FILE
    HAS_PARAMETERS=true
  fi
  if [ ! -z "$BATCH_TIMEOUT_MICROS" ]; then
    echo "batch_timeout_micros { value: $BATCH_TIMEOUT_MICROS }" >> $BATCH_PARAMETER_FILE
    HAS_PARAMETERS=true
  fi
  if [ ! -z "$MAX_ENQUEUED_BATCHES" ]; then
    echo "max_enqueued_batches { value: $MAX_ENQUEUED_BATCHES }" >> $BATCH_PARAMETER_FILE
    HAS_PARAMETERS=true
  fi
  if [ ! -z "$NUM_BATCH_THREADS" ]; then
    echo "num_batch_threads { value: $NUM_BATCH_THREADS }" >> $BATCH_PARAMETER_FILE
    HAS_PARAMETERS=true
  fi
  if [ "$HAS_PARAMETERS" = true ]; then
    BASE_COMMAND="$BASE_COMMAND --batching_parameters_file=$BATCH_PARAMETER_FILE"
  fi
fi

cat $BATCH_PARAMETER_FILE

echo $BASE_COMMAND "$@"
$BASE_COMMAND "$@"
