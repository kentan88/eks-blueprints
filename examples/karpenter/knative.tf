# https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/#prerequisites

data "kubectl_path_documents" "knative_serving_crds" {
  pattern = "${path.module}/knative/serving-crds.yaml"
}

resource "kubectl_manifest" "knative_serving_crds" {
  for_each  = toset(data.kubectl_path_documents.karpenter_provisioners.documents)
  yaml_body = each.value

  depends_on = [
    module.eks_blueprints_kubernetes_addons
  ]
}

data "kubectl_path_documents" "knative_serving_core" {
  pattern = "${path.module}/knative/serving-core.yaml"
}

resource "kubectl_manifest" "knative_serving_core" {
  for_each  = toset(data.kubectl_path_documents.karpenter_provisioners.documents)
  yaml_body = each.value

  depends_on = [
    kubectl_manifest.knative_serving_crds
  ]
}

# data "kubectl_path_documents" "knative_istio" {
#   pattern = "${path.module}/knative/istio.yaml"
# }

# resource "kubectl_manifest" "knative_istio" {
#   for_each  = toset(data.kubectl_path_documents.karpenter_provisioners.documents)
#   yaml_body = each.value

#   depends_on = [
#     kubectl_manifest.knative_serving_core
#   ]
# }

# data "kubectl_path_documents" "knative_net_istio" {
#   pattern = "${path.module}/knative/net-istio.yaml"
# }

# resource "kubectl_manifest" "knative_net_istio" {
#   for_each  = toset(data.kubectl_path_documents.karpenter_provisioners.documents)
#   yaml_body = each.value

#   depends_on = [
#     kubectl_manifest.knative_istio
#   ]
# }