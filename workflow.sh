terraform init
sleep 1
terraform apply -target=aws_ecr_repository.ecr-repo
sleep 10
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 460996855651.dkr.ecr.us-west-2.amazonaws.com
sleep 3
docker tag ecr-repo:latest 460996855651.dkr.ecr.us-west-2.amazonaws.com/ecr-repo:latest
sleep 2
docker push 460996855651.dkr.ecr.us-west-2.amazonaws.com/ecr-repo:latest
sleep 2
terraform plan
sleep 10
terraform apply

