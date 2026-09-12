# 🚀 Day 15 of hashtag#30DaysofAWSTerraform @Piyush_sachdeva

# Multi-Region VPC Peering with Terraform

# Diagram
<img width="1536" height="1024" alt="Project Diagram" src="https://github.com/user-attachments/assets/275b4b6c-c2cf-4d12-9055-d3a487dd9fc0" />

[<img width="853" height="161" alt="image" src="https://github.com/user-attachments/assets/a659e21e-a37f-40fb-a46e-32ee5054b671" />](https://youtu.be/WGt000THDmQ?si=ptvBxGJTrSgID_YS)


In this hands-on exercise, I worked on building and testing a multi-region AWS VPC Peering architecture using Terraform.

Instead of only implementing the basic two-VPC example, I extended the exercise to three VPCs across three AWS regions to understand how VPC peering behaves in a real networking scenario.

🏗️ Architecture:
```
VPC A: us-east-1 with CIDR: 10.0.0.0/16
VPC B: us-west-1 with CIDR: 10.1.0.0/16
VPC C: us-east-2 with CIDR: 10.2.0.0/16
```
Using Terraform, I provisioned:
1) 3 VPCs 
2) Subnets 
3) Internet Gateways 
4) Route Tables 
5) Security Groups 
6) EC2 instances 
7) Multi-region AWS provider aliases 
8) VPC Peering connections 
9) AWS data sources for Availability Zones and AMIs

🔍 🕵 The interesting part: testing non-transitive peering
 
I first created: VPC A ↔ VPC B ↔ VPC C

Then I tested connectivity between the EC2 instances. 
✅ A → B worked
✅ B → C worked
❌ A → C failed

At first glance, it might seem that VPC A should be able to use VPC B as a path to VPC C.
 
But this exposed an important AWS networking concept: VPC Peering is non-transitive.
VPC B does not automatically act as a transit point between VPC A and VPC C.
 
🛠️ Fix:
To establish direct connectivity, I added: VPC A ↔ VPC C and configured the corresponding route-table and security-group rules.
 
The final topology became:

▫️▫️VPC A
▫️▫️| ▫️▫️\
▫️▫️| ▫️▫️ \
▫️ VPC B ---- VPC C


I also got practical experience with:
 
- Terraform provider aliases for multi-region deployments
- Terraform dependencies and depends_on
- AWS route-table configuration
- Security-group rules for cross-VPC traffic
- Terraform data sources
- Troubleshooting connectivity instead of assuming the architecture works just because terraform apply succeeds

My biggest takeaway for: A successful Terraform deployment does not necessarily mean a successful network design. Testing and troubleshooting are part of infrastructure engineering.

Continuing to build, break, troubleshoot, and learn. 🚀
 

# Created the KeyPairs

```pwsh
 aws ec2 describe-key-pairs --region us-east-1 --query "KeyPairs[*].KeyName" --output table
-------------------------------------                                                                                                                                                                               
|         DescribeKeyPairs          |
+-----------------------------------+
|  vpc-peering-task-region-primary  |
+-----------------------------------+


 aws ec2 describe-key-pairs --region us-west-1 --query "KeyPairs[*].KeyName" --output table
---------------------------------------                                                                                                                                                                             
|          DescribeKeyPairs           |
+-------------------------------------+
|  vpc-peering-task-region-secondary  |
+-------------------------------------+


 aws ec2 describe-key-pairs --region us-east-2 --query "KeyPairs[*].KeyName" --output table
-----------------------------------                                                                                                                                                                                 
|        DescribeKeyPairs         |
+---------------------------------+
|  vpc-peering-task-region-third  |
+---------------------------------+



```

<img width="1510" height="392" alt="Screenshot 2026-09-10 224229" src="https://github.com/user-attachments/assets/24984bfa-f47d-4e8a-b68c-ed54899fffc2" />
<img width="1602" height="417" alt="Screenshot 2026-09-10 224312" src="https://github.com/user-attachments/assets/3c5debb6-6d0a-4a48-8377-4d8baf9e7e39" />
<img width="1612" height="671" alt="Screenshot 2026-09-10 224326" src="https://github.com/user-attachments/assets/de316278-9038-4ef3-9c2c-9a25bbbfa20d" />

---

## Before the VPC peering was added for Region C (Demonstrated that VPC peering is non-transitive)

<img width="870" height="687" alt="Screenshot 2026-09-10 232001" src="https://github.com/user-attachments/assets/d27b829f-b1a8-4bac-bfe4-316222133a4e" />
<img width="1136" height="512" alt="Screenshot 2026-09-10 231338" src="https://github.com/user-attachments/assets/66a21b5e-d647-410f-95ee-7d6b34eaafdc" />
<img width="1270" height="887" alt="Screenshot 2026-09-10 231417" src="https://github.com/user-attachments/assets/06407c19-7e98-44c8-ac4c-2fb707429757" />
<img width="1065" height="747" alt="Screenshot 2026-09-10 231451" src="https://github.com/user-attachments/assets/301de7f9-60b2-4593-9abd-b25a1a3a0834" />
<img width="810" height="567" alt="Screenshot 2026-09-10 231620" src="https://github.com/user-attachments/assets/e1918ef2-c0a4-412f-bc91-f884c0ee7ba1" />
<img width="890" height="510" alt="Screenshot 2026-09-10 231859" src="https://github.com/user-attachments/assets/f649e09b-ab85-45ab-b571-66359c6fd1a3" />

## After Adding the VPC Peering for Region C 

