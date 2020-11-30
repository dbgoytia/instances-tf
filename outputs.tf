# # Output the public IP's of the worker nodes
# output "NODES_PUBLIC_IPS" {
#   value = {
#     for instance in aws_instance.webserver :
#     instance.id => instance.public_ip
#   }
# }
