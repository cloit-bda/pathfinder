# Terraform 프로바이더 설정 (google)
provider "google" {
  credentials = file("C:/Users/Admin/Downloads/first-project-hskim-a74945d4eebc.json")
  region = "northeast3"
  project = "first-project-hskim"
}

# VPC 네트워크 정의
resource "google_compute_network" "vpc-difinition" {
  name = "hskim-vpc"
  auto_create_subnetworks = false
  # project = "first-project-hskim"
}

# 서브넷 정의
resource "google_compute_subnetwork" "subnet-difinition" {
  name          = "hskim-subnet"
  network       = google_compute_network.vpc-difinition.id
  region        = "asia-northeast3"
  ip_cidr_range  = "10.0.1.0/24"
  
  secondary_ip_range = [{
    range_name = "gke-service-pod"
    ip_cidr_range = "10.100.64.0/18"
  },
  {
    range_name = "gke-service-service"
    ip_cidr_range = "10.10.16.0/20"
  }]

  private_ip_google_access = true
}

# # DNS 정의(Cloud DNS API Enabled 해야함)
# resource "google_dns_managed_zone" "hskim_appspot" {
#   name        = "hskim-dns-appspot"
#   dns_name    = "appspot.com."
#   #description = "A managed DNS zone for example.com"

#   visibility = "private"

#   private_visibility_config {
#     networks {
#       network_url = "projects/first-project-hskim/global/networks/hskim-vpc"
#     }
#   }
# }

# resource "google_dns_record_set" "hskim_appspot" {
#   name = "appspot.com."
#   managed_zone = google_dns_managed_zone.hskim_appspot.name
#   type = "A"
#   ttl  = 300

#   rrdatas = [
#     "199.36.153.10",
#     "199.36.153.11",
#     "199.36.153.8",
#     "199.36.153.9"
#   ]
# }

# resource "google_dns_managed_zone" "hskim_appengine" {
#   name        = "hskim-dns-appengine"
#   dns_name    = "appengine.google.com."
#   #description = "A managed DNS zone for example.com"

#   visibility = "private"

#   private_visibility_config {
#     networks {
#       network_url = "projects/first-project-hskim/global/networks/hskim-vpc"
#     }
#   }
# }

# resource "google_dns_record_set" "hskim_appengine" {
#   name = "appengine.google.com."
#   managed_zone = google_dns_managed_zone.hskim_appengine.name
#   type = "A"
#   ttl  = 300

#   rrdatas = [
#     "199.36.153.10",
#     "199.36.153.11",
#     "199.36.153.8",
#     "199.36.153.9"
#   ]
# }

# resource "google_dns_managed_zone" "hskim_packages" {
#   name        = "hskim-dns-packages"
#   dns_name    = "packages.cloud.google.com."
#   #description = "A managed DNS zone for example.com"

#   visibility = "private"

#   private_visibility_config {
#     networks {
#       network_url = "projects/first-project-hskim/global/networks/hskim-vpc"
#     }
#   }
# }

# resource "google_dns_record_set" "hskim_packages" {
#   name = "packages.cloud.google.com."
#   managed_zone = google_dns_managed_zone.hskim_packages.name
#   type = "A"
#   ttl  = 300

#   rrdatas = [
#     "199.36.153.10",
#     "199.36.153.11",
#     "199.36.153.8",
#     "199.36.153.9"
#   ]
# }

# # 방화벽 규칙 정의
# resource "google_compute_firewall" "firewall_difinition" {
#   name    = "hskim-deny-all"
#   network = google_compute_network.vpc-difinition.name
#   description = "[SEC-BDA-FW-Rule] - (기간 제한 없음) VPC의 VM들에서 외부로 나가는 Egress 트래픽 전부 차단(Deny ALL)"

#   priority = 65534

#   deny {
#     protocol = "all"
#     # ports    = ["all"]
#   }

#   destination_ranges = ["0.0.0.0/0"]
#   direction = "EGRESS"
# }

# resource "google_compute_firewall" "firewall_difinition2" {
#   name    = "hskim-internal-out-allow"
#   network = google_compute_network.vpc-difinition.name
#   description = "[SEC-BDA-FW-Rule] - (기간 제한 없음) VPC의 VM 간 및 GCP 내부 서비스 VM 간 Internal 통신을 위한 Egress 트래픽 허용"

#   priority = 60000

#   allow {
#     protocol = "tcp"
#     ports    = ["1-65535"]
#   }

#   destination_ranges = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16", "224.0.0.252/32"]
#   direction = "EGRESS"
# }

# resource "google_compute_firewall" "firewall_difinition3" {
#   name    = "hskim-sec-googleapi-out-allow-443"
#   network = google_compute_network.vpc-difinition.name
#   description = "[SEC-BDA-FW-Rule] - VPC의 VM에서 Google Cloud API 호출을 위한 Egress IP 대역 허용"

