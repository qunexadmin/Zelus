# 🔧 Backend Documentation

**FastAPI Backend for Zelux Platform**

---

## 📊 Current Status

**Status:** ✅ Running  
**Server:** AWS EC2 (3.24.31.8)  
**Port:** 8006  
**Database:** Neon PostgreSQL (Serverless)  
**Health:** http://3.24.31.8:8006/health  
**API Docs:** http://3.24.31.8:8006/docs  
**Last Updated:** October 18, 2025 (Migrated to Neon)

---

## 🏗️ Tech Stack

- **Framework:** FastAPI 0.104.1
- **Python:** 3.10.12
- **Database:** Neon PostgreSQL 17.5 (Serverless)
- **ORM:** SQLAlchemy 2.0.23
- **Migrations:** Alembic 1.12.1
- **Validation:** Pydantic 2.5.0
- **Server:** Uvicorn 0.24.0

---

## 📁 Project Structure

```
backend/
├── app/
│   ├── routers/              # API endpoints
│   │   ├── auth.py          # Authentication
│   │   ├── salons.py        # Salon endpoints
│   │   ├── stylists.py      # Stylist endpoints
│   │   ├── feed.py          # Feed endpoints
│   │   └── ai.py            # AI features (placeholder)
│   ├── models/               # SQLAlchemy models
│   │   ├── user.py
│   │   ├── salon.py
│   │   ├── stylist.py
│   │   ├── service.py
│   │   └── booking.py
│   ├── schemas/              # Pydantic schemas
│   ├── core/                 # Core utilities
│   │   └── config.py        # Settings
│   ├── db.py                # Database setup
│   └── main.py              # FastAPI app
├── alembic/                  # Database migrations
├── requirements.txt          # Python dependencies
├── .env                      # Environment variables
└── seed_data.py             # Sample data loader
```

---

## ⚙️ Configuration

### Environment Variables (.env)

```bash
# Database (Neon PostgreSQL - Serverless)
# Database name: zelus
DATABASE_URL=postgresql://user:password@hostname.neon.tech/zelus?sslmode=require

# Security
SECRET_KEY=dev-secret-key-change-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=10080

# CORS
BACKEND_CORS_ORIGINS=["http://localhost:3000","http://localhost:*"]

# API Settings
API_V1_STR=/api/v1
PROJECT_NAME=Zelux API
```

---

## 🚀 Setup & Installation

### 1. Prerequisites
```bash
# Check Python version
python3 --version  # Should be 3.10+

# Database: Neon PostgreSQL (already configured in .env)
# No Docker required - using serverless Neon database
```

### 2. Create Virtual Environment
```bash
cd /home/ubuntu/Zelus/backend
python3 -m venv venv
source venv/bin/activate
```

### 3. Install Dependencies
```bash
pip install -r requirements.txt
pip install pydantic[email]  # For email validation
```

### 4. Initialize Database (First Time)
```bash
cd backend
source venv/bin/activate
python seed_data.py
```

### 5. Start Backend
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8006 --reload
```

---

## 🎮 Management Commands

### Check Backend Status
```bash
# Check if running
ps aux | grep "uvicorn.*8006" | grep -v grep

# Check health
curl http://localhost:8006/health
```

### Start Backend
```bash
cd /home/ubuntu/Zelus/backend
source venv/bin/activate
uvicorn app.main:app --host 0.0.0.0 --port 8006 --reload &
```

### Stop Backend
```bash
pkill -f "uvicorn app.main:app"
```

### Restart Backend
```bash
pkill -f "uvicorn app.main:app"
cd /home/ubuntu/Zelus/backend
source venv/bin/activate
uvicorn app.main:app --host 0.0.0.0 --port 8006 --reload &
```

### View Logs (Foreground Mode)
```bash
cd /home/ubuntu/Zelus/backend
source venv/bin/activate
uvicorn app.main:app --host 0.0.0.0 --port 8006 --reload
# Press Ctrl+C to stop
```

---

## 🗄️ Database Management

### Database: Neon PostgreSQL (Serverless)

The database is hosted on Neon (https://neon.tech) - no local Docker setup required.

### Database Migrations
```bash
cd /home/ubuntu/Zelus/backend
source venv/bin/activate

# Create new migration
alembic revision --autogenerate -m "description"

# Apply migrations
alembic upgrade head

# Rollback migration
alembic downgrade -1

# Check current version
alembic current
```

### Connect to Database
```bash
# Using psql (install if needed: sudo apt install postgresql-client)
psql "postgresql://[your-neon-connection-string]"

