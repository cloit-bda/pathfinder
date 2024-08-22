
# Authentication
### Google Cloud Login
```bash
gcloud auth login
```
### application-default login
```bash 
gcloud auth application-default login
```


#  Security
## Service Account
### Initialize Terraform
```bash
cd environments/dev/security
terraform init
```
### Terraform State list
```bash
cd environments/dev/security
terraform state list
```
### Gcloud Command to yaml
```bash
gcloud iam service-accounts list --project=cloit-data-dev --format="yaml"      
```
```bash
gcloud iam service-accounts list --project=cloit-data-dev --format="yaml(name,description,displayName,email,projectId)"      
```
### Verify yaml
```bash
cat environments/dev/security/serviceaccount/cloit-data-dev.yaml
```
### Terraform Migrations (Import)
```bash
python3 migration/import_service_account.py 
```
### Terraform Plan
```bash
cd environments/dev/security
terraform plan -target=module.service_account -var project_id=cloit-data-dev 
```
### Terraform Apply
```bash
#terraform apply -target=module.service_account -var project_id=cloit-data-dev 
```
### Bucket State
```bash
gsutil cat gs://cloit-d-host-cs-terraform-state/terraform/state/dev/security/default.tfstate
```
### Terraform show
```bash
cd environments/dev/security
terraform show
```


# IAM
## IAM Binding
### Initialize Terraform
```bash
cd environments/dev/iam
terraform init
```
### Terraform State list
```bash
cd environments/dev/iam
terraform state list
```
### Gcloud Command to yaml
```bash
gcloud projects get-iam-policy cloit-host-dev --flatten="bindings[].members" --format="table(bindings.members:sort=1,bindings.role:sort=1)"
```
```bash
gcloud projects get-iam-policy cloit-data-dev --flatten="bindings[].members" --format="yaml(bindings.members,bindings.role)"  > cloit-data-dev.yaml
```
### Verify yaml
```bash
cat environments/dev/iam/projects_iam/cloit-host-dev.yaml
```
### Terraform Migrations (Import)
**cloit-host-dev.yaml**
```bash
python3 migration/import_member_iam.py cloit-host-dev
```
**cloit-ingest-dev.yaml**
```bash
python3 migration/import_member_iam.py cloit-ingest-dev
```
**cloit-data-dev.yaml**
```bash
python3 migration/import_member_iam.py cloit-data-dev
```
**cloit-service-dev.yaml**
```bash
python3 migration/import_member_iam.py cloit-service-dev
```
### Workspace 사용
```bash
cd environments/dev/iam
terraform workspace new cloit-host-dev
terraform workspace new cloit-ingest-dev
terraform workspace new cloit-data-dev
terraform workspace new cloit-service-dev
```

### Terraform Plan
**cloit-host-dev.yaml**
```bash
cd environments/dev/iam
terraform workspace select cloit-host-dev
terraform plan -target=module.iam_member -var project_id=cloit-host-dev
```
**cloit-data-dev.yaml**
```bash
cd environments/dev/iam
terraform workspace select cloit-data-dev
terraform plan -target=module.iam_member -var project_id=cloit-data-dev
```
**cloit-service-dev.yaml**
```bash
cd environments/dev/iam
terraform workspace select cloit-service-dev
terraform plan -target=module.iam_member -var project_id=cloit-service-dev
```
**cloit-ingest-dev.yaml**
```bash
cd environments/dev/iam
terraform workspace select cloit-ingest-dev
terraform plan -target=module.iam_member -var project_id=cloit-ingest-dev
```

### Terraform Apply
```bash
cd environments/dev/iam
#terraform apply -target=module.iam_member -var project_id=cloit-host-dev
```
### Bucket State
```bash
gsutil cat gs://cloit-d-host-cs-terraform-state/terraform/state/dev/iam/default.tfstate
```
### Terraform show
```bash
cd environments/dev/iam
terraform show
```

### Bucket State rm
```bash
gsutil rm gs://cloit-d-host-cs-terraform-state/terraform/state/dev/iam/default.tfstate
```

