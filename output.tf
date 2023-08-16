# Definições de outputs após execução do IAC

output "ecr_repository_front_endpoint" {
  value = aws_ecr_repository.front.repository_url
}

output "ecr_repository_back_endpoint" {
  value = aws_ecr_repository.back.repository_url
}
