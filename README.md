AWS iPerf3 Distributed Network Testing Automation
This repository contains infrastructure as code and automation scripts for deploying and configuring a distributed iPerf3 testing environment across multiple AWS regions.
Infrastructure Overview

Client Location: Pasadena (us-west-2)
Server Locations:

Spain (eu-south-2)
Canberra (ap-southeast-2)
Barstow (us-west-1)



Components

Terraform: Infrastructure deployment
Ansible: Configuration management
AWS VPC Peering for cross-region connectivity
Bastion host for secure access

Prerequisites

AWS CLI configured
Terraform installed
Ansible installed
Required AWS permissions
SSH key pairs

Directory Structure
├── terraform/       # Infrastructure as Code
├── ansible/         # Configuration management
├── scripts/         # Helper scripts
└── .github/        # GitHub Actions workflows

Security Note
Sensitive information such as SSH keys and AWS credentials should never be committed to this repository.
Usage

Detailed usage instructions will be provided in each component's directory.
