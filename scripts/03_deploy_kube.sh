#!/bin/sh

TYPE="deploy_kube"

TERRAFORM_BIN="${PWD}/../bin/terraform"

WORK_DIR="${PWD}/../data/tf/${TYPE}"
STATE_DIR="${PWD}/../state"
PLUGINS_DIR="${PWD}/../plugins"

${TERRAFORM_BIN} init -plugin-dir=${PLUGINS_DIR} -input=false ${WORK_DIR}
if [ $? -ne 0 ]; then
    exit 1;
fi

${TERRAFORM_BIN} apply -auto-approve \
 -var-file=${WORK_DIR}/../default.tfvars \
 -var-file=${WORK_DIR}/../networks.tfvars \
 -var-file=${WORK_DIR}/../${TYPE}.tfvars \
 -state=${STATE_DIR}/${TYPE}/terraform.tfstate \
 -input=false ${WORK_DIR}

if [ $? -ne 0 ]; then
    exit 1;
fi
