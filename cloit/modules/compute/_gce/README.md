
```
# [heredoc 사용 시 encording 주의]
# git 내용 그대로 terraform apply 적용 시 개행 부분에서 "/r" 이 포함되어
# startup 스크립트 정상 동작이 안됨 (개행 시 \n 만 포함되어야 하는데, \r\n 으로 입력됨)

/*
[예시]
정상 :
"value": "
#! /bin/bash\n
setenforce 0\n
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config\n
sed -i 's/#Port 22/Port 20022/g' /etc/ssh/sshd_config\n
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config\n
service sshd restart\n",
"key": "startup-script

비정상 :
"value": "
#! /bin/bash\r\n
setenforce 0\r\n
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config\r\n
sed -i 's/#Port 22/Port 20022/g' /etc/ssh/sshd_config\r\n
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config\r\n
service sshd restart\r\n",
"key": "startup-script"
*/

```


```
#resource "google_service_account_iam_binding" "gateway_service_account_iam" {
#  service_account_id = google_service_account.gateway_service_account.name
#  #roles               = ["roles/logging.logWriter","roles/monitoring.metricWriter"]
#  role               = "roles/logging.logWriter"
#  members            = ["serviceAccount:${google_service_account.gateway_service_account.email}"]
#  depends_on = [google_service_account.gateway_service_account]
#}

```