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
