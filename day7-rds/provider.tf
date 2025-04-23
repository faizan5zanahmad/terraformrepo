
# Default provider (for resources not using aliases)
provider "aws" {
  region = "us-west-2" # or set to match your read replica region
}


# Primary region provider
provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

# Secondary region provider
provider "aws" {
  alias  = "secondary"
  region = "us-west-2"
}