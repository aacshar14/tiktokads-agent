# 🚀 Deployment Guide: TikTok Ads Agent on DigitalOcean

This guide will help you deploy your TikTok Ads Agent to a **DigitalOcean Droplet** using **Coolify**. This setup is cost-effective, scalable, and perfect for testing with your own domain.

## Prerequisites

1.  **DigitalOcean Account**: [Sign up here](https://www.digitalocean.com/) (You'll need a credit card).
2.  **Domain Name**: You have this on **GoDaddy**.
3.  **SSH Client**: Terminal (Mac/Linux) or PowerShell/PuTTY (Windows).

---

## Phase 1: Create the Server (Droplet)

1.  Log in to **DigitalOcean**.
2.  Click **Create** > **Droplets**.
3.  **Region**: Choose the one closest to you (e.g., New York, San Francisco).
4.  **OS**: Choose **Ubuntu 24.04 (LTS) x64**.
5.  **Size**:
    *   Choose **Basic**.
    *   Select **Regular Disk Type**.
    *   Pick the **$6/mo** (1GB RAM) or **$12/mo** (2GB RAM) option. *Recommendation: Start with 2GB ($12) for smoother performance with n8n + Database.*
6.  **Authentication**:
    *   Select **Password** and create a strong root password. (Save this!).
7.  **Hostname**: Name it something cool, like `tiktok-agent-server`.
8.  Click **Create Droplet**.
9.  **Wait** for the IP address to appear (e.g., `164.90.x.x`). **Copy this IP.**

---

## Phase 2: Configure DNS (GoDaddy)

We need to point your domain to your new server.

1.  Log in to **GoDaddy** and go to your **Domain Control Center**.
2.  Select your domain.
3.  Go to **Manage DNS**.
4.  Add the following **A Records**:

| Type | Name | Value | TTL |
| :--- | :--- | :--- | :--- |
| A | `@` | `YOUR_DROPLET_IP` | 600 seconds |
| A | `coolify` | `YOUR_DROPLET_IP` | 600 seconds |
| A | `n8n` | `YOUR_DROPLET_IP` | 600 seconds |

*   `@` points `yourdomain.com` to the server.
*   `coolify` points `coolify.yourdomain.com` to the management dashboard.
*   `n8n` points `n8n.yourdomain.com` to your workflow automation tool.

---

## Phase 3: Install Coolify

1.  Open **PowerShell** on your computer.
2.  Connect to your server:
    ```powershell
    ssh root@YOUR_DROPLET_IP
    ```
    *(Type `yes` if asked, then enter the password you created).*
3.  Run the Coolify installation command:
    ```bash
    curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
    ```
4.  Wait! It will take 5-10 minutes.
5.  Once finished, it will show: `Visit http://YOUR_IP:8000 to get started`.

---

## Phase 4: Setup Coolify & Deploy

1.  Open your browser to `http://YOUR_DROPLET_IP:8000`.
2.  **Register** your admin account.
3.  **Onboarding**:
    *   Select **"Self-hosted"**.
    *   It will ask for a domain. Enter `http://coolify.yourdomain.com` (replace with your actual domain).
    *   Coolify will automatically configure SSL (HTTPS) for itself.
4.  **Create a Project**:
    *   Click **Projects** > **+ New Project**.
    *   Name it `TikTok Agent`.
    *   Click on the environment (e.g., `Production`).
5.  **Add Resources**:

    ### A. Add PostgreSQL Database
    1.  Click **+ New Resource** > **Database** > **PostgreSQL**.
    2.  Select your server (`localhost`).
    3.  Set **Destination Docker Network** (default is fine).
    4.  Click **Continue**.
    5.  **Important**: In the configuration page, toggle **"Public Port"** to ON if you want to connect from your local computer (e.g., TablePlus/DBeaver).
    6.  Click **Start**.
    7.  **Copy the Connection String** (starts with `postgresql://...`). You'll need this for n8n.

    ### B. Add n8n
    1.  Click **+ New Resource** > **Service**.
    2.  Search for **n8n** and select it.
    3.  Configuration:
        *   **Name**: `n8n`
        *   **Domain**: `https://n8n.yourdomain.com`
    4.  **Environment Variables**:
        *   Find `DB_TYPE`. Set to `postgresdb`.
        *   Find `DB_POSTGRESDB_HOST`. Set to the *internal* IP or container name of your database (Coolify shows this in the DB details).
        *   *Easier Option*: n8n in Coolify often comes with its own internal Postgres. You can just use the default settings first to get it running.
    5.  Click **Deploy**.

    > [!CAUTION]
    > **Critical: Network Configuration**
    > By default, n8n and Postgres may be on different Docker networks and won't be able to communicate. You MUST configure them to use the same network:
    >
    > **For n8n:**
    > 1. Go to n8n service > **Docker Compose** tab
    > 2. Add under the `n8n:` service (same level as `image:`, `environment:`):
    >    ```yaml
    >    networks:
    >      - coolify
    >    ```
    > 3. At the bottom of the file (same level as `services:`), add:
    >    ```yaml
    >    networks:
    >      coolify:
    >        external: true
    >    ```
    > 4. Save and **Redeploy**
    >
    > **For Postgres:**
    > 1. Go to Postgres service > **Configuration**
    > 2. In the **Network** field, type: `coolify`
    > 3. Save and **Restart**
    >
    > Without this configuration, you'll get `getaddrinfo EAI_AGAIN` errors when n8n tries to connect to the database.

---

## Phase 5: Configure the Agent

1.  Go to `https://n8n.yourdomain.com`.
2.  Set up your owner account.
3.  **Import Workflow**:
    *   Go to **Workflows** > **Import from File**.
    *   Go to **Workflows** > **Import from File**.
    *   Upload `tiktok_ads_production_workflow.json` (this is the final, tested version with fallback logic).
4.  **Setup Credentials**:
    *   **Postgres**: 
        *   Go to **Credentials** > **Add Credential** > **Postgres**
        *   **Host**: Use the internal hostname from Coolify (e.g., `zoscco4kg0c0o4okw0o8o0k8`)
        *   **Port**: `5432`
        *   **User**: `postgres`
        *   **Password**: Copy from Coolify Postgres configuration
        *   **Database**: `postgres`
        *   **SSL**: Disable
    *   **OpenAI**: Add your API Key.
5.  **Initialize Database**:
    *   **Method 1 (Recommended)**: Use the init workflow
        1. Import `init_db_workflow.json` into n8n
        2. Double-click the "Run Schema SQL" node
# 🚀 Deployment Guide: TikTok Ads Agent on DigitalOcean

This guide will help you deploy your TikTok Ads Agent to a **DigitalOcean Droplet** using **Coolify**. This setup is cost-effective, scalable, and perfect for testing with your own domain.

## Prerequisites

1.  **DigitalOcean Account**: [Sign up here](https://www.digitalocean.com/) (You'll need a credit card).
2.  **Domain Name**: You have this on **GoDaddy**.
3.  **SSH Client**: Terminal (Mac/Linux) or PowerShell/PuTTY (Windows).

---

## Phase 1: Create the Server (Droplet)

1.  Log in to **DigitalOcean**.
2.  Click **Create** > **Droplets**.
3.  **Region**: Choose the one closest to you (e.g., New York, San Francisco).
4.  **OS**: Choose **Ubuntu 24.04 (LTS) x64**.
5.  **Size**:
    *   Choose **Basic**.
    *   Select **Regular Disk Type**.
    *   Pick the **$6/mo** (1GB RAM) or **$12/mo** (2GB RAM) option. *Recommendation: Start with 2GB ($12) for smoother performance with n8n + Database.*
6.  **Authentication**:
    *   Select **Password** and create a strong root password. (Save this!).
7.  **Hostname**: Name it something cool, like `tiktok-agent-server`.
8.  Click **Create Droplet**.
9.  **Wait** for the IP address to appear (e.g., `164.90.x.x`). **Copy this IP.**

---

## Phase 2: Configure DNS (GoDaddy)

We need to point your domain to your new server.

1.  Log in to **GoDaddy** and go to your **Domain Control Center**.
2.  Select your domain.
3.  Go to **Manage DNS**.
4.  Add the following **A Records**:

| Type | Name | Value | TTL |
| :--- | :--- | :--- | :--- |
| A | `@` | `YOUR_DROPLET_IP` | 600 seconds |
| A | `coolify` | `YOUR_DROPLET_IP` | 600 seconds |
| A | `n8n` | `YOUR_DROPLET_IP` | 600 seconds |

*   `@` points `yourdomain.com` to the server.
*   `coolify` points `coolify.yourdomain.com` to the management dashboard.
*   `n8n` points `n8n.yourdomain.com` to your workflow automation tool.

---

## Phase 3: Install Coolify

1.  Open **PowerShell** on your computer.
2.  Connect to your server:
    ```powershell
    ssh root@YOUR_DROPLET_IP
    ```
    *(Type `yes` if asked, then enter the password you created).*
3.  Run the Coolify installation command:
    ```bash
    curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
    ```
4.  Wait! It will take 5-10 minutes.
5.  Once finished, it will show: `Visit http://YOUR_IP:8000 to get started`.

---

## Phase 4: Setup Coolify & Deploy

1.  Open your browser to `http://YOUR_DROPLET_IP:8000`.
2.  **Register** your admin account.
3.  **Onboarding**:
    *   Select **"Self-hosted"**.
    *   It will ask for a domain. Enter `http://coolify.yourdomain.com` (replace with your actual domain).
    *   Coolify will automatically configure SSL (HTTPS) for itself.
4.  **Create a Project**:
    *   Click **Projects** > **+ New Project**.
    *   Name it `TikTok Agent`.
    *   Click on the environment (e.g., `Production`).
5.  **Add Resources**:

    ### A. Add PostgreSQL Database
    1.  Click **+ New Resource** > **Database** > **PostgreSQL**.
    2.  Select your server (`localhost`).
    3.  Set **Destination Docker Network** (default is fine).
    4.  Click **Continue**.
    5.  **Important**: In the configuration page, toggle **"Public Port"** to ON if you want to connect from your local computer (e.g., TablePlus/DBeaver).
    6.  Click **Start**.
    7.  **Copy the Connection String** (starts with `postgresql://...`). You'll need this for n8n.

    ### B. Add n8n
    1.  Click **+ New Resource** > **Service**.
    2.  Search for **n8n** and select it.
    3.  Configuration:
        *   **Name**: `n8n`
        *   **Domain**: `https://n8n.yourdomain.com`
    4.  **Environment Variables**:
        *   Find `DB_TYPE`. Set to `postgresdb`.
        *   Find `DB_POSTGRESDB_HOST`. Set to the *internal* IP or container name of your database (Coolify shows this in the DB details).
        *   *Easier Option*: n8n in Coolify often comes with its own internal Postgres. You can just use the default settings first to get it running.
    5.  Click **Deploy**.

    > [!CAUTION]
    > **Critical: Network Configuration**
    > By default, n8n and Postgres may be on different Docker networks and won't be able to communicate. You MUST configure them to use the same network:
    >
    > **For n8n:**
    > 1. Go to n8n service > **Docker Compose** tab
    > 2. Add under the `n8n:` service (same level as `image:`, `environment:`):
    >    ```yaml
    >    networks:
    >      - coolify
    >    ```
    > 3. At the bottom of the file (same level as `services:`), add:
    >    ```yaml
    >    networks:
    >      coolify:
    >        external: true
    >    ```
    > 4. Save and **Redeploy**
    >
    > **For Postgres:**
    > 1. Go to Postgres service > **Configuration**
    > 2. In the **Network** field, type: `coolify`
    > 3. Save and **Restart**
    >
    > Without this configuration, you'll get `getaddrinfo EAI_AGAIN` errors when n8n tries to connect to the database.

---

## Phase 5: Configure the Agent

1.  Go to `https://n8n.yourdomain.com`.
2.  Set up your owner account.
3.  **Import Workflow**:
    *   Go to **Workflows** > **Import from File**.
    *   Go to **Workflows** > **Import from File**.
    *   Upload `tiktok_ads_production_workflow.json` (this is the final, tested version with fallback logic).
4.  **Setup Credentials**:
    *   **Postgres**: 
        *   Go to **Credentials** > **Add Credential** > **Postgres**
        *   **Host**: Use the internal hostname from Coolify (e.g., `zoscco4kg0c0o4okw0o8o0k8`)
        *   **Port**: `5432`
        *   **User**: `postgres`
        *   **Password**: Copy from Coolify Postgres configuration
        *   **Database**: `postgres`
        *   **SSL**: Disable
    *   **OpenAI**: Add your API Key.
5.  **Initialize Database**:
    *   **Method 1 (Recommended)**: Use the init workflow
        1. Import `init_db_workflow.json` into n8n
        2. Double-click the "Run Schema SQL" node
        3. Select your Postgres credential
        4. Click **Execute Node**
    *   **Method 2**: Use TablePlus with SSH Tunnel
        1. Enable "Over SSH" in TablePlus
        2. SSH Server: `YOUR_DROPLET_IP`, Port: `22`, User: `root`
        3. Database Host: `127.0.0.1`, Port: `3000` (or the mapped port from Coolify)
      *   Run the script `tiktok_schema_cloudsql.sql`

## Phase 6: Verification & Troubleshooting

### Common Issues

1.  **"Connection Refused" or "EAI_AGAIN"**:
    *   This means n8n cannot find Postgres.
    *   **Fix**: Ensure both services are on the `coolify` network (see Phase 4 Caution box).
    *   **Fix**: Restart BOTH services after changing network settings.

2.  **"Undefined" errors in Campaign Generation**:
    *   This means OpenAI JSON parsing failed.
    *   **Fix**: Use the `tiktok_ads_production_workflow.json` which has built-in fallback logic to force your input values (Budget, Objective) even if AI fails.

3.  **Webhook 404 Error**:
    *   **Fix**: Ensure the workflow is **Activated** (toggle in top-right).
    *   **Fix**: Ensure the Webhook node path is exactly `ads/generate`.

## 🎉 Done!

Your agent is now live at `https://n8n.yourdomain.com`.
You can trigger it via Webhook: `https://n8n.yourdomain.com/webhook/ads/generate`

### Example Test Command
```bash
curl -X POST https://n8n.yourdomain.com/webhook/ads/generate \
  -H "Content-Type: application/json" \
  -d '{
    "brand": "ChocoBites",
    "objective": "MESSAGES",
    "locations": ["Piedras Negras, MX"],
    "daily_budget_mxn": 200,
    "age_range": "18-35",
    "gender": "ALL",
    "language": "es,*"
  }'
```
