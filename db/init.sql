--
-- PostgreSQL database dump
--

\restrict FtVBXknGiwyjgW6IYcgSczZqCqrUs7e081APegLSwY3jbVY146QUC6NAHimnftp

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-11-28 17:43:05

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
-- TOC entry 2 (class 3079 OID 16385)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 232 (class 1259 OID 16560)
-- Name: asset_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_assignments (
    assignment_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    assigned_on date,
    returned_on date,
    asset_id uuid,
    employee_id uuid,
    assigned_by uuid
);


ALTER TABLE public.asset_assignments OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16472)
-- Name: asset_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_categories (
    category_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    category_name character varying(100) NOT NULL,
    parent_id uuid
);


ALTER TABLE public.asset_categories OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16514)
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
-- TOC entry 230 (class 1259 OID 16526)
-- Name: asset_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_requests (
    request_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    request_date date,
    status character varying(50),
    employee_id uuid,
    category_id uuid,
    reason text,
    manager_comment text
);


ALTER TABLE public.asset_requests OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16589)
-- Name: asset_returns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_returns (
    return_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    return_date date,
    condition character varying(100),
    assignment_id uuid,
    status character varying(50) DEFAULT 'Pending'::character varying,
    manager_comment text,
    employee_id uuid,
    asset_id uuid,
    reason text,
    manager_action character varying(50)
);


ALTER TABLE public.asset_returns OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16577)
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
-- TOC entry 228 (class 1259 OID 16485)
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
-- TOC entry 238 (class 1259 OID 16637)
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
-- TOC entry 224 (class 1259 OID 16433)
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    department_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    department_name character varying(100) NOT NULL,
    location_id uuid
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16625)
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
-- TOC entry 225 (class 1259 OID 16446)
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
-- TOC entry 240 (class 1259 OID 16664)
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
-- TOC entry 223 (class 1259 OID 16426)
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
-- TOC entry 236 (class 1259 OID 16613)
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
-- TOC entry 222 (class 1259 OID 16418)
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    permission_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    permission_name character varying(100) NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16543)
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
-- TOC entry 243 (class 1259 OID 16705)
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16410)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role_name character varying(100) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16651)
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
-- TOC entry 241 (class 1259 OID 16676)
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
-- TOC entry 245 (class 1259 OID 24928)
-- Name: system_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_settings (
    id integer NOT NULL,
    primary_color character varying(20) DEFAULT '#1F3049'::character varying,
    accent_color character varying(20) DEFAULT '#C9A15B'::character varying,
    bg_color character varying(20) DEFAULT '#F4F5F7'::character varying,
    logo_url text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.system_settings OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 24927)
-- Name: system_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.system_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_settings_id_seq OWNER TO postgres;

--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 244
-- Name: system_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.system_settings_id_seq OWNED BY public.system_settings.id;


--
-- TOC entry 242 (class 1259 OID 16688)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    user_id uuid NOT NULL,
    role_id uuid NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16396)
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
-- TOC entry 226 (class 1259 OID 16464)
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
-- TOC entry 235 (class 1259 OID 16601)
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
-- TOC entry 4886 (class 2604 OID 24931)
-- Name: system_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings ALTER COLUMN id SET DEFAULT nextval('public.system_settings_id_seq'::regclass);


--
-- TOC entry 5144 (class 0 OID 16560)
-- Dependencies: 232
-- Data for Name: asset_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_assignments (assignment_id, assigned_on, returned_on, asset_id, employee_id, assigned_by) FROM stdin;
e8ad3baf-142e-4904-8dc6-7d7d2d3236f6	2026-11-25	\N	e8d76052-d716-46d2-8778-3def8fcd35e5	70707070-7070-7070-7070-707070707070	60606060-6060-6060-6060-606060606060
a3eeb1d6-1bbb-425c-82d0-0ff30713d939	2026-11-25	\N	897d966a-2e15-46b3-a818-3f737e22417e	99999999-9999-9999-9999-999999999999	99999999-9999-9999-9999-999999999999
b750bbfb-eada-420f-85ef-1706254152cd	2026-11-25	\N	5fc68272-5fdf-470a-aea9-c684af1bb52e	30303030-3030-3030-3030-303030303030	c37b566a-6d84-4a83-9936-0bb669551422
4743e436-d31b-476e-8e03-894ebd73732f	2026-11-25	\N	5fc68272-5fdf-470a-aea9-c684af1bb52e	30303030-3030-3030-3030-303030303030	c37b566a-6d84-4a83-9936-0bb669551422
b4104900-bb57-43d3-a544-b02104e226ac	2026-11-26	\N	77ad4d15-a6c0-433f-9c01-4503da996fe0	66666666-6666-6666-6666-666666666666	44444444-4444-4444-4444-444444444444
fc427683-2e46-4245-b5bf-af0e6fcaf0a9	2026-11-26	\N	b1d7a724-62ec-4c23-a6b4-47a58d047a90	77777777-7777-7777-7777-777777777777	77777777-7777-7777-7777-777777777777
2612552e-eee0-4fc8-9b1e-ca8c84a45cf3	2026-11-27	\N	d05514f8-fff0-455a-a49a-e14f7287f276	10101010-1010-1010-1010-101010101010	99999999-9999-9999-9999-999999999999
a388a47f-3334-4df9-abc4-8982f6e9aaf9	2026-11-27	\N	d765015b-01a1-4e9c-a823-154551c61129	20202020-2020-2020-2020-202020202020	99999999-9999-9999-9999-999999999999
056498af-85c8-42fa-b93a-3b0497c226bc	2026-11-27	\N	d35c2484-aa5f-4d33-aa33-aafc02c807af	10101010-1010-1010-1010-101010101010	99999999-9999-9999-9999-999999999999
\.


