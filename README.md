# DCChallenge

![DCC Diagram](images/DCChallenge-diagram.png)


This project is about setting up a highly available web server on EC2 using Docker containers, ECR, Infrastructure as Code (IaC), automation, and pipelines. I call the project DCC, which stands for Decops Code Challenge.

You can see the project diagram above. Monitoring and ‌‌Bastion are considered in the project but have not been implemented yet.

## Contents

Project Structure
Configuring AWS CLI
Project Setup
Project Deployment
Project Cleanup
Debugging

### 1. Project Structure
The project follows this directory structure:

``` bash
.
├── ansible_role
├── appspec.yml
├── cloudformation
├── images
├── LICENSE
├── README.md
├── scripts
└── webserver

```

- ansible_role: This directory contains Ansible roles for the project. You can list and tag the project roles in the main YAML file, site.yml. Add a host to the project by editing the host file.
- cloudformation: Houses CloudFormation templates to configure the required services for this project.
- images: Stores images needed for this guide.
- scripts and appspec.yml: Used by AWS CodeDeploy service. Modify these files if you need to change the deployment process.
- webserver: Contains the project's main Dockerfile and index.html(webserver context).

### 2. Configuring AWS CLI
For this project, you can use either the AWS CloudFormation console or the AWS CLI. This guide uses the AWS CLI, which you must have installed on your system. After installation, configure it with your AWS credentials.

If you work with multiple AWS accounts, leverage AWS profiles - a set of settings including credentials and other AWS related info. Create a new profile with the command aws configure --profile profilename, where profilename is your profile name.

For example:

``` bash 
aws configure --profile myprofile

```
Input your details as follows:
``` bash 
AWS Access Key ID [None]: YOUR_ACCESS_KEY
AWS Secret Access Key [None]: YOUR_SECRET_KEY
Default region name [None]: YOUR_REGION (e.g., us-west-2)
Default output format [None]: json

```

### 3. Project Setup

To set up the project for the first time, you will need to run the following commands:

1. Navigate to the main project folder and execute the following command:

``` bash 
aws cloudformation create-stack --capabilities CAPABILITY_NAMED_IAM --stack-name <stack name> --template-body file://cloudformation/DCC-cf-template-2023-07-26.yaml  --profile <project account profile > --region <project region>


```

Note: This project template is currently set up for regions eu-central-1 and eu-north-1.

2. After running the command, you can monitor the status of the stack until the entire project is up. You can do this either through the AWS console or by executing the following command:

``` bash 
aws cloudformation describe-stack-events --stack-name <stack name> --profile <project account profile >  --region <project region>

```

3. After the stack is fully up and running, to update it in the future, you should use the following command:

```bash 
aws cloudformation update-stack --capabilities CAPABILITY_NAMED_IAM --stack-name <stack name> --template-body file://cloudformation/DCC-cf-template-2023-07-26.yaml  --profile <project account profile > --region <project region>

```

#### Important notes:

1. On the first launch of the infrastructure, the server may not function due to the repository being empty. Therefore, it's essential to perform a deployment immediately after the execution to start the servers.

2. The web servers of the project are launched in a private subnet. Therefore, there's no direct access to them from the outside or the internet. To connect to them, you either need to use a previously accessible bastion server or utilize the AWS SSM Session Manager.

3. All prerequisites required on the web servers are prepared via the user data script included in the CloudFormation template. Also, a cron job runs every 5 minutes on the servers to monitor the status of the containers.

4. The keys and secrets of the project are stored on the SSM Parameter Store and are readily accessible.

5. Artifacts and temporary files of the project are stored on an S3 bucket.

### 4. Project Deployment

To deploy the project, you can commit to the 'main' branch of the project repository. The repository will be updated automatically, and the containers on the servers will also be updated.

The project branch is customizable, and you can modify it in the CloudFormation template (parameter: GitHubBranch).

To alter the displayed context, you can update the webserver/index.html file.

### 5. Project Cleanup
To delete the stack, the contents of the S3 bucket related to the project must be cleared beforehand. In addition, the service roles created by the stack and the repository contents should be deleted.

``` bastion
aws cloudformation delete-stack --stack-name <stack name> --profile <> --region <>

`1`

Note: Before deleting the stack, make sure you have backed up all the essential project data that you may need to refer to in the future.