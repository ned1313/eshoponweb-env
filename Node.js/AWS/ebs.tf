## Elastic Beanstalk

resource "aws_elastic_beanstalk_application" "crud" {
  name        = var.name
  description = "Node JS CRUD"
}

resource "aws_elastic_beanstalk_environment" "crud" {
    name = var.name
    application = aws_elastic_beanstalk_application.crud.name
    solution_stack_name = "64bit Amazon Linux 2 v5.2.1 running Node.js 12"
    description =  "Node JS env CRUD"

    setting {
        namespace = "aws:ec2:instances"
        name = "InstanceTypes"
        value = "c5.large"
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "InstanceType"
        value = "c5.large"
    }

    setting {
        namespace = "aws:cloudformation:template:parameter"
        name = "InstanceTypeFamily"
        value = "c5"
    }

    setting {
        resource = "AWSEBAutoScalingLaunchConfiguration"
        namespace = "aws:autoscaling:launchconfiguration"
        name = "IamInstanceProfile"
        value = "aws-elasticbeanstalk-ec2-role"
    }

    setting {
        namespace = "aws:ec2:vpc"
        name = "VPCId"
        value = module.vpc.vpc_id
    }

    setting {
        resource = "AWSEBAutoScalingGroup"
        namespace = "aws:autoscaling:asg"
        name = "Availability Zones"
        value = "Any"
    }

    setting {
        resource = "AWSEBAutoScalingGroup"
        namespace = "aws:autoscaling:asg"
        name = "Cooldown"
        value = "360"
    }

    setting {
        resource = "AWSEBAutoScalingGroup"
        namespace = "aws:autoscaling:asg"
        name = "MaxSize"
        value = "4"
    }

    setting {
        resource = "AWSEBAutoScalingGroup"
        namespace = "aws:autoscaling:asg"
        name = "MinSize"
        value = "2"
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "InstanceType"
        value = "t2.micro"
    }

    setting {
        resource = "AWSEBCloudwatchAlarmLow"
        namespace = "aws:autoscaling:trigger"
        name = "LowerThreshold"
        value = "25"
    }

    setting {
        resource = "AWSEBCloudwatchAlarmLow"
        namespace = "aws:autoscaling:trigger"
        name = "MeasureName"
        value = "CPUUtilization"
    }

    setting {
        resource = "AWSEBCloudwatchAlarmLow"
        namespace = "aws:autoscaling:trigger"
        name = "Period"
        value = "5"
    }

    setting {
        resource = "AWSEBCloudwatchAlarmLow"
        namespace = "aws:autoscaling:trigger"
        name = "Statistic"
        value = "Average"
    }

    setting {
        resource = "AWSEBCloudwatchAlarmLow"
        namespace = "aws:autoscaling:trigger"
        name = "Unit"
        value = "Percent"
    }

    setting {
        resource = "AWSEBCloudwatchAlarmHigh"
        namespace = "aws:autoscaling:trigger"
        name = "UpperThreshold"
        value = "70"
    }

    setting {
        resource = "AWSEBAutoScalingLaunchConfiguration"
        namespace = "aws:ec2:vpc"
        name = "AssociatePublicIpAddress"
        value = "true"
    }

    setting {
        namespace = "aws:ec2:vpc"
        name = "ELBScheme"
        value = "public"
    }

    setting {
        namespace = "aws:ec2:vpc"
        name = "ELBSubnets"
        value = join(",",module.vpc.public_subnets)
    }

    setting {
        resource = "AWSEBAutoScalingGroup"
        namespace = "aws:ec2:vpc"
        name = "Subnets"
        value = join(",",module.vpc.public_subnets)
    }

    setting {
        resource = "AWSEBLoadBalancerSecurityGroup"
        namespace = "aws:ec2:vpc"
        name = "VPCId"
        value = module.vpc.vpc_id
    }
}

# Create Elastic Beanstalk with 4 instances