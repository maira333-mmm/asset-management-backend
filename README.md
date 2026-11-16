Asset Management System - Backend API

A complete backend system for managing company assets, built with Node.js, Express, PostgreSQL, and Docker. It includes JWT Authentication, Role-Based Access Control (RBAC), and full CRUD operations for Master Data and Assets.

🚀 Tech Stack

Node.js & Express.js (Backend API)

PostgreSQL (Relational Database)

JWT (JSON Web Tokens) (Authentication)

Bcrypt.js (Password Hashing)

Express Validator (Data Validation)

Swagger UI (API Documentation)

Docker & Docker Compose (Containerization)

🛠️ Prerequisites
Before running this project, make sure you have installed:

Node.js (v18 or higher)

Docker Desktop (Running in the background)

📦 How to Run the Project

Clone the repository:
git clone https://github.com/maira333-mmm/asset-management-backend.git
cd asset-management-backend

Create the .env file:
Create a new file named .env in the root directory and paste the following:
PORT=5000
DB_USER=postgres
DB_PASSWORD=admin123
DB_HOST=db
DB_PORT=5432
DB_NAME=asset_management_db
JWT_SECRET=super_secret_key_123

Start the application with Docker:
docker-compose up --build -d
(The -d flag runs it in the background. If you want to see the logs, remove -d)

Access the APIs:

API Base URL: http://localhost:5000

Swagger Documentation: http://localhost:5000/api-docs

🗄️ Database Setup
The PostgreSQL database and all 22 tables are automatically created when you run Docker. The initialization script is located at db/init.sql and runs on the first startup.

🔐 Authentication & Roles
The system uses JWT Authentication.
There are 3 roles defined in the system:

Admin: Can manage Master Data (Departments, Vendors, Categories, Locations) and perform full CRUD on Assets.

Manager: (Upcoming) Can view assets, approve requests, and assign assets.

Employee: (Upcoming) Can request assets and view their assigned assets.

Default Admin Credentials (for testing)

Email: maira@techavenue.com

Password: Admin@123

(Note: To use protected routes in Swagger, first hit the /api/auth/login endpoint, copy the token, and paste it into the "Authorize" button at the top right).

📌 API Endpoints (Implemented so far)

1. Auth

POST /api/auth/signup - Register a new user

POST /api/auth/login - Login and get JWT token

2. Master Data (Admin Only)

POST /api/departments | GET /api/departments

POST /api/vendors | GET /api/vendors

POST /api/categories | GET /api/categories

POST /api/locations | GET /api/locations

3. Assets

POST /api/assets - Create a new asset (Admin Only)

GET /api/assets - Get all assets

PUT /api/assets/:id - Update an asset (Admin Only)

DELETE /api/assets/:id - Delete an asset (Admin Only)

🛑 Stopping the Application
To stop the Docker containers, run:
docker-compose down

📝 Next Steps (In Progress)

Employee Management Module

Asset Request & Approval Workflow

Asset Assignment & Return Module