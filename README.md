# LOGS TRACE ET OPTIMISATION - REFCONTACT-RFK

## Aperçu du projet
Le projet REFCONTACT-EFK vise à développer une solution intégrée pour gérer efficacement les logs générés d'une multitude de services interconnectés au sein du projet REFCONTACT. Ces services, qui sont essentiels au fonctionnement global du système, produisent un volume important de données de log, indispensables pour surveiller les performances, diagnostiquer les problèmes, et améliorer continuellement l'ensemble de l'écosystème.

Le projet repose sur une architecture qui centralise les logs à l'aide de Fluentd, les stocke dans Elasticsearch, et les visualise via Kibana. Cette approche permet non seulement de structurer et d'analyser les logs de manière cohérente, mais aussi de fournir des tableaux de bord interactifs et dynamiques pour une meilleure compréhension des données.

L'un des objectifs principaux de REFCONTACT est de surmonter la complexité inhérente aux interactions entre les services, en offrant une visibilité complète et en temps réel sur l'état du système.
### Fonctionnalités clés
- Collecte et stockage centralisés des logs
- Surveillance en temps réel de la santé des services
- Tableaux de bord personnalisés pour visualiser les données de logs et les métriques des services
- Authentification des utilisateurs et contrôle d'accès pour visualisation et modification
- Alertes par e-mail pour les seuils d'utilisation des ressources

## Technologies utilisées
1. **Fluentd** : Fluentd est un collecteur de données open-source conçu pour unifier la gestion des logs à travers différentes sources, traitements, et destinations. Il permet de collecter, transformer, et acheminer les logs et événements de manière efficace. Fluentd est flexible et extensible grâce à ses nombreux plugins, permettant de le connecter à diverses bases de données, systèmes de stockage, et outils de surveillance. Utilisé dans des environnements cloud, DevOps, et de microservices, Fluentd centralise les logs pour une analyse plus facile et une gestion simplifiée des données
2. **Elasticsearch** : Elasticsearch est un moteur de recherche et d'analyse distribué open-source, développé par Elastic. Il est conçu pour indexer, rechercher et analyser de grandes quantités de données en temps réel. Elasticsearch est basé sur Apache Lucene et offre des fonctionnalités de recherche avancées, comme la recherche full-text, le filtrage, et l'agrégation de données
3. **Kibana** : 
Kibana est un outil d'analyse et de visualisation de données open-source, développé par Elastic, et utilisé pour interagir avec les données stockées dans Elasticsearch. Il permet aux utilisateurs de créer des tableaux de bord interactifs, des visualisations graphiques, et des rapports basés sur les données collectées et indexées par Elasticsearch.

## Architecture
La solution suit une architecture multi-niveaux :

1. **Collecte de logs (Fluentd)** :
Fluentd joue un rôle crucial dans cette architecture en tant que collecteur de logs unifié.

- Collecte : Fluentd peut collecter des logs de diverses sources; dans notre cas, la forward source sur le port 24224 pour enregistret les logs internes des services et la source exec qui execute des commande docker dans un intervalle de temps défini pour faire la collecte des informations relatives aux services telles que la consommation CPU et memoire etc ... 
- Formatage : Utilisations de parser et de record transformer pour convertir les formats de logs et les rendre plus cohérents.
- Buffering et fiabilité : Fluentd peut mettre en buffer les logs en cas de pics de trafic ou de problèmes de connexion avec Elasticsearch, assurant ainsi qu'aucune donnée n'est perdue.


2. **Stockage de logs (Elasticsearch)** :
Elasticsearch est utilisé comme un moteur de stockage et de recherche pour les logs.

- Indexation : Les logs sont stockés dans des indices Elasticsearch, qui sont optimisés pour la recherche rapide. 4 index sont créés: 
    Service Logs:
    Container_Health_Check:
    Container_Heath_Check_History:


3. **Visualisation (Kibana)** :
Kibana fournit une interface utilisateur pour explorer et visualiser les données stockées dans Elasticsearch.

- Tableaux de bord : Création de tableaux de bord personnalisés avec différents types de visualisations (graphiques, métriques, tables, etc.).
- Recherche et filtrage : Interface pour effectuer des recherches complexes dans les logs.
-vAlerting : Possibilité de configurer des alertes basées sur des conditions spécifiques dans les données de logs.


4. **Authentification** :
L'authentification est cruciale pour sécuriser l'accès aux données sensibles contenues dans les logs.

- Contrôle d'accès : Mise en place de mécanismes d'authentification (comme LDAP, Active Directory, ou OAuth) pour vérifier l'identité des utilisateurs.
- Autorisation : Configuration de rôles et de permissions pour contrôler ce que chaque utilisateur peut voir et faire dans le système.
- Audit : Enregistrement des accès et des actions des utilisateurs pour des fins de sécurité et de conformité.


5. **Alertes** :
Le système d'alertes permet une surveillance proactive de l'infrastructure et des applications.

- Définition de seuils : Configuration de seuils pour différentes métriques (utilisation CPU, mémoire, erreurs dans les logs, etc.).
- Notifications par e-mail : Envoi automatique d'e-mails lorsque ces seuils sont dépassés ou lorsque des patterns spécifiques sont détectés dans les logs.
- Personnalisation : Possibilité de définir différents niveaux d'alerte et de personnaliser le contenu des notifications.
- Intégration : Potentielle intégration avec d'autres systèmes de notification (comme Slack, PagerDuty, etc.) pour une réponse rapide aux incidents.


Cette architecture multi-niveaux permet une gestion complète du cycle de vie des logs, de leur collecte à leur analyse, tout en assurant la sécurité et la surveillance proactive du système. Chaque niveau joue un rôle spécifique et crucial dans la chaîne de traitement des logs, offrant une solution robuste et flexible pour la gestion des logs dans un environnement complexe.

![Architecture Diagram](images/architecture-globale.png)

## Configuration et installation
(Inclure les étapes de configuration de l'environnement, de Fluentd, Elasticsearch et Kibana)

## Utilisation
(Fournir des instructions sur l'utilisation du système, l'accès aux tableaux de bord et l'interprétation des données)

## Configuration des alertes
- Des alertes d'utilisation du CPU et de la mémoire sont configurées
- Les alertes sont envoyées par e-mail lorsque les seuils sont dépassés
- Des alertes supplémentaires peuvent être configurées pour Elasticsearch et Kibana afin de prévenir les surcharges ou les défaillances de logging

## Défis et intégration
(Décrire les défis rencontrés lors de l'implémentation et comment ils ont été surmontés)

## Améliorations futures
(Lister les améliorations potentielles ou les fonctionnalités prévues pour les itérations futures)

## Contributeurs
- NOURHENE AZAIEZ

## Licence
(Spécifier la licence sous laquelle ce projet est publié)
