# Utilisez Ansible pour gérer la configuration et déployer l'application conteneurisée sur le cluster K8S

## 1. Structure des fichiers

Dans le dossier `k8s`, vous trouverez les fichiers de configuration YAML utilisés pour déployer l'application WebGoat. Le fichier `playbook.yml` automatise les commandes `kubectl apply -f` pour tous les différents fichiers de configuration YAML pour chaque service et chaque déploiement.

## 2. Prérequis

### 2.1 Prérequis pour les variables d'environnement

Copiez le fichier d'exemple `.env` disponible dans le projet et remplacez les valeurs par vos propres configurations d'environnement.

### 2.2 Prérequis pour Ansible

Installez Ansible en fonction de votre système opérateur en suivant les consignes suggérées par la documentation d'Ansible : [lien documentation](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html)

Si vous utilisez un environnement Python géré de manière externe (par exemple, sous Ubuntu) ou préférez spécifier un environnement pour votre application, il est recommandé de créer un environnement virtuel Python pour isoler vos dépendances :

```bash
python3 -m venv venv
source venv/bin/activate
```

Ensuite, installez le package Kubernetes via pip :

```bash
pip install kubernetes
```

### 2.3 Prérequis pour les VMs

Vous devez avoir un outil de gestion de machines virtuelles installé, tel que Minikube, Vagrant, ou tout autre équivalent.

### 2.4 Prérequis pour Kubernetes

Assurez-vous que kubectl est installé et fonctionnel. Vous pouvez vérifier cela en exécutant la commande suivante :

```bash
kubectl version --client
```

### 2.5 Commande optionnelle de nettoyage

Avant de démarrer, vous pouvez choisir de supprimer les résidus des anciens lancements de Kubernetes avec cette commande (optionnelle) :

```bash
rm ~/.kube/config
```

### 2.6 Lancement de Minikube ou de l'équivalent

Avant de commencer, lancez Minikube (ou tout autre outil de gestion de cluster Kubernetes) :
```bash
minikube start
```

### 2.7 Prérequis pour la base de données (à effectuer après avoir lancé votre outil de gestion de cluster Kubernetes)

Dans les fichiers de configuration YAML, vous devez spécifier le mot de passe et le port de votre base de données PostgreSQL. Pour plus de sécurité, évitez d'utiliser des chaînes de caractères en clair dans les fichiers YAML. Vous pouvez enregistrer votre mot de passe dans Kubernetes via la commande suivante :

```bash
kubectl create secret generic postgres-secret --from-literal=POSTGRES_PASSWORD=your_password -n webgoat
```
Note : Remplacez your_password par votre mot de passe en texte clair. Vous pouvez également définir le mot de passe directement dans l'environnement du conteneur dans le fichier de configuration YAML, mais l'utilisation de secrets Kubernetes est recommandée. L'option -n précise le namespace sur lequel vous travaillez (ici webgoat). Si vous ne spécifiez pas de namespace, le namespace par défaut (default) sera utilisé. Dans ce cas, modifiez le fichier k8s/playbook.yml pour enlever les namespaces.

## 3 Déploiement avec Ansible

Pour déployer l'application via le playbook Ansible, exécutez la commande suivante dans le dossier k8s. Si votre environnement est géré de manière externe (comme un environnement Python virtuel), spécifiez l'interpréteur Python à utiliser :
```bash
ansible-playbook playbook.yml -e "ansible_python_interpreter=../venv/bin/python"
```

Note : Cette commande doit être adaptée en fonction de l'endroit où vous vous trouvez dans l'application.

## 4 Vérification du bon fonctionnement

### 4.1 Vérification des ressources dans le cluster

Vous pouvez vérifier l'ensemble des éléments présents dans votre cluster Kubernetes en utilisant la commande suivante :

```bash
kubectl get all -n webgoat
```

Cela vous permettra de voir tous les objets (pods, services, déploiements, etc.) dans le namespace webgoat.

Note : Le -n webgoat est nécessaire si vous utilisez le playbook.yml pour déployer. Si vous configurez manuellement sans préciser de namespace, ce n'est pas nécessaire.

### 4.2 Vérification des pods

Pour vérifier les pods spécifiques au namespace webgoat :
```bash
kubectl get pods -n webgoat
```

Note : Le -n webgoat est nécessaire si vous utilisez le playbook.yml pour déployer. Si vous configurez manuellement sans préciser de namespace, ce n'est pas nécessaire.

### 4.3 Vérification des services

Pour vérifier vos services dans le namespace webgoat :
```bash
kubectl get svc -n webgoat
```

Note : Le -n webgoat est nécessaire si vous utilisez le playbook.yml pour déployer. Si vous configurez manuellement sans préciser de namespace, ce n'est pas nécessaire.

### 4.4 Vérification de la base de données PostgreSQL

Assurez-vous que votre service de base de données PostgreSQL n'a pas d'adresse IP publique et reste bien interne à votre cluster Kubernetes.

### 4.5 Si le service WebGoat reste à "Pending"

Il peut arriver que le service WebGoat reste dans l'état "Pending" si les ressources nécessaires ne sont pas disponibles. Pour résoudre ce problème, exécutez la commande suivante pour permettre à Minikube de créer un tunnel réseau :
```bash
minikube tunnel
```
Cela assignera une adresse IP externe à votre service WebGoat, permettant ainsi à Kubernetes de rediriger le trafic vers les bons pods. On vous demandera de renseigner le mot de passe de votre compte administrateur pour confirmer le lancement de la commande.



