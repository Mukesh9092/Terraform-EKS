# Terraform-EKS
mkdir ~/.kube
terraform output config-map-aws-auth>~/.kube/config-map-aws-auth
terraform output kubeconfig>~/.kube/config
terraform output config-map-aws-auth >config-map-aws-auth.yaml
kubectl apply -f config-map-aws-auth.yaml
