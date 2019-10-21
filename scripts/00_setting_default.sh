#!/bin/bash

IMAGE_NAME="CentOS-7-x86_64-GenericCloud-1907.qcow2"
IMAGE_URL="https://cloud.centos.org/centos/7/images/${IMAGE_NAME}"
IMAGE_FILE_DIR="../images"

curl ${IMAGE_URL} -o ${IMAGE_FILE_DIR}/${IMAGE_NAME}
