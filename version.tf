#####################################################
# IBM Cloud PowerVS Workspace Module
#####################################################

terraform {
  required_version = ">= 1.3"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">=1.65.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.1"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.0.0"
    }
  }
}
