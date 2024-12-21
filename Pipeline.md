# Pipeline

## Pipeline CI

La pipeline CI est lancé à chaque push dans la branche main et pipeline, elle comporte les étapes suivantes :
- Scan statique du code avec Snyk
- Scan de l'image docker avec Docker Scout et Trivy
- Scan de l'application avec OWASP Zap

Docker Scout, Trivy et OWASP Zap necessite l'image docker. Ainsi avant ces étapes, l'image docker est construite et mise à disposition pour les étapes suivantes. Les étapes utilisant Docker Scout, Trivy et OWASP Zap nécessitent donc l'étape de la création d'image. 
Dans le cas où une vulnérabilité est détectée, une erreur est levée, une alerte discord est envoyée et nous ne pouvons commencer le déploiement.
En parallèle, et en plus du SAST Snyk, SonarCloud analyse le code à chaque push dans la branche main et avertit par mail des vulnérabilités introduites dans le push effectué. 

## Pipeline CD

Une fois la pipeline CI exécutée sans erreur la pipeline CD se charge de publier l'image docker sur Docker Hub et de déployer le cluster kubernetes avec Terraform puis Ansible.
