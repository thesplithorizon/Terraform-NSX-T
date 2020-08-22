/* 
  Configure multiple static routes using CSV file 
*/


# Define Provider 
provider "nsxt" {
  host                  = var.nsx_manager
  username              = var.nsx_username
  password              = var.nsx_password
  allow_unverified_ssl  = true
  max_retries           = 10
  retry_min_delay       = 500
  retry_max_delay       = 5000
  retry_on_status_codes = [429]
}

# Define Data Source
data "nsxt_policy_tier0_gateway" "provider-t0-gateway" {
  display_name = "provider-t0-gateway"
}

# Import CSV file "static_route.csv" in local directory
# Using csvdecode function
locals {
csv_data = file("static_route.csv")
instances = csvdecode(local.csv_data)
}


# Define Resource
resource "nsxt_policy_static_route" "staticRoute" {
  for_each = { for inst in local.instances : inst.id => inst }
  display_name = each.value.display_name
  gateway_path = data.nsxt_policy_tier0_gateway.provider-t0-gateway.path
  network      = each.value.network

  next_hop {
    admin_distance = "1"
    ip_address     = each.value.next_hop_ip
  }
}
