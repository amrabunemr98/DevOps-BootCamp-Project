# resource "aws_iam_policy" "ebs_policy" {
#   name = "EBSPolicy"
  
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = [
#           "ec2:AttachVolume",
#           "ec2:DetachVolume"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role" "ebs_role" {
#   name = "EBSRole"
  
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect    = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_instance_profile" "ebs" {      
#   name       = "ebs-temp"
#   role       = aws_iam_role.ebs_role.name
# }

# resource "aws_iam_role_policy_attachment" "ebs_role_attachment" {
#   policy_arn = aws_iam_policy.ebs_policy.arn
#   role       = aws_iam_role.ebs_role.name
# }

resource "aws_ebs_volume" "my_ebs_volume" {
  availability_zone = "us-east-1a"   
  size              = 2  

#   # Use the IAM role for the EBS volume
#   kms_key_id    = "alias/aws/ebs"
#   encrypted     = true
#   create_snapshot = false
#   volume_type   = "gp2"
#   tags = {
#     Name = "MyEBSVolume"
#   }
#   iam_instance_profile = aws_iam_role.ebs_role.name
}
