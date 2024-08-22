gcloud auth application-default login
gcloud compute firewall-rules list --format=json > firewall_rules.json
python3 firewall_convert.py


gcloud compute firewall-rules list --format=yaml