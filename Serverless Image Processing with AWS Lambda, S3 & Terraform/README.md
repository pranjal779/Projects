# Day 18: Serverless Image Processing with AWS Lambda, S3 & Terraform

[<img width="926" height="150" alt="image" src="https://github.com/user-attachments/assets/50941087-937d-45c6-af75-ec05f75bcceb" />](https://youtu.be/l0RYCxczgyk?si=-Y4V3Jfe24PsUhcm)
[Link](https://youtu.be/l0RYCxczgyk?si=RlutAFwEPjlrWM_5)

- **Developed an event-driven serverless image-processing pipeline** using Terraform, Amazon S3 and AWS Lambda to automatically process uploaded images through S3 `ObjectCreated` events.
- **Implemented Python-based image processing with the Pillow library and a Lambda Layer**, generating five image variants: compressed JPEG, low-quality JPEG, WebP, PNG and 200×200 thumbnails.
- **Automated AWS infrastructure provisioning and deployment** with Terraform and shell scripts, incorporating S3 encryption, versioning, public access blocking, IAM permissions and CloudWatch logging

A serverless image-processing backend that automatically processes images uploaded to Amazon S3 using AWS Lambda and the Pillow library. Terraform is used to provision and configure the required AWS infrastructure.

## Project Overview

<img width="1774" height="887" alt="image" src="https://github.com/user-attachments/assets/77816f22-f8a4-466c-8c83-fd4ea1f0d2d4" />

This project implements an event-driven image-processing pipeline.

When an image is uploaded to the source S3 bucket, an S3 `ObjectCreated` event invokes an AWS Lambda function. The Lambda function processes the image and stores five generated variants in a destination S3 bucket.

## Architecture

```text
User / AWS CLI / SDK
        |
        | Upload image
        v
Source S3 Bucket
        |
        | S3 ObjectCreated event
        v
AWS Lambda Function
(Image Processing)
        |
        | Pillow Library
        |
        |-- Compressed JPEG — quality 85
        |-- Low-quality JPEG — quality 60
        |-- WebP image
        |-- PNG image
        |-- 200x200 thumbnail
        v
Processed S3 Bucket

Terraform provisions the infrastructure.
```

## Technologies Used: 
1. AWS Lambda
2. Amazon S3
3. AWS IAM
4. AWS CloudWatch Logs
5. AWS Lambda Layers
6. Python
7. Pillow 10.4.0
8. Terraform
9. AWS CLI
10. Bash scripting
11. Docker for building the Lambda layer


## Key Features:

1. Event-driven image processing using S3 and Lambda.
2. Automatic generation of five image variants for each uploaded image.
3. Pillow library provided through a Lambda Layer.
4. Separate source and processed S3 buckets.
5. S3 versioning and server-side encryption.
6. Private S3 buckets with public access blocked.
7. IAM permissions for Lambda to access the required S3 resources.
8. Deployment and cleanup scripts for repeatable infrastructure management.
9. CloudWatch logging for Lambda execution monitoring.


## Generated Image Variants

For every uploaded image, the Lambda function creates:

| Variant | Description |
|---------|-------------|
|Compressed JPEG|JPEG image with quality set to 85|
|Low-quality JPEG|JPEG image with quality set to 60|
|WebP|Image converted to WebP format|
|PNG|Lossless PNG image|
|Thumbnail|200x200 image preview|


## Project Structure:

```txt

Day18/
├── lambda/
│   └── lambda_function.py
├── scripts/
│   ├── deploy.sh
│   └── destroy.sh
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── ...
├── Notes/
├── terminal output/
├── Task screenshots.md
├── task.md
└── Day18 Readme.md

```

## Prerequisites

1. Install and configure the following tools:
   - Terraform
   - AWS CLI
   - Python
   - Docker Desktop with WSL integration, if building the Lambda layer locally
   - An AWS account with appropriate permissions

2. Verify your AWS credentials: aws sts get-caller-identity

## Deployment

Navigate to the Day18 directory and run: 
```sh
./scripts/deploy.sh
```

The deployment script builds the Lambda layer and deploys the required AWS infrastructure through Terraform.

Before deployment, verify that Docker is running if the layer-building process uses Docker.

## Upload an Image

Upload an image to the source S3 bucket using the AWS CLI:

```sh
aws s3 cp my-photo.jpg s3://YOUR-UPLOAD-BUCKET/
```

The S3 upload event automatically triggers the Lambda function.

## Verify Processed Images

List the generated objects in the processed bucket: ``` aws s3 ls s3://YOUR-PROCESSED-BUCKET/ --recursive ```

Download a generated image: ``` aws s3 cp s3://YOUR-PROCESSED-BUCKET/my-photo_compressed.jpg ./ ```

## Monitoring

View Lambda logs using CloudWatch Logs: ``` aws logs tail /aws/lambda/YOUR-LAMBDA-FUNCTION --follow ```

Use the logs to investigate Lambda invocations, image-processing errors and execution behaviour.

## Security Considerations

- S3 buckets are configured as private.
- Public access blocking is enabled.
- Server-side encryption is enabled.
- IAM permissions are configured for the Lambda function's required S3 access.
- Terraform manages the infrastructure configuration consistently.

## Cleanup

To remove the deployed infrastructure, run: ``` ./scripts/destroy.sh ```

Review the Terraform plan and ensure that any required data has been backed up before destroying resources.  
Do not commit AWS credentials, secret keys, generated Terraform state files or other sensitive information to the repository.  

## Key Learnings

1. Designed an event-driven serverless architecture using S3 and Lambda.
2. Used Terraform to provision AWS infrastructure as code.
3. Configured S3 event notifications to invoke Lambda.
4. Learned how Lambda Layers can package external Python dependencies such as Pillow.
5. Practiced IAM permissions, S3 security controls and CloudWatch logging.
6. Used deployment scripts to automate infrastructure setup and cleanup.
7. Understood how a serverless workflow can process files without managing servers.

## Future Improvements

1. Add file-size and file-type validation before processing.
2. Implement dead-letter handling for failed Lambda invocations.
3. Add CloudWatch alarms for Lambda errors and throttling.
4. Introduce automated tests for the image-processing functions.
5. Add object lifecycle policies to manage storage costs.
6. Use CI/CD to validate and deploy Terraform changes.
