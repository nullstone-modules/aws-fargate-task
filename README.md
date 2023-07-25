# Fargate Task

This app module is used to create a short-lived task/job.
To create a long-running service, use Fargate Service.

After creating the application, add an `Event` capability to trigger the task from items in a queue, on a schedule, or directly. 

## Security & Compliance

Security scanning is graciously provided by [Bridgecrew](https://bridgecrew.io/).
Bridgecrew is the leading fully hosted, cloud-native solution providing continuous Terraform security and compliance.

![Infrastructure Security](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-task/general)
![CIS AWS V1.3](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-task/cis_aws_13)
![PCI-DSS V3.2](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-task/pci)
![NIST-800-53](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-task/nist)
![ISO27001](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-task/iso)
![SOC2](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-task/soc2)
![HIPAA](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-task/hipaa)

## Platform

This module uses [AWS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/userguide/what-is-fargate.html), which is a technology that allows you to run ECS container applications without managing EC2 boxes (Virtual Machines).

## App Support

- Environment Variables
- Secrets
- Network Access
- SSH Access
- Log Providers
- Sidecars
- Volumes
