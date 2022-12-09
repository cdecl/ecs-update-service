

# cluster : infra-dev-mvcapp-ecs
# definition : infra-dev-mvcapp-def
# service : infra-dev-mvcapp-svc 

aws ecs list-services --cluster infra-dev-mvcapp-ecs

aws ecs describe-task-definition --task-definition infra-dev-mvcapp-def

aws ecs register-task-definition --cli-input-json file://infra-dev-mvcapp-def.json > output-definition.json

ECS_TASK_DEF=$(cat output-definition.json | jq -r '.taskDefinition.taskDefinitionArn' | awk -F/ '{ print $2 }')
echo $ECS_TASK_DEF

aws ecs update-service --cluster infra-dev-mvcapp-ecs --service infra-dev-mvcapp-svc --task-definition infra-dev-mvcapp-def:6 --force-new-deployment

aws ecs describe-services --service infra-dev-mvcapp-svc --cluster infra-dev-mvcapp-ecs