# Or manage via Neon Console: https://console.neon.tech
```

### Reset Database (Use with Caution!)
```bash
# Option 1: Drop and recreate tables using Alembic
alembic downgrade base
alembic upgrade head
python seed_data.py

# Option 2: Use Neon Console to delete/recreate branch
# Go to https://console.neon.tech and manage branches
```

---

## 📡 API Endpoints

**Base URL:** `http://3.24.31.8:8006/api/v1`

### Health Check
- `GET /health` - Backend health status

### Feed (Social)
- `GET /feed` - For You feed (mock)
- `GET /feed/trending` - Trending feed (sorted by engagement)
- `POST /feed/{post_id}/tag-salon?salon_id=...` - Tag a salon on post (MVP stub)
- `POST /feed/{post_id}/tag-stylist?stylist_id=...` - Tag a stylist on post (MVP stub)
- `DELETE /feed/{post_id}/tag-salon/{salon_id}` - Remove salon tag (stub)
- `DELETE /feed/{post_id}/tag-stylist/{stylist_id}` - Remove stylist tag (stub)

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/verify-token` - Verify Firebase token
- `GET /api/v1/auth/me` - Get current user

### Salons
- `GET /api/v1/salons` - List all salons (with filters)
- `GET /api/v1/salons/{id}` - Get salon details
- `GET /api/v1/salons/{id}/stylists` - Get salon's stylists

### Stylists
- `GET /api/v1/stylists` - List all stylists
- `GET /api/v1/stylists/{id}` - Get stylist profile
- `GET /api/v1/stylists/{id}/services` - Get stylist's services
- `GET /api/v1/stylists/{id}/availability` - Check availability

### Booking
Booking is handled externally in Phase 1. No booking API is exposed. Salons may include a `booking_url` that the mobile app opens in the browser.

### AI Features (Placeholder)
- `POST /api/v1/ai/preview` - Generate style preview
- `POST /api/v1/ai/recommendations` - Get style recommendations
- `GET /api/v1/ai/styles/trending` - Get trending styles

---

## 🧪 Testing

### Test Endpoints
```bash
# Health check
curl http://3.24.31.8:8006/health

# List salons
curl http://3.24.31.8:8006/api/v1/salons

# Get specific salon
curl http://3.24.31.8:8006/api/v1/salons/salon-1

# Get stylist
curl http://3.24.31.8:8006/api/v1/stylists/stylist-1

# Register user
curl -X POST http://3.24.31.8:8006/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","name":"Test User"}'
```

### Interactive API Docs
Open in browser: http://3.24.31.8:8006/docs

---

## 📊 Database Schema

### Users Table
```sql
- id: VARCHAR (Primary Key)
- firebase_uid: VARCHAR (Unique, nullable)
- email: VARCHAR (Unique)
- name: VARCHAR
- phone: VARCHAR
- profile_image_url: VARCHAR
- is_stylist: BOOLEAN
- is_admin: BOOLEAN
- created_at: TIMESTAMP
- updated_at: TIMESTAMP
```

### Salons Table
```sql
- id: VARCHAR (Primary Key)
- name: VARCHAR
- description: TEXT
- address: VARCHAR
- city: VARCHAR
- state: VARCHAR
- zip_code: VARCHAR
- country: VARCHAR
- phone: VARCHAR
- email: VARCHAR
- website: VARCHAR
- latitude: FLOAT
- longitude: FLOAT
- cover_image_url: VARCHAR
- logo_url: VARCHAR
- rating: FLOAT
- review_count: FLOAT
- is_active: BOOLEAN
- created_at: TIMESTAMP
- updated_at: TIMESTAMP
```

### Stylists Table
```sql
- id: VARCHAR (Primary Key)
- user_id: VARCHAR (Foreign Key → users)
- salon_id: VARCHAR (Foreign Key → salons)
- name: VARCHAR
- bio: TEXT
- specialties: JSON
- years_experience: INTEGER
- profile_image_url: VARCHAR
- portfolio_images: JSON
- rating: FLOAT
- review_count: INTEGER
- base_price: FLOAT
- is_active: BOOLEAN
- is_verified: BOOLEAN
- created_at: TIMESTAMP
- updated_at: TIMESTAMP
```

### Services Table
```sql
- id: VARCHAR (Primary Key)
- stylist_id: VARCHAR (Foreign Key → stylists)
- name: VARCHAR
- description: TEXT
- category: VARCHAR
- duration_minutes: INTEGER
- price: FLOAT
- image_url: VARCHAR
- is_active: BOOLEAN
- created_at: TIMESTAMP
- updated_at: TIMESTAMP
```

### Salon Booking URL
```sql
- id: VARCHAR (Primary Key)
- user_id: VARCHAR (Foreign Key → users)
- stylist_id: VARCHAR (Foreign Key → stylists)
- service_id: VARCHAR (Foreign Key → services)
- scheduled_at: TIMESTAMP
- duration_minutes: FLOAT
- status: VARCHAR (PENDING, CONFIRMED, COMPLETED, CANCELLED, NO_SHOW)
- total_price: FLOAT
- payment_status: VARCHAR (PENDING, PAID, REFUNDED, FAILED)
- payment_intent_id: VARCHAR
- customer_notes: TEXT
- stylist_notes: TEXT
- created_at: TIMESTAMP
- updated_at: TIMESTAMP
```

---

## 🗃️ Sample Data

### Users
- `demo@zelux.com` - Demo User
- `customer1@example.com` - Alice Johnson
- `customer2@example.com` - Bob Smith

### Salons
- `salon-1` - Elite Hair Studio (NYC)
- `salon-2` - Color Studio NYC
- `salon-3` - Downtown Barbers

### Stylists
- `stylist-1` - Jane Smith (Elite Hair Studio)
- `stylist-2` - Michael Chen (Elite Hair Studio)
- `stylist-3` - Sarah Johnson (Color Studio NYC)
- `stylist-4` - Mike Brown (Downtown Barbers)

### Services
- Women's Haircut & Style - $75
- Balayage Color - $200
- Full Color - $150
- Fashion Color - $250
- Highlights - $180
- Men's Haircut - $45
- Beard Trim & Shape - $25

---

## 🔐 Security

### Current Setup
- ✅ Environment variables
- ✅ CORS configured
- ✅ JWT ready (mock auth for now)
- ⚠️ HTTP only (need HTTPS for production)

### Production Todos
- [ ] Enable Firebase authentication
- [ ] Add rate limiting
- [ ] Configure SSL/HTTPS
- [ ] Restrict CORS to specific origins
- [ ] Add API key authentication
- [ ] Enable request validation
- [ ] Set up logging & monitoring

---

## 🐛 Troubleshooting

### Backend Won't Start
```bash
# Check if port is in use
sudo lsof -i :8006

