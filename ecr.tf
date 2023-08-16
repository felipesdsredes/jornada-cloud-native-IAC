# Criação de dois repositórios para as respectivas aplicações

resource "aws_ecr_repository" "front" {
  name = "front"
}

resource "aws_ecr_repository" "back" {
  name = "back"
}
