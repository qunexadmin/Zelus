"""
Seed script to populate database with sample data for development
Run with: python seed_data.py
"""
import sys
from datetime import datetime, timedelta
from app.db import SessionLocal, init_db
from app.models import User, Salon, Stylist, Service


def seed_database():
    """Populate database with sample data"""
    print("🌱 Starting database seeding...")
    
    # Initialize database
    init_db()
    
    db = SessionLocal()
    
    try:
        # Check if data already exists
        if db.query(User).count() > 0:
            print("⚠️  Database already contains data. Skipping seed.")
            return
        
        print("👤 Creating users...")
        # Create sample users
        users = [
            User(
                id="user-1",
                email="customer1@example.com",
                name="Alice Johnson",
                phone="+1-555-0101",
            ),
            User(
                id="user-2",
                email="customer2@example.com",
                name="Bob Smith",
                phone="+1-555-0102",
            ),
            User(
                id="user-3",
                email="demo@zelux.com",
                name="Demo User",
                phone="+1-555-0100",
            ),
        ]
        db.add_all(users)
        db.commit()
        print(f"✅ Created {len(users)} users")
        
        print("🏪 Creating salons...")
        # Create sample salons
        salons = [
            Salon(
                id="salon-1",
                name="Elite Hair Studio",
                description="Premier salon offering cutting-edge styling and color services",
                address="123 Main Street",
                city="New York",
                state="NY",
                zip_code="10001",
                phone="+1-555-1001",
                email="contact@elitehair.com",
                latitude=40.7589,
                longitude=-73.9851,
                rating=4.8,
                review_count=234,
            ),
            Salon(
                id="salon-2",
                name="Color Studio NYC",
                description="Specialists in hair color and transformations",
                address="456 Broadway",
                city="New York",
                state="NY",
                zip_code="10012",
                phone="+1-555-1002",
                email="info@colorstudio.com",
                latitude=40.7255,
                longitude=-74.0023,
                rating=4.9,
                review_count=189,
            ),
            Salon(
                id="salon-3",
                name="Downtown Barbers",
                description="Classic barbershop with modern techniques",
                address="789 Park Avenue",
                city="New York",
                state="NY",
                zip_code="10021",
                phone="+1-555-1003",
                email="hello@downtownbarbers.com",
                latitude=40.7736,
                longitude=-73.9629,
                rating=4.7,
                review_count=312,
            ),
        ]
        db.add_all(salons)
        db.commit()
        print(f"✅ Created {len(salons)} salons")
        
        print("💇 Creating stylists...")
        # Create sample stylists
        stylists = [
            Stylist(
                id="stylist-1",
                salon_id="salon-1",
                name="Jane Smith",
                bio="Award-winning stylist specializing in modern cuts and color",
                specialties=["Haircuts", "Color", "Balayage", "Styling"],
                years_experience=8,
                rating=4.9,
                review_count=156,
                base_price=75.0,
                is_verified=True,
            ),
            Stylist(
                id="stylist-2",
                salon_id="salon-1",
                name="Michael Chen",
                bio="Creative colorist with expertise in fashion colors",
                specialties=["Color", "Balayage", "Fashion Colors"],
                years_experience=6,
                rating=4.8,
                review_count=98,
                base_price=85.0,
                is_verified=True,
            ),
            Stylist(
                id="stylist-3",
                salon_id="salon-2",
                name="Sarah Johnson",
                bio="Master colorist specializing in natural-looking highlights",
                specialties=["Color", "Highlights", "Treatments"],
                years_experience=10,
                rating=5.0,
                review_count=203,
                base_price=95.0,
                is_verified=True,
            ),
            Stylist(
                id="stylist-4",
                salon_id="salon-3",
                name="Mike Brown",
                bio="Classic barber with modern styling skills",
                specialties=["Haircuts", "Beard Trim", "Hot Towel Shave"],
                years_experience=12,
                rating=4.7,
                review_count=267,
                base_price=45.0,
                is_verified=True,
            ),
        ]
        db.add_all(stylists)
        db.commit()
        print(f"✅ Created {len(stylists)} stylists")
        
        print("✂️  Creating services...")
        # Create sample services
        services = [
            # Jane's services
            Service(
                id="service-1",
                stylist_id="stylist-1",
                name="Women's Haircut & Style",
                description="Precision cut with blow-dry styling",
                category="haircut",
                duration_minutes=60,
                price=75.0,
            ),
            Service(
                id="service-2",
                stylist_id="stylist-1",
                name="Balayage Color",
                description="Hand-painted highlights for natural look",
                category="color",
                duration_minutes=180,
                price=200.0,
            ),
            # Michael's services
            Service(
                id="service-3",
                stylist_id="stylist-2",
                name="Full Color",
                description="All-over color application",
                category="color",
                duration_minutes=120,
                price=150.0,
            ),
            Service(
                id="service-4",
                stylist_id="stylist-2",
                name="Fashion Color",
                description="Creative color (vivids, pastels)",
                category="color",
                duration_minutes=180,
                price=250.0,
            ),
            # Sarah's services
            Service(
                id="service-5",
                stylist_id="stylist-3",
                name="Highlights",
                description="Traditional foil highlights",
                category="color",
                duration_minutes=150,
                price=180.0,
            ),
            # Mike's services
            Service(
                id="service-6",
                stylist_id="stylist-4",
                name="Men's Haircut",
                description="Classic cut with hot towel",
                category="haircut",
                duration_minutes=45,
                price=45.0,
            ),
            Service(
                id="service-7",
                stylist_id="stylist-4",
                name="Beard Trim & Shape",
                description="Professional beard grooming",
                category="grooming",
                duration_minutes=30,
                price=25.0,
            ),
        ]
        db.add_all(services)
        db.commit()
        print(f"✅ Created {len(services)} services")
        
        print("\n✨ Database seeding completed successfully!")
        print("\n📊 Summary:")
        print(f"   - Users: {len(users)}")
        print(f"   - Salons: {len(salons)}")
        print(f"   - Stylists: {len(stylists)}")
        print(f"   - Services: {len(services)}")
        print("\n🚀 You can now start the API server and test the endpoints!")
        
    except Exception as e:
        print(f"❌ Error seeding database: {e}")
        db.rollback()
        raise
    finally:
        db.close()


if __name__ == "__main__":
    seed_database()

