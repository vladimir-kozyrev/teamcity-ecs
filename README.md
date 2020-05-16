Deploy TeamCity with dynamic agents on AWS
-------------------------------

What code in this repo does

* Creates an AMI for TeamCity server
* TeamCity server runs using the official [JetBrains TeamCity server Docker image](https://hub.docker.com/r/jetbrains/teamcity-server/)
* Runs TeamCity server on EC2 instance based on the AMI
* Stores TeamCity server data directory in EFS
* Makes the server available via ALB
* Provisions an ECS cluster for TeamCity agents

Manual configuration required at startup of the server

* Sign in and [configure TeamCity server to run agents on top of ECS](https://github.com/JetBrains/teamcity-amazon-ecs-plugin)
