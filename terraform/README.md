Create state & lock infrastructure
----------------------------------

Before running anything you need to create an S3 bucket and Dynamo db table where terraform state & locks can be stored.
Execute the following command from terraform/ directory.
Make sure to change S3 bucket name and Dynamo table names to unique values within main.tf file.
```bash
terraform init
terraform apply -target 'aws_s3_bucket.terraform_state'
terraform apply -target 'aws_dynamodb_table.terraform_locks'
# Once S3 bucket and Dynamo table is created, you can start using them
terraform apply
```

Directory structure
-------------------

Everything is split into pieces that create either data-stores, services, vpc, or global entities like S3 or IAM.
Each subfolder has its own terraform state path for safety purposes.

Creation order
--------------

1. vpc/teamcity
2. data-stores/efs
3. data-stores/mysql
4. services/teamcity

For each entity do the following
```bash
$ cd vpc/teamcity
$ terraform init
$ terraform apply
```
