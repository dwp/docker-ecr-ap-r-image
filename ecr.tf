resource "aws_ecr_repository" "docker-ecr-ap-r-image" {
  name = "docker-ecr-ap-r-image"
  tags = merge(
    local.common_tags,
    { DockerHub : "dwpdigital/docker-ecr-ap-r-image" }
  )
}

resource "aws_ecr_repository_policy" "docker-ecr-ap-r-image" {
  repository = aws_ecr_repository.docker-ecr-ap-r-image.name
  policy     = data.terraform_remote_state.management.outputs.ecr_iam_policy_document
}

output "ecr_example_url" {
  value = aws_ecr_repository.docker-ecr-ap-r-image.repository_url
}
