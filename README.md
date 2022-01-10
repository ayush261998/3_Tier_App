# 3_Tier_App





Process to setup the infrastructure for an Hello World application which has been Dockerized. 
    Dockerize the App.
    • Create a simple Node app and run it locally. (Pre req done)
    • Dockerize the Node app. (Pre req done)
    
  1:  Create an image repository on AWS ECR and push the image. 
        Create a ECR repo on AWS using terraform.
        >>>terraform apply -target=aws_ecr_repository.my_first_ecr_repo
        Push the image from local docker to the ecr repo. (Manually Done using the commands from aws)
    
    2st step: Create VPC and Subnets
        I followed the basic 3 Tier infrastructure and created 1 Public subnet, 2 private subnets each for Application(ECS) and Database.
            The public Subnet is where the load balancer is loacted which connects and has a target group of the ECS containers which are loacted in the private subnet.
        Difference between aws_route_tables vs aws_route module?
    
   3: Create an AWS ECS cluster.
            
    
    Create an AWS ECS task.
    
    Create an AWS ECS service.
        Managed by FARGATE instead of EC2 (Autoscaling) as I was having issues with 
    
    Create a load balancer.


The msot important things to keep in mind when designing an infrastructure in AWS for applications
        Keep in mind of the ports and how you design the security groups to specifically configure what you allow to your services, load balancers and what you do not allow.
        I kept it simple and allowed everything and kept it open for most of it since it was being a little difficult initially to run the application successfully as the load balancer health checks were failing.
        
        


Done first because of Ecr creation
Creating a ECR repo using terraform and the pushing the images from docker to ecr repo usinf aws cli 


1st step: Create VPC and Subnets



• ECS Cluster: It is a logical grouping of tasks or services. It can use EC2 instances as resources managed by the user, or can be a serverless compute engine for containers better known as Fargate.
• Container Definition: It is basically a docker container description where ports, docker image, cpu and others are defined.
• Task Definition: It is where other necessary configurations for containers are set with respect to AWS, such IAM roles, tags, data volumes and others.
• Service: It takes care that conditions are fulfilled. In other words, if a task definition has been defined, it can indicate how many replicas of out application to run, and in case something happens to a docker container, the service will be in charge of raining one again as long as the conditions indicated are met.



