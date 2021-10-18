#!/bin/bash -e

output_file=$1

if [ -z "$output_file" ];then
    echo "no output file"
    exit 1
fi
mkdir -p $(dirname $output_file)
rm -f $output_file

AWS_GREENGRASS_CONFIG=/greengrass/config/config.json

# ex. arn:aws:iot:ap-northeast-1:237086546437:thing/fms-dev-edge-d43fba9d-57b7-4c30-bbe8-04dbc8f26ea4-Core
thing_arn=$(cat $AWS_GREENGRASS_CONFIG | jq -r .coreThing.thingArn)

# ex. fms-dev
profile=$(echo "$thing_arn" | cut -d ':' -f 6 | sed -r -n -e 's#^thing/(.*)-edge-.*$#\1#p')

case "$profile" in
    fms-dev)
        AWS_CREDENTIAL_PROVIDER_ENDPOINT="cfm5qkounell8.credentials.iot.ap-northeast-1.amazonaws.com"
    ;;
    fms-stg)
        AWS_CREDENTIAL_PROVIDER_ENDPOINT="c33worhjjbxnl7.credentials.iot.ap-northeast-1.amazonaws.com"
    ;;
    fms-prd)
        AWS_CREDENTIAL_PROVIDER_ENDPOINT="c14x83ykv3r9dg.credentials.iot.ap-northeast-1.amazonaws.com"
    ;;
    *)
        echo "failed to setup aws greengrass log. invalid profile: profile=$profile"
        exit 1
    ;;
esac

account_id=$(echo "$thing_arn" | cut -d ':' -f 5)

AWS_CLOUDWATCH_LOG_GROUP=/aws/greengrass/edge/ap-northeast-1/${account_id}/${profile}-edge-otaclient
AWS_ROLE_ALIAS=${profile}-autoware-adapter-credentials-iot-secrets-access-role-alias
AWS_CLOUDWATCH_LOG_ENABLE=true

envvars=( \
    AWS_GREENGRASS_CONFIG \
    AWS_CREDENTIAL_PROVIDER_ENDPOINT \
    AWS_CLOUDWATCH_LOG_GROUP \
    AWS_ROLE_ALIAS \
    AWS_CLOUDWATCH_LOG_ENABLE \
)

for envvar in ${envvars[@]};do
    echo ${envvar}=${!envvar} >> $output_file
done