--
-- TOC entry 5139 (class 0 OID 16472)
-- Dependencies: 227
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
-- TOC entry 5141 (class 0 OID 16514)
-- Dependencies: 229
-- Data for Name: asset_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_documents (doc_no, doc_type, file_url, asset_id) FROM stdin;
\.


--
-- TOC entry 5142 (class 0 OID 16526)
-- Dependencies: 230
-- Data for Name: asset_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_requests (request_id, request_date, status, employee_id, category_id, reason, manager_comment) FROM stdin;
4b0bf199-bbba-459c-b19b-65737ad235c1	2026-11-26	Approved	50505050-5050-5050-5050-505050505050	28197bec-2c7a-4da9-b2dd-0b25b4a0a48a	EXISTING CHAIR IS BROKER	\N
3bfc4194-0b67-4a18-a10f-a0a6d01b057b	2026-11-26	Rejected	66666666-6666-6666-6666-666666666666	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	Replacemnet of previous one	\N
5aec58ff-4026-462e-bfbc-f2aed4e9ddad	2026-11-26	Rejected	10101010-1010-1010-1010-101010101010	9dd034db-7a51-4be0-89ff-3c03631e5aa5	replacement	\N
61b30565-0954-4b42-99f2-686f6d8cac16	2026-11-26	Approved	10101010-1010-1010-1010-101010101010	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	remplacement	\N
1d2136d3-9314-4aea-969e-c5a341dc5dfa	2026-11-26	Rejected	4c9201fa-d729-4fce-953a-aecede829e3f	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	New joinee	N/A\n
62a6a7e9-24e8-4ebd-8e3e-b1d7970d3809	2026-11-26	Approved	4c9201fa-d729-4fce-953a-aecede829e3f	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	new joinee	Request Approved
664d5c36-76c5-41f9-bbd8-d4b2fece7cb9	2026-11-26	Approved	10101010-1010-1010-1010-101010101010	28197bec-2c7a-4da9-b2dd-0b25b4a0a48a	n/a	Request Approved
8c3a2b75-878d-46dc-8656-907106585ef3	2026-11-27	Rejected	10101010-1010-1010-1010-101010101010	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	new joinee	n/a
2cbcb974-1393-4b04-bfad-53f5818c8e59	2026-11-27	Approved	10101010-1010-1010-1010-101010101010	28197bec-2c7a-4da9-b2dd-0b25b4a0a48a	replacement of old chair	Request Approved
eac35bd3-637e-4f74-a7a8-01bcf7573e1e	2026-11-27	Approved	10101010-1010-1010-1010-101010101010	28197bec-2c7a-4da9-b2dd-0b25b4a0a48a	broken chair	Request Approved
73fc8319-662c-485b-a506-b2dd2eee9d28	2026-11-27	Approved	10101010-1010-1010-1010-101010101010	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	n/a	Request Approved
\.


--
-- TOC entry 5146 (class 0 OID 16589)
-- Dependencies: 234
-- Data for Name: asset_returns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_returns (return_id, return_date, condition, assignment_id, status, manager_comment, employee_id, asset_id, reason, manager_action) FROM stdin;
d1c6486f-07d1-4233-a492-1703206d13f2	2026-11-26	Needs Repair	\N	Approved	Return accepted. Asset returned to inventory.	10101010-1010-1010-1010-101010101010	897d966a-2e15-46b3-a818-3f737e22417e	n/a	\N
e80ccbf4-386a-42c2-9db6-0c69769f420c	2026-11-26	Needs Repair	\N	Approved	\N	50505050-5050-5050-5050-505050505050	6f10aab7-9cc9-4849-8aba-1457fed33057	n/a\n	Retired
42d027b9-3bdd-4bde-96a4-3e494ee8d075	2026-11-27	Good	\N	Rejected	Return rejected by manager	10101010-1010-1010-1010-101010101010	d765015b-01a1-4e9c-a823-154551c61129	n/a	\N
c71621ca-f684-468c-8359-ef5e795ce5db	2026-11-27	Damaged	\N	Approved	\N	10101010-1010-1010-1010-101010101010	d765015b-01a1-4e9c-a823-154551c61129	need a new one	Available
0b746bbc-888b-4aa7-ab0c-e9049ffc2452	2026-11-27	Good	\N	Approved	\N	10101010-1010-1010-1010-101010101010	897d966a-2e15-46b3-a818-3f737e22417e	n/a	Retired
82ce9b5c-989c-43f9-badc-4eac421f3868	2026-11-27	Good	\N	Approved	\N	10101010-1010-1010-1010-101010101010	d35c2484-aa5f-4d33-aa33-aafc02c807af	n/a	Available
\.


--
-- TOC entry 5145 (class 0 OID 16577)
-- Dependencies: 233
-- Data for Name: asset_transfers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_transfers (transfer_id, transfer_date, reason, assignment_id) FROM stdin;
\.