# Network
## VPC
### Initialize Terraform
```bash
cd environments/dev/networks
terraform init
```
### Terraform State list
```bash
cd environments/dev/networks
terraform state list
```
### Verify yaml
```bash
cat environments/dev/networks/resource/vpc.yaml
```
### Terraform Migrations (Import)
```bash
python3 migration/import_vpc.py cloit-host-dev
```
```bash
cd environments/dev/networks
terraform import "module.vpc.module.vpc[\"cloit-d-host-vpc\"].google_compute_shared_vpc_host_project.shared_vpc_host[0]" cloit-host-dev
```
### Terraform Plan
```bash
cd environments/dev/networks
terraform plan -target=module.vpc #-var project_id=cloit-host-dev 
```
### Terraform Apply
```bash
cd environments/dev/networks
#terraform apply -target=module.vpc
```
### Bucket State
```bash
gsutil cat gs://cloit-d-host-cs-terraform-state/terraform/state/dev/networks/default.tfstate
```
### Terraform show
```bash
cd environments/dev/networks
terraform show
```

## Subnetwork
### Initialize Terraform
```bash
cd environments/dev/networks
terraform init
```
### Terraform State list
```bash
cd environments/dev/networks
terraform state list
```
### Verify yaml
```bash
cat environments/dev/networks/resource/subnets.yaml
```
### Terraform Migrations (Import)
```bash
python3 migration/import_subnets.py cloit-host-dev
```
```bash
cd environments/dev/networks
terraform import "module.vpc.module.vpc[\"cloit-d-host-vpc\"].google_compute_shared_vpc_host_project.shared_vpc_host[0]" cloit-host-dev
```
### Terraform Plan
```bash
cd environments/dev/networks
terraform plan -target=module.vpc #-var project_id=cloit-host-dev 
```
### Terraform Apply
```bash
cd environments/dev/networks
#terraform apply -target=module.vpc
```
### Bucket State
```bash
gsutil cat gs://cloit-d-host-cs-terraform-state/terraform/state/dev/networks/default.tfstate
```
### Terraform show
```bash
cd environments/dev/networks
terraform show
```




### Bucket State rm
```bash
gsutil rm gs://cloit-d-host-cs-terraform-state/terraform/state/dev/networks/default.tfstate
```
## Shared VPC
### Initialize Terraform
```bash
cd environments/dev/networks
terraform init
```
### Terraform State list
```bash
cd environments/dev/networks
terraform state list
```
### Verify yaml
```bash
cat environments/dev/networks/resource/shared_vpc.yaml
```
### Terraform Migrations (Import)
```bash
python3 migration/import_shared_vpc.py --project_id cloit-host-dev
```
```bash
cd environments/dev/networks
terraform import module.shared_vpc.google_compute_shared_vpc_host_project.host cloit-host-dev
```
### Terraform Plan
```bash
cd environments/dev/networks
terraform plan -target=module.shared_vpc #-var project_id=cloit-host-dev 
```
### Terraform Apply
```bash
cd environments/dev/networks
#terraform apply -target=module.shared_vpc
```
### Bucket State
```bash
gsutil cat gs://cloit-d-host-cs-terraform-state/terraform/state/dev/networks/default.tfstate
```
### Terraform show
```bash
cd environments/dev/networks
terraform show
```

### Bucket State rm
```bash
gsutil rm gs://cloit-d-host-cs-terraform-state/terraform/state/dev/networks/default.tfstate
```

## Firewall
### Initialize Terraform
```bash
cd environments/dev/networks
terraform init
```
### Terraform State list
```bash
cd environments/dev/networks
terraform state list
```
### Gcloud Command to yaml
```bash
gcloud compute firewall-rules list --format=yaml
```
### Verify yaml
```bash
cat environments/dev/networks/resource/firewall.yaml
```
### Terraform Migrations (Import)
```bash
python3 migration/import_firewalls.py --project_id cloit-host-dev
```
### Terraform Plan
```bash
cd environments/dev/networks
terraform plan -target=module.firewall
```
### Terraform Apply
```bash
cd environments/dev/networks
terraform apply -target=module.firewall
```
### Bucket State
```bash
gsutil rm gs://cloit-d-host-cs-terraform-state/terraform/state/dev/networks/default.tfstate
```
### Terraform show
```bash
cd environments/dev/networks
terraform show
```

