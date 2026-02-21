# lab-sample-tracker-sql

# Lab Sample Tracker (SQL Server)

Mini-projet SQL simulant une partie d’un LIMS (Laboratory Information Management System) :
gestion d’échantillons, tests, résultats, équipements et workflow.

## Objectifs
- Modélisation relationnelle (PK/FK, contraintes, normalisation)
- Requêtes SQL (jointures, agrégations)
- Vues et procédures stockées (SQL Server)

## Contenu
- `sql/01_create_schema.sql` : création du schéma
- `sql/02_seed_data.sql` : données d’exemple
- `sql/03_queries.sql` : requêtes de démonstration
- `sql/04_views.sql` : vues utiles (suivi, indicateurs)
- `sql/05_stored_procedures.sql` : procédures (création échantillon, enregistrement résultat)

## Modèle (résumé)
- **Samples** : échantillons (code, matrice, statut, date)
- **Tests** : catalogues d’analyses (pH, nitrate, microbiologie…)
- **SampleTests** : tests demandés pour un échantillon
- **Results** : résultats (valeur, unités, conformité)
- **Equipment** : équipements utilisés
- **Users** : techniciens / responsables qualité

## Exécution
1. Créer une base (ex: `LabTracker`)
2. Exécuter dans l’ordre :
   - `01_create_schema.sql`
   - `02_seed_data.sql`
   - `04_views.sql`
   - `05_stored_procedures.sql`
3. Lancer `03_queries.sql` pour tester.

## Technologies
- SQL Server (T-SQL)
