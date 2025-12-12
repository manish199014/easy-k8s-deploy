terraform {
  required_version = ">= 1.2.0"

  backend "s3" {
    # Bucket name and region provided via -backend-config
    # Example: terraform init -backend-config="bucket=eks-tfstate-123456789012" -backend-config="region=us-east-1"
    key     = "terraform/state/eks.tfstate"
    encrypt = true
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "kubernetes.io/cluster/demo-eks" = "owned"
    }
  }
}

output "NodeInstanceRole" {
  value = aws_iam_role.node_instance_role.arn
}

output "NodeSecurityGroup" {
  value = aws_security_group.node_security_group.id
}

output "NodeAutoScalingGroup" {
  value = aws_cloudformation_stack.autoscaling_group.outputs["NodeAutoScalingGroup"]
}
