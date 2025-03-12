resource "aws_instance" "public_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [var.public_sg_id]
  iam_instance_profile = aws_iam_instance_profile.prometheus_instance_profile.name  # ✅ IAM Role Attach Ho Raha Hai

  tags = { Name = "public-instance" }
}

resource "aws_instance" "private_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [var.private_sg_id]
  iam_instance_profile = aws_iam_instance_profile.prometheus_instance_profile.name  # ✅ IAM Role Attach Ho Raha Hai

  tags = { Name = "private-instance" }
}

# IAM Role for Prometheus EC2
resource "aws_iam_role" "prometheus_role" {
  name = "PrometheusEC2Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "ec2.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM Policy to allow Prometheus to discover EC2 instances
resource "aws_iam_policy" "prometheus_policy" {
  name        = "PrometheusEC2Policy"
  description = "Allow Prometheus to discover EC2 instances"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ec2:DescribeInstances", "ec2:DescribeTags"],
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "attach_prometheus_policy" {
  policy_arn = aws_iam_policy.prometheus_policy.arn
  role       = aws_iam_role.prometheus_role.name
}

# IAM Instance Profile for attaching IAM Role to EC2
resource "aws_iam_instance_profile" "prometheus_instance_profile" {
  name = "PrometheusInstanceProfile"
  role = aws_iam_role.prometheus_role.name
}


output "public_instance_ip" {
  value = aws_instance.public_instance.public_ip
}

output "private_instance_ip" {
  value = aws_instance.private_instance.private_ip
}
