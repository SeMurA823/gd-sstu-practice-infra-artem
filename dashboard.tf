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
        },
        {
            "type": "metric",
            "x": 0,
            "y": 14,
            "width": 12,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/EC2", "NetworkIn", "AutoScalingGroupName", "petclinic" ],
                    [ ".", "NetworkOut", ".", "." ]
                ],
                "region": "us-east-1"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 28,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "SEARCH('{CWAgent,AutoScalingGroupName,ImageId,InstanceId,InstanceType} AutoScalingGroupName=\"petclinic\" MetricName=\"mem_used_percent\"', 'Average', 300)", "id": "e1", "period": 300 } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "us-east-1",
                "stat": "Average",
                "period": 300,
                "title": "Petclinic MEMORY"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 35,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "SEARCH('{CWAgent,AutoScalingGroupName,ImageId,InstanceId,InstanceType} AutoScalingGroupName=\"petclinic\" MetricName=\"swap_used_percent\"', 'Average', 300)", "id": "e1", "period": 300 } ]
                ],
                "unit": "percent",
                "view": "timeSeries",
                "stacked": false,
                "region": "us-east-1",
                "stat": "Average",
                "period": 300,
                "title": "Petclinic SWAP"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 42,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "SEARCH('{CWAgent,AutoScalingGroupName,ImageId,InstanceId,InstanceType,device,fstype,path} AutoScalingGroupName=\"petclinic\" MetricName=\"disk_used_percent\" path=\"/\"', 'Average', 300)", "label": "Disk root", "id": "e1", "period": 300 } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "us-east-1",
                "stat": "Average",
                "period": 300,
                "title": "Petclinic ROOT disk usage"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 49,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "SEARCH('{CWAgent,AutoScalingGroupName,ImageId,InstanceId,InstanceType,cpu} MetricName=\"cpu_usage_user\" AutoScalingGroupName=\"petclinic\"', 'Average', 300)", "label": "CPU USER", "id": "e1", "period": 300 } ]
                    ],
                "view": "timeSeries",
                "stacked": false,
                "region": "us-east-1",
                "stat": "Average",
                "title": "Petclinic CPU USER"
            }   
        },
        {
            "type": "metric",
            "x": 0,
            "y": 56,
            "width": 24,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "SEARCH('{CWAgent,AutoScalingGroupName,ImageId,InstanceId,InstanceType,cpu} MetricName=\"cpu_usage_system\" AutoScalingGroupName=\"petclinic\"', 'Average', 300)", "label": "CPU SYSTEM", "id": "e1", "period": 300 } ]
                    ],
                "view": "timeSeries",
                "stacked": false,
                "region": "us-east-1",
                "stat": "Average",
                "title": "Petclinic CPU SYSTEM"
            }   
        }
    ]
}
EOF
}