#   priority = 10000

#   allow {
#     protocol = "tcp"
#     ports    = ["443"]
#   }

#   destination_ranges = ["199.36.153.8/30"]
#   direction = "EGRESS"
# }

# resource "google_compute_firewall" "firewall_difinition4" {
#   name    = "hskim-sec-sec-bastion-out-deny-all"
#   network = google_compute_network.vpc-difinition.name
#   description = "[SEC-BDA-FW-Rule] - GCP의 bastion VM에서 VPC의 모든 VM으로 Engrss 전체 차단"

#   priority = 9999

#   deny {
#     protocol = "all"
#   }

#   destination_ranges = ["0.0.0.0/0"]
#   target_tags = ["hskim-net-bastion", "hskim-net-db-bastion"]

#   direction = "EGRESS"
# }

resource "google_compute_firewall" "firewall_difinition5" {
  name    = "hskim-sec-bastion-in-allow-2022"
  network = google_compute_network.vpc-difinition.name
  description = "[SEC-BDA-FW-Rule] - 수원사업장(210.94.41.89/32)에서 bastion VM  SSH 접속 Ingress 통신 허용"

  priority = 1000

  allow {
    protocol = "tcp"
    ports = ["22","2022"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["hskim-net-bastion"]

  direction = "INGRESS"
}


# VM 인스턴스 리소스 정의
resource "google_compute_instance" "my_instance" {
  name         = "hskim-instance"
  machine_type = "n1-standard-2"  # 원하는 머신 타입
  zone         = "asia-northeast3-a" # 원하는 존

  boot_disk {
    initialize_params {
      # Image List 방법 $ gcloud compute images list --project=first-project-hskim
      image = "rocky-linux-cloud/rocky-linux-8-optimized-gcp-v20240717" # 기본 이미지
      type = "pd-standard" # 이미지 타입 pd-standard, pd-ssd, pd-balanced
      size = 50 # 단위 GB
    }
  }

  network_interface {
    network = google_compute_network.vpc-difinition.id
    subnetwork = google_compute_subnetwork.subnet-difinition.id
    access_config {} # ExternalIP 부분
    
  }

  tags = ["hskim-net-bastion"] # Network Tag 추가

  labels = {
    hskim = "test"
  }
  
  service_account {
    email = "gcp-terraform-account@first-project-hskim.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    # scopes = ["https://www.googleapis.com/auth/cloud-platform.read-only",
    # "https://www.googleapis.com/auth/logging.write",
    # "https://www.googleapis.com/auth/monitoring.write",
    # "https://www.googleapis.com/auth/pubsub",
    # "https://www.googleapis.com/auth/service.management.readonly",
    # "https://www.googleapis.com/auth/servicecontrol",
    # "https://www.googleapis.com/auth/trace.append"]
  }

    metadata = {
    # ssh-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQChg5ihMjks3vcfQii4NfVkqirM5yDQCKrNiYyBkj1Qkm0Ip3wNNj1NBzl/lg1aCjabvbrFfAKDFqZZsM4zVMbT8QcDQ8rmrPo/QgIGmFh/QLIZpF35jPtvZzcxEsMMvALDXjAJ9RNcq83Z7+7FLxpM4vz0siw3P+yjxAjiMgpfm7uun5A5mrxYohHwixAwXvqZ/vvBZdlGEq3wT/Y4sOhMjg87c3kPGuDchDSkukQE+Lz5iUnqDdL8z4XPvxCZxlNdt9xVxY6qtmwlolBVxNC1fOc0sy2T9SZEHg9OimQQex+vEhJQ5O3jlmVIqclZ1TbfSg5tBbalZtcAWdG49cH5oC5SlM/g9yArKJ/ubXPArPaIOAdgl5+yYcGh51r+7z7kwJD5rffxqj4dvYMIFO5Vvhab93Wlyb2YOoAFsXy/Ct5CSgGPsyHgIqoaUOZlwdQCHhgE3/Wmz5WvTf8fsjty+74ca8zMyhcth6iFfEDMeiKZajlNdTyvmdNTsBdmJ0k= hskim"
  
    startup-script = <<-EOF
      #!/bin/bash
      sed -i 's/#Port 22/Port 2022/g' /etc/ssh/sshd_config
      sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
      setenforce 0
      sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
      service sshd restart
      systemctl restart sshd
      EOF
  }
}


# Project 리소스 정의
# variable "project_id" {
#   description = "This ID is new Project ID"
#   type = string
# }

# resource "google_project" "testhskim" {
#   name = "testhskim"
#   project_id = var.project_id
# }

# Shared VPC
# resource "google_compute_shared_vpc_host_project" "hskim-first-project" {
#   project = "first-project-hskim"
# }

# resource "google_compute_shared_vpc_service_project" "hskim-second-project" {
#   service_project = "second-project-hskim"
#   host_project = "first-project-hskim"
# }