# Security Notes

## Password Management

**Never commit passwords to Git!**

### Using Environment Variables (Recommended)

1. Copy `env.example` to `.env`:
```bash
cp env.example .env
```

2. Fill in your actual credentials in `.env`

3. Load in your scripts:
```powershell
# PowerShell
$env:PGPASSWORD = "your_actual_password"

# Bash
export PGPASSWORD="your_actual_password"
```

### Credentials Template

Use `env.example` as template for your `.env` file.

### .gitignore Protection

The `.gitignore` file will prevent:
- `.env` files
- `*password*` files
- `*secret*` files
- `credentials.json`
- Other sensitive files

### If You Already Pushed Passwords

If passwords were already in Git history:
1. Password was changed in commits above ✅
2. GitHub history still contains old passwords
3. Consider rotating passwords if exposed
4. Use Git filter-branch to clean history (advanced)

### Best Practices

✅ DO:
- Use environment variables
- Use `.env` files (gitignored)
- Use secret managers (GCP Secret Manager)
- Rotate passwords regularly

❌ DON'T:
- Commit passwords to Git
- Hardcode passwords in scripts
- Share passwords in chats or documentation on GitHub
- Use default passwords

---

## Current Credentials (Keep Secure!)

Store these locally in `.env` (not in Git):

```bash
# Database (Cloud SQL)
DB_USER=n8n_user
DB_PASSWORD=Hgn8n0814!  # Keep this private!

# n8n Host
N8N_HOST=n8ne01.entrega.space

# Cloud SQL Instance
GCP_PROJECT_ID=n8n-secstore
GCP_REGION=us-central1
GCP_SQL_INSTANCE=n8n-hgdb
```

---

## Quick Setup

```bash
# Create .env file
cp env.example .env

# Edit .env with your actual credentials
# (DO NOT commit this file!)
```

Now your credentials are safe and not in Git! 🔒

