🚀 Day 16 of #30DaysofAWSTerraform — AWS IAM User Management with Terraform

[<img width="797" height="162" alt="image" src="https://github.com/user-attachments/assets/433b5177-c302-43ee-8334-3affb7a29abe" />](https://youtu.be/33dWo4esH1U?si=zFr0M0SxbPpm8fZ8)
[link](https://youtu.be/33dWo4esH1U?si=DffXS4OEc3ROE9iG)


I worked on automating AWS IAM user management using Terraform.

The goal of this project was not just to create IAM users, but to understand how Terraform can take structured user information and turn it into repeatable AWS identity infrastructure.

🏗️ What I built:  
I used a CSV file as the source of user information and used Terraform to:

- Read user data using csvdecode()
- Create IAM users dynamically with for_each
- Generate usernames from user attributes
- Apply tags such as Department and Job Title
- Create IAM groups for Education, Managers, and Engineers
- Assign users to groups based on their attributes
- Create IAM login profiles
- Use Terraform lifecycle rules for selected login-profile attributes

One part I particularly liked was using the data itself to determine group membership rather than manually maintaining a list of users.

For example, users could be selected based on attributes such as:

Department → Education / Engineering and Job Title → Manager / CEO

This made the configuration more data-driven and reusable.

🔍 A small debugging lesson
I also made a mistake while configuring the IAM login profile.

I initially referenced the wrong value for the user argument, which caused Terraform to fail during planning.

After checking the error and comparing it with the IAM user resource, I corrected the reference to the actual IAM username.

That was a good reminder that with Terraform, understanding resource attributes and references is just as important as knowing the resource itself.

🧠 What I learned:
This project gave me hands-on practice with:

1. csvdecode() and external structured input
2. for_each for dynamic resource creation
3. Terraform expressions and filtering
4. Resource-to-resource references
5. IAM users and groups
6. IAM login profiles
7. lifecycle and ignore_changes
8. Designing Terraform configurations around data instead of hardcoding individual resources

The biggest takeaway for me: Infrastructure as Code becomes much more powerful when the infrastructure can be driven by structured data rather than manually duplicated resource blocks.


[16/30 - AWS IAM User Management with Terraform - Mini Project](https://www.youtube.com/watch?v=33dWo4esH1U&list=PLl4APkPHzsUWr5H7mprC8O21Crq_NnbYx&index=15)  

[Piyush's Github repo for Day 16](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day16)

[csvdecode Function](https://developer.hashicorp.com/terraform/language/functions/csvdecode)

[Resource: aws_iam_user](https://registry.terraform.io/providers/hashicorp/aws/2.43.0/docs/resources/iam_user)

**17:49**


**21:28**
[Resource: aws_iam_user_login_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_login_profile)


