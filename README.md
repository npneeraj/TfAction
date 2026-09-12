# TfAction 🚀

Dynamic, multi-region AWS Infrastructure as Code (IaC) automation using **Terraform** and **GitHub Actions**.

This repository demonstrates a fully parameterized, modular approach to provisioning and tearing down AWS resources. By eliminating hardcoded values and relying on dynamic cloud data sources, this pipeline can seamlessly deploy infrastructure to any AWS region on-demand via GitHub Actions `workflow_dispatch` events.

## 📌 Enterprise Features

* **Zero-Hardcoding Architecture**: Leverages Terraform Data Sources (`aws_vpc`, `aws_subnets`) to dynamically discover networking infrastructure based on the pipeline's target region.
* **Automated AMI Fetching**: Uses AWS Systems Manager (SSM) Parameter Store to automatically pull the latest, fully-patched Amazon Linux 2023 AMI at runtime.
* **Dynamic Remote State**: The S3 backend is initialized dynamically via GitHub Actions `-backend-config` injection, keeping the `.tf` code strictly environment-agnostic.
* **Modular Design**: Separates the core EC2 provisioning logic into a highly reusable child module, controlled completely via variable injection and maps.
* **Automated Teardown**: Includes a dedicated "Destructor" workflow to cleanly execute `terraform destroy` in the specified region, ensuring strict cost control for temporary lab environments.

## 🏗️ Pipeline Architecture

This repository operates on two primary, manually triggered pipelines:

**1. Provisioning Workflow (`iac.yml`)**
```text
  [Operator inputs AWS Region via GitHub UI]
                     │
                     ▼
          ┌─────────────────────┐
          │  Setup Credentials  │ (Access/Secret Keys & Session Token)
          └──────────┬──────────┘
                     │
                     ▼
          ┌─────────────────────┐
          │   Terraform Init    │ (Injects S3 backend configs dynamically)
          └──────────┬──────────┘
                     │
                     ▼
          ┌─────────────────────┐
          │   Terraform Apply   │ (Discovers Subnets/AMIs -> Provisions -> Outputs IPs)
          └─────────────────────┘

```

**2. Teardown Workflow (`destructor.yml`)**

* A mirrored pipeline that targets the user-provided region and safely executes `terraform destroy -auto-approve` to wipe the environment clean.

## ☁️ Infrastructure Details

* **Compute**: Deploys a `t2.micro` EC2 instance.
* **Networking**: Automatically deploys into the first available subnet of the target region's Default VPC.
* **Standardized Tagging**: Enforces strict resource and EBS volume tagging (e.g., `Purpose = "training"`) via variable maps to ensure cloud spend can be audited.
* **Outputs**: Extracts and prints the provisioned Instance ID, Public IP, and Private IP directly to the GitHub Actions console logs.

## 📂 Repository Structure

```text
├── .github/
│   └── workflows/
│       ├── iac.yml                # Provisioning pipeline (requests target region)
│       └── destructor.yml         # Teardown pipeline (requests target region)
├── ec2/                           # Reusable EC2 child module
│   ├── main.tf                    # Resource definitions
│   ├── variables.tf               # Input variables (ami, instance_type, subnet, tags)
│   └── outputs.tf                 # Exports resource attributes (IPs, IDs)
├── module/                        # Root execution directory
│   ├── main.tf                    # SSM/VPC data sources & module instantiation
│   ├── backend.tf                 # Empty S3 state block (populated via CLI)
│   └── outputs.tf                 # Terminal outputs for the pipeline logs
└── README.md

```

## ⚙️ Setup & Prerequisites

To run these workflows, configure the following **Repository Secrets** under `Settings > Secrets and variables > Actions`:

| Secret Name | Description |
| --- | --- |
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Key |
| `AWS_SESSION_TOKEN` | Your AWS Session Token (if using temporary STS credentials) |

**Environment Variables (Configured in YAML):**

* `BUCKET`: Ensure the S3 bucket (`npneeraj-bkt`) is pre-created in your AWS account to store the remote state.

## 🚀 Usage

**To Deploy:**

1. Navigate to the **Actions** tab in GitHub.
2. Select the **neeraj** workflow.
3. Click **Run workflow**.
4. Enter your target AWS Region (e.g., `us-east-1`, `ap-south-1`) and execute. The public IP will be visible in the workflow logs.

**To Destroy:**

1. Navigate to the **Actions** tab.
2. Select the **destroy** workflow.
3. Enter the same AWS Region used for deployment.
4. Click **Run workflow** to safely tear down the resources.

## 💡what to prompt to learn more
If you are reviewing this repository, here are a few suggested prompts you can ask to explore the architecture and design decisions:

"How does this pipeline handle Terraform state locking to prevent concurrent deployment corruption?"

"Why are the VPC and subnet_id fetched dynamically using data sources instead of being hardcoded?"

"How does the SSM Parameter Store integration ensure the EC2 instance always boots with a secure, fully-patched AMI?"

"How would we transition this pipeline's authentication model from static AWS access keys to GitHub OIDC federation?"

"What modifications are required to add an automated drift-detection cron job to this setup?"
