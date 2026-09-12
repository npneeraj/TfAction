# dynamically inject bucket, key, and region via the -backend-config CLI flags.
terraform {
  backend "s3" {}
}
