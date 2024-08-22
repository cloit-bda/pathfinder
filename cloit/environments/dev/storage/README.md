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

### Terraform Migrations (Import)
```bash
python3 migration/import_cloud_sql.py cloit-service-dev
```

```bash
terraform plan --target=module.mysql
```
