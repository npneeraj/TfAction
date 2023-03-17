module "ec2" {
    source = "../ec2"

    ami_id = "ami-05afd67c4a44cc983"
    instance_type = "t2.micro"
  
}