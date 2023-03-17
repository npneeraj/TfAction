terraform {
  backend "s3"{
    bucket = "npneeraj-bkt"
    key = "terraform.tfstate"
    region = "ap-south-1"

  }
}