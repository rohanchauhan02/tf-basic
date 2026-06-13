# Terraform AWS Infrastructure

Provisions AWS infrastructure using Terraform with remote state stored in S3. Includes modules for EC2, S3, and DynamoDB.

## Architecture

```
.
├── main.tf              # Root module — wires up all child modules
├── vars.tf              # Root-level input variables (AMI ID)
├── provider.tf          # AWS provider (region: ap-south-1)
├── backend.tf           # Remote state backend (S3 + S3 lock file)
├── output.tf            # Root outputs (EC2 public IP)
└── modules/
    ├── ec2/             # EC2 instance (t2.micro, Amazon Linux 2)
    ├── s3/              # S3 bucket
    └── dynamodb/        # DynamoDB table (commented out — using S3 lock instead)
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 0.12
- AWS CLI configured with credentials (`aws configure`)
- The S3 backend bucket `rohan-tf-remote-backend` must exist in `ap-south-1` before running `init`

## Remote State Backend

State is stored remotely in S3 with native S3 locking (no DynamoDB required):

```hcl
backend "s3" {
  bucket       = "rohan-tf-remote-backend"
  key          = "rohan/terraform.tfstate"
  region       = "ap-south-1"
  use_lockfile = true
}
```

> `use_lockfile = true` creates a `.tflock` file in S3, replacing the older DynamoDB-based lock table approach.

## Usage

### 1. Initialize

Downloads providers and configures the S3 backend.

```bash
terraform init
```

If migrating from local state to the S3 backend:

```bash
terraform init -migrate-state
```

### 2. Validate & Format

```bash
terraform validate   # Check for configuration errors
terraform fmt        # Auto-format all .tf files
```

### 3. Plan

Preview what Terraform will create, change, or destroy — no resources are modified.

```bash
terraform plan
```

Override the default AMI at plan time:

```bash
terraform plan -var="ami=ami-xxxxxxxxxxxxxxxxx"
```

### 4. Apply

Create or update all resources.

```bash
terraform apply
```

Auto-approve (skips the confirmation prompt — use carefully):

```bash
terraform apply -auto-approve
```

### 5. Outputs

After apply, view the EC2 instance's public IP:

```bash
terraform output ec2_my_vm_public_ip
```

### 6. Destroy

Tear down all managed resources.

```bash
terraform destroy
```

## Input Variables

| Name  | Description                   | Default                                |
|-------|-------------------------------|----------------------------------------|
| `ami` | AMI ID for the EC2 instance   | `ami-0db56f446d44f2f09` (Amazon Linux 2, ap-south-1) |

## Outputs

| Name                    | Description                          |
|-------------------------|--------------------------------------|
| `ec2_my_vm_public_ip`   | Public IP address of the EC2 instance |

## Modules

### `modules/ec2`

Creates an `aws_instance` with:
- Instance type: `t2.micro`
- Security group: `default`
- Key pair: `terrform_india_pam`
- Tag: `Rohan_EC2_Instance`

### `modules/s3`

Creates an `aws_s3_bucket`:
- Bucket name: `rohan-tf-demo-bucket-2026`
- Tag: `Rohan_S3_Bucket`

### `modules/dynamodb`

Commented out. Originally used for Terraform state locking via a `LockID` table. Replaced by `use_lockfile = true` in the S3 backend.

## State Management Notes

| Feature         | Old approach                        | Current approach            |
|-----------------|-------------------------------------|-----------------------------|
| State storage   | Local `terraform.tfstate`           | S3 bucket                   |
| State locking   | DynamoDB table (`terraform_lock`)   | S3 lock file (`use_lockfile = true`) |

To inspect the current state:

```bash
terraform state list                        # List all managed resources
terraform state show aws_instance.my_ec2   # Show details of a specific resource
```
