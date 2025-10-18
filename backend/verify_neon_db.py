"""
Verify Neon Database Setup
Run: python verify_neon_db.py
"""
from sqlalchemy import create_engine, text, inspect
from app.core.config import settings
import sys

def verify_database():
    print("\n" + "=" * 70)
    print("🔍 NEON DATABASE VERIFICATION")
    print("=" * 70)
    
    try:
        # Extract database info from connection string
        url = settings.DATABASE_URL
        parts = url.split('@')[1].split('/')[0]
        db_name = url.split('/')[-1].split('?')[0]
        
        print(f"\n📡 Connection Info:")
        print(f"   Host: {parts}")
        print(f"   Database: {db_name}")
        
        # Connect to database
        engine = create_engine(settings.DATABASE_URL)
        
        with engine.connect() as connection:
            # Check PostgreSQL version
            result = connection.execute(text("SELECT version()"))
            version = result.fetchone()[0].split(',')[0]
            print(f"   Version: {version}")
            
            print("\n" + "-" * 70)
            print("📋 TABLES")
            print("-" * 70)
            
            # Get all tables
            result = connection.execute(text("""
                SELECT 
                    table_name,
                    (SELECT COUNT(*) FROM information_schema.columns 
                     WHERE table_schema = 'public' AND table_name = t.table_name) as column_count
                FROM information_schema.tables t
                WHERE table_schema = 'public'
                ORDER BY table_name
            """))
            
            tables = result.fetchall()
            
            if not tables:
                print("❌ NO TABLES FOUND!")
                print("\n💡 To create tables, run:")
                print("   alembic upgrade head")
                return False
            
            print(f"\n✅ Found {len(tables)} tables:\n")
            
            for table_name, col_count in tables:
                if table_name != 'alembic_version':
                    # Get row count
                    count_result = connection.execute(text(f"SELECT COUNT(*) FROM {table_name}"))
                    row_count = count_result.fetchone()[0]
                    print(f"   📊 {table_name:20s} - {col_count:2d} columns, {row_count:3d} rows")
            
            print("\n" + "-" * 70)
            print("📊 DATA SUMMARY")
            print("-" * 70 + "\n")
            
            # Check users
            result = connection.execute(text("SELECT id, name, email FROM users LIMIT 5"))
            users = result.fetchall()
            print(f"👤 Users ({len(users)}):")
            for user in users:
                print(f"   - {user[1]} ({user[2]})")
            
            # Check salons
            result = connection.execute(text("SELECT id, name, city FROM salons LIMIT 5"))
            salons = result.fetchall()
            print(f"\n🏪 Salons ({len(salons)}):")
            for salon in salons:
                print(f"   - {salon[1]} ({salon[2]})")
            
            # Check stylists
            result = connection.execute(text("SELECT id, name, salon_id FROM stylists LIMIT 5"))
            stylists = result.fetchall()
            print(f"\n💇 Stylists ({len(stylists)}):")
            for stylist in stylists:
                print(f"   - {stylist[1]} (Salon: {stylist[2]})")
            
            # Check services
            result = connection.execute(text("SELECT id, name, price FROM services LIMIT 5"))
            services = result.fetchall()
            print(f"\n✂️  Services ({len(services)}):")
            for service in services:
                print(f"   - {service[1]} (${service[2]})")
            
            # Check Alembic version
            result = connection.execute(text("SELECT version_num FROM alembic_version"))
            alembic_version = result.fetchone()
            
            print("\n" + "-" * 70)
            print("🔄 MIGRATION STATUS")
            print("-" * 70)
            print(f"\n✅ Current migration: {alembic_version[0]}")
            
            print("\n" + "=" * 70)
            print("✅ DATABASE VERIFICATION SUCCESSFUL!")
            print("=" * 70)
            
            print("\n📖 To view in Neon Console:")
            print("   1. Go to: https://console.neon.tech")
            print("   2. Select your project")
            print("   3. Click 'SQL Editor' or 'Tables' tab")
            print("   4. Make sure you're on the 'main' branch")
            print("   5. View 'public' schema")
            
            print("\n🌐 API Test:")
            print("   curl http://localhost:8006/api/v1/salons")
            
            return True
            
    except Exception as e:
        print("\n" + "=" * 70)
        print(f"❌ ERROR: {str(e)}")
        print("=" * 70)
        
        print("\n💡 Troubleshooting:")
        print("   1. Check .env file has correct DATABASE_URL")
        print("   2. Verify Neon database is active")
        print("   3. Run: alembic upgrade head")
        print("   4. Check Neon Console: https://console.neon.tech")
        
        return False

if __name__ == "__main__":
    success = verify_database()
    sys.exit(0 if success else 1)

