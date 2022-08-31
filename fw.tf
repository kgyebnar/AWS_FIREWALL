
resource "aws_networkfirewall_firewall_policy" "policy1" {
  name = "policy1"

  firewall_policy {
    stateless_default_actions          = ["aws:drop"]
    stateless_fragment_default_actions = ["aws:drop"]
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.fwrule1.arn
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.fwrule2.arn
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.block_domains.arn
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.block_public_dns_resolvers.arn
    }


  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
}

resource "aws_networkfirewall_rule_group" "block_public_dns_resolvers" {
  capacity = 1
  name     = "block-public-dns"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      stateful_rule {
        action = "DROP"
        header {
          destination      = "ANY"
          destination_port = "ANY"
          direction        = "ANY"
          protocol         = "DNS"
          source           = "ANY"
          source_port      = "ANY"
        }
        rule_option {
          keyword = "sid:50"
        }
      }
    }
  }
}


resource "aws_networkfirewall_rule_group" "block_domains" {
  capacity = 100
  name     = "block-domains"
  type     = "STATEFUL"
  rule_group {
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = ["10.119.58.0/24", "10.119.59.0/24"]
        }
      }
    }
    rules_source {
      rules_source_list {
        generated_rules_type = "DENYLIST"
        target_types         = ["HTTP_HOST", "TLS_SNI"]
        targets              = [".facebook.com", ".twitter.com"]
      }
    }
  }

}


resource "aws_networkfirewall_firewall" "fw1" {
  name                = "fw1"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.policy1.arn
  vpc_id              = aws_vpc.main.id
firewall_policy_change_protection = true
 subnet_change_protection          = false
  subnet_mapping {
    subnet_id = aws_subnet.main-public-1.id
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
}

resource "aws_networkfirewall_rule_group" "fwrule1" {
  capacity = 100
  name     = "FWRULE1"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      stateful_rule {
        action = "DROP"
        header {
          destination      = "124.1.1.24/32"
          destination_port = 53
          direction        = "ANY"
          protocol         = "TCP"
          source           = "1.2.3.4/32"
          source_port      = 53
        }
        rule_option {
          keyword = "sid:1"
        }
      }
    }
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
}


resource "aws_networkfirewall_rule_group" "fwrule2" {
  capacity = 50
  name     = "FWRULE2"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      stateful_rule {
        action = "PASS"
        header {
          destination      = "1.1.1.24/32"
          destination_port = 53
          direction        = "ANY"
          protocol         = "TCP"
          source           = "1.2.3.4/32"
          source_port      = 53
        }
        rule_option {
          keyword = "sid:10"
        }
      }
    }
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
}