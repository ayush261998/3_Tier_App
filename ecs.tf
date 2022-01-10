resource "aws_ecs_cluster" "app-cluster" {
  name = "app-cluster" # Naming the cluster
}

resource "aws_ecs_task_definition" "app-task" {
  family                   = "app-task" # Naming our first task
  memory                   = 1024
  cpu                      = 512
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  container_definitions    = <<DEFINITION
  
  [
    {
      "name": "app-task",
      "image": "460996855651.dkr.ecr.us-west-2.amazonaws.com/ecr-repo:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "memory": 1024,
      "cpu": 512
    }
  ]
  DEFINITION
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



resource "aws_ecs_service" "app_service" {
  name            = "app-service"
  cluster         = "${aws_ecs_cluster.app-cluster.id}"
  task_definition = "${aws_ecs_task_definition.app-task.arn}"
  launch_type     = "FARGATE"
  desired_count   = 6
  
    load_balancer {
    target_group_arn = "${aws_lb_target_group.target_group.arn}" # Referencing our target group
    container_name   = "${aws_ecs_task_definition.app-task.family}"
    container_port   = 3000
  }
  
  network_configuration {
    subnets          = ["${aws_subnet.application_subnet_a.id}", "${aws_subnet.application_subnet_b.id}"]
    assign_public_ip = false
    security_groups  = ["${aws_security_group.service_security_group.id}"]
  }

}

resource "aws_security_group" "service_security_group" {
  vpc_id  = aws_vpc.webapp_vpc.id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}
