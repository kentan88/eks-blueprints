resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube_prometheus" {
  name            = "kube-prometheus-stack"
  repository      = "https://prometheus-community.github.io/helm-charts"
  chart           = "kube-prometheus-stack"
  version         = "43.2.1"
  cleanup_on_fail = true
  force_update    = false
  namespace       = "monitoring"

  values = [templatefile("${path.module}/alertmanager/config.tmpl", {})]

  depends_on = [module.eks_blueprints]
}

# kubectl port-forward --namespace monitoring svc/kube-prometheus-stack-prometheus 9090:9090