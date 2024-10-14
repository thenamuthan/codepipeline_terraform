resource "aws_codestarconnections_connection" "codestar_connection_example" {
  name          = "example-connection"
  provider_type = "GitHub"

}