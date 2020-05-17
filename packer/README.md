Build AMI for TeamCity server
-----------------------------

Export your AWS credentials or pass them as variables and run the following command
```shell
$ packer build \
  -var 'aws_region=eu-north-1' \
  -var 'aws_source_ami=REPLACE_WITH_UBUNTU_AMI_ID' \
  teamcity_server.json
```