# Check Python dependencies
cd /home/ubuntu/Zelus/backend
source venv/bin/activate
pip install -r requirements.txt
```

### Database Connection Error
```bash
# Check connection string in .env
cat /home/ubuntu/Zelus/backend/.env | grep DATABASE_URL

# Test connection
cd /home/ubuntu/Zelus/backend
source venv/bin/activate
python -c "from app.db import engine; engine.connect(); print('✅ Connected')"

# Check Neon dashboard: https://console.neon.tech
# Verify database is active and not suspended
```

### Module Not Found Errors
```bash
cd /home/ubuntu/Zelus/backend
source venv/bin/activate
pip install -r requirements.txt
pip install pydantic[email]
```

### Port Already in Use
```bash
# Find process using port 8006
sudo lsof -i :8006

# Kill the process
pkill -f "uvicorn"
```

---

## 📈 Performance

### Current Setup
- ✅ Auto-reload enabled (development)
- ✅ Single worker (development)
- ⚠️ Not optimized for production

### Production Optimizations
```bash
# Multiple workers (production)
gunicorn app.main:app \
  --workers 4 \
  --worker-class uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8006
```

---

## 📝 Development Workflow

### Making Changes
1. Edit code in `app/` directory
2. Uvicorn auto-reloads (if `--reload` flag used)
3. Test at http://localhost:8006/docs

### Database Migrations
```bash
# Create migration
alembic revision --autogenerate -m "description"

# Apply migration
alembic upgrade head

# Rollback migration
alembic downgrade -1
```

### Code Quality
```bash
# Format code
black app/

# Check linting
flake8 app/

# Type checking
mypy app/
```

---

## 🔄 Backup & Restore

### Neon Automatic Backups
Neon automatically backs up your database with point-in-time recovery.

### Manual Backup
```bash
# Export schema and data
pg_dump "postgresql://[your-neon-connection-string]" > backup.sql
```

### Restore from Backup
```bash
# Restore to Neon database
psql "postgresql://[your-neon-connection-string]" < backup.sql
```

### Database Branching (Neon Feature)
```bash
# Create a development branch from production data
# Use Neon Console: https://console.neon.tech
# Branches are instant copies - perfect for testing!
```

---

## 📞 Support

**Repository:** https://github.com/qunexadmin/Zelus  
**Issues:** GitHub Issues  
**API Docs:** http://3.24.31.8:8006/docs

---

**Last Updated:** October 18, 2025 - Migrated to Neon PostgreSQL


