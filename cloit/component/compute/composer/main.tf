variable "path" {}

locals {
  composer_data_raw = [for doc in split("---", file(var.path)) : yamldecode(doc) if doc != ""]
  composer          = [
    for doc in local.composer_data_raw : {
      environment_name = doc.config.environmentName
      project_id       = doc.config.projectId
      host_project_id  = doc.config.hostProjectId
      image_version    = doc.config.softwareConfig.imageVersion
      network          = doc.config.nodeConfig.network
      subnets          = [
        {
          subnet_name = split("/", doc.config.nodeConfig.subnetwork)[length(split("/", doc.config.nodeConfig.subnetwork)) - 1]
          subnet_cidr = doc.config.privateEnvironmentConfig.cloudComposerNetworkIpv4CidrBlock
        }
      ]
      secondary_ranges = [
        {
          range_name    = doc.config.nodeConfig.ipAllocationPolicy.clusterSecondaryRangeName
          ip_cidr_range = doc.config.privateEnvironmentConfig.cloudSqlIpv4CidrBlock
        },
        {
          range_name    = doc.config.nodeConfig.ipAllocationPolicy.servicesSecondaryRangeName
          ip_cidr_range = doc.config.privateEnvironmentConfig.privateClusterConfig.masterIpv4CidrBlock
        }
      ]
      tags      = doc.config.nodeConfig.tags
      scheduler = {
        count      = doc.config.workloadsConfig.scheduler.count
        cpu        = doc.config.workloadsConfig.scheduler.cpu
        memory_gb  = doc.config.workloadsConfig.scheduler.memoryGb
        storage_gb = doc.config.workloadsConfig.scheduler.storageGb
      }
      web_server = {
        cpu        = doc.config.workloadsConfig.webServer.cpu
        memory_gb  = doc.config.workloadsConfig.webServer.memoryGb
        storage_gb = doc.config.workloadsConfig.webServer.storageGb
      }
      worker = {
        cpu        = doc.config.workloadsConfig.worker.cpu
        memory_gb  = doc.config.workloadsConfig.worker.memoryGb
        storage_gb = doc.config.workloadsConfig.worker.storageGb
        min_count  = doc.config.workloadsConfig.worker.minCount
        max_count  = doc.config.workloadsConfig.worker.maxCount
      }
      master_ipv4_cidr = doc.config.privateEnvironmentConfig.privateClusterConfig.masterIpv4CidrBlock
      pypi_packages    = doc.config.softwareConfig.pypiPackages
      environment_size = doc.config.environmentSize
      serviceAccount   = doc.config.nodeConfig.serviceAccount
      workloads_config = doc.config.workloadsConfig
    }
  ]
}

module "composer" {
  for_each = {for env in local.composer : env.environment_name => env}

  source                           = "../../../modules/composer/create_environment_v2"
  project_id                       = each.value.project_id
  network_project_id               = "cloit-host-dev"
  composer_env_name                = each.value.environment_name
  image_version                    = each.value.image_version
  region                           = "asia-northeast3"
  composer_service_account         = each.value.serviceAccount
  network                          = split("/", each.value.network)[4]
  subnetwork                       = each.value.subnets[0].subnet_name
  pod_ip_allocation_range_name     = each.value.secondary_ranges[0].range_name
  service_ip_allocation_range_name = each.value.secondary_ranges[1].range_name
  grant_sa_agent_permission        = true
  use_private_environment          = true
  enable_private_endpoint          = true
  environment_size                 = each.value.environment_size
  tags                             = each.value.tags
  scheduler                        = each.value.scheduler
  web_server                       = each.value.web_server
  worker                           = each.value.worker
  master_ipv4_cidr                 = each.value.master_ipv4_cidr
  pypi_packages                    = each.value.pypi_packages
#  workloads_config                 = each.value.workloads_config
}

