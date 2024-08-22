variable "path" {}

locals {
  gke_data_raw = [for doc in split("---", file(var.path)) : yamldecode(doc) if doc != ""]
  gke = [
    for doc in local.gke_data_raw : {
      cluster_name = doc.name
      project_id = split("/", doc.selfLink)[5]  # 프로젝트 ID 추출
      region = doc.location
      network = doc.networkConfig.network  # 경로를 분할하지 않습니다.
      subnetwork = doc.subnetwork
      master_ipv4_cidr = doc.privateClusterConfig.masterIpv4CidrBlock
      services_ipv4_cidr = doc.ipAllocationPolicy.servicesIpv4Cidr  # services IP range 추가
      cluster_ipv4_cidr = doc.ipAllocationPolicy.clusterIpv4Cidr  # cluster IP range 추가
      cluster_secondary_range_name = doc.ipAllocationPolicy.clusterSecondaryRangeName  # Pod IP range name 추가
      services_secondary_range_name = doc.ipAllocationPolicy.servicesSecondaryRangeName  # Service IP range name 추가
      node_pools = [
        for pool in doc.nodePools : {
          name = pool.name
          machine_type = pool.config.machineType
          disk_size_gb = pool.config.diskSizeGb
          image_type = pool.config.imageType
          service_account = pool.config.serviceAccount
          tags = pool.config.tags
#          initial_node_count = pool.initialNodeCount

          autoscaling = {
            enabled         = try(pool.autoscaling.enabled, false),
            min_node_count  = try(pool.autoscaling.minNodeCount, 0),
            max_node_count  = try(pool.autoscaling.maxNodeCount, 0)
          }
        }
      ]
      resource_labels = {
        component          = doc.resourceLabels.component
        name               = doc.resourceLabels.name
        owner              = doc.resourceLabels.owner
        sec_assets_gateway = doc.resourceLabels.sec_assets_gateway == "y" ? "y" : "n"
        sec_assets_pii     = doc.resourceLabels.sec_assets_pii == "y" ? "y" : "n"
        service            = doc.resourceLabels.service
        stage              = doc.resourceLabels.stage
      }

    }
  ]
}

resource "google_container_cluster" "primary" {
  for_each = {for cluster in local.gke : cluster.cluster_name => cluster}

  name     = each.value.cluster_name
  location = each.value.region
  project  = each.value.project_id
  network  = each.value.network  # 실제 GCP에서 사용하는 네트워크 경로로 설정합니다.

  ip_allocation_policy {
    cluster_ipv4_cidr_block = each.value.cluster_ipv4_cidr
    services_ipv4_cidr_block = each.value.services_ipv4_cidr
  }

  resource_labels = {
    component          = each.value.resource_labels.component
    name               = each.value.resource_labels.name
    owner              = each.value.resource_labels.owner
    sec_assets_gateway = each.value.resource_labels.sec_assets_gateway
    sec_assets_pii     = each.value.resource_labels.sec_assets_pii
    service            = each.value.resource_labels.service
    stage              = each.value.resource_labels.stage
  }
}

resource "google_container_node_pool" "primary" {
  for_each = {for cluster in local.gke : cluster.cluster_name => cluster}

  name     = each.value.node_pools[0].name
  location = each.value.region
  cluster  = google_container_cluster.primary[each.key].name

  node_config {
    machine_type = each.value.node_pools[0].machine_type
    disk_size_gb = each.value.node_pools[0].disk_size_gb
    image_type   = each.value.node_pools[0].image_type

    # Handle optional tags
    tags = each.value.node_pools[0].tags != null ? each.value.node_pools[0].tags : []

    service_account = each.value.node_pools[0].service_account

  }

  dynamic "autoscaling" {
    for_each = each.value.node_pools[0].autoscaling.enabled ? [each.value.node_pools[0].autoscaling] : []
    content {
      min_node_count = autoscaling.value.min_node_count
      max_node_count = autoscaling.value.max_node_count
    }
  }

#  initial_node_count = each.value.node_pools[0].initial_node_count
}



# cluster_secondary_range_name = each.value.cluster_secondary_range_name
# services_secondary_range_name = each.value.services_secondary_range_name
