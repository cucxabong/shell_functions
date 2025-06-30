# Shell Functions for Kubernetes Pod-Node Analysis

A collection of shell functions for retrieving and analyzing Kubernetes pod information along with their associated node labels and metadata. Available for both Bash and Fish shells.

## Overview

These functions help you quickly analyze the relationship between your Kubernetes pods and the nodes they're running on, including:
- Node labels and metadata
- Availability zone distribution
- Instance types
- Karpenter node pool assignments
- Pod distribution statistics

## Prerequisites

Before using these functions, ensure you have:
- `kubectl` installed and configured with access to your Kubernetes cluster
- `jq` (JSON processor) installed for data manipulation
- Bash 4.0+ or Fish shell 3.0+

## Installation

### For Bash
```bash
# Source the functions in your current session
source bash/pod_node_labels.bash

# Or add to your ~/.bashrc for permanent access
echo "source $(pwd)/bash/pod_node_labels.bash" >> ~/.bashrc
```

### For Fish
```fish
# Source the functions in your current session
source fish/pod_node_labels.fish

# Or add to your Fish config
echo "source "(pwd)"/fish/pod_node_labels.fish" >> ~/.config/fish/config.fish
```
### Bash Completion
```bash
# Enable completion in your current session
source bash/pod_node_labels_completion.bash

# Or add to your ~/.bashrc for automatic loading
echo "source $(pwd)/bash/pod_node_labels_completion.bash" >> ~/.bashrc
```


## Available Functions

### `pod_node_labels [KUBECTL_OPTIONS]`
Retrieves pods along with their associated node information and all node labels.

**Example:**
```bash
pod_node_labels --namespace production
pod_node_labels -l app=nginx
```

### `podname_to_node_label <NODE_LABEL> [KUBECTL_OPTIONS]`
Creates a mapping of pod names to a specific node label value.

**Parameters:**
- `NODE_LABEL`: The node label key to extract (required)

**Example:**
```bash
podname_to_node_label "node.kubernetes.io/instance-type" -n default
podname_to_node_label "topology.kubernetes.io/zone" --all-namespaces
```

### `podname_to_az [KUBECTL_OPTIONS]`
Maps pod names to their availability zones using the standard `topology.kubernetes.io/zone` label.

**Example:**
```bash
podname_to_az -n production
podname_to_az -l tier=frontend
```

### `pod_to_instance_type [KUBECTL_OPTIONS]`
Maps pod names to their node's EC2 instance types using the `node.kubernetes.io/instance-type` label.

**Example:**
```bash
pod_to_instance_type --all-namespaces
pod_to_instance_type -n kube-system
```

### `pod_to_karpenter_nodepool [KUBECTL_OPTIONS]`
Maps pod names to their Karpenter node pool names. Only considers nodes initialized by Karpenter.

**Example:**
```bash
pod_to_karpenter_nodepool -n production
pod_to_karpenter_nodepool -l app=web-server
```

### `pod_per_az [KUBECTL_OPTIONS]`
Counts the number of pods running in each availability zone.

**Example:**
```bash
pod_per_az --all-namespaces
pod_per_az -n production
```

## Usage Examples

### Analyze pod distribution across availability zones
```bash
# Get pod count per AZ for a specific application
pod_per_az -l app=my-application

# Check AZ distribution for all pods in production namespace
pod_per_az -n production
```

### Find which instance types your pods are using
```bash
# Map all pods to their instance types
pod_to_instance_type --all-namespaces

# Check instance types for a specific deployment
pod_to_instance_type -l app=web-server
```

### Analyze Karpenter node pool usage
```bash
# See which Karpenter node pools your pods are using
pod_to_karpenter_nodepool -n production

# Check node pool distribution for a specific application
pod_to_karpenter_nodepool -l app=data-processor
```

### Custom node label analysis
```bash
# Map pods to custom node labels
podname_to_node_label "node.example.com/workload-type" -n production
podname_to_node_label "kubernetes.io/arch" --all-namespaces
```

## Output Format

All functions return JSON output that can be further processed with `jq` or other tools:

```json
[
  {
    "podName": "nginx-deployment-abc123",
    "podIP": "10.244.1.5",
    "nodeName": "node-1",
    "topology.kubernetes.io/zone": "us-west-2a",
    "node.kubernetes.io/instance-type": "m5.large"
  }
]
```

## Common kubectl Options

These functions accept standard `kubectl` options:
- `--namespace` or `-n`: Specify namespace
- `--all-namespaces` or `-A`: Include all namespaces
- `--selector` or `-l`: Filter by labels
- `--field-selector`: Filter by field selectors

## Troubleshooting

### Function not found
Make sure you've sourced the appropriate file for your shell:
```bash
# For Bash
source bash/pod_node_labels.bash

# For Fish
source fish/pod_node_labels.fish
```

### jq command not found
Install jq using your system's package manager:
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# RHEL/CentOS
sudo yum install jq
```

### kubectl access issues
Ensure your kubectl is configured and you have appropriate permissions:
```bash
kubectl auth can-i get pods
kubectl auth can-i get nodes
```

## Contributing

Feel free to submit issues or pull requests to improve these functions or add support for additional shells.

## License

This project is open source and available under the MIT License.
