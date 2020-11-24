# Get Amazon Linux AMI image ID
data "aws_ssm_parameter" "amazon_linux_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Retrieve aws secret object
data "aws_secretsmanager_secret" "secrets" {
  arn = var.ssh-key-arn
}

# Read AWS secret id
data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

# Create a key-pair for loggin into our instance
resource "aws_key_pair" "webserver-key" {
  key_name   = var.key_pair_name
  public_key = data.aws_secretsmanager_secret_version.current.secret_string
}

# Create the instance
resource "aws_instance" "webserver" {

  # Create "N" number of instances
  count = var.servers-count

  # Use retrevied amazon ID.
  ami = data.aws_ssm_parameter.amazon_linux_ami.value

  # Make the instance publicly accessible
  associate_public_ip_address = true

  # Instance type to be deployed
  instance_type = var.instance-type

  # Attach keypair to login to the instances
  key_name = aws_key_pair.webserver-key.key_name


  # Attach security group
  vpc_security_group_ids = [aws_security_group.allow_webserver.id]

  # Attach the subnet created in the networking module
  subnet_id = var.subnet_id

  tags = {
    Lab = join("_" , ["webserver_node_", count.index + 1])
  }
}