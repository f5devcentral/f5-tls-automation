
resource "bigip_ssl_certificate" "test-cert" {
  name      = "servercert.crt"
  content   = tls_self_signed_cert.mycertificate.cert_pem
  partition = "Common"
}

resource "bigip_ssl_key" "test-key" {
  name      = "serverkey.key"
  content   = tls_private_key.myprivatekey.private_key_pem
  partition = "Common"
}

resource "bigip_ltm_profile_client_ssl" "myClientSSLProfile" {
  depends_on = [
    bigip_ssl_key.test-key,
    bigip_ssl_certificate.test-cert
  ]
  name          = "/Common/myClientSSLProfile"
  defaults_from = "/Common/clientssl"
  #authenticate  = "always"
  ciphers = "DEFAULT"
  cert    = "/Common/servercert.crt"
  key     = "/Common/serverkey.key"
}
