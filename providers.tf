provider "aws" {
  region = var.region

}

provider "aws" {
  alias  = "secondary"
  region = var.replication_region

}

terraform {
  required_providers {
    aws = {
      version = "~> 3.0"
    }
  }
}
