terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Project     = "cloud-lab"
      Environment = "dev"
      ManagedBy   = "terraform"
    }
  }
}

# Read the outputs of network-dev
data "terraform_remote_state" "network" {
  backend = "remote"
  config = {
    organization = "sab37"
    workspaces = {
      name = "network-dev"
    }
  }
}

# A security group inside the VPC from network-dev
resource "aws_security_group" "app" {
  name        = "cloud-lab-dev-app-sg"
  description = "Security group for the app"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  tags = {
    Name = "cloud-lab-dev-app-sg"
  }
}

output "app_sg_id" {
  value = aws_security_group.app.id
}

output "network_vpc_id" {
  value = data.terraform_remote_state.network.outputs.vpc_id
}