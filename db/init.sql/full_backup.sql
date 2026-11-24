--
-- PostgreSQL database dump
--

\restrict aZEgtG9y7V89j0KcQD25n0H4jfpaFajEl2e6yOifZ5iHLNgnrMiOfzOcp0Y8x7G

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
    user_id uuid,
    manager_id uuid,
    cnic character varying(20),
    joining_date date,
    designation character varying(100),
    address text,
    emergency_contact character varying(50)
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
0c192a7b-a9d2-4f24-98f4-2142f37dc69d	Electronics	\N
7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	Laptop	0c192a7b-a9d2-4f24-98f4-2142f37dc69d
9dd034db-7a51-4be0-89ff-3c03631e5aa5	Monitors	0c192a7b-a9d2-4f24-98f4-2142f37dc69d
ee593654-5605-4e00-8439-3a63ba96e1cd	Furniture	\N
28197bec-2c7a-4da9-b2dd-0b25b4a0a48a	Chairs	ee593654-5605-4e00-8439-3a63ba96e1cd
4aea922b-7d09-4c70-9c37-e5aa26a0a052	Desks	ee593654-5605-4e00-8439-3a63ba96e1cd
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
02fe7704-bcde-4cee-a9a0-278283e830c9	DELL-LAP-100	SN-DELL-100	Available	2023-11-20	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	5b306a1a-e685-48ac-ad04-bb37c6e7439b	558a80e7-439b-4af1-941b-40623e8a4b0f	9558de8d-9fe3-4ae0-94dc-4f67230d9313
baa35eda-2792-4001-af30-be194e993f77	CHAIR-OFF-200	SN-CHAIR-200	Available	2023-11-21	28197bec-2c7a-4da9-b2dd-0b25b4a0a48a	32522431-8976-4268-827c-cc9620bb79c0	29f3fdcc-234e-4bc5-96b3-b606e9a31016	821d3afb-4f9a-4a02-9653-c06931f1a17a
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
821d3afb-4f9a-4a02-9653-c06931f1a17a	HR Department	\N
9558de8d-9fe3-4ae0-94dc-4f67230d9313	IT Department	\N
8fdf2208-eae9-4e3f-a22c-f5b31a674d30	Finance Department	\N
6ce87f70-9b52-4396-970b-d9b8df0dff4a	Sales & Marketing	\N
7bd190aa-4285-48b7-9fd2-2ac8d62a9f4a	Operations	\N
242605b2-f6cc-40b2-adee-a3ab43a1dfd2	Procurement	\N
\.


