import yaml

# Load the content from gke.yaml file
def load_yaml_content(filepath):
    with open(filepath, "r") as file:
        content = file.read()
    return content

# Save the cleaned YAML content to a new file
def save_to_yaml_file(content, filepath):
    with open(filepath, "w") as file:
        file.write(content)

# Function to recursively remove unused keys from a dictionary
def remove_unused_keys(data, unused_keys_list, prefix=[]):
    if isinstance(data, dict):
        keys_to_delete = []
        for key, value in data.items():
            new_prefix = prefix + [key]
            full_key = ".".join(new_prefix)
            if full_key in unused_keys_list:
                keys_to_delete.append(key)
            else:
                remove_unused_keys(value, unused_keys_list, new_prefix)
        for key in keys_to_delete:
            del data[key]

if __name__ == '__main__':
    gke_yaml_content = load_yaml_content("resource/gke.yaml")

    # Parse the multiple YAML documents in the content
    gke_documents = [doc for doc in yaml.safe_load_all(gke_yaml_content) if doc]

    # List of unused keys (from the earlier analysis)
    unused_keys = ['addonsConfig.horizontalPodAutoscaling', 'monitoringConfig', ...]  # truncated for clarity

    # Apply the remove function to each document in the gke.yaml file
    for doc in gke_documents:
        remove_unused_keys(doc, unused_keys)

    # Convert the modified documents back to YAML format
    cleaned_yaml_content = "\\n---\\n".join([yaml.safe_dump(doc) for doc in gke_documents if doc])

    save_to_yaml_file(cleaned_yaml_content, "cleaned_gke.yaml")
