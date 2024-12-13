# VMWare VM Power On/Off
This module serves as a workaround to control the power of a VM in VMWare. The foundation of how this module works is the HTTP provider with the [VCenter API](https://developer.broadcom.com/xapis/vsphere-automation-api/latest/vcenter/vm/power/).

The module creates an HTTP resource to make calls to the API, it requires prior authentication to the API to include the `vmware-api-session-id` header in the request.

A `terraform_data` resource is also created (replaces `null_resource`) which represents the power state of the VM. You can think of this module as a 'Power State' resource whose value can be `POWERED_ON` and `POWERED_OFF` which is also the value that you should specify in the `desired_state` variable.

The change in this variable triggers the creation of the `terraform_data` resource, whose value, in turn is used to avoid calling the API when running a plan and to guarantee the API will get called only when executing apply runs.

In reality, the API gets called in both plan and apply runs, but if you look at the code, you'll see the change in the power state is avoided in plan runs by changing the API request to the 'get power' endpoint (which doesn't make any change). The power change is detected by reading the value of the `terraform_data` resource and comparing with the _actual power state_ of the VM.

---
## Usage

```hcl
module "vm-power" {
  source            = "[SOURCE_PATH_OR_MODULE_REGISTRY]"
  VSPHERE_SERVER    = var.VSPHERE_SERVER
  vm                = vsphere_virtual_machine.vm.moid   #Required MOID of VM
  session_token     = var.session_token
  desired_state     = var.desired_state
}
```

---
## Inputs

| Name              | Type       | Description                                                           |
| ----------------- | ---------- | --------------------------------------------------------------------- |
| VSPHERE_SERVER    | string     | The host name (FQDN) of your VSphere server.                          |
| vm                | string     | Managed object reference ID of the VM. This has the format 'vm-1234'  |
| session_token     | string     | A session token after successful authentication to the VCenter API.   |
| desired_state     | string     | Desired state for the power of the VM: 'POWERED_ON' or 'POWERED_OFF'. |

---
## Outputs

| Name           | Type       | Description                             |
| -------------- | ---------- | --------------------------------------- |
| power_state    | string     | The actual power state of the machine.  |

