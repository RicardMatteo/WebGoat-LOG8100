# Configurations via Ansible

## Structure 

Ci-dessous la structure de notre dossier Ansible, aussi bien pour un déploiement local qu'un déploiement à distance :

ansible/
├── inventory/
│   ├── remote
│   └── localhost
├── playbooks/
│   ├── deploy.yml
│   ├── deploy_remote.yml
│   ├── setup_monitoring.yml
│   ├── setup_monitoring_remote.yml
│   ├── setup_application.yml
│   └── setup_application_remote.yml
├── templates/
│   ├── alertmanager_config.yml
│   ├── alertmanager_deployment.yml
│   ├── grafana_deployment.yml
│   ├── monitoring_services.yml
│   ├── namespaces.yml
│   ├── postgres_deployment.yaml.j2
│   ├── postgres_deployment.yml
│   ├── prometheus_config.yml
│   ├── prometheus_deployment.yml
│   ├── webgoat_deployment.yml
│   └── webgoat_service.yml
├── group_vars/
│   └── all.yml
└── roles/
    ├── monitoring/
    │   └── tasks/
    │      └── main.yml
    └── webgoat/
        └── tasks/
            └── main.yml

## Fonctionnement

Pour un déploiement local ou à distance on va faire à un playbook principal qui va orchestrer les configurations, deploy.yml pour celui en local et deploy_remote pour celui à distance. Ces derniers vont appliquer les fichiers de déploiements de nos namespaces webgoat et monitoring à l'aide des fichiers respectifs de setup_monitoring.yml, setup_application.yml et setup_monitoring_remote.yml, setup_application_remote.yml.
Ces derniers vont alors configurer nos déploiements selon les configurations communes définies dans nos templates. Dans all.yml du dossier group_vars, le nombre de réplicas de chacun de nos services pour l'application Webgoat, les variables liées à nos namespaces ainsi que l'image docker utilisée pour l'application Webgoat. Dans inventory, on définit les variables d'environnement nécessaires au déploiement local et à distance.





