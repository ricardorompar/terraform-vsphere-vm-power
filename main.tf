locals {
  base_url    = "https://${var.VSPHERE_SERVER}/api/vcenter/vm/${var.vm}"
  change      = jsondecode(data.http.get_vm_power.response_body).state != terraform_data.power_state.output
  change_url  = var.desired_state == "POWERED_ON" ? "${local.base_url}/power?action=start" : "${local.base_url}/guest/power?action=shutdown"
}

resource "terraform_data" "power_state" {
  input = var.desired_state
  triggers_replace = [
    var.desired_state
  ]
}

data "http" "get_vm_power" {
  url       = "${local.base_url}/power"
  method    = "GET"
  request_headers = {
    "vmware-api-session-id" : "${var.session_token}"
  }
}

data "http" "change_vm_power" {
  url       = local.change ? local.change_url : "${local.base_url}/power" #only run the POST api call if the power state requires change. Otherwise just GET again
  method    = local.change ? "POST" : "GET" #only run the POST api call if the power state requires change. Otherwise just GET again
  request_headers = {
    "vmware-api-session-id" : "${var.session_token}"
  }
}