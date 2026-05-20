locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${module.eks.cluster_endpoint}
    certificate-authority-data: ${module.eks.cluster_certificate_authority_data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - --region
      - ${data.aws_region.current.name}
      - eks
      - get-token
      - --cluster-name
      - ${local.cluster_name}
      command: aws
      env:
      - name: AWS_PROFILE
        value: ${var.aws_profile}
KUBECONFIG
}
