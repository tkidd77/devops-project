terraform {
  backend "s3" {
    bucket = "tkidd-util"
    key    = "hello_world/terraform.tfstate"
    region = "us-east-1"
  }
}
