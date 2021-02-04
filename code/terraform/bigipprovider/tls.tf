resource "tls_private_key" "myprivatekey" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "mycertificate" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.myprivatekey.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
