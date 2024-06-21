terraform {
  backend "remote" {
    organization = "eliseo_lopez_bravo"

    workspaces {
      name = "elb-workspace"
    }
  }
}

# Specify the required version of Terraform
terraform {
  required_version = ">= 0.13"
}

# Specify the required providers
terraform {
  required_providers {
    netlify = {
      source  = "netlify/netlify"
      version = ">= 1.0.0"
    }
    fauna = {
      source  = "fauna/fauna"
      version = ">= 0.1.0"
    }
  }
}

# Configure the Netlify provider
provider "netlify" {
  oauth_token = var.netlify_auth_token
}

# Configure the FaunaDB provider
provider "fauna" {
  secret = var.faunadb_server_secret
}

# Define the variables for Netlify and FaunaDB
variable "netlify_auth_token" {
  type        = string
  description = "Netlify personal access token"
  default     = ""
}

variable "faunadb_server_secret" {
  type        = string
  description = "FaunaDB server secret"
  default     = ""
}

# Create a new Netlify site
resource "netlify_site" "site" {
  name          = "el2-netlify-faunadb"
  custom_domain = "el2-netlify-faunadb" # Optional
}

# Deploy your application files to Netlify
resource "netlify_deploy" "deployment" {
  site_id = netlify_site.site.id
  dir     = "../build"
}

# Create a new FaunaDB database (optional)
resource "fauna_database" "fauna_db" {
  name = "netlify-faunadb"
}

# Output the site URL
output "netlify_site_url" {
  value = netlify_site.site.ssl_url
}

# Output the FaunaDB database name
output "faunadb_database_name" {
  value = fauna_database.fauna_db.name
}
