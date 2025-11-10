aws ssm put-parameter \
  --name "/some-service/container/parameters/value1" \
  --value "One-Two" \
  --type "String" \
  --overwrite

aws ssm put-parameter \
  --name "/some-service/container/parameters/value2" \
  --value "Three-Four" \
  --type "String" \
  --overwrite

echo "All parameters are update succussfully"