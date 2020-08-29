/* 
  Configure multiple NSX-T Segment using CSV file 
*/

# Define Data Source for Tier1 Gateway
data "nsxt_policy_tier1_gateway" "tenant1-t1-gw" {
  display_name = "tenant1-t1-gw"
}

# Define Data Source for Transport Zone
data "nsxt_policy_transport_zone" "tz-overlay" {
  display_name = "tz-overlay"
}


# Import CSV file "segment.csv" in local directory
# Using csvdecode function
locals {
csv_data = file("logical_segment.csv")
instances = csvdecode(local.csv_data)
}


# Define Resource
resource "nsxt_policy_segment" "segment" {
  for_each = { for inst in local.instances : inst.id => inst }
  display_name = each.value.display_name
  connectivity_path   = data.nsxt_policy_tier1_gateway.tenant1-t1-gw.path
  transport_zone_path = data.nsxt_policy_transport_zone.tz-overlay.path
  
  subnet {
     # Define Gatewy IP in cidr format
     cidr =  each.value.cidr
  }

}
