resource "aws_instance" "example" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = "${aws_subnet.main-private-1.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.allow-filters.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"
}

resource "aws_network_interface" "bar1" {
  subnet_id = "${aws_subnet.main-private-1.id}"
   tags = {
    Name = "private_network_interface"
  }
}
resource "aws_network_interface" "bar2" {
  subnet_id = "${aws_subnet.main-public-1.id}"
   tags = {
    Name = "secondary_network_interface"
  }
}
resource "aws_instance" "example2" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
 # the VPC subnet
 network_interface {
     network_interface_id = "${aws_network_interface.bar1.id}"
     device_index = 0
  }
 network_interface {
     network_interface_id = "${aws_network_interface.bar2.id}"
     device_index = 1
  }


  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"
}
