
resource "aws_iam_role" "prometheus_role" {
  name = "PrometheusMonitoringRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_policy" "prometheus_policy" {
  name        = "PrometheusEC2MonitoringPolicy"
  description = "Allows EC2 instances to be discovered by Prometheus"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "ec2:DescribeInstances",
        "ec2:DescribeTags",
        "ec2:DescribeVpcs",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets"
      ]
      Resource = "*"
    }]
  })
}


resource "aws_iam_role_policy_attachment" "attach_prometheus_policy" {
  policy_arn = aws_iam_policy.prometheus_policy.arn
  role       = aws_iam_role.prometheus_role.name
}


resource "aws_iam_instance_profile" "prometheus_instance_profile" {
  name = "PrometheusMonitoringProfile"
  role = aws_iam_role.prometheus_role.name
}



resource "aws_instance" "public_instances" {
  count                  = 2  
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = element(var.public_subnet_ids, count.index)  
  key_name               = var.key_name
  vpc_security_group_ids = [var.public_sg_id]
  iam_instance_profile   = aws_iam_instance_profile.prometheus_instance_profile.name

  tags = {
    Name        = "promethues_server-${count.index + 1}"
    Prometheus  = "enabled"  
  }
}



output "public_instance_ips" {
  value = aws_instance.public_instances[*].public_ip  
}

