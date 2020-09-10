terraform {
  backend "remote" {
    organization = "hillel-practice-project"

    workspaces {
      name = "compute"
    }
  }
}