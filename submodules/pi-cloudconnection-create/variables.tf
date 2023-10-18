variable "pi_zone" {
  description = "IBM Cloud PowerVS Zone."
  type        = string
}

variable "pi_workspace_guid" {
  description = "Existing IBM Cloud PowerVS Workspace GUID."
  type        = string
}

variable "transit_gateway_id" {
  description = "ID of the existing transit gateway. This is required to attach the CCs( Non PER environment) to TGW. Can be set to null and CCs will not be attached to TGW but it will be created."
  type        = string
}

variable "pi_cloud_connection" {
  description = "Cloud connection configuration: speed (50, 100, 200, 500, 1000, 2000, 5000, 10000 Mb/s), count (1 or 2 connections), global_routing (true or false), metered (true or false). Not applicable for PER enabled DC and CCs will not be created."
  type = object({
    count          = number
    speed          = number
    global_routing = bool
    metered        = bool
  })
}
