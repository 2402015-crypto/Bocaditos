DB helper scripts
=================

create_db_user.sql
- Creates `bocaditos_db` and a user `bocaditos_user` with privileges on that DB.

Run with the root MySQL account (interactive password prompt):

```powershell
cd 'C:\Users\bm030\TI_32Backend'
mysql -u root -p < scripts/create_db_user.sql
```

Or run the statements interactively after connecting as root:

```sql
SOURCE C:/Users/bm030/TI_32Backend/scripts/create_db_user.sql;
```

After creating the user, test the Node script:

```powershell
$env:DB_HOST='localhost'; $env:DB_USER='bocaditos_user'; $env:DB_PASS='strong_password'; cd 'C:\Users\bm030\TI_32Backend'; node scripts/test-db-connection.js
```

Security note: replace `strong_password` with a secure password and do not commit real credentials.
