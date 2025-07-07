variable "AWS_REGION" {
  type    = string
  default = "us-east-1"
}

variable "AWS_ACCESS_KEY_ID" {
  type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
}

variable "AWS_SESSION_TOKEN" {
  type = string
}

variable "BRANCH_NAME" {
  type    = string
  default = "dev"
}

variable "DB_CONNECTION" {
  type        = string
  description = "Tipo de conexión de la base de datos"
}

variable "DB_HOST" {
  type        = string
  description = "Host de la base de datos"
}

variable "DB_PORT" {
  type        = string
  description = "Puerto de la base de datos"
}

variable "DB_DATABASE" {
  type        = string
  description = "Nombre de la base de datos"
}

variable "DB_USERNAME" {
  type        = string
  description = "Usuario de la base de datos"
}

variable "DB_PASSWORD" {
  type        = string
  description = "Contraseña de la base de datos"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0697808a974fef452"
}

variable "subnets" {
  type    = list(string)
  default = ["subnet-0049cf73cb42dc01f", "subnet-03bd5e4b54dfcfb6e"]
}

variable "ami_id" {
  type    = string
  default = "ami-020cba7c55df1f615"
}