--
-- TOC entry 5140 (class 0 OID 16485)
-- Dependencies: 228
-- Data for Name: assets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assets (asset_id, asset_tag, serial_number, status, purchase_date, category_id, vendor_id, location_id, dept_id) FROM stdin;
897d966a-2e15-46b3-a818-3f737e22417e	CHAIR-EXEC-101	SN-CHR-101	Retired	2023-08-01	28197bec-2c7a-4da9-b2dd-0b25b4a0a48a	32522431-8976-4268-827c-cc9620bb79c0	4ee4ea5b-2c5e-4341-9800-d9dc63dc8099	6ce87f70-9b52-4396-970b-d9b8df0dff4a
e1c15fa4-2c2e-4e5b-991f-efc3326155e5	MON-DELL-101	SN-MON-101	Available	2023-10-20	9dd034db-7a51-4be0-89ff-3c03631e5aa5	5b306a1a-e685-48ac-ad04-bb37c6e7439b	558a80e7-439b-4af1-941b-40623e8a4b0f	9558de8d-9fe3-4ae0-94dc-4f67230d9313
b8ba237b-a30d-45ba-ba14-8ddba09b12c6	PROJ-EPSON-101	SN-PRJ-101	Available	2023-10-10	0c192a7b-a9d2-4f24-98f4-2142f37dc69d	1002d7c3-fafc-41b0-a31d-8dbb98229f15	4ee4ea5b-2c5e-4341-9800-d9dc63dc8099	821d3afb-4f9a-4a02-9653-c06931f1a17a
02fe7704-bcde-4cee-a9a0-278283e830c9	DELL-LAP-100	SN-DELL-100	Assigned	2023-11-20	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	5b306a1a-e685-48ac-ad04-bb37c6e7439b	558a80e7-439b-4af1-941b-40623e8a4b0f	9558de8d-9fe3-4ae0-94dc-4f67230d9313
baa35eda-2792-4001-af30-be194e993f77	CHAIR-OFF-200	SN-CHAIR-200	Available	2023-11-21	28197bec-2c7a-4da9-b2dd-0b25b4a0a48a	32522431-8976-4268-827c-cc9620bb79c0	29f3fdcc-234e-4bc5-96b3-b606e9a31016	821d3afb-4f9a-4a02-9653-c06931f1a17a
d35c2484-aa5f-4d33-aa33-aafc02c807af	SALES-LAP-002	SN-SLS-442	Assigned	2022-10-05	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	5b306a1a-e685-48ac-ad04-bb37c6e7439b	29f3fdcc-234e-4bc5-96b3-b606e9a31016	6ce87f70-9b52-4396-970b-d9b8df0dff4a
5fc68272-5fdf-470a-aea9-c684af1bb52e	CHAIR-STAFF-101	SN-CHR-102	Assigned	2023-08-15	28197bec-2c7a-4da9-b2dd-0b25b4a0a48a	32522431-8976-4268-827c-cc9620bb79c0	29f3fdcc-234e-4bc5-96b3-b606e9a31016	7bd190aa-4285-48b7-9fd2-2ac8d62a9f4a
5b641605-3d67-4db4-a954-24b4d6aed52b	MACBOOK-PRO-101	SN-MAC-101	Available	2023-11-01	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	9051e828-8bb0-4276-8a9e-a19ae42e5e6e	558a80e7-439b-4af1-941b-40623e8a4b0f	9558de8d-9fe3-4ae0-94dc-4f67230d9313
aaaf5120-3fe5-41ac-893c-4606f3e6c236	DELL-LAP-102	SN-DELL-102	Available	2023-12-05	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	5b306a1a-e685-48ac-ad04-bb37c6e7439b	558a80e7-439b-4af1-941b-40623e8a4b0f	9558de8d-9fe3-4ae0-94dc-4f67230d9313
77ad4d15-a6c0-433f-9c01-4503da996fe0	HP-LAP-101	SN-HP-101	Assigned	2023-11-15	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	12e4d76e-1fbe-40d9-aad5-4c2d0b3a6101	d05734ab-0623-4dc3-9764-70ef592292a2	8fdf2208-eae9-4e3f-a22c-f5b31a674d30
e8d76052-d716-46d2-8778-3def8fcd35e5	DESK-WOOD-101	SN-DSK-101	Assigned	2023-07-20	4aea922b-7d09-4c70-9c37-e5aa26a0a052	32522431-8976-4268-827c-cc9620bb79c0	8c2d878e-1ad9-4da2-9562-b61319c2306c	242605b2-f6cc-40b2-adee-a3ab43a1dfd2
c96d71f5-d6ca-40a7-a1eb-55914e7d75f0	IT-DELL-001	SN-IT-111	Available	2023-05-15	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	5b306a1a-e685-48ac-ad04-bb37c6e7439b	558a80e7-439b-4af1-941b-40623e8a4b0f	9558de8d-9fe3-4ae0-94dc-4f67230d9313
d40a7830-59bb-4db3-a922-08bb97de67cc	MON-HP-101	SN-MON-102	Available	2023-09-10	9dd034db-7a51-4be0-89ff-3c03631e5aa5	12e4d76e-1fbe-40d9-aad5-4c2d0b3a6101	29f3fdcc-234e-4bc5-96b3-b606e9a31016	821d3afb-4f9a-4a02-9653-c06931f1a17a
76d20491-57fe-4306-9718-f65eb26f7fd9	IT-DELL-002	SN-IT-112	Available	2023-06-10	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	5b306a1a-e685-48ac-ad04-bb37c6e7439b	558a80e7-439b-4af1-941b-40623e8a4b0f	9558de8d-9fe3-4ae0-94dc-4f67230d9313
e82b997f-a391-4e62-836a-b3fcb5a980f4	IT-HP-003	SN-IT-113	Available	2022-11-20	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	12e4d76e-1fbe-40d9-aad5-4c2d0b3a6101	558a80e7-439b-4af1-941b-40623e8a4b0f	9558de8d-9fe3-4ae0-94dc-4f67230d9313
318ebcb7-d903-4e92-9c79-a3612b568e14	IT-MON-004	SN-IT-114	Available	2023-01-05	9dd034db-7a51-4be0-89ff-3c03631e5aa5	5b306a1a-e685-48ac-ad04-bb37c6e7439b	4ee4ea5b-2c5e-4341-9800-d9dc63dc8099	9558de8d-9fe3-4ae0-94dc-4f67230d9313
9213296d-dd8e-443e-8a85-b580e144b708	IT-MAC-005	SN-IT-115	Available	2024-02-10	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	9051e828-8bb0-4276-8a9e-a19ae42e5e6e	558a80e7-439b-4af1-941b-40623e8a4b0f	9558de8d-9fe3-4ae0-94dc-4f67230d9313
3b86a43c-4dca-4655-b871-21d1ea94a769	HR-CHAIR-001	SN-HR-221	Available	2022-08-15	28197bec-2c7a-4da9-b2dd-0b25b4a0a48a	32522431-8976-4268-827c-cc9620bb79c0	558a80e7-439b-4af1-941b-40623e8a4b0f	821d3afb-4f9a-4a02-9653-c06931f1a17a
eabc731e-59e4-4fb6-8b8c-aafdfdd22f33	HR-CHAIR-002	SN-HR-222	Available	2022-08-15	28197bec-2c7a-4da9-b2dd-0b25b4a0a48a	32522431-8976-4268-827c-cc9620bb79c0	558a80e7-439b-4af1-941b-40623e8a4b0f	821d3afb-4f9a-4a02-9653-c06931f1a17a
b3e4c906-48d3-429d-901f-ac4280610fb7	HR-DESK-003	SN-HR-223	Available	2021-12-10	4aea922b-7d09-4c70-9c37-e5aa26a0a052	32522431-8976-4268-827c-cc9620bb79c0	d05734ab-0623-4dc3-9764-70ef592292a2	821d3afb-4f9a-4a02-9653-c06931f1a17a
664042d2-b1fe-487d-a867-c90528a2f04c	HR-DESK-004	SN-HR-224	Available	2021-12-10	4aea922b-7d09-4c70-9c37-e5aa26a0a052	32522431-8976-4268-827c-cc9620bb79c0	d05734ab-0623-4dc3-9764-70ef592292a2	821d3afb-4f9a-4a02-9653-c06931f1a17a
906a21c0-7834-4572-81af-03a92db3421b	FIN-LAP-001	SN-FIN-331	Available	2023-09-01	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	12e4d76e-1fbe-40d9-aad5-4c2d0b3a6101	d05734ab-0623-4dc3-9764-70ef592292a2	8fdf2208-eae9-4e3f-a22c-f5b31a674d30
03ac62f9-0677-4429-a9bb-a71304f3027a	FIN-LAP-002	SN-FIN-332	Available	2023-10-15	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	5b306a1a-e685-48ac-ad04-bb37c6e7439b	d05734ab-0623-4dc3-9764-70ef592292a2	8fdf2208-eae9-4e3f-a22c-f5b31a674d30
e02e26cf-30ae-4e82-a44c-9bbde7769a94	FIN-MON-003	SN-FIN-333	Available	2022-04-20	9dd034db-7a51-4be0-89ff-3c03631e5aa5	12e4d76e-1fbe-40d9-aad5-4c2d0b3a6101	d05734ab-0623-4dc3-9764-70ef592292a2	8fdf2208-eae9-4e3f-a22c-f5b31a674d30
4e452da4-b110-432a-8689-59c2950c27c6	OPS-DESK-002	SN-OPS-552	Available	2021-06-15	4aea922b-7d09-4c70-9c37-e5aa26a0a052	32522431-8976-4268-827c-cc9620bb79c0	8c2d878e-1ad9-4da2-9562-b61319c2306c	7bd190aa-4285-48b7-9fd2-2ac8d62a9f4a
f6467f9c-c8df-4199-bf72-4678e054b532	PRO-LAP-001	SN-PRO-661	Available	2022-01-20	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	12e4d76e-1fbe-40d9-aad5-4c2d0b3a6101	8c2d878e-1ad9-4da2-9562-b61319c2306c	242605b2-f6cc-40b2-adee-a3ab43a1dfd2
e998b69f-afc1-4821-a052-38ae98744319	PRO-MON-002	SN-PRO-662	Available	2024-01-10	9dd034db-7a51-4be0-89ff-3c03631e5aa5	5b306a1a-e685-48ac-ad04-bb37c6e7439b	8c2d878e-1ad9-4da2-9562-b61319c2306c	242605b2-f6cc-40b2-adee-a3ab43a1dfd2
b1d7a724-62ec-4c23-a6b4-47a58d047a90	DELL-LAP-101	SN-DELL-101	Assigned	2023-12-01	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	5b306a1a-e685-48ac-ad04-bb37c6e7439b	558a80e7-439b-4af1-941b-40623e8a4b0f	9558de8d-9fe3-4ae0-94dc-4f67230d9313
6f10aab7-9cc9-4849-8aba-1457fed33057	OPS-LAP-001	SN-OPS-551	Retired	2023-11-11	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	5b306a1a-e685-48ac-ad04-bb37c6e7439b	8c2d878e-1ad9-4da2-9562-b61319c2306c	7bd190aa-4285-48b7-9fd2-2ac8d62a9f4a
d05514f8-fff0-455a-a49a-e14f7287f276	SALES-CHAIR-003	SN-SLS-443	Assigned	2019-03-15	28197bec-2c7a-4da9-b2dd-0b25b4a0a48a	32522431-8976-4268-827c-cc9620bb79c0	29f3fdcc-234e-4bc5-96b3-b606e9a31016	6ce87f70-9b52-4396-970b-d9b8df0dff4a
d765015b-01a1-4e9c-a823-154551c61129	SALES-LAP-001	SN-SLS-441	Assigned	2023-07-11	7f3c260d-2cfb-4784-a8d4-0f0ceea6a232	9051e828-8bb0-4276-8a9e-a19ae42e5e6e	29f3fdcc-234e-4bc5-96b3-b606e9a31016	6ce87f70-9b52-4396-970b-d9b8df0dff4a
\.


