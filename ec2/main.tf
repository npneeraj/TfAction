resource "aws_instance" "ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = "subnet-0962069167a59d185"
    tags = {
        Name = "Neeraj"
        Owner = "neeraj.panwar@cloudeq.com"
        Purpose = "training"
    }
    volume_tags = {
        Name = "Neeraj"
        Owner = "neeraj.panwar@cloudeq.com"
        Purpose = "training"
      
    }
  
}