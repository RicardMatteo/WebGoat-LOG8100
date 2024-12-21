# Le déploiement sur Azure

## Prérequis

- **Compte Azure** avec les autorisations nécessaires pour créer des ressources.
- **Terraform** installé. [Télécharger Terraform](https://developer.hashicorp.com/terraform/downloads)
- **Azure CLI** installé et configuré. [Télécharger Azure CLI](https://learn.microsoft.com/fr-fr/cli/azure/install-azure-cli)
- **kubectl** installé pour gérer les ressources Kubernetes. [Télécharger kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Étapes de Déploiement

### 1. Authentification Azure
Connectez-vous à votre compte Azure via la CLI pour autoriser Terraform à accéder à votre souscription Azure :

```bash
az login
```

Ensuite, configurez le subscription_id via une variable d'environnement :

```bash
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
```

### 2. Initialiser et Configurer le Projet Terraform

#### a. Initialisez Terraform
Initialisez le projet Terraform pour télécharger les plugins nécessaires :

```bash
cd ./terraform
terraform init
```

#### b. Prévisualisez la Configuration
Utilisez la commande suivante pour voir les ressources qui seront créées :

```bash
terraform plan
```

#### c. Appliquez la Configuration
Appliquez la configuration pour créer le cluster Kubernetes et les ressources réseau :

```bash
terraform apply
```

Confirmez en tapant "yes" lorsque demandé.

### 3. Récupérer le kubeconfig nécessaire au lancement de Ansible
```bash
az aks get-credentials --resource-group [insérer le groupe] --name [insérer le nom du cluster] --file  ./playbooks/kubeconfig
```

### 4. Configurer le déploiement via Ansible

Selon vos configurations : 
```bash
ansible-playbook -i azure/ansible/inventory/vm azure/ansible/playbooks/deploy.yml -e @azure/ansible/group_vars/all.yml
```
Si vous utilisez un environnement virtuel local python, il faut l'ajouter comme argument supplémentaire :
```bash
ansible-playbook -i azure/ansible/inventory/vm azure/ansible/playbooks/deploy.yml -e @azure/ansible/group_vars/all.yml -e "ansible_python_interpreter=../../../venv/bin/python"
```

### 5. Vérification du bon fonctionnement

L'application Webgoat est alors accessible à l'adresse suivante : http://<EXTERNAL-IP>:9090/WebGoat.

## Notes 

On a réussi à déployer l'infrastructure sur Azure comme le montre l'action github [ici](https://github.com/RicardMatteo/WebGoat-LOG8100/actions/runs/12323630687/job/34399700211). Malheureusement, nous avons épuisé tous nos crédit et avons du changer la manière d'héberger l'infrastructure.
