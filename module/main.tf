# 1. Dynamically fetch the latest Amazon Linux 2023 AMI
data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

# 2. Fetch the Default VPC for the region the pipeline is running in
data "aws_vpc" "default" {
  default = true
}

# 3. Fetch all available Subnets within that Default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "ec2" {
  source = "../ec2"
  ami_id        = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnets.default.ids[0]
  
  tags = {
    Name    = "Neeraj"
    Owner   = "neeraj.panwar@cloudeq.com"
    Purpose = "training"
  }
}
