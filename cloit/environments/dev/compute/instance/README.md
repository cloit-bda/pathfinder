# Terraform Migrations
## Managed Service
### Terraform init

### Login
```bash
gcloud auth login
```

```bash 
gcloud auth application-default login
```


```bash
terraform init
```


**주의 사항** 
1. label에서 n 은 false 로 인식함     
"n" 문자열로 변경해 주어야 함.  그렇지 않으면 false로 변경이 됨. 

2. machine_type 은  machine-type 로 변경해 주어야 함.  
#machineType: https://www.googleapis.com/compute/v1/projects/cloit-data-dev/zones/asia-northeast3-b/machineTypes/n1-standard-4
machineType: n1-standard-4

불필요 필드 없에는 프로그램 필요 

## Compute Instance (VM)

### Data 추출
```bash
gcloud compute instances list --project=cloit-data-dev  --format=yaml
```

## Terraform Import
**cloit-data-dev**
```bash
python3 /Users/sdk/IdeaProjects/opsman-terraform/vdkpi/migration/import_gce_insatnce.py cloit-data-dev
```
**cloit-ingest-dev**
```bash
python3 /Users/sdk/IdeaProjects/opsman-terraform/vdkpi/migration/import_gce_insatnce.py cloit-ingest-dev
```

**cloit-service-dev**
```bash
python3 /Users/sdk/IdeaProjects/opsman-terraform/vdkpi/migration/import_gce_insatnce.py cloit-service-dev
```


### Terraform plan
```bash
terraform plan -target=module.instance
```



terraform refresh
terraform init

TF_LOG=DEBUG terraform import 'module.composer.module.composer["cloit-d-sub-data-analytics-an3"].google_composer_environment.composer_env' projects/cloit-data-dev/locations/asia-northeast3/environments/cloit-d-sub-data-analytics-an3


## Compute Instance (VM)

### Data 추출 

filter="name~^vdkpi" --format=yaml  : vdkpi 로 시작하는 GCE 만 추출 (GKE 제외됨.) 

**cloit-data-dev**
```bash
gcloud compute instances list --project=cloit-data-dev  --filter="name~^vdkpi" --format=yaml
```
**cloit-ingest-dev**
```bash
gcloud compute instances list --project=cloit-ingest-dev --filter="name~^vdkpi" --format=yaml > cloit-ingest-dev.yaml
```

**cloit-service-dev**
```bash
gcloud compute instances list --project=cloit-service-dev --filter="name~^vdkpi" --format=yaml
```

## Terraform Import
```bash
python3 /Users/sdk/IdeaProjects/opsman-terraform/vdkpi/migration/import_gce_insatnce.py cloit-data-dev
```

```bash
python3 /Users/sdk/IdeaProjects/opsman-terraform/vdkpi/migration/import_gce_insatnce.py cloit-service-dev
```

```bash
python3 /Users/sdk/IdeaProjects/opsman-terraform/vdkpi/migration/import_gce_insatnce.py cloit-ingest-dev
```


### Terraform plan
**cloit-data-dev**
```bash
terraform workspace select cloit-data-dev
terraform plan -target=module.instance -var project_id=cloit-data-dev
```
**cloit-service-dev**
```bash
terraform workspace select cloit-service-dev
terraform plan -target=module.instance -var project_id=cloit-service-dev
```
**cloit-ingest-dev**
```bash
terraform workspace select cloit-ingest-dev
terraform plan -target=module.instance -var project_id=cloit-ingest-dev
```
**cloit-host-dev**
```bash
terraform workspace select cloit-host-dev
terraform plan -target=module.instance -var project_id=cloit-data-dev
```


```bash
gsutil rm gs://cloit-d-host-cs-terraform-state/terraform/state/dev/compute/instance/cloit-ingest-dev.tfstate
```
