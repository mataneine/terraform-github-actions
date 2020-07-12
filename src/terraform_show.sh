#!/bin/bash

function terraformShow {
  # Gather the output of `terraform show`.
  echo "show: info: gathering all the outputs for the Terraform configuration in ${tfWorkingDir}"
  showOutput=$(terraform show -json ${*} 2>&1)
  showExitCode=${?}

  # Exit code of 0 indicates success. Print the output and exit.
  if [ ${showExitCode} -eq 0 ]; then
    echo "show: info: successfully gathered all the outputs for the Terraform configuration in ${tfWorkingDir}"
    echo "${showOutput}"
    echo

    # https://github.community/t5/GitHub-Actions/set-output-Truncates-Multiline-Strings/m-p/38372/highlight/true#M3322
    showOutput="${showOutput//'%'/'%25'}"
    showOutput="${showOutput//$'\n'/'%0A'}"
    showOutput="${showOutput//$'\r'/'%0D'}"

    echo "::set-output name=tf_actions_show::${showOutput}"
    exit ${showExitCode}
  fi

  # Exit code of !0 indicates failure.
  echo "show: error: failed to gather all the outputs for the Terraform configuration in ${tfWorkingDir}"
  echo "${showOutput}"
  echo
  exit ${showExitCode}
}
