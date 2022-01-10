# 3_Tier_App
Process to setup the infrastructure for an Hello World application which has been Dockerized. 
    Dockerize the App.
    This was interesting to learn since I had not got to use containers before so it was a good starting point to understand on how docker container works.
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
    
3: Create an AWS ECS cluster. (pretty straightforward)
     Create an ECS:
     Task Definition: It is where other necessary configurations for containers are set with respect to AWS and where container     definitions is configured.      
    Container Definition: It is basically a docker container description where ports, docker image, cpu and others are defined.
     
    Create an AWS ECS service:
        Managed by FARGATE instead of EC2 (Autoscaling) as I was having issues with autoscaling initially and causing
    
4: Create a load balancer:
    



NOTES
The msot important things to keep in mind when designing an infrastructure in AWS for applications
        Keep in mind of the ports and how you design the security groups to specifically configure what you allow to your services, load balancers and what you do not allow.
        I kept it simple and allowed everything and kept it open for most of it since it was being a little difficult initially to run the application successfully as the load balancer health checks were failing.
        
  
Learn to use EC2 instance and autoscaling instead of trying to use FARGATE, more control over the infrstructure.
Learning the IAM roles, havign to know what roles would apply for each type of resource/service.





For a 3 Tier web-APP

with a public subnet which has a internet facing load balancer which has a target group of ecs service for the web tier in the same subnet

The web tier then calls the api url for requestswhich would be the URL to the load balancer on the second public subnet where the ecs service would be running the api tier. The load balancer in this would be listening for requests from the first web service and passing these to the target group which is the ecs service running the api node. 

Following this the api tier makes request to the db url which would be the load balancer in the privaite subnet which has a target group of database instance running

All this would be in 2 different AZ groups to increase avaibility. 
This would not give cross regional HA.

