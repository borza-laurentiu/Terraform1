variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}
variable "name" {
  type    = string
  default = ""
}
variable "ami_id" {
  type    = string
  default = "ami-0015a39e4b7c0966f"
}
variable "ssh_key" {
  type    = string
  default = "New_Key"
}
variable "vpc_id" {
  type    = string
  default = "vpc-0a06473c5d624cf0f"
}
variable "subnet_id" {
  type    = string
  default = "subnet-0f99bc33319acef12"
}