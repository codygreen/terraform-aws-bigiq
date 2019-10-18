# AWS F5 BIG-IQ Terraform Module
Terraform module to deploy an F5 BIG-IQ in AWS.  This module currently supports a 2 nic deployment and defaults to using the AWS Marketplace BYOL (bring-your-own-license) 7.0.0.1 BIG-IQ license.  If you would like to use a different BIG-IQ AMI then set the *f5_ami_search_name* variable accordingly.

**NOTE:** You will need to accept the AWS Marketplace offer for your selected BIG-IQ AMI.  
**NOTE:** This code is provided for demonstration purposes and is not intended to be used for production deployments. 

## Password Policy
For security reasons the module requires that a password be created in the AWS Secrets Manager and the Secret name must be supplied to the module.  For demonstration purposes, the examples show how to do this using an randomly generated password.

## Dependencies
This module requires that the user has created a password and stored it in the AWS Secret Manager before calling the module. For information on how to do this please refer to the [AWS Secret Manager docs](https://docs.aws.amazon.com/secretsmanager/latest/userguide/manage_create-basic-secret.html).

## Terraform Version
This modules supports Terraform 0.12 and higher

## Examples
We have provided some common deployment examples below.  However, if you would like to see full end-to-end examples with the creation of all required objects check out the [examples] folder in the GitHub repository.
### Example 1-NIC Deployment PAYG
```hcl
module bigiq {
  source = "f5devcentral/bigiq/aws"
  version = "0.1.0"

  prefix                      = "big-iq"
  f5_instance_count           = 2
  ec2_key_name                = "my-key"
  aws_secretmanager_secret_id = "my_bigiq_password"
  mgmt_subnet_security_group_ids = [sg-01234567890abcdef]
  private_subnet_security_group_ids = [sg-9876543210fedcba]
  vpc_mgmt_subnet_ids    = [subnet-01234567890abcdef]
  vpc_private_subnet_ids = [subnet-9876543210fedcba]
}
```