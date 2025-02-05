#!/bin/bash
# Copyright Contributors to the Open Cluster Management project

# set -x
TEST_DIR=test/functional
TEST_RESULT_DIR=$TEST_DIR/tmp
ERROR_REPORT=""
CLUSTER_NAME=$PROJECT_NAME-functional-test
kind create cluster --name $CLUSTER_NAME
# Configure the kind cluster
cm applier -d $TEST_DIR/resources

rm -rf $TEST_RESULT_DIR
mkdir -p $TEST_RESULT_DIR

echo "Test cm create cluster AWS"
cm create cluster --values $TEST_DIR/create/cluster/aws_values.yaml -o $TEST_RESULT_DIR/aws_result.yaml
diff -u $TEST_DIR/create/cluster/aws_result.yaml $TEST_RESULT_DIR/aws_result.yaml
if [ $? != 0 ]
then
   ERROR_REPORT=$ERROR_REPORT+"create/cluster/deploy.sh AWS failed\n"
fi

echo "Test cm create cluster Azure"
cm create cluster --values $TEST_DIR/create/cluster/azure_values.yaml -o $TEST_RESULT_DIR/azure_result.yaml
diff -u $TEST_DIR/create/cluster/azure_result.yaml $TEST_RESULT_DIR/azure_result.yaml
if [ $? != 0 ]
then
   ERROR_REPORT=$ERROR_REPORT+"cm create cluster Azure failed\n"
fi

echo "Test cm create cluster GCP"
cm create cluster --values $TEST_DIR/create/cluster/gcp_values.yaml -o $TEST_RESULT_DIR/gcp_result.yaml
diff -u $TEST_DIR/create/cluster/gcp_result.yaml $TEST_RESULT_DIR/gcp_result.yaml
if [ $? != 0 ]
then
   ERROR_REPORT=$ERROR_REPORT+"cm create cluster GCP failed\n"
fi

echo "Test cm create cluster vSphere"
cm create cluster --values $TEST_DIR/create/cluster/vsphere_values.yaml -o $TEST_RESULT_DIR/vsphere_result.yaml
diff -u $TEST_DIR/create/cluster/vsphere_result.yaml $TEST_RESULT_DIR/vsphere_result.yaml
if [ $? != 0 ]
then
   ERROR_REPORT=$ERROR_REPORT+"cm create cluster vSphere failed\n"
fi

echo "Test cm attach cluster manual"
cm attach cluster --values $TEST_DIR/attach/cluster/manual_values.yaml -o $TEST_RESULT_DIR/manual_result.yaml
diff -u $TEST_DIR/attach/cluster/manual_result.yaml $TEST_RESULT_DIR/manual_result.yaml
if [ $? != 0 ]
then
   ERROR_REPORT=$ERROR_REPORT+"cm attach cluster manual failed\n"
fi

echo "Test cm attach cluster kubeconfig"
cm attach cluster --values $TEST_DIR/attach/cluster/kubeconfig_values.yaml -o $TEST_RESULT_DIR/kubeconfig_result.yaml
diff -u $TEST_DIR/attach/cluster/kubeconfig_result.yaml $TEST_RESULT_DIR/kubeconfig_result.yaml
if [ $? != 0 ]
then
   ERROR_REPORT=$ERROR_REPORT+"cm attach cluster kubeconfig failed\n"
fi

echo "Test cm attach cluster token"
cm attach cluster --values $TEST_DIR/attach/cluster/token_values.yaml -o $TEST_RESULT_DIR/token_result.yaml
diff -u $TEST_DIR/attach/cluster/token_result.yaml $TEST_RESULT_DIR/token_result.yaml
if [ $? != 0 ]
then
   ERROR_REPORT=$ERROR_REPORT+"cm attach cluster token failed\n"
fi

if [ -z "$ERROR_REPORT" ]
then
    echo "Success"
else
    echo -e "\n\nErrors\n======\n"$ERROR_REPORT
    exit 1
fi

kind delete cluster --name $CLUSTER_NAME