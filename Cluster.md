# Cluster Kubernetes

Détail de la configuration et des fonctionnalités du cluster Kubernetes hébergeant l'application. Ce cluster a été conçu pour garantir une gestion sécurisée, surveillée et optimisée des ressources tout en automatisant les déploiements grâce au pipeline CI/CD.

## Architecture

Le cluster est structuré autour des namespaces suivants :  

- **webgoat** : 
    - Application déployée dans un pod dédié. Et répliqué pour garantir que l'application reste disponible même si une instance crash. 
    - Service exposé via un LoadBalancer ou un Ingress pour l'accès externe.  

- **monitoring** : 
    - Prometheus collecte les métriques des pods et du cluster.  
    - Grafana offre une interface de visualisation.  
    - Connecté à Prometheus pour envoyer des alertes aux développeurs.

- **kube-system** : Namespace standard de Kubernetes pour les composants internes du cluster.

## Réseau 

Des groupes de sécurité sont mis en place pour agir comme des firewalls et bloque tout le trafic non autorisé. 
Seul le trafic indispensable au fonctionnement de WebGoat et du monitoring est autorisée.

## Surveillance et Monitoring

- **Prometheus** :
    - Collecte des métriques exposées par les pods et les composants Kubernetes.  
    - Configuration des endpoints pour surveiller l'application WebGoat et les services associés.  

- **Grafana** :
    - Interface de visualisation des métriques avec des tableaux de bord personnalisés.  
    - Inclut des graphiques sur :  
        - Utilisation des ressources CPU et mémoire.  
        - Disponibilité des services.  
        - Détails des alertes actives.

- **Kube-state-metrics** :
    - Surveille l'état des objets Kubernetes, tels que les pods, les services et les déploiements.  
    - Les données sont utilisées par Prometheus pour enrichir les métriques.

## Alertes

- **Prometheus Alertmanager** : Les alertes sont configurées pour signaler :  
    - Une surconsommation des ressources.  
    - Des pods non disponibles.  
    - Des erreurs dans l'application WebGoat.

- **Notifications via Discord** :
    - Les alertes sont transmises à un channel Discord via un webhook.  
    - La configuration est définie dans `alertmanager-config.yaml`.  
    - Les messages incluent :  
        - La gravité de l'alerte.  
        - Les détails de l'incident.  
        - Les actions recommandées.

## Gestion des Ressources et des Coûts

Pour éviter une consommation excessive des ressources, des limites et des quotas sont définis dans les manifests Kubernetes :  
- **Quotas CPU et mémoire** : Appliqués aux pods dans le namespace `webgoat`.  
- **Restrictions sur les ressources** : Empêchent les pods d'utiliser plus de ressources que nécessaire.

## Résumé des Outils et Technologies

**Kubernetes** : Orchestration des conteneurs et gestion des déploiements.
**Prometheus** : Collecte des métriques et configuration des alertes.
**Grafana** : Visualisation des données de monitoring.
**Helm** : Gestion des packages Kubernetes (par ex. Prometheus-Operator).
**Discord** : Notifications d'alerte via webhook.
**Terraform** : Déploiement automatisé de l'infrastructure (inclus dans le pipeline CI/CD).
