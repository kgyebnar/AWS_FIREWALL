
variable "AWS_REGION" {
  default = "eu-central-1"
}
variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}
variable "AMIS" {
  type = map
  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
    eu-central-1 = "ami-027583e616ca104df"
  }
}


variable "dnsservers" {
  type    = list
  default = ["1.2.3.4", "5.6.7.8"]
}

variable "vpntags" {
  type        = map
  default     = {
    AppName = "test"
    AppID = "testApp"
    Name = "VirtualPrivateGW"
    }
}
locals {
  route_tags = "${tomap({
    Name = "AppName,net,AppID,privateroutetable,Environmenttype",
    BussinesAudit = "Installedsoftware=NA,ExpiryDate=NA|Environment",
    CTIresourceAudit = "Instantiatedby=Terraform|StartDateTime=NA|Publicrouted=No",
    CTIsystemInventory = "CSIAppid,Appid,billingprofilenumber,billingid"
  })}"
}


locals {
  common_tags = "${tomap({
    Project = "TestAppProj",
    AppName = "testApp",
    AppID = "testAppID"
    }
    )}"
}


variable "AppName" {
    default = "testApp"
}
variable "AppID" {
    default = "testAppID"
}
variable "BillingID" {
    default = "testBillingID"
}