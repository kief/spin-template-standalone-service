#!/usr/bin/env bash
# vim: set ft=sh

set -eu

PIPELINE_NAME=simple_stack_pipeline

exit_good()
{
  echo "OK: $*"
  exit 0
}

exit_bad()
{
  >&2 echo "FAIL: $*"
  exit 1
}

run_aws_cli()
{
  AWS_CLI_OUTPUT=$(aws $*)
  [[ "$?" == "0" ]] || exit_bad "output: ${AWS_CLI_OUTPUT}"
}

parse_result()
{
  COMMAND_RESULT=$(echo ${AWS_CLI_OUTPUT} | jq -r "$*")
}

run_aws_cli codepipeline start-pipeline-execution --name ${PIPELINE_NAME}
parse_result '.pipelineExecutionId'
EXECUTION_ID=${COMMAND_RESULT}

EXECUTION_STATUS=""
while [ "${EXECUTION_STATUS}" = "" -o "${EXECUTION_STATUS}" = "InProgress" ] ; do
  sleep 5
  run_aws_cli codepipeline get-pipeline-execution \
    --pipeline-name ${PIPELINE_NAME} \
    --pipeline-execution-id ${EXECUTION_ID}
  parse_result '.pipelineExecution | .status'
  EXECUTION_STATUS=${COMMAND_RESULT}
  echo ${EXECUTION_STATUS}
done

echo "FINAL: ${EXECUTION_STATUS}"

[[ ${EXECUTION_STATUS} = "Succeeded" ]] || exit_bad "Pipeline did not succeed: (${EXECUTION_STATUS})"
exit_good "Pipeline succeeded."