--
-- TOC entry 5150 (class 0 OID 16637)
-- Dependencies: 238
-- Data for Name: audits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audits (audit_id, audit_date, findings, asset_id) FROM stdin;
\.


--
-- TOC entry 5136 (class 0 OID 16433)
-- Dependencies: 224
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
-- TOC entry 5149 (class 0 OID 16625)
-- Dependencies: 237
-- Data for Name: depreciation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.depreciation (depreciation_id, rate, value, asset_id) FROM stdin;
\.


--
-- TOC entry 5137 (class 0 OID 16446)
-- Dependencies: 225
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (employee_id, name, contact, department_id, user_id, manager_id, cnic, joining_date, designation, address, emergency_contact) FROM stdin;
11111111-1111-1111-1111-111111111111	Ayesha Khan	03001112221	821d3afb-4f9a-4a02-9653-c06931f1a17a	11111111-0000-0000-0000-000000000001	\N	42101-1111111-1	2022-01-10	HR Manager	\N	\N
22222222-2222-2222-2222-222222222222	Zainab Fatima	03001112222	821d3afb-4f9a-4a02-9653-c06931f1a17a	22222222-0000-0000-0000-000000000001	11111111-1111-1111-1111-111111111111	42101-1111111-2	2023-03-15	HR Executive	\N	\N
33333333-3333-3333-3333-333333333333	Omar Farooq	03001112223	821d3afb-4f9a-4a02-9653-c06931f1a17a	33333333-0000-0000-0000-000000000001	11111111-1111-1111-1111-111111111111	42101-1111111-3	2023-08-20	Recruiter	\N	\N
44444444-4444-4444-4444-444444444444	Bilal Ahmed	03002223331	8fdf2208-eae9-4e3f-a22c-f5b31a674d30	44444444-0000-0000-0000-000000000001	\N	42101-2222222-1	2021-11-05	Finance Manager	\N	\N
55555555-5555-5555-5555-555555555555	Sana Malik	03002223332	8fdf2208-eae9-4e3f-a22c-f5b31a674d30	55555555-0000-0000-0000-000000000001	44444444-4444-4444-4444-444444444444	42101-2222222-2	2023-02-14	Accountant	\N	\N
66666666-6666-6666-6666-666666666666	Hamza Ali	03002223333	8fdf2208-eae9-4e3f-a22c-f5b31a674d30	66666666-0000-0000-0000-000000000001	44444444-4444-4444-4444-444444444444	42101-2222222-3	2023-09-01	Financial Analyst	\N	\N
99999999-9999-9999-9999-999999999999	Sara Ali	03004445551	6ce87f70-9b52-4396-970b-d9b8df0dff4a	99999999-0000-0000-0000-000000000001	\N	42101-4444444-1	2022-07-01	Sales Manager	\N	\N
10101010-1010-1010-1010-101010101010	Usman Tariq	03004445552	6ce87f70-9b52-4396-970b-d9b8df0dff4a	10101010-0000-0000-0000-000000000001	99999999-9999-9999-9999-999999999999	42101-4444444-2	2023-05-12	Sales Executive	\N	\N
20202020-2020-2020-2020-202020202020	Maryam Javed	03004445553	6ce87f70-9b52-4396-970b-d9b8df0dff4a	20202020-0000-0000-0000-000000000001	99999999-9999-9999-9999-999999999999	42101-4444444-3	2023-10-01	Marketing Officer	\N	\N
30303030-3030-3030-3030-303030303030	Imran Khan	03005556661	7bd190aa-4285-48b7-9fd2-2ac8d62a9f4a	30303030-0000-0000-0000-000000000001	\N	42101-5555555-1	2021-09-15	Operations Manager	\N	\N
50505050-5050-5050-5050-505050505050	Nida Yasir	03005556663	7bd190aa-4285-48b7-9fd2-2ac8d62a9f4a	50505050-0000-0000-0000-000000000001	30303030-3030-3030-3030-303030303030	42101-5555555-3	2023-11-20	Logistics Officer	\N	\N
60606060-6060-6060-6060-606060606060	Tariq Mehmood	03006667771	242605b2-f6cc-40b2-adee-a3ab43a1dfd2	60606060-0000-0000-0000-000000000001	\N	42101-6666666-1	2022-02-20	Procurement Manager	\N	\N
70707070-7070-7070-7070-707070707070	Kashif Ali	03006667772	242605b2-f6cc-40b2-adee-a3ab43a1dfd2	70707070-0000-0000-0000-000000000001	60606060-6060-6060-6060-606060606060	42101-6666666-2	2023-01-10	Purchasing Officer	\N	\N
80808080-8080-8080-8080-808080808080	Sadia Imam	03006667773	242605b2-f6cc-40b2-adee-a3ab43a1dfd2	80808080-0000-0000-0000-000000000001	60606060-6060-6060-6060-606060606060	42101-6666666-3	2023-06-25	Vendor Coordinator	\N	\N
77777777-7777-7777-7777-777777777777	Faisal Khan	03003334441	9558de8d-9fe3-4ae0-94dc-4f67230d9313	77777777-0000-0000-0000-000000000001	\N	42101-3333333-1	2023-04-10	Network Admin		
c37b566a-6d84-4a83-9936-0bb669551422	mysa	03001234567	7bd190aa-4285-48b7-9fd2-2ac8d62a9f4a	8f1e3ae4-b4f3-4b3e-b0a5-b97ce84cf84b	\N	42101-14444567-8	2026-11-09	HR Executive	Street 1	v
4c9201fa-d729-4fce-953a-aecede829e3f	 Hira Noor	 03003334442 	9558de8d-9fe3-4ae0-94dc-4f67230d9313	c9188188-e359-4cd4-a57c-bbdc8981073a	77777777-7777-7777-7777-777777777777	42101-3333333-2	2026-12-21	System Analyst	\N	\N
40404040-4040-4040-4040-404040404040	Adeel 	03005556661	821d3afb-4f9a-4a02-9653-c06931f1a17a	40404040-0000-0000-0000-000000000001	30303030-3030-3030-3030-303030303030	42101-5551555-0	2022-12-01	Operations Executive		
\.


