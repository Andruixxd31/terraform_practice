# User Pool
resource "aws_cognito_user_pool" "pocRBAC" {
  name = "pocRBAC"
}

resource "aws_cognito_identity_pool" "pocRBAC" {
  identity_pool_name = "pocRBAC"
  allow_unauthenticated_identities = false
}
