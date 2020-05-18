Deploy TeamCity with dynamic agents on AWS
------------------------------------------

### What code in this repo does

* Creates an AMI for TeamCity server using packer
* Provisions an RDS (MySQL) to act as TeamCity server's database
* TeamCity server runs using the official [JetBrains TeamCity server Docker image](https://hub.docker.com/r/jetbrains/teamcity-server/)
* Runs TeamCity server on EC2 instance based on the AMI
* Stores TeamCity server data directory in EFS
* Makes the server available via ALB
* Monitors the server using CloudWatch
* Creates an IAM role that is used to run dynamic agents on top of ECS
* Provisions an ECS cluster that is used to run TeamCity agents **TODO**
* Collects server's logs using CloudWatch **TODO**
* Backup TeamCity using its REST API **TODO**

### Manual configuration required at startup of the server

* Intial bootstrapping & connection to database
* Sign in and [configure TeamCity server to run agents on top of ECS](https://github.com/JetBrains/teamcity-amazon-ecs-plugin)

### Improvement ideas
* Add a variables and replace hardcoded values with them
* Move modules to a separate repo to allow versioning
* Configure Java options of TeamCity server