--
-- TOC entry 5152 (class 0 OID 16664)
-- Dependencies: 240
-- Data for Name: financial_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.financial_records (financial_id, amount, transaction_type, asset_id) FROM stdin;
\.


--
-- TOC entry 5135 (class 0 OID 16426)
-- Dependencies: 223
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
-- TOC entry 5148 (class 0 OID 16613)
-- Dependencies: 236
-- Data for Name: maintenance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maintenance (maintenance_id, maintenance_date, cost, asset_id) FROM stdin;
\.


--
-- TOC entry 5134 (class 0 OID 16418)
-- Dependencies: 222
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
-- TOC entry 5143 (class 0 OID 16543)
-- Dependencies: 231
-- Data for Name: request_approvals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.request_approvals (approval_id, approval_status, approved_on, request_id, approved_by) FROM stdin;
d89dcabd-ee1a-41fc-b454-74ddd972770a	Approved	2026-11-26	4b0bf199-bbba-459c-b19b-65737ad235c1	30303030-0000-0000-0000-000000000001
63978d55-969a-4575-8561-a9c343486a69	Rejected	2026-11-26	3bfc4194-0b67-4a18-a10f-a0a6d01b057b	44444444-0000-0000-0000-000000000001
f428fccd-b3d6-4591-9452-2e73a46091db	Rejected	2026-11-26	5aec58ff-4026-462e-bfbc-f2aed4e9ddad	99999999-0000-0000-0000-000000000001
19176d88-5bcc-4f9c-915e-2d348557cc40	Approved	2026-11-26	61b30565-0954-4b42-99f2-686f6d8cac16	99999999-0000-0000-0000-000000000001
d7df1f5b-0b12-4efd-9ee1-634f78bb8260	Rejected	2026-11-26	1d2136d3-9314-4aea-969e-c5a341dc5dfa	77777777-0000-0000-0000-000000000001
20e939f0-8c8d-46fa-933e-a61cfe08e6f5	Approved	2026-11-26	62a6a7e9-24e8-4ebd-8e3e-b1d7970d3809	77777777-0000-0000-0000-000000000001
90977f7c-df98-4cd4-9621-205cc7d96416	Approved	2026-11-26	664d5c36-76c5-41f9-bbd8-d4b2fece7cb9	99999999-0000-0000-0000-000000000001
a4d695d4-efbb-4935-84b4-a3fb51401662	Rejected	2026-11-27	8c3a2b75-878d-46dc-8656-907106585ef3	99999999-0000-0000-0000-000000000001
ef565663-1b4b-4830-992c-c478248de773	Approved	2026-11-27	2cbcb974-1393-4b04-bfad-53f5818c8e59	99999999-0000-0000-0000-000000000001
0cd7677a-ed76-4c20-9a79-e47706e04788	Approved	2026-11-27	eac35bd3-637e-4f74-a7a8-01bcf7573e1e	99999999-0000-0000-0000-000000000001
65edbd49-b41b-4215-90cb-8f893515f102	Approved	2026-11-27	73fc8319-662c-485b-a506-b2dd2eee9d28	99999999-0000-0000-0000-000000000001
\.


