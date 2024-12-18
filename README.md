# WebGoat

## Pipeline

### Pipeline CI

La pipeline CI comporte les étapes suivantes :
- Scan statique du code avec Snyk
- Scan de l'image docker avec Docker Scout et Trivy
- Scan de l'application avec OWASP Zap

Docker Scout, Trivy et OWASP Zap necessite l'image docker. Ainsi avant ces étapes, l'image docker est construite et mise à disposition pour les étapes suivantes. Les étapes utilisant Docker Scout, Trivy et OWASP Zap necessitent donc l'étape de la création d'image. 
Dans le cas où une vulnérabilité est détectée, une erreur est levée, une alerte discord est envoyée et nous ne pouvons continuer la pipeline.

### Pipeline CD

Une fois la pipeline CI exécutée sans erreur la pipeline CD se charge de publier l'image docker sur Docker Hub et de déployer le cluster kubernetes avec Terraform puis Ansible.

---

## Cluster Kubernetes

Détail de la configuration et des fonctionnalités du cluster Kubernetes hébergeant l'application. Ce cluster a été conçu pour garantir une gestion sécurisée, surveillée et optimisée des ressources tout en automatisant les déploiements grâce au pipeline CI/CD.

### Architecture

Le cluster est structuré autour des namespaces suivants :  

- **webgoat** : 
    - Application déployée dans un pod dédié.  
    - Service exposé via un LoadBalancer ou un Ingress pour l'accès externe.  

- **monitoring** : 
    - Prometheus collecte les métriques des pods et du cluster.  
    - Grafana offre une interface de visualisation.  
    - Connecté à Prometheus pour envoyer des alertes aux développeurs.

- **kube-system** : Namespace standard de Kubernetes pour les composants internes du cluster.

### Surveillance et Monitoring

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

### Alertes

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

### Gestion des Ressources et des Coûts

Pour éviter une consommation excessive des ressources, des limites et des quotas sont définis dans les manifests Kubernetes :  
- **Quotas CPU et mémoire** : Appliqués aux pods dans le namespace `webgoat`.  
- **Restrictions sur les ressources** : Empêchent les pods d'utiliser plus de ressources que nécessaire.

### Résumé des Outils et Technologies

**Kubernetes** : Orchestration des conteneurs et gestion des déploiements.
**Prometheus** : Collecte des métriques et configuration des alertes.
**Grafana** : Visualisation des données de monitoring.
**Helm** : Gestion des packages Kubernetes (par ex. Prometheus-Operator).
**Discord** : Notifications d'alerte via webhook.
**Terraform** : Déploiement automatisé de l'infrastructure (inclus dans le pipeline CI/CD).

---