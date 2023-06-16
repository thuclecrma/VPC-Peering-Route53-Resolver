provider "aws" {
  region = "us-east-1"

  access_key = var.aws_account.access_key
  secret_key = var.aws_account.secret_key
  token      = var.aws_account.token
}

provider "aws" {
  alias  = "global_services"
  region = "us-east-1"

  access_key = var.aws_account.access_key
  secret_key = var.aws_account.secret_key
  token      = var.aws_account.token
}

provider "aws" {
  alias  = "client"
  region = "us-west-2"

  access_key = var.aws_account.access_key
  secret_key = var.aws_account.secret_key
  token      = var.aws_account.token
}

provider "random" {}
