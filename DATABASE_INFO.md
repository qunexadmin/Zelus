# 📊 Database Configuration - Zelus

**Database Name:** `zelus`  
**Provider:** Neon (Serverless PostgreSQL)  
**Region:** AWS ap-southeast-1 (Singapore)  
**PostgreSQL Version:** 17.5

---

## 🔗 Connection Information

### Connection String Format:
```
postgresql://username:password@endpoint.neon.tech/zelus?sslmode=require
```

### Your Connection:
- **Endpoint:** ep-sweet-dust-a1sdoish-pooler.ap-southeast-1.aws.neon.tech
- **Database:** zelus
- **Schema:** public
- **Branch:** main

---

## 📋 Tables

| Table Name | Rows | Description |
|------------|------|-------------|
| users | 3 | Customer accounts |
| salons | 3 | Salon/studio locations |
| stylists | 4 | Professional stylists |
| services | 7 | Services offered by stylists |
| alembic_version | 1 | Migration tracking (system table) |

---

## 🔧 Configuration Files

### 1. Backend Environment (.env)
**Location:** `/home/ubuntu/Zelus/backend/.env`
```bash
DATABASE_URL=postgresql://neondb_owner:npg_xxx@ep-sweet-dust-a1sdoish-pooler.ap-southeast-1.aws.neon.tech/zelus?sslmode=require&channel_binding=require
```

### 2. Example Configuration (env.example)
**Location:** `/home/ubuntu/Zelus/backend/env.example`
- Updated with `zelus` database name
- Contains example format for Neon connection

### 3. Application Config (config.py)
**Location:** `/home/ubuntu/Zelus/backend/app/core/config.py`
- Reads DATABASE_URL from environment
- No hardcoded database name

### 4. Alembic Config (alembic.ini)
**Location:** `/home/ubuntu/Zelus/backend/alembic.ini`
- Uses environment variable (no hardcoded URL)
- Configured via alembic/env.py

---

## 📚 Documentation Updated

All documentation files now reference the `zelus` database:

1. ✅ **README.md**
   - Database name: zelus
   - Connection examples updated

2. ✅ **BACKEND.md**
   - Environment variables updated
   - Database name specified: zelus

3. ✅ **PROJECT_OVERVIEW.md**
   - Project status shows: Neon PostgreSQL - zelus

4. ✅ **env.example**
   - Example connection string uses: /zelus?sslmode=require

---

## 🌐 Neon Console Access

### View Your Database:
1. Go to: https://console.neon.tech
2. Select project: **zelus** (or look for endpoint: ep-sweet-dust-a1sdoish)
3. Ensure branch: **main** is selected
4. Database dropdown: Select **zelus**
5. Click **Tables** to view all tables

### SQL Editor:
Access at: https://console.neon.tech/app/projects/royal-butterfly-99105535/branches/br-fancy-bird-a1okwoi0/sql-editor

---

## 🔄 Database Migrations

### Create Migration (after model changes):
```bash
cd /home/ubuntu/Zelus/backend
source venv/bin/activate
alembic revision --autogenerate -m "description of changes"
```

### Apply Migration:
```bash
alembic upgrade head
```

### Check Current Version:
```bash
alembic current
```

### Rollback (if needed):
```bash
alembic downgrade -1
```

---

## 🧪 Verification Commands

### Check Database Connection:
```bash
cd /home/ubuntu/Zelus/backend
source venv/bin/activate
python verify_neon_db.py
```

### Quick Check:
```bash
python -c "from app.core.config import settings; print(settings.DATABASE_URL.split('/')[-1].split('?')[0])"
# Should output: zelus
```

### Test API:
```bash
curl http://localhost:8006/api/v1/salons
# Should return 3 salons from zelus database
```

---

## 📊 Sample Data

### Users (3):
- customer1@example.com - Alice Johnson
- customer2@example.com - Bob Smith  
- demo@zelux.com - Demo User

### Salons (3):
- Elite Hair Studio (New York)
- Color Studio NYC (New York)
- Downtown Barbers (New York)

### Stylists (4):
- Jane Smith (Elite Hair Studio)
- Michael Chen (Elite Hair Studio)
- Sarah Johnson (Color Studio NYC)
- Mike Brown (Downtown Barbers)

### Services (7):
- Women's Haircut & Style - $75
- Balayage Color - $200
- Full Color - $150
- Fashion Color - $250
- Highlights - $180
- Men's Haircut - $45
- Beard Trim & Shape - $25

---

## ⚠️ Important Notes

1. **Database Name:** Always use `zelus` (not neondb)
2. **Connection String:** Must include `?sslmode=require`
3. **Migrations:** Run `alembic upgrade head` after pulling changes
4. **Backups:** Neon provides automatic backups and point-in-time recovery
5. **Branching:** Neon supports database branches for dev/staging

---

## 🆘 Troubleshooting

### Can't see tables in Neon Console?
- Check you're viewing the **main** branch
- Ensure **zelus** database is selected (dropdown at top)
- Check **public** schema is selected
- Click refresh button

### Connection Error?
- Verify DATABASE_URL in .env is correct
- Check database name is `zelus` (not neondb)
- Ensure Neon project is active (not suspended)

### API returns no data?
- Check API is using correct database: `cat backend/.env | grep DATABASE_URL`
- Verify data exists: `python verify_neon_db.py`
- Restart API server

---

**Last Updated:** October 18, 2025  
**Database:** zelus on Neon PostgreSQL 17.5
