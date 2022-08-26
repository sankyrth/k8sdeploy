### This repository contains code to deploy an applications on to kubernetes using Terraform 
###### This repository assumes you have a Minikube version and terraform running locally on your machine. If a production grade experience is required, use CFCR/Bosh https://github.com/making/cfcr-aws , AWS EKS or AZURE EKS instead of Minikube.
###### Firstly download `minikube.dmg` from https://minikube.sigs.k8s.io/docs/start/ on to your local && start the cluster using `$ minikube start` command.
###### Clone this repo which contains terraform scripts that are used to deploy nginx image in the required namespace to your local, and `cd K8s-test-option1`
> The k8s.tf is the template used to specify the namespace,deployment name and specifications for the nginx deployment to run.
> provider.tf is the template used to declare the modules to be used and the kube config path.
######  Run the below commands to initialize terraform and apply the config to deploy nginx application
> `terraform init`

> `terraform plan` 

> `terraform apply`
