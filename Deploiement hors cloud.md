# Déploiement hors cloud

## Remote (ssh)

On suppose que l'on dispose d'un cluster installer sur une machine distante (via minikube, k3s ou microk8s par exemple)

### Terraform (si nécessaire)

Si nécessaire, copier via scp (ou git) les fichiers de configuration terraform avec comme provider kubernetes.

### Ansible

Exécuter la playbook de déploiement avec l'inventory ``remote``

```   
ansible-playbook -i ansible/inventory/remote ansible/playbooks/deploy_remote.yml -e @ansible/group_vars/all.yml
```

### Vérification 

Vérifier que le service est bien lancé avec ``kubectl`` (l'option du namespace est optionelle) :

```
kubectl get service -n <namespace>
```

## En local

Lancer un cluster kubernetes en local (à l'aide de minikube par exemple) et récuperer le fichier kubeconfig.

Procéder de la même manière que pour le déploiement en remote. Il faut juste utiliser l'inventaire local :
```   
ansible-playbook -i ansible/inventory/localhost ansible/playbooks/deploy_remote.yml -e @ansible/group_vars/all.yml
```
