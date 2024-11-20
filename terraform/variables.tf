variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  default     = "terraform-generated-key"
}

variable "repository_url" {
  description = "URL of the Git repository to clone"
  default     = "https://github.com/IngeEduar/terraform-npm-aws.git"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  default     = "servosis-telegram-bot"
}
