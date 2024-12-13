output "power_state" {
  description   = "The actual power state of the machine."
  value         = terraform_data.power_state.output
}