resource "aws_instance" "ec2" {
    ami = var.ami-id
    instance-type = var.instance-type
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