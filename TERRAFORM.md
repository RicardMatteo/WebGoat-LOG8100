# Déploiement de WebGoat sur un Cluster Kubernetes Azure avec Terraform

Ce dépôt contient les configurations Terraform et les fichiers Kubernetes YAML nécessaires pour déployer un cluster Kubernetes sur Azure et y déployer l'application WebGoat.

## Prérequis

- **Compte Azure** avec les autorisations nécessaires pour créer des ressources.
- **Terraform** installé. [Télécharger Terraform](https://developer.hashicorp.com/terraform/downloads)
- **Azure CLI** installé et configuré. [Télécharger Azure CLI](https://learn.microsoft.com/fr-fr/cli/azure/install-azure-cli)
- **kubectl** installé pour gérer les ressources Kubernetes. [Télécharger kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Étapes de Déploiement

### 1. Authentification Azure
Connectez-vous à votre compte Azure via la CLI pour autoriser Terraform à accéder à votre souscription Azure :

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

### 3. Configurer `kubectl` pour le Cluster

Après la création du cluster, récupérez la configuration pour `kubectl` en exécutant la commande suivante et en l'ajoutant à votre fichier kubeconfig :

```bash
echo "$(terraform output kube_config)" > ~/.kube/config
```

### 4. Déploiement de l'Application WebGoat sur le Cluster

#### a. Déployer WebGoat
Utilisez les fichiers de configuration YAML fournis pour déployer l'application WebGoat :

```bash
kubectl apply -f ../k8s/deployment.yaml
kubectl apply -f ../k8s/service.yaml
```

#### b. Vérifiez le Service
Vérifiez l'adresse IP externe du service WebGoat avec la commande suivante :

```bash
kubectl get service
```

Recherchez l’IP externe associée à `webgoat-service`. Le service sera disponible à l'adresse suivante :

```
http://<EXTERNAL-IP>:8080
```

Remplacez `<EXTERNAL-IP>` par l'IP externe obtenue.

### 5. Accéder à WebGoat

Ouvrez un navigateur et allez à l'adresse :

```
http://<EXTERNAL-IP>:8080
```

Vous devriez voir l'interface de WebGoat.

## Nettoyage des Ressources

Pour éviter des frais inattendus, détruisez les ressources une fois que vous n’en avez plus besoin :

```bash
terraform destroy
```

Confirmez en tapant "yes" lorsque demandé.

## Structure des Fichiers

- **`main.tf`** : Décrit l'infrastructure Azure pour le cluster Kubernetes.
- **`deployment.yaml`** : Fichier de configuration pour le déploiement de WebGoat sur Kubernetes.
- **`service.yaml`** : Fichier de configuration pour le service exposant WebGoat.

## Remarques

- **Service LoadBalancer** : Le service WebGoat utilise un LoadBalancer pour être accessible publiquement. Vous pouvez limiter l'accès via des règles de sécurité dans Azure.
- **Terraform** : Assurez-vous de bien spécifier votre `subscription_id` Azure dans `main.tf` ou via une variable d'environnement.

## Ressources Utiles

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/)
- [WebGoat Documentation](https://owasp.org/www-project-webgoat/)

---