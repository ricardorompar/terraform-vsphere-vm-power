variable "VSPHERE_SERVER" {
  description = "The host name (FQDN) of your VSphere server."
}

variable "vm" {
  description   = "Managed object reference ID of the VM. This has the format 'vm-1234'"
}

# Get the session token variable by running:
# curl -k -X POST -u "${VCENTER_USERNAME}:${VCENTER_PASSWORD}" https://${VCENTER}/api/session
# More info: https://developer.broadcom.com/xapis/vsphere-automation-api/latest/vcenter/api/vcenter/authentication/token/post/
variable "session_token" {
  description   = "A session token after successful authentication to the VCenter API."
}

variable "desired_state" {
  description = "Desired state for the power of the VM: 'POWERED_ON' or 'POWERED_OFF'."
  type = string
  default = "POWERED_ON"
  validation {
    condition     = var.desired_state == "POWERED_ON" || var.desired_state == "POWERED_OFF"
    error_message = "Must be one of 'POWERED_ON' or 'POWERED_OFF'"
  }
}