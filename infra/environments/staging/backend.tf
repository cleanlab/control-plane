terraform {
  backend "s3" {
    bucket = "cleanlab-control-plane-tofu-state"
    key    = "staging/tofu.tfstate"
    region = "us-west-2"
  }
}
