terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "terraform-data-xyz"
    key          = "state-files/crc-backend.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "crc_backend" {
  bucket = "this-bucket-will-be-deleted-asdflkajsdflasdgh"
}
