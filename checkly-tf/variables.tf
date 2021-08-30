variable "checkly_api_key" {}

variable "inlets-exit-node-ip" {
  default = "51.158.169.72"
}

variable "frequency" {
  default = 1
}

variable "locations" {
  default = [
    "us-west-1",
    "eu-central-1",
    "ap-south-1",
    "sa-east-1"
  ]
}