--
-- TOC entry 5155 (class 0 OID 16705)
-- Dependencies: 243
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
-- TOC entry 5133 (class 0 OID 16410)
-- Dependencies: 221
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, role_name) FROM stdin;
2a22e2b7-5293-493d-9f44-901f64c35ae4	Admin
fbd0f03e-e55d-47d6-a08e-d9979db04da9	Manager
be2bb751-0b5e-4572-8df4-9438b880d473	Employee
\.


--
-- TOC entry 5151 (class 0 OID 16651)
-- Dependencies: 239
-- Data for Name: status_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status_history (history_id, old_status, new_status, changed_at, asset_id) FROM stdin;
\.


--
-- TOC entry 5153 (class 0 OID 16676)
-- Dependencies: 241
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscriptions (subscription_id, license_key, expiry_date, asset_id) FROM stdin;
\.


--
-- TOC entry 5157 (class 0 OID 24928)
-- Dependencies: 245
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_settings (id, primary_color, accent_color, bg_color, logo_url, updated_at) FROM stdin;
1	#1E3A2A	#D9A05B	#F4F5F7	data:image/jpeg;base64,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	2026-11-27 14:48:56.547633
\.


--
-- TOC entry 5154 (class 0 OID 16688)
-- Dependencies: 242
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
11111111-0000-0000-0000-000000000001	fbd0f03e-e55d-47d6-a08e-d9979db04da9
22222222-0000-0000-0000-000000000001	be2bb751-0b5e-4572-8df4-9438b880d473
33333333-0000-0000-0000-000000000001	be2bb751-0b5e-4572-8df4-9438b880d473
44444444-0000-0000-0000-000000000001	fbd0f03e-e55d-47d6-a08e-d9979db04da9
55555555-0000-0000-0000-000000000001	be2bb751-0b5e-4572-8df4-9438b880d473
66666666-0000-0000-0000-000000000001	be2bb751-0b5e-4572-8df4-9438b880d473
99999999-0000-0000-0000-000000000001	fbd0f03e-e55d-47d6-a08e-d9979db04da9
10101010-0000-0000-0000-000000000001	be2bb751-0b5e-4572-8df4-9438b880d473
20202020-0000-0000-0000-000000000001	be2bb751-0b5e-4572-8df4-9438b880d473
30303030-0000-0000-0000-000000000001	fbd0f03e-e55d-47d6-a08e-d9979db04da9
50505050-0000-0000-0000-000000000001	be2bb751-0b5e-4572-8df4-9438b880d473
60606060-0000-0000-0000-000000000001	fbd0f03e-e55d-47d6-a08e-d9979db04da9
70707070-0000-0000-0000-000000000001	be2bb751-0b5e-4572-8df4-9438b880d473
80808080-0000-0000-0000-000000000001	be2bb751-0b5e-4572-8df4-9438b880d473
77777777-0000-0000-0000-000000000001	fbd0f03e-e55d-47d6-a08e-d9979db04da9
8f1e3ae4-b4f3-4b3e-b0a5-b97ce84cf84b	fbd0f03e-e55d-47d6-a08e-d9979db04da9
c9188188-e359-4cd4-a57c-bbdc8981073a	be2bb751-0b5e-4572-8df4-9438b880d473
40404040-0000-0000-0000-000000000001	2a22e2b7-5293-493d-9f44-901f64c35ae4
\.


