resource "aws_instance" "webserver" {
  count         = "${var.ec2_count}"
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  associate_public_ip_address = true
  subnet_id     = "${var.subnet_id}"
  security_groups = ["${var.security_group}"]
  monitoring    = true
  key_name = "denislavSSH"
  user_data = "#!/bin/bash -ex\n yum install httpd -y\n systemctl start httpd\n cd /var/www/html\n echo $HOSTNAME > index.html\n"
  
  tags = {
    Name = "WebServer"
  }
}

  resource "aws_elb" "task" {
  name               = "task-elb"
  
   subnets         = ["${var.subnet_id}"]
   security_groups = ["${var.security_group}"]
  internal        = false
  

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  
  instances                   = aws_instance.webserver.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  
  tags = {
    Name = "denislav-terraform-elb"
  }
}