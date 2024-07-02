function pod_node_labels
  set pods $(kubectl get pods $argv -o json | jq -c '.items|map({nodeName: .spec.nodeName, podName: .metadata.name, podIP: .status.podIP})')
  set nodes $(kubectl get nodes -o json | jq -c '.items|map(.metadata.labels+{nodeName: .metadata.name})')
  jq -s '[.[0][] as $pod | (.[1][] | select($pod.nodeName == .nodeName) as $node | {podName: $pod.podName, podIP: $pod.podIP}+$node)]' (echo $pods | psub) (echo $nodes | psub)
end
