#!/bin/bash

CLUSTER=infra-dev-mvcapp-ecs
SERVICE=infra-dev-mvcapp-svc 
DEFINITION=file://infra-dev-mvcapp-def.json

aws ecs describe-services --service $SERVICE --cluster $CLUSTER > output-describe-services.json
cat output-describe-services.json | jq -r '.services[] | "[NOW DEF] serviceName: \(.serviceName) \n[NOW DEF] desiredCount: \(.desiredCount) \n[NOW DEF] taskDefinition: \(.taskDefinition)"'
echo '--'

aws ecs register-task-definition --cli-input-json "$DEFINITION" > output-definition.json

ECS_TASK_DEF=$(cat output-definition.json | jq -r '.taskDefinition.taskDefinitionArn' | awk -F/ '{ print $2 }')
echo "[REGISTER DEF] taskDefinition : $ECS_TASK_DEF"
echo '--'

aws ecs update-service \
	--cluster $CLUSTER  \
	--service $SERVICE \
	--task-definition $ECS_TASK_DEF \
	--desired-count 1 \
	--force-new-deployment > output-update-service.json

cat output-update-service.json | jq -r '.service | "[UPDATE DEF] serviceName: \(.serviceName) \n[UPDATE DEF] desiredCount: \(.desiredCount) \n[UPDATE DEF] taskDefinition: \(.taskDefinition)"'
echo '--'

aws ecs describe-services --service $SERVICE --cluster $CLUSTER > output-describe-services.json
cat output-describe-services.json | jq -r '.services[] | "[NOW DEF] serviceName: \(.serviceName) \n[NOW DEF] desiredCount: \(.desiredCount) \n[NOW DEF] taskDefinition: \(.taskDefinition)"'
