variable "pi_zone" {
  description = "IBM Cloud PowerVS Zone."
  type        = string
}

variable "pi_workspace_guid" {
  description = "Existing IBM Cloud PowerVS Workspace GUID."
  type        = string
}

variable "pi_transit_gateway_connection" {
  description = "Set enable to true and provide ID of the existing transit gateway to attach the CCs( Non PER environment) to TGW. If enable is false, CCs will not be attached to TGW but CCs will be created."
  type = object({
    enable             = bool
    transit_gateway_id = string
  })
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
