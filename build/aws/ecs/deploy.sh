#!/usr/bin/env bash

# Replace version number in container definition file
VERSION="${bamboo_buildNumber}"
sed -i "s:VERSION:${VERSION}:g" container_definitions.json

export ParentVPCStack="vpc-variables-container"
export ClusterName=ecs-cluster
export ServiceName=contest

# https://github.com/widdix/aws-cf-templates/tree/ecs/ecs#creating-a-ecs-task-definition
# create task definition for new docker image
export TaskDefinitionArn=$(aws ecs register-task-definition --family $ServiceName --network-mode bridge --container-definitions file://container_definitions.json --query "taskDefinition.taskDefinitionArn" --output text)

# create or update service stack to deploy new task definition

if aws cloudformation describe-stacks --stack-name $ClusterName-$ServiceName ; then
    aws cloudformation update-stack --stack-name $ClusterName-$ServiceName --template-body file://service.yaml  \
        --parameters  \
            ParameterKey=ParentVPCStack,UsePreviousValue=true   \
            ParameterKey=ParentClusterStack,UsePreviousValue=true   \
            ParameterKey=ParentAuthProxyStack,UsePreviousValue=true   \
            ParameterKey=LoadBalancerScheme,UsePreviousValue=true   \
            ParameterKey=LoadBalancerCertificateArn,UsePreviousValue=true   \
            ParameterKey=TaskDefinitionArn,ParameterValue=$TaskDefinitionArn   \
            ParameterKey=DesiredCount,UsePreviousValue=true   \
            ParameterKey=MaxCapacity,UsePreviousValue=true  \
            ParameterKey=MinCapacity,UsePreviousValue=true  \
            ParameterKey=ContainerPort,UsePreviousValue=true  \
            ParameterKey=ContainerName,UsePreviousValue=true  \
         --capabilities CAPABILITY_IAM
    # The next command can take up to 5 minutes because of instance draining (http://docs.aws.amazon.com/AmazonECS/latest/developerguide/container-instance-draining.html)
    aws cloudformation wait stack-update-complete --stack-name $ClusterName-$ServiceName
else
    aws cloudformation create-stack --stack-name $ClusterName-$ServiceName --template-body file://service.yaml   \
        --parameters   \
            ParameterKey=ParentVPCStack,ParameterValue=$ParentVPCStack \
            ParameterKey=ParentClusterStack,ParameterValue=$ClusterName   \
            ParameterKey=TaskDefinitionArn,ParameterValue=$TaskDefinitionArn \
        --capabilities CAPABILITY_IAM
    aws cloudformation wait stack-create-complete --stack-name $ClusterName-$ServiceName
fi
