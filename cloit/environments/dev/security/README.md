# Terraform Migrations
##  Service Account
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

```bash
terraform plan
```




### Gcloud Command to yaml
```bash
gcloud iam service-accounts list --project=cloit-data-dev --format="yaml"      
```
```bash
gcloud iam service-accounts list --project=cloit-service-dev --filter="email~^vdkpi" --format="yaml(name,description,displayName,email,projectId)"  >> serviceaccount.yaml
```


terraform state rm 'module.service_account.google_service_account.service_account["cloit-data-dev"]'