## DNS
### Initialize Terraform
```bash
cd environments/dev/networks
terraform init
```
### Terraform State list
```bash
cd environments/dev/networks
terraform state list
```
### Gcloud Command to yaml
### Verify yaml
```bash
cat environments/dev/networks/resource/dns.yaml
```
### Terraform Migrations (Import)
```bash
python3 migration/import_dns.py --project_id cloit-host-dev
```
```bash
python3 migration/bk_import_dns.py --project_id cloit-host-dev
```
### Terraform Plan
```bash
cd environments/dev/networks
terraform plan -target=module.dns
```
### Terraform Apply
```bash
cd environments/dev/networks
#terraform apply -target=module.firewall
```
### Bucket State
```bash
gsutil rm gs://cloit-d-host-cs-terraform-state/terraform/state/dev/networks/default.tfstate
```
### Terraform show
```bash
cd environments/dev/networks
terraform show
```

## Router
### Initialize Terraform
```bash
cd environments/dev/networks
terraform init
```
### Terraform State list
```bash
cd environments/dev/networks
terraform state list
```
### Gcloud Command to yaml
```bash
gcloud compute routers list
```
### Verify yaml
```bash
cat environments/dev/networks/resource/routers.yaml
```
### Terraform Migrations (Import)
```bash
cd environments/dev/networks
terraform import "module.router.google_compute_router.router" projects/cloit-host-dev/regions/asia-northeast3/routers/cloit-d-host-rou-internet
```
### Terraform Plan
```bash
cd environments/dev/networks
terraform plan -target=module.routes
```
### Terraform Apply
```bash
cd environments/dev/networks
#terraform apply -target=module.routes
```
### Bucket State
```bash
gsutil rm gs://cloit-d-host-cs-terraform-state/terraform/state/dev/networks/default.tfstate
```
### Terraform show
```bash
cd environments/dev/networks
terraform show
```

## Routes
### Initialize Terraform
```bash
cd environments/dev/networks
terraform init
```
### Terraform State list
```bash
cd environments/dev/networks
terraform state list
```
### Gcloud Command to yaml
```bash
gcloud compute routers list
```
### Verify yaml
```bash
cat environments/dev/networks/resource/route.yaml
```
### Terraform Migrations (Import)
```bash
cd environments/dev/networks
terraform import "module.router.google_compute_router.router" projects/cloit-host-dev/regions/asia-northeast3/routers/cloit-d-host-rou-internet
```
### Terraform Plan
```bash
cd environments/dev/networks
terraform plan -target=module.routes
```
### Terraform Apply
```bash
cd environments/dev/networks
#terraform apply -target=module.routes
```
### Bucket State
```bash
gsutil rm gs://cloit-d-host-cs-terraform-state/terraform/state/dev/networks/default.tfstate
```
### Terraform show
```bash
cd environments/dev/networks
terraform show
```


## IP Address
### Initialize Terraform
```bash
cd environments/dev/networks
terraform init
```
### Terraform State list
```bash
cd environments/dev/networks
terraform state list
```
### Gcloud Command to yaml
```bash
gcloud compute addresses list --filter="global"
```
### Verify yaml
```bash
cat environments/dev/networks/resource/static_ip.yaml
```
```bash
gcloud compute addresses list 
```
```bash
gcloud compute addresses list --filter="region:(asia-northeast3)"
```
### Terraform Migrations (Import)
```bash
python3 migration/import_static_ip.py cloit-host-dev
```
```bash
cd environments/dev/networks
terraform import module.nat.google_compute_router_nat.cloud_nat projects/cloit-host-dev/regions/asia-northeast3/routers/cloit-d-host-rou-internet/nats/cloit-d-host-nat-an3
```
```bash
cd environments/dev/networks
terraform import 'module.nat.google_compute_router_nat.cloud_nat["cloit-d-host-nat-an3"]' projects/cloit-host-dev/regions/asia-northeast3/routers/cloit-d-host-rou-internet/nats/cloit-d-host-nat-an3
```

```bash
terraform import 'module.nat.google_compute_router_nat.cloud_nat["cloit-d-host-nat-an3"]' projects/cloit-host-dev/regions/asia-northeast3/routers/cloit-d-host-rou-internet/cloit-d-host-nat-an3

```
## IP Import
```bash
cd environments/dev/networks
terraform import module.static_ip.google_compute_address.static_ips["cloit-d-host-eip-nat-an3"]  projects/cloit-host-dev/regions/asia-northeast3/addresses/cloit-d-host-eip-nat-an3
```

