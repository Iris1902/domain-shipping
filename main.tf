provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  token      = var.AWS_SESSION_TOKEN
}

module "domain_products" {
  source = "./modules/microservice"
  name   = "domain-products"
  image_user_create = "ievinan/microservice-product-create"
  port_user_create  = 6000
  image_user_read   = "ievinan/microservice-product-read"
  port_user_read    = 6001
  image_user_update = "ievinan/microservice-product-update"
  port_user_update  = 6002
  image_user_delete = "ievinan/microservice-product-delete"
  port_user_delete  = 6003
  branch        = var.BRANCH_NAME
  db_connection = var.DB_CONNECTION
  db_host       = var.DB_HOST
  db_port       = var.DB_PORT
  db_database   = var.DB_DATABASE
  db_username   = var.DB_USERNAME
  db_password   = var.DB_PASSWORD
}


resource "aws_sns_topic" "asg_alerts" {
  name = "asg-alerts-topic"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.asg_alerts.arn
  protocol  = "email"
  endpoint  = "ievinan@uce.edu.ec"
}

resource "aws_cloudwatch_metric_alarm" "asg_high_cpu" {
  alarm_name          = "asg-high-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarma si el promedio de CPU de las instancias del ASG supera el 70%"
  dimensions = {
    AutoScalingGroupName = module.domain_products.asg_name
  }
  alarm_actions = [aws_sns_topic.asg_alerts.arn]
}

resource "aws_cloudwatch_dashboard" "asg_dashboard" {
  dashboard_name = "asg-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        "type" = "metric",
        "x" = 0,
        "y" = 0,
        "width" = 24,
        "height" = 6,
        "properties" = {
          "metrics" = [
            [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", module.domain_products.asg_name ]
          ],
          "period" = 300,
          "stat" = "Average",
          "region" = var.AWS_REGION,
          "title" = "ASG CPU Utilization"
        }
      }
    ]
  })
}