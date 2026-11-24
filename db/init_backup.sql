--
-- PostgreSQL database dump
--

\restrict QQXUiEhCf6PbcnoRyOsBNTbatzpPtFpngZndyfGu24AaPtR1VqPXledjOjtM6sk

-- Dumped from database version 15.19
-- Dumped by pg_dump version 15.19

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: asset_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_assignments (
    assignment_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    assigned_on date,
    returned_on date,
    asset_id uuid,
    employee_id uuid
);


ALTER TABLE public.asset_assignments OWNER TO postgres;

--
-- Name: asset_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_categories (
    category_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    category_name character varying(100) NOT NULL,
    parent_id uuid
);


ALTER TABLE public.asset_categories OWNER TO postgres;

--
-- Name: asset_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_documents (
    doc_no character varying(100) NOT NULL,
    doc_type character varying(50),
    file_url character varying(255),
    asset_id uuid NOT NULL
);


ALTER TABLE public.asset_documents OWNER TO postgres;

--
-- Name: asset_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_requests (
    request_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    request_date date,
    status character varying(50),
    employee_id uuid,
    category_id uuid
);


ALTER TABLE public.asset_requests OWNER TO postgres;

--
-- Name: asset_returns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_returns (
    return_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    return_date date,
    condition character varying(100),
    assignment_id uuid
);


ALTER TABLE public.asset_returns OWNER TO postgres;

--
-- Name: asset_transfers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_transfers (
    transfer_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    transfer_date date,
    reason character varying(255),
    assignment_id uuid
);


ALTER TABLE public.asset_transfers OWNER TO postgres;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    asset_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    asset_tag character varying(100),
    serial_number character varying(100),
    status character varying(50),
    purchase_date date,
    category_id uuid,
    vendor_id uuid,
    location_id uuid,
    dept_id uuid
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: audits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audits (
    audit_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    audit_date date,
    findings text,
    asset_id uuid
);


ALTER TABLE public.audits OWNER TO postgres;

--
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    department_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    department_name character varying(100) NOT NULL,
    location_id uuid
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- Name: depreciation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.depreciation (
    depreciation_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    rate numeric(5,2),
    value numeric(10,2),
    asset_id uuid
);


ALTER TABLE public.depreciation OWNER TO postgres;

--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employee_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    contact character varying(50),
    department_id uuid,
    user_id uuid
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: financial_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.financial_records (
    financial_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    amount numeric(10,2),
    transaction_type character varying(50),
    asset_id uuid
);


ALTER TABLE public.financial_records OWNER TO postgres;

--
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    location_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    building character varying(100),
    floor character varying(50),
    room character varying(50)
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- Name: maintenance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maintenance (
    maintenance_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    maintenance_date date,
    cost numeric(10,2),
    asset_id uuid
);


ALTER TABLE public.maintenance OWNER TO postgres;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    permission_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    permission_name character varying(100) NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: request_approvals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.request_approvals (
    approval_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    approval_status character varying(50),
    approved_on date,
    request_id uuid,
    approved_by uuid
);


ALTER TABLE public.request_approvals OWNER TO postgres;

--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role_name character varying(100) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: status_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_history (
    history_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    old_status character varying(50),
    new_status character varying(50),
    changed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    asset_id uuid
);


ALTER TABLE public.status_history OWNER TO postgres;

--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscriptions (
    subscription_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    license_key character varying(255),
    expiry_date date,
    asset_id uuid
);


ALTER TABLE public.subscriptions OWNER TO postgres;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    user_id uuid NOT NULL,
    role_id uuid NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    status character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: vendors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendors (
    vendor_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    vendor_name character varying(100) NOT NULL,
    email character varying(255),
    phone character varying(50)
);


ALTER TABLE public.vendors OWNER TO postgres;

--
-- Name: warranties; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.warranties (
    warranty_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    start_date date,
    end_date date,
    asset_id uuid
);


ALTER TABLE public.warranties OWNER TO postgres;

--
-- Data for Name: asset_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_assignments (assignment_id, assigned_on, returned_on, asset_id, employee_id) FROM stdin;
\.


--
-- Data for Name: asset_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_categories (category_id, category_name, parent_id) FROM stdin;
\.


--
-- Data for Name: asset_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_documents (doc_no, doc_type, file_url, asset_id) FROM stdin;
\.


--
-- Data for Name: asset_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_requests (request_id, request_date, status, employee_id, category_id) FROM stdin;
\.


--
-- Data for Name: asset_returns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_returns (return_id, return_date, condition, assignment_id) FROM stdin;
\.


--
-- Data for Name: asset_transfers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_transfers (transfer_id, transfer_date, reason, assignment_id) FROM stdin;
\.


--
-- Data for Name: assets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assets (asset_id, asset_tag, serial_number, status, purchase_date, category_id, vendor_id, location_id, dept_id) FROM stdin;
\.


--
-- Data for Name: audits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audits (audit_id, audit_date, findings, asset_id) FROM stdin;
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (department_id, department_name, location_id) FROM stdin;
\.


--
-- Data for Name: depreciation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.depreciation (depreciation_id, rate, value, asset_id) FROM stdin;
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (employee_id, name, contact, department_id, user_id) FROM stdin;
\.


--
-- Data for Name: financial_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.financial_records (financial_id, amount, transaction_type, asset_id) FROM stdin;
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (location_id, building, floor, room) FROM stdin;
\.


--
-- Data for Name: maintenance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maintenance (maintenance_id, maintenance_date, cost, asset_id) FROM stdin;
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (permission_id, permission_name) FROM stdin;
\.


