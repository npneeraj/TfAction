resource "aws_instance" "ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
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