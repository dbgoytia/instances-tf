# Output the public IP's of the worker nodes
output "NODES_IDS" {
    value = {
        for instance in aws_instance.webserver:
            instance.id => instance.id
    }
}

# output "INSTANCE_ID" {
#   value = aws_instance.webserver.id
# }