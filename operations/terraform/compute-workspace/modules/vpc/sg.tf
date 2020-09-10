resource "aws_security_group" "web_access" {
  name        = "web_access"
  description = "allow public access for http/https traffic"
  vpc_id      = aws_vpc.this.id
  tags = merge(
    var.tags,
    { "Name" = "web_access" }
  )

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#resource "aws_security_group" "ssh" {
#  
#}
