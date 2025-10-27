# Connect to Cloud SQL Database
# Run this script after starting cloud-sql-proxy

Write-Host "Connecting to Cloud SQL database..." -ForegroundColor Green

# Start Cloud SQL Proxy in background (if not running)
Write-Host "Make sure cloud-sql-proxy is running!" -ForegroundColor Yellow
Write-Host "If not, run in another terminal: cloud-sql-proxy n8n-secstore:us-central1:n8n-hgdb --port 5432" -ForegroundColor Yellow
Write-Host ""

# Connection parameters
$env:PGPASSWORD = "Hgttads0814!"
$host = "127.0.0.1"
$port = "5432"
$database = "n8n"
$user = "n8n_user"

# Connect using psql
Write-Host "Connecting to $database as $user..." -ForegroundColor Cyan
psql -h $host -p $port -U $user -d $database

# Alternative: Use pgAdmin or other SQL client
Write-Host ""
Write-Host "Or connect manually with:" -ForegroundColor Yellow
Write-Host "  Host: $host" -ForegroundColor White
Write-Host "  Port: $port" -ForegroundColor White
Write-Host "  Database: $database" -ForegroundColor White
Write-Host "  User: $user" -ForegroundColor White
Write-Host "  Password: Hgttads0814!" -ForegroundColor White

