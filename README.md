<div align="center">

<img width="100%" src="https://capsule-render.vercel.app/api?type=waving&height=210&color=0:111827,50:1E3A8A,100:3B82F6&text=Asset%20Management%20System&fontColor=ffffff&fontSize=46&fontAlignY=38&desc=Backend%20API%20%7C%20Node.js%20%7C%20Express%20%7C%20PostgreSQL%20%7C%20Docker&descAlignY=60&animation=fadeIn" alt="Asset Management System Header" />

<br>

<img src="https://readme-typing-svg.demolab.com?font=Inter&weight=600&size=20&duration=2800&pause=700&color=3B82F6&center=true&vCenter=true&repeat=true&width=750&height=52&lines=Enterprise+Asset+Management+Backend.;Built+with+Node.js+%7C+Express+%7C+PostgreSQL.;JWT+Authentication+%7C+RBAC+%7C+Dockerized.;Automated+Database+Setup+with+22+Tables." alt="Typing Animation" />

<br><br>

A comprehensive **Backend API system** for managing company assets, built with **Node.js, Express, PostgreSQL, and Docker**. Features robust JWT Authentication, Role-Based Access Control (RBAC), and full CRUD operations with strict departmental data isolation.

<br>

<a href="https://github.com/maira333-mmm/asset-management-backend">
  <img src="https://img.shields.io/badge/📂_SOURCE_CODE-181717?style=for-the-badge&logo=github&logoColor=white" alt="Source Code"/>
</a>

<a href="https://github.com/maira333-mmm/asset-management-backend/commits/main">
  <img src="https://img.shields.io/github/last-commit/maira333-mmm/asset-management-backend?style=for-the-badge&label=LAST%20UPDATE" alt="Last Update"/>
</a>

<br><br>

<img src="https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=nodedotjs&logoColor=white"/>
<img src="https://img.shields.io/badge/Express.js-000000?style=flat-square&logo=express&logoColor=white"/>
<img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=flat-square&logo=postgresql&logoColor=white"/>
<img src="https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white"/>
<img src="https://img.shields.io/badge/JWT-000000?style=flat-square&logo=jsonwebtokens&logoColor=white"/>
<img src="https://img.shields.io/badge/Swagger-85EA2D?style=flat-square&logo=swagger&logoColor=black"/>

</div>

---

# 📋 Table of Contents

