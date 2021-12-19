

## Customize this deployment

### Credentials 
- `provider.tf` file should outline path to aws config file along with the named profile you want to use.

- Input the public key you want to use to connect to the EC2 instance in the `variables.tf` file as the value of `public_key`.

### Naming Things 
- Change the value of `deployment_prefix` variable to change the name of the resources deployed.  If you don't change this all your AWS resoures will be named in my honor.


### Steps to Deployment

- Ensure you have a valid aws session credential
  ``aws sso login --profile [named-prodile]``