```bash
```
### Terraform Plan
```bash
cd environments/dev/networks
terraform plan -target=module.vpc #-var project_id=cloit-host-dev 
```
### Terraform Apply
```bash
cd environments/dev/networks
#terraform apply -target=module.vpc
```
### Bucket State
```bash
gsutil cat gs://cloit-d-host-cs-terraform-state/terraform/state/dev/networks/default.tfstate
```
### Terraform show
```bash
cd environments/dev/networks
terraform show
```


## Cloud NAT
### Initialize Terraform
```bash
cd environments/dev/networks
terraform init
```
### Terraform State list
```bash
cd environments/dev/networks
terraform state list
```
### Gcloud Command to yaml
```bash
gcloud compute routers nats list --router cloit-d-host-rou-internet
```
```bash
gcloud compute routers nats describe cloit-d-host-nat-an3 --router=cloit-d-host-rou-internet --format=yaml
```
### Verify yaml
```bash
cat environments/dev/networks/resource/nat.yaml
```

### Terraform Migrations (Import)
```bash
python3 migration/import_cloud_nat.py cloit-host-dev
```
```bash
cd environments/dev/networks
terraform import module.nat.google_compute_router_nat.cloud_nat projects/cloit-host-dev/regions/asia-northeast3/routers/cloit-d-host-rou-internet/nats/cloit-d-host-nat-an3
```


terraform import 'module.nat.google_compute_router_nat.cloud_nat["cloit-d-host-nat-an3"]' projects/cloit-host-dev/regions/asia-northeast3/routers/cloit-d-host-rou-internet/nats/cloit-d-host-nat-an3

```bash
cd environments/dev/networks
terraform import module.nat.google_compute_router_nat.cloud_nat projects/cloit-host-dev/regions/asia-northeast3/routers/cloit-d-host-rou-internet/nats/cloit-d-host-nat-an3
```
### Terraform Plan
```bash
cd environments/dev/networks
terraform plan -target=module.nat  
```
### Terraform Apply
```bash
cd environments/dev/networks
#terraform apply -target=module.vpc
```
### Bucket State
```bash
gsutil cat gs://cloit-d-host-cs-terraform-state/terraform/state/dev/networks/default.tfstate
```
### Terraform show
```bash
cd environments/dev/networks
terraform show
```
### Bucket State rm
```bash
terraform state rm module.nat.google_compute_router_nat.cloud_nat
```

## Private Service Connect & peering
### Initialize Terraform
```bash
cd environments/dev/networks
terraform init
```
### Terraform State list
```bash
cd environments/dev/networks
terraform state list
```
### Gcloud Command to yaml
private service connect
```bash
gcloud services vpc-peerings list --network=cloit-d-host-vpc --project=cloit-host-dev
```
peering
```bash
gcloud services vpc-peerings list --network=cloit-d-host-vpc --project=cloit-host-dev
```
### Verify yaml
```bash
cat environments/dev/networks/resource/private_connection.yaml
```

### Terraform Migrations (Import)
```bash
python3 migration/import_private_connection.py cloit-host-dev
```
```bash
cd environments/dev/networks
terraform import module.nat.google_compute_router_nat.cloud_nat projects/cloit-host-dev/regions/asia-northeast3/routers/cloit-d-host-rou-internet/nats/cloit-d-host-nat-an3
```
```bash
cd environments/dev/networks
terraform import module.nat.google_compute_router_nat.cloud_nat projects/cloit-host-dev/regions/asia-northeast3/routers/cloit-d-host-rou-internet/nats/cloit-d-host-nat-an3
```
### Terraform Plan
```bash
cd environments/dev/networks
terraform plan -target=module.vpc #-var project_id=cloit-host-dev 
```
### Terraform Apply
```bash
cd environments/dev/networks
#terraform apply -target=module.vpc
```
### Bucket State
```bash
gsutil cat gs://cloit-d-host-cs-terraform-state/terraform/state/dev/networks/default.tfstate
```
### Terraform show
```bash
cd environments/dev/networks
terraform show
```
### Bucket State rm
```bash
terraform state rm module.nat.google_compute_router_nat.cloud_nat
```