- [📖 About](#-about)
- [🚀 Tech Stack](#-tech-stack)
- [🛠️ Prerequisites](#️-prerequisites)
- [📦 How to Run the Project](#-how-to-run-the-project)
- [🗄️ Database Setup](#️-database-setup)
- [🔐 Authentication & Roles (RBAC)](#-authentication--roles-rbac)
- [🔄 System Workflows](#-system-workflows)
- [📌 API Endpoints](#-api-endpoints)
- [🛑 Stopping the Application](#-stopping-the-application)
- [📝 Next Steps (In Progress)](#-next-steps-in-progress)
- [📬 Contact](#-contact)

---

# 📖 About

The **Asset Management System - Backend API** is a complete enterprise-grade backend solution designed to streamline the tracking, management, and administration of company assets. It provides a secure foundation with role-based access control, automated database initialization via Docker, and interactive API documentation through Swagger UI.

## 🎯 Key Highlights

- ✅ **JWT Authentication** - Secure token-based session management.
- ✅ **Role-Based Access Control (RBAC)** - Granular permissions for Admin, Manager, and Employee roles.
- ✅ **Departmental Data Isolation** - Managers and Employees only see data relevant to their specific department.
- ✅ **Full CRUD Operations** - Comprehensive management for Master Data and Company Assets.
- ✅ **Dockerized Environment** - Seamless one-command setup with PostgreSQL and Express containers.
- ✅ **Interactive Documentation** - Pre-configured Swagger UI for instant API testing.

---

# 🚀 Tech Stack

| Technology | Purpose |
|------------|---------|
| **Node.js & Express.js** | Backend API Framework |
| **PostgreSQL** | Relational Database Management |
| **Docker & Docker Compose** | Containerization & Multi-container orchestration |
| **JWT (JSON Web Tokens)** | Secure User Authentication |
| **Bcrypt.js** | Password Hashing & Security |
| **Express Validator** | Request Data Validation |
| **Swagger UI** | Interactive API Documentation |

---

# 🛠️ Prerequisites

Before running this project locally, make sure you have installed:
- [Node.js](https://nodejs.org/) (v18 or higher)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Must be running in the background)

---

# 📦 How to Run the Project

### 1. Clone the repository
```bash
git clone https://github.com/maira333-mmm/asset-management-backend.git
cd asset-management-backend\
2. Create the .env file
Create a new file named .env in the root directory and paste the following configuration:

PORT=5000
DB_USER=postgres
DB_PASSWORD=admin123
DB_HOST=db
DB_PORT=5432
DB_NAME=asset_management_db
JWT_SECRET=super_secret_key_123

3. Start the application with Docker
docker-compose up --build -d

4. Access the Services
API Base URL: http://localhost:5000

Swagger Documentation: http://localhost:5000/api-docs

🗄️ Database Setup
The PostgreSQL database and all 22 foundational tables are automatically provisioned when you launch Docker. The automated initialization script is located at db/init.sql and executes seamlessly on the first container startup.

🔐 Authentication & Roles (RBAC)
The system uses JWT Authentication. There are 3 distinct roles defined in the architecture with strict access control:

👑 Admin
Access Level: Full System Access.

Responsibilities: Can manage Master Data (Departments, Vendors, Categories, Locations), perform full CRUD on Assets, and create/manage both Managers and Employees.

Global View: Can view assets and employees across all departments.

🛡️ Manager
Access Level: Department-Specific Access.

Responsibilities: Can view employees only within their own department. Can assign available assets to their team members and approve/reject asset requests from their department.

Restrictions: Cannot create new assets, manage master data, or view other departments' data.

👤 Employee
Access Level: Personal Access.

Responsibilities: Can log in to view their own assigned assets. Can create asset requests for their department manager to approve.

Restrictions: Cannot assign assets or view company-wide data.

🔄 System Workflows
Admin Setup: Admin logs in, creates Departments, Categories, Vendors, and Locations. Admin then creates Managers and assigns them to specific departments.

Asset Creation: Admin registers new assets and assigns them to a specific department or keeps them in general inventory.

Manager Assignment: A Manager logs in and sees only their department's assets and employees. They select an employee and assign an available asset to them.

Employee Request: An Employee logs in, requests an asset (e.g., a laptop). The request goes to their specific Manager.

Manager Approval: The Manager reviews the request, approves it, and assigns an available asset from their department pool.

📌 API Endpoints
1. Authentication (/api/auth)
Method	Endpoint	Description
POST	/api/auth/signup	Register a new user
POST	/api/auth/login	Login and retrieve JWT token
2. Master Data — Admin Only (/api)
Method	Endpoint	Description
POST / GET	/api/departments	Manage company departments
POST / GET	/api/vendors	Manage asset vendors/suppliers
POST / GET	/api/categories	Manage asset categories
POST / GET	/api/locations	Manage office locations
3. Employees Management (/api/employees)
Method	Endpoint	Description	Access
POST	/api/employees	Create a new employee	Admin
GET	/api/employees	Get all employees	Admin (All) / Manager (Dept Only)
PUT	/api/employees/:id	Update employee details	Admin
DELETE	/api/employees/:id	Delete an employee	Admin
4. Assets Management (/api/assets)
Method	Endpoint	Description	Access
POST	/api/assets	Create a new asset record	Admin Only
GET	/api/assets	Retrieve all registered assets	Admin (All) / Manager (Dept)
PUT	/api/assets/:id	Update an existing asset	Admin Only
DELETE	/api/assets/:id	Delete an asset record	Admin Only
5. Assignments & Requests (/api/assignments, /api/requests)
Method	Endpoint	Description	Access
GET	/api/assignments/available-assets	Get available assets in Manager's dept	Manager
POST	/api/assignments/assign	Assign an asset to an employee	Manager
GET	/api/assignments/my-assets	View assigned assets	Employee
POST	/api/requests	Create a new asset request	Employee
GET	/api/requests/pending	View pending requests for team	Manager
PUT	/api/requests/:id/status	Approve/Reject a request	Manager
🧪 Default Admin Credentials (For Testing)
Email: maira@techavenue.com

Password: Admin@123

💡 Tip for Swagger Testing: To test protected endpoints in Swagger UI, first call the POST /api/auth/login endpoint, copy the returned token, click the "Authorize" button at the top right of Swagger, and paste your token.

🛑 Stopping the Application
To safely stop and tear down the Docker containers, run:

bash
docker-compose down
📝 Next Steps (In Progress)
☑ Employee Management Module
☑ Asset Request & Approval Workflow
☑ Asset Assignment & Return Module
□ Appearance Settings Module (Dynamic Branding / Color Scheme via Database)
👩‍💻 Author
Maira Alam


<div align="center"> <b>❤️ Built with Node.js, Express, PostgreSQL & Docker</b><br> <i>⭐ If you found this project helpful, consider giving it a Star!</i> </div> ```
