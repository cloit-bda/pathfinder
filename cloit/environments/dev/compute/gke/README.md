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


## GKE

### Data 추출
```bash
gcloud container clusters list --project=cloit-service-dev   --filter="name~^vdkpi" --format=yaml
```

```bash
gcloud container clusters describe  cloit-d-service-dive-gke-an3-001  --project=cloit-service-dev   #--filter="name~^vdkpi" --format=yaml
```

## Terraform Import
```bash
python3 /Users/sdk/IdeaProjects/opsman-terraform/vdkpi/migration/import_gke.py
```

### Terraform plan
```bash
terraform plan -target=module.gke
```



terraform refresh
terraform init



