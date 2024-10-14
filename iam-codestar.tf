resource "aws_iam_policy" "codestar_connection_policy" {
  name        = "appexample-dev-codestar-connection-policy"
  description = "A policy with permissions for codestar connection"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codestar-connections:UseConnection",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:RegisterApplicationRevision",
          "codedeploy:GetApplicationRevision"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_codestar_connection_policy" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codestar_connection_policy.arn
}
#Now let’s define a service role for CodeBuild. We want to allow CodeBuild to write logs to CloudWatch and to put artifacts into the S3 bucket with the application code. So a policy for it will look like this:

data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "example_codebuild_project_role" {
  name               = "appexample-dev-codebuild-role-us-east-1"
  assume_role_policy = data.aws_iam_policy_document.codebuild_policy.json
}

resource "aws_iam_policy" "codebuild_write_cloudwatch_policy" {
  name        = "appexample-dev-codebuild-policy-us-west-1"
  description = "A policy for codebuild to write to cloudwatch"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "cloudwatch:*",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:DescribeLogStreams"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : ["s3:*"],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_codebuild_write_cloudwatch_policy" {
  role       = aws_iam_role.example_codebuild_project_role.name
  policy_arn = aws_iam_policy.codebuild_write_cloudwatch_policy.arn
}
resource "aws_iam_policy" "codepipline_execution_policy" {
  name        = "appexample-dev-codepipeline-policy"
  description = "A policy with permissions for codepipeline"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow"
        "Action" : ["codebuild:StartBuild", "codebuild:BatchGetBuilds"],
        "Resource" : "*",
      },
      {
        "Action" : ["cloudwatch:*"],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : ["s3:Get*", "s3:List*", "s3:PutObject"],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : ["codedeploy:CreateDeployment", "codedeploy:GetDeploymentConfig"],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}
resource "aws_iam_role" "codepipeline_role" {
  name = "appexample-dev-codepipeline-role"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codepipeline.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}