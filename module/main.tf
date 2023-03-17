module "ec2" {
    source = "../ec2"
    ami-id = "ami-05afd67c4a44cc983"
    instance-type = "t2.micro"
  
}