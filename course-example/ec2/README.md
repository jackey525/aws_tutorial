### Lab 需求
EC2   
https://us-west-1.console.aws.amazon.com/ec2/v2/home?region=us-west-1#Home:

EBS   
https://us-west-1.console.aws.amazon.com/ec2/v2/home?region=us-west-1#Volumes:sort=desc:createTime

KeyPair   
https://us-west-1.console.aws.amazon.com/ec2/v2/home?region=us-west-1#KeyPairs:   

EC2 Role   
https://console.aws.amazon.com/iam/home?region=us-west-1#/roles   


### Lab EC2 System   
Ubuntu 18.04

### BootStrap Script Sample      
安裝nginx / aws-cli
```
#!/bin/bash
sudo apt update -y 
sudo apt install -y nginx
sudo apt install -y unzip
sudo systemctl enable nginx
sudo systemctl start nginx
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```


### Running With Terraform   
記得要設定好自己的Credentials !   
產好後可以透過export的方式做單次使用
```
export AWS_ACCESS_KEY_ID="ABCDEFGHIJKLMNOPQRST"
export AWS_SECRET_ACCESS_KEY="ABCDEFGHIJKLMNOPQRSTABCDEFGHIJKLMNOPQRSTABCDEFGHIJKLMNOPQRST"
export AWS_DEFAULT_REGION="us-east-1"
```
terraform sample測試法   
```
cd terraform
terraform init
terraform apply
terraform destroy
```
