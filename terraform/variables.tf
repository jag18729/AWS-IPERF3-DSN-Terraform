# General Variables
variable "project_name" {
  description = "Name tag for all resources"
  type        = string
  default     = "iperf3-test"
}

# VPC CIDR blocks
variable "vpc_cidrs" {
  description = "CIDR blocks for each VPC"
  type        = map(string)
  default = {
    pasadena = "10.0.1.0/27"
    canberra = "10.0.2.0/27"
    barstow  = "10.0.3.0/27"
    # spain    = "10.0.4.0/27"  # Commented but preserved for future use
  }
}

# Instance types
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# SSH Key configuration
variable "ssh_public_key" {
  description = "SSH public key for EC2 instances"
  type        = string
}

# Your IP for bastion access
variable "allowed_ip" {
  description = "Your IP address for bastion host access"
  type        = string
}

# Instance AMIs (Amazon Linux 2023)
variable "amis" {
  description = "AMI IDs for each region"
  type        = map(string)
  default = {
    us-west-2      = "ami-0735c191cf914754d"  # Pasadena
    ap-southeast-2 = "ami-0310483fb2b488153"  # Canberra
    us-west-1      = "ami-0a0409af1cb831414"  # Barstow
    # eu-south-2   = "ami-0a6006bac3b9bb8d3"  # Spain (commented)
  }
}

# Auto-termination configuration
variable "termination_days" {
  description = "Number of days after which resources will be terminated"
  type        = number
  default     = 30
}

# Tags
variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "test"
    Project     = "iperf3-network-testing"
    Terraform   = "true"
    ManagedBy   = "terraform"
  }
}