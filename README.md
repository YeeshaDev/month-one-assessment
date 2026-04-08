# TechCorp AWS Infrastructure - Terraform Assessment

## Architecture Overview

This Terraform configuration deploys a highly available web application infrastructure on AWS:

- **VPC** with public and private subnets across 2 availability zones
- **Application Load Balancer** distributing traffic to web servers
- **2 Web Servers** (Apache) in private subnets
- **1 Database Server** (PostgreSQL) in a private subnet
- **Bastion Host** for secure SSH access to private instances
- **NAT Gateways** for outbound internet access from private subnets

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- AWS CLI configured with valid credentials (`aws configure`)
- An EC2 Key Pair created in your target AWS region

## Deployment Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Yeeshadev/month-one-assessment.git
   cd month-one-assessment
   ```

2. **Configure variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   Edit `terraform.tfvars` with your values:
   - `my_ip` — your public IP (find it at https://checkip.amazonaws.com)
   - `key_name` — your EC2 key pair name

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Review the plan:**
   ```bash
   terraform plan
   ```

5. **Deploy the infrastructure:**
   ```bash
   terraform apply
   ```
   Type `yes` when prompted.

6. **Access the application:**
   - Open the `load_balancer_dns_name` output URL in your browser
   - SSH to bastion: `ssh -i your-key.pem ec2-user@<bastion_public_ip>`
   - From bastion, SSH to web servers: `ssh webadmin@<web_server_private_ip>` (password: `your_password`)
   - From bastion, SSH to DB server: `ssh dbadmin@<db_server_private_ip>` (password: `your_password`)
   - Connect to PostgreSQL on DB server: `psql -h localhost -U techcorp -d techcorpdb`

## Cleanup

To destroy all resources and stop incurring charges:

```bash
terraform destroy
```

Type `yes` when prompted.

## File Structure

```
terraform-assessment/
├── main.tf                  # All resource definitions
├── variables.tf             # Variable declarations
├── outputs.tf               # Output definitions
├── terraform.tfvars.example # Example variable values
├── user_data/
│   ├── web_server_setup.sh  # Apache installation script
│   └── db_server_setup.sh   # PostgreSQL installation script
├── evidence/
│   ├── terraform-plan.png       # Terraform plan output
│   ├── terraform-plan.txt       # Full terraform plan text
│   ├── terraform-apply.png      # Terraform apply output
│   ├── terraform-alb.png        # ALB resource in AWS console
│   ├── ec2-instances.png        # EC2 instances running
│   ├── nat-gateways.png         # NAT Gateways in AWS console
│   ├── target-group.png         # ALB target group with healthy targets
│   ├── alb-web-access.png       # Web app accessed via ALB DNS
│   ├── bastion-ssh.png          # SSH into bastion host
│   ├── web-ssh.png              # SSH into web server 1 from bastion
│   ├── web2-ssh.png             # SSH into web server 2 from bastion
│   └── postgres-instance.png    # PostgreSQL running on DB server
└── README.md                # This file
```
