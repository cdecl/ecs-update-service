
# AWS ECS Update Service (CLI)

## CLI 명령어 요악

### 클러스터 내 서비스 확인 

> aws ecs list-services --cluster <클러스터이름>

```sh
$ aws ecs list-services --cluster infra-dev-mvcapp-ecs
```

### 작업 정의 개정판 확인 

> aws ecs describe-task-definition --task-definition <작업정의이름>

```sh
$ aws ecs describe-task-definition --task-definition infra-dev-mvcapp-def
```

### 작업 정의 개정 등록 (개정 버전이 신규 등록)

> aws ecs register-task-definition --cli-input-json <작업정의 Json 파일>

```sh
$ aws ecs register-task-definition --cli-input-json file://infra-dev-mvcapp-def.json > output-definition.json

ECS_TASK_DEF=$(cat output-definition.json | jq -r '.taskDefinition.taskDefinitionArn' | awk -F/ '{ print $2 }')
echo $ECS_TASK_DEF

```

### 서비스의 작업 정의를 업데이트 (배포)

> aws ecs update-service --cluster <클러스터이름> --service <서비스이름> --task-definition <작업정의개정판버전> --force-new-deployment

```sh
$ aws ecs update-service --cluster infra-dev-mvcapp-ecs --service infra-dev-mvcapp-svc --task-definition infra-dev-mvcapp-def:6 --force-new-deployment
```


### 서비스 상태 확인 

> aws ecs describe-services --cluster <클러스터이름> --service <서비스이름>

```sh
$ aws ecs describe-services --service infra-dev-mvcapp-svc --cluster infra-dev-mvcapp-ecs
```

---

## 테스트 
 
```sh
$ ./ecs-update-service.sh
[NOW DEF] serviceName: infra-dev-mvcapp-svc
[NOW DEF] desiredCount: 1
[NOW DEF] taskDefinition: arn:aws:ecs:ap-northeast-2:800674234928:task-definition/infra-dev-mvcapp-def:15
--
[REGISTER DEF] taskDefinition : infra-dev-mvcapp-def:16
--
[UPDATE DEF] serviceName: infra-dev-mvcapp-svc
[UPDATE DEF] desiredCount: 1
[UPDATE DEF] taskDefinition: arn:aws:ecs:ap-northeast-2:800674234928:task-definition/infra-dev-mvcapp-def:16
--
[NOW DEF] serviceName: infra-dev-mvcapp-svc
[NOW DEF] desiredCount: 1
[NOW DEF] taskDefinition: arn:aws:ecs:ap-northeast-2:800674234928:task-definition/infra-dev-mvcapp-def:16
```