--
-- TOC entry 5132 (class 0 OID 16396)
-- Dependencies: 220
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
11111111-0000-0000-0000-000000000001	ayesha.hr@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Active	2026-11-25 02:06:12.473684
22222222-0000-0000-0000-000000000001	zainab.hr@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Active	2026-11-25 02:06:12.473684
44444444-0000-0000-0000-000000000001	bilal.finance@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Active	2026-11-25 02:07:23.54523
55555555-0000-0000-0000-000000000001	sana.finance@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Active	2026-11-25 02:07:23.54523
66666666-0000-0000-0000-000000000001	hamza.finance@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Active	2026-11-25 02:07:23.54523
77777777-0000-0000-0000-000000000001	faisal.it@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Active	2026-11-25 02:07:37.808478
99999999-0000-0000-0000-000000000001	sara.sales@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Active	2026-11-25 02:07:51.143824
10101010-0000-0000-0000-000000000001	usman.sales@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Active	2026-11-25 02:07:51.143824
20202020-0000-0000-0000-000000000001	maryam.sales@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Active	2026-11-25 02:07:51.143824
30303030-0000-0000-0000-000000000001	imran.ops@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Active	2026-11-25 02:08:02.644231
50505050-0000-0000-0000-000000000001	nida.ops@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Active	2026-11-25 02:08:02.644231
70707070-0000-0000-0000-000000000001	kashif.proc@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Active	2026-11-25 02:08:13.06194
80808080-0000-0000-0000-000000000001	sadia.proc@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Active	2026-11-25 02:08:13.06194
40404040-0000-0000-0000-000000000001	adeel.ops@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Active	2026-11-25 02:08:02.644231
8f1e3ae4-b4f3-4b3e-b0a5-b97ce84cf84b	mysa@techavenue.com	$2a$10$GorhwzFmhmGh3naHRejKYOJp/86hRk9Huc7toTBz1E0CW.l3HMV8C	Active	2026-11-25 03:27:23.454657
60606060-0000-0000-0000-000000000001	tariq.proc@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Suspended	2026-11-25 02:08:13.06194
c9188188-e359-4cd4-a57c-bbdc8981073a	hira.it@techavenue.com	$2a$10$uRA4OPmvGDrbfYnnfmb//enGvsj0H2rctVu4MaoXFc5d.97fNkSs2	Active	2026-11-26 00:53:42.48801
33333333-0000-0000-0000-000000000001	omar.hr@techavenue.com	$2a$10$ZO9k0x4RVnncc7uw9ZA23ONjsL/ItURz09zkU2KmmGYxhSKladpxe	Suspended	2026-11-25 02:06:12.473684
\.


--
-- TOC entry 5138 (class 0 OID 16464)
-- Dependencies: 226
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
-- TOC entry 5147 (class 0 OID 16601)
-- Dependencies: 235
-- Data for Name: warranties; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.warranties (warranty_id, start_date, end_date, asset_id) FROM stdin;
\.


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 244
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 1, true);


--
-- TOC entry 4928 (class 2606 OID 16566)
-- Name: asset_assignments asset_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_assignments
    ADD CONSTRAINT asset_assignments_pkey PRIMARY KEY (assignment_id);


--
-- TOC entry 4914 (class 2606 OID 16479)
-- Name: asset_categories asset_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_categories
    ADD CONSTRAINT asset_categories_pkey PRIMARY KEY (category_id);


--
-- TOC entry 4922 (class 2606 OID 16520)
-- Name: asset_documents asset_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_documents
    ADD CONSTRAINT asset_documents_pkey PRIMARY KEY (doc_no, asset_id);


--
-- TOC entry 4924 (class 2606 OID 16532)
-- Name: asset_requests asset_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_pkey PRIMARY KEY (request_id);


--
-- TOC entry 4932 (class 2606 OID 16595)
-- Name: asset_returns asset_returns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_returns
    ADD CONSTRAINT asset_returns_pkey PRIMARY KEY (return_id);


--
-- TOC entry 4930 (class 2606 OID 16583)
-- Name: asset_transfers asset_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfers
    ADD CONSTRAINT asset_transfers_pkey PRIMARY KEY (transfer_id);


--
-- TOC entry 4918 (class 2606 OID 16493)
-- Name: assets assets_asset_tag_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_asset_tag_key UNIQUE (asset_tag);


--
-- TOC entry 4920 (class 2606 OID 16491)
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (asset_id);


--
-- TOC entry 4940 (class 2606 OID 16645)
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (audit_id);


--
-- TOC entry 4902 (class 2606 OID 16440)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- TOC entry 4938 (class 2606 OID 16631)
-- Name: depreciation depreciation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depreciation
    ADD CONSTRAINT depreciation_pkey PRIMARY KEY (depreciation_id);


--
-- TOC entry 4906 (class 2606 OID 16734)
-- Name: employees employees_cnic_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_cnic_key UNIQUE (cnic);


--
-- TOC entry 4908 (class 2606 OID 16453)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 4944 (class 2606 OID 16670)
-- Name: financial_records financial_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financial_records
    ADD CONSTRAINT financial_records_pkey PRIMARY KEY (financial_id);


--
-- TOC entry 4900 (class 2606 OID 16432)
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (location_id);


--
-- TOC entry 4936 (class 2606 OID 16619)
-- Name: maintenance maintenance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance
    ADD CONSTRAINT maintenance_pkey PRIMARY KEY (maintenance_id);


--
-- TOC entry 4898 (class 2606 OID 16425)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (permission_id);


--
-- TOC entry 4926 (class 2606 OID 16549)
-- Name: request_approvals request_approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_approvals
    ADD CONSTRAINT request_approvals_pkey PRIMARY KEY (approval_id);


