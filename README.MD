HCL SCRIPT
.TF FILE

terraform init -> initalization
terraform plan -> execution plan (these are the things going to changes)
terraform apply -> this helps to create a resource
terrsform destroy -> delete the resources



terraform fmt -> formatting (optional)
terraform validate -> validate(optional)


terraform init -migrate-state -> migrate local state

Historically, Terraform used a DynamoDB table:

dynamodb_table = "terraform_lock"

Newer Terraform versions support:

use_lockfile = true

which creates and manages a lock file in S3, eliminating the need for DynamoDB.
