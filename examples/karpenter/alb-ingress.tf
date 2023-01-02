resource "helm_release" "alb_ingress" {
  name       = "alb-ingress"
  chart      = "./alb-ingress"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = false


  depends_on = [module.eks_blueprints, helm_release.ingressgateway]
}