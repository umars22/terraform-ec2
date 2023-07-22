resource "aws_instance" "my-instance" {
  key_name        = aws_key_pair.terraform-key.key_name
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.my-sg.name]


  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo echo 'big-bruh' | sudo tee /etc/hostname",
      "sudo mkdir laka",
      "sudo echo 'yeeee' | sudo tee /home/ec2-user/laka/lol.txt",
    ]
  }

  provisioner "local-exec" {
    command = "ssh ec2-user@${aws_instance.my-instance.public_ip} 'sudo cat /home/ec2-user/laka/lol.txt'"
  }

}

output "jenkins_instance_public_ip" {
  value = aws_instance.my-instance.public_ip
}
