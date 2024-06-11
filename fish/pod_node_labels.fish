function pod_node_labels --description "Getting Pods and labels of Nodes which are hosting those Pods"
  set pods $(kubectl get pods $argv -o json | jq -c '.items|map({nodeName: .spec.nodeName, podName: .metadata.name})')
  set nodes $(kubectl get nodes -o json | jq -c '.items|map(.metadata.labels+{nodeName: .metadata.name})')
  jq -s '[.[0][] as $pod | (.[1][] | select($pod.nodeName == .nodeName) as $node | {podName: $pod.podName}+$node)]' (echo $pods | psub) (echo $nodes | psub)
end
