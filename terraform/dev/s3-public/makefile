

default:
	@echo "Please specify a target: init, plan, apply, validate, fmt, login"

login:
	@gcloud auth application-default login

init:
	@terraform init

plan:
	@terraform plan -var-file=../_env_config/dev.tfvars -out create.plan 

refresh:
	@terraform refresh -var-file=../_env_config/dev.tfvars

apply:
	@terraform apply "create.plan"
	@rm "create.plan"

validate:
	@terraform validate

fmt:
	@terraform fmt

destroy:
	@terraform destroy -var-file=../_env_config/dev.tfvars