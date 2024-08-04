terraform {
  cloud {
    organization = "Learn_Terraform_RK"

    workspaces {
      name = "devops-aws-myapp-dev"
    }
  }
}