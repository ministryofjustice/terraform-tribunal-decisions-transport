#!/bin/bash

echo "CODEBUILD_SRC_DIR <$CODEBUILD_SRC_DIR>"
echo "The action is <$TF_ACTION>. The mode is <$TF_MODE>"
echo "The artifacts are in $CODEBUILD_SRC_DIR_TerraformPlanArtifacts"
ls $CODEBUILD_SRC_DIR_TerraformPlanArtifacts

terraform init -input=false

if [ "$TF_ACTION" == "apply" ]; then
  cp $CODEBUILD_SRC_DIR_TerraformPlanArtifacts/* /opt/;
  terraform $TF_ACTION /opt/tf.plan;
fi

if [ "$TF_ACTION" == "plan" ]; then
  terraform $TF_ACTION -var "application_name=$APPLICATION_NAME" -var "environment=$ENVIRONMENT" -out /opt/tf.plan $TF_MODE;
fi

ls /opt