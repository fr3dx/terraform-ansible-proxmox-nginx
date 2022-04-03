variable "Test_Env" {
  description = "declare env var"
  type        = string
}

output "Test_Env" {
  description = "Echo env var"
  value       = var.Test_Env
}