resource "aws_ecr_repository" "neonsign" {
  name                 = "neonsign"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_image" "neonsign" {
    repository_name = aws_ecr_repository.neonsign.name
    image_tag       = data.external.docker_image.result.image_tag
}
