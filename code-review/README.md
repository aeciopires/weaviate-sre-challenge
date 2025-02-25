#### Menu

<!-- TOC -->

- [About](#about)
- [Requirements](#requirements)
- [Structure of directories](#structure-of-directories)
- [How to test](#how-to-test)
- [How to Uninstall](#how-to-uninstall)
  - [Remove AWS S3 Bucket](#remove-aws-s3-bucket)
  - [Remove DynamoDB Table](#remove-dynamodb-table)

<!-- TOC -->

# About

Create EKS Kubernetes cluster using Terraform code.

# Requirements

- Configure the AWS Credentials and all install all packages and binaries following the instructions on the [REQUIREMENTS.md](../REQUIREMENTS.md) file.

# Structure of directories

```bash
├── code-review      # Directory with Terraform code
│   ├── main.tf      # Terraform resouces
│   ├── output.tf    # Terraform output
│   ├── variables.tf # Terraform variables
└── README.md        # This documentation
```

# How to test

- Create common environment variables:

```bash
export SUFFIX='gyr4'
export AWS_PROFILE='myaccount'
export AWS_ACCOUNT_ID='CHANGE_HERE'
export AWS_REGION='us-east-2'
export PREFIX_CLUSTER_NAME='cluster1'
export CLUSTER_NAME="cluster1-${SUFFIX}"
export BUCKET_NAME="terraform-remote-state-${SUFFIX}"
export DYNAMODB_NAME="terraform-state-lock-dynamo-${SUFFIX}"
```

- Change values in ``variables.tf`` file.

- For create key pair RSA for EKS cluster:

Example:

```bash
ssh-keygen -t rsa -b 4096 -v -f ~/key-$SUFFIX.pem
```

- Copy content public key without USER and HOST.

```bash
cat ~/key-$SUFFIX.pem.pub | cut -d " " -f1,2
```

- Example:

```config
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGaj/Af6UpsosJoP7Z3AEW6qf+9qQsIpYhbWR9ZXfo0M5/HorpCe/OqqyMwjLwfZb6TCDKDjH/9MK5Y3VxoL/SF/ECjk3SJM5NQO/NWZojZUYM8nTkkc0sqsF7MNJgN4I0SFeigJwWpYE2h0NAJTadMIt9jY9OAEcH1FIcpcBgE9SuL4SvZm7CDbBlSloMoGqBS+BB/9sHc7UCANFR0FrAFdwMKGYUmlOmMJlklbryoSuht8A5fWGo+iPtkksVgJ07fIlnkDiFhJIiaM4ScEd5g8OwjrmZjfx4+pyQlEAXKiYwR5T/05gHomMCNdUZfLjIAzLRlcaRTxQ6CVhRUlB4KYcoYdpc8sbw8stVh6p0uRUZ9O+cKoEcyQv8gq0pUoq+er3+inHIlcUY+nLNPGFRlRcWzZ0Dd96QeJclEByln7vRVZDokKyn1y41P/jV2FtXdt/z/MbCYxhqtWxXQtDpIuauW6aPU9CDyjPgif3KjluxILYH7lyw8uKJuJM3pV0S15ZVdu6a3GeVrGRYMx4Gq6QyFcc9Rtl3E1QhFFxXWFvpMkIfeiax5HfQHE+XHWKN38LXR+8ZjQbMZSD/8/WJP2K9YVLIsRfLclwwkccYGEvMfiQuDIx7YjLZ+lF8WBGNUswbibDhiDK9aQLZ0n4bvGRrPtWgbE5oJm8AjeQi2w==
```

Run the ``terraform`` commands.

```bash
cd ~/git/weaviate-sre-challenge/code-review/

# Creating AWS-S3 bucket in the first time
aws s3 mb "s3://${BUCKET_NAME}" --region $AWS_REGION --profile $AWS_PROFILE

# Creating AWS-DynamoDB in the first time
aws dynamodb create-table --table-name "$DYNAMODB_NAME" --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --region $AWS_REGION --profile $AWS_PROFILE

# Run terraform commands
terraform validate
terraform plan
terraform apply
terraform output
```

# How to Uninstall

- Run the command:

```bash
terraform destroy
```

## Remove AWS S3 Bucket

- Run the command:

```bash
aws s3 rb "s3://${BUCKET_NAME}" \
  --force \
  --recursive \
  --region "$AWS_REGION" \
  --profile myaccount

# or

aws s3api delete-bucket \
  --bucket "$BUCKET_NAME" \
  --region "$AWS_REGION" \
  --profile myaccount
```

References:

- https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-bucket.html
- https://docs.aws.amazon.com/cli/latest/reference/s3api/delete-bucket.html

## Remove DynamoDB Table

- Run the command:

```bash
aws dynamodb delete-table \
  --table-name "${DYNAMODB_NAME}" \
  --region "$AWS_REGION" \
  --profile myaccount
```

References:

- https://docs.aws.amazon.com/cli/latest/reference/dynamodb/delete-table.html
