import yaml

# Define the used keys
used_keys = {
    'deletionProtection',
    'disks',
    'labels',
    'machineType',
    'metadata.items',
    'name',
    'networkInterfaces',
    'scheduling.automaticRestart',
    'scheduling.onHostMaintenance',
    'scheduling.provisioningModel',
    'selfLink',
    'serviceAccounts',
    'shieldedInstanceConfig.enableIntegrityMonitoring',
    'shieldedInstanceConfig.enableVtpm',
    'shieldedInstanceConfig.enableSecureBoot',  # Added this field
    'tags.items',
    'zone'
}

def select_fields_from_path(target, paths):
    """Recursively select fields from the target dictionary based on the provided paths."""
    if not paths or not isinstance(target, (dict, list)):
        return target

    if isinstance(target, dict):
        result = {}
        for key in target.keys():
            remaining_paths = [p[len(key)+1:] for p in paths if p.startswith(key + ".")]
            if remaining_paths:
                result[key] = select_fields_from_path(target[key], remaining_paths)
            elif key in paths:
                result[key] = target[key]
        return result
    elif isinstance(target, list):
        return [select_fields_from_path(item, paths) for item in target]

# Load all documents from the provided original yaml file
with open("origin-cloit-service-dev.yaml", 'r') as file:
    origin_documents = list(yaml.safe_load_all(file))

# Filter the fields based on the updated used_keys
enhanced_filtered_documents = []
for doc in origin_documents:
    filtered_doc = select_fields_from_path(doc, used_keys)
    if 'labels' in doc:
        filtered_doc['labels'] = doc['labels']  # Ensure labels is retained if it exists in the original doc
    enhanced_filtered_documents.append(filtered_doc)

# Save the enhanced filtered documents to a new YAML file with the desired comment format
output_filename = "resource/cloit-service-dev.yaml"
with open(output_filename, 'w') as file:
    for idx, doc in enumerate(enhanced_filtered_documents):
        # Write the provided comment format before each document
        file.write("---\n")
        file.write("# JIRA Number : [여기에 JIRA 번호를 적어주세요]\n")
        file.write("# Description: [작업에 대한 간단한 설명을 적어주세요]\n")
        file.write("# 요청자 : [요청자의 이름을 적어주세요]\n\n")

        yaml.dump(doc, file, default_flow_style=False)
        if idx != len(enhanced_filtered_documents) - 1:
            file.write('\n')  # Separate documents with a newline, but not after the last one