## 
# Compute
## GCE
### Initialize Terraform
```bash
cd environments/dev/compute/instance

terraform init
```
### Terraform State list
```bash
cd environments/dev/compute 
terraform state list
```
### Gcloud Command to yaml
```bash
gcloud compute instances list --format=yaml --project=cloit-data-dev
```
### Verify yaml
```bash
cat environments/dev/compute/instance/cloit-data-dev.yaml
```
### Terraform Migrations (Import)
```bash
python3 migration/import_gce_insatnce.py cloit-host-dev
```
### Terraform Plan
```bash
cd environments/dev/compute/instance
terraform workspace select cloit-data-dev
terraform plan -target module.gce -var project_id=cloit-data-dev
```
```bash
cd environments/dev/compute/instance
terraform workspace select cloit-ingest-dev
terraform plan -target module.gce -var project_id=cloit-ingest-dev
```
```bash
cd environments/dev/compute/instance
terraform workspace select cloit-service-dev
terraform plan -target module.gce -var project_id=cloit-service-dev
```
```bash
cd environments/dev/compute

terraform plan -target module.gce -var project_id=cloit-data-dev
```
### Terraform Apply
```bash
cd environments/dev/compute
#terraform apply -target module.gce -var project_id=cloit-data-dev
```
### Bucket State
```bash
gsutil cat gs://cloit-d-host-cs-terraform-state/terraform/state/dev/compute/default.tfstate
```
### Terraform show
```bash
cd environments/dev/compute
terraform show
```

## Composer
### Initialize Terraform
```bash
cd environments/dev/compute
terraform init
```
### Terraform State list
```bash
cd environments/dev/compute 
terraform state list
```
### Gcloud Command to yaml
```bash
gcloud composer environments list --project=cloit-data-dev  --locations=asia-northeast3 --format=yaml
```
### Verify yaml
```bash
cat environments/dev/compute/resource/composer.yaml
```
### Terraform Migrations (Import)
```bash
python3 migration/import_composer.py cloit-data-dev
```
### Terraform Plan
```bash
cd environments/dev/compute
terraform plan -target module.composer -var project_id=cloit-data-dev
```
### Terraform Apply
```bash
cd environments/dev/compute
#terraform apply -target module.gce -var project_id=cloit-data-dev
```
### Bucket State
```bash
gsutil cat gs://cloit-d-host-cs-terraform-state/terraform/state/dev/compute/default.tfstate
```
### Terraform show
```bash
cd environments/dev/compute
terraform show
```

# Storage
## Cloud SQL
### Initialize Terraform
```bash
cd environments/dev/storage
terraform init
```
### Terraform State list
```bash
cd environments/dev/storage
terraform state list
```
### Gcloud Command to yaml
```bash
gcloud sql instances list --project=cloit-service-dev --format=yaml
```
### Verify yaml
```bash
cat environments/dev/storage/resource/sql.yaml
```
### Terraform Migrations (Import)
```bash
python3 migration/import_cloud_sql.py cloit-service-dev
```
### Terraform Plan
```bash
terraform plan -target=module.mysql  
```
### Terraform Apply
```bash
# terraform apply -target=module.mysql -var project_id=cloit-service-dev 
```
### Bucket State
```bash
gsutil cat gs://cloit-d-host-cs-terraform-state/terraform/state/dev/storage/default.tfstate
```
### Terraform show
```bash
cd environments/dev/security
terraform show
```

## Bucket
### Initialize Terraform
```bash
cd environments/dev/security
terraform init
```
### Terraform State list
```bash
cd environments/dev/security
terraform state list
```
### Gcloud Command to yaml
```bash
```
### Verify yaml
```bash
cat environments/dev/security/serviceaccount/cloit-data-dev.yaml
```
### Terraform Migrations (Import)
```bash

```
### Terraform Plan
```bash

```
### Terraform Apply
```bash
#
```
### Bucket State
```bash
gsutil cat gs://cloit-d-host-cs-terraform-state/terraform/state/default.tfstate
```
### Terraform show
```bash
cd environments/dev/security
terraform show
```



# 남은 작업
* GKE
* 