--
-- TOC entry 4950 (class 2606 OID 16711)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- TOC entry 4896 (class 2606 OID 16417)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- TOC entry 4942 (class 2606 OID 16658)
-- Name: status_history status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_history
    ADD CONSTRAINT status_history_pkey PRIMARY KEY (history_id);


--
-- TOC entry 4946 (class 2606 OID 16682)
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (subscription_id);


--
-- TOC entry 4952 (class 2606 OID 24940)
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 4916 (class 2606 OID 16727)
-- Name: asset_categories unique_category_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_categories
    ADD CONSTRAINT unique_category_name UNIQUE (category_name);


--
-- TOC entry 4904 (class 2606 OID 16723)
-- Name: departments unique_department_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT unique_department_name UNIQUE (department_name);


--
-- TOC entry 4910 (class 2606 OID 16725)
-- Name: vendors unique_vendor_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT unique_vendor_name UNIQUE (vendor_name);


--
-- TOC entry 4948 (class 2606 OID 16694)
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- TOC entry 4892 (class 2606 OID 16409)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4894 (class 2606 OID 16407)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4912 (class 2606 OID 16471)
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (vendor_id);


--
-- TOC entry 4934 (class 2606 OID 16607)
-- Name: warranties warranties_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warranties
    ADD CONSTRAINT warranties_pkey PRIMARY KEY (warranty_id);


--
-- TOC entry 4967 (class 2606 OID 16567)
-- Name: asset_assignments asset_assignments_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_assignments
    ADD CONSTRAINT asset_assignments_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id);


--
-- TOC entry 4968 (class 2606 OID 24920)
-- Name: asset_assignments asset_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_assignments
    ADD CONSTRAINT asset_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.employees(employee_id);


--
-- TOC entry 4969 (class 2606 OID 16572)
-- Name: asset_assignments asset_assignments_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_assignments
    ADD CONSTRAINT asset_assignments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 4957 (class 2606 OID 16480)
-- Name: asset_categories asset_categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_categories
    ADD CONSTRAINT asset_categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.asset_categories(category_id);


--
-- TOC entry 4962 (class 2606 OID 16521)
-- Name: asset_documents asset_documents_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_documents
    ADD CONSTRAINT asset_documents_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- TOC entry 4963 (class 2606 OID 16538)
-- Name: asset_requests asset_requests_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.asset_categories(category_id);


--
-- TOC entry 4964 (class 2606 OID 16533)
-- Name: asset_requests asset_requests_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 4971 (class 2606 OID 24995)
-- Name: asset_returns asset_returns_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_returns
    ADD CONSTRAINT asset_returns_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id);


--
-- TOC entry 4972 (class 2606 OID 16596)
-- Name: asset_returns asset_returns_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_returns
    ADD CONSTRAINT asset_returns_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.asset_assignments(assignment_id);


--
-- TOC entry 4973 (class 2606 OID 24990)
-- Name: asset_returns asset_returns_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_returns
    ADD CONSTRAINT asset_returns_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 4970 (class 2606 OID 16584)
-- Name: asset_transfers asset_transfers_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfers
    ADD CONSTRAINT asset_transfers_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.asset_assignments(assignment_id);


--
-- TOC entry 4958 (class 2606 OID 16494)
-- Name: assets assets_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.asset_categories(category_id);


--
-- TOC entry 4959 (class 2606 OID 16509)
-- Name: assets assets_dept_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_dept_id_fkey FOREIGN KEY (dept_id) REFERENCES public.departments(department_id);


--
-- TOC entry 4960 (class 2606 OID 16504)
-- Name: assets assets_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(location_id);


--
-- TOC entry 4961 (class 2606 OID 16499)
-- Name: assets assets_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(vendor_id);


--
-- TOC entry 4977 (class 2606 OID 16646)
-- Name: audits audits_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- TOC entry 4953 (class 2606 OID 16441)
-- Name: departments departments_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(location_id);


--
-- TOC entry 4976 (class 2606 OID 16632)
-- Name: depreciation depreciation_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depreciation
    ADD CONSTRAINT depreciation_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- TOC entry 4954 (class 2606 OID 16454)
-- Name: employees employees_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(department_id);


--
-- TOC entry 4955 (class 2606 OID 16728)
-- Name: employees employees_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 4956 (class 2606 OID 16459)
-- Name: employees employees_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 4979 (class 2606 OID 16671)
-- Name: financial_records financial_records_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financial_records
    ADD CONSTRAINT financial_records_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- TOC entry 4975 (class 2606 OID 16620)
-- Name: maintenance maintenance_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance
    ADD CONSTRAINT maintenance_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- TOC entry 4965 (class 2606 OID 16555)
-- Name: request_approvals request_approvals_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_approvals
    ADD CONSTRAINT request_approvals_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(user_id);


--
-- TOC entry 4966 (class 2606 OID 16550)
-- Name: request_approvals request_approvals_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_approvals
    ADD CONSTRAINT request_approvals_request_id_fkey FOREIGN KEY (request_id) REFERENCES public.asset_requests(request_id);


--
-- TOC entry 4983 (class 2606 OID 16717)
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(permission_id) ON DELETE CASCADE;


--
-- TOC entry 4984 (class 2606 OID 16712)
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- TOC entry 4978 (class 2606 OID 16659)
-- Name: status_history status_history_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_history
    ADD CONSTRAINT status_history_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- TOC entry 4980 (class 2606 OID 16683)
-- Name: subscriptions subscriptions_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- TOC entry 4981 (class 2606 OID 16700)
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- TOC entry 4982 (class 2606 OID 16695)
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4974 (class 2606 OID 16608)
-- Name: warranties warranties_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warranties
    ADD CONSTRAINT warranties_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


-- Completed on 2026-11-28 17:43:06

--
-- PostgreSQL database dump complete
--

\unrestrict FtVBXknGiwyjgW6IYcgSczZqCqrUs7e081APegLSwY3jbVY146QUC6NAHimnftp

