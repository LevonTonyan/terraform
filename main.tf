provider "aws" {
    region = "us-east-2"
} 

variable "web_port" {
    description = "port number to access server"
  type = number

}
output "public_ip" {
  value = aws_instance.terraform_demo.public_ip
  description = "The public ip address of server"
}

resource "aws_instance" "terraform_demo" {
    ami = "ami-0e820afa569e84cc1"
    instance_type = "t2.micro"
    tags = {
      Name = "terraform-demo-webServer"
    }

    user_data = <<-EOF
                    #!/bin/bash
                    echo "Hello from the other side" > index.xhtml
                    nohup busybox httpd -f -p ${var.web_port} &
                    EOF
    
    user_data_replace_on_change = true

    vpc_security_group_ids = [ aws_security_group.webServer_SG.id ]
}

resource "aws_security_group" "webServer_SG" {
    name = "terraform-demo-sg"

    ingress  {
        from_port = var.web_port
        to_port = var.web_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

   
}