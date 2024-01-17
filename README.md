# Overview  
Terraform mini project to create Azure Container Registry(ACR) to store docker images in a private container registry. Also create a kubernetes cluster using Azure Kubernetes Service to host our kubernetes deployments. 

# Prerequisites
- Microsoft Azure account
- Azure cli
- terraform
- kubectl

# Steps
1. Login into the Azure account using azure cli
    ```
    az login
    ```
2. Create a new service principal  

    ```
    az ad sp create-for-rbac --skip-assignment
    ```

    Copy and save the information returned after executing the command successfully. Information will look something like:
    ```
    {
        "appId": "<app_if>",
        "displayName": "<display_name>",
        "password": "<password>",
        "tenant": "<tenant>"
    }
    ```

3. Get the service principal id(object id) using azure cli
    ```
    az ad sp show --id <appId_from_above_step> --query "id"
    ```
    Note the retured principal id as well.

4. In the terraform folder create a new file `terraform.tfvars` and paste the below code to initialise the variable values:
    ```
    resource_group_name = "tws_deployment_RG"
    location            = "centralindia"
    cluster_name        = "my-aks-cluster"
    kubernetes_version  = "1.26.10"
    system_node_count   = 3
    acr_name            = "twsChallengeACRVishal"
    appId               = "<appId_from_step_2>"
    principalid         = "<principalId_from_step_3>"
    password            = "<password_from_step_2>"
    dns_prefix          = "aks-dns-prefix-k8s"
    ```
    In `appId`, `principalid`, `password` insert data from the previous steps

5. Run the terraform commands to create a new AKS cluster and ACR.
    ```
    terraform init
    terraform fmt
    terraform plan
    # If the plan looks fine then go ahead and apply
    terraform apply -auto-approve
    ```
    Make note of the outputs after all the resources are created. Especially `acr_login_server`, `acr_username` and `acr_password`.  
    To see `acr_password`, use the command 
    ```
    terraform output acr_password
    ```

6. After provisioning, Retrieve access credentials and automatically configure `kubectl`
    ```
    az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)
    ```

7. Login into the private container registry hosted on Azure
    ```
    docker login <acr_login_server>
    ```
    Change `<acr_login_server>` to your login server.  
    Provide the `acr_username` and `acr_password` when prompted.

8. Build a new image or retag an existing image.
   ```
    #Build an image from Dockerfile  
    docker image build -t <acr_login_server>/<image_name>:<tag> ./

    #Re tag an existing image
     docker image tag <old_image_name>:<tag> <acr_login_server>/<image_name>:<tag> 
   ```
9. Push the docker image to the Azure Container Registry
    ```
    docker image push <acr_login_server>/<image_name>:<tag>
    ```

To create deployment in AKS using images from ACR you can run the typical kubernetes deployment commands
