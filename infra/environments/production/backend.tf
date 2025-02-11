terraform {
  backend "s3" {
    bucket = "cleanlab-control-plane-tofu-state"
    key    = "production/tofu.tfstate"
    region = "us-west-2"
  }
}
