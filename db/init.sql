-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Access Management Tables
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE roles (
    role_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    role_name VARCHAR(100) NOT NULL
);

CREATE TABLE permissions (
    permission_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    permission_name VARCHAR(100) NOT NULL
);

-- 2. Organization Tables
CREATE TABLE locations (
    location_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    building VARCHAR(100),
    floor VARCHAR(50),
    room VARCHAR(50)
);

CREATE TABLE departments (
    department_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    department_name VARCHAR(100) NOT NULL,
    location_id UUID REFERENCES locations(location_id)
);

CREATE TABLE employees (
    employee_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    contact VARCHAR(50),
    department_id UUID REFERENCES departments(department_id),
    user_id UUID REFERENCES users(user_id)
);

CREATE TABLE vendors (
    vendor_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vendor_name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50)
);

-- 3. Core Assets
CREATE TABLE asset_categories (
    category_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_name VARCHAR(100) NOT NULL,
    parent_id UUID REFERENCES asset_categories(category_id)
);

CREATE TABLE assets (
    asset_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    asset_tag VARCHAR(100) UNIQUE,
    serial_number VARCHAR(100),
    status VARCHAR(50),
    purchase_date DATE,
    category_id UUID REFERENCES asset_categories(category_id),
    vendor_id UUID REFERENCES vendors(vendor_id),
    location_id UUID REFERENCES locations(location_id),
    dept_id UUID REFERENCES departments(department_id)
);

CREATE TABLE asset_documents (
    doc_no VARCHAR(100),
    doc_type VARCHAR(50),
    file_url VARCHAR(255),
    asset_id UUID REFERENCES assets(asset_id) ON DELETE CASCADE,
    PRIMARY KEY (doc_no, asset_id) -- Weak entity PK
);

-- 4. Requests & Assignments
CREATE TABLE asset_requests (
    request_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_date DATE,
    status VARCHAR(50),
    employee_id UUID REFERENCES employees(employee_id),
    category_id UUID REFERENCES asset_categories(category_id)
);

CREATE TABLE request_approvals (
    approval_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    approval_status VARCHAR(50),
    approved_on DATE,
    request_id UUID REFERENCES asset_requests(request_id),
    approved_by UUID REFERENCES users(user_id)
);

CREATE TABLE asset_assignments (
    assignment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    assigned_on DATE,
    returned_on DATE,
    asset_id UUID REFERENCES assets(asset_id),
    employee_id UUID REFERENCES employees(employee_id)
);

CREATE TABLE asset_transfers (
    transfer_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transfer_date DATE,
    reason VARCHAR(255),
    assignment_id UUID REFERENCES asset_assignments(assignment_id)
);

CREATE TABLE asset_returns (
    return_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    return_date DATE,
    condition VARCHAR(100),
    assignment_id UUID REFERENCES asset_assignments(assignment_id)
);

-- 5. Lifecycle Tracking
CREATE TABLE warranties (
    warranty_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    start_date DATE,
    end_date DATE,
    asset_id UUID REFERENCES assets(asset_id) ON DELETE CASCADE
);

CREATE TABLE maintenance (
    maintenance_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    maintenance_date DATE,
    cost DECIMAL(10, 2),
    asset_id UUID REFERENCES assets(asset_id) ON DELETE CASCADE
);

CREATE TABLE depreciation (
    depreciation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rate DECIMAL(5, 2),
    value DECIMAL(10, 2),
    asset_id UUID REFERENCES assets(asset_id) ON DELETE CASCADE
);

CREATE TABLE audits (
    audit_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    audit_date DATE,
    findings TEXT,
    asset_id UUID REFERENCES assets(asset_id) ON DELETE CASCADE
);

CREATE TABLE status_history (
    history_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    asset_id UUID REFERENCES assets(asset_id) ON DELETE CASCADE
);

CREATE TABLE financial_records (
    financial_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    amount DECIMAL(10, 2),
    transaction_type VARCHAR(50),
    asset_id UUID REFERENCES assets(asset_id) ON DELETE CASCADE
);

CREATE TABLE subscriptions (
    subscription_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    license_key VARCHAR(255),
    expiry_date DATE,
    asset_id UUID REFERENCES assets(asset_id) ON DELETE CASCADE
);

-- M:N Tables (UserRoles & RolePermissions - from your Basic ERD)
CREATE TABLE user_roles (
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    role_id UUID REFERENCES roles(role_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

CREATE TABLE role_permissions (
    role_id UUID REFERENCES roles(role_id) ON DELETE CASCADE,
    permission_id UUID REFERENCES permissions(permission_id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);