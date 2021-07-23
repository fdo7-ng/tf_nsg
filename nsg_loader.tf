locals {
  json_data = jsondecode(file("${path.module}/sample.json"))
  json_data_raw = file("${path.module}/sample.json")
  resource_group_name         = "TestNEwork"
  network_security_group_name = "TestNSG"
  
}


output "template"{
    value = templatefile( "test.tmpl" ,{
        resource_group_name         = "TestNEwork"
        network_security_group_name = "TestNSG"
        # data = local.json_data_raw
        data = local.json_data
    })

}



output "data" {

    value = local.json_data
}
# output "object_count" {

#     value = length(local.json_data)

# }