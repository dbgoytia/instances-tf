# variable "key_pair_path" {
#   description = "Path to the key-pair used for logging into the instance"
#   type        = string
# }

variable "key_pair_name" {
  description = "Name to attach to the key_pair used for login."
  type        = string
}

variable "count" {
  description = "The number of servers to be created."
  type        = number
}

variable "instance-type" {
  description = "Instance type to be used for our webserver"
  type        = string
  default = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID to attach to our instance"
  type        = string
}

variable "vpc_id" {
  description = "VPC id used to install the security group"
  type        = string
}

variable "ssh-key-arn" {
  description = "ARN for the ssh-key pair"
  type        = string
}

variable "bootstrap_scripts_bucket" {
  description = "s3 location for the bootstrap scripts"
  type        = string
  default = null
}

variable "bootstrap_script_key" {
  description = "s3 keyfor the bootstrap scripts"
  type        = string
  default = null
}

variable "monitoring" {
  description = "ON/OFF toggle for detailed monitoring"
  type        = bool
  default = false
}

variable "ami" {
  description = "The AMI to be used by Systems Manager to deploy."
  type        = string
}
