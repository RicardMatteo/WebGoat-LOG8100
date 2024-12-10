# Guide d'Installation de Prometheus et Grafana sur Kubernetes

## Prérequis

1. **Installer Helm** :  
   Vous pouvez suivre la [documentation officielle de Helm](https://helm.sh/docs/intro/install/) pour l'installation de Helm.

2. **Ajouter le dépôt de charts Helm de Prometheus** :
   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
    ```
3. **Démarrer Minikube (si vous utilisez Minikube comme cluster local)** :
   ```bash
   minikube start
   ```

## Installation de Prometheus et Grafana avec Helm

1. **Installer le stack Kube-Prometheus** :
Utilisez le fichier de configuration fourni `kube-prometheus-stack-values.yml` pour installer le stack Kube-Prometheus :
   ```bash
   helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
     --namespace monitoring \
     --create-namespace \
     --values kube-prometheus-stack-values.yml
   ```

2. **Déployer l'application Webgoat à l'aide du playbook Ansible** :
  Suivre les instructions du ANSIBLE.md pour déployer l'application Webgoat dans le namespace `webgoat`.

3. **Démarrer le tunnel Minikube** :
   ```bash
    minikube tunnel
   ```

4. **Vérifier que les ressources ont été déployées** :
   ```bash
   kubectl get pods -n monitoring
   kubectl get svc -n monitoring
   ```

## Mettre à jour le stack Kube-Prometheus
Pour mettre à jour le stack Kube-Prometheus, vous pouvez utiliser la commande suivante :
   ```bash
   helm upgrade kube-prometheus-stack prometheus-community/kube-prometheus-stack \
     --namespace monitoring \
     --values prometheus/kube-prometheus-stack-values.yml
   ```

## Accéder à Prometheus et Grafana

1. **Obtenir l'URL de Prometheus** :
   ```bash
    export PROMETHEUS_URL=$(kubectl get svc -n monitoring -l app=kube-prometheus-stack-prometheus -o jsonpath='{.items[].status.loadBalancer.ingress[].ip}')
    echo Prometheus URL: http://$PROMETHEUS_URL
   ```
  Ouvrez l'URL dans votre navigateur pour accéder à l'interface utilisateur de Prometheus.

  Pour accéder aux cibles de Prometheus, allez à `status/targets`, notamment le ServiceMonitor `monitoring/kube-prometheus-stack-kube-state-metrics`.

2. **Obtenir l'URL de Grafana** :
   ```bash
   export GRAFANA_URL=$(kubectl get svc -n monitoring -l app.kubernetes.io/name=grafana -o jsonpath='{.items[].status.loadBalancer.ingress[].ip}')
   echo Grafana URL: http://$GRAFANA_URL
   ```
  Ouvrez l'URL dans votre navigateur pour accéder à l'interface utilisateur de Grafana.

  Utilisez les identifiants par défaut pour accéder à Grafana : `admin / prom-operator`.

  Si vous souhaitez configurer des identifiants personnalisés, vous pouvez le faire en modifiant le fichier `kube-prometheus-stack-values.yml` et en ajoutant les valeurs suivantes :
  ```yaml
  grafana:
    adminUser: your_admin_username
    adminPassword: your_admin_password
  ```

## Commandes utiles

### Voir toutes les informations disponibles dans le namespace monitoring
   ```bash
   kubectl get all -n monitoring
   ```

### Voir les charts Helm installés
   ```bash
    helm list -n monitoring
  ```

### Supprimer le stack Kube-Prometheus
   ```bash
   helm uninstall kube-prometheus-stack -n monitoring
   ```

### Arrêter Minikube
   ```bash
    minikube stop
  ```

### Vérifier les ServiceMonitors
   ```bash
    kubectl get servicemonitor -n monitoring
  ```

### Supprimer d'anciennes configurations de kubernetes en local
   ```bash
    rm ~/.kube/config
  ```

# Références
Tutoriel basé sur le guide d'installation de Prometheus et Grafana sur Kubernetes de OVHCloud : [Lien vers le guide][https://help.ovhcloud.com/csm/fr]

