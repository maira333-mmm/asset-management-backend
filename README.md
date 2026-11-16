<div align="center">

<img width="100%" src="https://capsule-render.vercel.app/api?type=waving&height=210&color=0:111827,50:1E3A8A,100:3B82F6&text=Asset%20Management%20System&fontColor=ffffff&fontSize=46&fontAlignY=38&desc=Backend%20API%20%7C%20Node.js%20%7C%20Express%20%7C%20PostgreSQL%20%7C%20Docker&descAlignY=60&animation=fadeIn" alt="Asset Management System Header" />

<br>

<img src="https://readme-typing-svg.demolab.com?font=Inter&weight=600&size=20&duration=2800&pause=700&color=3B82F6&center=true&vCenter=true&repeat=true&width=750&height=52&lines=Enterprise+Asset+Management+Backend.;Built+with+Node.js+%7C+Express+%7C+PostgreSQL.;JWT+Authentication+%7C+RBAC+%7C+Dockerized.;Automated+Database+Setup+with+22+Tables." alt="Typing Animation" />

<br><br>

A comprehensive **Backend API system** for managing company assets, built with **Node.js, Express, PostgreSQL, and Docker**. Features robust JWT Authentication, Role-Based Access Control (RBAC), and full CRUD operations for Master Data and Company Assets.

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

- 📖 About
- 🚀 Tech Stack
- 🛠️ Prerequisites
- 📦 How to Run the Project
- 🗄️ Database Setup
- 🔐 Authentication & Roles
- 📌 API Endpoints
- 🛑 Stopping the Application
- 📝 Next Steps (In Progress)
- 📬 Contact

---

# 📖 About

The **Asset Management System - Backend API** is a complete enterprise-grade backend solution designed to streamline the tracking, management, and administration of company assets. It provides a secure foundation with role-based access control, automated database initialization via Docker, and interactive API documentation through Swagger UI.

## 🎯 Key Highlights

- ✅ **JWT Authentication** - Secure token-based session management
- ✅ **Role-Based Access Control (RBAC)** - Granular permissions for Admin, Manager, and Employee roles
- ✅ **Full CRUD Operations** - Comprehensive management for Master Data and Company Assets
- ✅ **Dockerized Environment** - Seamless one-command setup with PostgreSQL and Express containers
- ✅ **Interactive Documentation** - Pre-configured Swagger UI for instant API testing

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
git clone [https://github.com/maira333-mmm/asset-management-backend.git](https://github.com/maira333-mmm/asset-management-backend.git)
cd asset-management-backend


2. Create the .env file
Create a new file named .env in the root directory and paste the following configuration

PORT=5000
DB_USER=postgres
DB_PASSWORD=admin123
DB_HOST=db
DB_PORT=5432
DB_NAME=asset_management_db
JWT_SECRET=super_secret_key_123


3. Start the application with Docker

docker-compose up --build -d

(Note: The -d flag runs containers in the background. Remove -d if you wish to view real-time logs in your terminal).4. Access the ServicesAPI Base URL: http://localhost:5000Swagger Documentation: http://localhost:5000/api-docs🗄️ Database SetupThe PostgreSQL database and all 22 foundational tables are automatically provisioned when you launch Docker.The automated initialization script is located at db/init.sql and executes seamlessly on the first container startup.🔐 Authentication & RolesThe system uses JWT Authentication. There are 3 distinct roles defined in the architecture:RolePermissions & Access👑 AdminCan manage Master Data (Departments, Vendors, Categories, Locations) and perform full CRUD on Assets.🛡️ Manager (Upcoming)Can view assets, approve requests, and assign assets.👤 Employee (Upcoming)Can request assets and view their assigned assets.🧪 Default Admin Credentials (For Testing)Email: maira@techavenue.comPassword: Admin@123💡 Tip for Swagger Testing: To test protected endpoints in Swagger UI, first call the POST /api/auth/login endpoint, copy the returned token, click the "Authorize" button at the top right of Swagger, and paste your token.📌 API Endpoints1. Authentication (/api/auth)MethodEndpointDescriptionPOST/api/auth/signupRegister a new userPOST/api/auth/loginLogin and retrieve JWT token2. Master Data — Admin Only (/api)MethodEndpointDescriptionPOST / GET/api/departmentsManage company departmentsPOST / GET/api/vendorsManage asset vendors/suppliersPOST / GET/api/categoriesManage asset categoriesPOST / GET/api/locationsManage office locations3. Assets Management (/api/assets)MethodEndpointDescriptionAccessPOST/api/assetsCreate a new asset recordAdmin OnlyGET/api/assetsRetrieve all registered assetsAuthenticated UsersPUT/api/assets/:idUpdate an existing assetAdmin OnlyDELETE/api/assets/:idDelete an asset recordAdmin Only🛑 Stopping the ApplicationTo safely stop and tear down the Docker containers, run:

docker-compose down

📝 Next Steps (In Progress)
👥 Employee Management Module

📋 Asset Request & Approval Workflow

🔄 Asset Assignment & Return Module

👩‍💻 Maira Alam


❤️ Built with Node.js, Express, PostgreSQL & Docker
⭐ If you found this project helpful, consider giving it a Star!
















