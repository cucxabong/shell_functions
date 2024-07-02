function pod_node_labels {
  local pods nodes
  pods=$(kubectl get pods $@ -o json | jq -c '.items|map({nodeName: .spec.nodeName, podName: .metadata.name, podIP: .status.podIP})')
  nodes=$(kubectl get nodes -o json | jq -c '.items|map(.metadata.labels+{nodeName: .metadata.name})')
  jq -s '[.[0][] as $pod | (.[1][] | select($pod.nodeName == .nodeName) as $node | {podName: $pod.podName, podIP: $pod.podIP}+$node)]' <(echo $pods) <(echo $nodes)
}
