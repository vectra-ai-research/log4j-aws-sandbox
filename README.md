# Log4Shell Deployable Sandbox (CVE-2021-44228)
Terraform deployment for a log4J testing sanbox complete with vulnerable application and JNDI Exploit Server.

## Steps to Deployment

- Ensure you have a valid aws session credential
	`aws sso login --profile [named-profile]`

- Terraform
	- `terraform init`
	- `terraform plan`
	- `terraform apply --auto-approve`


## Customize the deployment

### Credentials 
- `provider.tf` file should detail the relative path to your aws config file along with the named profile you want to use.

- Input the public key you want to use to connect to the EC2 instance in the `variables.tf` file as the value of `public_key`.

### Naming Things 
- The names of all AWS resouces are prefixed with 'kat-' in the `main.tf` file.  If you don't want your resouces named after me, find and replace that value.


Note, the deployment may take up to 3 minutes including the installation of the expoit server.


## Connecting to your EC2 Instance

- You can use EC2 Instance Connect (SSH from the Browser) to connect to your EC2 instance. Ingress rules allowing this are include in the deployment
- You can directly SSH to the EC2 instance if you configured a public key.  The IP address is which was used to deploy the resources is automatically allowed to SSH into the EC2 instance.

## Java Exploit Server

Starting the Server:

- `java -jar JNDIExploit-1.2-SNAPSHOT.jar -i $(hostname -I | awk '{print $1}') -p 8888`

The JNDI Exploit Server needs to be running and receiving callbacks from the vulnerable docker container.

More instructions for operating the [JNDI Exploit Server](http://web.archive.org/web/20211210111026/https://github.com/feihong-cs/JNDIExploit)

## Vulnarable Java Docker Container
This container should be listening on `127.0.0.1:8080`

More instructions for operating the [vulnerable docker container](https://github.com/christophetd/log4shell-vulnerable-app)


## Reference

https://www.lunasec.io/docs/blog/log4j-zero-day/
https://mbechler.github.io/2021/12/10/PSA_Log4Shell_JNDI_Injection/


## Contributors

[@nightmareJs](https://twitter.com/NightmareJS)









