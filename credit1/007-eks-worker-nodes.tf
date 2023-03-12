# # based on example 
# # https://www.techtarget.com/searchcloudcomputing/tutorial/How-to-deploy-an-EKS-cluster-using-Terraform

# resource "aws_eks_node_group" "worker-node-group" {
#   cluster_name  = aws_eks_cluster.eks-dev-cluster.name
#   node_group_name = "${var.prefix}-eks-dev-node-group"
#   node_role_arn  = aws_iam_role.workernodes.arn
#   subnet_ids   = [ aws_subnet.subnet1.id, aws_subnet.subnet2.id]
#   instance_types = ["t3.micro"]
 
#   scaling_config {
#    desired_size = 3
#    max_size   = 4
#    min_size   = 1
#   }
 
#   depends_on = [
#    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
#    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
#    aws_eks_cluster.eks-dev-cluster
#   ]
#  }
