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



## Composer 

### Composer list 
```bash
gcloud composer environments list --locations=asia-northeast3 --project=cloit-data-dev

```
### Data 추출
```bash 
gcloud composer environments list --project=cloit-data-dev  --locations=asia-northeast3 --format=yaml
```

### Import
**Script**
```bash
python3 /Users/sdk/IdeaProjects/opsman-terraform/vdkpi/migration/import_composer.py cloit-data-dev
```
**Manual**
```bash 
terraform import 'module.composer.module.composer["cloit-d-sub-data-analytics-an3"].google_composer_environment.composer_env' projects/cloit-data-dev/locations/asia-northeast3/environments/cloit-d-sub-data-analytics-an3 -var projects=cloit-data-dev
```

### All (composer, gce)
```bash
terraform plan
```

## Terraform Plan
```bash
terraform plan -target=module.composer
```



## Compute Instance (VM)

### Data 추출
```bash
gcloud compute instances list --project=cloit-data-dev  --format=yaml
```

## Terraform Import
```bash
python3 /Users/sdk/IdeaProjects/opsman-terraform/vdkpi/migration/import_gce_insatnce.py cloit-data-dev
```

### Terraform plan
```bash
terraform plan -target=module.composer
```




```bash
gcloud composer environments describe cloit-data-dev --location=asia-northeast3 --format=yaml
```

### Remove State 
```bash 
#terraform state rm "module.composer.module.composer\[cloit-d-data-cps-cn-demo-001\].google_composer_environment.composer_env"
terraform state rm 'module.composer.module.composer["cloit-d-data-cps-cn-demo-001"].google_composer_environment.composer_env'

```


terraform refresh
terraform init

TF_LOG=DEBUG terraform import 'module.composer.module.composer["cloit-d-sub-data-analytics-an3"].google_composer_environment.composer_env' projects/cloit-data-dev/locations/asia-northeast3/environments/cloit-d-sub-data-analytics-an3


