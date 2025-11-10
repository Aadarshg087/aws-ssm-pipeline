#!/usr/bin/bash
set -euo pipefail

# Edit these values
value1="One-Two-Two-one" 
value2="Three-Four"

BASE_PATH="/some-service/container/parameters"

ensure_param() {
  local varname="$1"
  # indirect expansion to get the variable's value
  local desired
  # If the variable isn't set, skip
  if ! desired="${!varname-}"; then
    echo "Variable \"$varname\" is not set. Skipping."
    return
  fi

  local param_name="$BASE_PATH/$varname"

  # Try to get existing parameter value. If parameter doesn't exist,
  # `aws ssm get-parameter` exits non-zero and we create the parameter.
  if existing_value=$(aws ssm get-parameter --name "$param_name" --query 'Parameter.Value' --output text 2>/dev/null); then
    if [ "$existing_value" != "$desired" ]; then
      echo "Updating parameter $param_name"
      aws ssm put-parameter --name "$param_name" --value "$desired" --type "String" --overwrite
    else
      echo "Parameter $param_name already up-to-date; skipping."
    fi
  else
    echo "Creating parameter $param_name"
    aws ssm put-parameter --name "$param_name" --value "$desired" --type "String"
  fi
}

main() {
  # list of variable names to process (these are the variable NAMES, not values)
  local params=(value1 value2)

  for p in "${params[@]}"; do
    ensure_param "$p"
  done

  echo "All parameters processed."
}

main "$@"
