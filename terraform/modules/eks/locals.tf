data "http" "my_public_ip" {
  url = "https://ifconfig.me"
}

locals {
  runner_ip         = "${chomp(data.http.my_public_ip.response_body)}/32"
  all_allowed_cidrs = concat([local.runner_ip], var.office_ips)
}