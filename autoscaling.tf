resource "aws_appautoscaling_target" "app" { 
  max_capacity        = 4 
  min_capacity        = 1 
  resource_id         = "service/spamoverflow/spamoverflow" 
  scalable_dimension  = "ecs:service:DesiredCount" 
  service_namespace   = "ecs" 
  depends_on = [ aws_ecs_service.spamoverflow ]
} 
 
 
resource "aws_appautoscaling_policy" "app-cpu" { 
  name                = "app-cpu" 
  policy_type         = "TargetTrackingScaling" 
  resource_id         = aws_appautoscaling_target.app.resource_id 
  scalable_dimension  = aws_appautoscaling_target.app.scalable_dimension 
  service_namespace   = aws_appautoscaling_target.app.service_namespace 
 
  target_tracking_scaling_policy_configuration { 
    predefined_metric_specification { 
      predefined_metric_type  = "ECSServiceAverageCPUUtilization" 
    } 
 
    target_value              = 20 
  } 
}