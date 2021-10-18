
provider "aws" {
  access_key = "${var.a_access_key}"
  secret_key = "${var.a_secret_key}"
  region = "${var.a_region}"
}

resource "aws_key_pair" "instance_keypair" {
  key_name   = "${var.a_name}-keypair"
  public_key = "${var.a_public_key}"
}

# t2.micro, t2.medium
resource "aws_instance" "instance" {
  ami           = "${var.a_image}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.instance_keypair.key_name}"
  subnet_id = "${var.a_subnet}"
  vpc_security_group_ids = ["${var.a_vpc_security_group_id}"]
  associate_public_ip_address = true
  tags = {
    Name = "${var.a_name}"
    Owner = "hobbyfarm"
    DoNotDelete = "true"
  }
  root_block_device {
    volume_type = "standard"
    volume_size = "${var.a_disk}"
    delete_on_termination = true
  }
}

output "private_ip" {
  value = "${aws_instance.instance.private_ip}"
}

output "public_ip" {
  value = "${aws_instance.instance.public_ip}"
}

output "hostname" {
  value = "${aws_instance.instance.public_dns}"
}
