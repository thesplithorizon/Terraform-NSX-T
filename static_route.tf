/* 
  Configure multiple static routes using CSV file 
*/

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
