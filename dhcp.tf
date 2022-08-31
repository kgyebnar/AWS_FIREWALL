// create DHCP options for the VPC
resource "aws_vpc_dhcp_options" "dns_resolvers" {
  domain_name = "aws.nam.nsroot.net"
  domain_name_servers = "${var.dnsservers}"
    tags = {
        Name = "DHCPoptions"
    }
}
// associate DHCP options with the VPC
resource "aws_vpc_dhcp_options_association" "dns_resolvers" {
  vpc_id = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolvers.id}"
}

