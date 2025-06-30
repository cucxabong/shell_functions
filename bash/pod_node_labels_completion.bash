# Bash completion for pod node label functions

# Common kubectl options to suggest
__pod_kubectl_opts="--namespace -n --all-namespaces -A --selector -l --field-selector"

_pod_node_labels_complete()
{
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"

    # If completing first argument of podname_to_node_label, offer node labels
    if [[ ${COMP_CWORD} -eq 1 && ${COMP_WORDS[0]} == podname_to_node_label ]]; then
        # Gather node labels from kubectl output
        local labels
        labels=$(kubectl get nodes -o json 2>/dev/null | jq -r '.items[].metadata.labels | keys[]' | sort -u)
        # shellcheck disable=SC2207
        COMPREPLY=( $(compgen -W "${labels}" -- "$cur") )
        return
    fi

    # shellcheck disable=SC2207
    COMPREPLY=( $(compgen -W "${__pod_kubectl_opts}" -- "$cur") )
}

# Register completion function for all provided functions
complete -F _pod_node_labels_complete pod_node_labels
complete -F _pod_node_labels_complete podname_to_node_label
complete -F _pod_node_labels_complete podname_to_az
complete -F _pod_node_labels_complete pod_to_instance_type
complete -F _pod_node_labels_complete pod_to_karpenter_nodepool
complete -F _pod_node_labels_complete pod_per_az
