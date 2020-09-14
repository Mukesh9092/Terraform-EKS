# Terraform-EKS
1.  mkdir ~/.kube
2.  terraform output config-map-aws-auth>~/.kube/config-map-aws-auth
3.  terraform output kubeconfig>~/.kube/config
4.  terraform output config-map-aws-auth >config-map-aws-auth.yaml
5.  kubectl apply -f config-map-aws-auth.yaml
