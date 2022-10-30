terraform {
    backend "s3" {
      encrypt = true
      bucket = "terraform-provider-versioning-app-test"
      key = "terraform-infra.tfstate"
      region = "us-east-1"
    }
  }