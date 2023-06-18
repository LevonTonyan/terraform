provider "aws" {
    region = "us-east-2"
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
                    nohup busybox httpd -f -p 8080 &
                    EOF
    
    user_data_replace_on_change = true

    vpc_security_group_ids = [ aws_security_group.webServer_SG.id ]
}

resource "aws_security_group" "webServer_SG" {
    name = "terraform-demo-sg"

    ingress  {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

   
}