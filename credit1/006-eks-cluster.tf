# based on example 
# https://www.techtarget.com/searchcloudcomputing/tutorial/How-to-deploy-an-EKS-cluster-using-Terraform

resource "aws_eks_cluster" "eks-dev-cluster" {
 name = "${var.prefix}-eks-dev-cluster"
 role_arn = aws_iam_role.eks-iam-role.arn

 vpc_config {
    #   subnet_ids = [var.subnet_id_1, var.subnet_id_2]
    subnet_ids = [ aws_subnet.subnet1.id, aws_subnet.subnet2.id  ]
 }

 depends_on = [
  aws_iam_role.eks-iam-role,
 ]
}