--
-- Data for Name: depreciation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.depreciation (depreciation_id, rate, value, asset_id) FROM stdin;
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (employee_id, name, contact, department_id, user_id, manager_id, cnic, joining_date, designation, address, emergency_contact) FROM stdin;
b2951293-e0ae-450e-946a-342920ccbd75	Ali Khan	03001234567	9558de8d-9fe3-4ae0-94dc-4f67230d9313	1862aae3-1923-46e2-90ac-20e87099c7d4	\N	42101-1234567-8	2023-10-25	Software Engineer	\N	\N
236cb13c-fba8-4e36-ad6b-1f2720bcb701	Usman Ahmed	03001112223	821d3afb-4f9a-4a02-9653-c06931f1a17a	96ced9d1-dd3d-41c3-a67d-266ed3296ab0	\N	42101-9876543-1	2024-01-15	HR Executive	\N	\N
335a9244-9c59-436f-8d78-a20a84f048d7	Kamran Akmal	03009998887	9558de8d-9fe3-4ae0-94dc-4f67230d9313	86e02bda-ba99-4d9d-b520-ebe295b84534	\N	42101-1111111-1	2022-05-10	IT Manager	House 10, Street 5, Karachi	03110002223
74d94104-faf6-482a-a1bd-03be8ca34cbb	Test Employee	03001234567	9558de8d-9fe3-4ae0-94dc-4f67230d9313	dbe2d143-21e5-4e3a-9541-b9d787f4d296	\N	42101-9999999-9	2024-01-15	Software Engineer	House 123, Karachi	03119876543
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
4ee4ea5b-2c5e-4341-9800-d9dc63dc8099	Main HQ	2nd Floor	Room 201
558a80e7-439b-4af1-941b-40623e8a4b0f	Head Office	1st Floor	Room 101
d05734ab-0623-4dc3-9764-70ef592292a2	Head Office	2nd Floor	Room 205
29f3fdcc-234e-4bc5-96b3-b606e9a31016	Branch Office	Ground Floor	Reception
8c2d878e-1ad9-4da2-9562-b61319c2306c	Warehouse	Ground Floor	Storage Area A
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
e5d4abd2-489f-4cff-89eb-24ba4fe4b47e	CREATE_ASSET
04f707c4-d209-415a-84b9-e5cf8b398a2e	READ_ASSET
f0bef885-c587-4fa9-9514-dc9f41f5a55b	UPDATE_ASSET
1d173860-c86b-4790-8f7b-ea07b17014f7	DELETE_ASSET
4a22171a-76d9-484c-9296-05758fc642a8	APPROVE_REQUEST
c8fa29c5-e05a-439b-8b25-629d7ac90870	ASSIGN_ASSET
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
2a22e2b7-5293-493d-9f44-901f64c35ae4	e5d4abd2-489f-4cff-89eb-24ba4fe4b47e
2a22e2b7-5293-493d-9f44-901f64c35ae4	04f707c4-d209-415a-84b9-e5cf8b398a2e
2a22e2b7-5293-493d-9f44-901f64c35ae4	f0bef885-c587-4fa9-9514-dc9f41f5a55b
2a22e2b7-5293-493d-9f44-901f64c35ae4	1d173860-c86b-4790-8f7b-ea07b17014f7
2a22e2b7-5293-493d-9f44-901f64c35ae4	4a22171a-76d9-484c-9296-05758fc642a8
2a22e2b7-5293-493d-9f44-901f64c35ae4	c8fa29c5-e05a-439b-8b25-629d7ac90870
fbd0f03e-e55d-47d6-a08e-d9979db04da9	04f707c4-d209-415a-84b9-e5cf8b398a2e
fbd0f03e-e55d-47d6-a08e-d9979db04da9	4a22171a-76d9-484c-9296-05758fc642a8
fbd0f03e-e55d-47d6-a08e-d9979db04da9	c8fa29c5-e05a-439b-8b25-629d7ac90870
be2bb751-0b5e-4572-8df4-9438b880d473	04f707c4-d209-415a-84b9-e5cf8b398a2e
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, role_name) FROM stdin;
2a22e2b7-5293-493d-9f44-901f64c35ae4	Admin
fbd0f03e-e55d-47d6-a08e-d9979db04da9	Manager
be2bb751-0b5e-4572-8df4-9438b880d473	Employee
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
40c6c9df-1371-4042-b939-82cb6188317b	2a22e2b7-5293-493d-9f44-901f64c35ae4
a403d84c-1b62-44af-bd67-af1686fe105c	fbd0f03e-e55d-47d6-a08e-d9979db04da9
652a9760-2371-4044-bdd0-60f5afff0fcd	fbd0f03e-e55d-47d6-a08e-d9979db04da9
1862aae3-1923-46e2-90ac-20e87099c7d4	fbd0f03e-e55d-47d6-a08e-d9979db04da9
96ced9d1-dd3d-41c3-a67d-266ed3296ab0	be2bb751-0b5e-4572-8df4-9438b880d473
86e02bda-ba99-4d9d-b520-ebe295b84534	fbd0f03e-e55d-47d6-a08e-d9979db04da9
dbe2d143-21e5-4e3a-9541-b9d787f4d296	be2bb751-0b5e-4572-8df4-9438b880d473
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, email, password_hash, status, created_at) FROM stdin;
40c6c9df-1371-4042-b939-82cb6188317b	maira@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	\N	2026-11-16 11:44:01.052581
d470cfb6-9d07-4b33-8f34-9cef556dc6ef	aly@test.com	$2a$10$Xw4x4sbl14y6L19/IPtffe8jTY6oKNcc1r9Iug0IM9d98c8nNocYG	\N	2026-11-16 11:47:37.048242
a403d84c-1b62-44af-bd67-af1686fe105c	ali@techavenue.com	$2a$10$XeGPXmWst3tUbgJ78YnRoeDtEtxvxKYMuy0sdv.yASEq1olMccwn6	\N	2026-11-22 22:44:25.056505
652a9760-2371-4044-bdd0-60f5afff0fcd	alikhan@techavenue.com	$2a$10$nJCreo1V.Obgrx9kCzl/6u8kFwGcH98w3Pfz0FTzu2MESQQb9cqeW	\N	2026-11-22 22:48:15.109637
1862aae3-1923-46e2-90ac-20e87099c7d4	ali.khan.manager@techavenue.com	$2a$10$bDHvEdHXfytRH7UdzdPzmO.o9N8WSa9/41aWPW2Jmg/TDvJEzIqxi	\N	2026-11-22 22:50:24.513746
96ced9d1-dd3d-41c3-a67d-266ed3296ab0	usman.hr@techavenue.com	$2a$10$bsPRQERDR2pO0RPddYzEpuD80UaOST4pPtEHyRHTTzJg66yTf.f/i	\N	2026-11-22 23:18:36.952011
86e02bda-ba99-4d9d-b520-ebe295b84534	kamran.manager@techavenue.com	$2a$10$Ez6dvkT1ssu/x4AXr/SIN.Nu3tm9i2dd5EsD5LlxrEOpdDOYuumEi	\N	2026-11-22 23:21:46.892239
dbe2d143-21e5-4e3a-9541-b9d787f4d296	test.employee@techavenue.com	$2a$10$y2U2oRheZ/j9qkCKq7P/l.u15.1owiELHMDYyzIfqq23O7acGKLuq	Suspended	2026-11-23 17:25:59.569139
\.


--
-- Data for Name: vendors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendors (vendor_id, vendor_name, email, phone) FROM stdin;
1002d7c3-fafc-41b0-a31d-8dbb98229f15	Tech Solutions Ltd	contact@techsolutions.com	03001234567
5b306a1a-e685-48ac-ad04-bb37c6e7439b	Dell Technologies	sales@dell.com	111-222-333
12e4d76e-1fbe-40d9-aad5-4c2d0b3a6101	HP Inc	support@hp.com	444-555-666
9051e828-8bb0-4276-8a9e-a19ae42e5e6e	Apple Store	business@apple.com	777-888-999
32522431-8976-4268-827c-cc9620bb79c0	Local Furniture Mart	info@furnituremart.com	000-111-222
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
-- Name: employees employees_cnic_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_cnic_key UNIQUE (cnic);


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
-- Name: asset_categories unique_category_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_categories
    ADD CONSTRAINT unique_category_name UNIQUE (category_name);


--
-- Name: departments unique_department_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT unique_department_name UNIQUE (department_name);


--
-- Name: vendors unique_vendor_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT unique_vendor_name UNIQUE (vendor_name);


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
-- Name: employees employees_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(employee_id);


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

\unrestrict aZEgtG9y7V89j0KcQD25n0H4jfpaFajEl2e6yOifZ5iHLNgnrMiOfzOcp0Y8x7G

