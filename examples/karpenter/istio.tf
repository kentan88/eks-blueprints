resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "kubernetes_labels" "example" {
  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name = "default"
  }
  labels = {
    "istio-injection" = "enabled"
  }
}

resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.istio_system.metadata.0.name

  depends_on = [module.eks_blueprints]
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.istio_system.metadata.0.name

  set {
    name  = "meshConfig.accessLogFile"
    value = "/dev/stdout"
  }

  depends_on = [module.eks_blueprints, helm_release.istio_base]
}

resource "helm_release" "ingressgateway" {
  name       = "istio-ingressgateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"

  timeout         = 500
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.istio_system.metadata.0.name

  set {
    name  = "service.type"
    value = "NodePort"
  }

  depends_on = [module.eks_blueprints, helm_release.istiod]
}

resource "helm_release" "alb-istio-ingress" {
  name  = "alb-istio-ingress"
  chart = "/Users/kentan/workspace/infrastructure-istio/helm-external/istio-ingress"

  depends_on = [module.eks_blueprints, helm_release.istiod]
}