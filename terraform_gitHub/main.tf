
terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "5.18.3"
    }
  }
}

provider "github" {
  # Configuration options
  token = var.my-token
}


resource "github_repository" "terraform_example" {
  name        = "terraform-example"
  description = "My example repostory"

  visibility = "public"
  auto_init = true
}

resource "github_repository_file" "file" {
  repository          = github_repository.terraform_example.name
  branch              = "main"
  file                = ".gitignore"
  content             = "**/*.tfstate"
  overwrite_on_create = true
}