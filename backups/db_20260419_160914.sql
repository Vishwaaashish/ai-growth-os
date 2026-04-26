--
-- PostgreSQL database dump
--

\restrict bWhpe1j13Lbf6vgnffbJhPhNVaL9xFEV4X2j2GlFrK6HhafcRcSdSB0VEnpejvH

-- Dumped from database version 15.17 (Debian 15.17-1.pgdg13+1)
-- Dumped by pg_dump version 15.17 (Debian 15.17-1.pgdg13+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.api_keys (
    key text NOT NULL,
    tenant_id text,
    quota integer DEFAULT 1000,
    used integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.api_keys OWNER TO admin;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.jobs (
    id integer NOT NULL,
    type text,
    payload jsonb,
    status text,
    retries integer DEFAULT 0,
    result jsonb,
    error text,
    policy_id integer,
    tenant_id text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.jobs OWNER TO admin;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jobs_id_seq OWNER TO admin;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: learning_memory; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.learning_memory (
    id integer NOT NULL,
    policy_id integer,
    outcome boolean,
    latency integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.learning_memory OWNER TO admin;

--
-- Name: learning_memory_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.learning_memory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.learning_memory_id_seq OWNER TO admin;

--
-- Name: learning_memory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.learning_memory_id_seq OWNED BY public.learning_memory.id;


--
-- Name: policies; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.policies (
    id integer NOT NULL,
    agent_type text,
    condition jsonb,
    action jsonb,
    weight double precision DEFAULT 1.0,
    approval_status text DEFAULT 'approved'::text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.policies OWNER TO admin;

--
-- Name: policies_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.policies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.policies_id_seq OWNER TO admin;

--
-- Name: policies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.policies_id_seq OWNED BY public.policies.id;


--
-- Name: policy_metrics; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.policy_metrics (
    policy_id integer NOT NULL,
    success_count integer DEFAULT 0,
    failure_count integer DEFAULT 0,
    avg_latency double precision DEFAULT 0
);


ALTER TABLE public.policy_metrics OWNER TO admin;

--
-- Name: tenants; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.tenants (
    id text NOT NULL,
    name text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tenants OWNER TO admin;

--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: learning_memory id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.learning_memory ALTER COLUMN id SET DEFAULT nextval('public.learning_memory_id_seq'::regclass);


--
-- Name: policies id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.policies ALTER COLUMN id SET DEFAULT nextval('public.policies_id_seq'::regclass);


--
-- Data for Name: api_keys; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.api_keys (key, tenant_id, quota, used, created_at) FROM stdin;
test-key-123	tenant_1	1000	6	2026-04-18 19:50:12.827395
ada63d9cdbdc4dc4859d99a281394d26	tenant_5aca8f88	1000	1	2026-04-19 10:01:20.472818
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.jobs (id, type, payload, status, retries, result, error, policy_id, tenant_id, created_at) FROM stdin;
1	test	{}	pending	0	\N	\N	\N	tenant_1	2026-04-19 06:16:17.323648
2	test	{}	completed	0	{"status": "success", "message": "Executed job type: test"}	\N	\N	tenant_1	2026-04-19 06:26:41.310566
3	test	{}	queued	0	{"status": "success", "message": "Executed job type: test"}	\N	1	tenant_1	2026-04-19 06:33:41.082442
4	test	{}	pending	0	\N	\N	1	tenant_1	2026-04-19 08:52:12.796259
5	test	{}	queued	0	{"status": "success", "message": "Executed job type: test"}	\N	1	tenant_1	2026-04-19 08:59:05.481951
6	test	{}	completed	0	{"status": "success", "message": "Executed job type: test"}	\N	1	tenant_1	2026-04-19 09:03:50.250158
7	test	{}	completed	0	{"status": "success", "message": "Executed job type: test"}	\N	3	tenant_5aca8f88	2026-04-19 10:03:42.321539
\.


--
-- Data for Name: learning_memory; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.learning_memory (id, policy_id, outcome, latency, created_at) FROM stdin;
1	1	t	5	2026-04-19 09:03:50.938378
2	3	t	3	2026-04-19 10:03:42.753747
\.


--
-- Data for Name: policies; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.policies (id, agent_type, condition, action, weight, approval_status, created_at) FROM stdin;
1	default	{}	{"queue": "default"}	1	approved	2026-04-19 06:31:21.403033
2	test_job	{}	{"priority": 3}	0.17	approved	2026-04-19 09:03:50.946125
3	test_job	{}	{"priority": 4}	3	approved	2026-04-19 09:03:50.946125
4	test_job	{}	{"priority": 5}	1.98	approved	2026-04-19 09:03:50.946125
\.


--
-- Data for Name: policy_metrics; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.policy_metrics (policy_id, success_count, failure_count, avg_latency) FROM stdin;
1	3	0	5
3	1	0	3
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.tenants (id, name, created_at) FROM stdin;
tenant_7d1c5598	test_company	2026-04-19 09:40:18.482534
tenant_5aca8f88	test_company	2026-04-19 09:57:25.210645
\.


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.jobs_id_seq', 7, true);


--
-- Name: learning_memory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.learning_memory_id_seq', 2, true);


--
-- Name: policies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.policies_id_seq', 4, true);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (key);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: learning_memory learning_memory_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.learning_memory
    ADD CONSTRAINT learning_memory_pkey PRIMARY KEY (id);


--
-- Name: policies policies_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT policies_pkey PRIMARY KEY (id);


--
-- Name: policy_metrics policy_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.policy_metrics
    ADD CONSTRAINT policy_metrics_pkey PRIMARY KEY (policy_id);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict bWhpe1j13Lbf6vgnffbJhPhNVaL9xFEV4X2j2GlFrK6HhafcRcSdSB0VEnpejvH

