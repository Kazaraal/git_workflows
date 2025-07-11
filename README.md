# Git Workflows & CI/CD Automation Repository 🚀  
**Best Practices for Git Branching, GitHub Actions, and Terraform CI/CD**

This repository demonstrates professional Git workflows, branching strategies, and infrastructure-as-code automation using Terraform and GitHub Actions. Ideal for DevOps engineers and teams implementing CI/CD pipelines.

## ⚡ Quick Start

```sh
git clone https://github.com/Kazaraal/git_workflows.git
cd git_workflows

├── .github/
│   └── workflows/          # GitHub Actions workflows
│       ├── terraform.yaml  # Terraform CI/CD pipeline
│       └── ...             # Additional workflow examples

├── src/                    # Application code (optional)
    |__ modules/            # 
└── README.md

🛠️ Terraform Automation
The included GitHub Actions workflow (.github/workflows/terraform.yaml) provides:

name: Terraform CI/CD

on:
  push:
    branches: [ main ]
  pull_request:

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4  # Clones repo to $GITHUB_WORKSPACE :cite[1]
      
      - name: Terraform Init
        run: terraform init
        
      - name: Terraform Validate
        run: terraform validate
        
      - name: Terraform Plan
        run: terraform plan -var-file=terraform.tfvars