--
-- Data for Name: request_approvals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.request_approvals (approval_id, approval_status, approved_on, request_id, approved_by) FROM stdin;
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (role_id, permission_id) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, role_name) FROM stdin;
\.


--
-- Data for Name: status_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status_history (history_id, old_status, new_status, changed_at, asset_id) FROM stdin;
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscriptions (subscription_id, license_key, expiry_date, asset_id) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (user_id, role_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, email, password_hash, status, created_at) FROM stdin;
5c24fdda-d664-4402-ae68-7378efaced8d	maira@test.com	$2a$10$RroKlLwe6bw2Ai4ezTKoJOeZWPnatkZfV4Rt.zItnmXqpwtbTZiT6	\N	2026-11-16 18:27:30.4285
4e5b8e0a-c327-42af-8d65-6f35e21920a3	mairas@t.com	$2a$10$Lgru3Gc4NdWIhOXIab2vRuRKKtOezSaCVZ5drv6LmddIclzb5P2oW	\N	2026-11-16 18:40:32.12337
795fbe90-fe02-4b20-9a14-f46c00cc70b7	maira@techavenue.com	$2a$10$3ChwVUsn6P64zFLWLl2YDuujieUDLRGoQ0RG8/azeiZPS02l5hbum	\N	2026-11-16 19:10:12.070498
\.


--
-- Data for Name: vendors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendors (vendor_id, vendor_name, email, phone) FROM stdin;
\.


--
-- Data for Name: warranties; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.warranties (warranty_id, start_date, end_date, asset_id) FROM stdin;
\.


--
-- Name: asset_assignments asset_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_assignments
    ADD CONSTRAINT asset_assignments_pkey PRIMARY KEY (assignment_id);


--
-- Name: asset_categories asset_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_categories
    ADD CONSTRAINT asset_categories_pkey PRIMARY KEY (category_id);


--
-- Name: asset_documents asset_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_documents
    ADD CONSTRAINT asset_documents_pkey PRIMARY KEY (doc_no, asset_id);


--
-- Name: asset_requests asset_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_pkey PRIMARY KEY (request_id);


--
-- Name: asset_returns asset_returns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_returns
    ADD CONSTRAINT asset_returns_pkey PRIMARY KEY (return_id);


--
-- Name: asset_transfers asset_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfers
    ADD CONSTRAINT asset_transfers_pkey PRIMARY KEY (transfer_id);


--
-- Name: assets assets_asset_tag_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_asset_tag_key UNIQUE (asset_tag);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (asset_id);


--
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (audit_id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- Name: depreciation depreciation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depreciation
    ADD CONSTRAINT depreciation_pkey PRIMARY KEY (depreciation_id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- Name: financial_records financial_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financial_records
    ADD CONSTRAINT financial_records_pkey PRIMARY KEY (financial_id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (location_id);


--
-- Name: maintenance maintenance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance
    ADD CONSTRAINT maintenance_pkey PRIMARY KEY (maintenance_id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (permission_id);


--
-- Name: request_approvals request_approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_approvals
    ADD CONSTRAINT request_approvals_pkey PRIMARY KEY (approval_id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: status_history status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_history
    ADD CONSTRAINT status_history_pkey PRIMARY KEY (history_id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (subscription_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (vendor_id);


--
-- Name: warranties warranties_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warranties
    ADD CONSTRAINT warranties_pkey PRIMARY KEY (warranty_id);


--
-- Name: asset_assignments asset_assignments_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_assignments
    ADD CONSTRAINT asset_assignments_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id);


--
-- Name: asset_assignments asset_assignments_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_assignments
    ADD CONSTRAINT asset_assignments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- Name: asset_categories asset_categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_categories
    ADD CONSTRAINT asset_categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.asset_categories(category_id);


--
-- Name: asset_documents asset_documents_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_documents
    ADD CONSTRAINT asset_documents_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- Name: asset_requests asset_requests_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.asset_categories(category_id);


--
-- Name: asset_requests asset_requests_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- Name: asset_returns asset_returns_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_returns
    ADD CONSTRAINT asset_returns_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.asset_assignments(assignment_id);


--
-- Name: asset_transfers asset_transfers_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfers
    ADD CONSTRAINT asset_transfers_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.asset_assignments(assignment_id);


--
-- Name: assets assets_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.asset_categories(category_id);


--
-- Name: assets assets_dept_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_dept_id_fkey FOREIGN KEY (dept_id) REFERENCES public.departments(department_id);


--
-- Name: assets assets_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(location_id);


--
-- Name: assets assets_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(vendor_id);


--
-- Name: audits audits_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- Name: departments departments_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(location_id);


--
-- Name: depreciation depreciation_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depreciation
    ADD CONSTRAINT depreciation_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- Name: employees employees_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(department_id);


--
-- Name: employees employees_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: financial_records financial_records_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financial_records
    ADD CONSTRAINT financial_records_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- Name: maintenance maintenance_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance
    ADD CONSTRAINT maintenance_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- Name: request_approvals request_approvals_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_approvals
    ADD CONSTRAINT request_approvals_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(user_id);


--
-- Name: request_approvals request_approvals_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_approvals
    ADD CONSTRAINT request_approvals_request_id_fkey FOREIGN KEY (request_id) REFERENCES public.asset_requests(request_id);


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(permission_id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- Name: status_history status_history_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_history
    ADD CONSTRAINT status_history_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- Name: subscriptions subscriptions_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: warranties warranties_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warranties
    ADD CONSTRAINT warranties_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict QQXUiEhCf6PbcnoRyOsBNTbatzpPtFpngZndyfGu24AaPtR1VqPXledjOjtM6sk