<img width="740" height="236" alt="Screenshot 2026-09-11 013839" src="https://github.com/user-attachments/assets/283210ff-b09c-44c7-a3b4-074b02dbb436" />
<img width="925" height="712" alt="Screenshot 2026-09-11 012909" src="https://github.com/user-attachments/assets/ce92ddbe-f12e-4049-a175-2485efe538f6" />
<img width="1087" height="967" alt="Screenshot 2026-09-11 013103" src="https://github.com/user-attachments/assets/e5283bd6-5355-4e07-99f1-320d2ca04346" />
<img width="1157" height="1055" alt="Screenshot 2026-09-11 013436" src="https://github.com/user-attachments/assets/bbe471c7-07ac-4918-97a9-49cce03064a0" />

---

---


```pwsh
 get-childItem .

        Directory: C:\Users\pranj\Desktop\my code\30 Days of AWS Terraform\Day15\TaskCode


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----         9/10/2026   1:45 PM                  .terraform
d----         9/11/2026   1:40 AM                  Output-results
d----         9/11/2026   1:15 AM                  Until VPC Transitive connection failure.md
-a---         9/10/2026   1:45 PM           1481   .terraform.lock.hcl
-a---         9/10/2026   6:48 PM           3001   data.tf
-a---         9/11/2026  12:57 AM           1279   local.tf
-a---         9/11/2026   1:12 AM          16832   main.tf
-a---          9/8/2026   9:58 AM            479   providers.tf
-a---          9/8/2026  12:23 PM           1692 󰪷  README.md
-a---          9/8/2026  10:50 PM            220   terraform.tfvars
-a---         9/10/2026   8:25 PM           2475   variable.tf
-a---         9/10/2026  10:26 PM           1706   vpc-peering-task-region-primary.pem
-a---         9/10/2026  10:27 PM           1702   vpc-peering-task-region-secondary.pem
-a---         9/10/2026  10:30 PM           1702   vpc-peering-task-region-third.pem


   pwsh MEM: 68% | 9/13GB   139ms  (base) 
╭─ ♥ 13:01 |                TaskCode 
╰─ 

 get-childItem '.\Until VPC Transitive connection failure.md\'

        Directory: C:\Users\pranj\Desktop\my code\30 Days of AWS Terraform\Day15\TaskCode\Until VPC Transitive connection failure.md


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----         9/10/2026  10:41 PM                  apply-result
d----         9/11/2026   1:14 AM                  plan-results
-a---         9/10/2026   8:37 PM           1080   until or before the failure to connect to region C.md

 get-childItem '.\Output-results\'

        Directory: C:\Users\pranj\Desktop\my code\30 Days of AWS Terraform\Day15\TaskCode\Output-results


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----         9/11/2026   1:17 AM                  apply-result
d----         9/11/2026   1:15 AM                  plan-results
-a---         9/10/2026  10:31 PM          13382 󰈙  creating-ssh-key-pairs.txt
-a---         9/11/2026   1:41 AM          66221 󰈙  destroy-result.txt


   pwsh MEM: 68% | 9/13GB   37ms  (base) 
╭─ ♥ 13:03 |                TaskCode 
╰─ 


 get-childItem '.\Output-results\apply-result\'

        Directory: C:\Users\pranj\Desktop\my code\30 Days of AWS Terraform\Day15\TaskCode\Output-results\apply-result


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         9/11/2026   1:17 AM          55377 󰈙  apply05.txt

 get-childItem '.\Output-results\plan-results\'

        Directory: C:\Users\pranj\Desktop\my code\30 Days of AWS Terraform\Day15\TaskCode\Output-results\plan-results


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         9/11/2026   1:15 AM          53061 󰈙  plan003.txt


   pwsh MEM: 68% | 9/13GB   22ms  (base) 
╭─ ♥ 13:03 |                TaskCode 
╰─ 

 get-childItem '.\Until VPC Transitive connection failure.md\apply-result\'

        Directory: C:\Users\pranj\Desktop\my code\30 Days of AWS Terraform\Day15\TaskCode\Until VPC Transitive connection failure.md\apply-result


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         9/10/2026   8:11 PM          13183 󰈙  apply00.txt
-a---         9/10/2026   8:48 PM           2152 󰈙  apply01.txt
-a---         9/10/2026   8:50 PM          47693 󰈙  apply02.txt
-a---         9/10/2026  10:05 PM          47693 󰈙  apply03.txt
-a---         9/10/2026  10:41 PM          46863 󰈙  apply04.txt

 get-childItem '.\Until VPC Transitive connection failure.md\plan-results\'

        Directory: C:\Users\pranj\Desktop\my code\30 Days of AWS Terraform\Day15\TaskCode\Until VPC Transitive connection failure.md\plan-results


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         9/10/2026   6:49 PM          44573 󰈙  plan00.txt
-a---         9/10/2026  10:40 PM          43987 󰈙  plan002.txt
-a---         9/10/2026   8:38 PM          43845 󰈙  plan01.txt


   pwsh MEM: 68% | 9/13GB   30ms  (base) 
╭─ ♥ 13:07 |                TaskCode 
╰─ 
```


# Resources READ

[aws-providers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

[Customize Terraform configuration with variables - for the aws_region specific documentation](https://developer.hashicorp.com/terraform/tutorials/configuration-language/variables)

[Resource: aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

[Resource: aws_default_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc)

[Data Source: aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc)

### Subnet related
[List Resource: aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/list-resources/subnet)

[Data Source: aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)

[Data Source: aws_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets)

[Resource: aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)

[Resource: aws_ec2_subnet_cidr_reservation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_subnet_cidr_reservation)


### Data source for AZ
[reference 1 for Data Source for AZ](https://github.com/hashicorp/terraform-provider-aws/blob/main/website/docs/d/availability_zones.html.markdown)
[reference 2 for Data Source for AZ](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones)
[Data Source: aws_availability_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones)

