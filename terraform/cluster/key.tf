
resource "tls_private_key" "vmss_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
