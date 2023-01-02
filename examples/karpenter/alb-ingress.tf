resource "helm_release" "alb_ingress" {
  name       = "alb-ingress"
  chart      = "./alb-ingress"

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