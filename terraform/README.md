# Device Connect for Fitbit -- Terraform deployment
<!-- vscode-markdown-toc -->
* 1. [Project Requirements](#ProjectRequirements)
* 2. [Getting Started](#GettingStarted)
* 3. [Prerequisites](#Prerequisites)
* 4. [GCP Foundation Setup - Terraform](#GCPFoundationSetup-Terraform)


<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->


##  1. <a name='ProjectRequirements'></a>Project Requirements

| Tool  | Current Version  | Documentation site |
|---|---|---|
| gcloud CLI | Latest  | https://cloud.google.com/sdk/docs/install |
| terraform | Latest | https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli |

##  2. <a name='GettingStarted'></a>Getting Started

This guide will describe how to use the provided terraform configurations to deploy 
Device Connect for Fitbit to your GCP project.


## 3. <a name='Prerequisites'></a>Prerequisites

To make things easier, set your `PROJECT_ID` to the gcp project you are using:
```
export PROJECT_ID=<yourprojectid>
```

Now login to google cloud and set the `gcloud` default project.

```
gcloud auth application-default login
gcloud auth application-default set-quota-project $PROJECT_ID
gcloud config set project $PROJECT_ID
```


## 4. <a name='GCPFoundationSetup-Terraform'></a>GCP Foundation Setup - Terraform

Set up Terraform environment variables and GCS bucket for state file.
If the new project is just created recently, you may need to wait for 1-2 minutes
before running the Terraform command.

After installing `gcloud`, change directories to `./environments/dev` and create a 
file called `terraform.tfvars` with the following parameters:

```
project_id                = # your gcp project id
admin_email               = # your email
fitbit_oauth_client_id    = # sign up at dev.fitbit.com for a developer identity
fitbit_oauth_client_secret= # add your client_id and client_secret here.

# if you are using google's openid connect server, then you can leave this alone, 
# otherwise, put in the url for your openid connect provider.
openid_auth_metadata_url  = "https://accounts.google.com/.well-known/openid-configuration"
openid_auth_client_id     = # your openid auth client_id
openid_auth_client_secret = # your openid auth client_secret

# default is "fitbit"
bigquery_dataset          = "fitbit"
# default is "tokens"
firestore_dataset         = "tokens"
```

Set some more environment variables:

```
export TF_BUCKET_NAME="${PROJECT_ID}-tfstate"
export TF_BUCKET_LOCATION="us"
```

# Grant Storage admin to the current user IAM.

```
export CURRENT_USER=$(gcloud config list account --format "value(core.account)")
gcloud projects add-iam-policy-binding $PROJECT_ID --member="user:$CURRENT_USER" --role='roles/storage.admin'
```

# Create Terraform Statefile in GCS bucket.

```
bash setup/setup_terraform.sh
```

Run Terraform apply

```
# Init Terraform
cd terraform/environments/dev
terraform init -backend-config=bucket=$TF_BUCKET_NAME

# Enabling GCP services first.
terraform apply -target=module.project_services -target=module.service_accounts -auto-approve

# Run the rest of Terraform
terraform apply -auto-approve
```
