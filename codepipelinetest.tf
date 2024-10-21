#create codepipeline
resource "aws_codepipeline" "demo" {
  name     = "tf-test-pipeline"
  role_arn = aws_iam_role.demo-codepipeline.arn
  artifact_store {
    location = aws_s3_bucket.demo-artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"
      version  = "1"
      #provider = "GitHub"
      #version = "1"
      output_artifacts = ["demo-docker-source"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.codestar_connection_example.arn
        FullRepositoryId = "thenamuthan/repo"
        BranchName       = "main"
        #OAuthToken = var.GITHUB_TOKEN
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["demo-docker-source"]
      output_artifacts = ["demo-docker-build"]
      configuration = {
        ProjectName = aws_codebuild_project.demo.name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "DeployToECS"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      input_artifacts = ["demo-docker-build"]
      configuration = {
        ApplicationName                = aws_codedeploy_app.demo.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.demo.deployment_group_name
        TaskDefinitionTemplateArtifact = "demo-docker-build"
        AppSpecTemplateArtifact        = "demo-docker-build"
      }
    }
  }
}