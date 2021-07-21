resource "aws_cloudwatch_dashboard" "main_dashboard" {
    dashboard_name = "main-dashboard"
    dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [
                        "AWS/EC2",
                        "CPUUtilization",
                        "AutoScalingGroupName",
                        "petclinic"
                    ]
                ],
                "period": 300,
                "stat": "Average",
                "region": "us-east-1",
                "title": "Autoscalling group CPU"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 7,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [
                        "AWS/EC2",
                        "DiskReadBytes",
                        "AutoScalingGroupName",
                        "petclinic"
                    ]
                ],
                "period": 300,
                "stat": "Average",
                "region": "us-east-1",
                "title": "Autoscalling group DiskReadBytes"
            }
        }

    ]
}
EOF
}