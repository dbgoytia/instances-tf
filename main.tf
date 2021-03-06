# Get Amazon Linux AMI image ID
data "aws_ssm_parameter" "amazon_linux_ami" {
  name = var.ami
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

data "aws_s3_bucket_object" "bootstrap_script" {
  bucket = var.bootstrap_scripts_bucket
  key    = var.bootstrap_script_key
}

# Create the instance
resource "aws_instance" "webserver" {

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

  # Bootstrap script
  user_data = data.aws_s3_bucket_object.bootstrap_script.body

  # Enable monitoring for device (Cloudwatch)
  monitoring = var.monitoring

  # Enable encription
  root_block_device {
    encrypted = true
  }
}

