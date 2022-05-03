terraform {
  cloud {
    organization = "nullreference"

    workspaces {
      tags = ["nullreference-papermc"]
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8.0"
    }
    hashicorp = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

provider "archive" {}
