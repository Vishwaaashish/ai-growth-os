--
-- PostgreSQL database dump
--

\restrict FHunRdAPRC5svBFy3HB0W8wqfhRrFTivdqpbSgyUpvCX6cTNiuNjUgvaWwfIj98

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

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


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
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.api_keys OWNER TO admin;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.audit_logs (
    id text NOT NULL,
    tenant_id text,
    user_id text,
    action text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.audit_logs OWNER TO admin;

--
-- Name: campaign_metrics; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.campaign_metrics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id text,
    impressions integer,
    clicks integer,
    spend double precision,
    ctr double precision,
    cpa double precision,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.campaign_metrics OWNER TO admin;

--
-- Name: creative_ad_map; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.creative_ad_map (
    id integer NOT NULL,
    creative_id character varying NOT NULL,
    ad_id character varying NOT NULL,
    platform character varying DEFAULT 'meta'::character varying,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.creative_ad_map OWNER TO admin;

--
-- Name: creative_ad_map_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.creative_ad_map_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.creative_ad_map_id_seq OWNER TO admin;

--
-- Name: creative_ad_map_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.creative_ad_map_id_seq OWNED BY public.creative_ad_map.id;


--
-- Name: creative_metrics; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.creative_metrics (
    creative_id text NOT NULL,
    ctr double precision,
    cpa double precision,
    roas double precision,
    frequency double precision,
    updated_at timestamp without time zone DEFAULT now(),
    id integer NOT NULL
);


ALTER TABLE public.creative_metrics OWNER TO admin;

--
-- Name: creative_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.creative_metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.creative_metrics_id_seq OWNER TO admin;

--
-- Name: creative_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.creative_metrics_id_seq OWNED BY public.creative_metrics.id;


--
-- Name: creatives; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.creatives (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    script_id uuid,
    format text,
    asset_url text,
    status text DEFAULT 'draft'::text,
    score double precision DEFAULT 0
);


ALTER TABLE public.creatives OWNER TO admin;

--
-- Name: experiments; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.experiments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    creative_id text,
    variant text,
    status text,
    started_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.experiments OWNER TO admin;

--
-- Name: feedback_log; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.feedback_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    policy_id uuid,
    success boolean,
    latency integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.feedback_log OWNER TO admin;

--
-- Name: hooks; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.hooks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id text,
    category text,
    text text,
    score double precision DEFAULT 0,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.hooks OWNER TO admin;

--
-- Name: invoices; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.invoices (
    id text NOT NULL,
    tenant_id text,
    plan_id text,
    amount integer,
    status text DEFAULT 'pending'::text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.invoices OWNER TO admin;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.jobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id text,
    status text,
    payload jsonb,
    result jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    type text,
    retries integer DEFAULT 0,
    error text,
    policy_id uuid
);


ALTER TABLE public.jobs OWNER TO admin;

--
-- Name: learning_insights; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.learning_insights (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    pattern jsonb,
    confidence double precision,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.learning_insights OWNER TO admin;

--
-- Name: learning_memory; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.learning_memory (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    policy_id uuid,
    outcome boolean,
    latency double precision,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.learning_memory OWNER TO admin;

--
-- Name: outcomes_log; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.outcomes_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    policy_id uuid,
    success boolean,
    latency double precision,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.outcomes_log OWNER TO admin;

--
-- Name: payments; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.payments (
    id text NOT NULL,
    invoice_id text,
    amount integer,
    method text,
    status text DEFAULT 'initiated'::text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.payments OWNER TO admin;

--
-- Name: plans; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.plans (
    id text NOT NULL,
    name text NOT NULL,
    request_limit integer,
    price integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.plans OWNER TO admin;

--
-- Name: policies; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.policies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    agent_type text NOT NULL,
    condition jsonb NOT NULL,
    action jsonb NOT NULL,
    weight double precision DEFAULT 1.0,
    approval_status text DEFAULT 'pending'::text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    score double precision DEFAULT 0,
    usage_count integer DEFAULT 0,
    last_used timestamp without time zone
);


ALTER TABLE public.policies OWNER TO admin;

--
-- Name: policy_metrics; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.policy_metrics (
    policy_id uuid NOT NULL,
    success_count integer DEFAULT 0,
    failure_count integer DEFAULT 0,
    avg_latency double precision DEFAULT 0,
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.policy_metrics OWNER TO admin;

--
-- Name: scripts; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.scripts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hook_id uuid,
    format text,
    content text,
    version integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.scripts OWNER TO admin;

--
-- Name: strategy_memory; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.strategy_memory (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    policy_id uuid,
    strategy text,
    success boolean,
    latency integer,
    context jsonb,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.strategy_memory OWNER TO admin;

--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.subscriptions (
    id text DEFAULT gen_random_uuid() NOT NULL,
    tenant_id text,
    plan_id text,
    status text DEFAULT 'active'::text,
    start_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.subscriptions OWNER TO admin;

--
-- Name: system_goals; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.system_goals (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text,
    priority integer,
    target_metric text,
    is_active boolean DEFAULT true
);


ALTER TABLE public.system_goals OWNER TO admin;

--
-- Name: tenants; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.tenants (
    id text NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tenants OWNER TO admin;

--
-- Name: usage_logs; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.usage_logs (
    id text NOT NULL,
    tenant_id text,
    endpoint text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.usage_logs OWNER TO admin;

--
-- Name: users; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.users (
    id text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    role text DEFAULT 'client'::text,
    tenant_id text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO admin;

--
-- Name: creative_ad_map id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.creative_ad_map ALTER COLUMN id SET DEFAULT nextval('public.creative_ad_map_id_seq'::regclass);


--
-- Name: creative_metrics id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.creative_metrics ALTER COLUMN id SET DEFAULT nextval('public.creative_metrics_id_seq'::regclass);


--
-- Data for Name: api_keys; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.api_keys (key, tenant_id, quota, used, created_at) FROM stdin;
test_key_123	tenant_1	1	100	2026-04-21 21:32:09.750893
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.audit_logs (id, tenant_id, user_id, action, created_at) FROM stdin;
log_a9986d80	tenant_0e46a852	user_4dd0dd51	create_invoice	2026-04-21 21:13:12.849734
log_b8e8f840	tenant_0e46a852	user_4dd0dd51	create_invoice	2026-04-21 21:17:51.093038
log_1c5c2aa2	tenant_0e46a852	user_4dd0dd51	create_invoice	2026-04-21 21:17:54.062154
log_7b136800	tenant_0e46a852	user_4dd0dd51	create_invoice	2026-04-21 21:34:11.384189
log_6bd208ef	tenant_0e46a852	user_4dd0dd51	create_invoice	2026-04-21 21:34:15.555416
log_d459336f	tenant_a0ff45bf	user_4dd0dd51	create_invoice	2026-04-22 00:41:26.448372
log_49197fa0	tenant_a0ff45bf	user_4dd0dd51	create_invoice	2026-04-22 00:41:41.184987
log_9ed6fa4b	tenant_a0ff45bf	user_4dd0dd51	create_invoice	2026-04-22 00:46:19.857551
\.


--
-- Data for Name: campaign_metrics; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.campaign_metrics (id, campaign_id, impressions, clicks, spend, ctr, cpa, created_at) FROM stdin;
72b76bb1-5889-4987-bb81-cc05ed4268fe	test_1	1000	50	500	0.05	10	2026-04-25 07:23:36.973205
b4f35daf-2313-446f-95ae-3c978bda47d6	test_2	2000	20	400	0.01	20	2026-04-25 07:23:36.973205
9261a43e-2539-4d48-a6b5-3cb386380fb2	test_3	1500	120	800	0.08	6.5	2026-04-25 07:23:36.973205
\.


--
-- Data for Name: creative_ad_map; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.creative_ad_map (id, creative_id, ad_id, platform, created_at) FROM stdin;
1	creative_1	123456789	meta	2026-04-25 21:19:05.683927
\.


--
-- Data for Name: creative_metrics; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.creative_metrics (creative_id, ctr, cpa, roas, frequency, updated_at, id) FROM stdin;
083b503f-bc9a-4761-9232-985118e3bde4	1.57	218.34	1.3	1.31	2026-04-26 07:32:34.886279	1
84898f92-b30c-4251-99c5-6d4b8ee07428	2.56	130.3	1.18	2.85	2026-04-26 07:32:34.886279	2
1798c0d0-79e4-4d2b-9f3f-990b125d2105	2.89	63.33	3.93	1.45	2026-04-26 07:32:34.886279	3
d4454c95-37c1-4467-a22e-9fb7abac08a2	0.87	98.07	3.2	1.71	2026-04-26 07:32:34.886279	4
1dc79f19-741d-4d47-8552-5e53debeed00	1.81	160.94	1.29	2.74	2026-04-26 07:32:34.886279	5
127074f4-ef1e-44c6-b9d4-6e159522fe6d	3.46	85.52	3.3	2.4	2026-04-26 07:32:34.886279	6
933c3358-c4a9-4190-ba36-d320f41b28bd	2.99	234.2	1.63	1.57	2026-04-26 07:32:34.886279	7
24c4b5e6-9375-4a3d-aa2e-8ecf73311e2a	3.42	116.11	1.36	2.15	2026-04-26 07:32:34.886279	8
8459b204-828a-433c-946a-16940b23fe20	2.56	162.35	1.49	2.14	2026-04-26 07:32:34.886279	9
6c67de4d-14df-473a-b5b7-234ca1892d36	1.01	271.06	1.86	1.05	2026-04-26 07:32:34.886279	10
1a1da762-8b17-44fc-ab54-aacee70233c0	2.64	211.78	2.97	1.93	2026-04-26 07:32:34.886279	11
eaf83308-161d-4cbe-9a8f-c87d75ee5421	3.45	178.33	1.1	1.76	2026-04-26 07:32:34.886279	12
2639cd66-3527-4a6d-b26e-dfb2491c1bf2	1.01	92.2	3.7	1.91	2026-04-26 07:32:34.886279	13
8d34dd99-e669-4ca7-99af-1d91991a09c9	3.07	214.89	1.35	2.72	2026-04-26 07:32:34.886279	14
77398e9d-8c73-4cfb-9019-93696911c12d	1.84	267.43	2.16	1.14	2026-04-26 07:32:34.886279	15
af79ed93-81e1-4dad-ab43-483f230ed7d4	3.37	196.81	2.97	2.5	2026-04-26 07:32:34.886279	16
a09b5914-31d8-4628-bfde-a2ed4f60f907	3.19	73.5	3.13	2.07	2026-04-26 07:32:34.886279	17
af5d64a0-8fd6-4135-9b5c-ed9a17afe722	2.93	286.41	2.68	1.07	2026-04-26 07:32:34.886279	18
48f2ef4f-6f48-4a5a-8aca-e2844be19a4d	1.51	275.04	3.54	1.43	2026-04-26 07:32:34.886279	19
c4a5295a-ac7e-4505-ae47-069a3a50ecec	1.3	127.66	3.48	2.97	2026-04-26 07:32:34.886279	20
0cdc07b0-d122-4345-a871-ed8736125a13	1.91	153.75	3.13	2.3	2026-04-26 07:32:34.886279	21
8be3185b-bc1c-4142-b567-48aaff220b01	2.01	140.71	3.34	2.44	2026-04-26 07:32:34.886279	22
d9051e4d-d569-4f01-89e0-7d857762afe5	0.53	149.81	2.28	1.71	2026-04-26 07:32:34.886279	23
3fad7c09-4ab3-4a8b-aa29-7211513f7237	2.71	105.34	3.15	1.53	2026-04-26 07:32:34.886279	24
dbbf360e-7216-4601-8614-038fe1dcc2ba	0.58	266.88	2.75	1.76	2026-04-26 07:32:34.886279	25
9bd9f3c5-1b49-4927-8cdf-35373636ae00	0.99	263.41	1.37	2.13	2026-04-26 07:32:34.886279	26
160d3adf-6a5a-4442-8c35-f8ff730e0036	3.43	260.27	3.75	2.29	2026-04-26 07:32:34.886279	27
5c42027f-8aaa-441b-990e-215c05fc0300	2.31	108.32	1.55	2	2026-04-26 07:32:34.886279	28
bfc1d7fb-6dd6-42fd-a795-053bca272428	1.2	196.16	3.29	2.11	2026-04-26 07:32:34.886279	29
fe19663b-26a2-40d0-a329-bf3f1f6a25a6	1.09	189.33	2.74	2.76	2026-04-26 07:32:34.886279	30
09bcbc34-b01a-4878-88ae-4aac9ea91b2d	2.94	230.64	1.36	1.41	2026-04-26 07:32:34.886279	31
28aa7be3-ebf0-4bfb-9e4d-8eb57e7a1a09	1.35	170.7	2.48	2.19	2026-04-26 07:32:34.886279	32
a463568f-08c1-4eee-ba9f-87eca478959e	3.04	170.91	1.94	2.68	2026-04-26 07:32:34.886279	33
e91e2255-deed-4ffc-9e86-da19ee4fe2be	3.13	210.04	2.7	2.72	2026-04-26 07:32:34.886279	34
e6c3818b-29f0-4e36-9052-5e1482339405	2.78	159	2.68	2.03	2026-04-26 07:32:34.886279	35
80d81f80-2426-4c17-9e8a-321da7361798	1	187.76	1.84	1.84	2026-04-26 07:32:34.886279	36
6f817b31-ed87-46bb-9e2e-1140f4cb4cbb	3.17	82.04	2.51	2.89	2026-04-26 07:32:34.886279	37
34c9e297-d7dc-4168-a5a5-8e7e148dcbbd	1.87	237.08	3.75	1.38	2026-04-26 07:32:34.886279	38
06c52bbf-cbe5-4db7-997a-9f747283665e	0.66	55.83	1.43	1.34	2026-04-26 07:32:34.886279	39
0404794e-0a50-4824-a0ee-921cb23888ee	0.67	180.6	1.55	2.96	2026-04-26 07:32:34.886279	40
ff75e776-7227-4220-9f32-33a6013ae67f	2.75	254.37	1.79	1.63	2026-04-26 10:46:37.811973	41
522e7eca-7dde-4bb5-9cfd-7bfc1f5aa823	2.17	273.41	2.05	2.27	2026-04-26 10:46:37.811973	42
0670c059-cbff-4d6e-97fa-c2dbd81ba878	1.39	241.07	1.94	2.84	2026-04-26 10:46:37.811973	43
41623b9e-303f-46b1-82d3-8883c4a479bb	3.06	77.92	3.89	2.53	2026-04-26 10:46:37.811973	44
8425054a-27fe-45f7-a2d1-0ca5bb87c22d	2.94	184.94	2.53	1.42	2026-04-26 10:46:37.811973	45
88f2dc8f-4748-490e-b92d-e31ba6ddaf7b	1.07	219.87	3.61	1.45	2026-04-26 10:46:37.811973	46
71e03cf9-1c81-44c0-9c0f-63591e58aa30	1.95	253.78	1.03	1.15	2026-04-26 10:46:37.811973	47
bc2f02a5-cb1e-4610-ac0e-ba7f24c18ccd	2.55	269.56	1.34	1.31	2026-04-26 10:46:37.811973	48
c110010b-1088-4e02-be3c-83c511d7831c	1.01	176.38	3.05	2.17	2026-04-26 10:46:37.811973	49
fe8407a5-d6f0-4b63-b0c1-71ad87ffab96	1.34	148.97	1.35	1.56	2026-04-26 10:46:37.811973	50
19646a15-fc51-45ea-b837-9703ea5e5f8c	0.54	216.64	3.69	2.6	2026-04-26 10:46:40.513404	51
048313b2-21ec-4fbc-be08-2f0c27fa77f6	3.14	78.69	2.06	2.56	2026-04-26 10:46:40.513404	52
66ae13b0-bc41-401b-919a-a47c2d82b9ef	2.54	70.37	1.26	1.17	2026-04-26 10:46:40.513404	53
d87f65c7-d638-4f26-a825-aff5ae57457b	0.83	185.89	1.62	2.72	2026-04-26 10:46:40.513404	54
7931d397-9cb6-40aa-888c-6b1cfe481a74	3.27	233.37	2.99	1.55	2026-04-26 10:46:40.513404	55
a63e2468-ff52-45a6-a5cd-59944a3859bb	3.23	227.96	1.77	1.69	2026-04-26 10:46:40.513404	56
2c170f3c-70f5-4432-9675-baa82539a713	1.65	235.25	3.23	1.96	2026-04-26 10:46:40.513404	57
a49a8d86-d915-4488-b843-de71b33e91fd	2.04	145.44	1.27	1.41	2026-04-26 10:46:40.513404	58
b2cd1843-50e3-475c-b68b-24bcf035d14a	2.1	205.22	2.98	2.57	2026-04-26 10:46:40.513404	59
49214cd6-15b3-43e2-b004-f11980bd76e7	1.52	145.88	1.27	2.41	2026-04-26 10:46:40.513404	60
da38da3e-9316-49d8-af58-cfca2be2ecea	2.91	63.59	3.86	2.63	2026-04-26 10:46:42.673977	61
06e503be-bdf4-4afe-9252-ad4307d77d34	3.48	62.73	1.8	2.11	2026-04-26 10:46:42.673977	62
e07bf42f-e0df-4ae0-8b19-59673c872bf2	1.83	142.58	3.07	1.78	2026-04-26 10:46:42.673977	63
d9ff0e43-523c-4157-b412-c6e488086313	3.13	72.09	1.25	2.99	2026-04-26 10:46:42.673977	64
73605445-18c0-4c79-aa20-abe75a2aa504	1.99	101.95	2.86	1.52	2026-04-26 10:46:42.673977	65
17d1d4a8-7fff-4e9d-be6b-1ad8cff6ebd6	1.85	261.39	1.69	2.36	2026-04-26 10:46:42.673977	66
0ff59da4-ea9a-48c5-9b60-96f17e2644b7	2.9	160.6	1.09	2.69	2026-04-26 10:46:42.673977	67
0c867821-28e1-489c-96ef-a33a16f96004	0.86	287.7	1.87	2.03	2026-04-26 10:46:42.673977	68
6111d377-0b6c-4d93-b288-f7ebce6c00fc	2.73	192.8	1.91	1.13	2026-04-26 10:46:42.673977	69
18905b39-d6a0-4f41-8c02-9b817e1b009d	2.79	291.57	1.57	2.02	2026-04-26 10:46:42.673977	70
8b417aee-680e-4081-85f2-5a160fb2ff12	2.62	53.61	2.75	2.67	2026-04-26 10:46:45.066541	71
38b482a7-1f32-4ddc-9349-bcf1da86d546	3.37	135.71	1.32	2.13	2026-04-26 10:46:45.066541	72
02152a87-fd48-4156-bd2f-afe94c4dc7a6	1.04	254.71	2.11	1.32	2026-04-26 10:46:45.066541	73
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.75	157.63	3.99	1.01	2026-04-26 10:46:45.066541	74
79cd4a3f-adcf-4ce5-9d29-62693c93adf2	3.11	211.85	2.2	1.03	2026-04-26 10:46:45.066541	75
c4391873-3533-4cad-977b-0323fced348e	0.99	235	3.81	1.07	2026-04-26 10:46:45.066541	76
c6338c80-214f-405b-9b0b-7594bb69d230	2.14	143.6	2.79	1.39	2026-04-26 10:46:45.066541	77
382f3f60-7d3c-4ffc-8b2f-94ce32b77254	3.49	217.61	2.75	2.5	2026-04-26 10:46:45.066541	78
cf827a4b-a720-4825-84d4-29f047763f7e	0.98	133.07	2.11	2.62	2026-04-26 10:46:45.066541	79
d5806c60-9752-4845-9128-964d9b723f0b	0.95	107.46	1.91	1.44	2026-04-26 10:46:45.066541	80
96e0af22-02e2-46d4-8224-4db162bd27b6	0.6	112.55	1.67	2.84	2026-04-26 10:46:47.648953	81
9d0c77f5-485a-477d-80ec-8da875eb9852	1.96	152.11	1.75	2.79	2026-04-26 10:46:47.648953	82
c19c4f6a-3738-436e-b7dc-b27df3129b28	1.39	292.48	3.29	2.75	2026-04-26 10:46:47.648953	83
2d78aa7b-b8fb-4cc0-9d8a-f6a927032041	3.33	284.07	2.92	1.27	2026-04-26 10:46:47.648953	84
dbebf850-836f-4532-807c-c1e3f5b5d597	1.16	53.88	3.29	2.4	2026-04-26 10:46:47.648953	85
453f03e0-cb8d-4681-b343-d681f27e84f8	0.54	192.37	3.38	2.25	2026-04-26 10:46:47.648953	86
13d5f24a-3280-4db1-ae8d-4e7ac37dca9d	3.26	61.4	3.2	1.47	2026-04-26 10:46:47.648953	87
40f8a8d7-327f-4f20-a15c-cbd9fb6f5e75	3.39	122.91	3.17	2.18	2026-04-26 10:46:47.648953	88
8cfcaf67-4ae0-46c6-996e-6ce551b4096d	0.71	126.87	3.39	2.14	2026-04-26 10:46:47.648953	89
05bb5c72-6613-4d45-a876-a6c5fb64222e	2.02	226.59	1.02	1.81	2026-04-26 10:46:47.648953	90
37b80a41-5dec-4adb-ac19-126072ec4a13	3.02	144.71	2.78	2.96	2026-04-26 11:04:19.95742	91
514c19e7-d8eb-4f8a-b58c-db01659e571e	0.98	199.32	1.38	2.04	2026-04-26 11:04:19.95742	92
27ded357-dfee-45c6-844b-2108e05a105b	2.8	77.45	3.8	2.28	2026-04-26 11:04:19.95742	93
affc16bb-f7a4-4ff2-90df-48caf7eebddc	2.8	71.99	2.78	2.58	2026-04-26 11:04:19.95742	94
62b7cf0d-cf31-493a-85aa-8fa347acda25	0.98	262.66	3.19	1.63	2026-04-26 11:04:28.11927	95
ab3db038-d69b-451e-bba3-08e8119898b4	3.34	221.34	2.03	2.94	2026-04-26 11:04:30.969848	96
678ae26f-569d-4c0e-b4a9-0a688fc0936a	1.26	67.3	3.93	1.54	2026-04-26 12:07:42.172856	97
6438657c-ee67-48b5-8de0-62eeb64e0a87	1.82	120.6	3.64	2.48	2026-04-26 12:07:42.172856	98
e3216b17-e320-4d0f-ada0-b93e60caca02	2.28	153.57	1.17	2.38	2026-04-26 12:07:42.172856	99
63188d13-0344-4b51-aa79-19ea416c8cdd	2.65	270.6	3.33	1.17	2026-04-26 12:07:42.172856	100
17932bb9-836e-4db9-b27e-bd1b2f574954	2.11	292.02	3.58	2.04	2026-04-26 12:07:42.172856	101
459418c3-7fb1-4dd5-9c2b-6a0eb1e128a7	1.68	225.07	3.67	2.71	2026-04-26 12:07:42.172856	102
4d88229f-55e4-476b-bfc0-096795c485e4	3.05	128.84	1.13	2.96	2026-04-26 12:07:42.172856	103
2ce612e7-1b0e-4a98-aab2-d00e087e7acd	1.93	284.33	1.22	1.05	2026-04-26 12:07:42.172856	104
f1c04ba0-d43a-4055-8726-0674ce5a9591	2.59	232.64	2.83	2.29	2026-04-26 12:07:42.172856	105
b4617646-5ec4-4d15-a573-c29cffb7c27f	1.3	63.33	2.89	1.45	2026-04-26 12:07:42.172856	106
c02600b3-e48e-4409-95a3-eb683e336b10	2.63	86.76	1.99	2.84	2026-04-26 12:07:42.172856	107
fc365d4b-670e-4fca-8c15-bed27e9c7c64	2.76	165.75	3.97	2.05	2026-04-26 12:07:42.172856	108
cb0fe3b7-fbc8-479b-bd12-6acfeeeeffeb	2.69	226.65	1.62	1.9	2026-04-26 11:04:19.95742	109
c0f13516-b42b-4edf-8d54-260ed3432c91	1.06	263.91	2.23	2.55	2026-04-26 11:04:19.95742	110
a6b3ffd9-c2dc-4bf3-872f-1d4dfaff44ce	0.98	123.08	3.23	2.7	2026-04-26 11:04:19.95742	111
4c18584e-0e3e-40cc-94a4-dd6106965efb	3.23	228.87	1.68	2.45	2026-04-26 11:04:19.95742	112
42be6f12-2662-427d-b3bb-9f8fb042cde5	3.35	195.73	1.13	1.01	2026-04-26 11:04:19.95742	113
a9a3a5fa-5c98-4e69-883b-2afa82b1877f	3.28	297.49	3.62	1.1	2026-04-26 11:04:19.95742	114
69ceb13d-c6ba-480a-9bb6-8c94350b80bb	1.69	120.62	2.81	2.79	2026-04-26 11:04:22.715221	115
6946eb18-50ec-477c-808d-f71c98670e15	1.21	107.37	1.84	2.71	2026-04-26 11:04:22.715221	116
db738178-6c85-4003-814c-43efae201f66	2.43	236.96	2.16	1.11	2026-04-26 11:04:22.715221	117
4b5f92c9-7d51-4b0e-a137-acd779a460c0	1.68	226.57	1.68	1.58	2026-04-26 11:04:22.715221	118
343b8afa-f5f3-413a-8faf-37c6af937323	1.99	224.37	3.29	2.08	2026-04-26 11:04:22.715221	119
aa3eddc8-b910-47a9-b691-2ec377a4b6c3	2.63	87.33	3.44	2.5	2026-04-26 11:04:22.715221	120
10412ce9-7326-4907-98fb-f30f329eb834	1.27	76.08	3.33	2.98	2026-04-26 11:04:22.715221	121
a7a83b3b-4904-468d-b1ff-79250bae2178	1.88	88.49	3.07	2.4	2026-04-26 11:04:22.715221	122
de64100b-0d55-4423-8139-e21bf67b1ba3	2.78	136.36	2.69	2.67	2026-04-26 11:04:22.715221	123
48f1cae9-db76-406a-84c3-4b1d3fd1f646	3.2	219.85	1.44	1.78	2026-04-26 11:04:22.715221	124
bff99142-a62f-4628-a6ff-c053c6deb013	0.55	261.31	3.07	1.12	2026-04-26 11:04:22.715221	125
fb073968-3588-453a-85e2-75089d4c03f1	1.7	64.61	3.45	1.55	2026-04-26 11:04:22.715221	126
377f4e07-93cb-4351-8c6b-62851338fdb0	2.32	251.15	3.15	2.42	2026-04-26 11:04:22.715221	127
19bdfc5a-e1d0-463a-b163-7d7a692f73b8	1.36	265.1	1.43	2.51	2026-04-26 11:04:22.715221	128
cbd20eb0-7239-4734-b82b-404600e7d66b	1.19	133.12	1.81	1.75	2026-04-26 11:04:22.715221	129
18c3479d-2072-411f-8d91-9a580608c627	1.53	169.47	3.27	1.53	2026-04-26 11:04:22.715221	130
ca09ced3-7738-4c9e-887f-d34312c3d8e4	1.42	143.02	2.03	1.47	2026-04-26 11:04:22.715221	131
07a6b221-981a-4cce-bb5d-3d5a872c97b7	2.75	197.84	2.73	2.05	2026-04-26 11:04:22.715221	132
fa753e0b-bcb9-41b7-9c82-6fccd2333db1	1.65	217.61	1.62	1.3	2026-04-26 11:04:22.715221	133
100a7e1e-99f2-4b0d-8a9d-842a454a612f	1.84	164.83	2.09	1.53	2026-04-26 11:04:22.715221	134
41bd264e-1eb3-4ccb-ab43-221d92913239	2.66	152.97	1.13	2.55	2026-04-26 11:04:25.397346	135
b80e97e3-fe08-465e-ac72-eea64d2d6182	2.18	283.27	1.51	2.5	2026-04-26 11:04:25.397346	136
ed596397-26d6-4d02-a2f1-dbbf5f8ab704	3.14	124.06	1.71	1.2	2026-04-26 11:04:25.397346	137
5d36c463-e893-43a2-b567-1e7fbcb3c80c	0.95	138.24	1.75	2.71	2026-04-26 11:04:25.397346	138
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	2.99	233.65	3.98	1.88	2026-04-26 11:04:25.397346	139
b611f2f3-4dce-4565-9634-c5f67f16841f	1.88	184.23	2.15	1.92	2026-04-26 11:04:25.397346	140
af16d415-a7a8-426f-8d38-2ade72d8acb5	2.64	235.81	2.1	2.39	2026-04-26 11:04:25.397346	141
a18f9d90-4ce4-4793-a9c1-9452712601a3	2.4	264.8	3.64	1.68	2026-04-26 11:04:25.397346	142
2421d8dc-3548-4b72-b606-b235ecdf5448	0.95	78.08	3	1.87	2026-04-26 11:04:25.397346	143
bb6389a5-9e20-4135-8648-8a813bb296b7	2.1	269	3.57	2.18	2026-04-26 11:04:25.397346	144
6447b600-e734-4067-87b1-b915998722b4	2.65	102.57	2.72	1.42	2026-04-26 11:04:25.397346	145
a1fc9f0b-f1e6-4819-9cb5-1ce77541a1b5	2.02	132.06	3.83	1.1	2026-04-26 11:04:25.397346	146
25df9dd3-d744-4a1e-a96b-d1322d6952f5	1.16	161.9	3.24	1.63	2026-04-26 11:04:25.397346	147
8e3909e7-8ee5-4db8-9278-087d2851a6f1	2.24	188.7	2.79	2.48	2026-04-26 11:04:25.397346	148
3fcc2af3-e524-4b65-9649-cc48a58b7463	1.56	103.56	3.82	1.14	2026-04-26 11:04:25.397346	149
3045ab21-e78f-41cf-9f96-102cfd907777	1.73	147.54	1.87	1.13	2026-04-26 11:04:25.397346	150
211e6d92-06f3-4968-ab18-4d3606fb0313	1.46	179.24	3.57	2.02	2026-04-26 11:04:25.397346	151
577c5ceb-5d82-4a67-914e-cc3249432558	1.56	125.4	3.09	2.61	2026-04-26 11:04:25.397346	152
a9955bda-fedb-44d9-b5a6-33b7ceff70cc	1.03	135.12	1.13	2.61	2026-04-26 11:04:25.397346	153
cac6b96e-6c77-4c20-b201-5d059367fbf0	2.42	91.14	2.44	1.74	2026-04-26 11:04:25.397346	154
40b83090-1da5-4f1a-85d6-884f75d306d9	2.68	272.98	2.98	1.07	2026-04-26 11:04:28.11927	155
af6f8bce-ab49-4a79-a40c-4a4aba8d8552	3.15	299.99	1.62	1.4	2026-04-26 11:04:28.11927	156
7674a04d-8f67-4d07-9eab-998e344a03c9	1.29	241.02	3.69	2.5	2026-04-26 11:04:28.11927	157
f97b5670-ef68-4a86-97c0-6385e6ae7405	1.58	64.77	3.95	2.13	2026-04-26 11:04:28.11927	158
4fc26046-1ae2-4e60-99cf-95ef8ee6524a	3.42	118.79	3.56	1.45	2026-04-26 11:04:28.11927	159
e332ef09-be23-4a9d-b003-f886bfae870d	1.78	237.93	2.25	2.18	2026-04-26 11:04:28.11927	160
88f0fd74-5fbe-402b-b1f9-8b0185f9b042	2.12	155.51	1.54	1.12	2026-04-26 11:04:28.11927	161
7289ae0e-9605-4d46-aaee-5b05ddd96e59	3.04	109.39	3.79	2.3	2026-04-26 11:04:28.11927	162
b0318b61-a090-47a1-a30e-1f29ba099262	1.35	164.21	3.65	1.52	2026-04-26 11:04:28.11927	163
26ec3ee2-f140-4f43-b13b-9299796dd2d1	1.65	287.3	2.77	1.96	2026-04-26 11:04:28.11927	164
9dab24c7-177d-4ec4-8c0b-2323b92d3d4a	0.86	70.16	1.72	2.16	2026-04-26 11:04:28.11927	165
1a6d5e85-787b-461f-8db7-9cd8f8d81ece	1.19	140.15	1.02	1.82	2026-04-26 11:04:28.11927	166
27b23042-92c6-4a49-b397-6c200041d8ee	1.44	109.88	2.72	2.28	2026-04-26 11:04:28.11927	167
08f0acf7-18ec-45eb-8146-8042969d5c7a	1.61	81.7	2.2	1.31	2026-04-26 11:04:28.11927	168
a03af7ca-2046-499e-b19d-b6571e696f89	1.37	53.03	3.76	1.28	2026-04-26 11:04:28.11927	169
e7fd011f-5572-4ee9-a3de-2d9d4d5c818d	1.81	199.51	3.37	1.07	2026-04-26 11:04:28.11927	170
4065ab51-f74f-42a2-9363-7146df43c932	2.98	144.56	3.4	1.81	2026-04-26 11:04:28.11927	171
a07f2ed2-35ae-4720-ad65-a22fe59566d3	0.5	239.02	1.69	1.32	2026-04-26 11:04:28.11927	172
02c4237f-a7f5-452b-82c3-1fe296af3c3c	3.33	82.79	1.95	2.07	2026-04-26 11:04:28.11927	173
b685932b-8a27-4288-8795-f6e05e9e4cef	2.58	247.56	2.7	1.34	2026-04-26 11:04:30.969848	174
9cd7e4f4-8d1a-48da-abbc-075218e9e7a6	3.31	141.89	2.83	2.57	2026-04-26 11:04:30.969848	175
98d2ddcf-4cfa-4405-9501-d661884b1017	2.39	134.39	2.36	2.37	2026-04-26 11:04:30.969848	176
d0655207-0783-4e94-98d2-176fe26849d8	3.21	149.18	1.96	2.81	2026-04-26 11:04:30.969848	177
bcad4d42-8a4f-4b72-a2e1-b607651d5c31	1.91	240.04	3.79	1.54	2026-04-26 11:04:30.969848	178
9ed4929a-d3c0-4954-b272-227a89cbedec	2.05	153.87	3.52	1.93	2026-04-26 11:04:30.969848	179
edcb7d15-e6ed-461f-b1b4-38a993ff2ec7	1.58	207.45	1.57	2.2	2026-04-26 11:04:30.969848	180
2f5d7c02-eadd-4eb2-8dd5-46a5ba51c3f8	1.7	216.69	1.24	1.19	2026-04-26 11:04:30.969848	181
0ad0a6eb-d13c-440c-b74c-0391605d9685	1.87	219.23	3.15	2.36	2026-04-26 11:04:30.969848	182
2bb8c959-19b6-4951-8313-e6d0413c9a6f	2.5	209.88	3.58	2.96	2026-04-26 11:04:30.969848	183
303a312c-4f87-408c-b20b-03d848ec9055	2.02	286.26	1.86	2.92	2026-04-26 11:04:30.969848	184
a32bfdcd-5dd9-4a93-85e7-c1e608df83ee	2.48	234.14	3.61	1.98	2026-04-26 11:04:30.969848	185
5ccc6390-43ca-49f5-b6fa-84247d3e52af	1.65	238.58	1.85	1.58	2026-04-26 11:04:30.969848	186
df299e49-61f2-49ce-8051-e50cfc0b2650	0.55	207.62	1.84	1.2	2026-04-26 11:04:30.969848	187
86ef6ade-b308-467a-8c42-3c6e4c20ec8d	1.94	298.99	3.74	2.99	2026-04-26 11:04:30.969848	188
e318d53f-7605-468a-b41d-051070be96a3	2.32	232.22	3.6	1.74	2026-04-26 11:04:30.969848	189
efc0c233-0113-480b-b3e6-ca3275b5ffde	3.23	278.08	1.42	1.79	2026-04-26 11:04:30.969848	190
5808ae27-83d1-4163-9187-6a23f988dc97	3.32	159.43	3.42	1.42	2026-04-26 11:04:30.969848	191
e304e2e6-fd72-4399-b4d7-fb6416b81f0c	1.12	255.77	2.9	1.5	2026-04-26 11:04:30.969848	192
b5bfff34-218c-48cd-b9ce-673eea91bda1	0.6	154.32	3.23	2.67	2026-04-26 12:07:42.172856	193
0ef3d984-2e82-4672-bcd6-c49dfd8397b3	1.47	196.17	3.21	2.93	2026-04-26 12:07:42.172856	194
869589e4-a12e-4a97-9558-0e078bfadd07	3.08	243.15	3.78	1.14	2026-04-26 12:07:42.172856	195
fc37eb73-af1d-4f66-ab8d-ac6cd664ceea	2.11	88.54	3.24	2.67	2026-04-26 12:07:42.172856	196
f182189b-b6e2-4aee-bb22-5b1e555815b6	0.91	242.93	1.99	1.75	2026-04-26 12:07:42.172856	197
4a03155b-1956-495a-aa04-f02a9c3d31c8	1.02	158.73	2.58	2.12	2026-04-26 12:07:42.172856	198
6b9cb1d4-e93d-40cb-8099-44f30eae119b	0.63	282.01	3.89	2.46	2026-04-26 12:07:42.172856	199
77c9a885-1040-44e4-8b7c-18dccb3b1a81	3.13	89.02	3.08	2.79	2026-04-26 12:07:42.172856	200
ab089221-71a5-4b3c-a06e-445f999eed0a	2.01	75.93	1.19	2.97	2026-04-26 12:07:45.982563	201
2954b16d-0db5-4232-8923-ca1c2a81be0a	1.99	219.94	2.33	1.59	2026-04-26 12:07:45.982563	202
e072183d-f51e-4965-a227-e111304e8104	1.59	174.12	3.78	2.47	2026-04-26 12:07:45.982563	203
d59dcfa3-ec8d-4789-81cd-22e13a9c829c	2.72	123.96	2.4	1.86	2026-04-26 12:07:45.982563	204
e32ad455-b5bd-49ef-b295-f81c8a11da16	3.48	126.88	2.28	1.25	2026-04-26 12:07:45.982563	205
21d6e120-8fa3-4a51-9ade-436c7d77e075	0.85	176.43	2.12	2.42	2026-04-26 12:07:45.982563	206
efff145d-5625-4a2c-ac23-ffdccad3e85b	1.75	178.56	2.74	2.46	2026-04-26 12:07:45.982563	207
1a64a717-44a3-4308-9eaa-d6a37163544c	1.76	74.68	2.67	1.83	2026-04-26 12:07:45.982563	208
474c6490-57e2-4c5c-ad69-dc1c4cf6b1f5	1.49	189.97	3.26	1.18	2026-04-26 12:07:45.982563	209
7f85773c-30b2-4ff2-877a-93f568213806	2.39	276.35	2.63	1.1	2026-04-26 12:07:45.982563	210
4d87ace7-e3ee-4ea4-92f6-c395ef501428	1.25	168.83	3.3	1.1	2026-04-26 12:07:45.982563	211
4d289278-e3f8-42ed-af6a-2d3259072f3f	0.8	70.2	1.3	1.93	2026-04-26 12:07:45.982563	212
ebffe864-14eb-465e-b745-192f6e5717bf	1.17	154.92	1.39	1.07	2026-04-26 12:07:45.982563	213
fb9a49ca-e5e2-4be1-9e2c-5d77c4db770b	2.77	53.32	1.33	1.79	2026-04-26 12:07:45.982563	214
150f7991-fbd0-429e-bdf9-c60b50b1aae6	0.83	207.75	2.87	2.12	2026-04-26 12:07:45.982563	215
569b5e54-a5e6-442c-94e0-64a8245dcd07	0.71	77.76	1.14	2.54	2026-04-26 12:07:45.982563	216
1525c80d-cf06-4108-bab9-0205f6ed78f7	0.76	218.9	2.11	2.85	2026-04-26 12:07:45.982563	217
c6e7314c-8525-4191-80c2-2c3a921f415d	2.13	188.74	2.64	2.62	2026-04-26 12:07:45.982563	218
01d04063-d9c3-43b8-9cd1-f2c365206958	2.39	224.66	1.16	1.56	2026-04-26 12:07:45.982563	219
688a8c3f-fa38-4308-89d5-212d6faf8a77	1.44	265	3.77	2.33	2026-04-26 12:07:45.982563	220
80f0e0e1-a56b-4969-9328-300dd7d3889e	1.07	190.72	2.62	2.74	2026-04-26 12:07:48.434499	221
bf4c1fb6-a269-4569-be90-6b6a998ee7b9	2.87	299.93	2.26	2.99	2026-04-26 12:07:48.434499	222
4421a7a4-be54-4494-b732-9068a725e9b7	1.23	276.23	3.57	1.63	2026-04-26 12:07:48.434499	223
5d9bfdd7-0a23-41a4-bff6-1d1b588e6b78	1.3	178.52	2.65	2.16	2026-04-26 12:07:48.434499	224
9272aa0e-60be-48a7-b1a9-e260a3fcd3d2	0.81	88.28	2.19	2.12	2026-04-26 12:07:48.434499	225
cd6c4c38-b00a-4644-b1a1-7fc4b8c0ef46	3.4	50.44	3.84	1.12	2026-04-26 12:07:48.434499	226
903c34b0-9809-44ee-af0c-97ca045cde31	1.75	78.77	2.52	2.91	2026-04-26 12:07:48.434499	227
ec564929-5d5d-4964-85c9-c2c00181550b	1.17	108.57	3.13	2.28	2026-04-26 12:07:48.434499	228
eb5b0417-51b7-4630-89a7-fbac16715f99	0.61	138.58	1.43	1.21	2026-04-26 12:07:48.434499	229
2f71377b-f84e-4d62-a2dd-610ad858eff9	2.64	52.51	2.56	1.31	2026-04-26 12:07:48.434499	230
ccefa4d3-0ac6-49b4-b548-44dbecf95314	1.99	226.27	1.69	2.16	2026-04-26 12:07:48.434499	231
641085c9-c0f6-4e22-ba3b-1fb94f36d101	0.92	248.98	2.84	2.73	2026-04-26 12:07:48.434499	232
98771193-9965-407f-9a85-7fede6b77203	2.02	238.14	3.36	2.29	2026-04-26 12:07:48.434499	233
a4f48f59-b6eb-49b5-bda3-c4cbe0959ccc	0.58	192.78	1.77	2.62	2026-04-26 12:07:48.434499	234
349fd483-5e87-4860-902e-0499901d0595	0.62	270.99	2.1	1.23	2026-04-26 12:07:48.434499	235
9c9909c7-05a2-4227-acf9-28521c0da135	2.42	149.6	1.03	2.77	2026-04-26 12:07:48.434499	236
f305ad8e-b6cd-4ccb-8d44-e33845a294a1	3.16	278.84	3.71	1.78	2026-04-26 12:07:48.434499	237
baa2883c-e58b-4231-a08f-44235a4dea80	1.56	85.82	2.04	1.89	2026-04-26 12:07:48.434499	238
0d8f1e65-863d-45d8-bd85-f7a7bb2a19d6	2.01	230.22	3.01	1.76	2026-04-26 12:07:48.434499	239
1274b8fd-1c04-42fe-ae89-7ee5494a8909	1.72	217.61	2.76	2.71	2026-04-26 12:07:48.434499	240
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.75	157.63	3.99	1.01	2026-04-26 13:00:18.031288	241
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	2.99	233.65	3.98	1.88	2026-04-26 13:00:18.031288	242
fc365d4b-670e-4fca-8c15-bed27e9c7c64	2.76	165.75	3.97	2.05	2026-04-26 13:00:18.031288	243
f97b5670-ef68-4a86-97c0-6385e6ae7405	1.58	64.77	3.95	2.13	2026-04-26 13:00:18.031288	244
1798c0d0-79e4-4d2b-9f3f-990b125d2105	2.89	63.33	3.93	1.45	2026-04-26 13:00:18.031288	245
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.75	157.63	3.99	1.01	2026-04-26 13:01:27.548611	246
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.75	157.63	3.99	1.01	2026-04-26 13:01:27.548611	247
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	2.99	233.65	3.98	1.88	2026-04-26 13:01:27.548611	248
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	2.99	233.65	3.98	1.88	2026-04-26 13:01:27.548611	249
fc365d4b-670e-4fca-8c15-bed27e9c7c64	2.76	165.75	3.97	2.05	2026-04-26 13:01:27.548611	250
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.75	157.63	3.99	1.01	2026-04-26 13:06:37.00168	251
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.75	157.63	3.99	1.01	2026-04-26 13:06:37.00168	252
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.75	157.63	3.99	1.01	2026-04-26 13:06:37.00168	253
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.75	157.63	3.99	1.01	2026-04-26 13:06:37.00168	254
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	2.99	233.65	3.98	1.88	2026-04-26 13:06:37.00168	255
083b503f-bc9a-4761-9232-985118e3bde4	2.06	151.14	2.47	1.99	2026-04-26 13:06:38.026297	256
84898f92-b30c-4251-99c5-6d4b8ee07428	1.8	244.5	1.82	1.71	2026-04-26 13:06:38.026297	257
1798c0d0-79e4-4d2b-9f3f-990b125d2105	1.03	130.1	2.63	2.89	2026-04-26 13:06:38.026297	258
d4454c95-37c1-4467-a22e-9fb7abac08a2	2.71	134.89	1.43	2.33	2026-04-26 13:06:38.026297	259
1dc79f19-741d-4d47-8552-5e53debeed00	1.33	222.55	2.98	1.08	2026-04-26 13:06:38.026297	260
127074f4-ef1e-44c6-b9d4-6e159522fe6d	2.12	229.52	1.64	2.49	2026-04-26 13:06:38.026297	261
933c3358-c4a9-4190-ba36-d320f41b28bd	1.01	164.55	2.15	2.77	2026-04-26 13:06:38.026297	262
24c4b5e6-9375-4a3d-aa2e-8ecf73311e2a	2.21	61.6	3.2	1.33	2026-04-26 13:06:38.026297	263
8459b204-828a-433c-946a-16940b23fe20	2.02	131.87	1.79	1.41	2026-04-26 13:06:38.026297	264
6c67de4d-14df-473a-b5b7-234ca1892d36	0.8	64.54	2.79	1.27	2026-04-26 13:06:38.026297	265
1a1da762-8b17-44fc-ab54-aacee70233c0	2.13	211.09	2.67	1.18	2026-04-26 13:06:38.026297	266
eaf83308-161d-4cbe-9a8f-c87d75ee5421	1.73	200.87	1.54	1.47	2026-04-26 13:06:38.026297	267
2639cd66-3527-4a6d-b26e-dfb2491c1bf2	1.47	166.84	1.02	1.84	2026-04-26 13:06:38.026297	268
8d34dd99-e669-4ca7-99af-1d91991a09c9	3.23	146.8	3.28	2.2	2026-04-26 13:06:38.026297	269
77398e9d-8c73-4cfb-9019-93696911c12d	3.03	69.41	3.37	2.98	2026-04-26 13:06:38.026297	270
af79ed93-81e1-4dad-ab43-483f230ed7d4	3.07	63.68	2.45	1.32	2026-04-26 13:06:38.026297	271
a09b5914-31d8-4628-bfde-a2ed4f60f907	2.78	209.12	3.71	1.28	2026-04-26 13:06:38.026297	272
af5d64a0-8fd6-4135-9b5c-ed9a17afe722	2.92	187.62	2.58	2.72	2026-04-26 13:06:38.026297	273
48f2ef4f-6f48-4a5a-8aca-e2844be19a4d	2.44	115.94	3.43	2.67	2026-04-26 13:06:38.026297	274
c4a5295a-ac7e-4505-ae47-069a3a50ecec	3.18	270.78	2.3	1.86	2026-04-26 13:06:38.026297	275
0cdc07b0-d122-4345-a871-ed8736125a13	2.14	181.72	2.59	1.75	2026-04-26 13:06:38.026297	276
8be3185b-bc1c-4142-b567-48aaff220b01	1.22	120.14	2.13	1.73	2026-04-26 13:06:38.026297	277
d9051e4d-d569-4f01-89e0-7d857762afe5	2.7	91.03	3.26	2.85	2026-04-26 13:06:38.026297	278
3fad7c09-4ab3-4a8b-aa29-7211513f7237	2.62	298.03	3.64	1.19	2026-04-26 13:06:38.026297	279
dbbf360e-7216-4601-8614-038fe1dcc2ba	2.96	189.9	1.75	1.61	2026-04-26 13:06:38.026297	280
9bd9f3c5-1b49-4927-8cdf-35373636ae00	0.57	192.42	2.07	2.73	2026-04-26 13:06:38.026297	281
160d3adf-6a5a-4442-8c35-f8ff730e0036	0.53	53.92	1.69	1.28	2026-04-26 13:06:38.026297	282
5c42027f-8aaa-441b-990e-215c05fc0300	1.57	259.49	1.47	1.58	2026-04-26 13:06:38.026297	283
bfc1d7fb-6dd6-42fd-a795-053bca272428	2.68	237.8	3.78	1.53	2026-04-26 13:06:38.026297	284
fe19663b-26a2-40d0-a329-bf3f1f6a25a6	1.14	241.83	2.07	1.33	2026-04-26 13:06:38.026297	285
09bcbc34-b01a-4878-88ae-4aac9ea91b2d	2.34	140.38	1.36	2.18	2026-04-26 13:06:38.026297	286
28aa7be3-ebf0-4bfb-9e4d-8eb57e7a1a09	3.32	87.38	1.52	2.8	2026-04-26 13:06:38.026297	287
a463568f-08c1-4eee-ba9f-87eca478959e	2.9	188.73	1.87	1.37	2026-04-26 13:06:38.026297	288
e91e2255-deed-4ffc-9e86-da19ee4fe2be	0.76	73.97	3.81	1.87	2026-04-26 13:06:38.026297	289
e6c3818b-29f0-4e36-9052-5e1482339405	3.34	183.38	3.45	2.89	2026-04-26 13:06:38.026297	290
80d81f80-2426-4c17-9e8a-321da7361798	1.92	225.22	2.09	2.75	2026-04-26 13:06:38.026297	291
6f817b31-ed87-46bb-9e2e-1140f4cb4cbb	1.94	89.3	1.81	2.75	2026-04-26 13:06:38.026297	292
34c9e297-d7dc-4168-a5a5-8e7e148dcbbd	1.79	263.42	3.61	2.27	2026-04-26 13:06:38.026297	293
06c52bbf-cbe5-4db7-997a-9f747283665e	2.46	114.93	2.61	2.05	2026-04-26 13:06:38.026297	294
0404794e-0a50-4824-a0ee-921cb23888ee	1.18	138.73	1.39	2.57	2026-04-26 13:06:38.026297	295
ff75e776-7227-4220-9f32-33a6013ae67f	3.3	109.17	1.77	1.66	2026-04-26 13:06:38.026297	296
522e7eca-7dde-4bb5-9cfd-7bfc1f5aa823	0.57	114.95	3.67	1.2	2026-04-26 13:06:38.026297	297
0670c059-cbff-4d6e-97fa-c2dbd81ba878	1.26	254.19	1.69	2.08	2026-04-26 13:06:38.026297	298
41623b9e-303f-46b1-82d3-8883c4a479bb	1.66	208.95	2.57	1.46	2026-04-26 13:06:38.026297	299
8425054a-27fe-45f7-a2d1-0ca5bb87c22d	1.9	56.83	1.36	2.26	2026-04-26 13:06:38.026297	300
88f2dc8f-4748-490e-b92d-e31ba6ddaf7b	3.39	124.12	1.08	1.08	2026-04-26 13:06:38.026297	301
71e03cf9-1c81-44c0-9c0f-63591e58aa30	2.65	185.68	1.44	2.16	2026-04-26 13:06:38.026297	302
bc2f02a5-cb1e-4610-ac0e-ba7f24c18ccd	3.24	252.91	2.3	2.96	2026-04-26 13:06:38.026297	303
c110010b-1088-4e02-be3c-83c511d7831c	1.81	298.49	3.39	2.09	2026-04-26 13:06:38.026297	304
fe8407a5-d6f0-4b63-b0c1-71ad87ffab96	2.76	197.72	1.89	2.81	2026-04-26 13:06:38.026297	305
19646a15-fc51-45ea-b837-9703ea5e5f8c	3.23	170.33	3.46	2.39	2026-04-26 13:06:38.026297	306
048313b2-21ec-4fbc-be08-2f0c27fa77f6	2.84	142.33	2.58	1.66	2026-04-26 13:06:38.026297	307
66ae13b0-bc41-401b-919a-a47c2d82b9ef	1.39	135.25	2.38	1.2	2026-04-26 13:06:38.026297	308
d87f65c7-d638-4f26-a825-aff5ae57457b	1.29	155.65	1.63	1.92	2026-04-26 13:06:38.026297	309
7931d397-9cb6-40aa-888c-6b1cfe481a74	1.2	153.43	2.61	2.56	2026-04-26 13:06:38.026297	310
a63e2468-ff52-45a6-a5cd-59944a3859bb	3.2	202.64	3.27	1.28	2026-04-26 13:06:38.026297	311
2c170f3c-70f5-4432-9675-baa82539a713	2.21	93.64	1.09	1	2026-04-26 13:06:38.026297	312
a49a8d86-d915-4488-b843-de71b33e91fd	0.74	182.44	3.22	2.73	2026-04-26 13:06:38.026297	313
b2cd1843-50e3-475c-b68b-24bcf035d14a	2.31	249.28	3.3	2.78	2026-04-26 13:06:38.026297	314
49214cd6-15b3-43e2-b004-f11980bd76e7	3.1	83	2.37	1.92	2026-04-26 13:06:38.026297	315
da38da3e-9316-49d8-af58-cfca2be2ecea	3.48	201.42	2.43	1.2	2026-04-26 13:06:38.026297	316
06e503be-bdf4-4afe-9252-ad4307d77d34	3.21	57.87	3.77	1.52	2026-04-26 13:06:38.026297	317
e07bf42f-e0df-4ae0-8b19-59673c872bf2	1.44	221.08	2.06	1.63	2026-04-26 13:06:38.026297	318
d9ff0e43-523c-4157-b412-c6e488086313	2.14	291.1	3.29	2.68	2026-04-26 13:06:38.026297	319
73605445-18c0-4c79-aa20-abe75a2aa504	2.16	251.23	2.75	2.16	2026-04-26 13:06:38.026297	320
17d1d4a8-7fff-4e9d-be6b-1ad8cff6ebd6	2.43	173.65	3.35	2.15	2026-04-26 13:06:38.026297	321
0ff59da4-ea9a-48c5-9b60-96f17e2644b7	2.72	52.54	1.44	2.02	2026-04-26 13:06:38.026297	322
0c867821-28e1-489c-96ef-a33a16f96004	3.37	133.8	2.29	1.65	2026-04-26 13:06:38.026297	323
6111d377-0b6c-4d93-b288-f7ebce6c00fc	1.51	211	1.39	2.44	2026-04-26 13:06:38.026297	324
18905b39-d6a0-4f41-8c02-9b817e1b009d	1.86	161.79	3.93	2.32	2026-04-26 13:06:38.026297	325
8b417aee-680e-4081-85f2-5a160fb2ff12	2.03	255.98	3.13	2.35	2026-04-26 13:06:38.026297	326
38b482a7-1f32-4ddc-9349-bcf1da86d546	1.12	53.2	1.83	2.63	2026-04-26 13:06:38.026297	327
02152a87-fd48-4156-bd2f-afe94c4dc7a6	3.07	253.55	2.88	2.89	2026-04-26 13:06:38.026297	328
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.95	175.66	3.56	2.74	2026-04-26 13:06:38.026297	329
79cd4a3f-adcf-4ce5-9d29-62693c93adf2	2.12	108.69	3.46	2.51	2026-04-26 13:06:38.026297	330
c4391873-3533-4cad-977b-0323fced348e	1.43	57.22	2.77	1.36	2026-04-26 13:06:38.026297	331
c6338c80-214f-405b-9b0b-7594bb69d230	0.73	207.79	3.55	2.84	2026-04-26 13:06:38.026297	332
382f3f60-7d3c-4ffc-8b2f-94ce32b77254	1.72	170.78	3.43	1.62	2026-04-26 13:06:38.026297	333
cf827a4b-a720-4825-84d4-29f047763f7e	2.45	56.43	2.96	2.27	2026-04-26 13:06:38.026297	334
d5806c60-9752-4845-9128-964d9b723f0b	2.19	222.95	3.08	2.51	2026-04-26 13:06:38.026297	335
96e0af22-02e2-46d4-8224-4db162bd27b6	3.13	285.78	2.99	2.24	2026-04-26 13:06:38.026297	336
9d0c77f5-485a-477d-80ec-8da875eb9852	2.78	209.83	3.28	1.53	2026-04-26 13:06:38.026297	337
c19c4f6a-3738-436e-b7dc-b27df3129b28	2.54	161.31	1.78	1.22	2026-04-26 13:06:38.026297	338
2d78aa7b-b8fb-4cc0-9d8a-f6a927032041	1.37	76.85	2.47	1.21	2026-04-26 13:06:38.026297	339
dbebf850-836f-4532-807c-c1e3f5b5d597	1.76	53.78	1.66	1.71	2026-04-26 13:06:38.026297	340
453f03e0-cb8d-4681-b343-d681f27e84f8	2	194.64	1	1.86	2026-04-26 13:06:38.026297	341
13d5f24a-3280-4db1-ae8d-4e7ac37dca9d	1.03	234.3	2.92	2.94	2026-04-26 13:06:38.026297	342
40f8a8d7-327f-4f20-a15c-cbd9fb6f5e75	2.18	235.81	2.57	2.58	2026-04-26 13:06:38.026297	343
8cfcaf67-4ae0-46c6-996e-6ce551b4096d	2.81	200.88	3.9	1.92	2026-04-26 13:06:38.026297	344
05bb5c72-6613-4d45-a876-a6c5fb64222e	1.47	101.98	2.99	1.87	2026-04-26 13:06:38.026297	345
37b80a41-5dec-4adb-ac19-126072ec4a13	1.95	99.62	3.33	1.76	2026-04-26 13:06:38.026297	346
514c19e7-d8eb-4f8a-b58c-db01659e571e	3.01	173	2.07	2.11	2026-04-26 13:06:38.026297	347
27ded357-dfee-45c6-844b-2108e05a105b	1.56	250.22	2.9	2.45	2026-04-26 13:06:38.026297	348
affc16bb-f7a4-4ff2-90df-48caf7eebddc	3.26	291.67	3.97	1.53	2026-04-26 13:06:38.026297	349
cb0fe3b7-fbc8-479b-bd12-6acfeeeeffeb	1.86	218.35	1.28	2.66	2026-04-26 13:06:38.026297	350
c0f13516-b42b-4edf-8d54-260ed3432c91	2.3	247.29	2.5	2.05	2026-04-26 13:06:38.026297	351
a6b3ffd9-c2dc-4bf3-872f-1d4dfaff44ce	2.24	190.95	3.39	2.53	2026-04-26 13:06:38.026297	352
4c18584e-0e3e-40cc-94a4-dd6106965efb	0.52	121.23	3.4	1.51	2026-04-26 13:06:38.026297	353
42be6f12-2662-427d-b3bb-9f8fb042cde5	2.87	136.95	1.49	1.43	2026-04-26 13:06:38.026297	354
a9a3a5fa-5c98-4e69-883b-2afa82b1877f	2.51	202.21	2.97	2.46	2026-04-26 13:06:38.026297	355
69ceb13d-c6ba-480a-9bb6-8c94350b80bb	2.2	200.28	2	2.17	2026-04-26 13:06:38.026297	356
6946eb18-50ec-477c-808d-f71c98670e15	2.8	184.74	2.11	2.4	2026-04-26 13:06:38.026297	357
db738178-6c85-4003-814c-43efae201f66	0.78	102.72	1.04	1.87	2026-04-26 13:06:38.026297	358
4b5f92c9-7d51-4b0e-a137-acd779a460c0	2.97	229.26	2.13	1.08	2026-04-26 13:06:38.026297	359
343b8afa-f5f3-413a-8faf-37c6af937323	2	90.93	2.57	2.36	2026-04-26 13:06:38.026297	360
aa3eddc8-b910-47a9-b691-2ec377a4b6c3	2.35	57.69	3.25	1.6	2026-04-26 13:06:38.026297	361
10412ce9-7326-4907-98fb-f30f329eb834	3.34	102.16	1.93	1.27	2026-04-26 13:06:38.026297	362
a7a83b3b-4904-468d-b1ff-79250bae2178	2.07	267.38	1.15	1.91	2026-04-26 13:06:38.026297	363
de64100b-0d55-4423-8139-e21bf67b1ba3	3.39	176.25	2.82	2.86	2026-04-26 13:06:38.026297	364
48f1cae9-db76-406a-84c3-4b1d3fd1f646	1.63	183.38	1.78	2.1	2026-04-26 13:06:38.026297	365
bff99142-a62f-4628-a6ff-c053c6deb013	2.67	265.03	3.39	2.49	2026-04-26 13:06:38.026297	366
fb073968-3588-453a-85e2-75089d4c03f1	0.84	247.52	2.18	1.78	2026-04-26 13:06:38.026297	367
377f4e07-93cb-4351-8c6b-62851338fdb0	1.95	142.77	2.14	1.33	2026-04-26 13:06:38.026297	368
19bdfc5a-e1d0-463a-b163-7d7a692f73b8	3.05	180.59	2.2	1.45	2026-04-26 13:06:38.026297	369
cbd20eb0-7239-4734-b82b-404600e7d66b	1.05	190.24	2.56	1.68	2026-04-26 13:06:38.026297	370
18c3479d-2072-411f-8d91-9a580608c627	1.09	180.17	2.13	1.52	2026-04-26 13:06:38.026297	371
ca09ced3-7738-4c9e-887f-d34312c3d8e4	2.88	124.92	2.28	1.4	2026-04-26 13:06:38.026297	372
07a6b221-981a-4cce-bb5d-3d5a872c97b7	0.92	225.84	3.38	2.06	2026-04-26 13:06:38.026297	373
fa753e0b-bcb9-41b7-9c82-6fccd2333db1	1.34	145.44	3.65	1.2	2026-04-26 13:06:38.026297	374
100a7e1e-99f2-4b0d-8a9d-842a454a612f	3.05	188.12	1.66	2.24	2026-04-26 13:06:38.026297	375
41bd264e-1eb3-4ccb-ab43-221d92913239	0.89	85.21	2.83	1.57	2026-04-26 13:06:38.026297	376
b80e97e3-fe08-465e-ac72-eea64d2d6182	1.35	56.21	2.84	2.73	2026-04-26 13:06:38.026297	377
ed596397-26d6-4d02-a2f1-dbbf5f8ab704	1.64	193.95	1.36	1.53	2026-04-26 13:06:38.026297	378
5d36c463-e893-43a2-b567-1e7fbcb3c80c	2.81	225.06	3.09	2.15	2026-04-26 13:06:38.026297	379
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	2.25	146.2	2.93	1.4	2026-04-26 13:06:38.026297	380
b611f2f3-4dce-4565-9634-c5f67f16841f	2.94	105.62	1.01	1.35	2026-04-26 13:06:38.026297	381
af16d415-a7a8-426f-8d38-2ade72d8acb5	2.04	222.27	3.15	2.69	2026-04-26 13:06:38.026297	382
a18f9d90-4ce4-4793-a9c1-9452712601a3	2.17	255.77	3.21	2.97	2026-04-26 13:06:38.026297	383
2421d8dc-3548-4b72-b606-b235ecdf5448	0.92	206.5	1.93	2.03	2026-04-26 13:06:38.026297	384
bb6389a5-9e20-4135-8648-8a813bb296b7	0.9	289.47	1.17	2.25	2026-04-26 13:06:38.026297	385
6447b600-e734-4067-87b1-b915998722b4	1.39	105.87	1.13	2.36	2026-04-26 13:06:38.026297	386
a1fc9f0b-f1e6-4819-9cb5-1ce77541a1b5	2.04	233.32	3.78	2.42	2026-04-26 13:06:38.026297	387
25df9dd3-d744-4a1e-a96b-d1322d6952f5	1.42	72.75	2.33	2.36	2026-04-26 13:06:38.026297	388
8e3909e7-8ee5-4db8-9278-087d2851a6f1	1.59	69.78	2.35	1.61	2026-04-26 13:06:38.026297	389
3fcc2af3-e524-4b65-9649-cc48a58b7463	3.35	70.29	3.94	2.95	2026-04-26 13:06:38.026297	390
3045ab21-e78f-41cf-9f96-102cfd907777	1.95	286.13	2.69	2.92	2026-04-26 13:06:38.026297	391
211e6d92-06f3-4968-ab18-4d3606fb0313	3.12	68.02	3.2	1.39	2026-04-26 13:06:38.026297	392
577c5ceb-5d82-4a67-914e-cc3249432558	1.18	212.33	1.2	1.8	2026-04-26 13:06:38.026297	393
a9955bda-fedb-44d9-b5a6-33b7ceff70cc	2.79	260.73	2.97	2.99	2026-04-26 13:06:38.026297	394
cac6b96e-6c77-4c20-b201-5d059367fbf0	0.6	299.59	2.12	2.73	2026-04-26 13:06:38.026297	395
40b83090-1da5-4f1a-85d6-884f75d306d9	2.41	226.23	1.31	1.09	2026-04-26 13:06:38.026297	396
af6f8bce-ab49-4a79-a40c-4a4aba8d8552	1.31	279.61	3.39	1.21	2026-04-26 13:06:38.026297	397
7674a04d-8f67-4d07-9eab-998e344a03c9	0.92	106.45	2.14	1.4	2026-04-26 13:06:38.026297	398
f97b5670-ef68-4a86-97c0-6385e6ae7405	2.31	175.6	1.13	1.36	2026-04-26 13:06:38.026297	399
4fc26046-1ae2-4e60-99cf-95ef8ee6524a	1.47	251.82	2.1	1.91	2026-04-26 13:06:38.026297	400
e332ef09-be23-4a9d-b003-f886bfae870d	0.79	265.03	3.7	1.85	2026-04-26 13:06:38.026297	401
88f0fd74-5fbe-402b-b1f9-8b0185f9b042	2.27	141.32	2.97	2.18	2026-04-26 13:06:38.026297	402
7289ae0e-9605-4d46-aaee-5b05ddd96e59	1.35	136.22	2.47	1.48	2026-04-26 13:06:38.026297	403
b0318b61-a090-47a1-a30e-1f29ba099262	3.44	198.89	2.49	2.29	2026-04-26 13:06:38.026297	404
26ec3ee2-f140-4f43-b13b-9299796dd2d1	1.67	132.62	3.56	1.94	2026-04-26 13:06:38.026297	405
9dab24c7-177d-4ec4-8c0b-2323b92d3d4a	2.22	288.57	1.28	2.21	2026-04-26 13:06:38.026297	406
1a6d5e85-787b-461f-8db7-9cd8f8d81ece	3.14	178	3.03	1.11	2026-04-26 13:06:38.026297	407
27b23042-92c6-4a49-b397-6c200041d8ee	1.78	275.27	3.35	1.76	2026-04-26 13:06:38.026297	408
08f0acf7-18ec-45eb-8146-8042969d5c7a	1.11	150.8	1.93	2.42	2026-04-26 13:06:38.026297	409
a03af7ca-2046-499e-b19d-b6571e696f89	1.95	226.95	2.3	2.31	2026-04-26 13:06:38.026297	410
e7fd011f-5572-4ee9-a3de-2d9d4d5c818d	2.24	199.44	1.53	1.47	2026-04-26 13:06:38.026297	411
4065ab51-f74f-42a2-9363-7146df43c932	2.92	134.24	2.94	2.41	2026-04-26 13:06:38.026297	412
a07f2ed2-35ae-4720-ad65-a22fe59566d3	0.74	178.59	1.91	2.52	2026-04-26 13:06:38.026297	413
02c4237f-a7f5-452b-82c3-1fe296af3c3c	3.26	233.81	3.38	1.45	2026-04-26 13:06:38.026297	414
62b7cf0d-cf31-493a-85aa-8fa347acda25	3.5	98.66	2.14	1.61	2026-04-26 13:06:38.026297	415
ab3db038-d69b-451e-bba3-08e8119898b4	0.89	121.66	2.86	1.25	2026-04-26 13:06:38.026297	416
b685932b-8a27-4288-8795-f6e05e9e4cef	3.33	299.31	1.16	1.59	2026-04-26 13:06:38.026297	417
9cd7e4f4-8d1a-48da-abbc-075218e9e7a6	1.33	251.63	2.29	1.59	2026-04-26 13:06:38.026297	418
98d2ddcf-4cfa-4405-9501-d661884b1017	2.8	219.62	1.55	1.47	2026-04-26 13:06:38.026297	419
d0655207-0783-4e94-98d2-176fe26849d8	1.49	209.46	2.31	2.63	2026-04-26 13:06:38.026297	420
bcad4d42-8a4f-4b72-a2e1-b607651d5c31	2.25	126.61	3.3	1.54	2026-04-26 13:06:38.026297	421
9ed4929a-d3c0-4954-b272-227a89cbedec	2.43	214.74	2.34	2.17	2026-04-26 13:06:38.026297	422
edcb7d15-e6ed-461f-b1b4-38a993ff2ec7	2.96	249.37	1.87	2.86	2026-04-26 13:06:38.026297	423
2f5d7c02-eadd-4eb2-8dd5-46a5ba51c3f8	1.57	175.8	2.9	1.52	2026-04-26 13:06:38.026297	424
0ad0a6eb-d13c-440c-b74c-0391605d9685	2.78	131.46	2.45	1.81	2026-04-26 13:06:38.026297	425
2bb8c959-19b6-4951-8313-e6d0413c9a6f	3.41	286.6	1.49	1.21	2026-04-26 13:06:38.026297	426
303a312c-4f87-408c-b20b-03d848ec9055	1.72	161.8	2.36	2.35	2026-04-26 13:06:38.026297	427
a32bfdcd-5dd9-4a93-85e7-c1e608df83ee	3.38	276.23	3.14	1.65	2026-04-26 13:06:38.026297	428
5ccc6390-43ca-49f5-b6fa-84247d3e52af	0.51	203.31	3.2	2.97	2026-04-26 13:06:38.026297	429
df299e49-61f2-49ce-8051-e50cfc0b2650	0.88	283.07	2.71	2.75	2026-04-26 13:06:38.026297	430
86ef6ade-b308-467a-8c42-3c6e4c20ec8d	2.83	99.49	1.3	1.99	2026-04-26 13:06:38.026297	431
e318d53f-7605-468a-b41d-051070be96a3	2.91	142.42	3.69	2.57	2026-04-26 13:06:38.026297	432
efc0c233-0113-480b-b3e6-ca3275b5ffde	3.26	254.34	1.86	2.87	2026-04-26 13:06:38.026297	433
5808ae27-83d1-4163-9187-6a23f988dc97	0.73	79.17	1.19	2.85	2026-04-26 13:06:38.026297	434
e304e2e6-fd72-4399-b4d7-fb6416b81f0c	1.23	75.01	1.13	1.37	2026-04-26 13:06:38.026297	435
678ae26f-569d-4c0e-b4a9-0a688fc0936a	3.31	82.65	3.59	2.14	2026-04-26 13:06:38.026297	436
6438657c-ee67-48b5-8de0-62eeb64e0a87	3.41	145.28	3.07	2.55	2026-04-26 13:06:38.026297	437
e3216b17-e320-4d0f-ada0-b93e60caca02	1.38	97.48	1.9	2.79	2026-04-26 13:06:38.026297	438
63188d13-0344-4b51-aa79-19ea416c8cdd	3.07	146.33	2.89	2.77	2026-04-26 13:06:38.026297	439
17932bb9-836e-4db9-b27e-bd1b2f574954	0.72	169.04	1.08	2.9	2026-04-26 13:06:38.026297	440
459418c3-7fb1-4dd5-9c2b-6a0eb1e128a7	3.07	75.46	2.78	1	2026-04-26 13:06:38.026297	441
4d88229f-55e4-476b-bfc0-096795c485e4	3.03	79.76	2.72	1.33	2026-04-26 13:06:38.026297	442
2ce612e7-1b0e-4a98-aab2-d00e087e7acd	1.36	82.61	2.21	2.14	2026-04-26 13:06:38.026297	443
f1c04ba0-d43a-4055-8726-0674ce5a9591	1.74	248.85	3.25	2.2	2026-04-26 13:06:38.026297	444
b4617646-5ec4-4d15-a573-c29cffb7c27f	1.88	91.82	1.51	1.69	2026-04-26 13:06:38.026297	445
c02600b3-e48e-4409-95a3-eb683e336b10	2.58	275.58	3.31	1.89	2026-04-26 13:06:38.026297	446
fc365d4b-670e-4fca-8c15-bed27e9c7c64	1.29	159.44	1.25	2.41	2026-04-26 13:06:38.026297	447
b5bfff34-218c-48cd-b9ce-673eea91bda1	3.11	210.17	1.26	1.97	2026-04-26 13:06:38.026297	448
0ef3d984-2e82-4672-bcd6-c49dfd8397b3	0.87	195.59	1.28	1.23	2026-04-26 13:06:38.026297	449
869589e4-a12e-4a97-9558-0e078bfadd07	2.41	151.34	1.83	2.06	2026-04-26 13:06:38.026297	450
fc37eb73-af1d-4f66-ab8d-ac6cd664ceea	2.15	130.26	1.52	1.75	2026-04-26 13:06:38.026297	451
f182189b-b6e2-4aee-bb22-5b1e555815b6	1.07	242.87	3.09	1.56	2026-04-26 13:06:38.026297	452
4a03155b-1956-495a-aa04-f02a9c3d31c8	2.21	113.47	3.4	1.58	2026-04-26 13:06:38.026297	453
6b9cb1d4-e93d-40cb-8099-44f30eae119b	2.12	267.93	2.85	1.29	2026-04-26 13:06:38.026297	454
77c9a885-1040-44e4-8b7c-18dccb3b1a81	1.57	274.28	2.22	1.82	2026-04-26 13:06:38.026297	455
ab089221-71a5-4b3c-a06e-445f999eed0a	1.34	169.32	3.47	2.98	2026-04-26 13:06:38.026297	456
2954b16d-0db5-4232-8923-ca1c2a81be0a	1.8	275.82	2.52	2.09	2026-04-26 13:06:38.026297	457
e072183d-f51e-4965-a227-e111304e8104	1.86	186.2	1.2	2.27	2026-04-26 13:06:38.026297	458
d59dcfa3-ec8d-4789-81cd-22e13a9c829c	3.35	140.78	1.67	1.83	2026-04-26 13:06:38.026297	459
e32ad455-b5bd-49ef-b295-f81c8a11da16	2.26	58.2	2.54	1.36	2026-04-26 13:06:38.026297	460
21d6e120-8fa3-4a51-9ade-436c7d77e075	0.75	186.1	2.15	1.28	2026-04-26 13:06:38.026297	461
efff145d-5625-4a2c-ac23-ffdccad3e85b	3.19	213.49	3.47	2.38	2026-04-26 13:06:38.026297	462
1a64a717-44a3-4308-9eaa-d6a37163544c	3.16	186.69	1.19	2.25	2026-04-26 13:06:38.026297	463
474c6490-57e2-4c5c-ad69-dc1c4cf6b1f5	2.84	274.89	1.54	1.97	2026-04-26 13:06:38.026297	464
7f85773c-30b2-4ff2-877a-93f568213806	1.48	162.97	1.76	2.98	2026-04-26 13:06:38.026297	465
4d87ace7-e3ee-4ea4-92f6-c395ef501428	2.79	264.21	1.55	1.74	2026-04-26 13:06:38.026297	466
4d289278-e3f8-42ed-af6a-2d3259072f3f	2.64	280.48	3.7	1.7	2026-04-26 13:06:38.026297	467
ebffe864-14eb-465e-b745-192f6e5717bf	0.66	226.66	3.3	2.87	2026-04-26 13:06:38.026297	468
fb9a49ca-e5e2-4be1-9e2c-5d77c4db770b	3.32	186.84	1.09	2.24	2026-04-26 13:06:38.026297	469
150f7991-fbd0-429e-bdf9-c60b50b1aae6	1.31	224.28	3.76	1.68	2026-04-26 13:06:38.026297	470
569b5e54-a5e6-442c-94e0-64a8245dcd07	3.17	207.7	2.32	2.81	2026-04-26 13:06:38.026297	471
1525c80d-cf06-4108-bab9-0205f6ed78f7	3.06	92.68	2.59	2.18	2026-04-26 13:06:38.026297	472
c6e7314c-8525-4191-80c2-2c3a921f415d	2.05	160.84	1.01	1.1	2026-04-26 13:06:38.026297	473
01d04063-d9c3-43b8-9cd1-f2c365206958	0.82	80.56	3.13	2.26	2026-04-26 13:06:38.026297	474
688a8c3f-fa38-4308-89d5-212d6faf8a77	1.42	175.38	2.73	2.76	2026-04-26 13:06:38.026297	475
80f0e0e1-a56b-4969-9328-300dd7d3889e	2.29	107.7	2.66	2.4	2026-04-26 13:06:38.026297	476
bf4c1fb6-a269-4569-be90-6b6a998ee7b9	2.93	95.04	1.79	2.23	2026-04-26 13:06:38.026297	477
4421a7a4-be54-4494-b732-9068a725e9b7	3.41	88.74	3.61	2.98	2026-04-26 13:06:38.026297	478
5d9bfdd7-0a23-41a4-bff6-1d1b588e6b78	3.43	142.35	1.58	1.12	2026-04-26 13:06:38.026297	479
9272aa0e-60be-48a7-b1a9-e260a3fcd3d2	1.84	98.86	1.99	1.42	2026-04-26 13:06:38.026297	480
cd6c4c38-b00a-4644-b1a1-7fc4b8c0ef46	2.26	194.95	1.58	2.29	2026-04-26 13:06:38.026297	481
903c34b0-9809-44ee-af0c-97ca045cde31	3.29	164.93	1.46	1.95	2026-04-26 13:06:38.026297	482
ec564929-5d5d-4964-85c9-c2c00181550b	2.12	263.42	1.95	1.7	2026-04-26 13:06:38.026297	483
eb5b0417-51b7-4630-89a7-fbac16715f99	1.96	268.64	2.27	1.91	2026-04-26 13:06:38.026297	484
2f71377b-f84e-4d62-a2dd-610ad858eff9	2.93	157.18	3.26	2.02	2026-04-26 13:06:38.026297	485
ccefa4d3-0ac6-49b4-b548-44dbecf95314	0.73	136.63	2.84	2.8	2026-04-26 13:06:38.026297	486
641085c9-c0f6-4e22-ba3b-1fb94f36d101	3.48	120.65	2.59	2.62	2026-04-26 13:06:38.026297	487
98771193-9965-407f-9a85-7fede6b77203	3.04	172.62	1.48	1.82	2026-04-26 13:06:38.026297	488
a4f48f59-b6eb-49b5-bda3-c4cbe0959ccc	1.08	126.06	3.42	1.71	2026-04-26 13:06:38.026297	489
349fd483-5e87-4860-902e-0499901d0595	1.02	147.53	3.98	1.47	2026-04-26 13:06:38.026297	490
9c9909c7-05a2-4227-acf9-28521c0da135	0.83	197.79	1.7	2.82	2026-04-26 13:06:38.026297	491
f305ad8e-b6cd-4ccb-8d44-e33845a294a1	0.94	56.11	3.97	1.04	2026-04-26 13:06:38.026297	492
baa2883c-e58b-4231-a08f-44235a4dea80	2.6	155.33	2.11	1.72	2026-04-26 13:06:38.026297	493
0d8f1e65-863d-45d8-bd85-f7a7bb2a19d6	2.47	83.02	3.54	2.89	2026-04-26 13:06:38.026297	494
1274b8fd-1c04-42fe-ae89-7ee5494a8909	3.19	123.44	3.19	1.59	2026-04-26 13:06:38.026297	495
177aba49-3dfa-4284-870d-fb28b84d4534	0.83	206.82	3.3	1.63	2026-04-26 13:06:38.026297	496
a3e55969-7679-400e-b2f8-63e2955e54c2	0.77	107.46	3.46	2.07	2026-04-26 13:06:38.026297	497
ccea675a-ef56-4f85-b8c5-317c8ce5a850	0.87	217.97	1.43	2.84	2026-04-26 13:06:38.026297	498
3aa10c1e-2460-4377-b65a-f47990cf20a4	2.67	241.02	1.59	1.97	2026-04-26 13:06:38.026297	499
95049103-faa4-4e21-9165-033861d9c488	2.41	176.31	3.34	2.82	2026-04-26 13:06:38.026297	500
2c47bb0c-f0bc-43ef-97b7-ec4d8c96c29f	2.74	230.3	2.69	1.57	2026-04-26 13:06:38.026297	501
c1b55a4f-d015-496a-97a5-0eda929e3dc3	3.44	200.25	1.37	1.8	2026-04-26 13:06:38.026297	502
b8174b2e-1cb1-472c-ac48-c2a6912e48de	2.3	182.59	3.78	2.71	2026-04-26 13:06:38.026297	503
ef342171-814f-4d88-ba4b-9c3e820c63de	0.79	103.55	1.09	2.8	2026-04-26 13:06:38.026297	504
ff142781-a79f-4ff4-a703-7732aa9af9e3	1.76	248.81	2.39	2.94	2026-04-26 13:06:38.026297	505
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.95	175.66	3.56	2.74	2026-04-26 13:06:42.495329	506
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.95	175.66	3.56	2.74	2026-04-26 13:06:42.495329	507
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.95	175.66	3.56	2.74	2026-04-26 13:06:42.495329	508
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.95	175.66	3.56	2.74	2026-04-26 13:06:42.495329	509
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.95	175.66	3.56	2.74	2026-04-26 13:06:42.495329	510
083b503f-bc9a-4761-9232-985118e3bde4	3.38	177.02	3.21	1.02	2026-04-26 13:06:43.512226	511
84898f92-b30c-4251-99c5-6d4b8ee07428	1.36	274.55	3.2	1.73	2026-04-26 13:06:43.512226	512
1798c0d0-79e4-4d2b-9f3f-990b125d2105	1.08	146.52	2.73	1.19	2026-04-26 13:06:43.512226	513
d4454c95-37c1-4467-a22e-9fb7abac08a2	1.22	235.06	2.09	1.07	2026-04-26 13:06:43.512226	514
1dc79f19-741d-4d47-8552-5e53debeed00	2.67	264.4	2.23	2.7	2026-04-26 13:06:43.512226	515
127074f4-ef1e-44c6-b9d4-6e159522fe6d	2.2	66.53	3.69	1.77	2026-04-26 13:06:43.512226	516
933c3358-c4a9-4190-ba36-d320f41b28bd	1.27	258.61	1.95	1.1	2026-04-26 13:06:43.512226	517
24c4b5e6-9375-4a3d-aa2e-8ecf73311e2a	1.04	230.94	1.84	1.11	2026-04-26 13:06:43.512226	518
8459b204-828a-433c-946a-16940b23fe20	2.43	168.32	3.47	2.32	2026-04-26 13:06:43.512226	519
6c67de4d-14df-473a-b5b7-234ca1892d36	1.03	226.71	2.13	1.76	2026-04-26 13:06:43.512226	520
1a1da762-8b17-44fc-ab54-aacee70233c0	2.49	60.83	2.08	2.65	2026-04-26 13:06:43.512226	521
eaf83308-161d-4cbe-9a8f-c87d75ee5421	2.79	71.5	1.11	1.97	2026-04-26 13:06:43.512226	522
2639cd66-3527-4a6d-b26e-dfb2491c1bf2	3.22	178.99	2.75	1.47	2026-04-26 13:06:43.512226	523
8d34dd99-e669-4ca7-99af-1d91991a09c9	2.63	279.22	2.49	1.12	2026-04-26 13:06:43.512226	524
77398e9d-8c73-4cfb-9019-93696911c12d	1.06	281.51	3.56	1.49	2026-04-26 13:06:43.512226	525
af79ed93-81e1-4dad-ab43-483f230ed7d4	3.47	215.52	3.32	1.01	2026-04-26 13:06:43.512226	526
a09b5914-31d8-4628-bfde-a2ed4f60f907	2.15	276.9	1.87	2.92	2026-04-26 13:06:43.512226	527
af5d64a0-8fd6-4135-9b5c-ed9a17afe722	3.15	222.49	2.16	1.69	2026-04-26 13:06:43.512226	528
48f2ef4f-6f48-4a5a-8aca-e2844be19a4d	0.93	117.8	2.95	2.54	2026-04-26 13:06:43.512226	529
c4a5295a-ac7e-4505-ae47-069a3a50ecec	2.72	77.47	2.11	1.32	2026-04-26 13:06:43.512226	530
0cdc07b0-d122-4345-a871-ed8736125a13	0.87	107.95	3.33	1.12	2026-04-26 13:06:43.512226	531
8be3185b-bc1c-4142-b567-48aaff220b01	1.18	163.01	2.78	2.34	2026-04-26 13:06:43.512226	532
d9051e4d-d569-4f01-89e0-7d857762afe5	0.99	227.92	1.32	1.2	2026-04-26 13:06:43.512226	533
3fad7c09-4ab3-4a8b-aa29-7211513f7237	1.53	215.73	1.85	2.75	2026-04-26 13:06:43.512226	534
dbbf360e-7216-4601-8614-038fe1dcc2ba	1.84	79.08	3.08	1.95	2026-04-26 13:06:43.512226	535
9bd9f3c5-1b49-4927-8cdf-35373636ae00	3.34	184.27	2.42	1.37	2026-04-26 13:06:43.512226	536
160d3adf-6a5a-4442-8c35-f8ff730e0036	2.31	133.45	3.05	2.15	2026-04-26 13:06:43.512226	537
5c42027f-8aaa-441b-990e-215c05fc0300	2.62	173.91	2.84	2.53	2026-04-26 13:06:43.512226	538
bfc1d7fb-6dd6-42fd-a795-053bca272428	2.37	81.78	3.57	2.61	2026-04-26 13:06:43.512226	539
fe19663b-26a2-40d0-a329-bf3f1f6a25a6	2.17	170.59	2.42	2.7	2026-04-26 13:06:43.512226	540
09bcbc34-b01a-4878-88ae-4aac9ea91b2d	2.19	193.37	2.28	1.96	2026-04-26 13:06:43.512226	541
28aa7be3-ebf0-4bfb-9e4d-8eb57e7a1a09	1.54	168.31	1.24	2.36	2026-04-26 13:06:43.512226	542
a463568f-08c1-4eee-ba9f-87eca478959e	0.77	98.76	2.42	2.55	2026-04-26 13:06:43.512226	543
e91e2255-deed-4ffc-9e86-da19ee4fe2be	1.94	255.27	2.36	2.05	2026-04-26 13:06:43.512226	544
e6c3818b-29f0-4e36-9052-5e1482339405	1.45	149.73	3.63	2.88	2026-04-26 13:06:43.512226	545
80d81f80-2426-4c17-9e8a-321da7361798	0.58	202.89	3.48	2.31	2026-04-26 13:06:43.512226	546
6f817b31-ed87-46bb-9e2e-1140f4cb4cbb	1.11	126.31	3.23	2.64	2026-04-26 13:06:43.512226	547
34c9e297-d7dc-4168-a5a5-8e7e148dcbbd	1.19	271.95	2.6	1.99	2026-04-26 13:06:43.512226	548
06c52bbf-cbe5-4db7-997a-9f747283665e	1.84	178.04	3.27	2.87	2026-04-26 13:06:43.512226	549
0404794e-0a50-4824-a0ee-921cb23888ee	2.19	101.62	2.77	2.07	2026-04-26 13:06:43.512226	550
ff75e776-7227-4220-9f32-33a6013ae67f	2.65	231.69	1.63	2.55	2026-04-26 13:06:43.512226	551
522e7eca-7dde-4bb5-9cfd-7bfc1f5aa823	3.48	261.18	3.79	2.76	2026-04-26 13:06:43.512226	552
0670c059-cbff-4d6e-97fa-c2dbd81ba878	0.74	99.38	3.75	2.14	2026-04-26 13:06:43.512226	553
41623b9e-303f-46b1-82d3-8883c4a479bb	1.91	265.62	1.23	2.5	2026-04-26 13:06:43.512226	554
8425054a-27fe-45f7-a2d1-0ca5bb87c22d	0.74	168.35	2.34	1.34	2026-04-26 13:06:43.512226	555
88f2dc8f-4748-490e-b92d-e31ba6ddaf7b	2.45	270.55	1.73	1.93	2026-04-26 13:06:43.512226	556
71e03cf9-1c81-44c0-9c0f-63591e58aa30	1.01	149.24	2.01	1.41	2026-04-26 13:06:43.512226	557
bc2f02a5-cb1e-4610-ac0e-ba7f24c18ccd	1.97	253.45	1.22	2.33	2026-04-26 13:06:43.512226	558
c110010b-1088-4e02-be3c-83c511d7831c	2.51	202.26	3.08	2.96	2026-04-26 13:06:43.512226	559
fe8407a5-d6f0-4b63-b0c1-71ad87ffab96	1.07	105.34	1.78	1.9	2026-04-26 13:06:43.512226	560
19646a15-fc51-45ea-b837-9703ea5e5f8c	3.36	132.86	2.47	2.44	2026-04-26 13:06:43.512226	561
048313b2-21ec-4fbc-be08-2f0c27fa77f6	3.43	92.01	2.88	1.49	2026-04-26 13:06:43.512226	562
66ae13b0-bc41-401b-919a-a47c2d82b9ef	3.47	199.99	3.75	2.82	2026-04-26 13:06:43.512226	563
d87f65c7-d638-4f26-a825-aff5ae57457b	1.85	112.34	1.47	2.14	2026-04-26 13:06:43.512226	564
7931d397-9cb6-40aa-888c-6b1cfe481a74	2.19	76.41	3.28	2.86	2026-04-26 13:06:43.512226	565
a63e2468-ff52-45a6-a5cd-59944a3859bb	1.3	146.27	2.21	1.41	2026-04-26 13:06:43.512226	566
2c170f3c-70f5-4432-9675-baa82539a713	1.32	86.24	3.44	1.55	2026-04-26 13:06:43.512226	567
a49a8d86-d915-4488-b843-de71b33e91fd	3.23	119.06	1.21	1.56	2026-04-26 13:06:43.512226	568
b2cd1843-50e3-475c-b68b-24bcf035d14a	0.94	295.32	2.52	1.38	2026-04-26 13:06:43.512226	569
49214cd6-15b3-43e2-b004-f11980bd76e7	1.61	243.61	1.55	1.65	2026-04-26 13:06:43.512226	570
da38da3e-9316-49d8-af58-cfca2be2ecea	3.14	71.61	2.72	1.24	2026-04-26 13:06:43.512226	571
06e503be-bdf4-4afe-9252-ad4307d77d34	1.79	192.02	3.04	1.5	2026-04-26 13:06:43.512226	572
e07bf42f-e0df-4ae0-8b19-59673c872bf2	3.01	241.77	1.96	1.77	2026-04-26 13:06:43.512226	573
d9ff0e43-523c-4157-b412-c6e488086313	3.2	149.55	1.75	2.3	2026-04-26 13:06:43.512226	574
73605445-18c0-4c79-aa20-abe75a2aa504	1.28	156.15	1.26	2.26	2026-04-26 13:06:43.512226	575
17d1d4a8-7fff-4e9d-be6b-1ad8cff6ebd6	1.21	52.96	2.14	2.7	2026-04-26 13:06:43.512226	576
0ff59da4-ea9a-48c5-9b60-96f17e2644b7	2.25	65.16	2.56	1.1	2026-04-26 13:06:43.512226	577
0c867821-28e1-489c-96ef-a33a16f96004	2.26	117.79	1.04	1.47	2026-04-26 13:06:43.512226	578
6111d377-0b6c-4d93-b288-f7ebce6c00fc	2.76	180.86	1.34	1.91	2026-04-26 13:06:43.512226	579
18905b39-d6a0-4f41-8c02-9b817e1b009d	0.86	136.64	2.81	2.12	2026-04-26 13:06:43.512226	580
8b417aee-680e-4081-85f2-5a160fb2ff12	3.41	52.2	3.07	2.65	2026-04-26 13:06:43.512226	581
38b482a7-1f32-4ddc-9349-bcf1da86d546	2.84	69.17	2.66	1.03	2026-04-26 13:06:43.512226	582
02152a87-fd48-4156-bd2f-afe94c4dc7a6	2.81	153.97	2.16	1.73	2026-04-26 13:06:43.512226	583
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.93	70.25	3.95	2.21	2026-04-26 13:06:43.512226	584
79cd4a3f-adcf-4ce5-9d29-62693c93adf2	1.13	63.08	2.01	1.52	2026-04-26 13:06:43.512226	585
c4391873-3533-4cad-977b-0323fced348e	1.43	285.64	3.18	1.77	2026-04-26 13:06:43.512226	586
c6338c80-214f-405b-9b0b-7594bb69d230	0.83	201.63	2.62	1.08	2026-04-26 13:06:43.512226	587
382f3f60-7d3c-4ffc-8b2f-94ce32b77254	3.14	55.89	3.3	2.32	2026-04-26 13:06:43.512226	588
cf827a4b-a720-4825-84d4-29f047763f7e	2.07	192.25	3.73	2.01	2026-04-26 13:06:43.512226	589
d5806c60-9752-4845-9128-964d9b723f0b	0.78	150.26	1.95	1.98	2026-04-26 13:06:43.512226	590
96e0af22-02e2-46d4-8224-4db162bd27b6	1.18	279.33	2.12	1.74	2026-04-26 13:06:43.512226	591
9d0c77f5-485a-477d-80ec-8da875eb9852	2.69	240.86	1.52	1.59	2026-04-26 13:06:43.512226	592
c19c4f6a-3738-436e-b7dc-b27df3129b28	0.87	88.55	1.94	1.37	2026-04-26 13:06:43.512226	593
2d78aa7b-b8fb-4cc0-9d8a-f6a927032041	0.7	72.9	1.17	2.93	2026-04-26 13:06:43.512226	594
dbebf850-836f-4532-807c-c1e3f5b5d597	2.67	87.47	1.47	2.33	2026-04-26 13:06:43.512226	595
453f03e0-cb8d-4681-b343-d681f27e84f8	3.33	126.83	1.48	1.89	2026-04-26 13:06:43.512226	596
13d5f24a-3280-4db1-ae8d-4e7ac37dca9d	2.25	247.47	1.37	1.21	2026-04-26 13:06:43.512226	597
40f8a8d7-327f-4f20-a15c-cbd9fb6f5e75	2.99	294.84	3.24	2.12	2026-04-26 13:06:43.512226	598
8cfcaf67-4ae0-46c6-996e-6ce551b4096d	2.25	101.12	2.59	2.19	2026-04-26 13:06:43.512226	599
05bb5c72-6613-4d45-a876-a6c5fb64222e	2.68	292.39	2.62	1.06	2026-04-26 13:06:43.512226	600
37b80a41-5dec-4adb-ac19-126072ec4a13	2.41	55.22	3.31	2.76	2026-04-26 13:06:43.512226	601
514c19e7-d8eb-4f8a-b58c-db01659e571e	0.87	151.79	3.12	1.02	2026-04-26 13:06:43.512226	602
27ded357-dfee-45c6-844b-2108e05a105b	0.64	121.53	2.06	2.57	2026-04-26 13:06:43.512226	603
affc16bb-f7a4-4ff2-90df-48caf7eebddc	1.05	244.04	2.69	1.92	2026-04-26 13:06:43.512226	604
cb0fe3b7-fbc8-479b-bd12-6acfeeeeffeb	3.02	275.24	3.03	1.68	2026-04-26 13:06:43.512226	605
c0f13516-b42b-4edf-8d54-260ed3432c91	2.83	79.35	2.69	1.31	2026-04-26 13:06:43.512226	606
a6b3ffd9-c2dc-4bf3-872f-1d4dfaff44ce	1.45	138.26	3.55	2.18	2026-04-26 13:06:43.512226	607
4c18584e-0e3e-40cc-94a4-dd6106965efb	1.58	207.61	3.73	2.33	2026-04-26 13:06:43.512226	608
42be6f12-2662-427d-b3bb-9f8fb042cde5	2.93	292.35	2.05	2.19	2026-04-26 13:06:43.512226	609
a9a3a5fa-5c98-4e69-883b-2afa82b1877f	3.44	180.61	1.49	1.83	2026-04-26 13:06:43.512226	610
69ceb13d-c6ba-480a-9bb6-8c94350b80bb	1.93	149.48	3.81	2.33	2026-04-26 13:06:43.512226	611
6946eb18-50ec-477c-808d-f71c98670e15	3.1	73.23	3.92	1.36	2026-04-26 13:06:43.512226	612
db738178-6c85-4003-814c-43efae201f66	2.42	245.31	1.57	1.4	2026-04-26 13:06:43.512226	613
4b5f92c9-7d51-4b0e-a137-acd779a460c0	2.21	159.14	2.23	2.61	2026-04-26 13:06:43.512226	614
343b8afa-f5f3-413a-8faf-37c6af937323	2.13	232.76	2.55	1.12	2026-04-26 13:06:43.512226	615
aa3eddc8-b910-47a9-b691-2ec377a4b6c3	3.27	259.83	3.07	2.32	2026-04-26 13:06:43.512226	616
10412ce9-7326-4907-98fb-f30f329eb834	3.45	293.2	3	1.57	2026-04-26 13:06:43.512226	617
a7a83b3b-4904-468d-b1ff-79250bae2178	1.47	186.65	3.63	2.45	2026-04-26 13:06:43.512226	618
de64100b-0d55-4423-8139-e21bf67b1ba3	1.97	151.23	2.36	1.86	2026-04-26 13:06:43.512226	619
48f1cae9-db76-406a-84c3-4b1d3fd1f646	2.49	127.75	1.82	1.93	2026-04-26 13:06:43.512226	620
bff99142-a62f-4628-a6ff-c053c6deb013	1.67	187.67	3.63	2.56	2026-04-26 13:06:43.512226	621
fb073968-3588-453a-85e2-75089d4c03f1	2.96	296.23	1.96	1.85	2026-04-26 13:06:43.512226	622
377f4e07-93cb-4351-8c6b-62851338fdb0	1.91	106.16	2.43	2.75	2026-04-26 13:06:43.512226	623
19bdfc5a-e1d0-463a-b163-7d7a692f73b8	2.85	176.64	1.97	2.39	2026-04-26 13:06:43.512226	624
cbd20eb0-7239-4734-b82b-404600e7d66b	2.28	205.72	3.33	2.33	2026-04-26 13:06:43.512226	625
18c3479d-2072-411f-8d91-9a580608c627	1.12	255.07	1.61	1.93	2026-04-26 13:06:43.512226	626
ca09ced3-7738-4c9e-887f-d34312c3d8e4	2.66	164.11	1.01	2.15	2026-04-26 13:06:43.512226	627
07a6b221-981a-4cce-bb5d-3d5a872c97b7	0.93	188.5	2.7	1.65	2026-04-26 13:06:43.512226	628
fa753e0b-bcb9-41b7-9c82-6fccd2333db1	1.79	222.8	1.86	1.12	2026-04-26 13:06:43.512226	629
100a7e1e-99f2-4b0d-8a9d-842a454a612f	3.39	256.98	3.39	1.88	2026-04-26 13:06:43.512226	630
41bd264e-1eb3-4ccb-ab43-221d92913239	0.91	142.78	1.29	1.32	2026-04-26 13:06:43.512226	631
b80e97e3-fe08-465e-ac72-eea64d2d6182	2.96	164.46	3.27	1.25	2026-04-26 13:06:43.512226	632
ed596397-26d6-4d02-a2f1-dbbf5f8ab704	1.13	188.66	2.07	2.42	2026-04-26 13:06:43.512226	633
5d36c463-e893-43a2-b567-1e7fbcb3c80c	1.13	157.51	3.54	1.5	2026-04-26 13:06:43.512226	634
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	3.39	293.44	2.4	1.25	2026-04-26 13:06:43.512226	635
b611f2f3-4dce-4565-9634-c5f67f16841f	2.41	134.91	2.69	1.26	2026-04-26 13:06:43.512226	636
af16d415-a7a8-426f-8d38-2ade72d8acb5	0.97	129.42	3.45	2.36	2026-04-26 13:06:43.512226	637
a18f9d90-4ce4-4793-a9c1-9452712601a3	2.87	51.34	3.32	1.31	2026-04-26 13:06:43.512226	638
2421d8dc-3548-4b72-b606-b235ecdf5448	0.54	293.33	2.01	1.55	2026-04-26 13:06:43.512226	639
bb6389a5-9e20-4135-8648-8a813bb296b7	2.2	215.93	1.55	1.42	2026-04-26 13:06:43.512226	640
6447b600-e734-4067-87b1-b915998722b4	0.51	297.42	2.57	2.73	2026-04-26 13:06:43.512226	641
a1fc9f0b-f1e6-4819-9cb5-1ce77541a1b5	3.14	190.34	2.45	2.12	2026-04-26 13:06:43.512226	642
25df9dd3-d744-4a1e-a96b-d1322d6952f5	3.21	269.49	1.43	1.92	2026-04-26 13:06:43.512226	643
8e3909e7-8ee5-4db8-9278-087d2851a6f1	1.05	269.59	3.94	2.68	2026-04-26 13:06:43.512226	644
3fcc2af3-e524-4b65-9649-cc48a58b7463	2.08	150.11	3.89	2.03	2026-04-26 13:06:43.512226	645
3045ab21-e78f-41cf-9f96-102cfd907777	1.04	281.6	3.99	2.05	2026-04-26 13:06:43.512226	646
211e6d92-06f3-4968-ab18-4d3606fb0313	2.4	182.01	3.95	1.05	2026-04-26 13:06:43.512226	647
577c5ceb-5d82-4a67-914e-cc3249432558	2	96.88	3.83	1.58	2026-04-26 13:06:43.512226	648
a9955bda-fedb-44d9-b5a6-33b7ceff70cc	1.41	141.73	2.96	1.46	2026-04-26 13:06:43.512226	649
cac6b96e-6c77-4c20-b201-5d059367fbf0	2.43	113.34	2.74	2.5	2026-04-26 13:06:43.512226	650
40b83090-1da5-4f1a-85d6-884f75d306d9	2.95	174.32	3.8	1.97	2026-04-26 13:06:43.512226	651
af6f8bce-ab49-4a79-a40c-4a4aba8d8552	0.87	110.69	1.42	2.37	2026-04-26 13:06:43.512226	652
7674a04d-8f67-4d07-9eab-998e344a03c9	0.59	131.58	1.76	2.65	2026-04-26 13:06:43.512226	653
f97b5670-ef68-4a86-97c0-6385e6ae7405	1.44	61.83	1.54	1.07	2026-04-26 13:06:43.512226	654
4fc26046-1ae2-4e60-99cf-95ef8ee6524a	0.65	101.48	1.56	2.46	2026-04-26 13:06:43.512226	655
e332ef09-be23-4a9d-b003-f886bfae870d	1.68	119.03	3.38	2.93	2026-04-26 13:06:43.512226	656
88f0fd74-5fbe-402b-b1f9-8b0185f9b042	2.41	259.38	2.91	2.51	2026-04-26 13:06:43.512226	657
7289ae0e-9605-4d46-aaee-5b05ddd96e59	2.38	187.95	2.29	1.61	2026-04-26 13:06:43.512226	658
b0318b61-a090-47a1-a30e-1f29ba099262	3.45	259.93	3.4	1.09	2026-04-26 13:06:43.512226	659
26ec3ee2-f140-4f43-b13b-9299796dd2d1	3.46	151.17	2.58	1.2	2026-04-26 13:06:43.512226	660
9dab24c7-177d-4ec4-8c0b-2323b92d3d4a	0.69	55.4	1.97	1.67	2026-04-26 13:06:43.512226	661
1a6d5e85-787b-461f-8db7-9cd8f8d81ece	1.95	98.5	2.82	2.92	2026-04-26 13:06:43.512226	662
27b23042-92c6-4a49-b397-6c200041d8ee	1.26	264.42	3.26	2.55	2026-04-26 13:06:43.512226	663
08f0acf7-18ec-45eb-8146-8042969d5c7a	1.2	146.39	3.36	1.39	2026-04-26 13:06:43.512226	664
a03af7ca-2046-499e-b19d-b6571e696f89	2.45	146.43	2.41	2.92	2026-04-26 13:06:43.512226	665
e7fd011f-5572-4ee9-a3de-2d9d4d5c818d	1.37	95.86	2.71	1.67	2026-04-26 13:06:43.512226	666
4065ab51-f74f-42a2-9363-7146df43c932	2.07	200.89	2.26	2.7	2026-04-26 13:06:43.512226	667
a07f2ed2-35ae-4720-ad65-a22fe59566d3	2.46	189.25	3.78	1.66	2026-04-26 13:06:43.512226	668
02c4237f-a7f5-452b-82c3-1fe296af3c3c	0.9	159.66	3.82	1.66	2026-04-26 13:06:43.512226	669
62b7cf0d-cf31-493a-85aa-8fa347acda25	1.36	233.53	3.04	1.13	2026-04-26 13:06:43.512226	670
ab3db038-d69b-451e-bba3-08e8119898b4	1.24	171.05	3.79	2.05	2026-04-26 13:06:43.512226	671
b685932b-8a27-4288-8795-f6e05e9e4cef	2.67	200.37	3.92	2.74	2026-04-26 13:06:43.512226	672
9cd7e4f4-8d1a-48da-abbc-075218e9e7a6	3.02	295.72	2.99	1.97	2026-04-26 13:06:43.512226	673
98d2ddcf-4cfa-4405-9501-d661884b1017	3.03	215.3	2.84	1.62	2026-04-26 13:06:43.512226	674
d0655207-0783-4e94-98d2-176fe26849d8	0.73	110.17	2.56	2.66	2026-04-26 13:06:43.512226	675
bcad4d42-8a4f-4b72-a2e1-b607651d5c31	1.56	264.7	3.92	2.72	2026-04-26 13:06:43.512226	676
9ed4929a-d3c0-4954-b272-227a89cbedec	2.98	71.5	2.31	2.89	2026-04-26 13:06:43.512226	677
edcb7d15-e6ed-461f-b1b4-38a993ff2ec7	1.36	122.59	1.34	2.95	2026-04-26 13:06:43.512226	678
2f5d7c02-eadd-4eb2-8dd5-46a5ba51c3f8	2.37	233.61	2.87	1	2026-04-26 13:06:43.512226	679
0ad0a6eb-d13c-440c-b74c-0391605d9685	1.57	100.82	1.99	2.11	2026-04-26 13:06:43.512226	680
2bb8c959-19b6-4951-8313-e6d0413c9a6f	2.65	241.89	2.26	2.54	2026-04-26 13:06:43.512226	681
303a312c-4f87-408c-b20b-03d848ec9055	2.87	144.31	1.5	1.62	2026-04-26 13:06:43.512226	682
a32bfdcd-5dd9-4a93-85e7-c1e608df83ee	1.24	76.27	1.06	1.71	2026-04-26 13:06:43.512226	683
5ccc6390-43ca-49f5-b6fa-84247d3e52af	2.03	252.95	2.67	2.32	2026-04-26 13:06:43.512226	684
df299e49-61f2-49ce-8051-e50cfc0b2650	3.41	54.64	1.11	1.53	2026-04-26 13:06:43.512226	685
86ef6ade-b308-467a-8c42-3c6e4c20ec8d	1.36	270.73	1.22	2.52	2026-04-26 13:06:43.512226	686
e318d53f-7605-468a-b41d-051070be96a3	1.32	257.57	2.59	2.73	2026-04-26 13:06:43.512226	687
efc0c233-0113-480b-b3e6-ca3275b5ffde	1.55	126.26	2.34	2.61	2026-04-26 13:06:43.512226	688
5808ae27-83d1-4163-9187-6a23f988dc97	1.41	246.8	2.12	2.06	2026-04-26 13:06:43.512226	689
e304e2e6-fd72-4399-b4d7-fb6416b81f0c	2.86	197.81	3.4	1.88	2026-04-26 13:06:43.512226	690
678ae26f-569d-4c0e-b4a9-0a688fc0936a	2.22	58	2.76	1.83	2026-04-26 13:06:43.512226	691
6438657c-ee67-48b5-8de0-62eeb64e0a87	2.31	143.54	1.88	1.8	2026-04-26 13:06:43.512226	692
e3216b17-e320-4d0f-ada0-b93e60caca02	1.91	183.61	3.27	1.4	2026-04-26 13:06:43.512226	693
63188d13-0344-4b51-aa79-19ea416c8cdd	2.45	102.73	1.81	2.43	2026-04-26 13:06:43.512226	694
17932bb9-836e-4db9-b27e-bd1b2f574954	2.22	138.68	3.62	1.91	2026-04-26 13:06:43.512226	695
459418c3-7fb1-4dd5-9c2b-6a0eb1e128a7	1.54	262.12	2.04	2.65	2026-04-26 13:06:43.512226	696
4d88229f-55e4-476b-bfc0-096795c485e4	3.42	73.73	3.84	1.53	2026-04-26 13:06:43.512226	697
2ce612e7-1b0e-4a98-aab2-d00e087e7acd	2.89	197.82	2.8	1.88	2026-04-26 13:06:43.512226	698
f1c04ba0-d43a-4055-8726-0674ce5a9591	2.06	76.03	2.9	1.79	2026-04-26 13:06:43.512226	699
b4617646-5ec4-4d15-a573-c29cffb7c27f	2.63	220.9	3.34	1.06	2026-04-26 13:06:43.512226	700
c02600b3-e48e-4409-95a3-eb683e336b10	0.61	157.46	2.13	2.44	2026-04-26 13:06:43.512226	701
fc365d4b-670e-4fca-8c15-bed27e9c7c64	2.45	106.08	1.13	2.35	2026-04-26 13:06:43.512226	702
b5bfff34-218c-48cd-b9ce-673eea91bda1	1.27	239.45	3.67	1.16	2026-04-26 13:06:43.512226	703
0ef3d984-2e82-4672-bcd6-c49dfd8397b3	2.56	178.32	1.51	2.81	2026-04-26 13:06:43.512226	704
869589e4-a12e-4a97-9558-0e078bfadd07	1.44	291.52	1.12	2.08	2026-04-26 13:06:43.512226	705
fc37eb73-af1d-4f66-ab8d-ac6cd664ceea	2.33	283.83	3.93	2.71	2026-04-26 13:06:43.512226	706
f182189b-b6e2-4aee-bb22-5b1e555815b6	2.23	82.37	3.65	1.52	2026-04-26 13:06:43.512226	707
4a03155b-1956-495a-aa04-f02a9c3d31c8	0.51	265.87	1.81	1.97	2026-04-26 13:06:43.512226	708
6b9cb1d4-e93d-40cb-8099-44f30eae119b	3.32	152.09	2.87	1.65	2026-04-26 13:06:43.512226	709
77c9a885-1040-44e4-8b7c-18dccb3b1a81	3.36	177.94	1.69	2.15	2026-04-26 13:06:43.512226	710
ab089221-71a5-4b3c-a06e-445f999eed0a	3.45	193.29	2.09	1.25	2026-04-26 13:06:43.512226	711
2954b16d-0db5-4232-8923-ca1c2a81be0a	1.84	239.99	3.08	2.66	2026-04-26 13:06:43.512226	712
e072183d-f51e-4965-a227-e111304e8104	2.67	140.7	1.99	1.69	2026-04-26 13:06:43.512226	713
d59dcfa3-ec8d-4789-81cd-22e13a9c829c	0.59	91.57	3.11	1.82	2026-04-26 13:06:43.512226	714
e32ad455-b5bd-49ef-b295-f81c8a11da16	2.83	132.09	1.84	1.89	2026-04-26 13:06:43.512226	715
21d6e120-8fa3-4a51-9ade-436c7d77e075	1.6	153.15	1.48	1.58	2026-04-26 13:06:43.512226	716
efff145d-5625-4a2c-ac23-ffdccad3e85b	0.76	75.18	3.86	2.69	2026-04-26 13:06:43.512226	717
1a64a717-44a3-4308-9eaa-d6a37163544c	2.46	68.82	1.67	1.16	2026-04-26 13:06:43.512226	718
474c6490-57e2-4c5c-ad69-dc1c4cf6b1f5	2.89	245.81	2.76	1.27	2026-04-26 13:06:43.512226	719
7f85773c-30b2-4ff2-877a-93f568213806	2.21	286.79	1.2	1.24	2026-04-26 13:06:43.512226	720
4d87ace7-e3ee-4ea4-92f6-c395ef501428	0.62	255.24	1.22	1.31	2026-04-26 13:06:43.512226	721
4d289278-e3f8-42ed-af6a-2d3259072f3f	3.38	289.27	2.95	1.44	2026-04-26 13:06:43.512226	722
ebffe864-14eb-465e-b745-192f6e5717bf	3.11	282.12	3.63	2.48	2026-04-26 13:06:43.512226	723
fb9a49ca-e5e2-4be1-9e2c-5d77c4db770b	1.9	78.68	1.97	1.36	2026-04-26 13:06:43.512226	724
150f7991-fbd0-429e-bdf9-c60b50b1aae6	3.02	250.51	2.12	1.95	2026-04-26 13:06:43.512226	725
569b5e54-a5e6-442c-94e0-64a8245dcd07	0.64	80.38	3.81	1.44	2026-04-26 13:06:43.512226	726
1525c80d-cf06-4108-bab9-0205f6ed78f7	3.11	123.85	3.28	1.54	2026-04-26 13:06:43.512226	727
c6e7314c-8525-4191-80c2-2c3a921f415d	3.27	78.55	1.21	2.74	2026-04-26 13:06:43.512226	728
01d04063-d9c3-43b8-9cd1-f2c365206958	2	158.65	3.15	2.36	2026-04-26 13:06:43.512226	729
688a8c3f-fa38-4308-89d5-212d6faf8a77	1.13	167.26	1.87	1.53	2026-04-26 13:06:43.512226	730
80f0e0e1-a56b-4969-9328-300dd7d3889e	2.45	90.93	1.05	2.78	2026-04-26 13:06:43.512226	731
bf4c1fb6-a269-4569-be90-6b6a998ee7b9	0.55	66.81	2.65	2.23	2026-04-26 13:06:43.512226	732
4421a7a4-be54-4494-b732-9068a725e9b7	2.56	68.72	2.19	1.67	2026-04-26 13:06:43.512226	733
5d9bfdd7-0a23-41a4-bff6-1d1b588e6b78	3.02	257.34	3.66	2.71	2026-04-26 13:06:43.512226	734
9272aa0e-60be-48a7-b1a9-e260a3fcd3d2	0.77	191.62	1.28	2.31	2026-04-26 13:06:43.512226	735
cd6c4c38-b00a-4644-b1a1-7fc4b8c0ef46	1.17	229.6	2.62	2.89	2026-04-26 13:06:43.512226	736
903c34b0-9809-44ee-af0c-97ca045cde31	1.61	116.6	3.4	1.38	2026-04-26 13:06:43.512226	737
ec564929-5d5d-4964-85c9-c2c00181550b	2.86	67.83	3.58	1.46	2026-04-26 13:06:43.512226	738
eb5b0417-51b7-4630-89a7-fbac16715f99	1.91	290.04	2.1	1.35	2026-04-26 13:06:43.512226	739
2f71377b-f84e-4d62-a2dd-610ad858eff9	1.07	178.98	3.28	1.98	2026-04-26 13:06:43.512226	740
ccefa4d3-0ac6-49b4-b548-44dbecf95314	2.96	90.24	3.1	2.59	2026-04-26 13:06:43.512226	741
641085c9-c0f6-4e22-ba3b-1fb94f36d101	2.75	256.46	2.93	2.28	2026-04-26 13:06:43.512226	742
98771193-9965-407f-9a85-7fede6b77203	3.38	209.19	3.63	2.92	2026-04-26 13:06:43.512226	743
a4f48f59-b6eb-49b5-bda3-c4cbe0959ccc	2.5	214.05	3.87	1.04	2026-04-26 13:06:43.512226	744
349fd483-5e87-4860-902e-0499901d0595	3.44	74.15	2.48	1.33	2026-04-26 13:06:43.512226	745
9c9909c7-05a2-4227-acf9-28521c0da135	2.48	183.51	1.33	2.32	2026-04-26 13:06:43.512226	746
f305ad8e-b6cd-4ccb-8d44-e33845a294a1	2.34	125.21	3.64	2.11	2026-04-26 13:06:43.512226	747
baa2883c-e58b-4231-a08f-44235a4dea80	0.87	260.85	3.38	1.3	2026-04-26 13:06:43.512226	748
0d8f1e65-863d-45d8-bd85-f7a7bb2a19d6	2.45	287.62	1.34	1.81	2026-04-26 13:06:43.512226	749
1274b8fd-1c04-42fe-ae89-7ee5494a8909	1.18	117.5	2.89	1.52	2026-04-26 13:06:43.512226	750
177aba49-3dfa-4284-870d-fb28b84d4534	2.41	244.56	3.08	1.26	2026-04-26 13:06:43.512226	751
a3e55969-7679-400e-b2f8-63e2955e54c2	2.24	195.71	1.03	1.79	2026-04-26 13:06:43.512226	752
ccea675a-ef56-4f85-b8c5-317c8ce5a850	2.78	169.01	3.16	2.95	2026-04-26 13:06:43.512226	753
3aa10c1e-2460-4377-b65a-f47990cf20a4	1.38	85.35	2.95	1.66	2026-04-26 13:06:43.512226	754
95049103-faa4-4e21-9165-033861d9c488	2.93	193.42	1.71	1.19	2026-04-26 13:06:43.512226	755
2c47bb0c-f0bc-43ef-97b7-ec4d8c96c29f	1.02	206.79	2.39	2.12	2026-04-26 13:06:43.512226	756
c1b55a4f-d015-496a-97a5-0eda929e3dc3	2.93	69.52	2.13	2.28	2026-04-26 13:06:43.512226	757
b8174b2e-1cb1-472c-ac48-c2a6912e48de	3.28	221.43	2.58	2.5	2026-04-26 13:06:43.512226	758
ef342171-814f-4d88-ba4b-9c3e820c63de	3.14	261.92	2.4	1.86	2026-04-26 13:06:43.512226	759
ff142781-a79f-4ff4-a703-7732aa9af9e3	0.88	248.83	3.63	1.38	2026-04-26 13:06:43.512226	760
53988c3d-02b2-4be9-95b5-739ffb19f562	0.74	210.58	2.48	2.32	2026-04-26 13:06:43.512226	761
90e0676d-9543-455e-b95b-033a3dc29094	1.65	125.25	1.53	1.19	2026-04-26 13:06:43.512226	762
aa53d45e-4f36-4897-b499-3ed698190647	2.97	169.73	2.65	2.94	2026-04-26 13:06:43.512226	763
0d2cac97-cb24-4e98-8c0f-4356b3e97f0a	2.13	126.55	2.89	3	2026-04-26 13:06:43.512226	764
3781bb39-94d7-41ab-bddb-e6008d65fc3e	1.33	248.14	2.15	2.23	2026-04-26 13:06:43.512226	765
9c7b719e-b70f-4394-9ff1-ed98e6b5cc58	3.39	243.58	2.51	2.16	2026-04-26 13:06:43.512226	766
e7450082-184d-42e5-9e10-1ba889b81e15	1.19	173.86	2.08	2.96	2026-04-26 13:06:43.512226	767
7f8cdea0-97fa-4f5c-a07d-339312618900	3.46	168.97	2.5	2.73	2026-04-26 13:06:43.512226	768
1cdd7dbf-0fb2-4741-b2ce-1648f6588f83	1.85	248.06	2.32	2.02	2026-04-26 13:06:43.512226	769
addb0a76-380c-4a6e-81a0-5642a291744d	1.38	128.68	1.1	2.65	2026-04-26 13:06:43.512226	770
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.93	70.25	3.95	2.21	2026-04-26 13:06:44.294976	771
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.93	70.25	3.95	2.21	2026-04-26 13:06:44.294976	772
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.93	70.25	3.95	2.21	2026-04-26 13:06:44.294976	773
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.93	70.25	3.95	2.21	2026-04-26 13:06:44.294976	774
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.93	70.25	3.95	2.21	2026-04-26 13:06:44.294976	775
083b503f-bc9a-4761-9232-985118e3bde4	1.24	291.33	1.06	1.81	2026-04-26 13:06:45.313181	776
84898f92-b30c-4251-99c5-6d4b8ee07428	3.37	224.4	3.06	2.66	2026-04-26 13:06:45.313181	777
1798c0d0-79e4-4d2b-9f3f-990b125d2105	0.96	290.6	1.97	2.95	2026-04-26 13:06:45.313181	778
d4454c95-37c1-4467-a22e-9fb7abac08a2	2.66	281.92	2.05	2.47	2026-04-26 13:06:45.313181	779
1dc79f19-741d-4d47-8552-5e53debeed00	0.57	90.93	2.72	2.62	2026-04-26 13:06:45.313181	780
127074f4-ef1e-44c6-b9d4-6e159522fe6d	2.94	295.37	3.61	2.03	2026-04-26 13:06:45.313181	781
933c3358-c4a9-4190-ba36-d320f41b28bd	1.96	278.77	3.8	2.78	2026-04-26 13:06:45.313181	782
24c4b5e6-9375-4a3d-aa2e-8ecf73311e2a	0.53	84.13	1.08	2.24	2026-04-26 13:06:45.313181	783
8459b204-828a-433c-946a-16940b23fe20	0.85	202.58	2.47	2.62	2026-04-26 13:06:45.313181	784
6c67de4d-14df-473a-b5b7-234ca1892d36	2.85	92.32	3.72	1.07	2026-04-26 13:06:45.313181	785
1a1da762-8b17-44fc-ab54-aacee70233c0	0.66	69.29	3	2.97	2026-04-26 13:06:45.313181	786
eaf83308-161d-4cbe-9a8f-c87d75ee5421	2.41	97.33	3.61	2.75	2026-04-26 13:06:45.313181	787
2639cd66-3527-4a6d-b26e-dfb2491c1bf2	0.6	88.43	2.59	2	2026-04-26 13:06:45.313181	788
8d34dd99-e669-4ca7-99af-1d91991a09c9	1.38	238.02	1.31	2.66	2026-04-26 13:06:45.313181	789
77398e9d-8c73-4cfb-9019-93696911c12d	1.95	208.78	3.61	1.13	2026-04-26 13:06:45.313181	790
af79ed93-81e1-4dad-ab43-483f230ed7d4	1.88	190.84	2.54	1.43	2026-04-26 13:06:45.313181	791
a09b5914-31d8-4628-bfde-a2ed4f60f907	3.22	283.74	1.57	1.72	2026-04-26 13:06:45.313181	792
af5d64a0-8fd6-4135-9b5c-ed9a17afe722	1.2	294.19	2.29	1.79	2026-04-26 13:06:45.313181	793
48f2ef4f-6f48-4a5a-8aca-e2844be19a4d	2.58	255.6	2.53	1.37	2026-04-26 13:06:45.313181	794
c4a5295a-ac7e-4505-ae47-069a3a50ecec	2.21	266.39	3.75	2.13	2026-04-26 13:06:45.313181	795
0cdc07b0-d122-4345-a871-ed8736125a13	1.55	299.94	3.19	1.11	2026-04-26 13:06:45.313181	796
8be3185b-bc1c-4142-b567-48aaff220b01	2.94	78.31	3.31	1.73	2026-04-26 13:06:45.313181	797
d9051e4d-d569-4f01-89e0-7d857762afe5	3.47	208.53	3.43	1.44	2026-04-26 13:06:45.313181	798
3fad7c09-4ab3-4a8b-aa29-7211513f7237	2.94	227.75	1.5	1.44	2026-04-26 13:06:45.313181	799
dbbf360e-7216-4601-8614-038fe1dcc2ba	1.68	234.24	2.25	1.57	2026-04-26 13:06:45.313181	800
9bd9f3c5-1b49-4927-8cdf-35373636ae00	1.88	163.89	3.07	1.73	2026-04-26 13:06:45.313181	801
160d3adf-6a5a-4442-8c35-f8ff730e0036	2.77	233.86	1.25	1.56	2026-04-26 13:06:45.313181	802
5c42027f-8aaa-441b-990e-215c05fc0300	2.43	200.74	3.48	2.31	2026-04-26 13:06:45.313181	803
bfc1d7fb-6dd6-42fd-a795-053bca272428	0.88	190.75	2.93	1.31	2026-04-26 13:06:45.313181	804
fe19663b-26a2-40d0-a329-bf3f1f6a25a6	3.18	255.11	3.5	1.08	2026-04-26 13:06:45.313181	805
09bcbc34-b01a-4878-88ae-4aac9ea91b2d	0.59	96.88	2.35	1.38	2026-04-26 13:06:45.313181	806
28aa7be3-ebf0-4bfb-9e4d-8eb57e7a1a09	1.25	208.3	3.63	1.41	2026-04-26 13:06:45.313181	807
a463568f-08c1-4eee-ba9f-87eca478959e	2.22	157.78	2.12	2.89	2026-04-26 13:06:45.313181	808
e91e2255-deed-4ffc-9e86-da19ee4fe2be	0.89	131.3	3.89	1.4	2026-04-26 13:06:45.313181	809
e6c3818b-29f0-4e36-9052-5e1482339405	0.91	213.61	1.97	2.26	2026-04-26 13:06:45.313181	810
80d81f80-2426-4c17-9e8a-321da7361798	3.32	199.23	2.62	2.84	2026-04-26 13:06:45.313181	811
6f817b31-ed87-46bb-9e2e-1140f4cb4cbb	1.54	280.82	3.96	2.07	2026-04-26 13:06:45.313181	812
34c9e297-d7dc-4168-a5a5-8e7e148dcbbd	0.96	201.92	3.53	1.98	2026-04-26 13:06:45.313181	813
06c52bbf-cbe5-4db7-997a-9f747283665e	1.36	248.68	2.01	1.24	2026-04-26 13:06:45.313181	814
0404794e-0a50-4824-a0ee-921cb23888ee	1.14	61.38	3.23	1.58	2026-04-26 13:06:45.313181	815
ff75e776-7227-4220-9f32-33a6013ae67f	0.72	187.84	3.49	2.14	2026-04-26 13:06:45.313181	816
522e7eca-7dde-4bb5-9cfd-7bfc1f5aa823	3.43	192.11	1.53	1.45	2026-04-26 13:06:45.313181	817
0670c059-cbff-4d6e-97fa-c2dbd81ba878	0.56	151.65	3.07	1.75	2026-04-26 13:06:45.313181	818
41623b9e-303f-46b1-82d3-8883c4a479bb	2.17	137.12	3.48	2.56	2026-04-26 13:06:45.313181	819
8425054a-27fe-45f7-a2d1-0ca5bb87c22d	3.12	229.93	3.28	1.98	2026-04-26 13:06:45.313181	820
88f2dc8f-4748-490e-b92d-e31ba6ddaf7b	2.44	53.66	3.68	1.67	2026-04-26 13:06:45.313181	821
71e03cf9-1c81-44c0-9c0f-63591e58aa30	3.09	176	2.23	2.14	2026-04-26 13:06:45.313181	822
bc2f02a5-cb1e-4610-ac0e-ba7f24c18ccd	1.55	149.91	1.73	2.39	2026-04-26 13:06:45.313181	823
c110010b-1088-4e02-be3c-83c511d7831c	1.28	181.19	2.14	1.7	2026-04-26 13:06:45.313181	824
fe8407a5-d6f0-4b63-b0c1-71ad87ffab96	1.18	171.01	2.04	1.08	2026-04-26 13:06:45.313181	825
19646a15-fc51-45ea-b837-9703ea5e5f8c	1.08	169.88	1.3	1.3	2026-04-26 13:06:45.313181	826
048313b2-21ec-4fbc-be08-2f0c27fa77f6	1.38	111.12	3.75	1.9	2026-04-26 13:06:45.313181	827
66ae13b0-bc41-401b-919a-a47c2d82b9ef	1.9	293.19	2.31	2.97	2026-04-26 13:06:45.313181	828
d87f65c7-d638-4f26-a825-aff5ae57457b	2.37	228.09	1.67	1.43	2026-04-26 13:06:45.313181	829
7931d397-9cb6-40aa-888c-6b1cfe481a74	1.76	80.18	3.37	2.51	2026-04-26 13:06:45.313181	830
a63e2468-ff52-45a6-a5cd-59944a3859bb	1.36	139.01	1.29	2.1	2026-04-26 13:06:45.313181	831
2c170f3c-70f5-4432-9675-baa82539a713	3.21	58.82	3.28	2.59	2026-04-26 13:06:45.313181	832
a49a8d86-d915-4488-b843-de71b33e91fd	2.13	77.27	3.37	1.32	2026-04-26 13:06:45.313181	833
b2cd1843-50e3-475c-b68b-24bcf035d14a	0.53	245.75	3.13	2.64	2026-04-26 13:06:45.313181	834
49214cd6-15b3-43e2-b004-f11980bd76e7	2.8	209.78	3.22	1.39	2026-04-26 13:06:45.313181	835
da38da3e-9316-49d8-af58-cfca2be2ecea	0.78	173.57	3.54	2.82	2026-04-26 13:06:45.313181	836
06e503be-bdf4-4afe-9252-ad4307d77d34	1.84	284.32	3.08	1.07	2026-04-26 13:06:45.313181	837
e07bf42f-e0df-4ae0-8b19-59673c872bf2	2.87	197.26	3.03	2.09	2026-04-26 13:06:45.313181	838
d9ff0e43-523c-4157-b412-c6e488086313	1.01	256.23	3.44	2	2026-04-26 13:06:45.313181	839
73605445-18c0-4c79-aa20-abe75a2aa504	2.22	191.95	3.32	2.15	2026-04-26 13:06:45.313181	840
17d1d4a8-7fff-4e9d-be6b-1ad8cff6ebd6	0.93	81.84	2.16	2.51	2026-04-26 13:06:45.313181	841
0ff59da4-ea9a-48c5-9b60-96f17e2644b7	3.48	197.27	1.79	1.11	2026-04-26 13:06:45.313181	842
0c867821-28e1-489c-96ef-a33a16f96004	0.97	72.04	1.41	2.2	2026-04-26 13:06:45.313181	843
6111d377-0b6c-4d93-b288-f7ebce6c00fc	3.22	147.2	1.05	2.8	2026-04-26 13:06:45.313181	844
18905b39-d6a0-4f41-8c02-9b817e1b009d	3.17	186.81	2.22	2.59	2026-04-26 13:06:45.313181	845
8b417aee-680e-4081-85f2-5a160fb2ff12	2.39	240.19	1.24	2.05	2026-04-26 13:06:45.313181	846
38b482a7-1f32-4ddc-9349-bcf1da86d546	3.22	177.68	3.99	2.81	2026-04-26 13:06:45.313181	847
02152a87-fd48-4156-bd2f-afe94c4dc7a6	3.25	182.64	2.9	1.73	2026-04-26 13:06:45.313181	848
6a47fed4-5e33-425c-bbc6-691c625d33a7	3.38	283.19	3.74	3	2026-04-26 13:06:45.313181	849
79cd4a3f-adcf-4ce5-9d29-62693c93adf2	1.31	168.96	3.93	2.44	2026-04-26 13:06:45.313181	850
c4391873-3533-4cad-977b-0323fced348e	1.97	62	3.92	2.21	2026-04-26 13:06:45.313181	851
c6338c80-214f-405b-9b0b-7594bb69d230	2.26	162.92	3.95	2.16	2026-04-26 13:06:45.313181	852
382f3f60-7d3c-4ffc-8b2f-94ce32b77254	2.88	288.17	3.16	1.13	2026-04-26 13:06:45.313181	853
cf827a4b-a720-4825-84d4-29f047763f7e	2.4	291.37	3.03	1.69	2026-04-26 13:06:45.313181	854
d5806c60-9752-4845-9128-964d9b723f0b	2.94	159.5	2.48	1.5	2026-04-26 13:06:45.313181	855
96e0af22-02e2-46d4-8224-4db162bd27b6	1.47	218.45	3.22	2.5	2026-04-26 13:06:45.313181	856
9d0c77f5-485a-477d-80ec-8da875eb9852	0.98	234.79	1.04	1.67	2026-04-26 13:06:45.313181	857
c19c4f6a-3738-436e-b7dc-b27df3129b28	1.31	180.16	1.21	2.5	2026-04-26 13:06:45.313181	858
2d78aa7b-b8fb-4cc0-9d8a-f6a927032041	1.73	118.59	3.57	2.23	2026-04-26 13:06:45.313181	859
dbebf850-836f-4532-807c-c1e3f5b5d597	3.32	126.56	3.04	1.82	2026-04-26 13:06:45.313181	860
453f03e0-cb8d-4681-b343-d681f27e84f8	2.87	174.44	3.43	1.23	2026-04-26 13:06:45.313181	861
13d5f24a-3280-4db1-ae8d-4e7ac37dca9d	2.2	257.91	1.49	2.38	2026-04-26 13:06:45.313181	862
40f8a8d7-327f-4f20-a15c-cbd9fb6f5e75	1.23	150.54	3.64	2.11	2026-04-26 13:06:45.313181	863
8cfcaf67-4ae0-46c6-996e-6ce551b4096d	0.9	172.51	3.51	1.92	2026-04-26 13:06:45.313181	864
05bb5c72-6613-4d45-a876-a6c5fb64222e	0.57	115.94	2.68	2.28	2026-04-26 13:06:45.313181	865
37b80a41-5dec-4adb-ac19-126072ec4a13	0.84	135.54	3.69	2.65	2026-04-26 13:06:45.313181	866
514c19e7-d8eb-4f8a-b58c-db01659e571e	2.67	134.03	1.68	1.28	2026-04-26 13:06:45.313181	867
27ded357-dfee-45c6-844b-2108e05a105b	1.07	196.61	1.41	1.03	2026-04-26 13:06:45.313181	868
affc16bb-f7a4-4ff2-90df-48caf7eebddc	1.54	121.87	1.79	1.9	2026-04-26 13:06:45.313181	869
cb0fe3b7-fbc8-479b-bd12-6acfeeeeffeb	1.15	275.7	2.61	1.04	2026-04-26 13:06:45.313181	870
c0f13516-b42b-4edf-8d54-260ed3432c91	3.14	197.14	3.04	2.94	2026-04-26 13:06:45.313181	871
a6b3ffd9-c2dc-4bf3-872f-1d4dfaff44ce	1.76	264.4	2.39	1.09	2026-04-26 13:06:45.313181	872
4c18584e-0e3e-40cc-94a4-dd6106965efb	3	184.79	1.95	2.17	2026-04-26 13:06:45.313181	873
42be6f12-2662-427d-b3bb-9f8fb042cde5	3.14	61.13	2.95	1.81	2026-04-26 13:06:45.313181	874
a9a3a5fa-5c98-4e69-883b-2afa82b1877f	1.8	193.62	3.98	2.93	2026-04-26 13:06:45.313181	875
69ceb13d-c6ba-480a-9bb6-8c94350b80bb	2.87	221.72	2.25	2.6	2026-04-26 13:06:45.313181	876
6946eb18-50ec-477c-808d-f71c98670e15	1.96	185.88	2.95	1.06	2026-04-26 13:06:45.313181	877
db738178-6c85-4003-814c-43efae201f66	1.14	235.31	2.5	2.89	2026-04-26 13:06:45.313181	878
4b5f92c9-7d51-4b0e-a137-acd779a460c0	0.94	174.35	1.12	1.29	2026-04-26 13:06:45.313181	879
343b8afa-f5f3-413a-8faf-37c6af937323	2.7	129.63	3.97	1.66	2026-04-26 13:06:45.313181	880
aa3eddc8-b910-47a9-b691-2ec377a4b6c3	1.92	216.81	1.77	1.13	2026-04-26 13:06:45.313181	881
10412ce9-7326-4907-98fb-f30f329eb834	2.06	147.99	3.7	2.52	2026-04-26 13:06:45.313181	882
a7a83b3b-4904-468d-b1ff-79250bae2178	2.18	196.5	2.88	1.95	2026-04-26 13:06:45.313181	883
de64100b-0d55-4423-8139-e21bf67b1ba3	0.81	80.84	1.02	1.36	2026-04-26 13:06:45.313181	884
48f1cae9-db76-406a-84c3-4b1d3fd1f646	3.43	150.76	2.24	1.44	2026-04-26 13:06:45.313181	885
bff99142-a62f-4628-a6ff-c053c6deb013	1.82	85.09	2.87	1.56	2026-04-26 13:06:45.313181	886
fb073968-3588-453a-85e2-75089d4c03f1	1.49	119.32	2.42	2.78	2026-04-26 13:06:45.313181	887
377f4e07-93cb-4351-8c6b-62851338fdb0	2.54	213.79	2.75	1.54	2026-04-26 13:06:45.313181	888
19bdfc5a-e1d0-463a-b163-7d7a692f73b8	2.8	253.55	2.87	2.2	2026-04-26 13:06:45.313181	889
cbd20eb0-7239-4734-b82b-404600e7d66b	2.66	233.14	3.2	2.43	2026-04-26 13:06:45.313181	890
18c3479d-2072-411f-8d91-9a580608c627	0.93	125.93	2	1.66	2026-04-26 13:06:45.313181	891
ca09ced3-7738-4c9e-887f-d34312c3d8e4	2.91	264.01	1.43	2.5	2026-04-26 13:06:45.313181	892
07a6b221-981a-4cce-bb5d-3d5a872c97b7	3.27	189.49	1.77	2.65	2026-04-26 13:06:45.313181	893
fa753e0b-bcb9-41b7-9c82-6fccd2333db1	2.94	64.82	3.22	1.88	2026-04-26 13:06:45.313181	894
100a7e1e-99f2-4b0d-8a9d-842a454a612f	2.67	283.13	2.46	1.59	2026-04-26 13:06:45.313181	895
41bd264e-1eb3-4ccb-ab43-221d92913239	3.16	214.97	2.37	2.75	2026-04-26 13:06:45.313181	896
b80e97e3-fe08-465e-ac72-eea64d2d6182	2.41	160.8	1.56	1.39	2026-04-26 13:06:45.313181	897
ed596397-26d6-4d02-a2f1-dbbf5f8ab704	2.89	283.56	2.41	2.17	2026-04-26 13:06:45.313181	898
5d36c463-e893-43a2-b567-1e7fbcb3c80c	1.98	157.87	3.97	1.3	2026-04-26 13:06:45.313181	899
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	2.69	104.45	3.96	2.11	2026-04-26 13:06:45.313181	900
b611f2f3-4dce-4565-9634-c5f67f16841f	2.18	234.81	2.2	2.82	2026-04-26 13:06:45.313181	901
af16d415-a7a8-426f-8d38-2ade72d8acb5	1.51	203.54	1.54	2.69	2026-04-26 13:06:45.313181	902
a18f9d90-4ce4-4793-a9c1-9452712601a3	0.59	122.82	2.33	2.99	2026-04-26 13:06:45.313181	903
2421d8dc-3548-4b72-b606-b235ecdf5448	2.14	222.73	2.04	1.76	2026-04-26 13:06:45.313181	904
bb6389a5-9e20-4135-8648-8a813bb296b7	1.7	214.01	3.14	1.42	2026-04-26 13:06:45.313181	905
6447b600-e734-4067-87b1-b915998722b4	1.19	294.69	1.35	1.03	2026-04-26 13:06:45.313181	906
a1fc9f0b-f1e6-4819-9cb5-1ce77541a1b5	1.66	284.2	3.05	1.71	2026-04-26 13:06:45.313181	907
25df9dd3-d744-4a1e-a96b-d1322d6952f5	2.37	152.44	1.08	2.07	2026-04-26 13:06:45.313181	908
8e3909e7-8ee5-4db8-9278-087d2851a6f1	2.44	173.46	1.64	1.17	2026-04-26 13:06:45.313181	909
3fcc2af3-e524-4b65-9649-cc48a58b7463	3.41	223.88	2.64	1.62	2026-04-26 13:06:45.313181	910
3045ab21-e78f-41cf-9f96-102cfd907777	0.66	212.23	1.52	1.08	2026-04-26 13:06:45.313181	911
211e6d92-06f3-4968-ab18-4d3606fb0313	1.14	242.3	3.82	2.8	2026-04-26 13:06:45.313181	912
577c5ceb-5d82-4a67-914e-cc3249432558	1.09	172.08	1.55	1.28	2026-04-26 13:06:45.313181	913
a9955bda-fedb-44d9-b5a6-33b7ceff70cc	2.54	182.83	1.35	1.62	2026-04-26 13:06:45.313181	914
cac6b96e-6c77-4c20-b201-5d059367fbf0	2.21	97.84	1.3	2.72	2026-04-26 13:06:45.313181	915
40b83090-1da5-4f1a-85d6-884f75d306d9	1.62	80.08	2.36	2.48	2026-04-26 13:06:45.313181	916
af6f8bce-ab49-4a79-a40c-4a4aba8d8552	0.98	144.66	1.77	2.73	2026-04-26 13:06:45.313181	917
7674a04d-8f67-4d07-9eab-998e344a03c9	1.27	269.16	3.01	2.79	2026-04-26 13:06:45.313181	918
f97b5670-ef68-4a86-97c0-6385e6ae7405	2.27	111.75	2.4	1.07	2026-04-26 13:06:45.313181	919
4fc26046-1ae2-4e60-99cf-95ef8ee6524a	1.89	120.61	2.41	2.17	2026-04-26 13:06:45.313181	920
e332ef09-be23-4a9d-b003-f886bfae870d	3.16	213.76	3.73	2.62	2026-04-26 13:06:45.313181	921
88f0fd74-5fbe-402b-b1f9-8b0185f9b042	1.76	274.76	1.04	1.68	2026-04-26 13:06:45.313181	922
7289ae0e-9605-4d46-aaee-5b05ddd96e59	3.29	240.64	2.78	2.08	2026-04-26 13:06:45.313181	923
b0318b61-a090-47a1-a30e-1f29ba099262	2.98	266.34	2.82	2.26	2026-04-26 13:06:45.313181	924
26ec3ee2-f140-4f43-b13b-9299796dd2d1	2.09	139.63	2.99	1.28	2026-04-26 13:06:45.313181	925
9dab24c7-177d-4ec4-8c0b-2323b92d3d4a	2.21	170.15	1.55	2.91	2026-04-26 13:06:45.313181	926
1a6d5e85-787b-461f-8db7-9cd8f8d81ece	1.7	175.39	2.84	2.11	2026-04-26 13:06:45.313181	927
27b23042-92c6-4a49-b397-6c200041d8ee	2.88	85.31	1.56	2.56	2026-04-26 13:06:45.313181	928
08f0acf7-18ec-45eb-8146-8042969d5c7a	3.49	222.26	2.8	1.49	2026-04-26 13:06:45.313181	929
a03af7ca-2046-499e-b19d-b6571e696f89	2.61	145.45	2.3	2.22	2026-04-26 13:06:45.313181	930
e7fd011f-5572-4ee9-a3de-2d9d4d5c818d	1.35	172.58	1.79	1.03	2026-04-26 13:06:45.313181	931
4065ab51-f74f-42a2-9363-7146df43c932	2.09	80.09	1.55	1.48	2026-04-26 13:06:45.313181	932
a07f2ed2-35ae-4720-ad65-a22fe59566d3	1.19	179.15	3.83	1.37	2026-04-26 13:06:45.313181	933
02c4237f-a7f5-452b-82c3-1fe296af3c3c	0.79	118.45	2.02	2.82	2026-04-26 13:06:45.313181	934
62b7cf0d-cf31-493a-85aa-8fa347acda25	1.63	191.34	2.77	2.03	2026-04-26 13:06:45.313181	935
ab3db038-d69b-451e-bba3-08e8119898b4	3.2	235.06	3.19	2.02	2026-04-26 13:06:45.313181	936
b685932b-8a27-4288-8795-f6e05e9e4cef	1.2	290.4	2.75	2.48	2026-04-26 13:06:45.313181	937
9cd7e4f4-8d1a-48da-abbc-075218e9e7a6	0.87	290.36	3.46	2.66	2026-04-26 13:06:45.313181	938
98d2ddcf-4cfa-4405-9501-d661884b1017	3.45	288.63	1.29	2.54	2026-04-26 13:06:45.313181	939
d0655207-0783-4e94-98d2-176fe26849d8	3.02	92.92	2.04	2.22	2026-04-26 13:06:45.313181	940
bcad4d42-8a4f-4b72-a2e1-b607651d5c31	3.26	285.4	3.01	2.91	2026-04-26 13:06:45.313181	941
9ed4929a-d3c0-4954-b272-227a89cbedec	1.92	116.48	2.12	2.61	2026-04-26 13:06:45.313181	942
edcb7d15-e6ed-461f-b1b4-38a993ff2ec7	2.18	279.71	3.38	2.71	2026-04-26 13:06:45.313181	943
2f5d7c02-eadd-4eb2-8dd5-46a5ba51c3f8	0.6	87.91	3.95	3	2026-04-26 13:06:45.313181	944
0ad0a6eb-d13c-440c-b74c-0391605d9685	2.78	232.04	1.21	1.5	2026-04-26 13:06:45.313181	945
2bb8c959-19b6-4951-8313-e6d0413c9a6f	1.75	135.69	3.58	2.35	2026-04-26 13:06:45.313181	946
303a312c-4f87-408c-b20b-03d848ec9055	0.54	113.76	2.09	1.72	2026-04-26 13:06:45.313181	947
a32bfdcd-5dd9-4a93-85e7-c1e608df83ee	2.93	208.03	3.17	2.11	2026-04-26 13:06:45.313181	948
5ccc6390-43ca-49f5-b6fa-84247d3e52af	2.34	152.34	3.24	1.88	2026-04-26 13:06:45.313181	949
df299e49-61f2-49ce-8051-e50cfc0b2650	0.78	210.65	3.81	2.36	2026-04-26 13:06:45.313181	950
86ef6ade-b308-467a-8c42-3c6e4c20ec8d	1.86	277.22	1.03	1.36	2026-04-26 13:06:45.313181	951
e318d53f-7605-468a-b41d-051070be96a3	2.36	166.63	3.73	1.64	2026-04-26 13:06:45.313181	952
efc0c233-0113-480b-b3e6-ca3275b5ffde	2.12	96.09	3.24	1.67	2026-04-26 13:06:45.313181	953
5808ae27-83d1-4163-9187-6a23f988dc97	2.36	148.12	2.15	1.64	2026-04-26 13:06:45.313181	954
e304e2e6-fd72-4399-b4d7-fb6416b81f0c	2.84	184.65	3.93	2.88	2026-04-26 13:06:45.313181	955
678ae26f-569d-4c0e-b4a9-0a688fc0936a	3.35	191.03	3.46	2.43	2026-04-26 13:06:45.313181	956
6438657c-ee67-48b5-8de0-62eeb64e0a87	1.66	145.31	1.59	2.86	2026-04-26 13:06:45.313181	957
e3216b17-e320-4d0f-ada0-b93e60caca02	0.84	96.8	3.77	2.9	2026-04-26 13:06:45.313181	958
63188d13-0344-4b51-aa79-19ea416c8cdd	3.3	247.92	3.42	1.43	2026-04-26 13:06:45.313181	959
17932bb9-836e-4db9-b27e-bd1b2f574954	1.58	72.73	2.05	2.75	2026-04-26 13:06:45.313181	960
459418c3-7fb1-4dd5-9c2b-6a0eb1e128a7	3.13	195.48	2.75	1.16	2026-04-26 13:06:45.313181	961
4d88229f-55e4-476b-bfc0-096795c485e4	0.63	124.55	3.82	1.8	2026-04-26 13:06:45.313181	962
2ce612e7-1b0e-4a98-aab2-d00e087e7acd	1.36	165.08	3.5	2.52	2026-04-26 13:06:45.313181	963
f1c04ba0-d43a-4055-8726-0674ce5a9591	1.34	100.28	2	2.71	2026-04-26 13:06:45.313181	964
b4617646-5ec4-4d15-a573-c29cffb7c27f	2.85	212.28	2.53	2.01	2026-04-26 13:06:45.313181	965
c02600b3-e48e-4409-95a3-eb683e336b10	1.89	61.16	2.9	2.92	2026-04-26 13:06:45.313181	966
fc365d4b-670e-4fca-8c15-bed27e9c7c64	1.5	153.67	2.18	1.21	2026-04-26 13:06:45.313181	967
b5bfff34-218c-48cd-b9ce-673eea91bda1	2.19	262.16	2.51	1.29	2026-04-26 13:06:45.313181	968
0ef3d984-2e82-4672-bcd6-c49dfd8397b3	1.9	177.47	3.86	1.82	2026-04-26 13:06:45.313181	969
869589e4-a12e-4a97-9558-0e078bfadd07	2.53	155.32	2.8	2.04	2026-04-26 13:06:45.313181	970
fc37eb73-af1d-4f66-ab8d-ac6cd664ceea	0.99	184.36	3.87	2.53	2026-04-26 13:06:45.313181	971
f182189b-b6e2-4aee-bb22-5b1e555815b6	2.63	243.55	1.06	2.55	2026-04-26 13:06:45.313181	972
4a03155b-1956-495a-aa04-f02a9c3d31c8	3.49	50.82	3.95	2.68	2026-04-26 13:06:45.313181	973
6b9cb1d4-e93d-40cb-8099-44f30eae119b	3.46	236.6	2.23	2.61	2026-04-26 13:06:45.313181	974
77c9a885-1040-44e4-8b7c-18dccb3b1a81	2.39	52.71	3.74	2.68	2026-04-26 13:06:45.313181	975
ab089221-71a5-4b3c-a06e-445f999eed0a	3.23	293.24	1.42	2.55	2026-04-26 13:06:45.313181	976
2954b16d-0db5-4232-8923-ca1c2a81be0a	1.46	248.42	3.51	2.6	2026-04-26 13:06:45.313181	977
e072183d-f51e-4965-a227-e111304e8104	1.92	118.39	1.59	1.33	2026-04-26 13:06:45.313181	978
d59dcfa3-ec8d-4789-81cd-22e13a9c829c	2.55	129.3	2.44	1.9	2026-04-26 13:06:45.313181	979
e32ad455-b5bd-49ef-b295-f81c8a11da16	2.95	294.09	1.39	1.2	2026-04-26 13:06:45.313181	980
21d6e120-8fa3-4a51-9ade-436c7d77e075	1.85	173.45	1.16	2.36	2026-04-26 13:06:45.313181	981
efff145d-5625-4a2c-ac23-ffdccad3e85b	1.63	274.43	2.06	1.51	2026-04-26 13:06:45.313181	982
1a64a717-44a3-4308-9eaa-d6a37163544c	1.13	71.92	1.93	2.32	2026-04-26 13:06:45.313181	983
474c6490-57e2-4c5c-ad69-dc1c4cf6b1f5	1.85	222.53	2.78	1.55	2026-04-26 13:06:45.313181	984
7f85773c-30b2-4ff2-877a-93f568213806	1.2	112.06	2.42	2.43	2026-04-26 13:06:45.313181	985
4d87ace7-e3ee-4ea4-92f6-c395ef501428	2.33	250.15	2.81	2.77	2026-04-26 13:06:45.313181	986
4d289278-e3f8-42ed-af6a-2d3259072f3f	2.12	179	2.33	1.54	2026-04-26 13:06:45.313181	987
ebffe864-14eb-465e-b745-192f6e5717bf	2.25	154.46	2.37	1.4	2026-04-26 13:06:45.313181	988
fb9a49ca-e5e2-4be1-9e2c-5d77c4db770b	1.76	170.85	2.03	2.31	2026-04-26 13:06:45.313181	989
150f7991-fbd0-429e-bdf9-c60b50b1aae6	2.48	276.05	3.62	2.01	2026-04-26 13:06:45.313181	990
569b5e54-a5e6-442c-94e0-64a8245dcd07	2.59	50.63	3.74	1.21	2026-04-26 13:06:45.313181	991
1525c80d-cf06-4108-bab9-0205f6ed78f7	0.58	276.92	2.58	1.75	2026-04-26 13:06:45.313181	992
c6e7314c-8525-4191-80c2-2c3a921f415d	2.12	138.41	2.57	1.62	2026-04-26 13:06:45.313181	993
01d04063-d9c3-43b8-9cd1-f2c365206958	1.5	148.1	2.81	2.06	2026-04-26 13:06:45.313181	994
688a8c3f-fa38-4308-89d5-212d6faf8a77	0.75	225.88	1.64	2.98	2026-04-26 13:06:45.313181	995
80f0e0e1-a56b-4969-9328-300dd7d3889e	2.23	269.56	1.26	2.88	2026-04-26 13:06:45.313181	996
bf4c1fb6-a269-4569-be90-6b6a998ee7b9	1.81	253.95	3.23	1.45	2026-04-26 13:06:45.313181	997
4421a7a4-be54-4494-b732-9068a725e9b7	3.02	201.5	2.48	2.05	2026-04-26 13:06:45.313181	998
5d9bfdd7-0a23-41a4-bff6-1d1b588e6b78	2.67	66.74	2.68	1.87	2026-04-26 13:06:45.313181	999
9272aa0e-60be-48a7-b1a9-e260a3fcd3d2	1.69	147.42	1.97	2.87	2026-04-26 13:06:45.313181	1000
cd6c4c38-b00a-4644-b1a1-7fc4b8c0ef46	1.77	286.57	3.03	1.22	2026-04-26 13:06:45.313181	1001
903c34b0-9809-44ee-af0c-97ca045cde31	2.31	173.54	1.01	2.23	2026-04-26 13:06:45.313181	1002
ec564929-5d5d-4964-85c9-c2c00181550b	1.45	69.98	1.68	1.28	2026-04-26 13:06:45.313181	1003
eb5b0417-51b7-4630-89a7-fbac16715f99	3.19	63.6	3.16	1.99	2026-04-26 13:06:45.313181	1004
2f71377b-f84e-4d62-a2dd-610ad858eff9	1.55	185.5	2.71	2.86	2026-04-26 13:06:45.313181	1005
ccefa4d3-0ac6-49b4-b548-44dbecf95314	1.39	62.27	3.67	2.63	2026-04-26 13:06:45.313181	1006
641085c9-c0f6-4e22-ba3b-1fb94f36d101	1.86	68.07	2.35	1.56	2026-04-26 13:06:45.313181	1007
98771193-9965-407f-9a85-7fede6b77203	2.48	219.58	1.15	1.6	2026-04-26 13:06:45.313181	1008
a4f48f59-b6eb-49b5-bda3-c4cbe0959ccc	3.45	86.96	3.95	2.47	2026-04-26 13:06:45.313181	1009
349fd483-5e87-4860-902e-0499901d0595	2.57	125.73	1.69	1.42	2026-04-26 13:06:45.313181	1010
9c9909c7-05a2-4227-acf9-28521c0da135	3.32	170.28	2.33	2.8	2026-04-26 13:06:45.313181	1011
f305ad8e-b6cd-4ccb-8d44-e33845a294a1	0.7	111.3	2.95	1.36	2026-04-26 13:06:45.313181	1012
baa2883c-e58b-4231-a08f-44235a4dea80	1.27	243.94	3.25	2.47	2026-04-26 13:06:45.313181	1013
0d8f1e65-863d-45d8-bd85-f7a7bb2a19d6	2.76	96.55	1.23	1.78	2026-04-26 13:06:45.313181	1014
1274b8fd-1c04-42fe-ae89-7ee5494a8909	0.75	270.47	1.17	1.14	2026-04-26 13:06:45.313181	1015
177aba49-3dfa-4284-870d-fb28b84d4534	3	78.42	1.74	2.54	2026-04-26 13:06:45.313181	1016
a3e55969-7679-400e-b2f8-63e2955e54c2	1.36	110.93	1.7	1.3	2026-04-26 13:06:45.313181	1017
ccea675a-ef56-4f85-b8c5-317c8ce5a850	1.76	52.41	3.39	1.78	2026-04-26 13:06:45.313181	1018
3aa10c1e-2460-4377-b65a-f47990cf20a4	2.43	65.87	2.87	2.4	2026-04-26 13:06:45.313181	1019
95049103-faa4-4e21-9165-033861d9c488	2.57	155.7	2.92	1.01	2026-04-26 13:06:45.313181	1020
2c47bb0c-f0bc-43ef-97b7-ec4d8c96c29f	1.54	181.19	1.28	1.12	2026-04-26 13:06:45.313181	1021
c1b55a4f-d015-496a-97a5-0eda929e3dc3	0.7	251.23	3.02	1.77	2026-04-26 13:06:45.313181	1022
b8174b2e-1cb1-472c-ac48-c2a6912e48de	3.26	155.43	1.18	1.53	2026-04-26 13:06:45.313181	1023
ef342171-814f-4d88-ba4b-9c3e820c63de	1.59	156.07	1.14	2.45	2026-04-26 13:06:45.313181	1024
ff142781-a79f-4ff4-a703-7732aa9af9e3	2.74	260.19	1.36	2.53	2026-04-26 13:06:45.313181	1025
53988c3d-02b2-4be9-95b5-739ffb19f562	3.45	291.87	2.35	1.38	2026-04-26 13:06:45.313181	1026
90e0676d-9543-455e-b95b-033a3dc29094	2.36	261.19	1.94	2.29	2026-04-26 13:06:45.313181	1027
aa53d45e-4f36-4897-b499-3ed698190647	0.69	66.21	2.5	2.87	2026-04-26 13:06:45.313181	1028
0d2cac97-cb24-4e98-8c0f-4356b3e97f0a	3.28	182.54	1.35	1.46	2026-04-26 13:06:45.313181	1029
3781bb39-94d7-41ab-bddb-e6008d65fc3e	2.09	191.12	1.02	2.35	2026-04-26 13:06:45.313181	1030
9c7b719e-b70f-4394-9ff1-ed98e6b5cc58	1.87	151.87	2.95	2.05	2026-04-26 13:06:45.313181	1031
e7450082-184d-42e5-9e10-1ba889b81e15	3.2	283.47	2.63	1.11	2026-04-26 13:06:45.313181	1032
7f8cdea0-97fa-4f5c-a07d-339312618900	2.39	290.74	1.94	1.56	2026-04-26 13:06:45.313181	1033
1cdd7dbf-0fb2-4741-b2ce-1648f6588f83	1.28	53.12	2.43	2.43	2026-04-26 13:06:45.313181	1034
addb0a76-380c-4a6e-81a0-5642a291744d	0.64	151.87	3.5	2.42	2026-04-26 13:06:45.313181	1035
37353a0a-b1de-4f16-ade8-742e357bff71	2.34	264.07	3.99	1.08	2026-04-26 13:06:45.313181	1036
d806cbd2-e0cc-4e83-84a5-7e939ebd4b95	1.04	242.16	3.19	1.8	2026-04-26 13:06:45.313181	1037
84970f72-5d25-45d2-96d7-3ed2f3315168	2.47	80.11	2.21	2.99	2026-04-26 13:06:45.313181	1038
80fbbed9-4a78-4bd2-87e9-af704fc2de31	1.38	171.55	3.22	2.53	2026-04-26 13:06:45.313181	1039
8a2c8802-0ed7-4c68-b865-2b6b9b4e467b	3.42	189.96	2.47	1.37	2026-04-26 13:06:45.313181	1040
92491d57-33b8-476b-b82f-4d782b7925be	1.37	160.15	2.65	1.2	2026-04-26 13:06:45.313181	1041
101a0017-9d06-4cab-9376-10fca55b80fe	1.39	259.58	1.21	1.79	2026-04-26 13:06:45.313181	1042
7a670221-9a34-46e2-b81b-1d7085b29ac8	1.39	233.3	2.56	1.22	2026-04-26 13:06:45.313181	1043
b486f1ad-7297-436a-929a-3696998a7284	1.55	140.65	3.1	1.84	2026-04-26 13:06:45.313181	1044
ef7e5768-abc3-451c-8700-eadd22e0526f	2.05	287.41	2.16	1.23	2026-04-26 13:06:45.313181	1045
6a47fed4-5e33-425c-bbc6-691c625d33a7	3.38	283.19	3.74	3	2026-04-26 13:17:49.822693	1046
6a47fed4-5e33-425c-bbc6-691c625d33a7	3.38	283.19	3.74	3	2026-04-26 13:17:49.822693	1047
6a47fed4-5e33-425c-bbc6-691c625d33a7	3.38	283.19	3.74	3	2026-04-26 13:17:49.822693	1048
6a47fed4-5e33-425c-bbc6-691c625d33a7	3.38	283.19	3.74	3	2026-04-26 13:17:49.822693	1049
37353a0a-b1de-4f16-ade8-742e357bff71	2.34	264.07	3.99	1.08	2026-04-26 13:17:49.822693	1050
083b503f-bc9a-4761-9232-985118e3bde4	2.67	232.45	3.34	2.87	2026-04-26 13:17:50.841711	1051
84898f92-b30c-4251-99c5-6d4b8ee07428	1.74	261.68	1.65	1.45	2026-04-26 13:17:50.841711	1052
1798c0d0-79e4-4d2b-9f3f-990b125d2105	1.87	97.16	2.57	1.97	2026-04-26 13:17:50.841711	1053
d4454c95-37c1-4467-a22e-9fb7abac08a2	3.44	296.39	3.73	2.98	2026-04-26 13:17:50.841711	1054
1dc79f19-741d-4d47-8552-5e53debeed00	3.41	87.42	1.76	1.51	2026-04-26 13:17:50.841711	1055
127074f4-ef1e-44c6-b9d4-6e159522fe6d	3.14	282.11	1.51	1.69	2026-04-26 13:17:50.841711	1056
933c3358-c4a9-4190-ba36-d320f41b28bd	0.66	167.66	1.99	1.73	2026-04-26 13:17:50.841711	1057
24c4b5e6-9375-4a3d-aa2e-8ecf73311e2a	1.79	110.15	1.05	1.87	2026-04-26 13:17:50.841711	1058
8459b204-828a-433c-946a-16940b23fe20	3.1	59.33	2.59	2.71	2026-04-26 13:17:50.841711	1059
6c67de4d-14df-473a-b5b7-234ca1892d36	1.09	232.7	3.76	1.57	2026-04-26 13:17:50.841711	1060
1a1da762-8b17-44fc-ab54-aacee70233c0	3.32	296.51	1.72	2.98	2026-04-26 13:17:50.841711	1061
eaf83308-161d-4cbe-9a8f-c87d75ee5421	0.71	137.16	2.3	2.95	2026-04-26 13:17:50.841711	1062
2639cd66-3527-4a6d-b26e-dfb2491c1bf2	1.67	140.43	1.82	1.18	2026-04-26 13:17:50.841711	1063
8d34dd99-e669-4ca7-99af-1d91991a09c9	0.59	152.2	4	1.82	2026-04-26 13:17:50.841711	1064
77398e9d-8c73-4cfb-9019-93696911c12d	2.71	232.79	1.16	2.31	2026-04-26 13:17:50.841711	1065
af79ed93-81e1-4dad-ab43-483f230ed7d4	2.27	293.91	1.31	2.16	2026-04-26 13:17:50.841711	1066
a09b5914-31d8-4628-bfde-a2ed4f60f907	2.16	238.97	1.4	1.38	2026-04-26 13:17:50.841711	1067
af5d64a0-8fd6-4135-9b5c-ed9a17afe722	2.31	264.18	3.76	1.02	2026-04-26 13:17:50.841711	1068
48f2ef4f-6f48-4a5a-8aca-e2844be19a4d	1.38	184.34	2.02	2.74	2026-04-26 13:17:50.841711	1069
c4a5295a-ac7e-4505-ae47-069a3a50ecec	2.92	62.05	3.47	2.33	2026-04-26 13:17:50.841711	1070
0cdc07b0-d122-4345-a871-ed8736125a13	1.16	147.34	2.23	1.56	2026-04-26 13:17:50.841711	1071
8be3185b-bc1c-4142-b567-48aaff220b01	2.4	56.2	2.47	1.02	2026-04-26 13:17:50.841711	1072
d9051e4d-d569-4f01-89e0-7d857762afe5	3.41	140.35	2.77	2.19	2026-04-26 13:17:50.841711	1073
3fad7c09-4ab3-4a8b-aa29-7211513f7237	0.86	214.91	2.73	1.72	2026-04-26 13:17:50.841711	1074
dbbf360e-7216-4601-8614-038fe1dcc2ba	1.37	138.37	2.05	1.14	2026-04-26 13:17:50.841711	1075
9bd9f3c5-1b49-4927-8cdf-35373636ae00	2.21	102.67	2.45	2.37	2026-04-26 13:17:50.841711	1076
160d3adf-6a5a-4442-8c35-f8ff730e0036	1.03	69.29	2.03	1.43	2026-04-26 13:17:50.841711	1077
5c42027f-8aaa-441b-990e-215c05fc0300	2.1	59.53	2.25	1.08	2026-04-26 13:17:50.841711	1078
bfc1d7fb-6dd6-42fd-a795-053bca272428	2.12	241.28	2.08	2.22	2026-04-26 13:17:50.841711	1079
fe19663b-26a2-40d0-a329-bf3f1f6a25a6	3.04	123.97	3.31	1.3	2026-04-26 13:17:50.841711	1080
09bcbc34-b01a-4878-88ae-4aac9ea91b2d	3.47	203.87	2.96	1.81	2026-04-26 13:17:50.841711	1081
28aa7be3-ebf0-4bfb-9e4d-8eb57e7a1a09	0.56	187.74	3.93	2.79	2026-04-26 13:17:50.841711	1082
a463568f-08c1-4eee-ba9f-87eca478959e	1.13	278.73	3.56	1.79	2026-04-26 13:17:50.841711	1083
e91e2255-deed-4ffc-9e86-da19ee4fe2be	0.64	149.77	1.88	1.11	2026-04-26 13:17:50.841711	1084
e6c3818b-29f0-4e36-9052-5e1482339405	1.42	140.65	1.97	1.96	2026-04-26 13:17:50.841711	1085
80d81f80-2426-4c17-9e8a-321da7361798	2.49	138.02	2.46	1.15	2026-04-26 13:17:50.841711	1086
6f817b31-ed87-46bb-9e2e-1140f4cb4cbb	2.41	203.98	1.42	1.24	2026-04-26 13:17:50.841711	1087
34c9e297-d7dc-4168-a5a5-8e7e148dcbbd	3.4	63.42	2.18	1.47	2026-04-26 13:17:50.841711	1088
06c52bbf-cbe5-4db7-997a-9f747283665e	2.21	137.81	3.48	2.94	2026-04-26 13:17:50.841711	1089
0404794e-0a50-4824-a0ee-921cb23888ee	2.49	130.83	1.95	2.57	2026-04-26 13:17:50.841711	1090
ff75e776-7227-4220-9f32-33a6013ae67f	1.54	63	2.63	1.06	2026-04-26 13:17:50.841711	1091
522e7eca-7dde-4bb5-9cfd-7bfc1f5aa823	2.75	85.5	2.94	2.78	2026-04-26 13:17:50.841711	1092
0670c059-cbff-4d6e-97fa-c2dbd81ba878	3.05	240.06	1.58	2.64	2026-04-26 13:17:50.841711	1093
41623b9e-303f-46b1-82d3-8883c4a479bb	2.84	200.49	1.11	1.08	2026-04-26 13:17:50.841711	1094
8425054a-27fe-45f7-a2d1-0ca5bb87c22d	3.47	98.11	3.91	1.91	2026-04-26 13:17:50.841711	1095
88f2dc8f-4748-490e-b92d-e31ba6ddaf7b	1.6	264.66	2.74	2.11	2026-04-26 13:17:50.841711	1096
71e03cf9-1c81-44c0-9c0f-63591e58aa30	2.43	235.86	3.53	1.88	2026-04-26 13:17:50.841711	1097
bc2f02a5-cb1e-4610-ac0e-ba7f24c18ccd	2.46	177.93	2.07	1.03	2026-04-26 13:17:50.841711	1098
c110010b-1088-4e02-be3c-83c511d7831c	0.6	191.66	3.55	1.93	2026-04-26 13:17:50.841711	1099
fe8407a5-d6f0-4b63-b0c1-71ad87ffab96	2.66	170.97	3.27	2.29	2026-04-26 13:17:50.841711	1100
19646a15-fc51-45ea-b837-9703ea5e5f8c	2.51	180.22	3.18	2.6	2026-04-26 13:17:50.841711	1101
048313b2-21ec-4fbc-be08-2f0c27fa77f6	1.26	298.52	1.29	2.98	2026-04-26 13:17:50.841711	1102
66ae13b0-bc41-401b-919a-a47c2d82b9ef	3.42	258.1	2.25	1.41	2026-04-26 13:17:50.841711	1103
d87f65c7-d638-4f26-a825-aff5ae57457b	1.09	245.44	1.52	2.46	2026-04-26 13:17:50.841711	1104
7931d397-9cb6-40aa-888c-6b1cfe481a74	2.55	85.61	2.33	1.05	2026-04-26 13:17:50.841711	1105
a63e2468-ff52-45a6-a5cd-59944a3859bb	3.01	212.43	3.25	1.96	2026-04-26 13:17:50.841711	1106
2c170f3c-70f5-4432-9675-baa82539a713	1.04	65.64	2.64	1.66	2026-04-26 13:17:50.841711	1107
a49a8d86-d915-4488-b843-de71b33e91fd	2.79	151.65	2.05	1.79	2026-04-26 13:17:50.841711	1108
b2cd1843-50e3-475c-b68b-24bcf035d14a	1.53	177.96	1.85	2.59	2026-04-26 13:17:50.841711	1109
49214cd6-15b3-43e2-b004-f11980bd76e7	1.16	59.25	1.42	1.35	2026-04-26 13:17:50.841711	1110
da38da3e-9316-49d8-af58-cfca2be2ecea	1.47	77.21	2.2	2.02	2026-04-26 13:17:50.841711	1111
06e503be-bdf4-4afe-9252-ad4307d77d34	1.14	184.51	2.36	1.41	2026-04-26 13:17:50.841711	1112
e07bf42f-e0df-4ae0-8b19-59673c872bf2	0.92	90.09	1.86	1.42	2026-04-26 13:17:50.841711	1113
d9ff0e43-523c-4157-b412-c6e488086313	1.11	63.38	1.37	1.13	2026-04-26 13:17:50.841711	1114
73605445-18c0-4c79-aa20-abe75a2aa504	2.53	267.12	1.22	2.64	2026-04-26 13:17:50.841711	1115
17d1d4a8-7fff-4e9d-be6b-1ad8cff6ebd6	2.6	265.22	3.72	2.28	2026-04-26 13:17:50.841711	1116
0ff59da4-ea9a-48c5-9b60-96f17e2644b7	0.71	71.55	3.24	1.72	2026-04-26 13:17:50.841711	1117
0c867821-28e1-489c-96ef-a33a16f96004	0.76	286.24	1.05	1.17	2026-04-26 13:17:50.841711	1118
6111d377-0b6c-4d93-b288-f7ebce6c00fc	2.02	118.73	2.83	1.65	2026-04-26 13:17:50.841711	1119
18905b39-d6a0-4f41-8c02-9b817e1b009d	1.24	136.24	2.62	1.94	2026-04-26 13:17:50.841711	1120
8b417aee-680e-4081-85f2-5a160fb2ff12	1.12	274.02	1.4	2.27	2026-04-26 13:17:50.841711	1121
38b482a7-1f32-4ddc-9349-bcf1da86d546	0.5	264.54	2.13	2.95	2026-04-26 13:17:50.841711	1122
02152a87-fd48-4156-bd2f-afe94c4dc7a6	2.14	269.39	2.02	1.55	2026-04-26 13:17:50.841711	1123
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.16	163.75	1.98	2.61	2026-04-26 13:17:50.841711	1124
79cd4a3f-adcf-4ce5-9d29-62693c93adf2	2.72	221.48	2.28	2.94	2026-04-26 13:17:50.841711	1125
c4391873-3533-4cad-977b-0323fced348e	1.65	298.17	1.05	1.15	2026-04-26 13:17:50.841711	1126
c6338c80-214f-405b-9b0b-7594bb69d230	2.66	100.76	1.01	2.69	2026-04-26 13:17:50.841711	1127
382f3f60-7d3c-4ffc-8b2f-94ce32b77254	2.39	141.56	1.39	2.61	2026-04-26 13:17:50.841711	1128
cf827a4b-a720-4825-84d4-29f047763f7e	1.95	166.53	1.91	1.4	2026-04-26 13:17:50.841711	1129
d5806c60-9752-4845-9128-964d9b723f0b	1.06	270.15	3.59	2.19	2026-04-26 13:17:50.841711	1130
96e0af22-02e2-46d4-8224-4db162bd27b6	2.92	155.69	3.29	1.62	2026-04-26 13:17:50.841711	1131
9d0c77f5-485a-477d-80ec-8da875eb9852	0.62	73.31	1.5	2.36	2026-04-26 13:17:50.841711	1132
c19c4f6a-3738-436e-b7dc-b27df3129b28	3.48	217.3	1.28	2.41	2026-04-26 13:17:50.841711	1133
2d78aa7b-b8fb-4cc0-9d8a-f6a927032041	1.47	159.62	1.52	2.68	2026-04-26 13:17:50.841711	1134
dbebf850-836f-4532-807c-c1e3f5b5d597	2.54	66.26	3.67	2.62	2026-04-26 13:17:50.841711	1135
453f03e0-cb8d-4681-b343-d681f27e84f8	2.63	256.34	2.38	1.55	2026-04-26 13:17:50.841711	1136
13d5f24a-3280-4db1-ae8d-4e7ac37dca9d	2.49	183.15	1.46	1.23	2026-04-26 13:17:50.841711	1137
40f8a8d7-327f-4f20-a15c-cbd9fb6f5e75	1.8	243.7	1.83	1.32	2026-04-26 13:17:50.841711	1138
8cfcaf67-4ae0-46c6-996e-6ce551b4096d	1.72	119.36	2.54	2.98	2026-04-26 13:17:50.841711	1139
05bb5c72-6613-4d45-a876-a6c5fb64222e	1.2	76.42	3.56	1.15	2026-04-26 13:17:50.841711	1140
37b80a41-5dec-4adb-ac19-126072ec4a13	2.67	81.15	3.11	2.68	2026-04-26 13:17:50.841711	1141
514c19e7-d8eb-4f8a-b58c-db01659e571e	1.94	237.96	2.79	2.87	2026-04-26 13:17:50.841711	1142
27ded357-dfee-45c6-844b-2108e05a105b	1.4	94.07	1.4	2.54	2026-04-26 13:17:50.841711	1143
affc16bb-f7a4-4ff2-90df-48caf7eebddc	1.38	273.19	3.94	2.92	2026-04-26 13:17:50.841711	1144
cb0fe3b7-fbc8-479b-bd12-6acfeeeeffeb	0.54	80.96	1.94	2.49	2026-04-26 13:17:50.841711	1145
c0f13516-b42b-4edf-8d54-260ed3432c91	0.92	289.06	3.42	1.73	2026-04-26 13:17:50.841711	1146
a6b3ffd9-c2dc-4bf3-872f-1d4dfaff44ce	2.9	123.04	2.42	1.55	2026-04-26 13:17:50.841711	1147
4c18584e-0e3e-40cc-94a4-dd6106965efb	1.12	163.54	2.45	1.33	2026-04-26 13:17:50.841711	1148
42be6f12-2662-427d-b3bb-9f8fb042cde5	1.12	213.2	1.72	1.38	2026-04-26 13:17:50.841711	1149
a9a3a5fa-5c98-4e69-883b-2afa82b1877f	0.83	265.49	3.53	2.2	2026-04-26 13:17:50.841711	1150
69ceb13d-c6ba-480a-9bb6-8c94350b80bb	1.11	236.89	2.38	2.41	2026-04-26 13:17:50.841711	1151
6946eb18-50ec-477c-808d-f71c98670e15	3.34	169.45	1.61	2.62	2026-04-26 13:17:50.841711	1152
db738178-6c85-4003-814c-43efae201f66	3.5	236.18	3.81	1.97	2026-04-26 13:17:50.841711	1153
4b5f92c9-7d51-4b0e-a137-acd779a460c0	1.58	249.62	3.72	2.36	2026-04-26 13:17:50.841711	1154
343b8afa-f5f3-413a-8faf-37c6af937323	2.17	71.01	2.25	1.94	2026-04-26 13:17:50.841711	1155
aa3eddc8-b910-47a9-b691-2ec377a4b6c3	2.57	270.4	3.45	1.1	2026-04-26 13:17:50.841711	1156
10412ce9-7326-4907-98fb-f30f329eb834	1.55	273.12	3.36	2.54	2026-04-26 13:17:50.841711	1157
a7a83b3b-4904-468d-b1ff-79250bae2178	3.09	77.18	2.41	1.99	2026-04-26 13:17:50.841711	1158
de64100b-0d55-4423-8139-e21bf67b1ba3	3.36	188.4	1.82	2.26	2026-04-26 13:17:50.841711	1159
48f1cae9-db76-406a-84c3-4b1d3fd1f646	1.59	205.58	3.58	1.55	2026-04-26 13:17:50.841711	1160
bff99142-a62f-4628-a6ff-c053c6deb013	3.11	204.17	1.68	2.11	2026-04-26 13:17:50.841711	1161
fb073968-3588-453a-85e2-75089d4c03f1	1.33	172.83	1.48	1.15	2026-04-26 13:17:50.841711	1162
377f4e07-93cb-4351-8c6b-62851338fdb0	1.86	110.56	1.48	1.28	2026-04-26 13:17:50.841711	1163
19bdfc5a-e1d0-463a-b163-7d7a692f73b8	2.3	206.42	1.17	2.7	2026-04-26 13:17:50.841711	1164
cbd20eb0-7239-4734-b82b-404600e7d66b	3.32	57.39	1.06	2.25	2026-04-26 13:17:50.841711	1165
18c3479d-2072-411f-8d91-9a580608c627	2.9	192.56	3.41	2.79	2026-04-26 13:17:50.841711	1166
ca09ced3-7738-4c9e-887f-d34312c3d8e4	3.35	299.22	3.2	1.72	2026-04-26 13:17:50.841711	1167
07a6b221-981a-4cce-bb5d-3d5a872c97b7	3.18	93.64	1.08	2.69	2026-04-26 13:17:50.841711	1168
fa753e0b-bcb9-41b7-9c82-6fccd2333db1	2.17	155.28	2.23	2.27	2026-04-26 13:17:50.841711	1169
100a7e1e-99f2-4b0d-8a9d-842a454a612f	1.94	123.54	3.84	2.91	2026-04-26 13:17:50.841711	1170
41bd264e-1eb3-4ccb-ab43-221d92913239	1.3	61.39	1.67	1.24	2026-04-26 13:17:50.841711	1171
b80e97e3-fe08-465e-ac72-eea64d2d6182	2.36	148.52	3.07	1.52	2026-04-26 13:17:50.841711	1172
ed596397-26d6-4d02-a2f1-dbbf5f8ab704	0.68	157.39	3.01	2.85	2026-04-26 13:17:50.841711	1173
5d36c463-e893-43a2-b567-1e7fbcb3c80c	1.86	240.71	1.39	1.48	2026-04-26 13:17:50.841711	1174
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	2.75	235.01	3.68	2.75	2026-04-26 13:17:50.841711	1175
b611f2f3-4dce-4565-9634-c5f67f16841f	2.97	184.37	2.97	2.64	2026-04-26 13:17:50.841711	1176
af16d415-a7a8-426f-8d38-2ade72d8acb5	2.63	107.58	2.77	2.46	2026-04-26 13:17:50.841711	1177
a18f9d90-4ce4-4793-a9c1-9452712601a3	3	268.49	1.04	2.76	2026-04-26 13:17:50.841711	1178
2421d8dc-3548-4b72-b606-b235ecdf5448	2.51	253.48	3.55	1.93	2026-04-26 13:17:50.841711	1179
bb6389a5-9e20-4135-8648-8a813bb296b7	0.64	56.04	3.66	2.17	2026-04-26 13:17:50.841711	1180
6447b600-e734-4067-87b1-b915998722b4	1.37	212.91	2.36	2.95	2026-04-26 13:17:50.841711	1181
a1fc9f0b-f1e6-4819-9cb5-1ce77541a1b5	1.82	81.96	2.68	1.93	2026-04-26 13:17:50.841711	1182
25df9dd3-d744-4a1e-a96b-d1322d6952f5	3.2	199.75	3.07	1.07	2026-04-26 13:17:50.841711	1183
8e3909e7-8ee5-4db8-9278-087d2851a6f1	2.97	263.27	1.21	2.44	2026-04-26 13:17:50.841711	1184
3fcc2af3-e524-4b65-9649-cc48a58b7463	1.99	85.82	3.73	2.91	2026-04-26 13:17:50.841711	1185
3045ab21-e78f-41cf-9f96-102cfd907777	2.37	157.71	3.77	1.71	2026-04-26 13:17:50.841711	1186
211e6d92-06f3-4968-ab18-4d3606fb0313	1.83	148.11	3.39	2.79	2026-04-26 13:17:50.841711	1187
577c5ceb-5d82-4a67-914e-cc3249432558	2.25	292.55	3.07	2.23	2026-04-26 13:17:50.841711	1188
a9955bda-fedb-44d9-b5a6-33b7ceff70cc	1.14	89.67	2.96	2.45	2026-04-26 13:17:50.841711	1189
cac6b96e-6c77-4c20-b201-5d059367fbf0	2.42	61.05	1.56	1.7	2026-04-26 13:17:50.841711	1190
40b83090-1da5-4f1a-85d6-884f75d306d9	2.42	116.87	3.19	1.61	2026-04-26 13:17:50.841711	1191
af6f8bce-ab49-4a79-a40c-4a4aba8d8552	1.03	236.44	3.51	1.59	2026-04-26 13:17:50.841711	1192
7674a04d-8f67-4d07-9eab-998e344a03c9	3.29	88.21	1.84	1.8	2026-04-26 13:17:50.841711	1193
f97b5670-ef68-4a86-97c0-6385e6ae7405	0.55	119.01	2.11	2.27	2026-04-26 13:17:50.841711	1194
4fc26046-1ae2-4e60-99cf-95ef8ee6524a	0.98	116.56	2.36	2.46	2026-04-26 13:17:50.841711	1195
e332ef09-be23-4a9d-b003-f886bfae870d	2.92	168.84	3.73	2.62	2026-04-26 13:17:50.841711	1196
88f0fd74-5fbe-402b-b1f9-8b0185f9b042	0.67	77.53	1.88	1.53	2026-04-26 13:17:50.841711	1197
7289ae0e-9605-4d46-aaee-5b05ddd96e59	2.56	299.23	2.7	1.46	2026-04-26 13:17:50.841711	1198
b0318b61-a090-47a1-a30e-1f29ba099262	1.33	261.37	2.27	2.01	2026-04-26 13:17:50.841711	1199
26ec3ee2-f140-4f43-b13b-9299796dd2d1	2.13	69.7	3.46	1.17	2026-04-26 13:17:50.841711	1200
9dab24c7-177d-4ec4-8c0b-2323b92d3d4a	0.94	166.49	2.73	2.4	2026-04-26 13:17:50.841711	1201
1a6d5e85-787b-461f-8db7-9cd8f8d81ece	3.1	238.79	3.54	2.67	2026-04-26 13:17:50.841711	1202
27b23042-92c6-4a49-b397-6c200041d8ee	2.72	240.98	3.55	2.56	2026-04-26 13:17:50.841711	1203
08f0acf7-18ec-45eb-8146-8042969d5c7a	2.02	110.77	2.38	1.55	2026-04-26 13:17:50.841711	1204
a03af7ca-2046-499e-b19d-b6571e696f89	0.51	125.22	3.26	2.01	2026-04-26 13:17:50.841711	1205
e7fd011f-5572-4ee9-a3de-2d9d4d5c818d	1.13	65.98	2.89	1.36	2026-04-26 13:17:50.841711	1206
4065ab51-f74f-42a2-9363-7146df43c932	3.18	129.82	2.65	2.87	2026-04-26 13:17:50.841711	1207
a07f2ed2-35ae-4720-ad65-a22fe59566d3	3.37	222.12	3.59	1.46	2026-04-26 13:17:50.841711	1208
02c4237f-a7f5-452b-82c3-1fe296af3c3c	1.05	133.72	1.5	1.1	2026-04-26 13:17:50.841711	1209
62b7cf0d-cf31-493a-85aa-8fa347acda25	1.7	137.76	3.09	2.76	2026-04-26 13:17:50.841711	1210
ab3db038-d69b-451e-bba3-08e8119898b4	2.47	296.14	1.62	2.87	2026-04-26 13:17:50.841711	1211
b685932b-8a27-4288-8795-f6e05e9e4cef	1.01	66.5	2	1.33	2026-04-26 13:17:50.841711	1212
9cd7e4f4-8d1a-48da-abbc-075218e9e7a6	1.88	60.86	2.25	2.86	2026-04-26 13:17:50.841711	1213
98d2ddcf-4cfa-4405-9501-d661884b1017	2.41	144.69	1.45	2.35	2026-04-26 13:17:50.841711	1214
d0655207-0783-4e94-98d2-176fe26849d8	1.68	154.26	1.2	2.09	2026-04-26 13:17:50.841711	1215
bcad4d42-8a4f-4b72-a2e1-b607651d5c31	2.84	263.9	3.65	2.95	2026-04-26 13:17:50.841711	1216
9ed4929a-d3c0-4954-b272-227a89cbedec	0.57	234.86	1.63	2.21	2026-04-26 13:17:50.841711	1217
edcb7d15-e6ed-461f-b1b4-38a993ff2ec7	1.14	178.45	3.31	1.96	2026-04-26 13:17:50.841711	1218
2f5d7c02-eadd-4eb2-8dd5-46a5ba51c3f8	2.34	288.14	1.32	1.61	2026-04-26 13:17:50.841711	1219
0ad0a6eb-d13c-440c-b74c-0391605d9685	2.54	162.79	3.45	1.31	2026-04-26 13:17:50.841711	1220
2bb8c959-19b6-4951-8313-e6d0413c9a6f	1.19	259.67	1.99	1.24	2026-04-26 13:17:50.841711	1221
303a312c-4f87-408c-b20b-03d848ec9055	1.42	257.11	2.7	1.38	2026-04-26 13:17:50.841711	1222
a32bfdcd-5dd9-4a93-85e7-c1e608df83ee	1.22	63.59	1.99	1.21	2026-04-26 13:17:50.841711	1223
5ccc6390-43ca-49f5-b6fa-84247d3e52af	0.72	84.38	1.25	1.91	2026-04-26 13:17:50.841711	1224
df299e49-61f2-49ce-8051-e50cfc0b2650	2.63	66.77	2.4	2.05	2026-04-26 13:17:50.841711	1225
86ef6ade-b308-467a-8c42-3c6e4c20ec8d	3.36	242.1	1.31	1.1	2026-04-26 13:17:50.841711	1226
e318d53f-7605-468a-b41d-051070be96a3	1.65	226.49	2.13	1.75	2026-04-26 13:17:50.841711	1227
efc0c233-0113-480b-b3e6-ca3275b5ffde	0.52	64.39	3.59	2	2026-04-26 13:17:50.841711	1228
5808ae27-83d1-4163-9187-6a23f988dc97	3.13	162.96	3.2	2.38	2026-04-26 13:17:50.841711	1229
e304e2e6-fd72-4399-b4d7-fb6416b81f0c	0.98	124.17	2.6	1.87	2026-04-26 13:17:50.841711	1230
678ae26f-569d-4c0e-b4a9-0a688fc0936a	1.48	148.24	3.06	2.31	2026-04-26 13:17:50.841711	1231
6438657c-ee67-48b5-8de0-62eeb64e0a87	1.49	259.57	2.26	1.81	2026-04-26 13:17:50.841711	1232
e3216b17-e320-4d0f-ada0-b93e60caca02	2.71	194.85	1.54	2.55	2026-04-26 13:17:50.841711	1233
63188d13-0344-4b51-aa79-19ea416c8cdd	3.05	68.25	2.81	2.68	2026-04-26 13:17:50.841711	1234
17932bb9-836e-4db9-b27e-bd1b2f574954	1.87	238.98	3.66	2.45	2026-04-26 13:17:50.841711	1235
459418c3-7fb1-4dd5-9c2b-6a0eb1e128a7	1.65	112	3.53	1.04	2026-04-26 13:17:50.841711	1236
4d88229f-55e4-476b-bfc0-096795c485e4	1.72	139.25	1.31	1.17	2026-04-26 13:17:50.841711	1237
2ce612e7-1b0e-4a98-aab2-d00e087e7acd	3.3	198.21	3.44	1.49	2026-04-26 13:17:50.841711	1238
f1c04ba0-d43a-4055-8726-0674ce5a9591	1.62	86.26	2.3	2	2026-04-26 13:17:50.841711	1239
b4617646-5ec4-4d15-a573-c29cffb7c27f	2.85	79.62	2.4	2.5	2026-04-26 13:17:50.841711	1240
c02600b3-e48e-4409-95a3-eb683e336b10	0.84	234.4	2.59	2.7	2026-04-26 13:17:50.841711	1241
fc365d4b-670e-4fca-8c15-bed27e9c7c64	2.94	96.64	1.57	2.79	2026-04-26 13:17:50.841711	1242
b5bfff34-218c-48cd-b9ce-673eea91bda1	1.08	247.25	1.92	2.96	2026-04-26 13:17:50.841711	1243
0ef3d984-2e82-4672-bcd6-c49dfd8397b3	0.95	90.47	2.32	2.81	2026-04-26 13:17:50.841711	1244
869589e4-a12e-4a97-9558-0e078bfadd07	0.6	63.91	1.45	2.67	2026-04-26 13:17:50.841711	1245
fc37eb73-af1d-4f66-ab8d-ac6cd664ceea	0.59	232.48	3.3	1.45	2026-04-26 13:17:50.841711	1246
f182189b-b6e2-4aee-bb22-5b1e555815b6	2.75	205.21	2.9	1.35	2026-04-26 13:17:50.841711	1247
4a03155b-1956-495a-aa04-f02a9c3d31c8	2.7	293.04	1.72	1.66	2026-04-26 13:17:50.841711	1248
6b9cb1d4-e93d-40cb-8099-44f30eae119b	1.14	134.44	2.98	1.12	2026-04-26 13:17:50.841711	1249
77c9a885-1040-44e4-8b7c-18dccb3b1a81	0.94	214.26	1.22	1.64	2026-04-26 13:17:50.841711	1250
ab089221-71a5-4b3c-a06e-445f999eed0a	0.74	267.7	2.95	2.08	2026-04-26 13:17:50.841711	1251
2954b16d-0db5-4232-8923-ca1c2a81be0a	0.72	107.62	2.52	1.22	2026-04-26 13:17:50.841711	1252
e072183d-f51e-4965-a227-e111304e8104	1.87	207.24	1.4	1.63	2026-04-26 13:17:50.841711	1253
d59dcfa3-ec8d-4789-81cd-22e13a9c829c	2.61	155.48	2.99	1.68	2026-04-26 13:17:50.841711	1254
e32ad455-b5bd-49ef-b295-f81c8a11da16	1.46	98.97	2.81	2.23	2026-04-26 13:17:50.841711	1255
21d6e120-8fa3-4a51-9ade-436c7d77e075	1.2	70.47	1.27	1.05	2026-04-26 13:17:50.841711	1256
efff145d-5625-4a2c-ac23-ffdccad3e85b	2.9	269.2	2.08	1.98	2026-04-26 13:17:50.841711	1257
1a64a717-44a3-4308-9eaa-d6a37163544c	2.32	256.58	1.93	1.5	2026-04-26 13:17:50.841711	1258
474c6490-57e2-4c5c-ad69-dc1c4cf6b1f5	2.11	121.47	2.61	1.89	2026-04-26 13:17:50.841711	1259
7f85773c-30b2-4ff2-877a-93f568213806	0.67	276.55	2.82	2.72	2026-04-26 13:17:50.841711	1260
4d87ace7-e3ee-4ea4-92f6-c395ef501428	1.25	210.09	1.01	2.61	2026-04-26 13:17:50.841711	1261
4d289278-e3f8-42ed-af6a-2d3259072f3f	1.21	250.23	1.25	1.04	2026-04-26 13:17:50.841711	1262
ebffe864-14eb-465e-b745-192f6e5717bf	0.64	217.15	3.33	2.75	2026-04-26 13:17:50.841711	1263
fb9a49ca-e5e2-4be1-9e2c-5d77c4db770b	0.84	189.88	2.4	1.69	2026-04-26 13:17:50.841711	1264
150f7991-fbd0-429e-bdf9-c60b50b1aae6	1.78	83.17	1.2	2.49	2026-04-26 13:17:50.841711	1265
569b5e54-a5e6-442c-94e0-64a8245dcd07	1.15	281.9	1.43	2.69	2026-04-26 13:17:50.841711	1266
1525c80d-cf06-4108-bab9-0205f6ed78f7	1.05	145.38	2.78	2.62	2026-04-26 13:17:50.841711	1267
c6e7314c-8525-4191-80c2-2c3a921f415d	3.18	107.91	1.95	1.3	2026-04-26 13:17:50.841711	1268
01d04063-d9c3-43b8-9cd1-f2c365206958	0.94	233.17	3.88	1.23	2026-04-26 13:17:50.841711	1269
688a8c3f-fa38-4308-89d5-212d6faf8a77	1.45	163.09	2.72	1.73	2026-04-26 13:17:50.841711	1270
80f0e0e1-a56b-4969-9328-300dd7d3889e	2.29	162.74	1.92	1.73	2026-04-26 13:17:50.841711	1271
bf4c1fb6-a269-4569-be90-6b6a998ee7b9	1.29	230	2	2.37	2026-04-26 13:17:50.841711	1272
4421a7a4-be54-4494-b732-9068a725e9b7	3.32	238.21	1.58	1.73	2026-04-26 13:17:50.841711	1273
5d9bfdd7-0a23-41a4-bff6-1d1b588e6b78	0.87	89.9	2.63	1.85	2026-04-26 13:17:50.841711	1274
9272aa0e-60be-48a7-b1a9-e260a3fcd3d2	1.72	231.15	3.26	1.65	2026-04-26 13:17:50.841711	1275
cd6c4c38-b00a-4644-b1a1-7fc4b8c0ef46	2.81	232.13	3.46	2.22	2026-04-26 13:17:50.841711	1276
903c34b0-9809-44ee-af0c-97ca045cde31	1.09	239.57	2.08	2.1	2026-04-26 13:17:50.841711	1277
ec564929-5d5d-4964-85c9-c2c00181550b	1.06	215.32	1.55	1.34	2026-04-26 13:17:50.841711	1278
eb5b0417-51b7-4630-89a7-fbac16715f99	3.39	190.1	3.36	1.92	2026-04-26 13:17:50.841711	1279
2f71377b-f84e-4d62-a2dd-610ad858eff9	1.65	237.06	1.77	2.08	2026-04-26 13:17:50.841711	1280
ccefa4d3-0ac6-49b4-b548-44dbecf95314	2.08	174.4	2.84	1.59	2026-04-26 13:17:50.841711	1281
641085c9-c0f6-4e22-ba3b-1fb94f36d101	1.76	160.45	1.99	1.76	2026-04-26 13:17:50.841711	1282
98771193-9965-407f-9a85-7fede6b77203	2.37	182.23	3.04	2.84	2026-04-26 13:17:50.841711	1283
a4f48f59-b6eb-49b5-bda3-c4cbe0959ccc	2.81	155.7	2.26	2.74	2026-04-26 13:17:50.841711	1284
349fd483-5e87-4860-902e-0499901d0595	2.37	209.9	2.5	3	2026-04-26 13:17:50.841711	1285
9c9909c7-05a2-4227-acf9-28521c0da135	0.87	144.31	2.45	1.6	2026-04-26 13:17:50.841711	1286
f305ad8e-b6cd-4ccb-8d44-e33845a294a1	0.89	154.83	1.86	1.52	2026-04-26 13:17:50.841711	1287
baa2883c-e58b-4231-a08f-44235a4dea80	1.81	192.79	3.56	1.44	2026-04-26 13:17:50.841711	1288
0d8f1e65-863d-45d8-bd85-f7a7bb2a19d6	1.45	205.64	1.81	2.57	2026-04-26 13:17:50.841711	1289
1274b8fd-1c04-42fe-ae89-7ee5494a8909	2.35	51.55	2.54	2.9	2026-04-26 13:17:50.841711	1290
177aba49-3dfa-4284-870d-fb28b84d4534	3.07	152.17	2.06	2.78	2026-04-26 13:17:50.841711	1291
a3e55969-7679-400e-b2f8-63e2955e54c2	0.76	119.03	2.32	1.83	2026-04-26 13:17:50.841711	1292
ccea675a-ef56-4f85-b8c5-317c8ce5a850	1.99	291.26	2.69	1.98	2026-04-26 13:17:50.841711	1293
3aa10c1e-2460-4377-b65a-f47990cf20a4	2.86	114.7	3.21	1.54	2026-04-26 13:17:50.841711	1294
95049103-faa4-4e21-9165-033861d9c488	2.09	212.87	1.28	2.15	2026-04-26 13:17:50.841711	1295
2c47bb0c-f0bc-43ef-97b7-ec4d8c96c29f	1.12	152.53	3.08	2.18	2026-04-26 13:17:50.841711	1296
c1b55a4f-d015-496a-97a5-0eda929e3dc3	2.44	99.16	1.78	1.2	2026-04-26 13:17:50.841711	1297
b8174b2e-1cb1-472c-ac48-c2a6912e48de	1.73	195.96	1.53	2.92	2026-04-26 13:17:50.841711	1298
ef342171-814f-4d88-ba4b-9c3e820c63de	1.05	277.69	1.51	2.36	2026-04-26 13:17:50.841711	1299
ff142781-a79f-4ff4-a703-7732aa9af9e3	1.11	227.25	3.09	2.84	2026-04-26 13:17:50.841711	1300
53988c3d-02b2-4be9-95b5-739ffb19f562	3.21	278.71	3.7	1.81	2026-04-26 13:17:50.841711	1301
90e0676d-9543-455e-b95b-033a3dc29094	1.6	245.32	3.9	2.06	2026-04-26 13:17:50.841711	1302
aa53d45e-4f36-4897-b499-3ed698190647	2.44	207.07	1.34	1.97	2026-04-26 13:17:50.841711	1303
0d2cac97-cb24-4e98-8c0f-4356b3e97f0a	1.63	273.99	3	2.12	2026-04-26 13:17:50.841711	1304
3781bb39-94d7-41ab-bddb-e6008d65fc3e	1.45	139.87	1.85	2.12	2026-04-26 13:17:50.841711	1305
9c7b719e-b70f-4394-9ff1-ed98e6b5cc58	3.31	276.9	3.58	2.58	2026-04-26 13:17:50.841711	1306
e7450082-184d-42e5-9e10-1ba889b81e15	1.05	131.85	2.43	1.61	2026-04-26 13:17:50.841711	1307
7f8cdea0-97fa-4f5c-a07d-339312618900	0.71	73.61	1.72	1.44	2026-04-26 13:17:50.841711	1308
1cdd7dbf-0fb2-4741-b2ce-1648f6588f83	1.04	93.86	1.46	2.45	2026-04-26 13:17:50.841711	1309
addb0a76-380c-4a6e-81a0-5642a291744d	0.57	222.5	2.12	2.65	2026-04-26 13:17:50.841711	1310
37353a0a-b1de-4f16-ade8-742e357bff71	2.83	55.55	1.96	1.49	2026-04-26 13:17:50.841711	1311
d806cbd2-e0cc-4e83-84a5-7e939ebd4b95	2.18	189.83	2.39	1.05	2026-04-26 13:17:50.841711	1312
84970f72-5d25-45d2-96d7-3ed2f3315168	2	76.84	1.13	2.33	2026-04-26 13:17:50.841711	1313
80fbbed9-4a78-4bd2-87e9-af704fc2de31	3.05	81.99	2.44	1.1	2026-04-26 13:17:50.841711	1314
8a2c8802-0ed7-4c68-b865-2b6b9b4e467b	2.36	71.3	2.38	1.22	2026-04-26 13:17:50.841711	1315
92491d57-33b8-476b-b82f-4d782b7925be	1.73	122.61	3.53	1.06	2026-04-26 13:17:50.841711	1316
101a0017-9d06-4cab-9376-10fca55b80fe	1.12	63.19	3.6	2.69	2026-04-26 13:17:50.841711	1317
7a670221-9a34-46e2-b81b-1d7085b29ac8	1.05	78.99	1.4	1.72	2026-04-26 13:17:50.841711	1318
b486f1ad-7297-436a-929a-3696998a7284	0.53	124.69	3.28	1.83	2026-04-26 13:17:50.841711	1319
ef7e5768-abc3-451c-8700-eadd22e0526f	3.17	72.33	3.76	1.87	2026-04-26 13:17:50.841711	1320
63993198-0f2e-4909-b4ec-c6e6b29c10e1	2.08	65.83	1.77	2.53	2026-04-26 13:17:50.841711	1321
785054cb-4641-468e-b119-e344676aba22	1.34	235.29	3.4	1.06	2026-04-26 13:17:50.841711	1322
2641930a-9a92-4a93-a28c-017fc48fc1b3	0.55	220.1	1.21	1.69	2026-04-26 13:17:50.841711	1323
4a2d3659-552c-4773-9281-2b75e2ba4bb6	0.88	247.1	3.12	2.74	2026-04-26 13:17:50.841711	1324
78beb24a-058f-4cc9-864c-1d33949d4818	1.08	244.81	2.62	1.76	2026-04-26 13:17:50.841711	1325
0889297c-d685-4c5d-bfc9-bba36110c15d	1.66	54.67	3.46	1.33	2026-04-26 13:17:50.841711	1326
acef61e7-7f4b-4b30-b6c5-425f9e36a90e	2.21	169.17	3.52	2.26	2026-04-26 13:17:50.841711	1327
186f60d6-c7c7-467f-b4fe-fa7636f79a23	2.07	212.02	2.02	2.48	2026-04-26 13:17:50.841711	1328
4079e5e0-9e84-4432-b44a-32af8e59d4b6	2.72	294.11	1.15	2.92	2026-04-26 13:17:50.841711	1329
29a4907b-3872-4537-b4c9-a42ef3e28b0e	2.93	177.14	3.89	1.39	2026-04-26 13:17:50.841711	1330
8d34dd99-e669-4ca7-99af-1d91991a09c9	0.59	152.2	4	1.82	2026-04-26 13:17:51.620911	1331
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.16	163.75	1.98	2.61	2026-04-26 13:17:51.620911	1332
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.16	163.75	1.98	2.61	2026-04-26 13:17:51.620911	1333
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.16	163.75	1.98	2.61	2026-04-26 13:17:51.620911	1334
37353a0a-b1de-4f16-ade8-742e357bff71	2.83	55.55	1.96	1.49	2026-04-26 13:17:51.620911	1335
083b503f-bc9a-4761-9232-985118e3bde4	0.7	100.07	2.46	1.74	2026-04-26 13:17:52.63879	1336
84898f92-b30c-4251-99c5-6d4b8ee07428	2.47	168.29	3.77	1.74	2026-04-26 13:17:52.63879	1337
1798c0d0-79e4-4d2b-9f3f-990b125d2105	1.27	183.62	1.21	1.8	2026-04-26 13:17:52.63879	1338
d4454c95-37c1-4467-a22e-9fb7abac08a2	0.75	277.41	2.46	1.63	2026-04-26 13:17:52.63879	1339
1dc79f19-741d-4d47-8552-5e53debeed00	2.44	243.83	1.61	1.09	2026-04-26 13:17:52.63879	1340
127074f4-ef1e-44c6-b9d4-6e159522fe6d	0.64	252.09	3.17	2.22	2026-04-26 13:17:52.63879	1341
933c3358-c4a9-4190-ba36-d320f41b28bd	2.15	197.48	3.43	2.35	2026-04-26 13:17:52.63879	1342
24c4b5e6-9375-4a3d-aa2e-8ecf73311e2a	3.22	184.1	3.69	1.97	2026-04-26 13:17:52.63879	1343
8459b204-828a-433c-946a-16940b23fe20	1.42	61.46	1.69	2.68	2026-04-26 13:17:52.63879	1344
6c67de4d-14df-473a-b5b7-234ca1892d36	2.41	240.65	2.85	2.47	2026-04-26 13:17:52.63879	1345
1a1da762-8b17-44fc-ab54-aacee70233c0	1.7	182.74	3.72	2.56	2026-04-26 13:17:52.63879	1346
eaf83308-161d-4cbe-9a8f-c87d75ee5421	2.92	113.09	3.87	2.86	2026-04-26 13:17:52.63879	1347
2639cd66-3527-4a6d-b26e-dfb2491c1bf2	1.75	281.76	1.58	1.72	2026-04-26 13:17:52.63879	1348
8d34dd99-e669-4ca7-99af-1d91991a09c9	2.33	183.46	1.86	2.88	2026-04-26 13:17:52.63879	1349
77398e9d-8c73-4cfb-9019-93696911c12d	2.9	69.05	2.76	1.58	2026-04-26 13:17:52.63879	1350
af79ed93-81e1-4dad-ab43-483f230ed7d4	0.95	215.89	2.28	1.59	2026-04-26 13:17:52.63879	1351
a09b5914-31d8-4628-bfde-a2ed4f60f907	2.43	142.57	1.51	1.35	2026-04-26 13:17:52.63879	1352
af5d64a0-8fd6-4135-9b5c-ed9a17afe722	3	283.76	2.59	2.08	2026-04-26 13:17:52.63879	1353
48f2ef4f-6f48-4a5a-8aca-e2844be19a4d	3.02	128.55	1.27	1.84	2026-04-26 13:17:52.63879	1354
c4a5295a-ac7e-4505-ae47-069a3a50ecec	2.82	276.25	1.98	2.43	2026-04-26 13:17:52.63879	1355
0cdc07b0-d122-4345-a871-ed8736125a13	0.52	248.05	2.08	2.47	2026-04-26 13:17:52.63879	1356
8be3185b-bc1c-4142-b567-48aaff220b01	1.55	92.04	2.76	1.52	2026-04-26 13:17:52.63879	1357
d9051e4d-d569-4f01-89e0-7d857762afe5	2.06	238.94	1.7	1.58	2026-04-26 13:17:52.63879	1358
3fad7c09-4ab3-4a8b-aa29-7211513f7237	2.28	154.04	3.61	2.69	2026-04-26 13:17:52.63879	1359
dbbf360e-7216-4601-8614-038fe1dcc2ba	2.25	140.41	3.67	2.84	2026-04-26 13:17:52.63879	1360
9bd9f3c5-1b49-4927-8cdf-35373636ae00	0.62	248.36	3.14	2.91	2026-04-26 13:17:52.63879	1361
160d3adf-6a5a-4442-8c35-f8ff730e0036	1.52	123.73	1.14	1.4	2026-04-26 13:17:52.63879	1362
5c42027f-8aaa-441b-990e-215c05fc0300	2.61	191.32	3.32	2.06	2026-04-26 13:17:52.63879	1363
bfc1d7fb-6dd6-42fd-a795-053bca272428	0.76	123.96	2.06	1.53	2026-04-26 13:17:52.63879	1364
fe19663b-26a2-40d0-a329-bf3f1f6a25a6	1.57	73.7	1.11	2.75	2026-04-26 13:17:52.63879	1365
09bcbc34-b01a-4878-88ae-4aac9ea91b2d	2.1	244.21	3.72	2.47	2026-04-26 13:17:52.63879	1366
28aa7be3-ebf0-4bfb-9e4d-8eb57e7a1a09	2.63	269.77	1.16	1.69	2026-04-26 13:17:52.63879	1367
a463568f-08c1-4eee-ba9f-87eca478959e	2.77	199.79	2.14	1.42	2026-04-26 13:17:52.63879	1368
e91e2255-deed-4ffc-9e86-da19ee4fe2be	1.11	57.41	1.74	2.36	2026-04-26 13:17:52.63879	1369
e6c3818b-29f0-4e36-9052-5e1482339405	1.9	110.95	2.47	1.11	2026-04-26 13:17:52.63879	1370
80d81f80-2426-4c17-9e8a-321da7361798	2.58	91.99	1.56	1.26	2026-04-26 13:17:52.63879	1371
6f817b31-ed87-46bb-9e2e-1140f4cb4cbb	2.31	90.55	2.8	1.53	2026-04-26 13:17:52.63879	1372
34c9e297-d7dc-4168-a5a5-8e7e148dcbbd	0.78	255.56	2.08	2.87	2026-04-26 13:17:52.63879	1373
06c52bbf-cbe5-4db7-997a-9f747283665e	0.98	145.36	1.25	2.55	2026-04-26 13:17:52.63879	1374
0404794e-0a50-4824-a0ee-921cb23888ee	1.55	231.76	3.99	2.12	2026-04-26 13:17:52.63879	1375
ff75e776-7227-4220-9f32-33a6013ae67f	2.29	221.48	3.05	2.07	2026-04-26 13:17:52.63879	1376
522e7eca-7dde-4bb5-9cfd-7bfc1f5aa823	1.33	61.91	3.83	2.23	2026-04-26 13:17:52.63879	1377
0670c059-cbff-4d6e-97fa-c2dbd81ba878	2.31	125.15	3.22	2.01	2026-04-26 13:17:52.63879	1378
41623b9e-303f-46b1-82d3-8883c4a479bb	3.12	185.36	1.96	1.3	2026-04-26 13:17:52.63879	1379
8425054a-27fe-45f7-a2d1-0ca5bb87c22d	1.67	271.76	3.36	2.63	2026-04-26 13:17:52.63879	1380
88f2dc8f-4748-490e-b92d-e31ba6ddaf7b	3.31	119.67	2.52	2.66	2026-04-26 13:17:52.63879	1381
71e03cf9-1c81-44c0-9c0f-63591e58aa30	1.34	249.17	3.18	2.82	2026-04-26 13:17:52.63879	1382
bc2f02a5-cb1e-4610-ac0e-ba7f24c18ccd	1.62	213.87	2.83	1.72	2026-04-26 13:17:52.63879	1383
c110010b-1088-4e02-be3c-83c511d7831c	2.12	53.04	3.78	1.03	2026-04-26 13:17:52.63879	1384
fe8407a5-d6f0-4b63-b0c1-71ad87ffab96	3.36	209.57	2.94	2.19	2026-04-26 13:17:52.63879	1385
19646a15-fc51-45ea-b837-9703ea5e5f8c	2.58	128.21	1.2	1.53	2026-04-26 13:17:52.63879	1386
048313b2-21ec-4fbc-be08-2f0c27fa77f6	2.6	247.15	3.15	2.24	2026-04-26 13:17:52.63879	1387
66ae13b0-bc41-401b-919a-a47c2d82b9ef	1.44	193.05	2.84	1.42	2026-04-26 13:17:52.63879	1388
d87f65c7-d638-4f26-a825-aff5ae57457b	2.9	233.95	1.2	1.07	2026-04-26 13:17:52.63879	1389
7931d397-9cb6-40aa-888c-6b1cfe481a74	1.96	237.33	2.44	2.72	2026-04-26 13:17:52.63879	1390
a63e2468-ff52-45a6-a5cd-59944a3859bb	0.94	157.6	1.5	2.95	2026-04-26 13:17:52.63879	1391
2c170f3c-70f5-4432-9675-baa82539a713	2.68	171.1	1.74	2.18	2026-04-26 13:17:52.63879	1392
a49a8d86-d915-4488-b843-de71b33e91fd	1.4	241.25	1.17	1.11	2026-04-26 13:17:52.63879	1393
b2cd1843-50e3-475c-b68b-24bcf035d14a	2.45	180.15	3.34	1.32	2026-04-26 13:17:52.63879	1394
49214cd6-15b3-43e2-b004-f11980bd76e7	2.96	293.26	2.13	1.07	2026-04-26 13:17:52.63879	1395
da38da3e-9316-49d8-af58-cfca2be2ecea	1.05	178.49	4	2.41	2026-04-26 13:17:52.63879	1396
06e503be-bdf4-4afe-9252-ad4307d77d34	2.67	52.76	1.99	1.52	2026-04-26 13:17:52.63879	1397
e07bf42f-e0df-4ae0-8b19-59673c872bf2	1.35	65.11	3.85	2.6	2026-04-26 13:17:52.63879	1398
d9ff0e43-523c-4157-b412-c6e488086313	2.45	174.06	1.49	1.89	2026-04-26 13:17:52.63879	1399
73605445-18c0-4c79-aa20-abe75a2aa504	1.82	167.16	2.46	1.49	2026-04-26 13:17:52.63879	1400
17d1d4a8-7fff-4e9d-be6b-1ad8cff6ebd6	2.09	179.67	3.93	1.49	2026-04-26 13:17:52.63879	1401
0ff59da4-ea9a-48c5-9b60-96f17e2644b7	0.54	246.28	3.46	1.44	2026-04-26 13:17:52.63879	1402
0c867821-28e1-489c-96ef-a33a16f96004	1.17	274.36	3.87	1.69	2026-04-26 13:17:52.63879	1403
6111d377-0b6c-4d93-b288-f7ebce6c00fc	3.31	213.69	2.4	2.43	2026-04-26 13:17:52.63879	1404
18905b39-d6a0-4f41-8c02-9b817e1b009d	2.58	128.78	2	1.78	2026-04-26 13:17:52.63879	1405
8b417aee-680e-4081-85f2-5a160fb2ff12	0.51	78.77	1.09	2.68	2026-04-26 13:17:52.63879	1406
38b482a7-1f32-4ddc-9349-bcf1da86d546	1.08	262.61	2.29	2.34	2026-04-26 13:17:52.63879	1407
02152a87-fd48-4156-bd2f-afe94c4dc7a6	3.34	289.05	1.89	1.38	2026-04-26 13:17:52.63879	1408
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.16	85.43	1.28	2.92	2026-04-26 13:17:52.63879	1409
79cd4a3f-adcf-4ce5-9d29-62693c93adf2	1.27	117.76	2.82	2.78	2026-04-26 13:17:52.63879	1410
c4391873-3533-4cad-977b-0323fced348e	3.46	208.07	1.04	2.87	2026-04-26 13:17:52.63879	1411
c6338c80-214f-405b-9b0b-7594bb69d230	1.77	190.08	2.79	2.96	2026-04-26 13:17:52.63879	1412
382f3f60-7d3c-4ffc-8b2f-94ce32b77254	2.36	202.73	3.04	2.01	2026-04-26 13:17:52.63879	1413
cf827a4b-a720-4825-84d4-29f047763f7e	2.14	271.25	2.15	2.57	2026-04-26 13:17:52.63879	1414
d5806c60-9752-4845-9128-964d9b723f0b	1.95	261.01	3.45	1.09	2026-04-26 13:17:52.63879	1415
96e0af22-02e2-46d4-8224-4db162bd27b6	1.77	234.48	1.92	2.85	2026-04-26 13:17:52.63879	1416
9d0c77f5-485a-477d-80ec-8da875eb9852	2.02	298.53	3.45	2.36	2026-04-26 13:17:52.63879	1417
c19c4f6a-3738-436e-b7dc-b27df3129b28	1.55	222.34	3	1.09	2026-04-26 13:17:52.63879	1418
2d78aa7b-b8fb-4cc0-9d8a-f6a927032041	1.26	86.54	3.95	2.22	2026-04-26 13:17:52.63879	1419
dbebf850-836f-4532-807c-c1e3f5b5d597	0.54	170.33	2.8	2.87	2026-04-26 13:17:52.63879	1420
453f03e0-cb8d-4681-b343-d681f27e84f8	1.53	274.72	1.78	2.58	2026-04-26 13:17:52.63879	1421
13d5f24a-3280-4db1-ae8d-4e7ac37dca9d	3.18	214.75	1.83	2.7	2026-04-26 13:17:52.63879	1422
40f8a8d7-327f-4f20-a15c-cbd9fb6f5e75	2.5	218.03	3.38	2.18	2026-04-26 13:17:52.63879	1423
8cfcaf67-4ae0-46c6-996e-6ce551b4096d	1.83	196.94	1.31	1.5	2026-04-26 13:17:52.63879	1424
05bb5c72-6613-4d45-a876-a6c5fb64222e	1.46	294.72	1.89	1.35	2026-04-26 13:17:52.63879	1425
37b80a41-5dec-4adb-ac19-126072ec4a13	0.92	279.19	3.88	1.04	2026-04-26 13:17:52.63879	1426
514c19e7-d8eb-4f8a-b58c-db01659e571e	3.11	140.22	3	1.21	2026-04-26 13:17:52.63879	1427
27ded357-dfee-45c6-844b-2108e05a105b	3.41	229.9	1.65	1.53	2026-04-26 13:17:52.63879	1428
affc16bb-f7a4-4ff2-90df-48caf7eebddc	0.85	66.49	3.8	2.57	2026-04-26 13:17:52.63879	1429
cb0fe3b7-fbc8-479b-bd12-6acfeeeeffeb	1.95	158.46	2.8	1.4	2026-04-26 13:17:52.63879	1430
c0f13516-b42b-4edf-8d54-260ed3432c91	1.72	247.62	3.82	2.63	2026-04-26 13:17:52.63879	1431
a6b3ffd9-c2dc-4bf3-872f-1d4dfaff44ce	0.88	79.45	2.33	2.37	2026-04-26 13:17:52.63879	1432
4c18584e-0e3e-40cc-94a4-dd6106965efb	3.49	176.72	2.33	2.75	2026-04-26 13:17:52.63879	1433
42be6f12-2662-427d-b3bb-9f8fb042cde5	2.36	217.95	3.12	2.99	2026-04-26 13:17:52.63879	1434
a9a3a5fa-5c98-4e69-883b-2afa82b1877f	2.03	233.77	3.41	2.06	2026-04-26 13:17:52.63879	1435
69ceb13d-c6ba-480a-9bb6-8c94350b80bb	2.13	267.36	2.58	1.76	2026-04-26 13:17:52.63879	1436
6946eb18-50ec-477c-808d-f71c98670e15	1.76	103.4	1.44	1.99	2026-04-26 13:17:52.63879	1437
db738178-6c85-4003-814c-43efae201f66	2.58	70.58	4	2.15	2026-04-26 13:17:52.63879	1438
4b5f92c9-7d51-4b0e-a137-acd779a460c0	2.3	118.21	3.51	2.08	2026-04-26 13:17:52.63879	1439
343b8afa-f5f3-413a-8faf-37c6af937323	0.95	162.48	3.19	1.1	2026-04-26 13:17:52.63879	1440
aa3eddc8-b910-47a9-b691-2ec377a4b6c3	3.01	266.09	3.25	1.01	2026-04-26 13:17:52.63879	1441
10412ce9-7326-4907-98fb-f30f329eb834	0.84	293.64	3.12	2.44	2026-04-26 13:17:52.63879	1442
a7a83b3b-4904-468d-b1ff-79250bae2178	3.34	71.41	1.24	2.16	2026-04-26 13:17:52.63879	1443
de64100b-0d55-4423-8139-e21bf67b1ba3	2.51	182.14	2.46	1.01	2026-04-26 13:17:52.63879	1444
48f1cae9-db76-406a-84c3-4b1d3fd1f646	0.62	65.54	2.47	2.91	2026-04-26 13:17:52.63879	1445
bff99142-a62f-4628-a6ff-c053c6deb013	2.88	276.74	1.42	2.89	2026-04-26 13:17:52.63879	1446
fb073968-3588-453a-85e2-75089d4c03f1	3.43	133.32	3.46	2.21	2026-04-26 13:17:52.63879	1447
377f4e07-93cb-4351-8c6b-62851338fdb0	1.65	269.29	1.75	1.97	2026-04-26 13:17:52.63879	1448
19bdfc5a-e1d0-463a-b163-7d7a692f73b8	1.12	246.47	2.87	1.27	2026-04-26 13:17:52.63879	1449
cbd20eb0-7239-4734-b82b-404600e7d66b	1.36	96.86	2.79	1.09	2026-04-26 13:17:52.63879	1450
18c3479d-2072-411f-8d91-9a580608c627	2.95	261.75	1.64	1.59	2026-04-26 13:17:52.63879	1451
ca09ced3-7738-4c9e-887f-d34312c3d8e4	2	69.41	2.35	1.76	2026-04-26 13:17:52.63879	1452
07a6b221-981a-4cce-bb5d-3d5a872c97b7	1.03	187.39	3.62	2.94	2026-04-26 13:17:52.63879	1453
fa753e0b-bcb9-41b7-9c82-6fccd2333db1	2.59	157.87	1.1	2.21	2026-04-26 13:17:52.63879	1454
100a7e1e-99f2-4b0d-8a9d-842a454a612f	2.12	270.2	2.94	2.42	2026-04-26 13:17:52.63879	1455
41bd264e-1eb3-4ccb-ab43-221d92913239	0.56	282.44	1.83	2.64	2026-04-26 13:17:52.63879	1456
b80e97e3-fe08-465e-ac72-eea64d2d6182	2.25	110.95	3.5	1.87	2026-04-26 13:17:52.63879	1457
ed596397-26d6-4d02-a2f1-dbbf5f8ab704	2.46	114.01	3.41	1.29	2026-04-26 13:17:52.63879	1458
5d36c463-e893-43a2-b567-1e7fbcb3c80c	0.66	174.88	1.01	2.9	2026-04-26 13:17:52.63879	1459
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	3.2	208.47	2.19	2.82	2026-04-26 13:17:52.63879	1460
b611f2f3-4dce-4565-9634-c5f67f16841f	2.65	189.8	2.4	2.29	2026-04-26 13:17:52.63879	1461
af16d415-a7a8-426f-8d38-2ade72d8acb5	1.84	86.96	3.46	2.28	2026-04-26 13:17:52.63879	1462
a18f9d90-4ce4-4793-a9c1-9452712601a3	1.5	72.27	3.57	2.79	2026-04-26 13:17:52.63879	1463
2421d8dc-3548-4b72-b606-b235ecdf5448	2.44	277.6	3.19	2.55	2026-04-26 13:17:52.63879	1464
bb6389a5-9e20-4135-8648-8a813bb296b7	3	261.09	2.45	2.75	2026-04-26 13:17:52.63879	1465
6447b600-e734-4067-87b1-b915998722b4	2.4	211.65	3.46	1.83	2026-04-26 13:17:52.63879	1466
a1fc9f0b-f1e6-4819-9cb5-1ce77541a1b5	3.18	60.53	3.48	1.25	2026-04-26 13:17:52.63879	1467
25df9dd3-d744-4a1e-a96b-d1322d6952f5	1.96	71.34	2.63	2.38	2026-04-26 13:17:52.63879	1468
8e3909e7-8ee5-4db8-9278-087d2851a6f1	1.59	78.35	2.3	2.25	2026-04-26 13:17:52.63879	1469
3fcc2af3-e524-4b65-9649-cc48a58b7463	2.48	179.13	2.99	2.43	2026-04-26 13:17:52.63879	1470
3045ab21-e78f-41cf-9f96-102cfd907777	2.22	182.89	2.36	1.83	2026-04-26 13:17:52.63879	1471
211e6d92-06f3-4968-ab18-4d3606fb0313	0.71	213.87	1.78	2.07	2026-04-26 13:17:52.63879	1472
577c5ceb-5d82-4a67-914e-cc3249432558	2.74	117.23	2	2.97	2026-04-26 13:17:52.63879	1473
a9955bda-fedb-44d9-b5a6-33b7ceff70cc	2.09	99.97	1.56	2.82	2026-04-26 13:17:52.63879	1474
cac6b96e-6c77-4c20-b201-5d059367fbf0	2.63	119.98	3.35	2.56	2026-04-26 13:17:52.63879	1475
40b83090-1da5-4f1a-85d6-884f75d306d9	1.55	292.97	3.51	1.21	2026-04-26 13:17:52.63879	1476
af6f8bce-ab49-4a79-a40c-4a4aba8d8552	3.32	219.55	3.6	2.02	2026-04-26 13:17:52.63879	1477
7674a04d-8f67-4d07-9eab-998e344a03c9	3.1	224.9	3.86	2.31	2026-04-26 13:17:52.63879	1478
f97b5670-ef68-4a86-97c0-6385e6ae7405	2.42	144.46	1.26	2	2026-04-26 13:17:52.63879	1479
4fc26046-1ae2-4e60-99cf-95ef8ee6524a	0.87	112.71	3.06	1.3	2026-04-26 13:17:52.63879	1480
e332ef09-be23-4a9d-b003-f886bfae870d	0.87	52.11	1.44	2.03	2026-04-26 13:17:52.63879	1481
88f0fd74-5fbe-402b-b1f9-8b0185f9b042	1.05	235.36	3.15	1.45	2026-04-26 13:17:52.63879	1482
7289ae0e-9605-4d46-aaee-5b05ddd96e59	2.73	162.76	3.4	1.7	2026-04-26 13:17:52.63879	1483
b0318b61-a090-47a1-a30e-1f29ba099262	1.7	139.98	3.98	2.14	2026-04-26 13:17:52.63879	1484
26ec3ee2-f140-4f43-b13b-9299796dd2d1	1.02	116.98	3.4	2.09	2026-04-26 13:17:52.63879	1485
9dab24c7-177d-4ec4-8c0b-2323b92d3d4a	2.76	158.91	3.73	2.32	2026-04-26 13:17:52.63879	1486
1a6d5e85-787b-461f-8db7-9cd8f8d81ece	3.25	85.41	2.23	1.87	2026-04-26 13:17:52.63879	1487
27b23042-92c6-4a49-b397-6c200041d8ee	1.96	291.47	3.43	1.49	2026-04-26 13:17:52.63879	1488
08f0acf7-18ec-45eb-8146-8042969d5c7a	1.7	147.75	3.44	1.29	2026-04-26 13:17:52.63879	1489
a03af7ca-2046-499e-b19d-b6571e696f89	2.17	176.31	1.13	2.96	2026-04-26 13:17:52.63879	1490
e7fd011f-5572-4ee9-a3de-2d9d4d5c818d	1.01	134.35	1.98	1.48	2026-04-26 13:17:52.63879	1491
4065ab51-f74f-42a2-9363-7146df43c932	0.61	126.67	2.93	2.75	2026-04-26 13:17:52.63879	1492
a07f2ed2-35ae-4720-ad65-a22fe59566d3	2.43	267.69	3.25	2.7	2026-04-26 13:17:52.63879	1493
02c4237f-a7f5-452b-82c3-1fe296af3c3c	2.92	62.41	1.06	1.45	2026-04-26 13:17:52.63879	1494
62b7cf0d-cf31-493a-85aa-8fa347acda25	2.1	138.08	1.13	2.51	2026-04-26 13:17:52.63879	1495
ab3db038-d69b-451e-bba3-08e8119898b4	1.06	123.61	1.18	2.21	2026-04-26 13:17:52.63879	1496
b685932b-8a27-4288-8795-f6e05e9e4cef	1.65	123.22	3.57	2.32	2026-04-26 13:17:52.63879	1497
9cd7e4f4-8d1a-48da-abbc-075218e9e7a6	2.95	106.03	1.29	2.12	2026-04-26 13:17:52.63879	1498
98d2ddcf-4cfa-4405-9501-d661884b1017	2.3	264.85	1.52	1.36	2026-04-26 13:17:52.63879	1499
d0655207-0783-4e94-98d2-176fe26849d8	2.05	259.4	3.78	2.42	2026-04-26 13:17:52.63879	1500
bcad4d42-8a4f-4b72-a2e1-b607651d5c31	1.74	182.39	3.21	2.14	2026-04-26 13:17:52.63879	1501
9ed4929a-d3c0-4954-b272-227a89cbedec	1.37	153.07	3.27	1.68	2026-04-26 13:17:52.63879	1502
edcb7d15-e6ed-461f-b1b4-38a993ff2ec7	1.45	75.22	2.58	1.6	2026-04-26 13:17:52.63879	1503
2f5d7c02-eadd-4eb2-8dd5-46a5ba51c3f8	2.54	245.4	1.99	1.4	2026-04-26 13:17:52.63879	1504
0ad0a6eb-d13c-440c-b74c-0391605d9685	1.9	295.98	2.93	2.94	2026-04-26 13:17:52.63879	1505
2bb8c959-19b6-4951-8313-e6d0413c9a6f	2.03	265.38	1.79	1.62	2026-04-26 13:17:52.63879	1506
303a312c-4f87-408c-b20b-03d848ec9055	0.56	238.78	3.3	1.25	2026-04-26 13:17:52.63879	1507
a32bfdcd-5dd9-4a93-85e7-c1e608df83ee	1.4	286.48	2.87	1.54	2026-04-26 13:17:52.63879	1508
5ccc6390-43ca-49f5-b6fa-84247d3e52af	2.95	112.17	1.24	1.61	2026-04-26 13:17:52.63879	1509
df299e49-61f2-49ce-8051-e50cfc0b2650	3.3	135.67	1.11	1.06	2026-04-26 13:17:52.63879	1510
86ef6ade-b308-467a-8c42-3c6e4c20ec8d	2.85	270.11	3.31	2.97	2026-04-26 13:17:52.63879	1511
e318d53f-7605-468a-b41d-051070be96a3	2.41	134.06	3.94	1.23	2026-04-26 13:17:52.63879	1512
efc0c233-0113-480b-b3e6-ca3275b5ffde	3.4	283.07	1.95	2.81	2026-04-26 13:17:52.63879	1513
5808ae27-83d1-4163-9187-6a23f988dc97	1.81	245.3	2.36	2.03	2026-04-26 13:17:52.63879	1514
e304e2e6-fd72-4399-b4d7-fb6416b81f0c	3.3	200.92	1.45	1.32	2026-04-26 13:17:52.63879	1515
678ae26f-569d-4c0e-b4a9-0a688fc0936a	2.41	219.96	3.11	2.66	2026-04-26 13:17:52.63879	1516
6438657c-ee67-48b5-8de0-62eeb64e0a87	3.4	284.09	2.58	1.24	2026-04-26 13:17:52.63879	1517
e3216b17-e320-4d0f-ada0-b93e60caca02	2.48	106.26	2.8	2.06	2026-04-26 13:17:52.63879	1518
63188d13-0344-4b51-aa79-19ea416c8cdd	3.16	134.56	3.17	2.4	2026-04-26 13:17:52.63879	1519
17932bb9-836e-4db9-b27e-bd1b2f574954	2.01	138.63	2.96	1.99	2026-04-26 13:17:52.63879	1520
459418c3-7fb1-4dd5-9c2b-6a0eb1e128a7	1.03	120.83	2.21	2.64	2026-04-26 13:17:52.63879	1521
4d88229f-55e4-476b-bfc0-096795c485e4	2.55	226.1	1.83	1.7	2026-04-26 13:17:52.63879	1522
2ce612e7-1b0e-4a98-aab2-d00e087e7acd	2.85	141.42	3.62	1.56	2026-04-26 13:17:52.63879	1523
f1c04ba0-d43a-4055-8726-0674ce5a9591	0.81	58.54	1.17	1.59	2026-04-26 13:17:52.63879	1524
b4617646-5ec4-4d15-a573-c29cffb7c27f	1.57	154.4	3.01	1.18	2026-04-26 13:17:52.63879	1525
c02600b3-e48e-4409-95a3-eb683e336b10	0.83	107.67	2.06	2.58	2026-04-26 13:17:52.63879	1526
fc365d4b-670e-4fca-8c15-bed27e9c7c64	2.09	154.21	2.79	2.63	2026-04-26 13:17:52.63879	1527
b5bfff34-218c-48cd-b9ce-673eea91bda1	3.19	272.85	3.94	2.7	2026-04-26 13:17:52.63879	1528
0ef3d984-2e82-4672-bcd6-c49dfd8397b3	2.26	259.59	3.07	1.21	2026-04-26 13:17:52.63879	1529
869589e4-a12e-4a97-9558-0e078bfadd07	1.76	110.58	1.48	2.1	2026-04-26 13:17:52.63879	1530
fc37eb73-af1d-4f66-ab8d-ac6cd664ceea	1.59	104.08	2.04	2.72	2026-04-26 13:17:52.63879	1531
f182189b-b6e2-4aee-bb22-5b1e555815b6	1.69	253.52	2.48	1.25	2026-04-26 13:17:52.63879	1532
4a03155b-1956-495a-aa04-f02a9c3d31c8	1.28	167.15	1.59	1.42	2026-04-26 13:17:52.63879	1533
6b9cb1d4-e93d-40cb-8099-44f30eae119b	0.91	146.57	3.22	1.53	2026-04-26 13:17:52.63879	1534
77c9a885-1040-44e4-8b7c-18dccb3b1a81	1.56	254.06	3.67	1.59	2026-04-26 13:17:52.63879	1535
ab089221-71a5-4b3c-a06e-445f999eed0a	2.29	152.8	3.45	1.34	2026-04-26 13:17:52.63879	1536
2954b16d-0db5-4232-8923-ca1c2a81be0a	2.38	95.45	3.01	2.25	2026-04-26 13:17:52.63879	1537
e072183d-f51e-4965-a227-e111304e8104	2.11	132.02	3.77	1.52	2026-04-26 13:17:52.63879	1538
d59dcfa3-ec8d-4789-81cd-22e13a9c829c	1.04	96.94	1.73	2.36	2026-04-26 13:17:52.63879	1539
e32ad455-b5bd-49ef-b295-f81c8a11da16	3.15	266.71	1.76	1.61	2026-04-26 13:17:52.63879	1540
21d6e120-8fa3-4a51-9ade-436c7d77e075	2.39	147.95	3.07	2.22	2026-04-26 13:17:52.63879	1541
efff145d-5625-4a2c-ac23-ffdccad3e85b	2.75	235.37	3.57	1.89	2026-04-26 13:17:52.63879	1542
1a64a717-44a3-4308-9eaa-d6a37163544c	0.78	221.3	3	1.53	2026-04-26 13:17:52.63879	1543
474c6490-57e2-4c5c-ad69-dc1c4cf6b1f5	3.36	257.41	1.79	1.94	2026-04-26 13:17:52.63879	1544
7f85773c-30b2-4ff2-877a-93f568213806	3.19	247.57	1.26	2.43	2026-04-26 13:17:52.63879	1545
4d87ace7-e3ee-4ea4-92f6-c395ef501428	1.52	186.95	2.49	1.97	2026-04-26 13:17:52.63879	1546
4d289278-e3f8-42ed-af6a-2d3259072f3f	1.76	221.66	2.96	1.65	2026-04-26 13:17:52.63879	1547
ebffe864-14eb-465e-b745-192f6e5717bf	1.1	292.32	2.83	1.4	2026-04-26 13:17:52.63879	1548
fb9a49ca-e5e2-4be1-9e2c-5d77c4db770b	2.67	65.13	1.14	1.42	2026-04-26 13:17:52.63879	1549
150f7991-fbd0-429e-bdf9-c60b50b1aae6	1.03	134.4	3.03	2.61	2026-04-26 13:17:52.63879	1550
569b5e54-a5e6-442c-94e0-64a8245dcd07	3.13	106.73	3.08	2.82	2026-04-26 13:17:52.63879	1551
1525c80d-cf06-4108-bab9-0205f6ed78f7	1.09	157.73	2.73	1.37	2026-04-26 13:17:52.63879	1552
c6e7314c-8525-4191-80c2-2c3a921f415d	1.01	183.9	2.83	2.37	2026-04-26 13:17:52.63879	1553
01d04063-d9c3-43b8-9cd1-f2c365206958	3.36	57.89	2.04	1.26	2026-04-26 13:17:52.63879	1554
688a8c3f-fa38-4308-89d5-212d6faf8a77	1.08	216.58	2.79	2.83	2026-04-26 13:17:52.63879	1555
80f0e0e1-a56b-4969-9328-300dd7d3889e	2.53	291.75	2.61	1.3	2026-04-26 13:17:52.63879	1556
bf4c1fb6-a269-4569-be90-6b6a998ee7b9	3.04	127.52	3.69	1.24	2026-04-26 13:17:52.63879	1557
4421a7a4-be54-4494-b732-9068a725e9b7	1.04	51.02	2.53	1.96	2026-04-26 13:17:52.63879	1558
5d9bfdd7-0a23-41a4-bff6-1d1b588e6b78	1.87	155.68	1.8	1.63	2026-04-26 13:17:52.63879	1559
9272aa0e-60be-48a7-b1a9-e260a3fcd3d2	1.9	133.31	1.31	1.33	2026-04-26 13:17:52.63879	1560
cd6c4c38-b00a-4644-b1a1-7fc4b8c0ef46	1.22	106.51	3.82	2.12	2026-04-26 13:17:52.63879	1561
903c34b0-9809-44ee-af0c-97ca045cde31	2.42	112.19	1.97	1.14	2026-04-26 13:17:52.63879	1562
ec564929-5d5d-4964-85c9-c2c00181550b	0.79	196.89	3.05	1.38	2026-04-26 13:17:52.63879	1563
eb5b0417-51b7-4630-89a7-fbac16715f99	3.19	140.31	2.3	1.52	2026-04-26 13:17:52.63879	1564
2f71377b-f84e-4d62-a2dd-610ad858eff9	2.35	140.67	2.93	2.66	2026-04-26 13:17:52.63879	1565
ccefa4d3-0ac6-49b4-b548-44dbecf95314	3.43	166.37	2.72	1.21	2026-04-26 13:17:52.63879	1566
641085c9-c0f6-4e22-ba3b-1fb94f36d101	0.99	298.7	1.76	2.7	2026-04-26 13:17:52.63879	1567
98771193-9965-407f-9a85-7fede6b77203	2.67	273.99	2.96	1.33	2026-04-26 13:17:52.63879	1568
a4f48f59-b6eb-49b5-bda3-c4cbe0959ccc	0.54	173.04	2.89	1.15	2026-04-26 13:17:52.63879	1569
349fd483-5e87-4860-902e-0499901d0595	2.77	111.27	2.16	1.03	2026-04-26 13:17:52.63879	1570
9c9909c7-05a2-4227-acf9-28521c0da135	0.97	127.47	1.34	1.19	2026-04-26 13:17:52.63879	1571
f305ad8e-b6cd-4ccb-8d44-e33845a294a1	0.6	128.88	2.03	1.66	2026-04-26 13:17:52.63879	1572
baa2883c-e58b-4231-a08f-44235a4dea80	2.18	191.99	3.14	1.42	2026-04-26 13:17:52.63879	1573
0d8f1e65-863d-45d8-bd85-f7a7bb2a19d6	2.44	208.89	3.25	2.76	2026-04-26 13:17:52.63879	1574
1274b8fd-1c04-42fe-ae89-7ee5494a8909	2.16	89.23	1.56	1.08	2026-04-26 13:17:52.63879	1575
177aba49-3dfa-4284-870d-fb28b84d4534	2.48	145	2.42	2.03	2026-04-26 13:17:52.63879	1576
a3e55969-7679-400e-b2f8-63e2955e54c2	2.78	237.19	1.76	2.53	2026-04-26 13:17:52.63879	1577
ccea675a-ef56-4f85-b8c5-317c8ce5a850	2.37	84.18	3.44	2.77	2026-04-26 13:17:52.63879	1578
3aa10c1e-2460-4377-b65a-f47990cf20a4	0.78	296.71	2.85	2.31	2026-04-26 13:17:52.63879	1579
95049103-faa4-4e21-9165-033861d9c488	1.03	122.34	2.84	1.95	2026-04-26 13:17:52.63879	1580
2c47bb0c-f0bc-43ef-97b7-ec4d8c96c29f	3.14	52.05	3.89	1.08	2026-04-26 13:17:52.63879	1581
c1b55a4f-d015-496a-97a5-0eda929e3dc3	1.81	59.53	2	1.99	2026-04-26 13:17:52.63879	1582
b8174b2e-1cb1-472c-ac48-c2a6912e48de	2.08	167.03	1.45	1.08	2026-04-26 13:17:52.63879	1583
ef342171-814f-4d88-ba4b-9c3e820c63de	1	73.3	1.76	2.08	2026-04-26 13:17:52.63879	1584
ff142781-a79f-4ff4-a703-7732aa9af9e3	0.77	290.14	2.17	2.08	2026-04-26 13:17:52.63879	1585
53988c3d-02b2-4be9-95b5-739ffb19f562	1.85	268.48	2.1	2.88	2026-04-26 13:17:52.63879	1586
90e0676d-9543-455e-b95b-033a3dc29094	2.39	221.75	1.78	2.27	2026-04-26 13:17:52.63879	1587
aa53d45e-4f36-4897-b499-3ed698190647	2.92	101.61	2.83	1.12	2026-04-26 13:17:52.63879	1588
0d2cac97-cb24-4e98-8c0f-4356b3e97f0a	2.43	211.39	1.49	2.81	2026-04-26 13:17:52.63879	1589
3781bb39-94d7-41ab-bddb-e6008d65fc3e	2.09	179.45	1.68	2.51	2026-04-26 13:17:52.63879	1590
9c7b719e-b70f-4394-9ff1-ed98e6b5cc58	0.5	151.93	1.19	1.75	2026-04-26 13:17:52.63879	1591
e7450082-184d-42e5-9e10-1ba889b81e15	2.31	134.23	1.29	2.66	2026-04-26 13:17:52.63879	1592
7f8cdea0-97fa-4f5c-a07d-339312618900	2.2	81.68	2.62	2.63	2026-04-26 13:17:52.63879	1593
1cdd7dbf-0fb2-4741-b2ce-1648f6588f83	0.64	56.41	1.7	2.8	2026-04-26 13:17:52.63879	1594
addb0a76-380c-4a6e-81a0-5642a291744d	2.05	255.8	3.97	1.88	2026-04-26 13:17:52.63879	1595
37353a0a-b1de-4f16-ade8-742e357bff71	2.71	239.8	3.31	1.54	2026-04-26 13:17:52.63879	1596
d806cbd2-e0cc-4e83-84a5-7e939ebd4b95	3.41	61.91	2.7	1.55	2026-04-26 13:17:52.63879	1597
84970f72-5d25-45d2-96d7-3ed2f3315168	2.43	195.63	1.12	1.62	2026-04-26 13:17:52.63879	1598
80fbbed9-4a78-4bd2-87e9-af704fc2de31	2.09	166.46	3.32	1.5	2026-04-26 13:17:52.63879	1599
8a2c8802-0ed7-4c68-b865-2b6b9b4e467b	1.65	180.58	2.21	2.97	2026-04-26 13:17:52.63879	1600
92491d57-33b8-476b-b82f-4d782b7925be	0.61	183.29	2.46	1.57	2026-04-26 13:17:52.63879	1601
101a0017-9d06-4cab-9376-10fca55b80fe	0.6	80.27	2.67	2.04	2026-04-26 13:17:52.63879	1602
7a670221-9a34-46e2-b81b-1d7085b29ac8	1.93	160.63	2.84	2.37	2026-04-26 13:17:52.63879	1603
b486f1ad-7297-436a-929a-3696998a7284	1.37	127.4	3.66	1.41	2026-04-26 13:17:52.63879	1604
ef7e5768-abc3-451c-8700-eadd22e0526f	1.94	284.6	1.96	2.49	2026-04-26 13:17:52.63879	1605
63993198-0f2e-4909-b4ec-c6e6b29c10e1	0.51	125.87	1	1.93	2026-04-26 13:17:52.63879	1606
785054cb-4641-468e-b119-e344676aba22	2.25	163.32	2.11	2.36	2026-04-26 13:17:52.63879	1607
2641930a-9a92-4a93-a28c-017fc48fc1b3	2.41	66.59	1.18	1.92	2026-04-26 13:17:52.63879	1608
4a2d3659-552c-4773-9281-2b75e2ba4bb6	2.71	264.33	1.62	2.66	2026-04-26 13:17:52.63879	1609
78beb24a-058f-4cc9-864c-1d33949d4818	2.79	135.86	3.9	1.71	2026-04-26 13:17:52.63879	1610
0889297c-d685-4c5d-bfc9-bba36110c15d	3.35	247.82	2.7	2.96	2026-04-26 13:17:52.63879	1611
acef61e7-7f4b-4b30-b6c5-425f9e36a90e	3.18	225.63	2.37	2.35	2026-04-26 13:17:52.63879	1612
186f60d6-c7c7-467f-b4fe-fa7636f79a23	0.74	53.94	2.57	1.3	2026-04-26 13:17:52.63879	1613
4079e5e0-9e84-4432-b44a-32af8e59d4b6	2.59	148.14	2.8	1.69	2026-04-26 13:17:52.63879	1614
29a4907b-3872-4537-b4c9-a42ef3e28b0e	2.09	274.9	1.79	2.21	2026-04-26 13:17:52.63879	1615
0881dc31-d7be-4ddb-99c9-8b6d0fa16990	2.49	213.11	3.94	1.73	2026-04-26 13:17:52.63879	1616
89e3921f-88ff-4fa8-9092-9e3260a671eb	2.06	95.42	3.85	1.19	2026-04-26 13:17:52.63879	1617
22899238-2cb3-4920-ad5f-d00408f74869	1.99	298.27	3.72	2.44	2026-04-26 13:17:52.63879	1618
69b47d8f-7fea-4be2-b860-28261bd322a8	2.57	58.75	1.78	2.39	2026-04-26 13:17:52.63879	1619
ed04eb26-1f11-4e73-bf37-9045f051da24	2.59	80.25	1.72	2.92	2026-04-26 13:17:52.63879	1620
82b0280e-102f-4227-8bdc-035191a662da	1.9	236.45	3.66	1.65	2026-04-26 13:17:52.63879	1621
fc3455ee-1aca-499b-a15a-59daa28c0dae	2.71	277.16	2.34	2.82	2026-04-26 13:17:52.63879	1622
73844c9a-3cfa-47e8-a779-2fd0f85cd1a4	2.6	200.87	2.11	1.57	2026-04-26 13:17:52.63879	1623
1395deb5-7679-416b-8a65-aaf8e835d7c3	1.68	143.31	1.16	2.02	2026-04-26 13:17:52.63879	1624
6b95825f-39e7-468c-9658-f24c248a95ab	3.12	232.22	3.94	2.32	2026-04-26 13:17:52.63879	1625
db738178-6c85-4003-814c-43efae201f66	2.58	70.58	4	2.15	2026-04-26 13:17:53.442546	1626
8d34dd99-e669-4ca7-99af-1d91991a09c9	2.33	183.46	1.86	2.88	2026-04-26 13:17:53.442546	1627
da38da3e-9316-49d8-af58-cfca2be2ecea	1.05	178.49	4	2.41	2026-04-26 13:17:53.442546	1628
8d34dd99-e669-4ca7-99af-1d91991a09c9	2.33	183.46	1.86	2.88	2026-04-26 13:17:53.442546	1629
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.16	85.43	1.28	2.92	2026-04-26 13:17:53.442546	1630
083b503f-bc9a-4761-9232-985118e3bde4	2.31	137.98	3.4	1.62	2026-04-26 13:17:54.460292	1631
84898f92-b30c-4251-99c5-6d4b8ee07428	3.21	100.63	3.92	1.91	2026-04-26 13:17:54.460292	1632
1798c0d0-79e4-4d2b-9f3f-990b125d2105	2.74	144.71	3.82	2.72	2026-04-26 13:17:54.460292	1633
d4454c95-37c1-4467-a22e-9fb7abac08a2	2.68	118.29	1.83	2.36	2026-04-26 13:17:54.460292	1634
1dc79f19-741d-4d47-8552-5e53debeed00	3.49	125.2	1.42	2.35	2026-04-26 13:17:54.460292	1635
127074f4-ef1e-44c6-b9d4-6e159522fe6d	1.14	110.9	3.1	2.78	2026-04-26 13:17:54.460292	1636
933c3358-c4a9-4190-ba36-d320f41b28bd	1.81	100.81	2.43	2.52	2026-04-26 13:17:54.460292	1637
24c4b5e6-9375-4a3d-aa2e-8ecf73311e2a	3.42	211.77	3.09	1.43	2026-04-26 13:17:54.460292	1638
8459b204-828a-433c-946a-16940b23fe20	1.87	156.84	2.73	2.94	2026-04-26 13:17:54.460292	1639
6c67de4d-14df-473a-b5b7-234ca1892d36	0.84	158.09	3.85	2.43	2026-04-26 13:17:54.460292	1640
1a1da762-8b17-44fc-ab54-aacee70233c0	0.65	62.25	3.85	1.75	2026-04-26 13:17:54.460292	1641
eaf83308-161d-4cbe-9a8f-c87d75ee5421	1.3	258.75	1.03	2.15	2026-04-26 13:17:54.460292	1642
2639cd66-3527-4a6d-b26e-dfb2491c1bf2	1.54	207.55	2.83	1.99	2026-04-26 13:17:54.460292	1643
8d34dd99-e669-4ca7-99af-1d91991a09c9	1.33	232.3	2.13	2.12	2026-04-26 13:17:54.460292	1644
77398e9d-8c73-4cfb-9019-93696911c12d	0.59	96.89	1.59	2.23	2026-04-26 13:17:54.460292	1645
af79ed93-81e1-4dad-ab43-483f230ed7d4	2.04	272.94	3.34	1.65	2026-04-26 13:17:54.460292	1646
a09b5914-31d8-4628-bfde-a2ed4f60f907	2.42	271.55	3.87	2.48	2026-04-26 13:17:54.460292	1647
af5d64a0-8fd6-4135-9b5c-ed9a17afe722	2.01	154.64	1.7	1.35	2026-04-26 13:17:54.460292	1648
48f2ef4f-6f48-4a5a-8aca-e2844be19a4d	2.81	57.94	3.55	2.9	2026-04-26 13:17:54.460292	1649
c4a5295a-ac7e-4505-ae47-069a3a50ecec	1.01	269.65	3.85	1.66	2026-04-26 13:17:54.460292	1650
0cdc07b0-d122-4345-a871-ed8736125a13	3.29	206.92	2.53	1.73	2026-04-26 13:17:54.460292	1651
8be3185b-bc1c-4142-b567-48aaff220b01	3.4	259.25	2.37	2.14	2026-04-26 13:17:54.460292	1652
d9051e4d-d569-4f01-89e0-7d857762afe5	1.59	153.05	1.51	1.2	2026-04-26 13:17:54.460292	1653
3fad7c09-4ab3-4a8b-aa29-7211513f7237	2.35	251.51	3.76	1.07	2026-04-26 13:17:54.460292	1654
dbbf360e-7216-4601-8614-038fe1dcc2ba	3	291.38	3.15	2.58	2026-04-26 13:17:54.460292	1655
9bd9f3c5-1b49-4927-8cdf-35373636ae00	1.17	254.76	2.4	2.98	2026-04-26 13:17:54.460292	1656
160d3adf-6a5a-4442-8c35-f8ff730e0036	1.51	76.87	1.74	1.21	2026-04-26 13:17:54.460292	1657
5c42027f-8aaa-441b-990e-215c05fc0300	2.86	260.37	3.83	2.18	2026-04-26 13:17:54.460292	1658
bfc1d7fb-6dd6-42fd-a795-053bca272428	0.93	130.04	1.03	2.64	2026-04-26 13:17:54.460292	1659
fe19663b-26a2-40d0-a329-bf3f1f6a25a6	3.04	172.44	2.1	2.71	2026-04-26 13:17:54.460292	1660
09bcbc34-b01a-4878-88ae-4aac9ea91b2d	3.15	273.28	2.49	2.79	2026-04-26 13:17:54.460292	1661
28aa7be3-ebf0-4bfb-9e4d-8eb57e7a1a09	2.67	138.68	2.61	1.67	2026-04-26 13:17:54.460292	1662
a463568f-08c1-4eee-ba9f-87eca478959e	2.92	144.85	1.97	2.04	2026-04-26 13:17:54.460292	1663
e91e2255-deed-4ffc-9e86-da19ee4fe2be	1.78	67.43	1.63	1.68	2026-04-26 13:17:54.460292	1664
e6c3818b-29f0-4e36-9052-5e1482339405	2.2	249.48	1.47	2.09	2026-04-26 13:17:54.460292	1665
80d81f80-2426-4c17-9e8a-321da7361798	0.56	273.54	3.34	2.67	2026-04-26 13:17:54.460292	1666
6f817b31-ed87-46bb-9e2e-1140f4cb4cbb	0.55	91.64	1.08	2.32	2026-04-26 13:17:54.460292	1667
34c9e297-d7dc-4168-a5a5-8e7e148dcbbd	1.4	297.42	3.1	1.19	2026-04-26 13:17:54.460292	1668
06c52bbf-cbe5-4db7-997a-9f747283665e	3.41	94.19	2.91	1.76	2026-04-26 13:17:54.460292	1669
0404794e-0a50-4824-a0ee-921cb23888ee	2.13	172.49	3.74	1.51	2026-04-26 13:17:54.460292	1670
ff75e776-7227-4220-9f32-33a6013ae67f	2.27	79.42	3.39	2.79	2026-04-26 13:17:54.460292	1671
522e7eca-7dde-4bb5-9cfd-7bfc1f5aa823	2.25	64.11	3.2	2.02	2026-04-26 13:17:54.460292	1672
0670c059-cbff-4d6e-97fa-c2dbd81ba878	0.64	165.81	2.31	1.27	2026-04-26 13:17:54.460292	1673
41623b9e-303f-46b1-82d3-8883c4a479bb	0.85	179.09	3.12	1.53	2026-04-26 13:17:54.460292	1674
8425054a-27fe-45f7-a2d1-0ca5bb87c22d	2.84	155.27	3.89	2.9	2026-04-26 13:17:54.460292	1675
88f2dc8f-4748-490e-b92d-e31ba6ddaf7b	0.99	135.48	3.18	2.46	2026-04-26 13:17:54.460292	1676
71e03cf9-1c81-44c0-9c0f-63591e58aa30	3.25	102.01	3.91	1.47	2026-04-26 13:17:54.460292	1677
bc2f02a5-cb1e-4610-ac0e-ba7f24c18ccd	1.6	151.47	1.53	1.47	2026-04-26 13:17:54.460292	1678
c110010b-1088-4e02-be3c-83c511d7831c	3.14	277.67	2.24	1.79	2026-04-26 13:17:54.460292	1679
fe8407a5-d6f0-4b63-b0c1-71ad87ffab96	3.2	127.85	3.48	2.29	2026-04-26 13:17:54.460292	1680
19646a15-fc51-45ea-b837-9703ea5e5f8c	1.74	158.51	1.74	2.87	2026-04-26 13:17:54.460292	1681
048313b2-21ec-4fbc-be08-2f0c27fa77f6	2.27	198.89	3.96	2.24	2026-04-26 13:17:54.460292	1682
66ae13b0-bc41-401b-919a-a47c2d82b9ef	2.11	120.17	3.11	2.2	2026-04-26 13:17:54.460292	1683
d87f65c7-d638-4f26-a825-aff5ae57457b	2.37	55.91	1.74	2.17	2026-04-26 13:17:54.460292	1684
7931d397-9cb6-40aa-888c-6b1cfe481a74	1.76	237	2	2.3	2026-04-26 13:17:54.460292	1685
a63e2468-ff52-45a6-a5cd-59944a3859bb	0.92	170.85	1.57	2.63	2026-04-26 13:17:54.460292	1686
2c170f3c-70f5-4432-9675-baa82539a713	0.96	71.96	2.56	1.31	2026-04-26 13:17:54.460292	1687
a49a8d86-d915-4488-b843-de71b33e91fd	1.44	92.21	2.09	2.68	2026-04-26 13:17:54.460292	1688
b2cd1843-50e3-475c-b68b-24bcf035d14a	0.88	127.32	1.47	2.88	2026-04-26 13:17:54.460292	1689
49214cd6-15b3-43e2-b004-f11980bd76e7	2.28	58.02	1.86	1.45	2026-04-26 13:17:54.460292	1690
da38da3e-9316-49d8-af58-cfca2be2ecea	0.67	111.86	2.67	1.91	2026-04-26 13:17:54.460292	1691
06e503be-bdf4-4afe-9252-ad4307d77d34	1.2	160.49	2.68	2.25	2026-04-26 13:17:54.460292	1692
e07bf42f-e0df-4ae0-8b19-59673c872bf2	0.84	215.74	2.98	2.56	2026-04-26 13:17:54.460292	1693
d9ff0e43-523c-4157-b412-c6e488086313	2.1	63.73	2.85	1.79	2026-04-26 13:17:54.460292	1694
73605445-18c0-4c79-aa20-abe75a2aa504	0.5	171.38	1.37	1.79	2026-04-26 13:17:54.460292	1695
17d1d4a8-7fff-4e9d-be6b-1ad8cff6ebd6	0.63	119.6	2.48	2.31	2026-04-26 13:17:54.460292	1696
0ff59da4-ea9a-48c5-9b60-96f17e2644b7	1.31	122.19	2.08	1.3	2026-04-26 13:17:54.460292	1697
0c867821-28e1-489c-96ef-a33a16f96004	3.41	58.18	3.83	2.35	2026-04-26 13:17:54.460292	1698
6111d377-0b6c-4d93-b288-f7ebce6c00fc	1.16	276.94	1.69	1.05	2026-04-26 13:17:54.460292	1699
18905b39-d6a0-4f41-8c02-9b817e1b009d	0.9	257.37	3.98	2.27	2026-04-26 13:17:54.460292	1700
8b417aee-680e-4081-85f2-5a160fb2ff12	0.76	106.4	2.48	2.99	2026-04-26 13:17:54.460292	1701
38b482a7-1f32-4ddc-9349-bcf1da86d546	3.22	285.15	1.79	1.5	2026-04-26 13:17:54.460292	1702
02152a87-fd48-4156-bd2f-afe94c4dc7a6	3.35	187.06	3.37	2.86	2026-04-26 13:17:54.460292	1703
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.7	183.46	3.75	2.41	2026-04-26 13:17:54.460292	1704
79cd4a3f-adcf-4ce5-9d29-62693c93adf2	1.99	138.09	3.99	2.07	2026-04-26 13:17:54.460292	1705
c4391873-3533-4cad-977b-0323fced348e	2.05	215.71	2.06	2.06	2026-04-26 13:17:54.460292	1706
c6338c80-214f-405b-9b0b-7594bb69d230	3.43	157.59	1.14	1.02	2026-04-26 13:17:54.460292	1707
382f3f60-7d3c-4ffc-8b2f-94ce32b77254	0.9	83.39	2.79	1.47	2026-04-26 13:17:54.460292	1708
cf827a4b-a720-4825-84d4-29f047763f7e	1.39	218.6	2.54	1.91	2026-04-26 13:17:54.460292	1709
d5806c60-9752-4845-9128-964d9b723f0b	1.51	280.68	1.91	2.05	2026-04-26 13:17:54.460292	1710
96e0af22-02e2-46d4-8224-4db162bd27b6	1.26	231.57	2.18	1.35	2026-04-26 13:17:54.460292	1711
9d0c77f5-485a-477d-80ec-8da875eb9852	1.34	106.44	1.18	1.21	2026-04-26 13:17:54.460292	1712
c19c4f6a-3738-436e-b7dc-b27df3129b28	3.47	125.91	1.2	2.63	2026-04-26 13:17:54.460292	1713
2d78aa7b-b8fb-4cc0-9d8a-f6a927032041	2.57	283.69	2.05	2.05	2026-04-26 13:17:54.460292	1714
dbebf850-836f-4532-807c-c1e3f5b5d597	1.96	177.94	3.88	1.71	2026-04-26 13:17:54.460292	1715
453f03e0-cb8d-4681-b343-d681f27e84f8	2.66	180.95	2.55	2.81	2026-04-26 13:17:54.460292	1716
13d5f24a-3280-4db1-ae8d-4e7ac37dca9d	0.72	242.98	2.06	1.2	2026-04-26 13:17:54.460292	1717
40f8a8d7-327f-4f20-a15c-cbd9fb6f5e75	2.78	61	2.16	2.79	2026-04-26 13:17:54.460292	1718
8cfcaf67-4ae0-46c6-996e-6ce551b4096d	2.16	152.94	3.15	2.64	2026-04-26 13:17:54.460292	1719
05bb5c72-6613-4d45-a876-a6c5fb64222e	2.38	297.21	3.11	2.48	2026-04-26 13:17:54.460292	1720
37b80a41-5dec-4adb-ac19-126072ec4a13	2.34	249.91	2.22	2.74	2026-04-26 13:17:54.460292	1721
514c19e7-d8eb-4f8a-b58c-db01659e571e	1.91	167.77	3.7	1.59	2026-04-26 13:17:54.460292	1722
27ded357-dfee-45c6-844b-2108e05a105b	3.26	125.58	3.99	1.95	2026-04-26 13:17:54.460292	1723
affc16bb-f7a4-4ff2-90df-48caf7eebddc	2.72	202.39	2.96	2.81	2026-04-26 13:17:54.460292	1724
cb0fe3b7-fbc8-479b-bd12-6acfeeeeffeb	0.6	273.09	2.08	1.4	2026-04-26 13:17:54.460292	1725
c0f13516-b42b-4edf-8d54-260ed3432c91	0.85	58.79	3.75	1.98	2026-04-26 13:17:54.460292	1726
a6b3ffd9-c2dc-4bf3-872f-1d4dfaff44ce	2.59	268.28	3.38	2.36	2026-04-26 13:17:54.460292	1727
4c18584e-0e3e-40cc-94a4-dd6106965efb	1.55	218.05	1.4	2.53	2026-04-26 13:17:54.460292	1728
42be6f12-2662-427d-b3bb-9f8fb042cde5	1.11	248.76	2.64	2.45	2026-04-26 13:17:54.460292	1729
a9a3a5fa-5c98-4e69-883b-2afa82b1877f	1.4	280.96	1.8	1.99	2026-04-26 13:17:54.460292	1730
69ceb13d-c6ba-480a-9bb6-8c94350b80bb	2.96	248.44	3.72	2.84	2026-04-26 13:17:54.460292	1731
6946eb18-50ec-477c-808d-f71c98670e15	1.87	208.23	3.2	1.34	2026-04-26 13:17:54.460292	1732
db738178-6c85-4003-814c-43efae201f66	2.62	54.07	1.89	2.63	2026-04-26 13:17:54.460292	1733
4b5f92c9-7d51-4b0e-a137-acd779a460c0	2.86	208.66	2.91	1.15	2026-04-26 13:17:54.460292	1734
343b8afa-f5f3-413a-8faf-37c6af937323	0.64	74.84	2.24	2.5	2026-04-26 13:17:54.460292	1735
aa3eddc8-b910-47a9-b691-2ec377a4b6c3	0.99	225.93	1.77	2.98	2026-04-26 13:17:54.460292	1736
10412ce9-7326-4907-98fb-f30f329eb834	0.81	137.62	3.62	1.42	2026-04-26 13:17:54.460292	1737
a7a83b3b-4904-468d-b1ff-79250bae2178	2.41	181.86	3.65	2.03	2026-04-26 13:17:54.460292	1738
de64100b-0d55-4423-8139-e21bf67b1ba3	2.48	286.79	1.6	2.21	2026-04-26 13:17:54.460292	1739
48f1cae9-db76-406a-84c3-4b1d3fd1f646	2.98	117.42	1.51	2.06	2026-04-26 13:17:54.460292	1740
bff99142-a62f-4628-a6ff-c053c6deb013	2.99	244.99	1.73	1.81	2026-04-26 13:17:54.460292	1741
fb073968-3588-453a-85e2-75089d4c03f1	2.43	163.84	3.09	2.21	2026-04-26 13:17:54.460292	1742
377f4e07-93cb-4351-8c6b-62851338fdb0	2.67	55.8	2.99	2.4	2026-04-26 13:17:54.460292	1743
19bdfc5a-e1d0-463a-b163-7d7a692f73b8	2.52	260.06	3	1.65	2026-04-26 13:17:54.460292	1744
cbd20eb0-7239-4734-b82b-404600e7d66b	3.47	265.47	1.87	1.5	2026-04-26 13:17:54.460292	1745
18c3479d-2072-411f-8d91-9a580608c627	0.6	297.91	2.04	1.35	2026-04-26 13:17:54.460292	1746
ca09ced3-7738-4c9e-887f-d34312c3d8e4	2.47	210.23	2.09	1.66	2026-04-26 13:17:54.460292	1747
07a6b221-981a-4cce-bb5d-3d5a872c97b7	2.01	131.76	3.52	2.89	2026-04-26 13:17:54.460292	1748
fa753e0b-bcb9-41b7-9c82-6fccd2333db1	2.34	286.55	2.05	1.88	2026-04-26 13:17:54.460292	1749
100a7e1e-99f2-4b0d-8a9d-842a454a612f	2.06	130.89	3.41	2.04	2026-04-26 13:17:54.460292	1750
41bd264e-1eb3-4ccb-ab43-221d92913239	1.99	155.08	3.75	2.44	2026-04-26 13:17:54.460292	1751
b80e97e3-fe08-465e-ac72-eea64d2d6182	2.11	148.25	3.65	1.86	2026-04-26 13:17:54.460292	1752
ed596397-26d6-4d02-a2f1-dbbf5f8ab704	1.24	61.73	1.29	2.55	2026-04-26 13:17:54.460292	1753
5d36c463-e893-43a2-b567-1e7fbcb3c80c	2.49	72.23	1.45	2.9	2026-04-26 13:17:54.460292	1754
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	1.84	264.4	2.75	1.27	2026-04-26 13:17:54.460292	1755
b611f2f3-4dce-4565-9634-c5f67f16841f	1.63	225.69	1.24	1.54	2026-04-26 13:17:54.460292	1756
af16d415-a7a8-426f-8d38-2ade72d8acb5	2.97	212.24	2.92	1.16	2026-04-26 13:17:54.460292	1757
a18f9d90-4ce4-4793-a9c1-9452712601a3	1.33	168.42	3.71	1.79	2026-04-26 13:17:54.460292	1758
2421d8dc-3548-4b72-b606-b235ecdf5448	1.98	237.39	3.7	2.18	2026-04-26 13:17:54.460292	1759
bb6389a5-9e20-4135-8648-8a813bb296b7	0.92	225.59	3.06	1.17	2026-04-26 13:17:54.460292	1760
6447b600-e734-4067-87b1-b915998722b4	1.51	183.19	1.48	2.29	2026-04-26 13:17:54.460292	1761
a1fc9f0b-f1e6-4819-9cb5-1ce77541a1b5	3.29	97.97	1.17	1.57	2026-04-26 13:17:54.460292	1762
25df9dd3-d744-4a1e-a96b-d1322d6952f5	2.61	86.29	1.95	1.48	2026-04-26 13:17:54.460292	1763
8e3909e7-8ee5-4db8-9278-087d2851a6f1	2.89	298.77	2.9	2.76	2026-04-26 13:17:54.460292	1764
3fcc2af3-e524-4b65-9649-cc48a58b7463	3.04	265.08	3.3	2.1	2026-04-26 13:17:54.460292	1765
3045ab21-e78f-41cf-9f96-102cfd907777	3.45	239.91	2.79	1.14	2026-04-26 13:17:54.460292	1766
211e6d92-06f3-4968-ab18-4d3606fb0313	0.54	89.84	4	1.52	2026-04-26 13:17:54.460292	1767
577c5ceb-5d82-4a67-914e-cc3249432558	0.63	94.16	2.5	1.99	2026-04-26 13:17:54.460292	1768
a9955bda-fedb-44d9-b5a6-33b7ceff70cc	3.01	183.62	3.54	2.03	2026-04-26 13:17:54.460292	1769
cac6b96e-6c77-4c20-b201-5d059367fbf0	0.54	105.02	2.12	1.48	2026-04-26 13:17:54.460292	1770
40b83090-1da5-4f1a-85d6-884f75d306d9	1.24	226.58	1.02	2.59	2026-04-26 13:17:54.460292	1771
af6f8bce-ab49-4a79-a40c-4a4aba8d8552	2.92	290	3.26	1.76	2026-04-26 13:17:54.460292	1772
7674a04d-8f67-4d07-9eab-998e344a03c9	0.91	103.59	2.45	1.89	2026-04-26 13:17:54.460292	1773
f97b5670-ef68-4a86-97c0-6385e6ae7405	1.82	194.92	2.02	1.68	2026-04-26 13:17:54.460292	1774
4fc26046-1ae2-4e60-99cf-95ef8ee6524a	1.21	224.24	2.5	1.24	2026-04-26 13:17:54.460292	1775
e332ef09-be23-4a9d-b003-f886bfae870d	3.36	173.97	1.64	2.21	2026-04-26 13:17:54.460292	1776
88f0fd74-5fbe-402b-b1f9-8b0185f9b042	1.91	72.83	1.65	2.3	2026-04-26 13:17:54.460292	1777
7289ae0e-9605-4d46-aaee-5b05ddd96e59	0.87	121.99	1.98	1.98	2026-04-26 13:17:54.460292	1778
b0318b61-a090-47a1-a30e-1f29ba099262	0.72	254.82	3.73	3	2026-04-26 13:17:54.460292	1779
26ec3ee2-f140-4f43-b13b-9299796dd2d1	1.63	279.88	1.09	2.52	2026-04-26 13:17:54.460292	1780
9dab24c7-177d-4ec4-8c0b-2323b92d3d4a	2.3	184.26	3.95	2.91	2026-04-26 13:17:54.460292	1781
1a6d5e85-787b-461f-8db7-9cd8f8d81ece	2.26	192.71	3.74	1.3	2026-04-26 13:17:54.460292	1782
27b23042-92c6-4a49-b397-6c200041d8ee	3.21	81.49	2.56	1.94	2026-04-26 13:17:54.460292	1783
08f0acf7-18ec-45eb-8146-8042969d5c7a	3.42	94.56	2.33	1.38	2026-04-26 13:17:54.460292	1784
a03af7ca-2046-499e-b19d-b6571e696f89	1.95	219.7	1.98	2.32	2026-04-26 13:17:54.460292	1785
e7fd011f-5572-4ee9-a3de-2d9d4d5c818d	1.28	87.83	2.63	2.64	2026-04-26 13:17:54.460292	1786
4065ab51-f74f-42a2-9363-7146df43c932	1.48	273.26	2.58	1.36	2026-04-26 13:17:54.460292	1787
a07f2ed2-35ae-4720-ad65-a22fe59566d3	0.95	157.18	3.18	2.35	2026-04-26 13:17:54.460292	1788
02c4237f-a7f5-452b-82c3-1fe296af3c3c	0.51	284.56	1.43	2.78	2026-04-26 13:17:54.460292	1789
62b7cf0d-cf31-493a-85aa-8fa347acda25	2.41	191.1	3.39	1.72	2026-04-26 13:17:54.460292	1790
ab3db038-d69b-451e-bba3-08e8119898b4	1.36	239.18	3.95	1.07	2026-04-26 13:17:54.460292	1791
b685932b-8a27-4288-8795-f6e05e9e4cef	1.46	292.37	3.2	2.3	2026-04-26 13:17:54.460292	1792
9cd7e4f4-8d1a-48da-abbc-075218e9e7a6	2.71	193.98	1.57	2.85	2026-04-26 13:17:54.460292	1793
98d2ddcf-4cfa-4405-9501-d661884b1017	0.81	152.43	1.66	1.65	2026-04-26 13:17:54.460292	1794
d0655207-0783-4e94-98d2-176fe26849d8	0.9	282.91	2.72	2.8	2026-04-26 13:17:54.460292	1795
bcad4d42-8a4f-4b72-a2e1-b607651d5c31	1.54	187.96	3.91	2.9	2026-04-26 13:17:54.460292	1796
9ed4929a-d3c0-4954-b272-227a89cbedec	2.84	184.68	1.36	2.36	2026-04-26 13:17:54.460292	1797
edcb7d15-e6ed-461f-b1b4-38a993ff2ec7	2.32	171.45	2.09	1.36	2026-04-26 13:17:54.460292	1798
2f5d7c02-eadd-4eb2-8dd5-46a5ba51c3f8	3.33	299.67	3.78	2.92	2026-04-26 13:17:54.460292	1799
0ad0a6eb-d13c-440c-b74c-0391605d9685	2.27	64.77	3.26	2.32	2026-04-26 13:17:54.460292	1800
2bb8c959-19b6-4951-8313-e6d0413c9a6f	3.36	231.27	2.27	1.32	2026-04-26 13:17:54.460292	1801
303a312c-4f87-408c-b20b-03d848ec9055	2.35	229.71	3.03	2.82	2026-04-26 13:17:54.460292	1802
a32bfdcd-5dd9-4a93-85e7-c1e608df83ee	2.45	260.35	2.16	1.45	2026-04-26 13:17:54.460292	1803
5ccc6390-43ca-49f5-b6fa-84247d3e52af	1.67	271.03	1.59	1.89	2026-04-26 13:17:54.460292	1804
df299e49-61f2-49ce-8051-e50cfc0b2650	0.92	126.42	1.97	2.04	2026-04-26 13:17:54.460292	1805
86ef6ade-b308-467a-8c42-3c6e4c20ec8d	0.65	141.23	2.71	1.56	2026-04-26 13:17:54.460292	1806
e318d53f-7605-468a-b41d-051070be96a3	3.02	69.55	1.5	2.7	2026-04-26 13:17:54.460292	1807
efc0c233-0113-480b-b3e6-ca3275b5ffde	1.67	194.12	2	2.34	2026-04-26 13:17:54.460292	1808
5808ae27-83d1-4163-9187-6a23f988dc97	1.9	154.7	3.22	1.72	2026-04-26 13:17:54.460292	1809
e304e2e6-fd72-4399-b4d7-fb6416b81f0c	1.41	150.42	3.87	2.84	2026-04-26 13:17:54.460292	1810
678ae26f-569d-4c0e-b4a9-0a688fc0936a	2.64	67.75	1.18	1.29	2026-04-26 13:17:54.460292	1811
6438657c-ee67-48b5-8de0-62eeb64e0a87	2.9	281.19	2.87	2.24	2026-04-26 13:17:54.460292	1812
e3216b17-e320-4d0f-ada0-b93e60caca02	1.9	198.57	1.89	2.57	2026-04-26 13:17:54.460292	1813
63188d13-0344-4b51-aa79-19ea416c8cdd	1.15	143.37	2.83	2.49	2026-04-26 13:17:54.460292	1814
17932bb9-836e-4db9-b27e-bd1b2f574954	3.04	251.02	3.18	1.91	2026-04-26 13:17:54.460292	1815
459418c3-7fb1-4dd5-9c2b-6a0eb1e128a7	0.72	60.66	1.1	2.51	2026-04-26 13:17:54.460292	1816
4d88229f-55e4-476b-bfc0-096795c485e4	3.35	230.2	2.16	1.71	2026-04-26 13:17:54.460292	1817
2ce612e7-1b0e-4a98-aab2-d00e087e7acd	2.28	72.63	3.1	1.9	2026-04-26 13:17:54.460292	1818
f1c04ba0-d43a-4055-8726-0674ce5a9591	1.58	280.64	2.44	3	2026-04-26 13:17:54.460292	1819
b4617646-5ec4-4d15-a573-c29cffb7c27f	2.92	65.03	3.37	2.06	2026-04-26 13:17:54.460292	1820
c02600b3-e48e-4409-95a3-eb683e336b10	1.98	95.65	1.01	1.14	2026-04-26 13:17:54.460292	1821
fc365d4b-670e-4fca-8c15-bed27e9c7c64	1.45	158.61	2.5	1.18	2026-04-26 13:17:54.460292	1822
b5bfff34-218c-48cd-b9ce-673eea91bda1	1.44	255.01	1.72	2.28	2026-04-26 13:17:54.460292	1823
0ef3d984-2e82-4672-bcd6-c49dfd8397b3	2.3	292.93	1.61	1.63	2026-04-26 13:17:54.460292	1824
869589e4-a12e-4a97-9558-0e078bfadd07	2.47	56.87	1.16	1.57	2026-04-26 13:17:54.460292	1825
fc37eb73-af1d-4f66-ab8d-ac6cd664ceea	1.91	75.18	2.67	1.11	2026-04-26 13:17:54.460292	1826
f182189b-b6e2-4aee-bb22-5b1e555815b6	1.97	209.31	1.73	1.43	2026-04-26 13:17:54.460292	1827
4a03155b-1956-495a-aa04-f02a9c3d31c8	0.55	243.7	3.64	1.76	2026-04-26 13:17:54.460292	1828
6b9cb1d4-e93d-40cb-8099-44f30eae119b	2.3	54.13	1.53	2.53	2026-04-26 13:17:54.460292	1829
77c9a885-1040-44e4-8b7c-18dccb3b1a81	3.18	234.02	3.51	1.92	2026-04-26 13:17:54.460292	1830
ab089221-71a5-4b3c-a06e-445f999eed0a	0.58	134.94	2.82	1.54	2026-04-26 13:17:54.460292	1831
2954b16d-0db5-4232-8923-ca1c2a81be0a	2.81	213.19	2.17	2.68	2026-04-26 13:17:54.460292	1832
e072183d-f51e-4965-a227-e111304e8104	3.26	98.7	2.66	2.12	2026-04-26 13:17:54.460292	1833
d59dcfa3-ec8d-4789-81cd-22e13a9c829c	2	63.02	2.28	1.45	2026-04-26 13:17:54.460292	1834
e32ad455-b5bd-49ef-b295-f81c8a11da16	3.41	234.4	3.59	1.48	2026-04-26 13:17:54.460292	1835
21d6e120-8fa3-4a51-9ade-436c7d77e075	2.69	158.16	1.61	1.97	2026-04-26 13:17:54.460292	1836
efff145d-5625-4a2c-ac23-ffdccad3e85b	2.21	61.16	3.07	2.33	2026-04-26 13:17:54.460292	1837
1a64a717-44a3-4308-9eaa-d6a37163544c	2.89	179.47	2.8	1.62	2026-04-26 13:17:54.460292	1838
474c6490-57e2-4c5c-ad69-dc1c4cf6b1f5	0.6	67.01	3.16	2.2	2026-04-26 13:17:54.460292	1839
7f85773c-30b2-4ff2-877a-93f568213806	3.26	248.8	3.82	2.49	2026-04-26 13:17:54.460292	1840
4d87ace7-e3ee-4ea4-92f6-c395ef501428	2.81	268.26	1.27	1.86	2026-04-26 13:17:54.460292	1841
4d289278-e3f8-42ed-af6a-2d3259072f3f	2.75	270.76	3.01	2.07	2026-04-26 13:17:54.460292	1842
ebffe864-14eb-465e-b745-192f6e5717bf	2.38	295.36	2.13	2.7	2026-04-26 13:17:54.460292	1843
fb9a49ca-e5e2-4be1-9e2c-5d77c4db770b	1.06	283.12	2.83	2.22	2026-04-26 13:17:54.460292	1844
150f7991-fbd0-429e-bdf9-c60b50b1aae6	3.04	173.39	3.15	2.2	2026-04-26 13:17:54.460292	1845
569b5e54-a5e6-442c-94e0-64a8245dcd07	1.27	93.98	2.42	1.41	2026-04-26 13:17:54.460292	1846
1525c80d-cf06-4108-bab9-0205f6ed78f7	1.37	215.84	1.48	1.02	2026-04-26 13:17:54.460292	1847
c6e7314c-8525-4191-80c2-2c3a921f415d	3.26	50.53	1.11	1.57	2026-04-26 13:17:54.460292	1848
01d04063-d9c3-43b8-9cd1-f2c365206958	1.84	288.54	2.89	2.23	2026-04-26 13:17:54.460292	1849
688a8c3f-fa38-4308-89d5-212d6faf8a77	2.37	107.76	2.54	1.52	2026-04-26 13:17:54.460292	1850
80f0e0e1-a56b-4969-9328-300dd7d3889e	1.11	92.49	3.03	2.66	2026-04-26 13:17:54.460292	1851
bf4c1fb6-a269-4569-be90-6b6a998ee7b9	3.3	202.13	2.15	1.45	2026-04-26 13:17:54.460292	1852
4421a7a4-be54-4494-b732-9068a725e9b7	2.75	143.87	2.2	2.43	2026-04-26 13:17:54.460292	1853
5d9bfdd7-0a23-41a4-bff6-1d1b588e6b78	1.02	98.39	1.79	1.69	2026-04-26 13:17:54.460292	1854
9272aa0e-60be-48a7-b1a9-e260a3fcd3d2	0.55	195.88	1.17	1.56	2026-04-26 13:17:54.460292	1855
cd6c4c38-b00a-4644-b1a1-7fc4b8c0ef46	2.65	211.78	1.09	2.01	2026-04-26 13:17:54.460292	1856
903c34b0-9809-44ee-af0c-97ca045cde31	1.49	231.02	2.66	1.52	2026-04-26 13:17:54.460292	1857
ec564929-5d5d-4964-85c9-c2c00181550b	2.54	280.74	3.01	2.15	2026-04-26 13:17:54.460292	1858
eb5b0417-51b7-4630-89a7-fbac16715f99	2.6	262.04	2.02	1.34	2026-04-26 13:17:54.460292	1859
2f71377b-f84e-4d62-a2dd-610ad858eff9	0.85	116.2	3.65	2.3	2026-04-26 13:17:54.460292	1860
ccefa4d3-0ac6-49b4-b548-44dbecf95314	2.84	272.25	2.2	1.22	2026-04-26 13:17:54.460292	1861
641085c9-c0f6-4e22-ba3b-1fb94f36d101	2.67	256.13	1.99	1.05	2026-04-26 13:17:54.460292	1862
98771193-9965-407f-9a85-7fede6b77203	3.39	230.74	3.72	1.81	2026-04-26 13:17:54.460292	1863
a4f48f59-b6eb-49b5-bda3-c4cbe0959ccc	0.99	197.11	2.2	2.52	2026-04-26 13:17:54.460292	1864
349fd483-5e87-4860-902e-0499901d0595	0.71	151.35	2.71	2.59	2026-04-26 13:17:54.460292	1865
9c9909c7-05a2-4227-acf9-28521c0da135	3.09	84.46	1.6	2.43	2026-04-26 13:17:54.460292	1866
f305ad8e-b6cd-4ccb-8d44-e33845a294a1	2.34	152.51	1.22	2.59	2026-04-26 13:17:54.460292	1867
baa2883c-e58b-4231-a08f-44235a4dea80	2.55	263.81	2.76	2.62	2026-04-26 13:17:54.460292	1868
0d8f1e65-863d-45d8-bd85-f7a7bb2a19d6	3.43	141.27	2.37	2.44	2026-04-26 13:17:54.460292	1869
1274b8fd-1c04-42fe-ae89-7ee5494a8909	2.88	200.31	3.59	2.04	2026-04-26 13:17:54.460292	1870
177aba49-3dfa-4284-870d-fb28b84d4534	3.34	183.05	3.13	1.63	2026-04-26 13:17:54.460292	1871
a3e55969-7679-400e-b2f8-63e2955e54c2	3.06	186.21	2.96	1.08	2026-04-26 13:17:54.460292	1872
ccea675a-ef56-4f85-b8c5-317c8ce5a850	1.63	183.07	1.96	2.82	2026-04-26 13:17:54.460292	1873
3aa10c1e-2460-4377-b65a-f47990cf20a4	2.07	80.02	3.89	2.51	2026-04-26 13:17:54.460292	1874
95049103-faa4-4e21-9165-033861d9c488	0.96	84.98	3.34	2.46	2026-04-26 13:17:54.460292	1875
2c47bb0c-f0bc-43ef-97b7-ec4d8c96c29f	1.42	276.98	3.76	2.05	2026-04-26 13:17:54.460292	1876
c1b55a4f-d015-496a-97a5-0eda929e3dc3	2.51	105.87	1.29	2.79	2026-04-26 13:17:54.460292	1877
b8174b2e-1cb1-472c-ac48-c2a6912e48de	1.04	235.47	3.07	1.58	2026-04-26 13:17:54.460292	1878
ef342171-814f-4d88-ba4b-9c3e820c63de	0.97	109.71	2.2	2.34	2026-04-26 13:17:54.460292	1879
ff142781-a79f-4ff4-a703-7732aa9af9e3	3.22	267.98	3.9	2.19	2026-04-26 13:17:54.460292	1880
53988c3d-02b2-4be9-95b5-739ffb19f562	2.23	173.98	2.8	1.96	2026-04-26 13:17:54.460292	1881
90e0676d-9543-455e-b95b-033a3dc29094	2.7	131.85	2.15	1.9	2026-04-26 13:17:54.460292	1882
aa53d45e-4f36-4897-b499-3ed698190647	1.56	224.75	2.49	1.05	2026-04-26 13:17:54.460292	1883
0d2cac97-cb24-4e98-8c0f-4356b3e97f0a	2.19	55.62	2.6	2.69	2026-04-26 13:17:54.460292	1884
3781bb39-94d7-41ab-bddb-e6008d65fc3e	2.46	245.07	2.66	2.13	2026-04-26 13:17:54.460292	1885
9c7b719e-b70f-4394-9ff1-ed98e6b5cc58	0.65	67.17	3.99	2.64	2026-04-26 13:17:54.460292	1886
e7450082-184d-42e5-9e10-1ba889b81e15	1.29	156.7	2.17	2.27	2026-04-26 13:17:54.460292	1887
7f8cdea0-97fa-4f5c-a07d-339312618900	0.74	194.53	2.08	2.18	2026-04-26 13:17:54.460292	1888
1cdd7dbf-0fb2-4741-b2ce-1648f6588f83	1.48	82.43	3.47	1.17	2026-04-26 13:17:54.460292	1889
addb0a76-380c-4a6e-81a0-5642a291744d	1.98	260.73	2.85	2.77	2026-04-26 13:17:54.460292	1890
37353a0a-b1de-4f16-ade8-742e357bff71	2.34	204.56	2.67	1.29	2026-04-26 13:17:54.460292	1891
d806cbd2-e0cc-4e83-84a5-7e939ebd4b95	2.84	231.56	2.39	1.16	2026-04-26 13:17:54.460292	1892
84970f72-5d25-45d2-96d7-3ed2f3315168	1.23	70.08	3.03	2.09	2026-04-26 13:17:54.460292	1893
80fbbed9-4a78-4bd2-87e9-af704fc2de31	1.05	59.17	1.27	2.41	2026-04-26 13:17:54.460292	1894
8a2c8802-0ed7-4c68-b865-2b6b9b4e467b	1.05	297.58	3.13	2.81	2026-04-26 13:17:54.460292	1895
92491d57-33b8-476b-b82f-4d782b7925be	3.07	144.3	3.32	1.33	2026-04-26 13:17:54.460292	1896
101a0017-9d06-4cab-9376-10fca55b80fe	1.86	295.53	1.18	2.23	2026-04-26 13:17:54.460292	1897
7a670221-9a34-46e2-b81b-1d7085b29ac8	2.78	125.4	2.36	1.65	2026-04-26 13:17:54.460292	1898
b486f1ad-7297-436a-929a-3696998a7284	1.2	158.61	1.41	1.75	2026-04-26 13:17:54.460292	1899
ef7e5768-abc3-451c-8700-eadd22e0526f	3.06	52.95	2.41	2.62	2026-04-26 13:17:54.460292	1900
63993198-0f2e-4909-b4ec-c6e6b29c10e1	3.11	280.99	2.49	1.72	2026-04-26 13:17:54.460292	1901
785054cb-4641-468e-b119-e344676aba22	1.82	66.38	3.79	2.88	2026-04-26 13:17:54.460292	1902
2641930a-9a92-4a93-a28c-017fc48fc1b3	2.91	183.35	2.62	1.42	2026-04-26 13:17:54.460292	1903
4a2d3659-552c-4773-9281-2b75e2ba4bb6	1.39	237.51	2.24	1.44	2026-04-26 13:17:54.460292	1904
78beb24a-058f-4cc9-864c-1d33949d4818	2.08	115.55	2.24	1.98	2026-04-26 13:17:54.460292	1905
0889297c-d685-4c5d-bfc9-bba36110c15d	1.85	116.85	1.69	2.41	2026-04-26 13:17:54.460292	1906
acef61e7-7f4b-4b30-b6c5-425f9e36a90e	3.07	82.19	3.54	1.31	2026-04-26 13:17:54.460292	1907
186f60d6-c7c7-467f-b4fe-fa7636f79a23	0.56	298.06	2.42	2.36	2026-04-26 13:17:54.460292	1908
4079e5e0-9e84-4432-b44a-32af8e59d4b6	0.86	141.14	2.45	1.2	2026-04-26 13:17:54.460292	1909
29a4907b-3872-4537-b4c9-a42ef3e28b0e	3.07	191.8	1.32	1.43	2026-04-26 13:17:54.460292	1910
0881dc31-d7be-4ddb-99c9-8b6d0fa16990	1.08	133.4	2.26	1.94	2026-04-26 13:17:54.460292	1911
89e3921f-88ff-4fa8-9092-9e3260a671eb	0.58	239.89	3.89	2.69	2026-04-26 13:17:54.460292	1912
22899238-2cb3-4920-ad5f-d00408f74869	2.11	179.3	1.47	1.75	2026-04-26 13:17:54.460292	1913
69b47d8f-7fea-4be2-b860-28261bd322a8	1.68	139.07	2.12	2.79	2026-04-26 13:17:54.460292	1914
ed04eb26-1f11-4e73-bf37-9045f051da24	1.23	158.07	2.57	1.5	2026-04-26 13:17:54.460292	1915
82b0280e-102f-4227-8bdc-035191a662da	1.71	170.5	1.13	2.23	2026-04-26 13:17:54.460292	1916
fc3455ee-1aca-499b-a15a-59daa28c0dae	1.43	130.53	3.99	2.29	2026-04-26 13:17:54.460292	1917
73844c9a-3cfa-47e8-a779-2fd0f85cd1a4	3.09	296.64	2.64	2.65	2026-04-26 13:17:54.460292	1918
1395deb5-7679-416b-8a65-aaf8e835d7c3	1.26	259.33	3.63	2.57	2026-04-26 13:17:54.460292	1919
6b95825f-39e7-468c-9658-f24c248a95ab	1.28	106.43	1.29	1.86	2026-04-26 13:17:54.460292	1920
ce7492b2-e891-474e-a19c-33b127c341bd	0.81	253.39	2.34	1.07	2026-04-26 13:17:54.460292	1921
29b851bc-bf09-44a9-8b92-fd986cecff07	3.11	244.79	1.07	1.18	2026-04-26 13:17:54.460292	1922
18bd7af5-1bd8-4924-b5c8-04e122688eb3	2.96	138.25	2.17	1.46	2026-04-26 13:17:54.460292	1923
0901b3ca-de69-4dc6-8669-6257957ae39e	1.85	158.09	1.12	2.48	2026-04-26 13:17:54.460292	1924
ecb61af6-0fbb-4eb0-bea9-b8c9f2fb8c69	1.98	212.89	3.89	1.97	2026-04-26 13:17:54.460292	1925
fa086000-f37b-4715-a2af-e114d3776051	1.94	291.54	3.66	2	2026-04-26 13:17:54.460292	1926
0ebae568-62bd-4e44-9ff7-798a7cf02baa	1.43	106.48	3.47	2.68	2026-04-26 13:17:54.460292	1927
8c5171fd-392e-49b3-9c7a-cac95ad4b712	3.05	118.33	1.11	1.4	2026-04-26 13:17:54.460292	1928
00b72f94-9185-4684-b9c9-7391caff4082	0.84	150.92	3.25	1.89	2026-04-26 13:17:54.460292	1929
4108c416-a720-408e-b90c-c674d5e86d0c	0.66	140.17	1.94	1.96	2026-04-26 13:17:54.460292	1930
da38da3e-9316-49d8-af58-cfca2be2ecea	0.67	111.86	2.67	1.91	2026-04-26 13:17:55.242402	1931
8d34dd99-e669-4ca7-99af-1d91991a09c9	1.33	232.3	2.13	2.12	2026-04-26 13:17:55.242402	1932
8d34dd99-e669-4ca7-99af-1d91991a09c9	1.33	232.3	2.13	2.12	2026-04-26 13:17:55.242402	1933
db738178-6c85-4003-814c-43efae201f66	2.62	54.07	1.89	2.63	2026-04-26 13:17:55.242402	1934
db738178-6c85-4003-814c-43efae201f66	2.62	54.07	1.89	2.63	2026-04-26 13:17:55.242402	1935
083b503f-bc9a-4761-9232-985118e3bde4	2.53	65.74	2.94	2.14	2026-04-26 13:17:56.262144	1936
84898f92-b30c-4251-99c5-6d4b8ee07428	3.45	272	2.22	1.4	2026-04-26 13:17:56.262144	1937
1798c0d0-79e4-4d2b-9f3f-990b125d2105	1.07	120.77	3.71	2.78	2026-04-26 13:17:56.262144	1938
d4454c95-37c1-4467-a22e-9fb7abac08a2	1.39	112.27	3.06	1.54	2026-04-26 13:17:56.262144	1939
1dc79f19-741d-4d47-8552-5e53debeed00	1.7	204.55	3.13	3	2026-04-26 13:17:56.262144	1940
127074f4-ef1e-44c6-b9d4-6e159522fe6d	0.75	54.88	2.03	1.68	2026-04-26 13:17:56.262144	1941
933c3358-c4a9-4190-ba36-d320f41b28bd	1.58	56.29	1.41	2.63	2026-04-26 13:17:56.262144	1942
24c4b5e6-9375-4a3d-aa2e-8ecf73311e2a	2.56	245.29	2.34	2.7	2026-04-26 13:17:56.262144	1943
8459b204-828a-433c-946a-16940b23fe20	3.09	95.78	3.23	1.74	2026-04-26 13:17:56.262144	1944
6c67de4d-14df-473a-b5b7-234ca1892d36	2.15	110.8	1.06	1.49	2026-04-26 13:17:56.262144	1945
1a1da762-8b17-44fc-ab54-aacee70233c0	0.52	279.97	1.72	2.99	2026-04-26 13:17:56.262144	1946
eaf83308-161d-4cbe-9a8f-c87d75ee5421	2.92	91.3	1.53	2.41	2026-04-26 13:17:56.262144	1947
2639cd66-3527-4a6d-b26e-dfb2491c1bf2	2.29	231.77	2.12	1.3	2026-04-26 13:17:56.262144	1948
8d34dd99-e669-4ca7-99af-1d91991a09c9	2.29	213.3	3.97	1.07	2026-04-26 13:17:56.262144	1949
77398e9d-8c73-4cfb-9019-93696911c12d	2.23	92.62	3.58	2.49	2026-04-26 13:17:56.262144	1950
af79ed93-81e1-4dad-ab43-483f230ed7d4	2.37	159.55	3.02	1.07	2026-04-26 13:17:56.262144	1951
a09b5914-31d8-4628-bfde-a2ed4f60f907	3.39	94.72	1.46	1.49	2026-04-26 13:17:56.262144	1952
af5d64a0-8fd6-4135-9b5c-ed9a17afe722	1.72	64.16	1.27	1.53	2026-04-26 13:17:56.262144	1953
48f2ef4f-6f48-4a5a-8aca-e2844be19a4d	0.58	194.28	2.84	2.55	2026-04-26 13:17:56.262144	1954
c4a5295a-ac7e-4505-ae47-069a3a50ecec	3.4	239.36	2.22	1.07	2026-04-26 13:17:56.262144	1955
0cdc07b0-d122-4345-a871-ed8736125a13	0.64	73.35	2.78	1.96	2026-04-26 13:17:56.262144	1956
8be3185b-bc1c-4142-b567-48aaff220b01	2.74	78.85	3.24	1.32	2026-04-26 13:17:56.262144	1957
d9051e4d-d569-4f01-89e0-7d857762afe5	2.58	186.14	1.39	2.52	2026-04-26 13:17:56.262144	1958
3fad7c09-4ab3-4a8b-aa29-7211513f7237	2.2	105.69	1.76	2.85	2026-04-26 13:17:56.262144	1959
dbbf360e-7216-4601-8614-038fe1dcc2ba	1.6	236.18	3.82	2.56	2026-04-26 13:17:56.262144	1960
9bd9f3c5-1b49-4927-8cdf-35373636ae00	2.89	285.72	3.12	1.4	2026-04-26 13:17:56.262144	1961
160d3adf-6a5a-4442-8c35-f8ff730e0036	2.54	247.24	1.29	1.03	2026-04-26 13:17:56.262144	1962
5c42027f-8aaa-441b-990e-215c05fc0300	1.29	160.89	1.46	2.92	2026-04-26 13:17:56.262144	1963
bfc1d7fb-6dd6-42fd-a795-053bca272428	3.05	262.84	1.92	2.32	2026-04-26 13:17:56.262144	1964
fe19663b-26a2-40d0-a329-bf3f1f6a25a6	3.23	102.25	2.75	2.34	2026-04-26 13:17:56.262144	1965
09bcbc34-b01a-4878-88ae-4aac9ea91b2d	1.16	245.75	3.77	1.56	2026-04-26 13:17:56.262144	1966
28aa7be3-ebf0-4bfb-9e4d-8eb57e7a1a09	2.19	295.38	3.43	1.83	2026-04-26 13:17:56.262144	1967
a463568f-08c1-4eee-ba9f-87eca478959e	2.24	98.59	3.94	2.47	2026-04-26 13:17:56.262144	1968
e91e2255-deed-4ffc-9e86-da19ee4fe2be	1.88	97.66	2.72	2.23	2026-04-26 13:17:56.262144	1969
e6c3818b-29f0-4e36-9052-5e1482339405	3.07	60.46	3.82	1.89	2026-04-26 13:17:56.262144	1970
80d81f80-2426-4c17-9e8a-321da7361798	3.22	117.85	2.81	2.26	2026-04-26 13:17:56.262144	1971
6f817b31-ed87-46bb-9e2e-1140f4cb4cbb	2.66	124.62	1.75	1.92	2026-04-26 13:17:56.262144	1972
34c9e297-d7dc-4168-a5a5-8e7e148dcbbd	2.52	112.61	3.52	2.08	2026-04-26 13:17:56.262144	1973
06c52bbf-cbe5-4db7-997a-9f747283665e	1.75	150.69	2.45	1.71	2026-04-26 13:17:56.262144	1974
0404794e-0a50-4824-a0ee-921cb23888ee	3.11	117.09	3.67	1.26	2026-04-26 13:17:56.262144	1975
ff75e776-7227-4220-9f32-33a6013ae67f	3.49	64.3	3.35	1.6	2026-04-26 13:17:56.262144	1976
522e7eca-7dde-4bb5-9cfd-7bfc1f5aa823	3.34	182.34	3.23	1.53	2026-04-26 13:17:56.262144	1977
0670c059-cbff-4d6e-97fa-c2dbd81ba878	0.6	113.69	2.68	1.1	2026-04-26 13:17:56.262144	1978
41623b9e-303f-46b1-82d3-8883c4a479bb	0.5	128.68	2.98	1.69	2026-04-26 13:17:56.262144	1979
8425054a-27fe-45f7-a2d1-0ca5bb87c22d	2.92	114.65	3.11	1.45	2026-04-26 13:17:56.262144	1980
88f2dc8f-4748-490e-b92d-e31ba6ddaf7b	1.65	247.83	3.52	2.89	2026-04-26 13:17:56.262144	1981
71e03cf9-1c81-44c0-9c0f-63591e58aa30	2.51	200.93	1.6	2.74	2026-04-26 13:17:56.262144	1982
bc2f02a5-cb1e-4610-ac0e-ba7f24c18ccd	1.14	153.04	2.88	2.65	2026-04-26 13:17:56.262144	1983
c110010b-1088-4e02-be3c-83c511d7831c	2.87	219.04	2.42	2.03	2026-04-26 13:17:56.262144	1984
fe8407a5-d6f0-4b63-b0c1-71ad87ffab96	1.4	113.53	1.17	1.58	2026-04-26 13:17:56.262144	1985
19646a15-fc51-45ea-b837-9703ea5e5f8c	2.35	98.34	1.48	1.45	2026-04-26 13:17:56.262144	1986
048313b2-21ec-4fbc-be08-2f0c27fa77f6	1.38	245.73	1	2.91	2026-04-26 13:17:56.262144	1987
66ae13b0-bc41-401b-919a-a47c2d82b9ef	2.58	134.84	1.94	2.58	2026-04-26 13:17:56.262144	1988
d87f65c7-d638-4f26-a825-aff5ae57457b	0.77	196.39	3.01	1.46	2026-04-26 13:17:56.262144	1989
7931d397-9cb6-40aa-888c-6b1cfe481a74	0.77	80.97	2.31	2.41	2026-04-26 13:17:56.262144	1990
a63e2468-ff52-45a6-a5cd-59944a3859bb	3.47	89.29	3.13	2.05	2026-04-26 13:17:56.262144	1991
2c170f3c-70f5-4432-9675-baa82539a713	0.82	75.11	2.02	2.48	2026-04-26 13:17:56.262144	1992
a49a8d86-d915-4488-b843-de71b33e91fd	1.1	128.69	3.99	1.45	2026-04-26 13:17:56.262144	1993
b2cd1843-50e3-475c-b68b-24bcf035d14a	1.25	56.83	3.69	1.18	2026-04-26 13:17:56.262144	1994
49214cd6-15b3-43e2-b004-f11980bd76e7	0.95	112.39	2.59	1.9	2026-04-26 13:17:56.262144	1995
da38da3e-9316-49d8-af58-cfca2be2ecea	0.91	224.17	1.87	1.95	2026-04-26 13:17:56.262144	1996
06e503be-bdf4-4afe-9252-ad4307d77d34	2.35	141.35	2.01	2.19	2026-04-26 13:17:56.262144	1997
e07bf42f-e0df-4ae0-8b19-59673c872bf2	1.54	231.3	2.21	1.35	2026-04-26 13:17:56.262144	1998
d9ff0e43-523c-4157-b412-c6e488086313	0.99	262.78	1.65	2.09	2026-04-26 13:17:56.262144	1999
73605445-18c0-4c79-aa20-abe75a2aa504	3.5	150.9	2.89	2.48	2026-04-26 13:17:56.262144	2000
17d1d4a8-7fff-4e9d-be6b-1ad8cff6ebd6	2.61	140.68	2.25	2.07	2026-04-26 13:17:56.262144	2001
0ff59da4-ea9a-48c5-9b60-96f17e2644b7	3.22	259.73	1.75	1.1	2026-04-26 13:17:56.262144	2002
0c867821-28e1-489c-96ef-a33a16f96004	1.04	219.02	1.55	1.99	2026-04-26 13:17:56.262144	2003
6111d377-0b6c-4d93-b288-f7ebce6c00fc	3.09	210.11	3.02	2.81	2026-04-26 13:17:56.262144	2004
18905b39-d6a0-4f41-8c02-9b817e1b009d	2.71	209.89	2.82	1.9	2026-04-26 13:17:56.262144	2005
8b417aee-680e-4081-85f2-5a160fb2ff12	2.45	53.62	2.12	1.88	2026-04-26 13:17:56.262144	2006
38b482a7-1f32-4ddc-9349-bcf1da86d546	1	60.27	1.21	2.79	2026-04-26 13:17:56.262144	2007
02152a87-fd48-4156-bd2f-afe94c4dc7a6	1.71	116.58	3.59	1.23	2026-04-26 13:17:56.262144	2008
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.9	59.2	3.77	1.45	2026-04-26 13:17:56.262144	2009
79cd4a3f-adcf-4ce5-9d29-62693c93adf2	2.34	71.76	1.12	2.26	2026-04-26 13:17:56.262144	2010
c4391873-3533-4cad-977b-0323fced348e	1.91	213.86	3.89	1.28	2026-04-26 13:17:56.262144	2011
c6338c80-214f-405b-9b0b-7594bb69d230	0.88	276.39	2.7	1.02	2026-04-26 13:17:56.262144	2012
382f3f60-7d3c-4ffc-8b2f-94ce32b77254	0.63	124.09	3.85	2.47	2026-04-26 13:17:56.262144	2013
cf827a4b-a720-4825-84d4-29f047763f7e	2.79	81.89	2.82	1.25	2026-04-26 13:17:56.262144	2014
d5806c60-9752-4845-9128-964d9b723f0b	2.42	248.41	1.45	2.37	2026-04-26 13:17:56.262144	2015
96e0af22-02e2-46d4-8224-4db162bd27b6	1.75	189.87	1.15	1.32	2026-04-26 13:17:56.262144	2016
9d0c77f5-485a-477d-80ec-8da875eb9852	1.44	240.8	3.97	1.7	2026-04-26 13:17:56.262144	2017
c19c4f6a-3738-436e-b7dc-b27df3129b28	2.83	253.15	1.1	1.57	2026-04-26 13:17:56.262144	2018
2d78aa7b-b8fb-4cc0-9d8a-f6a927032041	3.36	263.07	3.16	2.28	2026-04-26 13:17:56.262144	2019
dbebf850-836f-4532-807c-c1e3f5b5d597	1.35	124.82	2.94	2.6	2026-04-26 13:17:56.262144	2020
453f03e0-cb8d-4681-b343-d681f27e84f8	3.32	260.33	1.3	1.63	2026-04-26 13:17:56.262144	2021
13d5f24a-3280-4db1-ae8d-4e7ac37dca9d	1.88	73.37	1.5	1.92	2026-04-26 13:17:56.262144	2022
40f8a8d7-327f-4f20-a15c-cbd9fb6f5e75	2.82	92.3	3.53	1.55	2026-04-26 13:17:56.262144	2023
8cfcaf67-4ae0-46c6-996e-6ce551b4096d	2.2	50.75	2.41	1.57	2026-04-26 13:17:56.262144	2024
05bb5c72-6613-4d45-a876-a6c5fb64222e	2.05	151.56	1.46	1.46	2026-04-26 13:17:56.262144	2025
37b80a41-5dec-4adb-ac19-126072ec4a13	1.15	110.22	3.68	1.25	2026-04-26 13:17:56.262144	2026
514c19e7-d8eb-4f8a-b58c-db01659e571e	2.82	251.66	2.62	1.05	2026-04-26 13:17:56.262144	2027
27ded357-dfee-45c6-844b-2108e05a105b	2.07	199.64	2.29	1.05	2026-04-26 13:17:56.262144	2028
affc16bb-f7a4-4ff2-90df-48caf7eebddc	2.89	289.78	3.74	1.32	2026-04-26 13:17:56.262144	2029
cb0fe3b7-fbc8-479b-bd12-6acfeeeeffeb	3.37	108.45	1.49	2.26	2026-04-26 13:17:56.262144	2030
c0f13516-b42b-4edf-8d54-260ed3432c91	1.22	219.66	1.21	2.15	2026-04-26 13:17:56.262144	2031
a6b3ffd9-c2dc-4bf3-872f-1d4dfaff44ce	1.34	112.92	1.81	1.66	2026-04-26 13:17:56.262144	2032
4c18584e-0e3e-40cc-94a4-dd6106965efb	1.79	297.87	1.05	1.57	2026-04-26 13:17:56.262144	2033
42be6f12-2662-427d-b3bb-9f8fb042cde5	1.33	200.58	1.55	2.98	2026-04-26 13:17:56.262144	2034
a9a3a5fa-5c98-4e69-883b-2afa82b1877f	2.2	229.3	1.51	1.54	2026-04-26 13:17:56.262144	2035
69ceb13d-c6ba-480a-9bb6-8c94350b80bb	2.42	282.49	3.07	1.96	2026-04-26 13:17:56.262144	2036
6946eb18-50ec-477c-808d-f71c98670e15	1.42	141.94	2.23	1.44	2026-04-26 13:17:56.262144	2037
db738178-6c85-4003-814c-43efae201f66	1.72	220.97	3.82	2.19	2026-04-26 13:17:56.262144	2038
4b5f92c9-7d51-4b0e-a137-acd779a460c0	3.39	235.25	2.93	1.1	2026-04-26 13:17:56.262144	2039
343b8afa-f5f3-413a-8faf-37c6af937323	1.47	293.79	2.73	1.98	2026-04-26 13:17:56.262144	2040
aa3eddc8-b910-47a9-b691-2ec377a4b6c3	2.25	109.52	1.22	2.07	2026-04-26 13:17:56.262144	2041
10412ce9-7326-4907-98fb-f30f329eb834	1.37	151.21	1.25	1.32	2026-04-26 13:17:56.262144	2042
a7a83b3b-4904-468d-b1ff-79250bae2178	1.09	158.22	2.25	1.11	2026-04-26 13:17:56.262144	2043
de64100b-0d55-4423-8139-e21bf67b1ba3	2.2	53.58	3.91	2.07	2026-04-26 13:17:56.262144	2044
48f1cae9-db76-406a-84c3-4b1d3fd1f646	3.07	57.26	2.72	2.81	2026-04-26 13:17:56.262144	2045
bff99142-a62f-4628-a6ff-c053c6deb013	2.02	150.52	1.12	2.58	2026-04-26 13:17:56.262144	2046
fb073968-3588-453a-85e2-75089d4c03f1	0.5	286.41	2.03	1.98	2026-04-26 13:17:56.262144	2047
377f4e07-93cb-4351-8c6b-62851338fdb0	3.09	123.16	3.78	1.95	2026-04-26 13:17:56.262144	2048
19bdfc5a-e1d0-463a-b163-7d7a692f73b8	1.96	212.17	1.05	1.4	2026-04-26 13:17:56.262144	2049
cbd20eb0-7239-4734-b82b-404600e7d66b	1.61	136.42	2.63	2.17	2026-04-26 13:17:56.262144	2050
18c3479d-2072-411f-8d91-9a580608c627	1.14	288.04	2.08	2.18	2026-04-26 13:17:56.262144	2051
ca09ced3-7738-4c9e-887f-d34312c3d8e4	3.09	117.04	2.47	1.99	2026-04-26 13:17:56.262144	2052
07a6b221-981a-4cce-bb5d-3d5a872c97b7	2.86	74.19	3.55	1.38	2026-04-26 13:17:56.262144	2053
fa753e0b-bcb9-41b7-9c82-6fccd2333db1	3.01	292.32	2.63	2.5	2026-04-26 13:17:56.262144	2054
100a7e1e-99f2-4b0d-8a9d-842a454a612f	1.69	50.41	3.65	2.51	2026-04-26 13:17:56.262144	2055
41bd264e-1eb3-4ccb-ab43-221d92913239	1.18	242.17	1.89	1.41	2026-04-26 13:17:56.262144	2056
b80e97e3-fe08-465e-ac72-eea64d2d6182	0.59	156.03	3.67	1.15	2026-04-26 13:17:56.262144	2057
ed596397-26d6-4d02-a2f1-dbbf5f8ab704	2.52	175.04	3.44	2.84	2026-04-26 13:17:56.262144	2058
5d36c463-e893-43a2-b567-1e7fbcb3c80c	2.93	287.03	3.68	2.8	2026-04-26 13:17:56.262144	2059
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	2.82	253.49	1.41	2.77	2026-04-26 13:17:56.262144	2060
b611f2f3-4dce-4565-9634-c5f67f16841f	2.6	85.13	1.4	1.18	2026-04-26 13:17:56.262144	2061
af16d415-a7a8-426f-8d38-2ade72d8acb5	1.6	63.67	1.84	1.91	2026-04-26 13:17:56.262144	2062
a18f9d90-4ce4-4793-a9c1-9452712601a3	1.95	183.97	2.49	2.78	2026-04-26 13:17:56.262144	2063
2421d8dc-3548-4b72-b606-b235ecdf5448	1.21	252.02	2.01	1.92	2026-04-26 13:17:56.262144	2064
bb6389a5-9e20-4135-8648-8a813bb296b7	1.05	267.69	3.19	2.49	2026-04-26 13:17:56.262144	2065
6447b600-e734-4067-87b1-b915998722b4	1.95	221.89	3.3	2.71	2026-04-26 13:17:56.262144	2066
a1fc9f0b-f1e6-4819-9cb5-1ce77541a1b5	2.66	93.78	2.88	2.24	2026-04-26 13:17:56.262144	2067
25df9dd3-d744-4a1e-a96b-d1322d6952f5	1.35	268.18	2.09	1.5	2026-04-26 13:17:56.262144	2068
8e3909e7-8ee5-4db8-9278-087d2851a6f1	2.93	247.22	3.91	1.2	2026-04-26 13:17:56.262144	2069
3fcc2af3-e524-4b65-9649-cc48a58b7463	1.37	192.02	3.09	2.16	2026-04-26 13:17:56.262144	2070
3045ab21-e78f-41cf-9f96-102cfd907777	2.27	282.99	1.48	2.64	2026-04-26 13:17:56.262144	2071
211e6d92-06f3-4968-ab18-4d3606fb0313	1.41	56.08	3.28	1.82	2026-04-26 13:17:56.262144	2072
577c5ceb-5d82-4a67-914e-cc3249432558	2.55	217.7	3.16	2.56	2026-04-26 13:17:56.262144	2073
a9955bda-fedb-44d9-b5a6-33b7ceff70cc	1.58	291.57	3.33	2.78	2026-04-26 13:17:56.262144	2074
cac6b96e-6c77-4c20-b201-5d059367fbf0	2.7	160.16	1.17	1.95	2026-04-26 13:17:56.262144	2075
40b83090-1da5-4f1a-85d6-884f75d306d9	2.55	93.31	3.88	1.31	2026-04-26 13:17:56.262144	2076
af6f8bce-ab49-4a79-a40c-4a4aba8d8552	1.02	77.5	2.27	1.43	2026-04-26 13:17:56.262144	2077
7674a04d-8f67-4d07-9eab-998e344a03c9	0.82	126.41	3.15	1.67	2026-04-26 13:17:56.262144	2078
f97b5670-ef68-4a86-97c0-6385e6ae7405	0.71	50.43	2.51	1.7	2026-04-26 13:17:56.262144	2079
4fc26046-1ae2-4e60-99cf-95ef8ee6524a	2.12	198.17	1.23	2.14	2026-04-26 13:17:56.262144	2080
e332ef09-be23-4a9d-b003-f886bfae870d	1.13	182.36	1.19	2.83	2026-04-26 13:17:56.262144	2081
88f0fd74-5fbe-402b-b1f9-8b0185f9b042	3.38	59.93	2.75	1.45	2026-04-26 13:17:56.262144	2082
7289ae0e-9605-4d46-aaee-5b05ddd96e59	0.73	238.64	3.09	1.98	2026-04-26 13:17:56.262144	2083
b0318b61-a090-47a1-a30e-1f29ba099262	3.06	280.55	1.63	2.71	2026-04-26 13:17:56.262144	2084
26ec3ee2-f140-4f43-b13b-9299796dd2d1	3.15	201.23	1.05	2.85	2026-04-26 13:17:56.262144	2085
9dab24c7-177d-4ec4-8c0b-2323b92d3d4a	2.03	282.86	3.65	2.77	2026-04-26 13:17:56.262144	2086
1a6d5e85-787b-461f-8db7-9cd8f8d81ece	2.32	208.13	3.15	1.66	2026-04-26 13:17:56.262144	2087
27b23042-92c6-4a49-b397-6c200041d8ee	3.09	269.6	2.23	2.01	2026-04-26 13:17:56.262144	2088
08f0acf7-18ec-45eb-8146-8042969d5c7a	2.08	175.94	2.57	1.65	2026-04-26 13:17:56.262144	2089
a03af7ca-2046-499e-b19d-b6571e696f89	3.38	233.65	3.23	2.84	2026-04-26 13:17:56.262144	2090
e7fd011f-5572-4ee9-a3de-2d9d4d5c818d	3.46	140.9	1.26	2.51	2026-04-26 13:17:56.262144	2091
4065ab51-f74f-42a2-9363-7146df43c932	1.74	78.64	2.32	1.11	2026-04-26 13:17:56.262144	2092
a07f2ed2-35ae-4720-ad65-a22fe59566d3	2.39	58.69	1.83	2.69	2026-04-26 13:17:56.262144	2093
02c4237f-a7f5-452b-82c3-1fe296af3c3c	2.28	265.52	3.25	1.28	2026-04-26 13:17:56.262144	2094
62b7cf0d-cf31-493a-85aa-8fa347acda25	3	188.08	3.56	1.64	2026-04-26 13:17:56.262144	2095
ab3db038-d69b-451e-bba3-08e8119898b4	2.1	288.28	3.67	1.2	2026-04-26 13:17:56.262144	2096
b685932b-8a27-4288-8795-f6e05e9e4cef	2.25	167.97	1.91	2.91	2026-04-26 13:17:56.262144	2097
9cd7e4f4-8d1a-48da-abbc-075218e9e7a6	1.21	218.9	1.23	2.84	2026-04-26 13:17:56.262144	2098
98d2ddcf-4cfa-4405-9501-d661884b1017	1	90.36	1.47	1.7	2026-04-26 13:17:56.262144	2099
d0655207-0783-4e94-98d2-176fe26849d8	2.5	67.74	2.83	2.09	2026-04-26 13:17:56.262144	2100
bcad4d42-8a4f-4b72-a2e1-b607651d5c31	3.41	262.81	2.79	1.66	2026-04-26 13:17:56.262144	2101
9ed4929a-d3c0-4954-b272-227a89cbedec	3.22	262.58	1.56	2.64	2026-04-26 13:17:56.262144	2102
edcb7d15-e6ed-461f-b1b4-38a993ff2ec7	1.24	160.45	3.77	2.86	2026-04-26 13:17:56.262144	2103
2f5d7c02-eadd-4eb2-8dd5-46a5ba51c3f8	3.19	103.89	3.04	2.95	2026-04-26 13:17:56.262144	2104
0ad0a6eb-d13c-440c-b74c-0391605d9685	0.98	277.87	2.42	1.71	2026-04-26 13:17:56.262144	2105
2bb8c959-19b6-4951-8313-e6d0413c9a6f	0.53	232.09	1.17	2.23	2026-04-26 13:17:56.262144	2106
303a312c-4f87-408c-b20b-03d848ec9055	0.57	214.42	1.14	2.63	2026-04-26 13:17:56.262144	2107
a32bfdcd-5dd9-4a93-85e7-c1e608df83ee	1.08	73.45	3.88	2.99	2026-04-26 13:17:56.262144	2108
5ccc6390-43ca-49f5-b6fa-84247d3e52af	2.34	154.52	3.12	2.57	2026-04-26 13:17:56.262144	2109
df299e49-61f2-49ce-8051-e50cfc0b2650	1.94	138.46	2.5	2.62	2026-04-26 13:17:56.262144	2110
86ef6ade-b308-467a-8c42-3c6e4c20ec8d	1.06	296.65	3.95	1.89	2026-04-26 13:17:56.262144	2111
e318d53f-7605-468a-b41d-051070be96a3	1.8	229.8	2.85	2.28	2026-04-26 13:17:56.262144	2112
efc0c233-0113-480b-b3e6-ca3275b5ffde	2.77	110.96	1.97	2.13	2026-04-26 13:17:56.262144	2113
5808ae27-83d1-4163-9187-6a23f988dc97	0.98	195.57	3.67	1.77	2026-04-26 13:17:56.262144	2114
e304e2e6-fd72-4399-b4d7-fb6416b81f0c	1.6	151.79	3.99	1.92	2026-04-26 13:17:56.262144	2115
678ae26f-569d-4c0e-b4a9-0a688fc0936a	0.81	93.86	3.79	2.39	2026-04-26 13:17:56.262144	2116
6438657c-ee67-48b5-8de0-62eeb64e0a87	1.58	283.7	3.75	2.43	2026-04-26 13:17:56.262144	2117
e3216b17-e320-4d0f-ada0-b93e60caca02	3.06	63.51	2.4	2.44	2026-04-26 13:17:56.262144	2118
63188d13-0344-4b51-aa79-19ea416c8cdd	2.74	252.44	2.53	2.67	2026-04-26 13:17:56.262144	2119
17932bb9-836e-4db9-b27e-bd1b2f574954	2.66	294.57	1.23	1.52	2026-04-26 13:17:56.262144	2120
459418c3-7fb1-4dd5-9c2b-6a0eb1e128a7	3.34	190.33	3.84	1.62	2026-04-26 13:17:56.262144	2121
4d88229f-55e4-476b-bfc0-096795c485e4	2.07	50.84	1.85	1.04	2026-04-26 13:17:56.262144	2122
2ce612e7-1b0e-4a98-aab2-d00e087e7acd	1.6	154.84	3.63	1.04	2026-04-26 13:17:56.262144	2123
f1c04ba0-d43a-4055-8726-0674ce5a9591	2.86	276.4	3.13	1.75	2026-04-26 13:17:56.262144	2124
b4617646-5ec4-4d15-a573-c29cffb7c27f	1.95	250.21	2.32	2.07	2026-04-26 13:17:56.262144	2125
c02600b3-e48e-4409-95a3-eb683e336b10	0.66	176.93	2.38	2.21	2026-04-26 13:17:56.262144	2126
fc365d4b-670e-4fca-8c15-bed27e9c7c64	1.93	164.95	1.86	1.75	2026-04-26 13:17:56.262144	2127
b5bfff34-218c-48cd-b9ce-673eea91bda1	2.72	207.55	3.32	1.52	2026-04-26 13:17:56.262144	2128
0ef3d984-2e82-4672-bcd6-c49dfd8397b3	2.42	131.6	1.79	2.87	2026-04-26 13:17:56.262144	2129
869589e4-a12e-4a97-9558-0e078bfadd07	0.73	223.82	3.87	2.5	2026-04-26 13:17:56.262144	2130
fc37eb73-af1d-4f66-ab8d-ac6cd664ceea	0.79	92.2	2.85	1.2	2026-04-26 13:17:56.262144	2131
f182189b-b6e2-4aee-bb22-5b1e555815b6	3.32	167.25	1.63	2.24	2026-04-26 13:17:56.262144	2132
4a03155b-1956-495a-aa04-f02a9c3d31c8	1.11	263.63	3.5	1.22	2026-04-26 13:17:56.262144	2133
6b9cb1d4-e93d-40cb-8099-44f30eae119b	1.92	237.41	2.84	1.83	2026-04-26 13:17:56.262144	2134
77c9a885-1040-44e4-8b7c-18dccb3b1a81	3.36	297.63	3.42	1.5	2026-04-26 13:17:56.262144	2135
ab089221-71a5-4b3c-a06e-445f999eed0a	2.87	61.38	3.84	2.28	2026-04-26 13:17:56.262144	2136
2954b16d-0db5-4232-8923-ca1c2a81be0a	2.22	123.92	3.78	2.31	2026-04-26 13:17:56.262144	2137
e072183d-f51e-4965-a227-e111304e8104	0.65	79.7	2.94	2.97	2026-04-26 13:17:56.262144	2138
d59dcfa3-ec8d-4789-81cd-22e13a9c829c	2.56	69.31	3.13	1.78	2026-04-26 13:17:56.262144	2139
e32ad455-b5bd-49ef-b295-f81c8a11da16	2.2	236.42	3.42	2.65	2026-04-26 13:17:56.262144	2140
21d6e120-8fa3-4a51-9ade-436c7d77e075	2.18	51.32	2.69	1.39	2026-04-26 13:17:56.262144	2141
efff145d-5625-4a2c-ac23-ffdccad3e85b	1.78	162.31	1.79	2.07	2026-04-26 13:17:56.262144	2142
1a64a717-44a3-4308-9eaa-d6a37163544c	3.01	206.67	1.14	2.78	2026-04-26 13:17:56.262144	2143
474c6490-57e2-4c5c-ad69-dc1c4cf6b1f5	1.31	134.03	2.7	2.97	2026-04-26 13:17:56.262144	2144
7f85773c-30b2-4ff2-877a-93f568213806	1.21	165.77	3.59	2.21	2026-04-26 13:17:56.262144	2145
4d87ace7-e3ee-4ea4-92f6-c395ef501428	2.56	238.95	1.23	2.68	2026-04-26 13:17:56.262144	2146
4d289278-e3f8-42ed-af6a-2d3259072f3f	3.15	234.47	3.88	1.29	2026-04-26 13:17:56.262144	2147
ebffe864-14eb-465e-b745-192f6e5717bf	1.68	242.38	2.73	2.95	2026-04-26 13:17:56.262144	2148
fb9a49ca-e5e2-4be1-9e2c-5d77c4db770b	1.45	218.09	3.14	1.44	2026-04-26 13:17:56.262144	2149
150f7991-fbd0-429e-bdf9-c60b50b1aae6	1.58	261.18	3.68	2.67	2026-04-26 13:17:56.262144	2150
569b5e54-a5e6-442c-94e0-64a8245dcd07	3.09	227.55	1.07	1.04	2026-04-26 13:17:56.262144	2151
1525c80d-cf06-4108-bab9-0205f6ed78f7	0.73	279.85	3.02	1.46	2026-04-26 13:17:56.262144	2152
c6e7314c-8525-4191-80c2-2c3a921f415d	2.99	104.81	2.12	2.7	2026-04-26 13:17:56.262144	2153
01d04063-d9c3-43b8-9cd1-f2c365206958	2.72	169.83	1.78	1.14	2026-04-26 13:17:56.262144	2154
688a8c3f-fa38-4308-89d5-212d6faf8a77	1.75	246.53	3.8	1.87	2026-04-26 13:17:56.262144	2155
80f0e0e1-a56b-4969-9328-300dd7d3889e	3.04	236.2	2.7	1.34	2026-04-26 13:17:56.262144	2156
bf4c1fb6-a269-4569-be90-6b6a998ee7b9	3.42	82	1.31	2.9	2026-04-26 13:17:56.262144	2157
4421a7a4-be54-4494-b732-9068a725e9b7	1.33	283.75	2.81	2.87	2026-04-26 13:17:56.262144	2158
5d9bfdd7-0a23-41a4-bff6-1d1b588e6b78	3.45	261.6	3.41	2.09	2026-04-26 13:17:56.262144	2159
9272aa0e-60be-48a7-b1a9-e260a3fcd3d2	3.26	223.35	3	2.68	2026-04-26 13:17:56.262144	2160
cd6c4c38-b00a-4644-b1a1-7fc4b8c0ef46	2.49	207.5	2.52	2.26	2026-04-26 13:17:56.262144	2161
903c34b0-9809-44ee-af0c-97ca045cde31	2.73	116.51	1.48	2.93	2026-04-26 13:17:56.262144	2162
ec564929-5d5d-4964-85c9-c2c00181550b	2.31	178.8	2.16	1.21	2026-04-26 13:17:56.262144	2163
eb5b0417-51b7-4630-89a7-fbac16715f99	2.04	77.23	1.95	1.23	2026-04-26 13:17:56.262144	2164
2f71377b-f84e-4d62-a2dd-610ad858eff9	0.55	240.33	1.48	2.71	2026-04-26 13:17:56.262144	2165
ccefa4d3-0ac6-49b4-b548-44dbecf95314	2.88	275.59	3.84	2.43	2026-04-26 13:17:56.262144	2166
641085c9-c0f6-4e22-ba3b-1fb94f36d101	0.53	195.34	3.3	1.35	2026-04-26 13:17:56.262144	2167
98771193-9965-407f-9a85-7fede6b77203	0.51	109.48	3.76	2.43	2026-04-26 13:17:56.262144	2168
a4f48f59-b6eb-49b5-bda3-c4cbe0959ccc	1.9	257.93	1.58	2.07	2026-04-26 13:17:56.262144	2169
349fd483-5e87-4860-902e-0499901d0595	2.84	112.9	3.18	1.76	2026-04-26 13:17:56.262144	2170
9c9909c7-05a2-4227-acf9-28521c0da135	1.71	274.99	2.8	2.97	2026-04-26 13:17:56.262144	2171
f305ad8e-b6cd-4ccb-8d44-e33845a294a1	1	230.76	2.68	2.98	2026-04-26 13:17:56.262144	2172
baa2883c-e58b-4231-a08f-44235a4dea80	0.67	202.35	1.29	2.66	2026-04-26 13:17:56.262144	2173
0d8f1e65-863d-45d8-bd85-f7a7bb2a19d6	2.56	136.9	3.04	1.28	2026-04-26 13:17:56.262144	2174
1274b8fd-1c04-42fe-ae89-7ee5494a8909	1.08	181.3	1.49	1.12	2026-04-26 13:17:56.262144	2175
177aba49-3dfa-4284-870d-fb28b84d4534	0.82	289.99	2.26	2.48	2026-04-26 13:17:56.262144	2176
a3e55969-7679-400e-b2f8-63e2955e54c2	1.69	184.25	2.82	1.34	2026-04-26 13:17:56.262144	2177
ccea675a-ef56-4f85-b8c5-317c8ce5a850	0.54	207.53	1.64	2.7	2026-04-26 13:17:56.262144	2178
3aa10c1e-2460-4377-b65a-f47990cf20a4	3.23	128.59	3.24	1.43	2026-04-26 13:17:56.262144	2179
95049103-faa4-4e21-9165-033861d9c488	1.01	175.95	3.8	1.22	2026-04-26 13:17:56.262144	2180
2c47bb0c-f0bc-43ef-97b7-ec4d8c96c29f	1.49	109.46	2.43	2.72	2026-04-26 13:17:56.262144	2181
c1b55a4f-d015-496a-97a5-0eda929e3dc3	0.77	137.93	1.65	1.01	2026-04-26 13:17:56.262144	2182
b8174b2e-1cb1-472c-ac48-c2a6912e48de	1.02	251.67	3.6	2.77	2026-04-26 13:17:56.262144	2183
ef342171-814f-4d88-ba4b-9c3e820c63de	2.27	264.83	3.28	1.31	2026-04-26 13:17:56.262144	2184
ff142781-a79f-4ff4-a703-7732aa9af9e3	2.57	59.89	3.95	2.21	2026-04-26 13:17:56.262144	2185
53988c3d-02b2-4be9-95b5-739ffb19f562	3.22	108.41	1.52	2.99	2026-04-26 13:17:56.262144	2186
90e0676d-9543-455e-b95b-033a3dc29094	3.42	293.54	3.48	2.22	2026-04-26 13:17:56.262144	2187
aa53d45e-4f36-4897-b499-3ed698190647	2.5	244.95	3.07	2.19	2026-04-26 13:17:56.262144	2188
0d2cac97-cb24-4e98-8c0f-4356b3e97f0a	0.59	77.48	3.28	1.74	2026-04-26 13:17:56.262144	2189
3781bb39-94d7-41ab-bddb-e6008d65fc3e	2.64	89.8	2.52	2.96	2026-04-26 13:17:56.262144	2190
9c7b719e-b70f-4394-9ff1-ed98e6b5cc58	2.07	65.46	1.8	1.53	2026-04-26 13:17:56.262144	2191
e7450082-184d-42e5-9e10-1ba889b81e15	3.25	279.42	3.87	1.87	2026-04-26 13:17:56.262144	2192
7f8cdea0-97fa-4f5c-a07d-339312618900	1.49	153.02	3.64	2.22	2026-04-26 13:17:56.262144	2193
1cdd7dbf-0fb2-4741-b2ce-1648f6588f83	1.82	128.98	2.44	1.44	2026-04-26 13:17:56.262144	2194
addb0a76-380c-4a6e-81a0-5642a291744d	1.37	158.75	2.72	2.56	2026-04-26 13:17:56.262144	2195
37353a0a-b1de-4f16-ade8-742e357bff71	2.5	211.66	1.28	1.54	2026-04-26 13:17:56.262144	2196
d806cbd2-e0cc-4e83-84a5-7e939ebd4b95	1.39	204.03	1.99	2.42	2026-04-26 13:17:56.262144	2197
84970f72-5d25-45d2-96d7-3ed2f3315168	1.79	175.99	3.82	2.88	2026-04-26 13:17:56.262144	2198
80fbbed9-4a78-4bd2-87e9-af704fc2de31	2.03	171.76	1.53	2.06	2026-04-26 13:17:56.262144	2199
8a2c8802-0ed7-4c68-b865-2b6b9b4e467b	0.8	170.92	2.12	1.85	2026-04-26 13:17:56.262144	2200
92491d57-33b8-476b-b82f-4d782b7925be	2.97	223.71	2.97	2.33	2026-04-26 13:17:56.262144	2201
101a0017-9d06-4cab-9376-10fca55b80fe	0.62	87.01	1.59	1.97	2026-04-26 13:17:56.262144	2202
7a670221-9a34-46e2-b81b-1d7085b29ac8	0.65	216.75	1.44	1.5	2026-04-26 13:17:56.262144	2203
b486f1ad-7297-436a-929a-3696998a7284	1.18	231.5	3.86	1.74	2026-04-26 13:17:56.262144	2204
ef7e5768-abc3-451c-8700-eadd22e0526f	2.34	183.89	3.99	2.75	2026-04-26 13:17:56.262144	2205
63993198-0f2e-4909-b4ec-c6e6b29c10e1	0.75	172.69	3.21	1.99	2026-04-26 13:17:56.262144	2206
785054cb-4641-468e-b119-e344676aba22	2.36	68.51	3	1.71	2026-04-26 13:17:56.262144	2207
2641930a-9a92-4a93-a28c-017fc48fc1b3	2.6	153.26	1.13	1.47	2026-04-26 13:17:56.262144	2208
4a2d3659-552c-4773-9281-2b75e2ba4bb6	3.5	287.17	2.74	1.56	2026-04-26 13:17:56.262144	2209
78beb24a-058f-4cc9-864c-1d33949d4818	0.99	209.08	3.1	2.42	2026-04-26 13:17:56.262144	2210
0889297c-d685-4c5d-bfc9-bba36110c15d	0.98	252.86	2.44	1.92	2026-04-26 13:17:56.262144	2211
acef61e7-7f4b-4b30-b6c5-425f9e36a90e	2.46	272.55	1.53	1.65	2026-04-26 13:17:56.262144	2212
186f60d6-c7c7-467f-b4fe-fa7636f79a23	0.9	82.82	1.22	2.51	2026-04-26 13:17:56.262144	2213
4079e5e0-9e84-4432-b44a-32af8e59d4b6	2.12	136.2	1.06	2.01	2026-04-26 13:17:56.262144	2214
29a4907b-3872-4537-b4c9-a42ef3e28b0e	2.51	218.62	2.65	1.38	2026-04-26 13:17:56.262144	2215
0881dc31-d7be-4ddb-99c9-8b6d0fa16990	3.03	240.73	1.17	2.03	2026-04-26 13:17:56.262144	2216
89e3921f-88ff-4fa8-9092-9e3260a671eb	0.6	237.97	2.06	1.7	2026-04-26 13:17:56.262144	2217
22899238-2cb3-4920-ad5f-d00408f74869	0.95	79.73	1.87	1.67	2026-04-26 13:17:56.262144	2218
69b47d8f-7fea-4be2-b860-28261bd322a8	1.49	74.29	3.81	2.29	2026-04-26 13:17:56.262144	2219
ed04eb26-1f11-4e73-bf37-9045f051da24	1.04	183.91	2.8	1.26	2026-04-26 13:17:56.262144	2220
82b0280e-102f-4227-8bdc-035191a662da	2.79	217.06	3.32	1.62	2026-04-26 13:17:56.262144	2221
fc3455ee-1aca-499b-a15a-59daa28c0dae	1.89	147.89	3.13	2.77	2026-04-26 13:17:56.262144	2222
73844c9a-3cfa-47e8-a779-2fd0f85cd1a4	2.01	64.49	1.91	1.14	2026-04-26 13:17:56.262144	2223
1395deb5-7679-416b-8a65-aaf8e835d7c3	2.99	132.19	3.04	2.87	2026-04-26 13:17:56.262144	2224
6b95825f-39e7-468c-9658-f24c248a95ab	2.66	208.29	1.03	1.64	2026-04-26 13:17:56.262144	2225
ce7492b2-e891-474e-a19c-33b127c341bd	3.22	77.29	3.71	2.92	2026-04-26 13:17:56.262144	2226
29b851bc-bf09-44a9-8b92-fd986cecff07	2.44	257.17	2.36	3	2026-04-26 13:17:56.262144	2227
18bd7af5-1bd8-4924-b5c8-04e122688eb3	2.5	249.4	1.08	2.89	2026-04-26 13:17:56.262144	2228
0901b3ca-de69-4dc6-8669-6257957ae39e	3.13	103.14	3.77	2.55	2026-04-26 13:17:56.262144	2229
ecb61af6-0fbb-4eb0-bea9-b8c9f2fb8c69	1.27	118.17	3.85	1.84	2026-04-26 13:17:56.262144	2230
fa086000-f37b-4715-a2af-e114d3776051	0.55	282.22	1.52	2.12	2026-04-26 13:17:56.262144	2231
0ebae568-62bd-4e44-9ff7-798a7cf02baa	1.33	278.15	3.13	2.45	2026-04-26 13:17:56.262144	2232
8c5171fd-392e-49b3-9c7a-cac95ad4b712	2.79	171.27	2.57	1.34	2026-04-26 13:17:56.262144	2233
00b72f94-9185-4684-b9c9-7391caff4082	3.24	226.72	3.13	2.94	2026-04-26 13:17:56.262144	2234
4108c416-a720-408e-b90c-c674d5e86d0c	2.67	186.12	3.79	2.99	2026-04-26 13:17:56.262144	2235
d930d57f-4865-49e1-b97c-e8d38ea33778	2.35	109.32	2.16	1.64	2026-04-26 13:17:56.262144	2236
94ee1380-d4a5-45d7-aca4-98acc362d2ea	3.14	94.1	3.93	2.34	2026-04-26 13:17:56.262144	2237
fdc902c2-6087-4d6f-80c4-06dc3417dd09	2.22	232.18	1.8	2.1	2026-04-26 13:17:56.262144	2238
a8c53a76-9bd2-4da8-bcc2-507bf0391475	1.38	133.87	1.67	2.92	2026-04-26 13:17:56.262144	2239
ec48173e-93eb-43f2-986b-837f4d9ea0a3	2.51	91.11	1.44	1.14	2026-04-26 13:17:56.262144	2240
4cf14171-7f85-401b-a1ed-240a930297d6	2.39	250.01	1.32	1.61	2026-04-26 13:17:56.262144	2241
5e2c38bc-5335-4dcc-b5fd-60f7c7da1f1d	1.4	154.04	2.95	2.15	2026-04-26 13:17:56.262144	2242
6d78a687-8013-4ecd-8edc-b3eaf641d308	1.14	277.08	1.66	2.51	2026-04-26 13:17:56.262144	2243
b4db985f-3cb5-4e0b-8269-75c0205a4a76	0.62	239.64	3.77	2.39	2026-04-26 13:17:56.262144	2244
e740dd73-61ff-47b3-b096-021863c558ef	0.57	151.41	1.72	1.42	2026-04-26 13:17:56.262144	2245
211e6d92-06f3-4968-ab18-4d3606fb0313	1.41	56.08	3.28	1.82	2026-04-26 13:17:57.073887	2246
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.9	59.2	3.77	1.45	2026-04-26 13:17:57.073887	2247
db738178-6c85-4003-814c-43efae201f66	1.72	220.97	3.82	2.19	2026-04-26 13:17:57.073887	2248
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.9	59.2	3.77	1.45	2026-04-26 13:17:57.073887	2249
38b482a7-1f32-4ddc-9349-bcf1da86d546	1	60.27	1.21	2.79	2026-04-26 13:17:57.073887	2250
083b503f-bc9a-4761-9232-985118e3bde4	1.61	201.28	3.34	1.36	2026-04-26 13:17:58.092147	2251
84898f92-b30c-4251-99c5-6d4b8ee07428	2.93	265.74	1.48	2.7	2026-04-26 13:17:58.092147	2252
1798c0d0-79e4-4d2b-9f3f-990b125d2105	1.66	115.08	1.1	2.09	2026-04-26 13:17:58.092147	2253
d4454c95-37c1-4467-a22e-9fb7abac08a2	0.64	117.73	3.95	2.99	2026-04-26 13:17:58.092147	2254
1dc79f19-741d-4d47-8552-5e53debeed00	0.78	74.01	3.7	2.35	2026-04-26 13:17:58.092147	2255
127074f4-ef1e-44c6-b9d4-6e159522fe6d	1.03	274.51	2.64	2.71	2026-04-26 13:17:58.092147	2256
933c3358-c4a9-4190-ba36-d320f41b28bd	2.84	101.03	1.73	2.89	2026-04-26 13:17:58.092147	2257
24c4b5e6-9375-4a3d-aa2e-8ecf73311e2a	1.33	143.02	1.47	2.33	2026-04-26 13:17:58.092147	2258
8459b204-828a-433c-946a-16940b23fe20	2.78	262.01	3.65	1.46	2026-04-26 13:17:58.092147	2259
6c67de4d-14df-473a-b5b7-234ca1892d36	3.08	263.15	3.62	1.82	2026-04-26 13:17:58.092147	2260
1a1da762-8b17-44fc-ab54-aacee70233c0	2.8	155.77	2.11	1.07	2026-04-26 13:17:58.092147	2261
eaf83308-161d-4cbe-9a8f-c87d75ee5421	3.02	93.64	1.77	1.68	2026-04-26 13:17:58.092147	2262
2639cd66-3527-4a6d-b26e-dfb2491c1bf2	1.27	202.62	1.14	1.1	2026-04-26 13:17:58.092147	2263
8d34dd99-e669-4ca7-99af-1d91991a09c9	2.16	101.28	3.14	2.03	2026-04-26 13:17:58.092147	2264
77398e9d-8c73-4cfb-9019-93696911c12d	2.95	188.19	1.75	2.39	2026-04-26 13:17:58.092147	2265
af79ed93-81e1-4dad-ab43-483f230ed7d4	1.55	282.89	2.56	2.71	2026-04-26 13:17:58.092147	2266
a09b5914-31d8-4628-bfde-a2ed4f60f907	3.04	286.47	3.16	1.28	2026-04-26 13:17:58.092147	2267
af5d64a0-8fd6-4135-9b5c-ed9a17afe722	1.02	230.45	2.59	2.93	2026-04-26 13:17:58.092147	2268
48f2ef4f-6f48-4a5a-8aca-e2844be19a4d	2.02	157.32	3.03	2.42	2026-04-26 13:17:58.092147	2269
c4a5295a-ac7e-4505-ae47-069a3a50ecec	1.76	50.24	3.69	1.99	2026-04-26 13:17:58.092147	2270
0cdc07b0-d122-4345-a871-ed8736125a13	2.67	207.18	3.71	2.07	2026-04-26 13:17:58.092147	2271
8be3185b-bc1c-4142-b567-48aaff220b01	2.93	86.14	2.24	2.3	2026-04-26 13:17:58.092147	2272
d9051e4d-d569-4f01-89e0-7d857762afe5	1.35	220.2	1.49	1.54	2026-04-26 13:17:58.092147	2273
3fad7c09-4ab3-4a8b-aa29-7211513f7237	3	210.97	1.53	1.9	2026-04-26 13:17:58.092147	2274
dbbf360e-7216-4601-8614-038fe1dcc2ba	1.24	126.48	3.23	1.5	2026-04-26 13:17:58.092147	2275
9bd9f3c5-1b49-4927-8cdf-35373636ae00	1.96	54.75	1.96	1.66	2026-04-26 13:17:58.092147	2276
160d3adf-6a5a-4442-8c35-f8ff730e0036	1.05	167.56	2.21	2.55	2026-04-26 13:17:58.092147	2277
5c42027f-8aaa-441b-990e-215c05fc0300	2.38	131.76	3.68	2.16	2026-04-26 13:17:58.092147	2278
bfc1d7fb-6dd6-42fd-a795-053bca272428	2.48	274.81	2.7	2.39	2026-04-26 13:17:58.092147	2279
fe19663b-26a2-40d0-a329-bf3f1f6a25a6	3.19	54.03	2.95	1.17	2026-04-26 13:17:58.092147	2280
09bcbc34-b01a-4878-88ae-4aac9ea91b2d	1.91	241.26	2.22	2.25	2026-04-26 13:17:58.092147	2281
28aa7be3-ebf0-4bfb-9e4d-8eb57e7a1a09	1.78	60.83	3.24	2.94	2026-04-26 13:17:58.092147	2282
a463568f-08c1-4eee-ba9f-87eca478959e	2.89	295.74	3.01	2.06	2026-04-26 13:17:58.092147	2283
e91e2255-deed-4ffc-9e86-da19ee4fe2be	1.9	267.02	2.79	1.38	2026-04-26 13:17:58.092147	2284
e6c3818b-29f0-4e36-9052-5e1482339405	1.56	273.21	2.33	1.31	2026-04-26 13:17:58.092147	2285
80d81f80-2426-4c17-9e8a-321da7361798	2.89	291.49	2.75	2.46	2026-04-26 13:17:58.092147	2286
6f817b31-ed87-46bb-9e2e-1140f4cb4cbb	2.23	229.19	1.77	1.96	2026-04-26 13:17:58.092147	2287
34c9e297-d7dc-4168-a5a5-8e7e148dcbbd	2.87	216.85	2.14	1.77	2026-04-26 13:17:58.092147	2288
06c52bbf-cbe5-4db7-997a-9f747283665e	2.6	278.14	3.04	2.65	2026-04-26 13:17:58.092147	2289
0404794e-0a50-4824-a0ee-921cb23888ee	3.48	116.86	2.78	2.67	2026-04-26 13:17:58.092147	2290
ff75e776-7227-4220-9f32-33a6013ae67f	2.06	222.94	1.53	2.24	2026-04-26 13:17:58.092147	2291
522e7eca-7dde-4bb5-9cfd-7bfc1f5aa823	2.6	144.04	3.15	2.04	2026-04-26 13:17:58.092147	2292
0670c059-cbff-4d6e-97fa-c2dbd81ba878	3.18	237.73	2.21	2	2026-04-26 13:17:58.092147	2293
41623b9e-303f-46b1-82d3-8883c4a479bb	1.3	150.25	1.74	1.86	2026-04-26 13:17:58.092147	2294
8425054a-27fe-45f7-a2d1-0ca5bb87c22d	1.39	288.89	3.06	1.24	2026-04-26 13:17:58.092147	2295
88f2dc8f-4748-490e-b92d-e31ba6ddaf7b	0.63	67.49	1.34	2.22	2026-04-26 13:17:58.092147	2296
71e03cf9-1c81-44c0-9c0f-63591e58aa30	1.33	90.8	3.86	1.12	2026-04-26 13:17:58.092147	2297
bc2f02a5-cb1e-4610-ac0e-ba7f24c18ccd	1.31	128.14	2.86	1.35	2026-04-26 13:17:58.092147	2298
c110010b-1088-4e02-be3c-83c511d7831c	1.18	157.44	1.69	2.96	2026-04-26 13:17:58.092147	2299
fe8407a5-d6f0-4b63-b0c1-71ad87ffab96	1.73	152.66	2.88	1.53	2026-04-26 13:17:58.092147	2300
19646a15-fc51-45ea-b837-9703ea5e5f8c	2.44	193.49	2.79	1.01	2026-04-26 13:17:58.092147	2301
048313b2-21ec-4fbc-be08-2f0c27fa77f6	3.08	67.07	1.95	1.66	2026-04-26 13:17:58.092147	2302
66ae13b0-bc41-401b-919a-a47c2d82b9ef	3.39	168.82	2.66	1.24	2026-04-26 13:17:58.092147	2303
d87f65c7-d638-4f26-a825-aff5ae57457b	3.43	177.22	1.19	2.55	2026-04-26 13:17:58.092147	2304
7931d397-9cb6-40aa-888c-6b1cfe481a74	2.92	86.41	1.12	1.33	2026-04-26 13:17:58.092147	2305
a63e2468-ff52-45a6-a5cd-59944a3859bb	1.8	119.17	1.82	1.39	2026-04-26 13:17:58.092147	2306
2c170f3c-70f5-4432-9675-baa82539a713	3.15	296.03	3.73	2.65	2026-04-26 13:17:58.092147	2307
a49a8d86-d915-4488-b843-de71b33e91fd	1.77	276.58	3.64	2.91	2026-04-26 13:17:58.092147	2308
b2cd1843-50e3-475c-b68b-24bcf035d14a	2.12	194.59	2.19	1.73	2026-04-26 13:17:58.092147	2309
49214cd6-15b3-43e2-b004-f11980bd76e7	1.2	93.9	1.35	1.92	2026-04-26 13:17:58.092147	2310
da38da3e-9316-49d8-af58-cfca2be2ecea	2.38	122.92	2.28	2.84	2026-04-26 13:17:58.092147	2311
06e503be-bdf4-4afe-9252-ad4307d77d34	2.51	81.63	2.07	2.97	2026-04-26 13:17:58.092147	2312
e07bf42f-e0df-4ae0-8b19-59673c872bf2	1.92	256.9	2.66	2.08	2026-04-26 13:17:58.092147	2313
d9ff0e43-523c-4157-b412-c6e488086313	1.72	298.08	2.19	1.93	2026-04-26 13:17:58.092147	2314
73605445-18c0-4c79-aa20-abe75a2aa504	2.11	220.18	2.61	1.05	2026-04-26 13:17:58.092147	2315
17d1d4a8-7fff-4e9d-be6b-1ad8cff6ebd6	2.61	278.62	1.34	2.98	2026-04-26 13:17:58.092147	2316
0ff59da4-ea9a-48c5-9b60-96f17e2644b7	1.95	239.65	2.63	2.46	2026-04-26 13:17:58.092147	2317
0c867821-28e1-489c-96ef-a33a16f96004	0.78	72.2	1.53	1.63	2026-04-26 13:17:58.092147	2318
6111d377-0b6c-4d93-b288-f7ebce6c00fc	1.02	65.44	3.62	1.6	2026-04-26 13:17:58.092147	2319
18905b39-d6a0-4f41-8c02-9b817e1b009d	2.86	80.16	2.61	2.57	2026-04-26 13:17:58.092147	2320
8b417aee-680e-4081-85f2-5a160fb2ff12	2.94	213.91	1.13	1.8	2026-04-26 13:17:58.092147	2321
38b482a7-1f32-4ddc-9349-bcf1da86d546	1.6	129.66	3.91	1.52	2026-04-26 13:17:58.092147	2322
02152a87-fd48-4156-bd2f-afe94c4dc7a6	3.49	255.8	1.77	1.76	2026-04-26 13:17:58.092147	2323
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.88	201.11	2.23	1.87	2026-04-26 13:17:58.092147	2324
79cd4a3f-adcf-4ce5-9d29-62693c93adf2	0.95	157.48	1.37	2.36	2026-04-26 13:17:58.092147	2325
c4391873-3533-4cad-977b-0323fced348e	0.97	141.72	3.45	2.13	2026-04-26 13:17:58.092147	2326
c6338c80-214f-405b-9b0b-7594bb69d230	2.58	57.16	2.06	2.87	2026-04-26 13:17:58.092147	2327
382f3f60-7d3c-4ffc-8b2f-94ce32b77254	1.1	70.44	2.7	1.84	2026-04-26 13:17:58.092147	2328
cf827a4b-a720-4825-84d4-29f047763f7e	0.82	169.7	3.69	1.46	2026-04-26 13:17:58.092147	2329
d5806c60-9752-4845-9128-964d9b723f0b	1.42	144.89	3.06	1.37	2026-04-26 13:17:58.092147	2330
96e0af22-02e2-46d4-8224-4db162bd27b6	1.94	280.44	3.69	1.87	2026-04-26 13:17:58.092147	2331
9d0c77f5-485a-477d-80ec-8da875eb9852	2.31	149.55	3.7	2.16	2026-04-26 13:17:58.092147	2332
c19c4f6a-3738-436e-b7dc-b27df3129b28	0.88	164.83	1.43	1.19	2026-04-26 13:17:58.092147	2333
2d78aa7b-b8fb-4cc0-9d8a-f6a927032041	1.61	153.19	3.57	2.07	2026-04-26 13:17:58.092147	2334
dbebf850-836f-4532-807c-c1e3f5b5d597	3.17	249.46	2.57	2.41	2026-04-26 13:17:58.092147	2335
453f03e0-cb8d-4681-b343-d681f27e84f8	2.41	68.99	1.16	2.35	2026-04-26 13:17:58.092147	2336
13d5f24a-3280-4db1-ae8d-4e7ac37dca9d	2.86	116.2	2.17	1.16	2026-04-26 13:17:58.092147	2337
40f8a8d7-327f-4f20-a15c-cbd9fb6f5e75	2.07	73.26	2.49	2.14	2026-04-26 13:17:58.092147	2338
8cfcaf67-4ae0-46c6-996e-6ce551b4096d	2.56	270.36	1.27	2.2	2026-04-26 13:17:58.092147	2339
05bb5c72-6613-4d45-a876-a6c5fb64222e	3.18	183.25	1.62	2.48	2026-04-26 13:17:58.092147	2340
37b80a41-5dec-4adb-ac19-126072ec4a13	0.98	209.04	1.15	1.7	2026-04-26 13:17:58.092147	2341
514c19e7-d8eb-4f8a-b58c-db01659e571e	3.05	225.39	3.21	2.29	2026-04-26 13:17:58.092147	2342
27ded357-dfee-45c6-844b-2108e05a105b	2.9	89.2	3.22	2.34	2026-04-26 13:17:58.092147	2343
affc16bb-f7a4-4ff2-90df-48caf7eebddc	0.59	258.3	1.14	1.21	2026-04-26 13:17:58.092147	2344
cb0fe3b7-fbc8-479b-bd12-6acfeeeeffeb	2.48	278.15	3.37	1.66	2026-04-26 13:17:58.092147	2345
c0f13516-b42b-4edf-8d54-260ed3432c91	2.84	63.64	2.81	2.37	2026-04-26 13:17:58.092147	2346
a6b3ffd9-c2dc-4bf3-872f-1d4dfaff44ce	2.39	139.67	1.08	2.48	2026-04-26 13:17:58.092147	2347
4c18584e-0e3e-40cc-94a4-dd6106965efb	1.29	61.74	1.33	2.84	2026-04-26 13:17:58.092147	2348
42be6f12-2662-427d-b3bb-9f8fb042cde5	0.99	287.39	2.12	1.9	2026-04-26 13:17:58.092147	2349
a9a3a5fa-5c98-4e69-883b-2afa82b1877f	2.17	200.27	2.16	1.05	2026-04-26 13:17:58.092147	2350
69ceb13d-c6ba-480a-9bb6-8c94350b80bb	1.09	87.17	1.84	2.07	2026-04-26 13:17:58.092147	2351
6946eb18-50ec-477c-808d-f71c98670e15	2.99	125.22	3.42	1.93	2026-04-26 13:17:58.092147	2352
db738178-6c85-4003-814c-43efae201f66	0.76	110.29	2.61	1.85	2026-04-26 13:17:58.092147	2353
4b5f92c9-7d51-4b0e-a137-acd779a460c0	1.24	194.04	2.05	1.67	2026-04-26 13:17:58.092147	2354
343b8afa-f5f3-413a-8faf-37c6af937323	0.63	113.59	3.51	2.01	2026-04-26 13:17:58.092147	2355
aa3eddc8-b910-47a9-b691-2ec377a4b6c3	2.91	138.12	2.45	1.45	2026-04-26 13:17:58.092147	2356
10412ce9-7326-4907-98fb-f30f329eb834	0.69	244.38	1.92	1.83	2026-04-26 13:17:58.092147	2357
a7a83b3b-4904-468d-b1ff-79250bae2178	2.6	182.85	1.22	2.09	2026-04-26 13:17:58.092147	2358
de64100b-0d55-4423-8139-e21bf67b1ba3	2.92	263.83	1.91	2.38	2026-04-26 13:17:58.092147	2359
48f1cae9-db76-406a-84c3-4b1d3fd1f646	0.92	95	3.06	1.23	2026-04-26 13:17:58.092147	2360
bff99142-a62f-4628-a6ff-c053c6deb013	1.71	53.54	2.45	1.41	2026-04-26 13:17:58.092147	2361
fb073968-3588-453a-85e2-75089d4c03f1	1.16	86.89	1.52	1.24	2026-04-26 13:17:58.092147	2362
377f4e07-93cb-4351-8c6b-62851338fdb0	3.18	290.94	3.31	2.69	2026-04-26 13:17:58.092147	2363
19bdfc5a-e1d0-463a-b163-7d7a692f73b8	0.65	187.1	3	1.06	2026-04-26 13:17:58.092147	2364
cbd20eb0-7239-4734-b82b-404600e7d66b	2.03	128.44	3.69	1.19	2026-04-26 13:17:58.092147	2365
18c3479d-2072-411f-8d91-9a580608c627	2.99	263.79	3.46	2.63	2026-04-26 13:17:58.092147	2366
ca09ced3-7738-4c9e-887f-d34312c3d8e4	1.21	253.04	2.04	1.88	2026-04-26 13:17:58.092147	2367
07a6b221-981a-4cce-bb5d-3d5a872c97b7	0.76	181.07	1.91	2.49	2026-04-26 13:17:58.092147	2368
fa753e0b-bcb9-41b7-9c82-6fccd2333db1	1.27	201.75	1.88	2.07	2026-04-26 13:17:58.092147	2369
100a7e1e-99f2-4b0d-8a9d-842a454a612f	1.96	203.47	3.63	1.32	2026-04-26 13:17:58.092147	2370
41bd264e-1eb3-4ccb-ab43-221d92913239	2.57	98.4	2.98	1.04	2026-04-26 13:17:58.092147	2371
b80e97e3-fe08-465e-ac72-eea64d2d6182	3.42	138.49	1.86	2.21	2026-04-26 13:17:58.092147	2372
ed596397-26d6-4d02-a2f1-dbbf5f8ab704	0.92	161.67	2.89	1.4	2026-04-26 13:17:58.092147	2373
5d36c463-e893-43a2-b567-1e7fbcb3c80c	2.85	195.02	2.15	2.42	2026-04-26 13:17:58.092147	2374
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	1.75	168.68	1.7	2.37	2026-04-26 13:17:58.092147	2375
b611f2f3-4dce-4565-9634-c5f67f16841f	1.19	142.1	2.24	2.3	2026-04-26 13:17:58.092147	2376
af16d415-a7a8-426f-8d38-2ade72d8acb5	1.43	205.74	2.56	2.68	2026-04-26 13:17:58.092147	2377
a18f9d90-4ce4-4793-a9c1-9452712601a3	1.64	59.43	3.68	1.43	2026-04-26 13:17:58.092147	2378
2421d8dc-3548-4b72-b606-b235ecdf5448	1.64	138.19	1.01	1.19	2026-04-26 13:17:58.092147	2379
bb6389a5-9e20-4135-8648-8a813bb296b7	1.49	143.47	3.18	2.78	2026-04-26 13:17:58.092147	2380
6447b600-e734-4067-87b1-b915998722b4	1.97	249.98	2.55	1.77	2026-04-26 13:17:58.092147	2381
a1fc9f0b-f1e6-4819-9cb5-1ce77541a1b5	1.07	174.87	1.34	1.84	2026-04-26 13:17:58.092147	2382
25df9dd3-d744-4a1e-a96b-d1322d6952f5	3.4	224.76	3.22	2.34	2026-04-26 13:17:58.092147	2383
8e3909e7-8ee5-4db8-9278-087d2851a6f1	0.72	96.42	2.79	1.74	2026-04-26 13:17:58.092147	2384
3fcc2af3-e524-4b65-9649-cc48a58b7463	3.39	166.39	3.25	1.38	2026-04-26 13:17:58.092147	2385
3045ab21-e78f-41cf-9f96-102cfd907777	1.38	99.42	3.06	2.22	2026-04-26 13:17:58.092147	2386
211e6d92-06f3-4968-ab18-4d3606fb0313	3.46	90.64	1.07	1.68	2026-04-26 13:17:58.092147	2387
577c5ceb-5d82-4a67-914e-cc3249432558	2.34	53.54	2.52	1.22	2026-04-26 13:17:58.092147	2388
a9955bda-fedb-44d9-b5a6-33b7ceff70cc	3.25	236.11	2.46	2.27	2026-04-26 13:17:58.092147	2389
cac6b96e-6c77-4c20-b201-5d059367fbf0	2.79	145.61	1.97	1.38	2026-04-26 13:17:58.092147	2390
40b83090-1da5-4f1a-85d6-884f75d306d9	3.14	57.38	2.93	2.2	2026-04-26 13:17:58.092147	2391
af6f8bce-ab49-4a79-a40c-4a4aba8d8552	0.62	164.78	3.55	2.23	2026-04-26 13:17:58.092147	2392
7674a04d-8f67-4d07-9eab-998e344a03c9	3.42	213.62	3.94	1.15	2026-04-26 13:17:58.092147	2393
f97b5670-ef68-4a86-97c0-6385e6ae7405	2.27	215.82	3.69	2.8	2026-04-26 13:17:58.092147	2394
4fc26046-1ae2-4e60-99cf-95ef8ee6524a	2.27	272.96	1.72	1.79	2026-04-26 13:17:58.092147	2395
e332ef09-be23-4a9d-b003-f886bfae870d	0.55	189.38	3.89	2.9	2026-04-26 13:17:58.092147	2396
88f0fd74-5fbe-402b-b1f9-8b0185f9b042	1.88	139.95	1.27	1.19	2026-04-26 13:17:58.092147	2397
7289ae0e-9605-4d46-aaee-5b05ddd96e59	2.63	141.52	3.28	1.13	2026-04-26 13:17:58.092147	2398
b0318b61-a090-47a1-a30e-1f29ba099262	1.27	98.1	2.59	1.6	2026-04-26 13:17:58.092147	2399
26ec3ee2-f140-4f43-b13b-9299796dd2d1	2.4	133.71	2.48	1.34	2026-04-26 13:17:58.092147	2400
9dab24c7-177d-4ec4-8c0b-2323b92d3d4a	0.92	91.76	2.88	1.21	2026-04-26 13:17:58.092147	2401
1a6d5e85-787b-461f-8db7-9cd8f8d81ece	0.83	64.62	1.73	1.75	2026-04-26 13:17:58.092147	2402
27b23042-92c6-4a49-b397-6c200041d8ee	2.03	274.32	1.3	1.34	2026-04-26 13:17:58.092147	2403
08f0acf7-18ec-45eb-8146-8042969d5c7a	3.24	253.26	3.44	2.96	2026-04-26 13:17:58.092147	2404
a03af7ca-2046-499e-b19d-b6571e696f89	1.32	189.81	1.55	1.45	2026-04-26 13:17:58.092147	2405
e7fd011f-5572-4ee9-a3de-2d9d4d5c818d	1.34	119.69	1.53	1.14	2026-04-26 13:17:58.092147	2406
4065ab51-f74f-42a2-9363-7146df43c932	2.04	270	2.02	1.99	2026-04-26 13:17:58.092147	2407
a07f2ed2-35ae-4720-ad65-a22fe59566d3	3.08	262.52	3.4	2.23	2026-04-26 13:17:58.092147	2408
02c4237f-a7f5-452b-82c3-1fe296af3c3c	1.96	258.1	2.37	1.07	2026-04-26 13:17:58.092147	2409
62b7cf0d-cf31-493a-85aa-8fa347acda25	3.4	144.04	1.36	1.62	2026-04-26 13:17:58.092147	2410
ab3db038-d69b-451e-bba3-08e8119898b4	2.46	148.5	3.28	2.83	2026-04-26 13:17:58.092147	2411
b685932b-8a27-4288-8795-f6e05e9e4cef	2.79	199.06	2.21	2.88	2026-04-26 13:17:58.092147	2412
9cd7e4f4-8d1a-48da-abbc-075218e9e7a6	2.15	213.55	3.23	2.02	2026-04-26 13:17:58.092147	2413
98d2ddcf-4cfa-4405-9501-d661884b1017	0.87	217	1.86	1.91	2026-04-26 13:17:58.092147	2414
d0655207-0783-4e94-98d2-176fe26849d8	3.26	120.99	1.88	1.59	2026-04-26 13:17:58.092147	2415
bcad4d42-8a4f-4b72-a2e1-b607651d5c31	1.17	140	1.49	1.42	2026-04-26 13:17:58.092147	2416
9ed4929a-d3c0-4954-b272-227a89cbedec	0.93	163.44	3.95	2.14	2026-04-26 13:17:58.092147	2417
edcb7d15-e6ed-461f-b1b4-38a993ff2ec7	0.6	136.74	1.17	2.38	2026-04-26 13:17:58.092147	2418
2f5d7c02-eadd-4eb2-8dd5-46a5ba51c3f8	2.31	113.32	2.22	1.24	2026-04-26 13:17:58.092147	2419
0ad0a6eb-d13c-440c-b74c-0391605d9685	0.94	61.7	3.11	1.04	2026-04-26 13:17:58.092147	2420
2bb8c959-19b6-4951-8313-e6d0413c9a6f	0.61	264.28	2.05	1.9	2026-04-26 13:17:58.092147	2421
303a312c-4f87-408c-b20b-03d848ec9055	2.46	188.36	1.56	1.39	2026-04-26 13:17:58.092147	2422
a32bfdcd-5dd9-4a93-85e7-c1e608df83ee	3.23	95.02	3.24	1.35	2026-04-26 13:17:58.092147	2423
5ccc6390-43ca-49f5-b6fa-84247d3e52af	2.54	95.81	2.55	2.04	2026-04-26 13:17:58.092147	2424
df299e49-61f2-49ce-8051-e50cfc0b2650	0.63	68.42	2.77	1.57	2026-04-26 13:17:58.092147	2425
86ef6ade-b308-467a-8c42-3c6e4c20ec8d	1.01	240.32	3.27	1.76	2026-04-26 13:17:58.092147	2426
e318d53f-7605-468a-b41d-051070be96a3	2.31	70.93	1.44	1.96	2026-04-26 13:17:58.092147	2427
efc0c233-0113-480b-b3e6-ca3275b5ffde	2.1	179.9	2.19	2.63	2026-04-26 13:17:58.092147	2428
5808ae27-83d1-4163-9187-6a23f988dc97	2.77	102.34	1.92	1.23	2026-04-26 13:17:58.092147	2429
e304e2e6-fd72-4399-b4d7-fb6416b81f0c	3.16	202.85	1.77	2.24	2026-04-26 13:17:58.092147	2430
678ae26f-569d-4c0e-b4a9-0a688fc0936a	2.98	81.17	2	1.97	2026-04-26 13:17:58.092147	2431
6438657c-ee67-48b5-8de0-62eeb64e0a87	1.1	70.73	1.79	2.8	2026-04-26 13:17:58.092147	2432
e3216b17-e320-4d0f-ada0-b93e60caca02	0.67	159.78	1.86	2.39	2026-04-26 13:17:58.092147	2433
63188d13-0344-4b51-aa79-19ea416c8cdd	2.19	90.2	3.98	1.61	2026-04-26 13:17:58.092147	2434
17932bb9-836e-4db9-b27e-bd1b2f574954	2.48	99.53	2.01	2.65	2026-04-26 13:17:58.092147	2435
459418c3-7fb1-4dd5-9c2b-6a0eb1e128a7	1.1	68.72	3.85	1.7	2026-04-26 13:17:58.092147	2436
4d88229f-55e4-476b-bfc0-096795c485e4	1.93	173.51	3.81	1.8	2026-04-26 13:17:58.092147	2437
2ce612e7-1b0e-4a98-aab2-d00e087e7acd	2.55	298.14	1.67	2.88	2026-04-26 13:17:58.092147	2438
f1c04ba0-d43a-4055-8726-0674ce5a9591	2	115.95	1.18	1.78	2026-04-26 13:17:58.092147	2439
b4617646-5ec4-4d15-a573-c29cffb7c27f	2.25	93.84	1.25	2.57	2026-04-26 13:17:58.092147	2440
c02600b3-e48e-4409-95a3-eb683e336b10	2.72	112.5	1.42	1.06	2026-04-26 13:17:58.092147	2441
fc365d4b-670e-4fca-8c15-bed27e9c7c64	2.58	246.96	3.66	1.78	2026-04-26 13:17:58.092147	2442
b5bfff34-218c-48cd-b9ce-673eea91bda1	2.58	278.33	1.69	1.37	2026-04-26 13:17:58.092147	2443
0ef3d984-2e82-4672-bcd6-c49dfd8397b3	2.74	251.2	1.11	2.41	2026-04-26 13:17:58.092147	2444
869589e4-a12e-4a97-9558-0e078bfadd07	1.85	298.74	3.1	1.83	2026-04-26 13:17:58.092147	2445
fc37eb73-af1d-4f66-ab8d-ac6cd664ceea	1.71	243.4	1.98	1.46	2026-04-26 13:17:58.092147	2446
f182189b-b6e2-4aee-bb22-5b1e555815b6	2.17	60.29	1.36	1.92	2026-04-26 13:17:58.092147	2447
4a03155b-1956-495a-aa04-f02a9c3d31c8	3.42	291.24	2.43	2.41	2026-04-26 13:17:58.092147	2448
6b9cb1d4-e93d-40cb-8099-44f30eae119b	3.23	288.61	2.49	1.87	2026-04-26 13:17:58.092147	2449
77c9a885-1040-44e4-8b7c-18dccb3b1a81	1.45	260.75	1.69	1.3	2026-04-26 13:17:58.092147	2450
ab089221-71a5-4b3c-a06e-445f999eed0a	1.2	184.13	2.88	1.81	2026-04-26 13:17:58.092147	2451
2954b16d-0db5-4232-8923-ca1c2a81be0a	3.36	249.91	3.1	1.33	2026-04-26 13:17:58.092147	2452
e072183d-f51e-4965-a227-e111304e8104	2.18	251.17	3.07	2.03	2026-04-26 13:17:58.092147	2453
d59dcfa3-ec8d-4789-81cd-22e13a9c829c	1.96	158.54	3.13	1.61	2026-04-26 13:17:58.092147	2454
e32ad455-b5bd-49ef-b295-f81c8a11da16	2.4	152.78	3.87	1.17	2026-04-26 13:17:58.092147	2455
21d6e120-8fa3-4a51-9ade-436c7d77e075	2.1	286.95	3.44	2.73	2026-04-26 13:17:58.092147	2456
efff145d-5625-4a2c-ac23-ffdccad3e85b	1.04	157.38	1.76	1.27	2026-04-26 13:17:58.092147	2457
1a64a717-44a3-4308-9eaa-d6a37163544c	2.34	267.96	1.35	2.41	2026-04-26 13:17:58.092147	2458
474c6490-57e2-4c5c-ad69-dc1c4cf6b1f5	2.59	56.53	2.07	1.99	2026-04-26 13:17:58.092147	2459
7f85773c-30b2-4ff2-877a-93f568213806	1.37	226.47	3.59	1.71	2026-04-26 13:17:58.092147	2460
4d87ace7-e3ee-4ea4-92f6-c395ef501428	2.7	52.8	3.91	2.89	2026-04-26 13:17:58.092147	2461
4d289278-e3f8-42ed-af6a-2d3259072f3f	2.44	248.91	1.66	2.67	2026-04-26 13:17:58.092147	2462
ebffe864-14eb-465e-b745-192f6e5717bf	1.78	100.88	3.82	1.55	2026-04-26 13:17:58.092147	2463
fb9a49ca-e5e2-4be1-9e2c-5d77c4db770b	0.65	199.04	1.96	1.99	2026-04-26 13:17:58.092147	2464
150f7991-fbd0-429e-bdf9-c60b50b1aae6	0.78	198.1	1.53	2.23	2026-04-26 13:17:58.092147	2465
569b5e54-a5e6-442c-94e0-64a8245dcd07	1.75	79.35	2.46	2.9	2026-04-26 13:17:58.092147	2466
1525c80d-cf06-4108-bab9-0205f6ed78f7	0.62	228	2.6	1.36	2026-04-26 13:17:58.092147	2467
c6e7314c-8525-4191-80c2-2c3a921f415d	1.99	284.9	3.68	2.13	2026-04-26 13:17:58.092147	2468
01d04063-d9c3-43b8-9cd1-f2c365206958	1.68	92.31	3.32	2.37	2026-04-26 13:17:58.092147	2469
688a8c3f-fa38-4308-89d5-212d6faf8a77	1.01	90.78	3.96	2.98	2026-04-26 13:17:58.092147	2470
80f0e0e1-a56b-4969-9328-300dd7d3889e	2.94	270.3	2.35	1.26	2026-04-26 13:17:58.092147	2471
bf4c1fb6-a269-4569-be90-6b6a998ee7b9	1.1	249.94	3.06	1.2	2026-04-26 13:17:58.092147	2472
4421a7a4-be54-4494-b732-9068a725e9b7	1.95	195.79	1.23	1.05	2026-04-26 13:17:58.092147	2473
5d9bfdd7-0a23-41a4-bff6-1d1b588e6b78	1.05	263.99	3.73	1.61	2026-04-26 13:17:58.092147	2474
9272aa0e-60be-48a7-b1a9-e260a3fcd3d2	1.44	184.87	1.42	1.31	2026-04-26 13:17:58.092147	2475
cd6c4c38-b00a-4644-b1a1-7fc4b8c0ef46	0.98	210.67	2.53	1.15	2026-04-26 13:17:58.092147	2476
903c34b0-9809-44ee-af0c-97ca045cde31	2.35	83.17	1.91	1.92	2026-04-26 13:17:58.092147	2477
ec564929-5d5d-4964-85c9-c2c00181550b	1.3	133.05	2.64	1.55	2026-04-26 13:17:58.092147	2478
eb5b0417-51b7-4630-89a7-fbac16715f99	2.73	61.47	3.81	2.8	2026-04-26 13:17:58.092147	2479
2f71377b-f84e-4d62-a2dd-610ad858eff9	2.96	61.83	1.74	1	2026-04-26 13:17:58.092147	2480
ccefa4d3-0ac6-49b4-b548-44dbecf95314	0.55	86.57	2.74	1.76	2026-04-26 13:17:58.092147	2481
641085c9-c0f6-4e22-ba3b-1fb94f36d101	2.47	281.19	3	2.88	2026-04-26 13:17:58.092147	2482
98771193-9965-407f-9a85-7fede6b77203	1.12	68.12	3.13	1.8	2026-04-26 13:17:58.092147	2483
a4f48f59-b6eb-49b5-bda3-c4cbe0959ccc	3.38	167.29	3.39	1.1	2026-04-26 13:17:58.092147	2484
349fd483-5e87-4860-902e-0499901d0595	0.59	297	2.49	2.95	2026-04-26 13:17:58.092147	2485
9c9909c7-05a2-4227-acf9-28521c0da135	1.9	284.76	3.38	1.99	2026-04-26 13:17:58.092147	2486
f305ad8e-b6cd-4ccb-8d44-e33845a294a1	1.27	153.72	2.88	1.28	2026-04-26 13:17:58.092147	2487
baa2883c-e58b-4231-a08f-44235a4dea80	1.66	207.45	3.28	2.25	2026-04-26 13:17:58.092147	2488
0d8f1e65-863d-45d8-bd85-f7a7bb2a19d6	2.28	195.27	1.23	2.81	2026-04-26 13:17:58.092147	2489
1274b8fd-1c04-42fe-ae89-7ee5494a8909	3.42	207.75	2.17	1.91	2026-04-26 13:17:58.092147	2490
177aba49-3dfa-4284-870d-fb28b84d4534	3.36	252.4	3.73	2.07	2026-04-26 13:17:58.092147	2491
a3e55969-7679-400e-b2f8-63e2955e54c2	2.17	142.59	1.93	1.38	2026-04-26 13:17:58.092147	2492
ccea675a-ef56-4f85-b8c5-317c8ce5a850	2.91	285.81	1.12	1.8	2026-04-26 13:17:58.092147	2493
3aa10c1e-2460-4377-b65a-f47990cf20a4	0.74	75.64	3.62	1.42	2026-04-26 13:17:58.092147	2494
95049103-faa4-4e21-9165-033861d9c488	2.95	99.14	3.99	2.85	2026-04-26 13:17:58.092147	2495
2c47bb0c-f0bc-43ef-97b7-ec4d8c96c29f	2.09	130.56	1.68	2.06	2026-04-26 13:17:58.092147	2496
c1b55a4f-d015-496a-97a5-0eda929e3dc3	1.38	202.64	1.38	1.09	2026-04-26 13:17:58.092147	2497
b8174b2e-1cb1-472c-ac48-c2a6912e48de	2.21	97.67	2.51	1.12	2026-04-26 13:17:58.092147	2498
ef342171-814f-4d88-ba4b-9c3e820c63de	2.38	230.46	2.31	2.43	2026-04-26 13:17:58.092147	2499
ff142781-a79f-4ff4-a703-7732aa9af9e3	1.51	89	3.13	1.75	2026-04-26 13:17:58.092147	2500
53988c3d-02b2-4be9-95b5-739ffb19f562	2.37	162.33	3.35	2.04	2026-04-26 13:17:58.092147	2501
90e0676d-9543-455e-b95b-033a3dc29094	0.61	55.42	2.95	1.16	2026-04-26 13:17:58.092147	2502
aa53d45e-4f36-4897-b499-3ed698190647	0.76	91.97	1.68	1.19	2026-04-26 13:17:58.092147	2503
0d2cac97-cb24-4e98-8c0f-4356b3e97f0a	2.92	102.85	1.92	1.45	2026-04-26 13:17:58.092147	2504
3781bb39-94d7-41ab-bddb-e6008d65fc3e	1.14	133.22	2.79	2.02	2026-04-26 13:17:58.092147	2505
9c7b719e-b70f-4394-9ff1-ed98e6b5cc58	1.8	209.62	1.23	2.84	2026-04-26 13:17:58.092147	2506
e7450082-184d-42e5-9e10-1ba889b81e15	2.35	78.28	3.17	2.85	2026-04-26 13:17:58.092147	2507
7f8cdea0-97fa-4f5c-a07d-339312618900	2.03	205.54	1.61	1.7	2026-04-26 13:17:58.092147	2508
1cdd7dbf-0fb2-4741-b2ce-1648f6588f83	2.02	198.15	2.34	2.85	2026-04-26 13:17:58.092147	2509
addb0a76-380c-4a6e-81a0-5642a291744d	2.32	238.39	1.73	1.36	2026-04-26 13:17:58.092147	2510
37353a0a-b1de-4f16-ade8-742e357bff71	1.24	209.72	2.04	2.89	2026-04-26 13:17:58.092147	2511
d806cbd2-e0cc-4e83-84a5-7e939ebd4b95	2.87	159.87	1.38	2.49	2026-04-26 13:17:58.092147	2512
84970f72-5d25-45d2-96d7-3ed2f3315168	0.85	250.83	2.68	2.73	2026-04-26 13:17:58.092147	2513
80fbbed9-4a78-4bd2-87e9-af704fc2de31	1.69	100.22	1.17	1.57	2026-04-26 13:17:58.092147	2514
8a2c8802-0ed7-4c68-b865-2b6b9b4e467b	2.89	257.61	2.27	1.47	2026-04-26 13:17:58.092147	2515
92491d57-33b8-476b-b82f-4d782b7925be	2.02	199.55	1.17	2.72	2026-04-26 13:17:58.092147	2516
101a0017-9d06-4cab-9376-10fca55b80fe	2.5	182.76	1.81	2.19	2026-04-26 13:17:58.092147	2517
7a670221-9a34-46e2-b81b-1d7085b29ac8	2.69	254.11	1.99	1.37	2026-04-26 13:17:58.092147	2518
b486f1ad-7297-436a-929a-3696998a7284	1.12	97.59	3.66	1.08	2026-04-26 13:17:58.092147	2519
ef7e5768-abc3-451c-8700-eadd22e0526f	1.17	83.86	3.74	1.31	2026-04-26 13:17:58.092147	2520
63993198-0f2e-4909-b4ec-c6e6b29c10e1	2.65	112.84	2.17	2.01	2026-04-26 13:17:58.092147	2521
785054cb-4641-468e-b119-e344676aba22	3.23	175.94	2.72	2.16	2026-04-26 13:17:58.092147	2522
2641930a-9a92-4a93-a28c-017fc48fc1b3	1.7	56.6	2.23	2.87	2026-04-26 13:17:58.092147	2523
4a2d3659-552c-4773-9281-2b75e2ba4bb6	3.16	165.63	1.43	1.22	2026-04-26 13:17:58.092147	2524
78beb24a-058f-4cc9-864c-1d33949d4818	0.77	276.3	3.25	1.88	2026-04-26 13:17:58.092147	2525
0889297c-d685-4c5d-bfc9-bba36110c15d	2.72	211.74	2.18	2.09	2026-04-26 13:17:58.092147	2526
acef61e7-7f4b-4b30-b6c5-425f9e36a90e	2.94	84.95	3.84	1.36	2026-04-26 13:17:58.092147	2527
186f60d6-c7c7-467f-b4fe-fa7636f79a23	2.36	247.43	2.56	1.79	2026-04-26 13:17:58.092147	2528
4079e5e0-9e84-4432-b44a-32af8e59d4b6	3.21	249.28	1.22	1.8	2026-04-26 13:17:58.092147	2529
29a4907b-3872-4537-b4c9-a42ef3e28b0e	1.79	225.75	1.06	2.49	2026-04-26 13:17:58.092147	2530
0881dc31-d7be-4ddb-99c9-8b6d0fa16990	3.3	235.54	3.66	1.72	2026-04-26 13:17:58.092147	2531
89e3921f-88ff-4fa8-9092-9e3260a671eb	0.79	66.8	2.72	2.95	2026-04-26 13:17:58.092147	2532
22899238-2cb3-4920-ad5f-d00408f74869	1.54	252.47	1.52	1.71	2026-04-26 13:17:58.092147	2533
69b47d8f-7fea-4be2-b860-28261bd322a8	1.37	157.37	3.79	1.92	2026-04-26 13:17:58.092147	2534
ed04eb26-1f11-4e73-bf37-9045f051da24	2.9	278.85	3.69	2.21	2026-04-26 13:17:58.092147	2535
82b0280e-102f-4227-8bdc-035191a662da	1.49	189.94	3.45	2.97	2026-04-26 13:17:58.092147	2536
fc3455ee-1aca-499b-a15a-59daa28c0dae	1.61	258.83	2.18	2.57	2026-04-26 13:17:58.092147	2537
73844c9a-3cfa-47e8-a779-2fd0f85cd1a4	2.83	189.36	2.96	1.52	2026-04-26 13:17:58.092147	2538
1395deb5-7679-416b-8a65-aaf8e835d7c3	2.83	164.55	2.34	2.26	2026-04-26 13:17:58.092147	2539
6b95825f-39e7-468c-9658-f24c248a95ab	0.83	169.36	3.27	1.15	2026-04-26 13:17:58.092147	2540
ce7492b2-e891-474e-a19c-33b127c341bd	1.45	89.16	3.72	1.65	2026-04-26 13:17:58.092147	2541
29b851bc-bf09-44a9-8b92-fd986cecff07	1.17	61.87	1.97	2.03	2026-04-26 13:17:58.092147	2542
18bd7af5-1bd8-4924-b5c8-04e122688eb3	1.78	251.41	1.37	2.59	2026-04-26 13:17:58.092147	2543
0901b3ca-de69-4dc6-8669-6257957ae39e	1.67	269	1.46	2.08	2026-04-26 13:17:58.092147	2544
ecb61af6-0fbb-4eb0-bea9-b8c9f2fb8c69	2.55	290.01	1.43	2.64	2026-04-26 13:17:58.092147	2545
fa086000-f37b-4715-a2af-e114d3776051	2.24	216.39	3.34	1.05	2026-04-26 13:17:58.092147	2546
0ebae568-62bd-4e44-9ff7-798a7cf02baa	1.44	93.96	1.12	2.22	2026-04-26 13:17:58.092147	2547
8c5171fd-392e-49b3-9c7a-cac95ad4b712	2.37	273.37	3.55	1.51	2026-04-26 13:17:58.092147	2548
00b72f94-9185-4684-b9c9-7391caff4082	1.77	180.03	1.17	2.51	2026-04-26 13:17:58.092147	2549
4108c416-a720-408e-b90c-c674d5e86d0c	1.6	71.52	3.85	1.25	2026-04-26 13:17:58.092147	2550
d930d57f-4865-49e1-b97c-e8d38ea33778	2.79	202.92	1.45	2.87	2026-04-26 13:17:58.092147	2551
94ee1380-d4a5-45d7-aca4-98acc362d2ea	2.75	129.8	3.75	1.73	2026-04-26 13:17:58.092147	2552
fdc902c2-6087-4d6f-80c4-06dc3417dd09	2.22	274.49	1.8	2.02	2026-04-26 13:17:58.092147	2553
a8c53a76-9bd2-4da8-bcc2-507bf0391475	0.52	93.17	1.49	1.23	2026-04-26 13:17:58.092147	2554
ec48173e-93eb-43f2-986b-837f4d9ea0a3	1.84	126.45	2.77	2.04	2026-04-26 13:17:58.092147	2555
4cf14171-7f85-401b-a1ed-240a930297d6	3.27	187.67	1.52	1.55	2026-04-26 13:17:58.092147	2556
5e2c38bc-5335-4dcc-b5fd-60f7c7da1f1d	1.72	251.15	3.14	1.11	2026-04-26 13:17:58.092147	2557
6d78a687-8013-4ecd-8edc-b3eaf641d308	2.48	110.05	3.5	1.01	2026-04-26 13:17:58.092147	2558
b4db985f-3cb5-4e0b-8269-75c0205a4a76	1.35	222.47	2.96	2.42	2026-04-26 13:17:58.092147	2559
e740dd73-61ff-47b3-b096-021863c558ef	2.44	163.12	2.97	1.86	2026-04-26 13:17:58.092147	2560
f0f9852b-d33b-4d90-85f0-2672b9b52d4a	2.41	292.34	3.7	2.46	2026-04-26 13:17:58.092147	2561
f7edc0a3-fffa-4af1-94d2-7ae07b266ec2	0.99	133.93	1.85	1.81	2026-04-26 13:17:58.092147	2562
bfcf2856-cd19-4b19-9e9c-310f6f0c9823	1.14	254.09	3.65	2.88	2026-04-26 13:17:58.092147	2563
3bf47c34-9cd2-4cac-a2f2-72a77040dc8b	2.35	73.41	1.51	1.28	2026-04-26 13:17:58.092147	2564
f025cb63-fae9-478d-afac-8cd17a79f540	3.18	296.93	3.23	1.4	2026-04-26 13:17:58.092147	2565
ddfcdeb7-606a-45f0-97b5-cb4b4ea01288	2.41	175.58	3.93	1.13	2026-04-26 13:17:58.092147	2566
bf95b772-5939-480b-9689-b8de3b17819c	1.81	165.46	1.06	1.59	2026-04-26 13:17:58.092147	2567
79fae5b0-e815-4e6b-979c-3d40dcf82296	3.25	129.24	1.56	1.44	2026-04-26 13:17:58.092147	2568
ab8c21a9-bb71-4b4f-aead-976a688c8f5b	1.21	175.36	3.8	2.09	2026-04-26 13:17:58.092147	2569
f9ad0b21-3622-4955-864f-b6acb6a20375	1.79	104.35	2.73	2.37	2026-04-26 13:17:58.092147	2570
da38da3e-9316-49d8-af58-cfca2be2ecea	2.38	122.92	2.28	2.84	2026-04-26 17:46:17.21088	2571
8d34dd99-e669-4ca7-99af-1d91991a09c9	2.16	101.28	3.14	2.03	2026-04-26 17:46:17.21088	2572
8d34dd99-e669-4ca7-99af-1d91991a09c9	2.16	101.28	3.14	2.03	2026-04-26 17:46:17.21088	2573
db738178-6c85-4003-814c-43efae201f66	0.76	110.29	2.61	1.85	2026-04-26 17:46:17.21088	2574
db738178-6c85-4003-814c-43efae201f66	0.76	110.29	2.61	1.85	2026-04-26 17:46:17.21088	2575
083b503f-bc9a-4761-9232-985118e3bde4	0.63	231.43	1.58	2.24	2026-04-26 17:46:18.246269	2576
84898f92-b30c-4251-99c5-6d4b8ee07428	0.9	65.41	1.39	2.3	2026-04-26 17:46:18.246269	2577
1798c0d0-79e4-4d2b-9f3f-990b125d2105	1.9	129.54	2.06	2.98	2026-04-26 17:46:18.246269	2578
d4454c95-37c1-4467-a22e-9fb7abac08a2	1.38	223.88	2	2.29	2026-04-26 17:46:18.246269	2579
1dc79f19-741d-4d47-8552-5e53debeed00	0.93	66.38	1.01	2.26	2026-04-26 17:46:18.246269	2580
127074f4-ef1e-44c6-b9d4-6e159522fe6d	3.15	144.61	1.47	1.11	2026-04-26 17:46:18.246269	2581
933c3358-c4a9-4190-ba36-d320f41b28bd	1.65	63.22	3.54	1.64	2026-04-26 17:46:18.246269	2582
24c4b5e6-9375-4a3d-aa2e-8ecf73311e2a	1.05	297.52	3.6	2.83	2026-04-26 17:46:18.246269	2583
8459b204-828a-433c-946a-16940b23fe20	2.85	177.83	3.49	1.77	2026-04-26 17:46:18.246269	2584
6c67de4d-14df-473a-b5b7-234ca1892d36	1.02	119.83	1.93	2.35	2026-04-26 17:46:18.246269	2585
1a1da762-8b17-44fc-ab54-aacee70233c0	0.61	288.16	1.51	1.04	2026-04-26 17:46:18.246269	2586
eaf83308-161d-4cbe-9a8f-c87d75ee5421	2.03	70.03	3.7	1.71	2026-04-26 17:46:18.246269	2587
2639cd66-3527-4a6d-b26e-dfb2491c1bf2	2.01	176.61	3.57	2.55	2026-04-26 17:46:18.246269	2588
8d34dd99-e669-4ca7-99af-1d91991a09c9	0.86	256.28	3.72	2.22	2026-04-26 17:46:18.246269	2589
77398e9d-8c73-4cfb-9019-93696911c12d	2.19	251.48	3.2	2.29	2026-04-26 17:46:18.246269	2590
af79ed93-81e1-4dad-ab43-483f230ed7d4	2.28	122.48	2.93	1.08	2026-04-26 17:46:18.246269	2591
a09b5914-31d8-4628-bfde-a2ed4f60f907	3.38	192.02	1.47	2.1	2026-04-26 17:46:18.246269	2592
af5d64a0-8fd6-4135-9b5c-ed9a17afe722	3.4	214.91	1.75	2.02	2026-04-26 17:46:18.246269	2593
48f2ef4f-6f48-4a5a-8aca-e2844be19a4d	1.06	216.02	1.97	2.16	2026-04-26 17:46:18.246269	2594
c4a5295a-ac7e-4505-ae47-069a3a50ecec	1.91	231.32	1.1	1.98	2026-04-26 17:46:18.246269	2595
0cdc07b0-d122-4345-a871-ed8736125a13	3.18	197.91	1.48	1.16	2026-04-26 17:46:18.246269	2596
8be3185b-bc1c-4142-b567-48aaff220b01	1	51.04	1.22	2.27	2026-04-26 17:46:18.246269	2597
d9051e4d-d569-4f01-89e0-7d857762afe5	1.26	262.98	1.32	1.24	2026-04-26 17:46:18.246269	2598
3fad7c09-4ab3-4a8b-aa29-7211513f7237	1.12	105.03	1.25	2.68	2026-04-26 17:46:18.246269	2599
dbbf360e-7216-4601-8614-038fe1dcc2ba	3.06	248.82	3.26	3	2026-04-26 17:46:18.246269	2600
9bd9f3c5-1b49-4927-8cdf-35373636ae00	2.33	211.5	2.6	2.78	2026-04-26 17:46:18.246269	2601
160d3adf-6a5a-4442-8c35-f8ff730e0036	2.58	205.04	2.12	2.79	2026-04-26 17:46:18.246269	2602
5c42027f-8aaa-441b-990e-215c05fc0300	0.8	203.04	3.62	1.75	2026-04-26 17:46:18.246269	2603
bfc1d7fb-6dd6-42fd-a795-053bca272428	2.96	129.04	1.97	1.75	2026-04-26 17:46:18.246269	2604
fe19663b-26a2-40d0-a329-bf3f1f6a25a6	1.68	261.57	1.82	1.99	2026-04-26 17:46:18.246269	2605
09bcbc34-b01a-4878-88ae-4aac9ea91b2d	0.8	282.01	1.32	2.42	2026-04-26 17:46:18.246269	2606
28aa7be3-ebf0-4bfb-9e4d-8eb57e7a1a09	2.35	161.08	2.78	2.32	2026-04-26 17:46:18.246269	2607
a463568f-08c1-4eee-ba9f-87eca478959e	3.48	70.4	1.63	1.59	2026-04-26 17:46:18.246269	2608
e91e2255-deed-4ffc-9e86-da19ee4fe2be	2.48	208.82	1.62	1.78	2026-04-26 17:46:18.246269	2609
e6c3818b-29f0-4e36-9052-5e1482339405	1.38	291.5	2.04	2.01	2026-04-26 17:46:18.246269	2610
80d81f80-2426-4c17-9e8a-321da7361798	2.22	197.63	3.92	2.72	2026-04-26 17:46:18.246269	2611
6f817b31-ed87-46bb-9e2e-1140f4cb4cbb	2.5	250.67	3.53	2.94	2026-04-26 17:46:18.246269	2612
34c9e297-d7dc-4168-a5a5-8e7e148dcbbd	0.71	110.57	2.39	2.02	2026-04-26 17:46:18.246269	2613
06c52bbf-cbe5-4db7-997a-9f747283665e	1.55	207.62	2.57	2.28	2026-04-26 17:46:18.246269	2614
0404794e-0a50-4824-a0ee-921cb23888ee	1.04	154.11	1.26	1.95	2026-04-26 17:46:18.246269	2615
ff75e776-7227-4220-9f32-33a6013ae67f	1.86	272.87	3.11	1.18	2026-04-26 17:46:18.246269	2616
522e7eca-7dde-4bb5-9cfd-7bfc1f5aa823	3.4	240.58	1.99	2.18	2026-04-26 17:46:18.246269	2617
0670c059-cbff-4d6e-97fa-c2dbd81ba878	2.06	170.8	1.67	1.89	2026-04-26 17:46:18.246269	2618
41623b9e-303f-46b1-82d3-8883c4a479bb	2.59	178	2.24	1.93	2026-04-26 17:46:18.246269	2619
8425054a-27fe-45f7-a2d1-0ca5bb87c22d	1.51	116.39	2.96	1.21	2026-04-26 17:46:18.246269	2620
88f2dc8f-4748-490e-b92d-e31ba6ddaf7b	0.81	267.39	1.77	1.95	2026-04-26 17:46:18.246269	2621
71e03cf9-1c81-44c0-9c0f-63591e58aa30	1.66	132.38	2.15	2.93	2026-04-26 17:46:18.246269	2622
bc2f02a5-cb1e-4610-ac0e-ba7f24c18ccd	0.69	254.22	1.61	1.71	2026-04-26 17:46:18.246269	2623
c110010b-1088-4e02-be3c-83c511d7831c	0.57	268.41	2.61	2	2026-04-26 17:46:18.246269	2624
fe8407a5-d6f0-4b63-b0c1-71ad87ffab96	3.25	57.62	2.81	2.35	2026-04-26 17:46:18.246269	2625
19646a15-fc51-45ea-b837-9703ea5e5f8c	2.59	288.21	1.28	1.55	2026-04-26 17:46:18.246269	2626
048313b2-21ec-4fbc-be08-2f0c27fa77f6	1.91	112.45	3.6	2.29	2026-04-26 17:46:18.246269	2627
66ae13b0-bc41-401b-919a-a47c2d82b9ef	3.1	145.72	3.22	2.43	2026-04-26 17:46:18.246269	2628
d87f65c7-d638-4f26-a825-aff5ae57457b	3.22	92.12	3.52	1.04	2026-04-26 17:46:18.246269	2629
7931d397-9cb6-40aa-888c-6b1cfe481a74	1.7	116.8	1.15	2.07	2026-04-26 17:46:18.246269	2630
a63e2468-ff52-45a6-a5cd-59944a3859bb	2.51	208.3	1.75	2	2026-04-26 17:46:18.246269	2631
2c170f3c-70f5-4432-9675-baa82539a713	2.67	117.72	2.8	2.13	2026-04-26 17:46:18.246269	2632
a49a8d86-d915-4488-b843-de71b33e91fd	2.18	226.05	1.08	2.27	2026-04-26 17:46:18.246269	2633
b2cd1843-50e3-475c-b68b-24bcf035d14a	1.03	135.38	1.79	2.44	2026-04-26 17:46:18.246269	2634
49214cd6-15b3-43e2-b004-f11980bd76e7	2.98	99.03	3.73	2.06	2026-04-26 17:46:18.246269	2635
da38da3e-9316-49d8-af58-cfca2be2ecea	2.7	189.67	2.98	2.48	2026-04-26 17:46:18.246269	2636
06e503be-bdf4-4afe-9252-ad4307d77d34	1.22	74.15	3.76	1.01	2026-04-26 17:46:18.246269	2637
e07bf42f-e0df-4ae0-8b19-59673c872bf2	1.7	72.77	2.76	2.73	2026-04-26 17:46:18.246269	2638
d9ff0e43-523c-4157-b412-c6e488086313	0.53	224.03	3.2	1.49	2026-04-26 17:46:18.246269	2639
73605445-18c0-4c79-aa20-abe75a2aa504	1.51	278.03	2.19	2.55	2026-04-26 17:46:18.246269	2640
17d1d4a8-7fff-4e9d-be6b-1ad8cff6ebd6	3.24	284.69	3.94	1.05	2026-04-26 17:46:18.246269	2641
0ff59da4-ea9a-48c5-9b60-96f17e2644b7	0.93	229.08	3.92	2.3	2026-04-26 17:46:18.246269	2642
0c867821-28e1-489c-96ef-a33a16f96004	1.9	64.79	2.13	2.78	2026-04-26 17:46:18.246269	2643
6111d377-0b6c-4d93-b288-f7ebce6c00fc	2.87	233.44	1.79	2.25	2026-04-26 17:46:18.246269	2644
18905b39-d6a0-4f41-8c02-9b817e1b009d	3.42	111.84	2.11	2.96	2026-04-26 17:46:18.246269	2645
8b417aee-680e-4081-85f2-5a160fb2ff12	3.19	135.66	3.21	1.06	2026-04-26 17:46:18.246269	2646
38b482a7-1f32-4ddc-9349-bcf1da86d546	1.03	203.34	1.03	2.06	2026-04-26 17:46:18.246269	2647
02152a87-fd48-4156-bd2f-afe94c4dc7a6	2.48	245.64	1.46	2.63	2026-04-26 17:46:18.246269	2648
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.22	56.79	2.71	2.02	2026-04-26 17:46:18.246269	2649
79cd4a3f-adcf-4ce5-9d29-62693c93adf2	1.69	224.65	3.57	1.7	2026-04-26 17:46:18.246269	2650
c4391873-3533-4cad-977b-0323fced348e	0.89	92.04	3.54	1.6	2026-04-26 17:46:18.246269	2651
c6338c80-214f-405b-9b0b-7594bb69d230	0.89	174.14	3.22	1.38	2026-04-26 17:46:18.246269	2652
382f3f60-7d3c-4ffc-8b2f-94ce32b77254	2.7	220.49	3.78	2.57	2026-04-26 17:46:18.246269	2653
cf827a4b-a720-4825-84d4-29f047763f7e	1.9	66.38	1.2	2.34	2026-04-26 17:46:18.246269	2654
d5806c60-9752-4845-9128-964d9b723f0b	1.57	183.07	2.21	2.66	2026-04-26 17:46:18.246269	2655
96e0af22-02e2-46d4-8224-4db162bd27b6	2.54	55.11	3.41	1.61	2026-04-26 17:46:18.246269	2656
9d0c77f5-485a-477d-80ec-8da875eb9852	1.61	126.62	3.44	1.07	2026-04-26 17:46:18.246269	2657
c19c4f6a-3738-436e-b7dc-b27df3129b28	2.57	230.85	1.1	2.97	2026-04-26 17:46:18.246269	2658
2d78aa7b-b8fb-4cc0-9d8a-f6a927032041	0.65	132.6	2.23	2.38	2026-04-26 17:46:18.246269	2659
dbebf850-836f-4532-807c-c1e3f5b5d597	3.31	267.72	3.17	2.33	2026-04-26 17:46:18.246269	2660
453f03e0-cb8d-4681-b343-d681f27e84f8	2.42	179.72	1.24	2.25	2026-04-26 17:46:18.246269	2661
13d5f24a-3280-4db1-ae8d-4e7ac37dca9d	1.62	80.76	1.04	1.88	2026-04-26 17:46:18.246269	2662
40f8a8d7-327f-4f20-a15c-cbd9fb6f5e75	3.02	291.79	1.56	1.99	2026-04-26 17:46:18.246269	2663
8cfcaf67-4ae0-46c6-996e-6ce551b4096d	3.12	111.14	1.27	1.49	2026-04-26 17:46:18.246269	2664
05bb5c72-6613-4d45-a876-a6c5fb64222e	0.58	93.52	3.43	1.95	2026-04-26 17:46:18.246269	2665
37b80a41-5dec-4adb-ac19-126072ec4a13	2.5	149.78	2.24	1.06	2026-04-26 17:46:18.246269	2666
514c19e7-d8eb-4f8a-b58c-db01659e571e	0.67	128.52	3.19	1.9	2026-04-26 17:46:18.246269	2667
27ded357-dfee-45c6-844b-2108e05a105b	2.79	219.18	3.53	2.86	2026-04-26 17:46:18.246269	2668
affc16bb-f7a4-4ff2-90df-48caf7eebddc	3.44	293.05	1.04	2.15	2026-04-26 17:46:18.246269	2669
cb0fe3b7-fbc8-479b-bd12-6acfeeeeffeb	1.92	162.88	3.31	1.9	2026-04-26 17:46:18.246269	2670
c0f13516-b42b-4edf-8d54-260ed3432c91	2.99	291.36	2.4	2.76	2026-04-26 17:46:18.246269	2671
a6b3ffd9-c2dc-4bf3-872f-1d4dfaff44ce	2.74	149.19	3.48	2.3	2026-04-26 17:46:18.246269	2672
4c18584e-0e3e-40cc-94a4-dd6106965efb	2.06	205.62	3	1.91	2026-04-26 17:46:18.246269	2673
42be6f12-2662-427d-b3bb-9f8fb042cde5	2.63	287.41	1.63	2.78	2026-04-26 17:46:18.246269	2674
a9a3a5fa-5c98-4e69-883b-2afa82b1877f	2.95	281.76	2.59	2.68	2026-04-26 17:46:18.246269	2675
69ceb13d-c6ba-480a-9bb6-8c94350b80bb	2.67	242.57	2.19	2.57	2026-04-26 17:46:18.246269	2676
6946eb18-50ec-477c-808d-f71c98670e15	2.03	287.98	3.7	1.23	2026-04-26 17:46:18.246269	2677
db738178-6c85-4003-814c-43efae201f66	3.22	115.16	2.39	1.92	2026-04-26 17:46:18.246269	2678
4b5f92c9-7d51-4b0e-a137-acd779a460c0	2.05	130.06	1.66	1.9	2026-04-26 17:46:18.246269	2679
343b8afa-f5f3-413a-8faf-37c6af937323	2.01	299.23	3.14	2.51	2026-04-26 17:46:18.246269	2680
aa3eddc8-b910-47a9-b691-2ec377a4b6c3	1.71	197.07	2.01	2.36	2026-04-26 17:46:18.246269	2681
10412ce9-7326-4907-98fb-f30f329eb834	2.11	166.74	3.63	1.57	2026-04-26 17:46:18.246269	2682
a7a83b3b-4904-468d-b1ff-79250bae2178	1.09	162.62	1.61	1.79	2026-04-26 17:46:18.246269	2683
de64100b-0d55-4423-8139-e21bf67b1ba3	2.88	163.25	2.16	1.76	2026-04-26 17:46:18.246269	2684
48f1cae9-db76-406a-84c3-4b1d3fd1f646	0.55	282.11	1.98	2.87	2026-04-26 17:46:18.246269	2685
bff99142-a62f-4628-a6ff-c053c6deb013	0.63	62.18	3.37	2.05	2026-04-26 17:46:18.246269	2686
fb073968-3588-453a-85e2-75089d4c03f1	1.85	242.51	2.58	2.53	2026-04-26 17:46:18.246269	2687
377f4e07-93cb-4351-8c6b-62851338fdb0	0.55	248.01	3.34	2.67	2026-04-26 17:46:18.246269	2688
19bdfc5a-e1d0-463a-b163-7d7a692f73b8	2.34	236.73	2.43	1.49	2026-04-26 17:46:18.246269	2689
cbd20eb0-7239-4734-b82b-404600e7d66b	1.74	196.36	3.77	1.3	2026-04-26 17:46:18.246269	2690
18c3479d-2072-411f-8d91-9a580608c627	0.68	136.74	1.71	1.54	2026-04-26 17:46:18.246269	2691
ca09ced3-7738-4c9e-887f-d34312c3d8e4	3	279.75	3.54	2.2	2026-04-26 17:46:18.246269	2692
07a6b221-981a-4cce-bb5d-3d5a872c97b7	2.1	213.34	2.64	1.22	2026-04-26 17:46:18.246269	2693
fa753e0b-bcb9-41b7-9c82-6fccd2333db1	0.66	102.89	1.86	2.1	2026-04-26 17:46:18.246269	2694
100a7e1e-99f2-4b0d-8a9d-842a454a612f	3.35	209.35	1.51	1.3	2026-04-26 17:46:18.246269	2695
41bd264e-1eb3-4ccb-ab43-221d92913239	0.86	285.42	1.86	1.86	2026-04-26 17:46:18.246269	2696
b80e97e3-fe08-465e-ac72-eea64d2d6182	0.92	145.47	2.27	1.76	2026-04-26 17:46:18.246269	2697
ed596397-26d6-4d02-a2f1-dbbf5f8ab704	0.62	173.41	3.94	2.1	2026-04-26 17:46:18.246269	2698
5d36c463-e893-43a2-b567-1e7fbcb3c80c	0.54	70.56	3.99	2.22	2026-04-26 17:46:18.246269	2699
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	2.67	256.9	3.79	2.42	2026-04-26 17:46:18.246269	2700
b611f2f3-4dce-4565-9634-c5f67f16841f	1.07	170.51	2.77	1.76	2026-04-26 17:46:18.246269	2701
af16d415-a7a8-426f-8d38-2ade72d8acb5	1.32	67.2	2.16	2.38	2026-04-26 17:46:18.246269	2702
a18f9d90-4ce4-4793-a9c1-9452712601a3	3.38	228.51	1.39	1.57	2026-04-26 17:46:18.246269	2703
2421d8dc-3548-4b72-b606-b235ecdf5448	3.27	116	3.04	1.34	2026-04-26 17:46:18.246269	2704
bb6389a5-9e20-4135-8648-8a813bb296b7	1.53	199.48	3.43	1.13	2026-04-26 17:46:18.246269	2705
6447b600-e734-4067-87b1-b915998722b4	1.29	97.83	2.38	1.2	2026-04-26 17:46:18.246269	2706
a1fc9f0b-f1e6-4819-9cb5-1ce77541a1b5	1.16	141.22	3.35	2.16	2026-04-26 17:46:18.246269	2707
25df9dd3-d744-4a1e-a96b-d1322d6952f5	1.61	67.49	1.89	1.37	2026-04-26 17:46:18.246269	2708
8e3909e7-8ee5-4db8-9278-087d2851a6f1	1.83	156.23	2.34	2.34	2026-04-26 17:46:18.246269	2709
3fcc2af3-e524-4b65-9649-cc48a58b7463	3.44	146.61	2.3	1.22	2026-04-26 17:46:18.246269	2710
3045ab21-e78f-41cf-9f96-102cfd907777	1.38	237.75	3.88	1.85	2026-04-26 17:46:18.246269	2711
211e6d92-06f3-4968-ab18-4d3606fb0313	3.36	159.15	3.39	2.68	2026-04-26 17:46:18.246269	2712
577c5ceb-5d82-4a67-914e-cc3249432558	1.61	246.13	2.65	2	2026-04-26 17:46:18.246269	2713
a9955bda-fedb-44d9-b5a6-33b7ceff70cc	1.06	236.9	2.08	1.95	2026-04-26 17:46:18.246269	2714
cac6b96e-6c77-4c20-b201-5d059367fbf0	2.55	230.73	2.2	2.36	2026-04-26 17:46:18.246269	2715
40b83090-1da5-4f1a-85d6-884f75d306d9	2.97	146.26	1.6	1.45	2026-04-26 17:46:18.246269	2716
af6f8bce-ab49-4a79-a40c-4a4aba8d8552	3.43	113.27	2.18	1.13	2026-04-26 17:46:18.246269	2717
7674a04d-8f67-4d07-9eab-998e344a03c9	1.9	218.37	3.7	2.14	2026-04-26 17:46:18.246269	2718
f97b5670-ef68-4a86-97c0-6385e6ae7405	2.1	113.94	2.53	1.61	2026-04-26 17:46:18.246269	2719
4fc26046-1ae2-4e60-99cf-95ef8ee6524a	1.37	168.41	1.2	1.19	2026-04-26 17:46:18.246269	2720
e332ef09-be23-4a9d-b003-f886bfae870d	3.03	139.62	3.71	1.64	2026-04-26 17:46:18.246269	2721
88f0fd74-5fbe-402b-b1f9-8b0185f9b042	3.36	212.74	2.52	2.07	2026-04-26 17:46:18.246269	2722
7289ae0e-9605-4d46-aaee-5b05ddd96e59	3.37	284.04	1.17	1.45	2026-04-26 17:46:18.246269	2723
b0318b61-a090-47a1-a30e-1f29ba099262	1.35	249.2	2.84	1.59	2026-04-26 17:46:18.246269	2724
26ec3ee2-f140-4f43-b13b-9299796dd2d1	0.91	197.33	1.15	2.15	2026-04-26 17:46:18.246269	2725
9dab24c7-177d-4ec4-8c0b-2323b92d3d4a	1.37	71.27	1.49	2.58	2026-04-26 17:46:18.246269	2726
1a6d5e85-787b-461f-8db7-9cd8f8d81ece	1.01	71.54	3.96	2.55	2026-04-26 17:46:18.246269	2727
27b23042-92c6-4a49-b397-6c200041d8ee	2.56	62.71	1.46	1.15	2026-04-26 17:46:18.246269	2728
08f0acf7-18ec-45eb-8146-8042969d5c7a	2.46	219.15	2.05	1.82	2026-04-26 17:46:18.246269	2729
a03af7ca-2046-499e-b19d-b6571e696f89	2.97	252.35	1.36	1.83	2026-04-26 17:46:18.246269	2730
e7fd011f-5572-4ee9-a3de-2d9d4d5c818d	1.41	146.33	2.92	2.49	2026-04-26 17:46:18.246269	2731
4065ab51-f74f-42a2-9363-7146df43c932	3.48	251.88	1.28	2.74	2026-04-26 17:46:18.246269	2732
a07f2ed2-35ae-4720-ad65-a22fe59566d3	3.36	179.47	1.99	2.73	2026-04-26 17:46:18.246269	2733
02c4237f-a7f5-452b-82c3-1fe296af3c3c	1.5	192.31	3.74	2.48	2026-04-26 17:46:18.246269	2734
62b7cf0d-cf31-493a-85aa-8fa347acda25	3.12	279.16	2.5	1.77	2026-04-26 17:46:18.246269	2735
ab3db038-d69b-451e-bba3-08e8119898b4	1.97	76.4	2.74	2.24	2026-04-26 17:46:18.246269	2736
b685932b-8a27-4288-8795-f6e05e9e4cef	1.37	149.51	3.44	1.98	2026-04-26 17:46:18.246269	2737
9cd7e4f4-8d1a-48da-abbc-075218e9e7a6	2.89	89.01	3.56	1.59	2026-04-26 17:46:18.246269	2738
98d2ddcf-4cfa-4405-9501-d661884b1017	2.77	147.38	1.5	2.98	2026-04-26 17:46:18.246269	2739
d0655207-0783-4e94-98d2-176fe26849d8	3.33	92.38	2.95	1.5	2026-04-26 17:46:18.246269	2740
bcad4d42-8a4f-4b72-a2e1-b607651d5c31	1.31	298.03	1.39	2	2026-04-26 17:46:18.246269	2741
9ed4929a-d3c0-4954-b272-227a89cbedec	2.07	247.72	1.85	1.99	2026-04-26 17:46:18.246269	2742
edcb7d15-e6ed-461f-b1b4-38a993ff2ec7	0.83	131.8	3.12	1.65	2026-04-26 17:46:18.246269	2743
2f5d7c02-eadd-4eb2-8dd5-46a5ba51c3f8	2.69	58.74	2.57	2.85	2026-04-26 17:46:18.246269	2744
0ad0a6eb-d13c-440c-b74c-0391605d9685	0.76	68.25	2.84	2.11	2026-04-26 17:46:18.246269	2745
2bb8c959-19b6-4951-8313-e6d0413c9a6f	0.68	151.23	1.38	1.87	2026-04-26 17:46:18.246269	2746
303a312c-4f87-408c-b20b-03d848ec9055	0.59	106.73	3.7	2.54	2026-04-26 17:46:18.246269	2747
a32bfdcd-5dd9-4a93-85e7-c1e608df83ee	0.65	129.43	3.83	2.28	2026-04-26 17:46:18.246269	2748
5ccc6390-43ca-49f5-b6fa-84247d3e52af	1.99	62.01	2.56	1.06	2026-04-26 17:46:18.246269	2749
df299e49-61f2-49ce-8051-e50cfc0b2650	0.7	116.57	1.64	2.74	2026-04-26 17:46:18.246269	2750
86ef6ade-b308-467a-8c42-3c6e4c20ec8d	2	153.02	3.28	1.36	2026-04-26 17:46:18.246269	2751
e318d53f-7605-468a-b41d-051070be96a3	2.43	163.22	1.86	2.09	2026-04-26 17:46:18.246269	2752
efc0c233-0113-480b-b3e6-ca3275b5ffde	0.56	125.92	2.99	2.65	2026-04-26 17:46:18.246269	2753
5808ae27-83d1-4163-9187-6a23f988dc97	2.98	277.7	2.96	1.28	2026-04-26 17:46:18.246269	2754
e304e2e6-fd72-4399-b4d7-fb6416b81f0c	1.09	108.34	1.59	1.76	2026-04-26 17:46:18.246269	2755
678ae26f-569d-4c0e-b4a9-0a688fc0936a	2.58	114.21	1.63	1.49	2026-04-26 17:46:18.246269	2756
6438657c-ee67-48b5-8de0-62eeb64e0a87	3.19	230.68	2.62	2.04	2026-04-26 17:46:18.246269	2757
e3216b17-e320-4d0f-ada0-b93e60caca02	1.69	264.49	1.26	2.43	2026-04-26 17:46:18.246269	2758
63188d13-0344-4b51-aa79-19ea416c8cdd	3.05	122.95	3.71	1.2	2026-04-26 17:46:18.246269	2759
17932bb9-836e-4db9-b27e-bd1b2f574954	1.19	60.97	1.5	2.89	2026-04-26 17:46:18.246269	2760
459418c3-7fb1-4dd5-9c2b-6a0eb1e128a7	3.01	64.9	3.22	2.08	2026-04-26 17:46:18.246269	2761
4d88229f-55e4-476b-bfc0-096795c485e4	1.89	96.75	2.91	2.71	2026-04-26 17:46:18.246269	2762
2ce612e7-1b0e-4a98-aab2-d00e087e7acd	2.45	199.6	1.32	1.93	2026-04-26 17:46:18.246269	2763
f1c04ba0-d43a-4055-8726-0674ce5a9591	1.58	232.03	2.73	2.04	2026-04-26 17:46:18.246269	2764
b4617646-5ec4-4d15-a573-c29cffb7c27f	1.13	103.02	1.95	2.34	2026-04-26 17:46:18.246269	2765
c02600b3-e48e-4409-95a3-eb683e336b10	1.66	90.28	2.98	1.94	2026-04-26 17:46:18.246269	2766
fc365d4b-670e-4fca-8c15-bed27e9c7c64	3.48	154.4	2.73	1.43	2026-04-26 17:46:18.246269	2767
b5bfff34-218c-48cd-b9ce-673eea91bda1	0.52	298.41	3.33	1.99	2026-04-26 17:46:18.246269	2768
0ef3d984-2e82-4672-bcd6-c49dfd8397b3	3.24	215.07	1.29	1.18	2026-04-26 17:46:18.246269	2769
869589e4-a12e-4a97-9558-0e078bfadd07	3.24	90.27	3.7	2.55	2026-04-26 17:46:18.246269	2770
fc37eb73-af1d-4f66-ab8d-ac6cd664ceea	3.36	114.56	3.14	1.84	2026-04-26 17:46:18.246269	2771
f182189b-b6e2-4aee-bb22-5b1e555815b6	2.53	206.96	2.36	2.98	2026-04-26 17:46:18.246269	2772
4a03155b-1956-495a-aa04-f02a9c3d31c8	1.69	186.67	2.78	1.06	2026-04-26 17:46:18.246269	2773
6b9cb1d4-e93d-40cb-8099-44f30eae119b	2.29	277.24	2.67	2.96	2026-04-26 17:46:18.246269	2774
77c9a885-1040-44e4-8b7c-18dccb3b1a81	1.53	217.88	2.42	1.52	2026-04-26 17:46:18.246269	2775
ab089221-71a5-4b3c-a06e-445f999eed0a	0.66	202.96	3.93	1.32	2026-04-26 17:46:18.246269	2776
2954b16d-0db5-4232-8923-ca1c2a81be0a	3.1	207.3	3.37	1.88	2026-04-26 17:46:18.246269	2777
e072183d-f51e-4965-a227-e111304e8104	1.42	180	1.48	1.86	2026-04-26 17:46:18.246269	2778
d59dcfa3-ec8d-4789-81cd-22e13a9c829c	0.92	61.46	3.67	2.77	2026-04-26 17:46:18.246269	2779
e32ad455-b5bd-49ef-b295-f81c8a11da16	2.51	221.84	2.12	2.66	2026-04-26 17:46:18.246269	2780
21d6e120-8fa3-4a51-9ade-436c7d77e075	3.36	212.52	3.61	1.09	2026-04-26 17:46:18.246269	2781
efff145d-5625-4a2c-ac23-ffdccad3e85b	2.62	107.54	3.5	1.35	2026-04-26 17:46:18.246269	2782
1a64a717-44a3-4308-9eaa-d6a37163544c	2.45	90.42	2.03	1.3	2026-04-26 17:46:18.246269	2783
474c6490-57e2-4c5c-ad69-dc1c4cf6b1f5	0.9	118.4	1.3	2.85	2026-04-26 17:46:18.246269	2784
7f85773c-30b2-4ff2-877a-93f568213806	2.64	66.58	1.6	2.25	2026-04-26 17:46:18.246269	2785
4d87ace7-e3ee-4ea4-92f6-c395ef501428	0.72	131.81	2.89	2.19	2026-04-26 17:46:18.246269	2786
4d289278-e3f8-42ed-af6a-2d3259072f3f	2.99	262.2	3.29	2.53	2026-04-26 17:46:18.246269	2787
ebffe864-14eb-465e-b745-192f6e5717bf	1.81	105.57	2.17	1.57	2026-04-26 17:46:18.246269	2788
fb9a49ca-e5e2-4be1-9e2c-5d77c4db770b	1.17	217.91	1.55	1.14	2026-04-26 17:46:18.246269	2789
150f7991-fbd0-429e-bdf9-c60b50b1aae6	2.97	88.12	3.64	2.36	2026-04-26 17:46:18.246269	2790
569b5e54-a5e6-442c-94e0-64a8245dcd07	3.07	231.32	2.32	2.79	2026-04-26 17:46:18.246269	2791
1525c80d-cf06-4108-bab9-0205f6ed78f7	0.98	53.31	3.52	1.24	2026-04-26 17:46:18.246269	2792
c6e7314c-8525-4191-80c2-2c3a921f415d	3.16	299.1	3.09	1.76	2026-04-26 17:46:18.246269	2793
01d04063-d9c3-43b8-9cd1-f2c365206958	1.73	244.8	3.8	2.89	2026-04-26 17:46:18.246269	2794
688a8c3f-fa38-4308-89d5-212d6faf8a77	2.11	91.9	2.3	2.68	2026-04-26 17:46:18.246269	2795
80f0e0e1-a56b-4969-9328-300dd7d3889e	1.83	149.65	2.35	2.37	2026-04-26 17:46:18.246269	2796
bf4c1fb6-a269-4569-be90-6b6a998ee7b9	0.78	114.95	2.37	2.54	2026-04-26 17:46:18.246269	2797
4421a7a4-be54-4494-b732-9068a725e9b7	1.04	125.75	3.89	2.66	2026-04-26 17:46:18.246269	2798
5d9bfdd7-0a23-41a4-bff6-1d1b588e6b78	2.23	216.01	1.48	1.14	2026-04-26 17:46:18.246269	2799
9272aa0e-60be-48a7-b1a9-e260a3fcd3d2	2.5	166.54	1.18	1.5	2026-04-26 17:46:18.246269	2800
cd6c4c38-b00a-4644-b1a1-7fc4b8c0ef46	0.74	133.23	3.47	2.08	2026-04-26 17:46:18.246269	2801
903c34b0-9809-44ee-af0c-97ca045cde31	1.39	207.97	3.24	1.93	2026-04-26 17:46:18.246269	2802
ec564929-5d5d-4964-85c9-c2c00181550b	2.39	240.77	3.99	1.26	2026-04-26 17:46:18.246269	2803
eb5b0417-51b7-4630-89a7-fbac16715f99	2.35	252.63	2.92	2.17	2026-04-26 17:46:18.246269	2804
2f71377b-f84e-4d62-a2dd-610ad858eff9	0.68	54.34	1.76	2.4	2026-04-26 17:46:18.246269	2805
ccefa4d3-0ac6-49b4-b548-44dbecf95314	2.04	270.23	2.39	2.81	2026-04-26 17:46:18.246269	2806
641085c9-c0f6-4e22-ba3b-1fb94f36d101	1.67	225.06	2.95	2.59	2026-04-26 17:46:18.246269	2807
98771193-9965-407f-9a85-7fede6b77203	1.35	96.89	2.77	2.14	2026-04-26 17:46:18.246269	2808
a4f48f59-b6eb-49b5-bda3-c4cbe0959ccc	0.99	155.47	1.72	2.12	2026-04-26 17:46:18.246269	2809
349fd483-5e87-4860-902e-0499901d0595	3.16	92.58	1.52	2.56	2026-04-26 17:46:18.246269	2810
9c9909c7-05a2-4227-acf9-28521c0da135	2.27	81.24	1.92	2.64	2026-04-26 17:46:18.246269	2811
f305ad8e-b6cd-4ccb-8d44-e33845a294a1	1.15	103.91	3.75	2.77	2026-04-26 17:46:18.246269	2812
baa2883c-e58b-4231-a08f-44235a4dea80	1.97	128.24	3.28	1.88	2026-04-26 17:46:18.246269	2813
0d8f1e65-863d-45d8-bd85-f7a7bb2a19d6	1.81	143.99	3.19	1.7	2026-04-26 17:46:18.246269	2814
1274b8fd-1c04-42fe-ae89-7ee5494a8909	2.36	159.28	2.75	1.77	2026-04-26 17:46:18.246269	2815
177aba49-3dfa-4284-870d-fb28b84d4534	1.65	273.97	1.44	2.69	2026-04-26 17:46:18.246269	2816
a3e55969-7679-400e-b2f8-63e2955e54c2	0.69	160.19	1.71	1.86	2026-04-26 17:46:18.246269	2817
ccea675a-ef56-4f85-b8c5-317c8ce5a850	2.59	242.9	3.27	1.87	2026-04-26 17:46:18.246269	2818
3aa10c1e-2460-4377-b65a-f47990cf20a4	3.04	276.63	3.06	2.55	2026-04-26 17:46:18.246269	2819
95049103-faa4-4e21-9165-033861d9c488	0.82	82.88	2.98	1.49	2026-04-26 17:46:18.246269	2820
2c47bb0c-f0bc-43ef-97b7-ec4d8c96c29f	0.79	280.72	2.37	2.55	2026-04-26 17:46:18.246269	2821
c1b55a4f-d015-496a-97a5-0eda929e3dc3	1.44	283.74	1.61	2.32	2026-04-26 17:46:18.246269	2822
b8174b2e-1cb1-472c-ac48-c2a6912e48de	2.55	60.56	1.48	2.94	2026-04-26 17:46:18.246269	2823
ef342171-814f-4d88-ba4b-9c3e820c63de	2.29	154.56	3.12	1.18	2026-04-26 17:46:18.246269	2824
ff142781-a79f-4ff4-a703-7732aa9af9e3	3	223.47	3.74	2.25	2026-04-26 17:46:18.246269	2825
53988c3d-02b2-4be9-95b5-739ffb19f562	1.84	274.87	3.35	2.69	2026-04-26 17:46:18.246269	2826
90e0676d-9543-455e-b95b-033a3dc29094	2.31	56.03	2.38	2.05	2026-04-26 17:46:18.246269	2827
aa53d45e-4f36-4897-b499-3ed698190647	3.45	142.33	3	1.42	2026-04-26 17:46:18.246269	2828
0d2cac97-cb24-4e98-8c0f-4356b3e97f0a	3.29	252.42	1.04	1.28	2026-04-26 17:46:18.246269	2829
3781bb39-94d7-41ab-bddb-e6008d65fc3e	2.99	296.19	2.63	2.8	2026-04-26 17:46:18.246269	2830
9c7b719e-b70f-4394-9ff1-ed98e6b5cc58	2.53	51.45	2.29	2.74	2026-04-26 17:46:18.246269	2831
e7450082-184d-42e5-9e10-1ba889b81e15	2.72	113.41	2.93	1.96	2026-04-26 17:46:18.246269	2832
7f8cdea0-97fa-4f5c-a07d-339312618900	1.99	268.27	3.9	2.62	2026-04-26 17:46:18.246269	2833
1cdd7dbf-0fb2-4741-b2ce-1648f6588f83	0.96	81.85	1.13	2.34	2026-04-26 17:46:18.246269	2834
addb0a76-380c-4a6e-81a0-5642a291744d	1.21	161.56	2.18	1.27	2026-04-26 17:46:18.246269	2835
37353a0a-b1de-4f16-ade8-742e357bff71	1.9	203.02	2.37	2.29	2026-04-26 17:46:18.246269	2836
d806cbd2-e0cc-4e83-84a5-7e939ebd4b95	1.97	130.76	2.05	2.35	2026-04-26 17:46:18.246269	2837
84970f72-5d25-45d2-96d7-3ed2f3315168	2.92	139.63	1.93	1.05	2026-04-26 17:46:18.246269	2838
80fbbed9-4a78-4bd2-87e9-af704fc2de31	2.45	68.31	1.04	2.44	2026-04-26 17:46:18.246269	2839
8a2c8802-0ed7-4c68-b865-2b6b9b4e467b	0.53	286.96	1.69	2.7	2026-04-26 17:46:18.246269	2840
92491d57-33b8-476b-b82f-4d782b7925be	2.56	283.5	3.78	1.28	2026-04-26 17:46:18.246269	2841
101a0017-9d06-4cab-9376-10fca55b80fe	2.19	183.06	2.5	2.71	2026-04-26 17:46:18.246269	2842
7a670221-9a34-46e2-b81b-1d7085b29ac8	2.57	57	1.2	1.85	2026-04-26 17:46:18.246269	2843
b486f1ad-7297-436a-929a-3696998a7284	0.55	195.91	3.76	1.31	2026-04-26 17:46:18.246269	2844
ef7e5768-abc3-451c-8700-eadd22e0526f	3.4	289.23	2.74	2.78	2026-04-26 17:46:18.246269	2845
63993198-0f2e-4909-b4ec-c6e6b29c10e1	2.62	264.05	2.59	2.28	2026-04-26 17:46:18.246269	2846
785054cb-4641-468e-b119-e344676aba22	3.03	187.39	3.34	1.95	2026-04-26 17:46:18.246269	2847
2641930a-9a92-4a93-a28c-017fc48fc1b3	3.17	149.84	3.79	2.88	2026-04-26 17:46:18.246269	2848
4a2d3659-552c-4773-9281-2b75e2ba4bb6	2.13	62.09	2.95	2.34	2026-04-26 17:46:18.246269	2849
78beb24a-058f-4cc9-864c-1d33949d4818	1.77	86.22	1.65	1.53	2026-04-26 17:46:18.246269	2850
0889297c-d685-4c5d-bfc9-bba36110c15d	2.47	116.49	2.16	2.18	2026-04-26 17:46:18.246269	2851
acef61e7-7f4b-4b30-b6c5-425f9e36a90e	3.12	119.86	2.26	2.78	2026-04-26 17:46:18.246269	2852
186f60d6-c7c7-467f-b4fe-fa7636f79a23	0.79	71.35	3.87	1.35	2026-04-26 17:46:18.246269	2853
4079e5e0-9e84-4432-b44a-32af8e59d4b6	2.22	138.76	3.42	2.89	2026-04-26 17:46:18.246269	2854
29a4907b-3872-4537-b4c9-a42ef3e28b0e	2.12	288.77	1.28	2.49	2026-04-26 17:46:18.246269	2855
0881dc31-d7be-4ddb-99c9-8b6d0fa16990	2.61	93.3	2.02	2.89	2026-04-26 17:46:18.246269	2856
89e3921f-88ff-4fa8-9092-9e3260a671eb	1.16	286.59	2.39	1.31	2026-04-26 17:46:18.246269	2857
22899238-2cb3-4920-ad5f-d00408f74869	1.44	191.28	1.53	1.52	2026-04-26 17:46:18.246269	2858
69b47d8f-7fea-4be2-b860-28261bd322a8	1.14	228.89	1.63	1.47	2026-04-26 17:46:18.246269	2859
ed04eb26-1f11-4e73-bf37-9045f051da24	2.92	265.42	3.16	2.75	2026-04-26 17:46:18.246269	2860
82b0280e-102f-4227-8bdc-035191a662da	2.44	191.27	1.46	1.49	2026-04-26 17:46:18.246269	2861
fc3455ee-1aca-499b-a15a-59daa28c0dae	0.93	141.91	1.42	1.84	2026-04-26 17:46:18.246269	2862
73844c9a-3cfa-47e8-a779-2fd0f85cd1a4	1.17	296.9	1.29	1.95	2026-04-26 17:46:18.246269	2863
1395deb5-7679-416b-8a65-aaf8e835d7c3	1.72	293.59	3.87	2.69	2026-04-26 17:46:18.246269	2864
6b95825f-39e7-468c-9658-f24c248a95ab	1.43	278.1	1.68	1.27	2026-04-26 17:46:18.246269	2865
ce7492b2-e891-474e-a19c-33b127c341bd	2.82	105.25	3.59	2.54	2026-04-26 17:46:18.246269	2866
29b851bc-bf09-44a9-8b92-fd986cecff07	2.8	86.01	3.36	1.62	2026-04-26 17:46:18.246269	2867
18bd7af5-1bd8-4924-b5c8-04e122688eb3	2.11	206.41	2.15	2.4	2026-04-26 17:46:18.246269	2868
0901b3ca-de69-4dc6-8669-6257957ae39e	1.71	57.39	1.73	2.72	2026-04-26 17:46:18.246269	2869
ecb61af6-0fbb-4eb0-bea9-b8c9f2fb8c69	1.4	159.57	2.66	1.66	2026-04-26 17:46:18.246269	2870
fa086000-f37b-4715-a2af-e114d3776051	2.8	104.84	2.18	2.78	2026-04-26 17:46:18.246269	2871
0ebae568-62bd-4e44-9ff7-798a7cf02baa	2.22	293.83	2.62	1.1	2026-04-26 17:46:18.246269	2872
8c5171fd-392e-49b3-9c7a-cac95ad4b712	1.58	89.26	1.83	1.48	2026-04-26 17:46:18.246269	2873
00b72f94-9185-4684-b9c9-7391caff4082	2.1	60.91	1.21	2.45	2026-04-26 17:46:18.246269	2874
4108c416-a720-408e-b90c-c674d5e86d0c	2.41	141.1	2.58	2.93	2026-04-26 17:46:18.246269	2875
d930d57f-4865-49e1-b97c-e8d38ea33778	2.6	225.2	2.08	2.24	2026-04-26 17:46:18.246269	2876
94ee1380-d4a5-45d7-aca4-98acc362d2ea	2.69	202.97	1.5	1.31	2026-04-26 17:46:18.246269	2877
fdc902c2-6087-4d6f-80c4-06dc3417dd09	0.79	82.97	2.15	1.34	2026-04-26 17:46:18.246269	2878
a8c53a76-9bd2-4da8-bcc2-507bf0391475	0.87	150.94	3.89	2.13	2026-04-26 17:46:18.246269	2879
ec48173e-93eb-43f2-986b-837f4d9ea0a3	1.4	146.84	3.87	2.2	2026-04-26 17:46:18.246269	2880
4cf14171-7f85-401b-a1ed-240a930297d6	2.43	131.82	2.08	1.55	2026-04-26 17:46:18.246269	2881
5e2c38bc-5335-4dcc-b5fd-60f7c7da1f1d	1.72	201.18	1.65	1.77	2026-04-26 17:46:18.246269	2882
6d78a687-8013-4ecd-8edc-b3eaf641d308	0.77	112.91	1.33	1.26	2026-04-26 17:46:18.246269	2883
b4db985f-3cb5-4e0b-8269-75c0205a4a76	1.51	266.7	2.62	2.75	2026-04-26 17:46:18.246269	2884
e740dd73-61ff-47b3-b096-021863c558ef	0.75	292.99	1.48	2.85	2026-04-26 17:46:18.246269	2885
f0f9852b-d33b-4d90-85f0-2672b9b52d4a	2.93	289.28	1.35	2.53	2026-04-26 17:46:18.246269	2886
f7edc0a3-fffa-4af1-94d2-7ae07b266ec2	3.18	112.11	3.55	2.4	2026-04-26 17:46:18.246269	2887
bfcf2856-cd19-4b19-9e9c-310f6f0c9823	2.77	127.68	1.97	2.93	2026-04-26 17:46:18.246269	2888
3bf47c34-9cd2-4cac-a2f2-72a77040dc8b	1.03	145.62	2.67	1.3	2026-04-26 17:46:18.246269	2889
f025cb63-fae9-478d-afac-8cd17a79f540	2.41	143.82	3.18	1.84	2026-04-26 17:46:18.246269	2890
ddfcdeb7-606a-45f0-97b5-cb4b4ea01288	0.98	296.34	2.92	1.82	2026-04-26 17:46:18.246269	2891
bf95b772-5939-480b-9689-b8de3b17819c	3.22	122.22	2.24	1.77	2026-04-26 17:46:18.246269	2892
79fae5b0-e815-4e6b-979c-3d40dcf82296	2.12	288.34	2.76	2.9	2026-04-26 17:46:18.246269	2893
ab8c21a9-bb71-4b4f-aead-976a688c8f5b	1.27	296.05	1.13	1.47	2026-04-26 17:46:18.246269	2894
f9ad0b21-3622-4955-864f-b6acb6a20375	1.12	58.09	2.98	1.49	2026-04-26 17:46:18.246269	2895
aef0ef1f-cf70-43c3-8f1d-741c39e1a0e6	3.14	51.12	3.72	2.64	2026-04-26 17:46:18.246269	2896
116f0b0c-99bc-4284-be34-a8763f08c3ab	2.55	249.11	1.72	2.41	2026-04-26 17:46:18.246269	2897
303c7791-8997-4438-ace3-bd9a7a7af3c4	1.62	106.35	1.42	1.38	2026-04-26 17:46:18.246269	2898
a46cee26-7552-4afd-a7d4-5ca99238e8e8	1.53	154.06	3.45	2.14	2026-04-26 17:46:18.246269	2899
9cb18f9e-63fe-4579-a41e-e5f782f33987	1	79.23	1.4	1.41	2026-04-26 17:46:18.246269	2900
a418ca68-e9f5-4739-a62d-33c94119c313	1.23	205.09	3.94	1.8	2026-04-26 17:46:18.246269	2901
77a3d378-3dea-4aa3-a7f5-7d85a45b2b08	1.1	125.24	3.82	1.11	2026-04-26 17:46:18.246269	2902
796992b1-1d1c-4c72-b5d0-2f661bcdd5ca	1.39	169.48	2.44	2.97	2026-04-26 17:46:18.246269	2903
d120b9a3-e088-4a57-b7ca-0f1e5f0bbc37	2.29	268.36	1.71	1.45	2026-04-26 17:46:18.246269	2904
bb26c4bd-6b5f-4541-9263-5ffa9ce44a38	3.48	280.75	1.92	2.48	2026-04-26 17:46:18.246269	2905
da38da3e-9316-49d8-af58-cfca2be2ecea	2.7	189.67	2.98	2.48	2026-04-26 17:46:19.955071	2906
8d34dd99-e669-4ca7-99af-1d91991a09c9	0.86	256.28	3.72	2.22	2026-04-26 17:46:19.955071	2907
8d34dd99-e669-4ca7-99af-1d91991a09c9	0.86	256.28	3.72	2.22	2026-04-26 17:46:19.955071	2908
db738178-6c85-4003-814c-43efae201f66	3.22	115.16	2.39	1.92	2026-04-26 17:46:19.955071	2909
db738178-6c85-4003-814c-43efae201f66	3.22	115.16	2.39	1.92	2026-04-26 17:46:19.955071	2910
083b503f-bc9a-4761-9232-985118e3bde4	0.95	101.42	2.37	1.66	2026-04-26 17:46:20.978765	2911
84898f92-b30c-4251-99c5-6d4b8ee07428	2.15	274.37	3.34	1.73	2026-04-26 17:46:20.978765	2912
1798c0d0-79e4-4d2b-9f3f-990b125d2105	2.9	248.58	1.09	2.11	2026-04-26 17:46:20.978765	2913
d4454c95-37c1-4467-a22e-9fb7abac08a2	0.97	144.51	3.77	2.47	2026-04-26 17:46:20.978765	2914
1dc79f19-741d-4d47-8552-5e53debeed00	3.03	214.74	1.35	2.58	2026-04-26 17:46:20.978765	2915
127074f4-ef1e-44c6-b9d4-6e159522fe6d	2.94	93.92	3.84	2.4	2026-04-26 17:46:20.978765	2916
933c3358-c4a9-4190-ba36-d320f41b28bd	2.23	56.92	3.51	1.09	2026-04-26 17:46:20.978765	2917
24c4b5e6-9375-4a3d-aa2e-8ecf73311e2a	0.99	189.37	1.32	1.34	2026-04-26 17:46:20.978765	2918
8459b204-828a-433c-946a-16940b23fe20	3.09	85.58	2.43	2.26	2026-04-26 17:46:20.978765	2919
6c67de4d-14df-473a-b5b7-234ca1892d36	3.3	94.8	2.6	1.61	2026-04-26 17:46:20.978765	2920
1a1da762-8b17-44fc-ab54-aacee70233c0	2.45	154.05	2.11	1.09	2026-04-26 17:46:20.978765	2921
eaf83308-161d-4cbe-9a8f-c87d75ee5421	1.23	193.48	2.03	2.96	2026-04-26 17:46:20.978765	2922
2639cd66-3527-4a6d-b26e-dfb2491c1bf2	1.66	198.34	2.56	1.31	2026-04-26 17:46:20.978765	2923
8d34dd99-e669-4ca7-99af-1d91991a09c9	2.49	272.62	2.02	1.46	2026-04-26 17:46:20.978765	2924
77398e9d-8c73-4cfb-9019-93696911c12d	1.28	149.33	1.4	2.31	2026-04-26 17:46:20.978765	2925
af79ed93-81e1-4dad-ab43-483f230ed7d4	0.56	291.31	3.68	2.61	2026-04-26 17:46:20.978765	2926
a09b5914-31d8-4628-bfde-a2ed4f60f907	0.54	224.51	1.33	1.83	2026-04-26 17:46:20.978765	2927
af5d64a0-8fd6-4135-9b5c-ed9a17afe722	3.5	93.71	2.84	2.84	2026-04-26 17:46:20.978765	2928
48f2ef4f-6f48-4a5a-8aca-e2844be19a4d	3.36	99.53	3.16	2.31	2026-04-26 17:46:20.978765	2929
c4a5295a-ac7e-4505-ae47-069a3a50ecec	1.3	126.99	1.55	2.41	2026-04-26 17:46:20.978765	2930
0cdc07b0-d122-4345-a871-ed8736125a13	2.46	234.61	2.8	1.59	2026-04-26 17:46:20.978765	2931
8be3185b-bc1c-4142-b567-48aaff220b01	3.14	59.1	3.35	1.5	2026-04-26 17:46:20.978765	2932
d9051e4d-d569-4f01-89e0-7d857762afe5	3.43	71.61	1.69	2.32	2026-04-26 17:46:20.978765	2933
3fad7c09-4ab3-4a8b-aa29-7211513f7237	2.28	218.77	1.91	1.53	2026-04-26 17:46:20.978765	2934
dbbf360e-7216-4601-8614-038fe1dcc2ba	3.17	158.29	3.92	2.12	2026-04-26 17:46:20.978765	2935
9bd9f3c5-1b49-4927-8cdf-35373636ae00	3.45	125.54	1.61	1.81	2026-04-26 17:46:20.978765	2936
160d3adf-6a5a-4442-8c35-f8ff730e0036	1.98	133.68	2.14	2.95	2026-04-26 17:46:20.978765	2937
5c42027f-8aaa-441b-990e-215c05fc0300	0.82	121.38	1.38	1.53	2026-04-26 17:46:20.978765	2938
bfc1d7fb-6dd6-42fd-a795-053bca272428	1.78	70.3	3.33	1.7	2026-04-26 17:46:20.978765	2939
fe19663b-26a2-40d0-a329-bf3f1f6a25a6	1.84	134.66	3.03	1.22	2026-04-26 17:46:20.978765	2940
09bcbc34-b01a-4878-88ae-4aac9ea91b2d	3.44	257	1.88	2.65	2026-04-26 17:46:20.978765	2941
28aa7be3-ebf0-4bfb-9e4d-8eb57e7a1a09	1.23	213.92	1.81	1.13	2026-04-26 17:46:20.978765	2942
a463568f-08c1-4eee-ba9f-87eca478959e	2	95.67	2.25	2.28	2026-04-26 17:46:20.978765	2943
e91e2255-deed-4ffc-9e86-da19ee4fe2be	2.74	121.91	1.97	2.71	2026-04-26 17:46:20.978765	2944
e6c3818b-29f0-4e36-9052-5e1482339405	2.21	174.86	1.78	2.04	2026-04-26 17:46:20.978765	2945
80d81f80-2426-4c17-9e8a-321da7361798	1.36	87	3.16	1.53	2026-04-26 17:46:20.978765	2946
6f817b31-ed87-46bb-9e2e-1140f4cb4cbb	2.25	232.49	2.46	1.42	2026-04-26 17:46:20.978765	2947
34c9e297-d7dc-4168-a5a5-8e7e148dcbbd	2.42	213.48	2.21	1.85	2026-04-26 17:46:20.978765	2948
06c52bbf-cbe5-4db7-997a-9f747283665e	2.69	117.19	2.3	2.86	2026-04-26 17:46:20.978765	2949
0404794e-0a50-4824-a0ee-921cb23888ee	2.73	72.5	2.73	2.91	2026-04-26 17:46:20.978765	2950
ff75e776-7227-4220-9f32-33a6013ae67f	2.67	209.6	1.03	2.74	2026-04-26 17:46:20.978765	2951
522e7eca-7dde-4bb5-9cfd-7bfc1f5aa823	1.87	171.12	2.49	1.95	2026-04-26 17:46:20.978765	2952
0670c059-cbff-4d6e-97fa-c2dbd81ba878	2.85	219.98	2.97	2.22	2026-04-26 17:46:20.978765	2953
41623b9e-303f-46b1-82d3-8883c4a479bb	3.19	228.7	3.12	1.43	2026-04-26 17:46:20.978765	2954
8425054a-27fe-45f7-a2d1-0ca5bb87c22d	2.33	173.59	3.03	2.5	2026-04-26 17:46:20.978765	2955
88f2dc8f-4748-490e-b92d-e31ba6ddaf7b	2.39	230.39	3.09	1.76	2026-04-26 17:46:20.978765	2956
71e03cf9-1c81-44c0-9c0f-63591e58aa30	2.93	275.44	1.91	2.25	2026-04-26 17:46:20.978765	2957
bc2f02a5-cb1e-4610-ac0e-ba7f24c18ccd	3.49	114.11	1.71	2.28	2026-04-26 17:46:20.978765	2958
c110010b-1088-4e02-be3c-83c511d7831c	1.46	262.87	2.92	2.56	2026-04-26 17:46:20.978765	2959
fe8407a5-d6f0-4b63-b0c1-71ad87ffab96	1.59	75.28	3.67	2.91	2026-04-26 17:46:20.978765	2960
19646a15-fc51-45ea-b837-9703ea5e5f8c	2.74	87.37	3.2	2.1	2026-04-26 17:46:20.978765	2961
048313b2-21ec-4fbc-be08-2f0c27fa77f6	1.45	125.39	3.32	1.42	2026-04-26 17:46:20.978765	2962
66ae13b0-bc41-401b-919a-a47c2d82b9ef	3.48	191.98	1.49	2.46	2026-04-26 17:46:20.978765	2963
d87f65c7-d638-4f26-a825-aff5ae57457b	0.56	77.77	2.66	2.95	2026-04-26 17:46:20.978765	2964
7931d397-9cb6-40aa-888c-6b1cfe481a74	2.86	129.89	1.77	1.84	2026-04-26 17:46:20.978765	2965
a63e2468-ff52-45a6-a5cd-59944a3859bb	1.85	225.29	3.14	2.31	2026-04-26 17:46:20.978765	2966
2c170f3c-70f5-4432-9675-baa82539a713	2.95	192.17	3.53	2.14	2026-04-26 17:46:20.978765	2967
a49a8d86-d915-4488-b843-de71b33e91fd	0.92	258.01	2.07	2.7	2026-04-26 17:46:20.978765	2968
b2cd1843-50e3-475c-b68b-24bcf035d14a	0.62	56.96	1.55	1.49	2026-04-26 17:46:20.978765	2969
49214cd6-15b3-43e2-b004-f11980bd76e7	2.49	126.12	2.74	1.53	2026-04-26 17:46:20.978765	2970
da38da3e-9316-49d8-af58-cfca2be2ecea	2.04	280.45	3.06	1.79	2026-04-26 17:46:20.978765	2971
06e503be-bdf4-4afe-9252-ad4307d77d34	1.08	109.87	3.42	2.97	2026-04-26 17:46:20.978765	2972
e07bf42f-e0df-4ae0-8b19-59673c872bf2	1.09	283.09	1.67	2.95	2026-04-26 17:46:20.978765	2973
d9ff0e43-523c-4157-b412-c6e488086313	2.06	165.12	1.25	2.57	2026-04-26 17:46:20.978765	2974
73605445-18c0-4c79-aa20-abe75a2aa504	0.59	115.93	1.41	2.1	2026-04-26 17:46:20.978765	2975
17d1d4a8-7fff-4e9d-be6b-1ad8cff6ebd6	2.72	215.93	1.43	1.52	2026-04-26 17:46:20.978765	2976
0ff59da4-ea9a-48c5-9b60-96f17e2644b7	3.4	298.56	3.12	1.87	2026-04-26 17:46:20.978765	2977
0c867821-28e1-489c-96ef-a33a16f96004	1.97	169.53	3.31	1.97	2026-04-26 17:46:20.978765	2978
6111d377-0b6c-4d93-b288-f7ebce6c00fc	1.64	234.1	1.3	1.21	2026-04-26 17:46:20.978765	2979
18905b39-d6a0-4f41-8c02-9b817e1b009d	0.67	131.08	1.73	1.06	2026-04-26 17:46:20.978765	2980
8b417aee-680e-4081-85f2-5a160fb2ff12	1.02	293.76	2.46	2.18	2026-04-26 17:46:20.978765	2981
38b482a7-1f32-4ddc-9349-bcf1da86d546	2.9	193.24	1.19	2.59	2026-04-26 17:46:20.978765	2982
02152a87-fd48-4156-bd2f-afe94c4dc7a6	3.26	88.4	3.41	2.26	2026-04-26 17:46:20.978765	2983
6a47fed4-5e33-425c-bbc6-691c625d33a7	1.11	130.46	2.79	1.06	2026-04-26 17:46:20.978765	2984
79cd4a3f-adcf-4ce5-9d29-62693c93adf2	0.78	54.41	1.86	2.82	2026-04-26 17:46:20.978765	2985
c4391873-3533-4cad-977b-0323fced348e	1.68	288.89	3.9	1.49	2026-04-26 17:46:20.978765	2986
c6338c80-214f-405b-9b0b-7594bb69d230	3.49	254.09	2.7	1.72	2026-04-26 17:46:20.978765	2987
382f3f60-7d3c-4ffc-8b2f-94ce32b77254	1.37	166.64	2.52	2.29	2026-04-26 17:46:20.978765	2988
cf827a4b-a720-4825-84d4-29f047763f7e	0.99	182.08	3.55	2.25	2026-04-26 17:46:20.978765	2989
d5806c60-9752-4845-9128-964d9b723f0b	3.03	82.75	1.91	2.02	2026-04-26 17:46:20.978765	2990
96e0af22-02e2-46d4-8224-4db162bd27b6	1.13	142.7	3.74	2.57	2026-04-26 17:46:20.978765	2991
9d0c77f5-485a-477d-80ec-8da875eb9852	1.63	151.33	2.67	1.52	2026-04-26 17:46:20.978765	2992
c19c4f6a-3738-436e-b7dc-b27df3129b28	0.63	103.63	2.75	2.29	2026-04-26 17:46:20.978765	2993
2d78aa7b-b8fb-4cc0-9d8a-f6a927032041	2.89	182.94	1.84	1.69	2026-04-26 17:46:20.978765	2994
dbebf850-836f-4532-807c-c1e3f5b5d597	0.62	206.59	3.02	1.46	2026-04-26 17:46:20.978765	2995
453f03e0-cb8d-4681-b343-d681f27e84f8	0.83	257.74	3.34	2.06	2026-04-26 17:46:20.978765	2996
13d5f24a-3280-4db1-ae8d-4e7ac37dca9d	1.22	113.85	3.88	1.43	2026-04-26 17:46:20.978765	2997
40f8a8d7-327f-4f20-a15c-cbd9fb6f5e75	2.32	244.33	2.92	1.37	2026-04-26 17:46:20.978765	2998
8cfcaf67-4ae0-46c6-996e-6ce551b4096d	2.16	293.49	1.05	1.82	2026-04-26 17:46:20.978765	2999
05bb5c72-6613-4d45-a876-a6c5fb64222e	2.58	280.42	3.57	2.41	2026-04-26 17:46:20.978765	3000
37b80a41-5dec-4adb-ac19-126072ec4a13	0.6	73.99	1.71	1.87	2026-04-26 17:46:20.978765	3001
514c19e7-d8eb-4f8a-b58c-db01659e571e	1.65	138.77	3.31	1.47	2026-04-26 17:46:20.978765	3002
27ded357-dfee-45c6-844b-2108e05a105b	1.89	181.6	3.33	1.08	2026-04-26 17:46:20.978765	3003
affc16bb-f7a4-4ff2-90df-48caf7eebddc	2.01	54.74	1.73	2.47	2026-04-26 17:46:20.978765	3004
cb0fe3b7-fbc8-479b-bd12-6acfeeeeffeb	1.25	232.1	1.18	1.56	2026-04-26 17:46:20.978765	3005
c0f13516-b42b-4edf-8d54-260ed3432c91	2.07	204.44	2.88	1.74	2026-04-26 17:46:20.978765	3006
a6b3ffd9-c2dc-4bf3-872f-1d4dfaff44ce	1.64	130.43	3.85	2.85	2026-04-26 17:46:20.978765	3007
4c18584e-0e3e-40cc-94a4-dd6106965efb	0.55	62.68	3.56	1.95	2026-04-26 17:46:20.978765	3008
42be6f12-2662-427d-b3bb-9f8fb042cde5	2.62	173.83	3.03	2.42	2026-04-26 17:46:20.978765	3009
a9a3a5fa-5c98-4e69-883b-2afa82b1877f	1.16	95.27	3.18	1.33	2026-04-26 17:46:20.978765	3010
69ceb13d-c6ba-480a-9bb6-8c94350b80bb	0.82	57.62	1.78	2.59	2026-04-26 17:46:20.978765	3011
6946eb18-50ec-477c-808d-f71c98670e15	1.58	188.78	2.97	1.12	2026-04-26 17:46:20.978765	3012
db738178-6c85-4003-814c-43efae201f66	2.26	257.49	2.16	2.81	2026-04-26 17:46:20.978765	3013
4b5f92c9-7d51-4b0e-a137-acd779a460c0	2.9	94.46	1.43	2.99	2026-04-26 17:46:20.978765	3014
343b8afa-f5f3-413a-8faf-37c6af937323	1.71	176.64	1.49	1.21	2026-04-26 17:46:20.978765	3015
aa3eddc8-b910-47a9-b691-2ec377a4b6c3	3.43	253.24	1.03	1.22	2026-04-26 17:46:20.978765	3016
10412ce9-7326-4907-98fb-f30f329eb834	1.64	190.97	1.19	2.77	2026-04-26 17:46:20.978765	3017
a7a83b3b-4904-468d-b1ff-79250bae2178	2.44	205.92	3.29	2.05	2026-04-26 17:46:20.978765	3018
de64100b-0d55-4423-8139-e21bf67b1ba3	2.34	216.26	1.77	1.92	2026-04-26 17:46:20.978765	3019
48f1cae9-db76-406a-84c3-4b1d3fd1f646	3.46	174.19	3.57	1.12	2026-04-26 17:46:20.978765	3020
bff99142-a62f-4628-a6ff-c053c6deb013	1.42	154.99	2.41	2.55	2026-04-26 17:46:20.978765	3021
fb073968-3588-453a-85e2-75089d4c03f1	2.56	145.3	3.4	2.52	2026-04-26 17:46:20.978765	3022
377f4e07-93cb-4351-8c6b-62851338fdb0	2.06	199.85	2.07	2.33	2026-04-26 17:46:20.978765	3023
19bdfc5a-e1d0-463a-b163-7d7a692f73b8	0.85	93.01	1.78	2.68	2026-04-26 17:46:20.978765	3024
cbd20eb0-7239-4734-b82b-404600e7d66b	3.47	234.54	3.37	1.41	2026-04-26 17:46:20.978765	3025
18c3479d-2072-411f-8d91-9a580608c627	0.52	98.65	2.08	2.14	2026-04-26 17:46:20.978765	3026
ca09ced3-7738-4c9e-887f-d34312c3d8e4	1.92	180.94	3.88	2.81	2026-04-26 17:46:20.978765	3027
07a6b221-981a-4cce-bb5d-3d5a872c97b7	0.71	295.14	4	1.35	2026-04-26 17:46:20.978765	3028
fa753e0b-bcb9-41b7-9c82-6fccd2333db1	1.88	282.23	3.27	2.72	2026-04-26 17:46:20.978765	3029
100a7e1e-99f2-4b0d-8a9d-842a454a612f	2.64	187.91	1.14	2.61	2026-04-26 17:46:20.978765	3030
41bd264e-1eb3-4ccb-ab43-221d92913239	1.09	245.93	2.8	1.2	2026-04-26 17:46:20.978765	3031
b80e97e3-fe08-465e-ac72-eea64d2d6182	1.21	279.99	3.33	2.79	2026-04-26 17:46:20.978765	3032
ed596397-26d6-4d02-a2f1-dbbf5f8ab704	3.27	153.57	2.9	2.82	2026-04-26 17:46:20.978765	3033
5d36c463-e893-43a2-b567-1e7fbcb3c80c	2.87	268.71	2.65	1.02	2026-04-26 17:46:20.978765	3034
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	1.09	52.43	2.73	2.94	2026-04-26 17:46:20.978765	3035
b611f2f3-4dce-4565-9634-c5f67f16841f	3.14	258.68	1.16	2.61	2026-04-26 17:46:20.978765	3036
af16d415-a7a8-426f-8d38-2ade72d8acb5	2.92	154.59	1.88	2.63	2026-04-26 17:46:20.978765	3037
a18f9d90-4ce4-4793-a9c1-9452712601a3	1.99	185.05	2.83	2.78	2026-04-26 17:46:20.978765	3038
2421d8dc-3548-4b72-b606-b235ecdf5448	0.68	123.36	1.4	1.55	2026-04-26 17:46:20.978765	3039
bb6389a5-9e20-4135-8648-8a813bb296b7	1.92	209.98	1.37	2.59	2026-04-26 17:46:20.978765	3040
6447b600-e734-4067-87b1-b915998722b4	2.02	287.21	3.97	1.95	2026-04-26 17:46:20.978765	3041
a1fc9f0b-f1e6-4819-9cb5-1ce77541a1b5	1.08	202.28	2.58	1.16	2026-04-26 17:46:20.978765	3042
25df9dd3-d744-4a1e-a96b-d1322d6952f5	0.61	285.7	3.94	2.03	2026-04-26 17:46:20.978765	3043
8e3909e7-8ee5-4db8-9278-087d2851a6f1	1.1	190.77	2.31	2.4	2026-04-26 17:46:20.978765	3044
3fcc2af3-e524-4b65-9649-cc48a58b7463	1.67	107.87	1.48	1.17	2026-04-26 17:46:20.978765	3045
3045ab21-e78f-41cf-9f96-102cfd907777	3.41	266.7	2.04	2.59	2026-04-26 17:46:20.978765	3046
211e6d92-06f3-4968-ab18-4d3606fb0313	2.96	273.86	2.01	1.65	2026-04-26 17:46:20.978765	3047
577c5ceb-5d82-4a67-914e-cc3249432558	3.07	235.23	1.32	1.38	2026-04-26 17:46:20.978765	3048
a9955bda-fedb-44d9-b5a6-33b7ceff70cc	3.44	189.45	3.42	2.09	2026-04-26 17:46:20.978765	3049
cac6b96e-6c77-4c20-b201-5d059367fbf0	2.61	97.88	1.51	2.1	2026-04-26 17:46:20.978765	3050
40b83090-1da5-4f1a-85d6-884f75d306d9	1.53	80.63	2.08	1.49	2026-04-26 17:46:20.978765	3051
af6f8bce-ab49-4a79-a40c-4a4aba8d8552	3.27	239.77	3.57	1.08	2026-04-26 17:46:20.978765	3052
7674a04d-8f67-4d07-9eab-998e344a03c9	0.76	200.23	3.58	1.7	2026-04-26 17:46:20.978765	3053
f97b5670-ef68-4a86-97c0-6385e6ae7405	1.69	114.24	3.43	1.68	2026-04-26 17:46:20.978765	3054
4fc26046-1ae2-4e60-99cf-95ef8ee6524a	3.32	296.91	3.78	2.38	2026-04-26 17:46:20.978765	3055
e332ef09-be23-4a9d-b003-f886bfae870d	2.8	200.88	1.17	1.71	2026-04-26 17:46:20.978765	3056
88f0fd74-5fbe-402b-b1f9-8b0185f9b042	0.6	221.17	1.42	2.9	2026-04-26 17:46:20.978765	3057
7289ae0e-9605-4d46-aaee-5b05ddd96e59	3.22	124.91	1.73	2.64	2026-04-26 17:46:20.978765	3058
b0318b61-a090-47a1-a30e-1f29ba099262	2.01	206.07	3.72	2.26	2026-04-26 17:46:20.978765	3059
26ec3ee2-f140-4f43-b13b-9299796dd2d1	0.8	156.95	3.55	1.28	2026-04-26 17:46:20.978765	3060
9dab24c7-177d-4ec4-8c0b-2323b92d3d4a	2.65	73.73	3.9	2.51	2026-04-26 17:46:20.978765	3061
1a6d5e85-787b-461f-8db7-9cd8f8d81ece	3.39	285.1	1.82	2.22	2026-04-26 17:46:20.978765	3062
27b23042-92c6-4a49-b397-6c200041d8ee	0.79	263.66	2.86	1.83	2026-04-26 17:46:20.978765	3063
08f0acf7-18ec-45eb-8146-8042969d5c7a	2.02	242.43	2.79	2.26	2026-04-26 17:46:20.978765	3064
a03af7ca-2046-499e-b19d-b6571e696f89	2.74	212.75	3.39	2.42	2026-04-26 17:46:20.978765	3065
e7fd011f-5572-4ee9-a3de-2d9d4d5c818d	0.84	66.09	1.57	2.93	2026-04-26 17:46:20.978765	3066
4065ab51-f74f-42a2-9363-7146df43c932	3.29	102.44	3.8	2.11	2026-04-26 17:46:20.978765	3067
a07f2ed2-35ae-4720-ad65-a22fe59566d3	0.51	299.65	2.04	1.7	2026-04-26 17:46:20.978765	3068
02c4237f-a7f5-452b-82c3-1fe296af3c3c	1	286.53	1.85	1.67	2026-04-26 17:46:20.978765	3069
62b7cf0d-cf31-493a-85aa-8fa347acda25	1.91	85.91	2.26	1.71	2026-04-26 17:46:20.978765	3070
ab3db038-d69b-451e-bba3-08e8119898b4	2.05	88.81	2.85	1.69	2026-04-26 17:46:20.978765	3071
b685932b-8a27-4288-8795-f6e05e9e4cef	3.01	93.78	3.56	1.18	2026-04-26 17:46:20.978765	3072
9cd7e4f4-8d1a-48da-abbc-075218e9e7a6	0.69	90.2	2.11	2.97	2026-04-26 17:46:20.978765	3073
98d2ddcf-4cfa-4405-9501-d661884b1017	0.58	229.21	1.97	1.47	2026-04-26 17:46:20.978765	3074
d0655207-0783-4e94-98d2-176fe26849d8	2.21	107.04	1.95	1.71	2026-04-26 17:46:20.978765	3075
bcad4d42-8a4f-4b72-a2e1-b607651d5c31	1.27	94.49	3.7	2.55	2026-04-26 17:46:20.978765	3076
9ed4929a-d3c0-4954-b272-227a89cbedec	1.28	144.86	3.82	1.59	2026-04-26 17:46:20.978765	3077
edcb7d15-e6ed-461f-b1b4-38a993ff2ec7	2.85	125.9	3.14	2.7	2026-04-26 17:46:20.978765	3078
2f5d7c02-eadd-4eb2-8dd5-46a5ba51c3f8	2.97	60.25	3.02	2.01	2026-04-26 17:46:20.978765	3079
0ad0a6eb-d13c-440c-b74c-0391605d9685	3.18	123.7	1.13	2.98	2026-04-26 17:46:20.978765	3080
2bb8c959-19b6-4951-8313-e6d0413c9a6f	2.56	207.71	2	1.93	2026-04-26 17:46:20.978765	3081
303a312c-4f87-408c-b20b-03d848ec9055	2.03	192.79	2.83	3	2026-04-26 17:46:20.978765	3082
a32bfdcd-5dd9-4a93-85e7-c1e608df83ee	1.07	244.02	3.42	2.36	2026-04-26 17:46:20.978765	3083
5ccc6390-43ca-49f5-b6fa-84247d3e52af	2.2	55.71	2.15	1.08	2026-04-26 17:46:20.978765	3084
df299e49-61f2-49ce-8051-e50cfc0b2650	1.42	240.14	1.22	1.66	2026-04-26 17:46:20.978765	3085
86ef6ade-b308-467a-8c42-3c6e4c20ec8d	3.17	260.12	1.97	1.2	2026-04-26 17:46:20.978765	3086
e318d53f-7605-468a-b41d-051070be96a3	2.9	50.17	2.41	2.36	2026-04-26 17:46:20.978765	3087
efc0c233-0113-480b-b3e6-ca3275b5ffde	2.06	264.97	3.5	1.71	2026-04-26 17:46:20.978765	3088
5808ae27-83d1-4163-9187-6a23f988dc97	1.96	138.56	1.27	2.12	2026-04-26 17:46:20.978765	3089
e304e2e6-fd72-4399-b4d7-fb6416b81f0c	1.46	189.25	3.7	1.09	2026-04-26 17:46:20.978765	3090
678ae26f-569d-4c0e-b4a9-0a688fc0936a	3.33	248.51	2.86	2.76	2026-04-26 17:46:20.978765	3091
6438657c-ee67-48b5-8de0-62eeb64e0a87	1.55	240.76	1.4	1.97	2026-04-26 17:46:20.978765	3092
e3216b17-e320-4d0f-ada0-b93e60caca02	2.52	178.03	2.38	2.7	2026-04-26 17:46:20.978765	3093
63188d13-0344-4b51-aa79-19ea416c8cdd	1.68	211.88	1.62	2.62	2026-04-26 17:46:20.978765	3094
17932bb9-836e-4db9-b27e-bd1b2f574954	3.01	206.78	2.74	1.9	2026-04-26 17:46:20.978765	3095
459418c3-7fb1-4dd5-9c2b-6a0eb1e128a7	0.73	135.51	3.26	1.68	2026-04-26 17:46:20.978765	3096
4d88229f-55e4-476b-bfc0-096795c485e4	0.7	65.71	2.22	1.04	2026-04-26 17:46:20.978765	3097
2ce612e7-1b0e-4a98-aab2-d00e087e7acd	0.72	226.81	2.84	1.12	2026-04-26 17:46:20.978765	3098
f1c04ba0-d43a-4055-8726-0674ce5a9591	1.53	234.22	2.77	2.26	2026-04-26 17:46:20.978765	3099
b4617646-5ec4-4d15-a573-c29cffb7c27f	2.64	107.61	1.75	1.38	2026-04-26 17:46:20.978765	3100
c02600b3-e48e-4409-95a3-eb683e336b10	3.34	237.09	2.97	1.93	2026-04-26 17:46:20.978765	3101
fc365d4b-670e-4fca-8c15-bed27e9c7c64	0.97	283.52	2.34	1.77	2026-04-26 17:46:20.978765	3102
b5bfff34-218c-48cd-b9ce-673eea91bda1	1.59	77.38	3.22	2.47	2026-04-26 17:46:20.978765	3103
0ef3d984-2e82-4672-bcd6-c49dfd8397b3	3.16	74.38	3.85	1.97	2026-04-26 17:46:20.978765	3104
869589e4-a12e-4a97-9558-0e078bfadd07	2.03	80.44	1.72	1.19	2026-04-26 17:46:20.978765	3105
fc37eb73-af1d-4f66-ab8d-ac6cd664ceea	0.75	173.29	2.13	1.27	2026-04-26 17:46:20.978765	3106
f182189b-b6e2-4aee-bb22-5b1e555815b6	1	277.01	3.1	1.91	2026-04-26 17:46:20.978765	3107
4a03155b-1956-495a-aa04-f02a9c3d31c8	0.61	57.12	3.73	1.81	2026-04-26 17:46:20.978765	3108
6b9cb1d4-e93d-40cb-8099-44f30eae119b	2.13	150.66	2.89	1.79	2026-04-26 17:46:20.978765	3109
77c9a885-1040-44e4-8b7c-18dccb3b1a81	1.44	275.32	2.95	1.27	2026-04-26 17:46:20.978765	3110
ab089221-71a5-4b3c-a06e-445f999eed0a	2.58	99.51	2.65	1.56	2026-04-26 17:46:20.978765	3111
2954b16d-0db5-4232-8923-ca1c2a81be0a	2.42	57.69	2.47	2.07	2026-04-26 17:46:20.978765	3112
e072183d-f51e-4965-a227-e111304e8104	0.53	76.12	1.79	2.89	2026-04-26 17:46:20.978765	3113
d59dcfa3-ec8d-4789-81cd-22e13a9c829c	2.34	74	3.58	1.42	2026-04-26 17:46:20.978765	3114
e32ad455-b5bd-49ef-b295-f81c8a11da16	2.71	256.48	2.2	2.75	2026-04-26 17:46:20.978765	3115
21d6e120-8fa3-4a51-9ade-436c7d77e075	0.71	197.19	2.06	1.24	2026-04-26 17:46:20.978765	3116
efff145d-5625-4a2c-ac23-ffdccad3e85b	3.3	295.72	3.89	2.9	2026-04-26 17:46:20.978765	3117
1a64a717-44a3-4308-9eaa-d6a37163544c	0.98	121.92	1.77	2.49	2026-04-26 17:46:20.978765	3118
474c6490-57e2-4c5c-ad69-dc1c4cf6b1f5	2.31	293.28	2.5	2.04	2026-04-26 17:46:20.978765	3119
7f85773c-30b2-4ff2-877a-93f568213806	2.16	182.64	2.67	1.13	2026-04-26 17:46:20.978765	3120
4d87ace7-e3ee-4ea4-92f6-c395ef501428	1.13	124.89	1.94	2.54	2026-04-26 17:46:20.978765	3121
4d289278-e3f8-42ed-af6a-2d3259072f3f	0.85	225.49	1.21	1.52	2026-04-26 17:46:20.978765	3122
ebffe864-14eb-465e-b745-192f6e5717bf	0.62	296.32	2.8	2.85	2026-04-26 17:46:20.978765	3123
fb9a49ca-e5e2-4be1-9e2c-5d77c4db770b	2.39	166.08	2.13	1.97	2026-04-26 17:46:20.978765	3124
150f7991-fbd0-429e-bdf9-c60b50b1aae6	2.65	246.51	1.87	2.57	2026-04-26 17:46:20.978765	3125
569b5e54-a5e6-442c-94e0-64a8245dcd07	2.66	205.87	3.36	1.56	2026-04-26 17:46:20.978765	3126
1525c80d-cf06-4108-bab9-0205f6ed78f7	0.74	102.67	3.39	1.54	2026-04-26 17:46:20.978765	3127
c6e7314c-8525-4191-80c2-2c3a921f415d	0.54	68.85	1.94	1.5	2026-04-26 17:46:20.978765	3128
01d04063-d9c3-43b8-9cd1-f2c365206958	1.33	180.89	3.59	2.27	2026-04-26 17:46:20.978765	3129
688a8c3f-fa38-4308-89d5-212d6faf8a77	3.38	267.08	2.3	1.49	2026-04-26 17:46:20.978765	3130
80f0e0e1-a56b-4969-9328-300dd7d3889e	0.7	156.91	1.59	2.36	2026-04-26 17:46:20.978765	3131
bf4c1fb6-a269-4569-be90-6b6a998ee7b9	2.96	249.28	3.27	1.23	2026-04-26 17:46:20.978765	3132
4421a7a4-be54-4494-b732-9068a725e9b7	2.7	229.6	2.9	2.03	2026-04-26 17:46:20.978765	3133
5d9bfdd7-0a23-41a4-bff6-1d1b588e6b78	3.32	65.52	2.11	1.01	2026-04-26 17:46:20.978765	3134
9272aa0e-60be-48a7-b1a9-e260a3fcd3d2	1.8	214.41	3.85	1.32	2026-04-26 17:46:20.978765	3135
cd6c4c38-b00a-4644-b1a1-7fc4b8c0ef46	2.39	203.61	1.83	1.84	2026-04-26 17:46:20.978765	3136
903c34b0-9809-44ee-af0c-97ca045cde31	2.55	142.4	3.35	2.77	2026-04-26 17:46:20.978765	3137
ec564929-5d5d-4964-85c9-c2c00181550b	2.21	273.31	1.61	2.74	2026-04-26 17:46:20.978765	3138
eb5b0417-51b7-4630-89a7-fbac16715f99	2.7	164.8	1.09	2.21	2026-04-26 17:46:20.978765	3139
2f71377b-f84e-4d62-a2dd-610ad858eff9	2.98	203.34	1.73	2.87	2026-04-26 17:46:20.978765	3140
ccefa4d3-0ac6-49b4-b548-44dbecf95314	0.68	222.74	1.64	1.66	2026-04-26 17:46:20.978765	3141
641085c9-c0f6-4e22-ba3b-1fb94f36d101	2.02	255.96	1.89	2.33	2026-04-26 17:46:20.978765	3142
98771193-9965-407f-9a85-7fede6b77203	1.11	119.31	1.06	1.75	2026-04-26 17:46:20.978765	3143
a4f48f59-b6eb-49b5-bda3-c4cbe0959ccc	3.1	133.72	2.85	2.45	2026-04-26 17:46:20.978765	3144
349fd483-5e87-4860-902e-0499901d0595	3.31	108.96	1.54	2.24	2026-04-26 17:46:20.978765	3145
9c9909c7-05a2-4227-acf9-28521c0da135	2.07	161.69	1.45	1.24	2026-04-26 17:46:20.978765	3146
f305ad8e-b6cd-4ccb-8d44-e33845a294a1	2.41	230.96	2.82	2.57	2026-04-26 17:46:20.978765	3147
baa2883c-e58b-4231-a08f-44235a4dea80	1.48	253.26	3.91	2.62	2026-04-26 17:46:20.978765	3148
0d8f1e65-863d-45d8-bd85-f7a7bb2a19d6	1.88	208.37	1.32	2.67	2026-04-26 17:46:20.978765	3149
1274b8fd-1c04-42fe-ae89-7ee5494a8909	2.38	98.45	1.46	1.69	2026-04-26 17:46:20.978765	3150
177aba49-3dfa-4284-870d-fb28b84d4534	2.79	121.03	1.2	1.23	2026-04-26 17:46:20.978765	3151
a3e55969-7679-400e-b2f8-63e2955e54c2	2.18	279.61	3.73	1.58	2026-04-26 17:46:20.978765	3152
ccea675a-ef56-4f85-b8c5-317c8ce5a850	2.35	294.28	2.6	1.59	2026-04-26 17:46:20.978765	3153
3aa10c1e-2460-4377-b65a-f47990cf20a4	1	145.24	2.68	2.18	2026-04-26 17:46:20.978765	3154
95049103-faa4-4e21-9165-033861d9c488	1.08	188.31	3.47	1.9	2026-04-26 17:46:20.978765	3155
2c47bb0c-f0bc-43ef-97b7-ec4d8c96c29f	2.03	181.2	2.8	2.17	2026-04-26 17:46:20.978765	3156
c1b55a4f-d015-496a-97a5-0eda929e3dc3	2.93	111.65	3.17	1.76	2026-04-26 17:46:20.978765	3157
b8174b2e-1cb1-472c-ac48-c2a6912e48de	0.95	169.26	3.28	1.15	2026-04-26 17:46:20.978765	3158
ef342171-814f-4d88-ba4b-9c3e820c63de	2.45	211.3	3.32	2.69	2026-04-26 17:46:20.978765	3159
ff142781-a79f-4ff4-a703-7732aa9af9e3	2.67	254.73	1.74	1.81	2026-04-26 17:46:20.978765	3160
53988c3d-02b2-4be9-95b5-739ffb19f562	2.76	230.3	1.75	1.07	2026-04-26 17:46:20.978765	3161
90e0676d-9543-455e-b95b-033a3dc29094	3.11	275.65	3.93	2.03	2026-04-26 17:46:20.978765	3162
aa53d45e-4f36-4897-b499-3ed698190647	2	147.46	1.51	3	2026-04-26 17:46:20.978765	3163
0d2cac97-cb24-4e98-8c0f-4356b3e97f0a	3.48	168.26	2.45	1.29	2026-04-26 17:46:20.978765	3164
3781bb39-94d7-41ab-bddb-e6008d65fc3e	2.98	254.91	2.92	2.76	2026-04-26 17:46:20.978765	3165
9c7b719e-b70f-4394-9ff1-ed98e6b5cc58	1.83	237.47	2.42	1.65	2026-04-26 17:46:20.978765	3166
e7450082-184d-42e5-9e10-1ba889b81e15	2.08	252.7	2.12	1.48	2026-04-26 17:46:20.978765	3167
7f8cdea0-97fa-4f5c-a07d-339312618900	0.73	118.21	3.41	2.51	2026-04-26 17:46:20.978765	3168
1cdd7dbf-0fb2-4741-b2ce-1648f6588f83	0.98	290.61	3.47	1.05	2026-04-26 17:46:20.978765	3169
addb0a76-380c-4a6e-81a0-5642a291744d	1.32	254.73	3.1	2.81	2026-04-26 17:46:20.978765	3170
37353a0a-b1de-4f16-ade8-742e357bff71	1.49	207.33	3.53	1.42	2026-04-26 17:46:20.978765	3171
d806cbd2-e0cc-4e83-84a5-7e939ebd4b95	0.81	287.46	1.7	2.64	2026-04-26 17:46:20.978765	3172
84970f72-5d25-45d2-96d7-3ed2f3315168	2.15	181.48	2.68	2.62	2026-04-26 17:46:20.978765	3173
80fbbed9-4a78-4bd2-87e9-af704fc2de31	2.07	82.75	3.72	2.09	2026-04-26 17:46:20.978765	3174
8a2c8802-0ed7-4c68-b865-2b6b9b4e467b	2.73	155.78	2.99	2.9	2026-04-26 17:46:20.978765	3175
92491d57-33b8-476b-b82f-4d782b7925be	2.05	223.08	3.93	1.27	2026-04-26 17:46:20.978765	3176
101a0017-9d06-4cab-9376-10fca55b80fe	2.92	282.27	1.99	2.74	2026-04-26 17:46:20.978765	3177
7a670221-9a34-46e2-b81b-1d7085b29ac8	3.26	146.15	3.91	1.36	2026-04-26 17:46:20.978765	3178
b486f1ad-7297-436a-929a-3696998a7284	2.32	167.73	2.66	1.24	2026-04-26 17:46:20.978765	3179
ef7e5768-abc3-451c-8700-eadd22e0526f	3.14	283.76	1.19	1.39	2026-04-26 17:46:20.978765	3180
63993198-0f2e-4909-b4ec-c6e6b29c10e1	2.77	149.46	1.59	2.72	2026-04-26 17:46:20.978765	3181
785054cb-4641-468e-b119-e344676aba22	0.65	168.38	1.37	1.24	2026-04-26 17:46:20.978765	3182
2641930a-9a92-4a93-a28c-017fc48fc1b3	2.75	236.18	1.16	1.13	2026-04-26 17:46:20.978765	3183
4a2d3659-552c-4773-9281-2b75e2ba4bb6	0.89	52.26	3.15	1.82	2026-04-26 17:46:20.978765	3184
78beb24a-058f-4cc9-864c-1d33949d4818	1.95	128.46	3.64	2.01	2026-04-26 17:46:20.978765	3185
0889297c-d685-4c5d-bfc9-bba36110c15d	3	78.59	3.96	2.69	2026-04-26 17:46:20.978765	3186
acef61e7-7f4b-4b30-b6c5-425f9e36a90e	3.45	292.33	2.29	2.37	2026-04-26 17:46:20.978765	3187
186f60d6-c7c7-467f-b4fe-fa7636f79a23	1.76	188.79	1.38	1.73	2026-04-26 17:46:20.978765	3188
4079e5e0-9e84-4432-b44a-32af8e59d4b6	0.61	52.43	1.74	2.61	2026-04-26 17:46:20.978765	3189
29a4907b-3872-4537-b4c9-a42ef3e28b0e	2.94	200.61	1.55	2.15	2026-04-26 17:46:20.978765	3190
0881dc31-d7be-4ddb-99c9-8b6d0fa16990	3.17	237.84	3.55	1.12	2026-04-26 17:46:20.978765	3191
89e3921f-88ff-4fa8-9092-9e3260a671eb	2.74	203.49	3.27	1.07	2026-04-26 17:46:20.978765	3192
22899238-2cb3-4920-ad5f-d00408f74869	3.28	211.44	2.88	2.81	2026-04-26 17:46:20.978765	3193
69b47d8f-7fea-4be2-b860-28261bd322a8	3.02	184.92	3.43	2.54	2026-04-26 17:46:20.978765	3194
ed04eb26-1f11-4e73-bf37-9045f051da24	3.15	222.27	1.56	2.7	2026-04-26 17:46:20.978765	3195
82b0280e-102f-4227-8bdc-035191a662da	1.05	207.01	3.49	1.6	2026-04-26 17:46:20.978765	3196
fc3455ee-1aca-499b-a15a-59daa28c0dae	1.51	158.44	2.48	2.77	2026-04-26 17:46:20.978765	3197
73844c9a-3cfa-47e8-a779-2fd0f85cd1a4	2.23	109.79	1.5	2.1	2026-04-26 17:46:20.978765	3198
1395deb5-7679-416b-8a65-aaf8e835d7c3	3.34	147.64	2.68	1.23	2026-04-26 17:46:20.978765	3199
6b95825f-39e7-468c-9658-f24c248a95ab	2.99	99.56	1.82	1.79	2026-04-26 17:46:20.978765	3200
ce7492b2-e891-474e-a19c-33b127c341bd	1.17	93.8	3.94	1.37	2026-04-26 17:46:20.978765	3201
29b851bc-bf09-44a9-8b92-fd986cecff07	1.21	50.11	1.66	1.55	2026-04-26 17:46:20.978765	3202
18bd7af5-1bd8-4924-b5c8-04e122688eb3	1.66	182.03	3.4	1.14	2026-04-26 17:46:20.978765	3203
0901b3ca-de69-4dc6-8669-6257957ae39e	0.73	230.1	2.29	2.91	2026-04-26 17:46:20.978765	3204
ecb61af6-0fbb-4eb0-bea9-b8c9f2fb8c69	1.81	146.27	1.58	1.16	2026-04-26 17:46:20.978765	3205
fa086000-f37b-4715-a2af-e114d3776051	3.4	285.7	3.65	1.74	2026-04-26 17:46:20.978765	3206
0ebae568-62bd-4e44-9ff7-798a7cf02baa	2.43	265.77	1.8	2.19	2026-04-26 17:46:20.978765	3207
8c5171fd-392e-49b3-9c7a-cac95ad4b712	2.74	232.79	1.22	2.02	2026-04-26 17:46:20.978765	3208
00b72f94-9185-4684-b9c9-7391caff4082	1.73	239.56	2.95	1.55	2026-04-26 17:46:20.978765	3209
4108c416-a720-408e-b90c-c674d5e86d0c	1.64	99.89	3.95	2.65	2026-04-26 17:46:20.978765	3210
d930d57f-4865-49e1-b97c-e8d38ea33778	0.81	117.67	1.38	1.06	2026-04-26 17:46:20.978765	3211
94ee1380-d4a5-45d7-aca4-98acc362d2ea	3.42	105.6	1.16	1.08	2026-04-26 17:46:20.978765	3212
fdc902c2-6087-4d6f-80c4-06dc3417dd09	1.65	117.45	1.56	2.95	2026-04-26 17:46:20.978765	3213
a8c53a76-9bd2-4da8-bcc2-507bf0391475	1.97	252.55	3.97	2.53	2026-04-26 17:46:20.978765	3214
ec48173e-93eb-43f2-986b-837f4d9ea0a3	2.13	255.76	1.39	2.59	2026-04-26 17:46:20.978765	3215
4cf14171-7f85-401b-a1ed-240a930297d6	1.01	219.73	2.7	1.91	2026-04-26 17:46:20.978765	3216
5e2c38bc-5335-4dcc-b5fd-60f7c7da1f1d	2.44	278.62	3.15	1.6	2026-04-26 17:46:20.978765	3217
6d78a687-8013-4ecd-8edc-b3eaf641d308	0.59	175.81	2.22	1.66	2026-04-26 17:46:20.978765	3218
b4db985f-3cb5-4e0b-8269-75c0205a4a76	1.06	126.31	3.62	2.19	2026-04-26 17:46:20.978765	3219
e740dd73-61ff-47b3-b096-021863c558ef	0.97	56.35	2.2	2.08	2026-04-26 17:46:20.978765	3220
f0f9852b-d33b-4d90-85f0-2672b9b52d4a	3.02	153.6	2.57	1.93	2026-04-26 17:46:20.978765	3221
f7edc0a3-fffa-4af1-94d2-7ae07b266ec2	2.19	184.43	3.57	1.51	2026-04-26 17:46:20.978765	3222
bfcf2856-cd19-4b19-9e9c-310f6f0c9823	1.69	233.2	3.19	1.48	2026-04-26 17:46:20.978765	3223
3bf47c34-9cd2-4cac-a2f2-72a77040dc8b	2.93	268.81	3.71	1.93	2026-04-26 17:46:20.978765	3224
f025cb63-fae9-478d-afac-8cd17a79f540	1.59	238.83	3.68	1.56	2026-04-26 17:46:20.978765	3225
ddfcdeb7-606a-45f0-97b5-cb4b4ea01288	3.15	71.8	3.47	1.19	2026-04-26 17:46:20.978765	3226
bf95b772-5939-480b-9689-b8de3b17819c	0.6	84.71	1.22	1.31	2026-04-26 17:46:20.978765	3227
79fae5b0-e815-4e6b-979c-3d40dcf82296	0.7	106.19	1.09	2.41	2026-04-26 17:46:20.978765	3228
ab8c21a9-bb71-4b4f-aead-976a688c8f5b	3.28	169.15	2.65	1.67	2026-04-26 17:46:20.978765	3229
f9ad0b21-3622-4955-864f-b6acb6a20375	2.16	149	1.12	2.89	2026-04-26 17:46:20.978765	3230
aef0ef1f-cf70-43c3-8f1d-741c39e1a0e6	2.09	144.22	3.9	1.99	2026-04-26 17:46:20.978765	3231
116f0b0c-99bc-4284-be34-a8763f08c3ab	2.87	213.4	3.05	1.57	2026-04-26 17:46:20.978765	3232
303c7791-8997-4438-ace3-bd9a7a7af3c4	0.98	91.56	1.73	1.62	2026-04-26 17:46:20.978765	3233
a46cee26-7552-4afd-a7d4-5ca99238e8e8	3.46	222.85	2.61	2.58	2026-04-26 17:46:20.978765	3234
9cb18f9e-63fe-4579-a41e-e5f782f33987	1.86	153.27	1.9	1.41	2026-04-26 17:46:20.978765	3235
a418ca68-e9f5-4739-a62d-33c94119c313	3.23	275.72	3.74	2.64	2026-04-26 17:46:20.978765	3236
77a3d378-3dea-4aa3-a7f5-7d85a45b2b08	3.14	55.55	1.39	2.05	2026-04-26 17:46:20.978765	3237
796992b1-1d1c-4c72-b5d0-2f661bcdd5ca	1.26	79.78	2.24	1.91	2026-04-26 17:46:20.978765	3238
d120b9a3-e088-4a57-b7ca-0f1e5f0bbc37	0.75	259.31	1.94	1.54	2026-04-26 17:46:20.978765	3239
bb26c4bd-6b5f-4541-9263-5ffa9ce44a38	2.54	208.98	3.5	1.8	2026-04-26 17:46:20.978765	3240
1b88f539-bcd1-445c-91ef-f2389aefa47f	0.73	87.6	1.07	1.73	2026-04-26 17:46:20.978765	3241
21dcb036-b5c2-4347-86f1-dd9821202a18	2.02	142.51	2.56	1.91	2026-04-26 17:46:20.978765	3242
cd3e4d12-a1e8-4bcc-a3ac-bdb037d54f65	2.76	281.52	3.34	1.61	2026-04-26 17:46:20.978765	3243
7c2dff92-88b3-473b-a1ac-f563a1465fab	0.57	165.7	1.14	1.94	2026-04-26 17:46:20.978765	3244
7a5d92aa-ee96-4190-afbe-5305d11457c0	0.91	86.3	1.97	2.91	2026-04-26 17:46:20.978765	3245
97f54406-bbf5-4ac4-b333-90dee66684eb	2.55	122.23	2.05	1.76	2026-04-26 17:46:20.978765	3246
1ddab371-a75b-4379-b61e-f9fcff7ce097	2.77	286.94	2.52	1.65	2026-04-26 17:46:20.978765	3247
d76936cd-a489-4f46-badb-efdcd51e0121	2.81	150.11	1.71	1.07	2026-04-26 17:46:20.978765	3248
e0b3453d-63ac-4135-a222-6ce145c529f9	1.27	61.82	2.35	1.49	2026-04-26 17:46:20.978765	3249
e61c37c0-b864-4ae4-a2db-2b50b1090fae	3.42	154.13	3.13	2.15	2026-04-26 17:46:20.978765	3250
db738178-6c85-4003-814c-43efae201f66	2.26	257.49	2.16	2.81	2026-04-26 17:46:22.672735	3251
8d34dd99-e669-4ca7-99af-1d91991a09c9	2.49	272.62	2.02	1.46	2026-04-26 17:46:22.672735	3252
8d34dd99-e669-4ca7-99af-1d91991a09c9	2.49	272.62	2.02	1.46	2026-04-26 17:46:22.672735	3253
db738178-6c85-4003-814c-43efae201f66	2.26	257.49	2.16	2.81	2026-04-26 17:46:22.672735	3254
da38da3e-9316-49d8-af58-cfca2be2ecea	2.04	280.45	3.06	1.79	2026-04-26 17:46:22.672735	3255
083b503f-bc9a-4761-9232-985118e3bde4	2.49	70.3	3.55	1.23	2026-04-26 17:46:23.696873	3256
84898f92-b30c-4251-99c5-6d4b8ee07428	2.35	136.75	1.55	1.87	2026-04-26 17:46:23.696873	3257
1798c0d0-79e4-4d2b-9f3f-990b125d2105	3.23	199.05	1.81	1.55	2026-04-26 17:46:23.696873	3258
d4454c95-37c1-4467-a22e-9fb7abac08a2	2.08	119.75	3.99	2.31	2026-04-26 17:46:23.696873	3259
1dc79f19-741d-4d47-8552-5e53debeed00	0.75	154.93	1.49	1.42	2026-04-26 17:46:23.696873	3260
127074f4-ef1e-44c6-b9d4-6e159522fe6d	2.08	110.13	1.42	2.51	2026-04-26 17:46:23.696873	3261
933c3358-c4a9-4190-ba36-d320f41b28bd	1.06	269.48	2.48	1.31	2026-04-26 17:46:23.696873	3262
24c4b5e6-9375-4a3d-aa2e-8ecf73311e2a	2.35	120.64	3.18	2.62	2026-04-26 17:46:23.696873	3263
8459b204-828a-433c-946a-16940b23fe20	2.63	232.23	1.95	2.04	2026-04-26 17:46:23.696873	3264
6c67de4d-14df-473a-b5b7-234ca1892d36	2.95	50.5	2.9	2.36	2026-04-26 17:46:23.696873	3265
1a1da762-8b17-44fc-ab54-aacee70233c0	1.66	198.77	3.23	1.78	2026-04-26 17:46:23.696873	3266
eaf83308-161d-4cbe-9a8f-c87d75ee5421	0.83	63.32	1.63	1.98	2026-04-26 17:46:23.696873	3267
2639cd66-3527-4a6d-b26e-dfb2491c1bf2	1.8	285.27	3.82	2.52	2026-04-26 17:46:23.696873	3268
8d34dd99-e669-4ca7-99af-1d91991a09c9	2.66	68.16	1.69	1.91	2026-04-26 17:46:23.696873	3269
77398e9d-8c73-4cfb-9019-93696911c12d	3.06	189.78	1.36	2.75	2026-04-26 17:46:23.696873	3270
af79ed93-81e1-4dad-ab43-483f230ed7d4	1.78	180.69	3.79	2.45	2026-04-26 17:46:23.696873	3271
a09b5914-31d8-4628-bfde-a2ed4f60f907	1.42	110.14	1.43	2.95	2026-04-26 17:46:23.696873	3272
af5d64a0-8fd6-4135-9b5c-ed9a17afe722	2.27	115.14	2.63	1.16	2026-04-26 17:46:23.696873	3273
48f2ef4f-6f48-4a5a-8aca-e2844be19a4d	1.7	126.34	2.33	1.19	2026-04-26 17:46:23.696873	3274
c4a5295a-ac7e-4505-ae47-069a3a50ecec	3.26	280.16	3.65	2.97	2026-04-26 17:46:23.696873	3275
0cdc07b0-d122-4345-a871-ed8736125a13	0.9	179.44	1.48	1.82	2026-04-26 17:46:23.696873	3276
8be3185b-bc1c-4142-b567-48aaff220b01	1.56	289.16	1.18	1.46	2026-04-26 17:46:23.696873	3277
d9051e4d-d569-4f01-89e0-7d857762afe5	2.92	137.46	3.01	2.52	2026-04-26 17:46:23.696873	3278
3fad7c09-4ab3-4a8b-aa29-7211513f7237	1.33	66.25	3.08	2.75	2026-04-26 17:46:23.696873	3279
dbbf360e-7216-4601-8614-038fe1dcc2ba	2.85	168.78	2.42	2.04	2026-04-26 17:46:23.696873	3280
9bd9f3c5-1b49-4927-8cdf-35373636ae00	0.91	273.86	1.6	2.6	2026-04-26 17:46:23.696873	3281
160d3adf-6a5a-4442-8c35-f8ff730e0036	1.87	285.27	1.64	2.56	2026-04-26 17:46:23.696873	3282
5c42027f-8aaa-441b-990e-215c05fc0300	1.84	203.5	1.45	1.12	2026-04-26 17:46:23.696873	3283
bfc1d7fb-6dd6-42fd-a795-053bca272428	2.19	163.19	2.42	1.05	2026-04-26 17:46:23.696873	3284
fe19663b-26a2-40d0-a329-bf3f1f6a25a6	3.41	122.1	1.2	1.53	2026-04-26 17:46:23.696873	3285
09bcbc34-b01a-4878-88ae-4aac9ea91b2d	2.08	208.33	2	2.35	2026-04-26 17:46:23.696873	3286
28aa7be3-ebf0-4bfb-9e4d-8eb57e7a1a09	1	180.93	3.53	2.57	2026-04-26 17:46:23.696873	3287
a463568f-08c1-4eee-ba9f-87eca478959e	0.58	73.79	2.61	2.01	2026-04-26 17:46:23.696873	3288
e91e2255-deed-4ffc-9e86-da19ee4fe2be	3.3	217.79	2.43	2.83	2026-04-26 17:46:23.696873	3289
e6c3818b-29f0-4e36-9052-5e1482339405	1.19	83.04	1.35	2.31	2026-04-26 17:46:23.696873	3290
80d81f80-2426-4c17-9e8a-321da7361798	3.32	97.76	3.79	1.36	2026-04-26 17:46:23.696873	3291
6f817b31-ed87-46bb-9e2e-1140f4cb4cbb	1.94	54.54	1.43	1.8	2026-04-26 17:46:23.696873	3292
34c9e297-d7dc-4168-a5a5-8e7e148dcbbd	1.6	222.99	2.33	1.43	2026-04-26 17:46:23.696873	3293
06c52bbf-cbe5-4db7-997a-9f747283665e	2.81	184.87	1.47	1.42	2026-04-26 17:46:23.696873	3294
0404794e-0a50-4824-a0ee-921cb23888ee	2.95	97.85	2.96	2.86	2026-04-26 17:46:23.696873	3295
ff75e776-7227-4220-9f32-33a6013ae67f	0.73	128.89	2.21	1.35	2026-04-26 17:46:23.696873	3296
522e7eca-7dde-4bb5-9cfd-7bfc1f5aa823	0.78	198.91	2.41	2.93	2026-04-26 17:46:23.696873	3297
0670c059-cbff-4d6e-97fa-c2dbd81ba878	1.61	119.06	2.49	1.48	2026-04-26 17:46:23.696873	3298
41623b9e-303f-46b1-82d3-8883c4a479bb	2.46	187.67	1.52	1.03	2026-04-26 17:46:23.696873	3299
8425054a-27fe-45f7-a2d1-0ca5bb87c22d	2.04	63.41	3.06	1.48	2026-04-26 17:46:23.696873	3300
88f2dc8f-4748-490e-b92d-e31ba6ddaf7b	2.31	191.48	3.31	2.41	2026-04-26 17:46:23.696873	3301
71e03cf9-1c81-44c0-9c0f-63591e58aa30	2.54	271.36	2.49	1.68	2026-04-26 17:46:23.696873	3302
bc2f02a5-cb1e-4610-ac0e-ba7f24c18ccd	2	275.68	3.41	1.06	2026-04-26 17:46:23.696873	3303
c110010b-1088-4e02-be3c-83c511d7831c	1.95	142.96	3.93	1.1	2026-04-26 17:46:23.696873	3304
fe8407a5-d6f0-4b63-b0c1-71ad87ffab96	2.82	249.03	3.25	1.18	2026-04-26 17:46:23.696873	3305
19646a15-fc51-45ea-b837-9703ea5e5f8c	3.26	215.32	2.5	1.7	2026-04-26 17:46:23.696873	3306
048313b2-21ec-4fbc-be08-2f0c27fa77f6	2.42	136.57	3.64	1.06	2026-04-26 17:46:23.696873	3307
66ae13b0-bc41-401b-919a-a47c2d82b9ef	1.73	228.77	1.48	2.49	2026-04-26 17:46:23.696873	3308
d87f65c7-d638-4f26-a825-aff5ae57457b	0.84	108.22	2.11	2.08	2026-04-26 17:46:23.696873	3309
7931d397-9cb6-40aa-888c-6b1cfe481a74	0.99	233.69	2.47	2.85	2026-04-26 17:46:23.696873	3310
a63e2468-ff52-45a6-a5cd-59944a3859bb	1.27	204.3	1.99	2.1	2026-04-26 17:46:23.696873	3311
2c170f3c-70f5-4432-9675-baa82539a713	1.98	281.22	1.76	1.83	2026-04-26 17:46:23.696873	3312
a49a8d86-d915-4488-b843-de71b33e91fd	0.94	58.86	1.75	2.82	2026-04-26 17:46:23.696873	3313
b2cd1843-50e3-475c-b68b-24bcf035d14a	0.74	233.46	3.1	1.58	2026-04-26 17:46:23.696873	3314
49214cd6-15b3-43e2-b004-f11980bd76e7	2.79	253.54	1.04	1.13	2026-04-26 17:46:23.696873	3315
da38da3e-9316-49d8-af58-cfca2be2ecea	1.58	229.34	3.29	1.42	2026-04-26 17:46:23.696873	3316
06e503be-bdf4-4afe-9252-ad4307d77d34	1.91	267.52	2.95	1.32	2026-04-26 17:46:23.696873	3317
e07bf42f-e0df-4ae0-8b19-59673c872bf2	0.75	142.83	1.93	2.18	2026-04-26 17:46:23.696873	3318
d9ff0e43-523c-4157-b412-c6e488086313	2.89	121.53	2.23	2.1	2026-04-26 17:46:23.696873	3319
73605445-18c0-4c79-aa20-abe75a2aa504	0.62	123.5	3.88	2.33	2026-04-26 17:46:23.696873	3320
17d1d4a8-7fff-4e9d-be6b-1ad8cff6ebd6	1.28	296.86	1.56	2.18	2026-04-26 17:46:23.696873	3321
0ff59da4-ea9a-48c5-9b60-96f17e2644b7	0.96	82.98	3.05	1.72	2026-04-26 17:46:23.696873	3322
0c867821-28e1-489c-96ef-a33a16f96004	1.73	258.61	3.83	2.93	2026-04-26 17:46:23.696873	3323
6111d377-0b6c-4d93-b288-f7ebce6c00fc	1.96	211.29	1.15	1.28	2026-04-26 17:46:23.696873	3324
18905b39-d6a0-4f41-8c02-9b817e1b009d	1.04	171.61	2.6	1.75	2026-04-26 17:46:23.696873	3325
8b417aee-680e-4081-85f2-5a160fb2ff12	1.61	119.44	3.45	2.98	2026-04-26 17:46:23.696873	3326
38b482a7-1f32-4ddc-9349-bcf1da86d546	1.13	215.43	2.66	1.52	2026-04-26 17:46:23.696873	3327
02152a87-fd48-4156-bd2f-afe94c4dc7a6	2.31	184.39	1.5	2.64	2026-04-26 17:46:23.696873	3328
6a47fed4-5e33-425c-bbc6-691c625d33a7	2.41	97.61	3.46	1.08	2026-04-26 17:46:23.696873	3329
79cd4a3f-adcf-4ce5-9d29-62693c93adf2	3.31	80.53	2.46	1.62	2026-04-26 17:46:23.696873	3330
c4391873-3533-4cad-977b-0323fced348e	1.61	239.43	1.64	2.13	2026-04-26 17:46:23.696873	3331
c6338c80-214f-405b-9b0b-7594bb69d230	3.13	233.58	2.73	1.63	2026-04-26 17:46:23.696873	3332
382f3f60-7d3c-4ffc-8b2f-94ce32b77254	1.89	126.19	3.87	1.05	2026-04-26 17:46:23.696873	3333
cf827a4b-a720-4825-84d4-29f047763f7e	2.09	177.77	1.2	2.32	2026-04-26 17:46:23.696873	3334
d5806c60-9752-4845-9128-964d9b723f0b	3.26	168.02	1.51	1.42	2026-04-26 17:46:23.696873	3335
96e0af22-02e2-46d4-8224-4db162bd27b6	0.91	61.39	1.82	1.88	2026-04-26 17:46:23.696873	3336
9d0c77f5-485a-477d-80ec-8da875eb9852	1.87	93.12	1.35	1.95	2026-04-26 17:46:23.696873	3337
c19c4f6a-3738-436e-b7dc-b27df3129b28	3.01	120.17	1.91	1.32	2026-04-26 17:46:23.696873	3338
2d78aa7b-b8fb-4cc0-9d8a-f6a927032041	1.09	160.09	3.71	1.26	2026-04-26 17:46:23.696873	3339
dbebf850-836f-4532-807c-c1e3f5b5d597	2.73	177	2.68	2.06	2026-04-26 17:46:23.696873	3340
453f03e0-cb8d-4681-b343-d681f27e84f8	1.76	201.07	1.31	2.36	2026-04-26 17:46:23.696873	3341
13d5f24a-3280-4db1-ae8d-4e7ac37dca9d	3.12	210.89	3.19	1.32	2026-04-26 17:46:23.696873	3342
40f8a8d7-327f-4f20-a15c-cbd9fb6f5e75	2.67	191	3.26	1.69	2026-04-26 17:46:23.696873	3343
8cfcaf67-4ae0-46c6-996e-6ce551b4096d	2.62	203.87	2.24	1.04	2026-04-26 17:46:23.696873	3344
05bb5c72-6613-4d45-a876-a6c5fb64222e	2.51	148.45	1.57	2.76	2026-04-26 17:46:23.696873	3345
37b80a41-5dec-4adb-ac19-126072ec4a13	0.6	150.57	1.84	1.72	2026-04-26 17:46:23.696873	3346
514c19e7-d8eb-4f8a-b58c-db01659e571e	1.96	243.05	3.05	2.1	2026-04-26 17:46:23.696873	3347
27ded357-dfee-45c6-844b-2108e05a105b	0.67	252.52	2.35	1.03	2026-04-26 17:46:23.696873	3348
affc16bb-f7a4-4ff2-90df-48caf7eebddc	1.79	236.92	3.51	2.53	2026-04-26 17:46:23.696873	3349
cb0fe3b7-fbc8-479b-bd12-6acfeeeeffeb	1.7	120.32	2	1.2	2026-04-26 17:46:23.696873	3350
c0f13516-b42b-4edf-8d54-260ed3432c91	1.15	137.87	2.44	2.48	2026-04-26 17:46:23.696873	3351
a6b3ffd9-c2dc-4bf3-872f-1d4dfaff44ce	1.07	88.83	2.47	1.28	2026-04-26 17:46:23.696873	3352
4c18584e-0e3e-40cc-94a4-dd6106965efb	1.11	248.66	3.46	2.92	2026-04-26 17:46:23.696873	3353
42be6f12-2662-427d-b3bb-9f8fb042cde5	1.4	278.94	3.89	2.98	2026-04-26 17:46:23.696873	3354
a9a3a5fa-5c98-4e69-883b-2afa82b1877f	1.09	114.07	1.8	1.53	2026-04-26 17:46:23.696873	3355
69ceb13d-c6ba-480a-9bb6-8c94350b80bb	2.86	140.27	1.82	2.75	2026-04-26 17:46:23.696873	3356
6946eb18-50ec-477c-808d-f71c98670e15	2.76	276.52	1.75	2.45	2026-04-26 17:46:23.696873	3357
db738178-6c85-4003-814c-43efae201f66	3.16	76.01	3.2	1.22	2026-04-26 17:46:23.696873	3358
4b5f92c9-7d51-4b0e-a137-acd779a460c0	2.84	284.17	3.18	2.56	2026-04-26 17:46:23.696873	3359
343b8afa-f5f3-413a-8faf-37c6af937323	1.56	171.04	1.8	2.02	2026-04-26 17:46:23.696873	3360
aa3eddc8-b910-47a9-b691-2ec377a4b6c3	2.81	72.36	1.53	2.81	2026-04-26 17:46:23.696873	3361
10412ce9-7326-4907-98fb-f30f329eb834	3.19	143.16	1.13	1.45	2026-04-26 17:46:23.696873	3362
a7a83b3b-4904-468d-b1ff-79250bae2178	1.81	122.81	1.4	2.84	2026-04-26 17:46:23.696873	3363
de64100b-0d55-4423-8139-e21bf67b1ba3	2.62	91.7	2.45	2.03	2026-04-26 17:46:23.696873	3364
48f1cae9-db76-406a-84c3-4b1d3fd1f646	1.17	154.22	2.39	2.06	2026-04-26 17:46:23.696873	3365
bff99142-a62f-4628-a6ff-c053c6deb013	3.4	120.67	1.18	2.91	2026-04-26 17:46:23.696873	3366
fb073968-3588-453a-85e2-75089d4c03f1	1.5	214.62	3.54	2.04	2026-04-26 17:46:23.696873	3367
377f4e07-93cb-4351-8c6b-62851338fdb0	3.12	154.33	1.35	1.25	2026-04-26 17:46:23.696873	3368
19bdfc5a-e1d0-463a-b163-7d7a692f73b8	0.53	195.83	1.1	2.8	2026-04-26 17:46:23.696873	3369
cbd20eb0-7239-4734-b82b-404600e7d66b	3.23	143.23	3.78	2.53	2026-04-26 17:46:23.696873	3370
18c3479d-2072-411f-8d91-9a580608c627	2.49	107.63	2.75	1.87	2026-04-26 17:46:23.696873	3371
ca09ced3-7738-4c9e-887f-d34312c3d8e4	2.28	87.11	3.01	1.92	2026-04-26 17:46:23.696873	3372
07a6b221-981a-4cce-bb5d-3d5a872c97b7	3.13	127.71	2.97	1.38	2026-04-26 17:46:23.696873	3373
fa753e0b-bcb9-41b7-9c82-6fccd2333db1	1.89	74.83	2.91	1.41	2026-04-26 17:46:23.696873	3374
100a7e1e-99f2-4b0d-8a9d-842a454a612f	2.87	190.02	3.87	2.79	2026-04-26 17:46:23.696873	3375
41bd264e-1eb3-4ccb-ab43-221d92913239	1.61	269.17	3.93	1.61	2026-04-26 17:46:23.696873	3376
b80e97e3-fe08-465e-ac72-eea64d2d6182	1.83	252.45	2.32	2.33	2026-04-26 17:46:23.696873	3377
ed596397-26d6-4d02-a2f1-dbbf5f8ab704	1.66	159.37	1.03	2.38	2026-04-26 17:46:23.696873	3378
5d36c463-e893-43a2-b567-1e7fbcb3c80c	2.57	60.85	2.34	2.91	2026-04-26 17:46:23.696873	3379
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	0.96	278.81	2.75	1.2	2026-04-26 17:46:23.696873	3380
b611f2f3-4dce-4565-9634-c5f67f16841f	2.59	288.59	3.56	2.81	2026-04-26 17:46:23.696873	3381
af16d415-a7a8-426f-8d38-2ade72d8acb5	1.32	193.23	1.65	1.44	2026-04-26 17:46:23.696873	3382
a18f9d90-4ce4-4793-a9c1-9452712601a3	0.92	157.99	1.78	2.41	2026-04-26 17:46:23.696873	3383
2421d8dc-3548-4b72-b606-b235ecdf5448	1.38	199.38	3.61	2.92	2026-04-26 17:46:23.696873	3384
bb6389a5-9e20-4135-8648-8a813bb296b7	1.86	240.87	1.33	2.54	2026-04-26 17:46:23.696873	3385
6447b600-e734-4067-87b1-b915998722b4	2.67	289.07	2.1	1.4	2026-04-26 17:46:23.696873	3386
a1fc9f0b-f1e6-4819-9cb5-1ce77541a1b5	2.57	261.69	1.61	2.49	2026-04-26 17:46:23.696873	3387
25df9dd3-d744-4a1e-a96b-d1322d6952f5	2.05	149.87	3.81	1.88	2026-04-26 17:46:23.696873	3388
8e3909e7-8ee5-4db8-9278-087d2851a6f1	0.86	82.53	1.61	2.56	2026-04-26 17:46:23.696873	3389
3fcc2af3-e524-4b65-9649-cc48a58b7463	2.7	188.24	3.32	2.23	2026-04-26 17:46:23.696873	3390
3045ab21-e78f-41cf-9f96-102cfd907777	0.87	141.24	3.4	2.2	2026-04-26 17:46:23.696873	3391
211e6d92-06f3-4968-ab18-4d3606fb0313	2.6	65.66	3.81	2.1	2026-04-26 17:46:23.696873	3392
577c5ceb-5d82-4a67-914e-cc3249432558	1.79	93.91	1.37	1.17	2026-04-26 17:46:23.696873	3393
a9955bda-fedb-44d9-b5a6-33b7ceff70cc	2.28	137.12	3.88	2.18	2026-04-26 17:46:23.696873	3394
cac6b96e-6c77-4c20-b201-5d059367fbf0	1.46	126.41	2.65	2.22	2026-04-26 17:46:23.696873	3395
40b83090-1da5-4f1a-85d6-884f75d306d9	2.15	165.9	2.59	1.59	2026-04-26 17:46:23.696873	3396
af6f8bce-ab49-4a79-a40c-4a4aba8d8552	2.73	115.05	2.57	2.78	2026-04-26 17:46:23.696873	3397
7674a04d-8f67-4d07-9eab-998e344a03c9	0.66	153.17	1.47	1.54	2026-04-26 17:46:23.696873	3398
f97b5670-ef68-4a86-97c0-6385e6ae7405	2.22	102.12	2.37	2.52	2026-04-26 17:46:23.696873	3399
4fc26046-1ae2-4e60-99cf-95ef8ee6524a	3	80.32	2.13	1.46	2026-04-26 17:46:23.696873	3400
e332ef09-be23-4a9d-b003-f886bfae870d	3.4	156.4	1.34	2.14	2026-04-26 17:46:23.696873	3401
88f0fd74-5fbe-402b-b1f9-8b0185f9b042	3.4	178.42	1.51	2.09	2026-04-26 17:46:23.696873	3402
7289ae0e-9605-4d46-aaee-5b05ddd96e59	3.29	214.36	2.36	2.83	2026-04-26 17:46:23.696873	3403
b0318b61-a090-47a1-a30e-1f29ba099262	2.46	160.54	2.74	1.12	2026-04-26 17:46:23.696873	3404
26ec3ee2-f140-4f43-b13b-9299796dd2d1	1.91	260.6	2.78	1.15	2026-04-26 17:46:23.696873	3405
9dab24c7-177d-4ec4-8c0b-2323b92d3d4a	0.91	79.68	1.33	2.16	2026-04-26 17:46:23.696873	3406
1a6d5e85-787b-461f-8db7-9cd8f8d81ece	1.28	193.33	1.09	2.49	2026-04-26 17:46:23.696873	3407
27b23042-92c6-4a49-b397-6c200041d8ee	0.65	236.8	1.67	1.46	2026-04-26 17:46:23.696873	3408
08f0acf7-18ec-45eb-8146-8042969d5c7a	2.03	86.25	3.82	2	2026-04-26 17:46:23.696873	3409
a03af7ca-2046-499e-b19d-b6571e696f89	2.99	76.24	2	1.99	2026-04-26 17:46:23.696873	3410
e7fd011f-5572-4ee9-a3de-2d9d4d5c818d	2.32	103.54	1.87	2.44	2026-04-26 17:46:23.696873	3411
4065ab51-f74f-42a2-9363-7146df43c932	2.96	132.74	2.69	2.87	2026-04-26 17:46:23.696873	3412
a07f2ed2-35ae-4720-ad65-a22fe59566d3	2.46	69.93	1.8	2.63	2026-04-26 17:46:23.696873	3413
02c4237f-a7f5-452b-82c3-1fe296af3c3c	1.22	272.59	2.18	1.9	2026-04-26 17:46:23.696873	3414
62b7cf0d-cf31-493a-85aa-8fa347acda25	1.81	242.33	3.51	2.58	2026-04-26 17:46:23.696873	3415
ab3db038-d69b-451e-bba3-08e8119898b4	1.05	150.1	1.53	1.76	2026-04-26 17:46:23.696873	3416
b685932b-8a27-4288-8795-f6e05e9e4cef	0.66	79.33	2.66	1.13	2026-04-26 17:46:23.696873	3417
9cd7e4f4-8d1a-48da-abbc-075218e9e7a6	2.72	179.59	1.06	2.66	2026-04-26 17:46:23.696873	3418
98d2ddcf-4cfa-4405-9501-d661884b1017	2.15	273.87	3.67	2.83	2026-04-26 17:46:23.696873	3419
d0655207-0783-4e94-98d2-176fe26849d8	0.95	191.39	2.98	2.47	2026-04-26 17:46:23.696873	3420
bcad4d42-8a4f-4b72-a2e1-b607651d5c31	3.3	174.78	3.76	2.95	2026-04-26 17:46:23.696873	3421
9ed4929a-d3c0-4954-b272-227a89cbedec	0.94	51.18	1.55	1.91	2026-04-26 17:46:23.696873	3422
edcb7d15-e6ed-461f-b1b4-38a993ff2ec7	1.34	217.61	3.07	2.32	2026-04-26 17:46:23.696873	3423
2f5d7c02-eadd-4eb2-8dd5-46a5ba51c3f8	1.6	61.77	1.71	2.79	2026-04-26 17:46:23.696873	3424
0ad0a6eb-d13c-440c-b74c-0391605d9685	0.95	139.7	2.22	1.86	2026-04-26 17:46:23.696873	3425
2bb8c959-19b6-4951-8313-e6d0413c9a6f	0.88	195.82	1.69	2.23	2026-04-26 17:46:23.696873	3426
303a312c-4f87-408c-b20b-03d848ec9055	1.7	102.74	3.89	2.78	2026-04-26 17:46:23.696873	3427
a32bfdcd-5dd9-4a93-85e7-c1e608df83ee	0.63	95.43	3.74	1.53	2026-04-26 17:46:23.696873	3428
5ccc6390-43ca-49f5-b6fa-84247d3e52af	1.43	149.43	3.66	1.96	2026-04-26 17:46:23.696873	3429
df299e49-61f2-49ce-8051-e50cfc0b2650	1.26	202.89	2.92	1.21	2026-04-26 17:46:23.696873	3430
86ef6ade-b308-467a-8c42-3c6e4c20ec8d	0.61	199.42	2.34	2.87	2026-04-26 17:46:23.696873	3431
e318d53f-7605-468a-b41d-051070be96a3	1.14	161.49	2.59	1.95	2026-04-26 17:46:23.696873	3432
efc0c233-0113-480b-b3e6-ca3275b5ffde	3.43	120.84	3.38	2.75	2026-04-26 17:46:23.696873	3433
5808ae27-83d1-4163-9187-6a23f988dc97	0.54	145.13	1.13	1.82	2026-04-26 17:46:23.696873	3434
e304e2e6-fd72-4399-b4d7-fb6416b81f0c	1.19	280.38	3.38	2.13	2026-04-26 17:46:23.696873	3435
678ae26f-569d-4c0e-b4a9-0a688fc0936a	3.02	259.47	3.31	1.21	2026-04-26 17:46:23.696873	3436
6438657c-ee67-48b5-8de0-62eeb64e0a87	2.95	102.67	1.17	2.58	2026-04-26 17:46:23.696873	3437
e3216b17-e320-4d0f-ada0-b93e60caca02	2.44	172.31	3.77	1.66	2026-04-26 17:46:23.696873	3438
63188d13-0344-4b51-aa79-19ea416c8cdd	2.86	178.02	1.25	2.79	2026-04-26 17:46:23.696873	3439
17932bb9-836e-4db9-b27e-bd1b2f574954	1.01	250.89	2.72	2.58	2026-04-26 17:46:23.696873	3440
459418c3-7fb1-4dd5-9c2b-6a0eb1e128a7	1.62	76.58	2.06	1.46	2026-04-26 17:46:23.696873	3441
4d88229f-55e4-476b-bfc0-096795c485e4	1.67	219.85	2.55	1.73	2026-04-26 17:46:23.696873	3442
2ce612e7-1b0e-4a98-aab2-d00e087e7acd	1.17	131.59	2.18	1.4	2026-04-26 17:46:23.696873	3443
f1c04ba0-d43a-4055-8726-0674ce5a9591	1.61	55.51	3.48	1.56	2026-04-26 17:46:23.696873	3444
b4617646-5ec4-4d15-a573-c29cffb7c27f	0.54	290.68	2.2	2.43	2026-04-26 17:46:23.696873	3445
c02600b3-e48e-4409-95a3-eb683e336b10	3.44	72.5	3.5	1.78	2026-04-26 17:46:23.696873	3446
fc365d4b-670e-4fca-8c15-bed27e9c7c64	1.99	282.29	3.55	1.1	2026-04-26 17:46:23.696873	3447
b5bfff34-218c-48cd-b9ce-673eea91bda1	1.21	276.61	2.49	2.41	2026-04-26 17:46:23.696873	3448
0ef3d984-2e82-4672-bcd6-c49dfd8397b3	1.92	273.38	3.07	1.1	2026-04-26 17:46:23.696873	3449
869589e4-a12e-4a97-9558-0e078bfadd07	2.19	55.49	1.74	2.15	2026-04-26 17:46:23.696873	3450
fc37eb73-af1d-4f66-ab8d-ac6cd664ceea	1.54	275.93	3.78	2.11	2026-04-26 17:46:23.696873	3451
f182189b-b6e2-4aee-bb22-5b1e555815b6	1.56	61.78	1.48	2.5	2026-04-26 17:46:23.696873	3452
4a03155b-1956-495a-aa04-f02a9c3d31c8	1.99	66.25	3.37	1.99	2026-04-26 17:46:23.696873	3453
6b9cb1d4-e93d-40cb-8099-44f30eae119b	2.43	78.55	1.71	2.39	2026-04-26 17:46:23.696873	3454
77c9a885-1040-44e4-8b7c-18dccb3b1a81	3.27	152.89	2.84	1.52	2026-04-26 17:46:23.696873	3455
ab089221-71a5-4b3c-a06e-445f999eed0a	1.67	215.93	3.82	1.26	2026-04-26 17:46:23.696873	3456
2954b16d-0db5-4232-8923-ca1c2a81be0a	0.65	192.03	3.51	1.56	2026-04-26 17:46:23.696873	3457
e072183d-f51e-4965-a227-e111304e8104	1.48	117.14	1.4	1.18	2026-04-26 17:46:23.696873	3458
d59dcfa3-ec8d-4789-81cd-22e13a9c829c	0.66	267.79	2.4	1.53	2026-04-26 17:46:23.696873	3459
e32ad455-b5bd-49ef-b295-f81c8a11da16	2.75	279.75	3.78	1.65	2026-04-26 17:46:23.696873	3460
21d6e120-8fa3-4a51-9ade-436c7d77e075	2.33	136.86	1.43	2.25	2026-04-26 17:46:23.696873	3461
efff145d-5625-4a2c-ac23-ffdccad3e85b	2.76	245.06	1.24	1.62	2026-04-26 17:46:23.696873	3462
1a64a717-44a3-4308-9eaa-d6a37163544c	3.42	258.38	3.6	2.74	2026-04-26 17:46:23.696873	3463
474c6490-57e2-4c5c-ad69-dc1c4cf6b1f5	3.22	142.68	2.05	1.65	2026-04-26 17:46:23.696873	3464
7f85773c-30b2-4ff2-877a-93f568213806	1.74	186.63	2.42	2.3	2026-04-26 17:46:23.696873	3465
4d87ace7-e3ee-4ea4-92f6-c395ef501428	1.12	244.91	2.87	1.59	2026-04-26 17:46:23.696873	3466
4d289278-e3f8-42ed-af6a-2d3259072f3f	2.77	207.24	3.44	1.78	2026-04-26 17:46:23.696873	3467
ebffe864-14eb-465e-b745-192f6e5717bf	1.77	100.81	3.61	1.05	2026-04-26 17:46:23.696873	3468
fb9a49ca-e5e2-4be1-9e2c-5d77c4db770b	2.33	105.25	2.58	1.72	2026-04-26 17:46:23.696873	3469
150f7991-fbd0-429e-bdf9-c60b50b1aae6	0.61	89.38	2.2	2.96	2026-04-26 17:46:23.696873	3470
569b5e54-a5e6-442c-94e0-64a8245dcd07	3.08	117.42	3.95	2.64	2026-04-26 17:46:23.696873	3471
1525c80d-cf06-4108-bab9-0205f6ed78f7	1.07	132.2	1.07	2.68	2026-04-26 17:46:23.696873	3472
c6e7314c-8525-4191-80c2-2c3a921f415d	3.48	285.22	2.39	1.25	2026-04-26 17:46:23.696873	3473
01d04063-d9c3-43b8-9cd1-f2c365206958	2.35	174.84	2.46	1.01	2026-04-26 17:46:23.696873	3474
688a8c3f-fa38-4308-89d5-212d6faf8a77	1.2	77.5	1.51	2.41	2026-04-26 17:46:23.696873	3475
80f0e0e1-a56b-4969-9328-300dd7d3889e	0.51	137.5	3.49	2.49	2026-04-26 17:46:23.696873	3476
bf4c1fb6-a269-4569-be90-6b6a998ee7b9	0.71	99.31	2.25	2.05	2026-04-26 17:46:23.696873	3477
4421a7a4-be54-4494-b732-9068a725e9b7	3.42	220.44	1.83	2.47	2026-04-26 17:46:23.696873	3478
5d9bfdd7-0a23-41a4-bff6-1d1b588e6b78	1.87	276.96	2.69	2.59	2026-04-26 17:46:23.696873	3479
9272aa0e-60be-48a7-b1a9-e260a3fcd3d2	2.14	241.43	1.41	1.83	2026-04-26 17:46:23.696873	3480
cd6c4c38-b00a-4644-b1a1-7fc4b8c0ef46	1.44	87.19	1.12	1.48	2026-04-26 17:46:23.696873	3481
903c34b0-9809-44ee-af0c-97ca045cde31	1.69	247.62	2.29	2.76	2026-04-26 17:46:23.696873	3482
ec564929-5d5d-4964-85c9-c2c00181550b	2.04	231.92	1.35	1.01	2026-04-26 17:46:23.696873	3483
eb5b0417-51b7-4630-89a7-fbac16715f99	2.4	139.28	1.13	2.38	2026-04-26 17:46:23.696873	3484
2f71377b-f84e-4d62-a2dd-610ad858eff9	1.43	228.37	3.08	1.02	2026-04-26 17:46:23.696873	3485
ccefa4d3-0ac6-49b4-b548-44dbecf95314	2.73	122.54	2.96	1.58	2026-04-26 17:46:23.696873	3486
641085c9-c0f6-4e22-ba3b-1fb94f36d101	2.18	98.1	3.48	2.2	2026-04-26 17:46:23.696873	3487
98771193-9965-407f-9a85-7fede6b77203	2.45	72.27	2.7	1.06	2026-04-26 17:46:23.696873	3488
a4f48f59-b6eb-49b5-bda3-c4cbe0959ccc	1.59	155.44	3.72	1.94	2026-04-26 17:46:23.696873	3489
349fd483-5e87-4860-902e-0499901d0595	3.5	185	2.95	2.06	2026-04-26 17:46:23.696873	3490
9c9909c7-05a2-4227-acf9-28521c0da135	0.81	115.02	1.9	1.49	2026-04-26 17:46:23.696873	3491
f305ad8e-b6cd-4ccb-8d44-e33845a294a1	0.99	276.59	1.86	1.24	2026-04-26 17:46:23.696873	3492
baa2883c-e58b-4231-a08f-44235a4dea80	2.92	77.05	1.94	1.2	2026-04-26 17:46:23.696873	3493
0d8f1e65-863d-45d8-bd85-f7a7bb2a19d6	2.85	79.01	3.68	2.99	2026-04-26 17:46:23.696873	3494
1274b8fd-1c04-42fe-ae89-7ee5494a8909	2.81	77.97	1.38	1.65	2026-04-26 17:46:23.696873	3495
177aba49-3dfa-4284-870d-fb28b84d4534	2.04	159.48	2.19	2.94	2026-04-26 17:46:23.696873	3496
a3e55969-7679-400e-b2f8-63e2955e54c2	0.64	183.36	2.75	1.3	2026-04-26 17:46:23.696873	3497
ccea675a-ef56-4f85-b8c5-317c8ce5a850	2.73	204.36	3.11	1.99	2026-04-26 17:46:23.696873	3498
3aa10c1e-2460-4377-b65a-f47990cf20a4	2.49	140.45	3.71	2.1	2026-04-26 17:46:23.696873	3499
95049103-faa4-4e21-9165-033861d9c488	2.55	96.16	2.42	2.79	2026-04-26 17:46:23.696873	3500
2c47bb0c-f0bc-43ef-97b7-ec4d8c96c29f	1.39	156.59	2.47	2.37	2026-04-26 17:46:23.696873	3501
c1b55a4f-d015-496a-97a5-0eda929e3dc3	2.58	191.83	1.82	1.82	2026-04-26 17:46:23.696873	3502
b8174b2e-1cb1-472c-ac48-c2a6912e48de	1.22	271.55	2.99	1	2026-04-26 17:46:23.696873	3503
ef342171-814f-4d88-ba4b-9c3e820c63de	2.88	133.97	2.43	1.04	2026-04-26 17:46:23.696873	3504
ff142781-a79f-4ff4-a703-7732aa9af9e3	0.59	131.09	2.26	1.18	2026-04-26 17:46:23.696873	3505
53988c3d-02b2-4be9-95b5-739ffb19f562	1.38	154.8	3.29	1.29	2026-04-26 17:46:23.696873	3506
90e0676d-9543-455e-b95b-033a3dc29094	2.28	70.66	2.37	2.59	2026-04-26 17:46:23.696873	3507
aa53d45e-4f36-4897-b499-3ed698190647	0.51	114.96	3.82	1.61	2026-04-26 17:46:23.696873	3508
0d2cac97-cb24-4e98-8c0f-4356b3e97f0a	1.16	267.79	1.97	1.97	2026-04-26 17:46:23.696873	3509
3781bb39-94d7-41ab-bddb-e6008d65fc3e	0.92	167.44	3.02	1.68	2026-04-26 17:46:23.696873	3510
9c7b719e-b70f-4394-9ff1-ed98e6b5cc58	1.19	299.31	1.74	1.36	2026-04-26 17:46:23.696873	3511
e7450082-184d-42e5-9e10-1ba889b81e15	1.79	96.87	2.81	1	2026-04-26 17:46:23.696873	3512
7f8cdea0-97fa-4f5c-a07d-339312618900	1.56	177.51	3.3	2.72	2026-04-26 17:46:23.696873	3513
1cdd7dbf-0fb2-4741-b2ce-1648f6588f83	1.58	291.72	3.6	1.68	2026-04-26 17:46:23.696873	3514
addb0a76-380c-4a6e-81a0-5642a291744d	3.08	264.84	2.67	2.69	2026-04-26 17:46:23.696873	3515
37353a0a-b1de-4f16-ade8-742e357bff71	2.57	233.43	3.58	1.53	2026-04-26 17:46:23.696873	3516
d806cbd2-e0cc-4e83-84a5-7e939ebd4b95	1.26	286.41	3.7	1.22	2026-04-26 17:46:23.696873	3517
84970f72-5d25-45d2-96d7-3ed2f3315168	3.1	198.93	3.81	2.05	2026-04-26 17:46:23.696873	3518
80fbbed9-4a78-4bd2-87e9-af704fc2de31	2.32	164.87	3.59	1.66	2026-04-26 17:46:23.696873	3519
8a2c8802-0ed7-4c68-b865-2b6b9b4e467b	1.75	129.46	3.45	1.82	2026-04-26 17:46:23.696873	3520
92491d57-33b8-476b-b82f-4d782b7925be	2.1	111.04	2.01	2.49	2026-04-26 17:46:23.696873	3521
101a0017-9d06-4cab-9376-10fca55b80fe	3.3	50.6	1.64	1.57	2026-04-26 17:46:23.696873	3522
7a670221-9a34-46e2-b81b-1d7085b29ac8	0.97	289.7	3.08	2	2026-04-26 17:46:23.696873	3523
b486f1ad-7297-436a-929a-3696998a7284	1.25	285.54	1.62	2.74	2026-04-26 17:46:23.696873	3524
ef7e5768-abc3-451c-8700-eadd22e0526f	2	216.65	2.22	1.1	2026-04-26 17:46:23.696873	3525
63993198-0f2e-4909-b4ec-c6e6b29c10e1	3.01	58.05	1.38	1.21	2026-04-26 17:46:23.696873	3526
785054cb-4641-468e-b119-e344676aba22	2.01	268.1	2.33	2.78	2026-04-26 17:46:23.696873	3527
2641930a-9a92-4a93-a28c-017fc48fc1b3	1.65	57.33	1.39	1.2	2026-04-26 17:46:23.696873	3528
4a2d3659-552c-4773-9281-2b75e2ba4bb6	0.8	105.08	1.14	2.85	2026-04-26 17:46:23.696873	3529
78beb24a-058f-4cc9-864c-1d33949d4818	1.6	54.13	1.27	1.53	2026-04-26 17:46:23.696873	3530
0889297c-d685-4c5d-bfc9-bba36110c15d	2.49	150.01	3.65	1.6	2026-04-26 17:46:23.696873	3531
acef61e7-7f4b-4b30-b6c5-425f9e36a90e	2.79	231.09	2.78	1.73	2026-04-26 17:46:23.696873	3532
186f60d6-c7c7-467f-b4fe-fa7636f79a23	1.21	244.93	2.57	2.55	2026-04-26 17:46:23.696873	3533
4079e5e0-9e84-4432-b44a-32af8e59d4b6	1.24	178.96	2.4	1.72	2026-04-26 17:46:23.696873	3534
29a4907b-3872-4537-b4c9-a42ef3e28b0e	1.45	99.06	2.28	2.52	2026-04-26 17:46:23.696873	3535
0881dc31-d7be-4ddb-99c9-8b6d0fa16990	2.16	185.23	2.23	2.35	2026-04-26 17:46:23.696873	3536
89e3921f-88ff-4fa8-9092-9e3260a671eb	1.23	183.37	2.04	1.04	2026-04-26 17:46:23.696873	3537
22899238-2cb3-4920-ad5f-d00408f74869	3.3	133.61	3	2.45	2026-04-26 17:46:23.696873	3538
69b47d8f-7fea-4be2-b860-28261bd322a8	3.11	189.91	3.18	2.07	2026-04-26 17:46:23.696873	3539
ed04eb26-1f11-4e73-bf37-9045f051da24	0.51	150.58	2.29	1.84	2026-04-26 17:46:23.696873	3540
82b0280e-102f-4227-8bdc-035191a662da	1.25	200.5	3.21	1.66	2026-04-26 17:46:23.696873	3541
fc3455ee-1aca-499b-a15a-59daa28c0dae	1.98	134.57	3.87	1.52	2026-04-26 17:46:23.696873	3542
73844c9a-3cfa-47e8-a779-2fd0f85cd1a4	1.53	184.37	1.52	1.26	2026-04-26 17:46:23.696873	3543
1395deb5-7679-416b-8a65-aaf8e835d7c3	2.29	226.58	2.28	1.46	2026-04-26 17:46:23.696873	3544
6b95825f-39e7-468c-9658-f24c248a95ab	0.89	294.94	1.31	1.99	2026-04-26 17:46:23.696873	3545
ce7492b2-e891-474e-a19c-33b127c341bd	1.56	221.09	2.98	2.61	2026-04-26 17:46:23.696873	3546
29b851bc-bf09-44a9-8b92-fd986cecff07	1.83	273.38	1.89	1.85	2026-04-26 17:46:23.696873	3547
18bd7af5-1bd8-4924-b5c8-04e122688eb3	3.35	169.04	2.59	2.48	2026-04-26 17:46:23.696873	3548
0901b3ca-de69-4dc6-8669-6257957ae39e	1.6	284.54	1.18	2.34	2026-04-26 17:46:23.696873	3549
ecb61af6-0fbb-4eb0-bea9-b8c9f2fb8c69	2.02	264.57	2.88	1.23	2026-04-26 17:46:23.696873	3550
fa086000-f37b-4715-a2af-e114d3776051	0.71	257.91	2.72	1.47	2026-04-26 17:46:23.696873	3551
0ebae568-62bd-4e44-9ff7-798a7cf02baa	3.41	261.63	3.3	1.63	2026-04-26 17:46:23.696873	3552
8c5171fd-392e-49b3-9c7a-cac95ad4b712	2.96	277.18	1.25	1.71	2026-04-26 17:46:23.696873	3553
00b72f94-9185-4684-b9c9-7391caff4082	0.59	75	2.84	2.07	2026-04-26 17:46:23.696873	3554
4108c416-a720-408e-b90c-c674d5e86d0c	2.84	267.55	3.43	2.72	2026-04-26 17:46:23.696873	3555
d930d57f-4865-49e1-b97c-e8d38ea33778	0.73	178.04	2.2	1.9	2026-04-26 17:46:23.696873	3556
94ee1380-d4a5-45d7-aca4-98acc362d2ea	1.19	216.21	2.1	1.8	2026-04-26 17:46:23.696873	3557
fdc902c2-6087-4d6f-80c4-06dc3417dd09	3.38	288.86	1.28	1.55	2026-04-26 17:46:23.696873	3558
a8c53a76-9bd2-4da8-bcc2-507bf0391475	1.05	165.3	1.74	2.96	2026-04-26 17:46:23.696873	3559
ec48173e-93eb-43f2-986b-837f4d9ea0a3	0.54	125.12	3.45	1.33	2026-04-26 17:46:23.696873	3560
4cf14171-7f85-401b-a1ed-240a930297d6	0.63	198.74	1.67	1.39	2026-04-26 17:46:23.696873	3561
5e2c38bc-5335-4dcc-b5fd-60f7c7da1f1d	1.9	153.46	2.95	2.74	2026-04-26 17:46:23.696873	3562
6d78a687-8013-4ecd-8edc-b3eaf641d308	3.14	279.27	2.3	2.1	2026-04-26 17:46:23.696873	3563
b4db985f-3cb5-4e0b-8269-75c0205a4a76	1.75	98.06	3.02	2.97	2026-04-26 17:46:23.696873	3564
e740dd73-61ff-47b3-b096-021863c558ef	3.4	135.89	1.99	1.55	2026-04-26 17:46:23.696873	3565
f0f9852b-d33b-4d90-85f0-2672b9b52d4a	2.56	233.69	2.81	1.79	2026-04-26 17:46:23.696873	3566
f7edc0a3-fffa-4af1-94d2-7ae07b266ec2	1.22	224.83	1.57	1.1	2026-04-26 17:46:23.696873	3567
bfcf2856-cd19-4b19-9e9c-310f6f0c9823	0.85	113.99	3	1.27	2026-04-26 17:46:23.696873	3568
3bf47c34-9cd2-4cac-a2f2-72a77040dc8b	0.68	125.24	2.31	2.33	2026-04-26 17:46:23.696873	3569
f025cb63-fae9-478d-afac-8cd17a79f540	0.86	90.17	1.97	1.75	2026-04-26 17:46:23.696873	3570
ddfcdeb7-606a-45f0-97b5-cb4b4ea01288	1.8	197.6	3.83	1.98	2026-04-26 17:46:23.696873	3571
bf95b772-5939-480b-9689-b8de3b17819c	3.36	223.44	1.63	2.74	2026-04-26 17:46:23.696873	3572
79fae5b0-e815-4e6b-979c-3d40dcf82296	0.81	267.97	2.69	2.95	2026-04-26 17:46:23.696873	3573
ab8c21a9-bb71-4b4f-aead-976a688c8f5b	1.49	78.77	1.17	2.82	2026-04-26 17:46:23.696873	3574
f9ad0b21-3622-4955-864f-b6acb6a20375	1.44	212.17	3.45	2.6	2026-04-26 17:46:23.696873	3575
aef0ef1f-cf70-43c3-8f1d-741c39e1a0e6	2.87	152.57	1.28	2.86	2026-04-26 17:46:23.696873	3576
116f0b0c-99bc-4284-be34-a8763f08c3ab	2.76	72.14	1.67	2.93	2026-04-26 17:46:23.696873	3577
303c7791-8997-4438-ace3-bd9a7a7af3c4	0.64	197.59	1.01	2.91	2026-04-26 17:46:23.696873	3578
a46cee26-7552-4afd-a7d4-5ca99238e8e8	2.6	157.51	1.93	2.81	2026-04-26 17:46:23.696873	3579
9cb18f9e-63fe-4579-a41e-e5f782f33987	1.61	210.88	1.79	2.38	2026-04-26 17:46:23.696873	3580
a418ca68-e9f5-4739-a62d-33c94119c313	2.66	256.44	1.76	1.37	2026-04-26 17:46:23.696873	3581
77a3d378-3dea-4aa3-a7f5-7d85a45b2b08	0.96	162.96	1.07	1.46	2026-04-26 17:46:23.696873	3582
796992b1-1d1c-4c72-b5d0-2f661bcdd5ca	2.26	116.93	1.77	1.68	2026-04-26 17:46:23.696873	3583
d120b9a3-e088-4a57-b7ca-0f1e5f0bbc37	3.21	205.76	1.95	2.68	2026-04-26 17:46:23.696873	3584
bb26c4bd-6b5f-4541-9263-5ffa9ce44a38	3.49	86.57	3.7	2.71	2026-04-26 17:46:23.696873	3585
1b88f539-bcd1-445c-91ef-f2389aefa47f	3.39	163.51	3.08	1.09	2026-04-26 17:46:23.696873	3586
21dcb036-b5c2-4347-86f1-dd9821202a18	2.73	254.08	1.01	2.26	2026-04-26 17:46:23.696873	3587
cd3e4d12-a1e8-4bcc-a3ac-bdb037d54f65	1.83	190.78	2.76	2.16	2026-04-26 17:46:23.696873	3588
7c2dff92-88b3-473b-a1ac-f563a1465fab	0.8	179.83	3.04	2.66	2026-04-26 17:46:23.696873	3589
7a5d92aa-ee96-4190-afbe-5305d11457c0	1.2	158.3	1.38	2.32	2026-04-26 17:46:23.696873	3590
97f54406-bbf5-4ac4-b333-90dee66684eb	2.73	218.07	1.4	1.02	2026-04-26 17:46:23.696873	3591
1ddab371-a75b-4379-b61e-f9fcff7ce097	3.29	244.34	3.59	2.39	2026-04-26 17:46:23.696873	3592
d76936cd-a489-4f46-badb-efdcd51e0121	0.83	104.68	1.28	1.29	2026-04-26 17:46:23.696873	3593
e0b3453d-63ac-4135-a222-6ce145c529f9	1.83	217.55	2.61	1.01	2026-04-26 17:46:23.696873	3594
e61c37c0-b864-4ae4-a2db-2b50b1090fae	1.35	160.43	3.59	1.86	2026-04-26 17:46:23.696873	3595
3a576557-968c-4c65-9c20-c116ef03faa5	3.2	59.3	1.08	1.85	2026-04-26 17:46:23.696873	3596
07838efa-5b31-4dd8-8d4f-a928883b60ee	1.36	270.8	3.33	1.24	2026-04-26 17:46:23.696873	3597
c595c14a-43e1-4a8c-87b2-5c4e74179fb9	1.43	87.7	3.02	1.63	2026-04-26 17:46:23.696873	3598
d71e773c-4cb3-4ae4-8c78-e59f21a60a5a	0.59	123.54	2.26	1.92	2026-04-26 17:46:23.696873	3599
9c17767f-b339-45c4-a57e-28e14851e190	2.63	76.04	1.33	1.19	2026-04-26 17:46:23.696873	3600
707e23b9-5293-45c5-bde4-9e41319c8c99	1.41	131.74	1.32	2.63	2026-04-26 17:46:23.696873	3601
00c68864-7854-4516-bab6-fa52741ae1d9	0.97	64.36	3.31	2.42	2026-04-26 17:46:23.696873	3602
1fa74a8a-aca9-4682-8770-0d1fe6f0918c	1.39	216.75	1.49	2.63	2026-04-26 17:46:23.696873	3603
da586753-c20c-41a3-aeff-6108198d4713	0.93	247.55	2.22	1.92	2026-04-26 17:46:23.696873	3604
fa6aff0e-c61f-4c99-af61-651804fc4564	3.03	143.2	2.18	2.2	2026-04-26 17:46:23.696873	3605
\.


--
-- Data for Name: creatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.creatives (id, script_id, format, asset_url, status, score) FROM stdin;
b3142849-fe78-4ce2-9a91-3aa0be840ea4	\N	video	pending	draft	0
b0d4f0da-f773-495a-9ee8-234b1854edfa	\N	video	pending	draft	0
9c13a415-acf5-4ddd-9b10-9092825043c3	\N	video	pending	draft	0
78feef44-99e5-476c-a9cd-a055d12d312d	\N	video	pending	draft	0
27d1940d-54f3-472c-bb68-f75f7cc7cd96	\N	video	pending	draft	0
cac4418a-7877-4a7d-97c7-51126470d452	\N	video	pending	draft	0
c4adc779-11a2-4129-bb65-64770dfdfec8	\N	video	pending	draft	0
4215dcc8-15fb-4d92-a06e-9ee54a3a830b	\N	video	pending	draft	0
f3d16619-5a28-4a37-a1a8-3edeb3239a9e	\N	video	pending	draft	0
c63a8bd6-26d1-47b1-863a-4271cbcc63b9	\N	video	pending	draft	0
083b503f-bc9a-4761-9232-985118e3bde4	66c91fd1-369a-4fcc-8b8a-77de610f2288	image	\N	generated	0.1
84898f92-b30c-4251-99c5-6d4b8ee07428	9af44914-8729-4269-b4c6-ff69960db5b0	image	\N	generated	0.1
1798c0d0-79e4-4d2b-9f3f-990b125d2105	4ce5624a-3c9d-455f-ada1-2b8c5d3c5c5f	image	\N	generated	0.1
d4454c95-37c1-4467-a22e-9fb7abac08a2	d42d6a12-2a67-451e-a515-5fcc9e97a367	image	\N	generated	0.1
1dc79f19-741d-4d47-8552-5e53debeed00	cdd8ee96-7ee8-4cd1-84e9-9999e12ef8f0	image	\N	generated	0.1
127074f4-ef1e-44c6-b9d4-6e159522fe6d	8d8eab50-1c65-440c-bfd2-e3ba1c98d895	image	\N	generated	0.1
933c3358-c4a9-4190-ba36-d320f41b28bd	424dd0d6-aec1-4027-8380-ebb1dead0b81	image	\N	generated	0.1
24c4b5e6-9375-4a3d-aa2e-8ecf73311e2a	4246688f-44d6-4980-a4a3-d773511dbe97	image	\N	generated	0.1
8459b204-828a-433c-946a-16940b23fe20	7ca844cf-0bd0-4c71-a174-14f2a13acf07	image	\N	generated	0.1
6c67de4d-14df-473a-b5b7-234ca1892d36	931e4a17-1290-4a3f-8ed5-36db7ccb6f31	image	\N	generated	0.1
1a1da762-8b17-44fc-ab54-aacee70233c0	7c0513e5-a3f5-46e5-b182-6a15cc107b69	image	\N	generated	0.1
eaf83308-161d-4cbe-9a8f-c87d75ee5421	bb62e7ca-a0fe-4c4d-b1ee-2824177fc488	image	\N	generated	0.1
2639cd66-3527-4a6d-b26e-dfb2491c1bf2	ca2eabe5-072e-4cb6-a8d0-77793bec2b01	image	\N	generated	0.1
8d34dd99-e669-4ca7-99af-1d91991a09c9	f3117122-94eb-4da2-86e3-c56e71784fb5	image	\N	generated	0.1
77398e9d-8c73-4cfb-9019-93696911c12d	dfca5310-eb41-4fe6-ac8b-5bf3ea935497	image	\N	generated	0.1
af79ed93-81e1-4dad-ab43-483f230ed7d4	c1e8f107-7146-4599-b305-6d31fc5b2cb7	image	\N	generated	0.1
a09b5914-31d8-4628-bfde-a2ed4f60f907	ad5e9266-27cd-4444-8155-3e388c2f4d49	image	\N	generated	0.1
af5d64a0-8fd6-4135-9b5c-ed9a17afe722	7b1b665b-bc65-4d43-9a62-4d2b282462f6	image	\N	generated	0.1
48f2ef4f-6f48-4a5a-8aca-e2844be19a4d	99733d0f-e03d-43eb-9bb9-32c65d50b83c	image	\N	generated	0.1
c4a5295a-ac7e-4505-ae47-069a3a50ecec	d7f596be-91dd-4bc5-b3f2-15974b9e06dc	image	\N	generated	0.1
ee150024-659e-474a-b0e6-7572deb8c96b	ca9c3f93-a9ef-492c-97cc-795bcc115ec0	image	\N	new	0.1
190d07d0-0fcb-4158-b684-2d4040e81a88	f2a6a642-6ea4-4663-8c49-e544be3d548b	image	\N	new	0.1
c719e005-76a2-4649-bf28-cd198aed1785	224a25c4-77c4-4104-bac8-1ec2085332b4	image	\N	new	0.1
7bd04403-df54-4387-b0e6-490f30ca3b93	1b7dd6c2-eb4c-453d-b56c-791eb197b218	image	\N	new	0.1
d5f651b8-c184-4284-bb6f-375b72a0c688	7eae75d1-51e4-4d14-ad34-630ed7db3a5a	image	\N	new	0.1
9e4b1c02-787a-46b6-9183-e197522ba234	fc6496bd-0ca3-4903-8453-45889dddae89	image	\N	new	0.1
086e6dbd-aea7-4a39-bbb5-145108c81fa2	493b5b50-d868-4ce7-a4c1-ff4165783e04	image	\N	new	0.1
289c883e-03d8-409c-bb2f-7c3cb5a43abd	29b71314-3986-4e86-b757-f4081bfd57e2	image	\N	new	0.1
77bac7e2-1be2-4f47-a1ee-42af525433ae	29d45795-e91e-44c4-a43f-984343f5bb06	image	\N	new	0.1
ecc58518-32d4-458e-a74d-f8957fe2d19d	b3500473-88a0-478f-8502-f0211830a6c8	image	\N	new	0.1
0cdc07b0-d122-4345-a871-ed8736125a13	fad9c39f-c1d7-4d09-91a3-641e7cb3678c	image	\N	generated	0.1
8be3185b-bc1c-4142-b567-48aaff220b01	c479e3f1-5578-48de-a890-4170ecc721e1	image	\N	generated	0.1
d9051e4d-d569-4f01-89e0-7d857762afe5	b2f0a7ea-29f6-4374-b784-691d3873bc2b	image	\N	generated	0.1
3fad7c09-4ab3-4a8b-aa29-7211513f7237	c1d98470-6b0b-4682-8015-c3ce947ccf8c	image	\N	generated	0.1
dbbf360e-7216-4601-8614-038fe1dcc2ba	69e24ab6-15ea-4e05-87d9-d533d3bd4149	image	\N	generated	0.1
9bd9f3c5-1b49-4927-8cdf-35373636ae00	030c1c2f-8367-491c-83b5-2fe94c233892	image	\N	generated	0.1
160d3adf-6a5a-4442-8c35-f8ff730e0036	518bb5b5-6d0f-415c-986a-d6df2dd4c0f8	image	\N	generated	0.1
5c42027f-8aaa-441b-990e-215c05fc0300	83b827fe-7c5d-4c60-b2bd-4ec94ce56e5b	image	\N	generated	0.1
bfc1d7fb-6dd6-42fd-a795-053bca272428	863e6709-5be0-47dc-82fa-30bdfed98bbf	image	\N	generated	0.1
fe19663b-26a2-40d0-a329-bf3f1f6a25a6	19444e0f-8898-4e33-8022-da0a0b7efa3d	image	\N	generated	0.1
09bcbc34-b01a-4878-88ae-4aac9ea91b2d	838a54a0-aabe-4ddd-9893-a25126c897a8	image	\N	generated	0.1
28aa7be3-ebf0-4bfb-9e4d-8eb57e7a1a09	1a675cd8-1265-49ba-b479-bbe773c4ddc4	image	\N	generated	0.1
a463568f-08c1-4eee-ba9f-87eca478959e	bec66dce-00f1-40ae-97c8-3b95ae47152d	image	\N	generated	0.1
e91e2255-deed-4ffc-9e86-da19ee4fe2be	cef0128c-73e7-4c04-8e49-d72277244254	image	\N	generated	0.1
e6c3818b-29f0-4e36-9052-5e1482339405	1cfb46fa-1acf-4f7a-b7aa-289cb2755237	image	\N	generated	0.1
80d81f80-2426-4c17-9e8a-321da7361798	699db022-3da1-43a4-8e3f-b4b73e095991	image	\N	generated	0.1
6f817b31-ed87-46bb-9e2e-1140f4cb4cbb	9763d16b-ccf2-43f4-a46b-042cadb8ef6d	image	\N	generated	0.1
34c9e297-d7dc-4168-a5a5-8e7e148dcbbd	e871daca-16a6-48af-b7ed-a1903a19cc86	image	\N	generated	0.1
06c52bbf-cbe5-4db7-997a-9f747283665e	8b728143-60fd-47d8-ba06-66fdb49197e2	image	\N	generated	0.1
0404794e-0a50-4824-a0ee-921cb23888ee	61e980ba-45e9-4857-8b08-cc1ad440143e	image	\N	generated	0.1
ff75e776-7227-4220-9f32-33a6013ae67f	673e9632-f743-48d4-9500-219395205d50	image	\N	generated	0.1
522e7eca-7dde-4bb5-9cfd-7bfc1f5aa823	ec19fb9a-3e29-4988-a7c1-adc00d340dab	image	\N	generated	0.1
0670c059-cbff-4d6e-97fa-c2dbd81ba878	ff14b1d0-6a11-4dad-914e-a50372d1cd50	image	\N	generated	0.1
41623b9e-303f-46b1-82d3-8883c4a479bb	57a95db5-673a-47fb-88fc-d8280bf28cf2	image	\N	generated	0.1
8425054a-27fe-45f7-a2d1-0ca5bb87c22d	ed975b55-8398-4e7f-ab2e-11a6edc9777a	image	\N	generated	0.1
88f2dc8f-4748-490e-b92d-e31ba6ddaf7b	ec8cd967-ef39-4422-916c-5b41698f84f5	image	\N	generated	0.1
71e03cf9-1c81-44c0-9c0f-63591e58aa30	2a231a6d-7760-47ca-b89e-e6ea7bdd5d95	image	\N	generated	0.1
bc2f02a5-cb1e-4610-ac0e-ba7f24c18ccd	34b41175-2eaa-4429-b185-cf1929636b5d	image	\N	generated	0.1
c110010b-1088-4e02-be3c-83c511d7831c	4f30e2c5-67c8-4844-8cec-112a93c2b730	image	\N	generated	0.1
fe8407a5-d6f0-4b63-b0c1-71ad87ffab96	31e34cd8-7eee-42d3-a132-86243b38d79e	image	\N	generated	0.1
19646a15-fc51-45ea-b837-9703ea5e5f8c	4f85d0ff-6815-471a-a0a9-0ccbe27ed4f3	image	\N	generated	0.1
048313b2-21ec-4fbc-be08-2f0c27fa77f6	95930088-dce6-41cb-8df6-d9185e302644	image	\N	generated	0.1
66ae13b0-bc41-401b-919a-a47c2d82b9ef	6f24980b-9013-4221-b78c-eca425f6c5e9	image	\N	generated	0.1
d87f65c7-d638-4f26-a825-aff5ae57457b	a2759bf2-47ee-4492-98b7-b318ca0a3ec6	image	\N	generated	0.1
7931d397-9cb6-40aa-888c-6b1cfe481a74	b135062b-c143-4473-a0a0-9283dc3f5abf	image	\N	generated	0.1
a63e2468-ff52-45a6-a5cd-59944a3859bb	f68347ae-bcfe-45b4-a42c-49a17588fe72	image	\N	generated	0.1
2c170f3c-70f5-4432-9675-baa82539a713	c6b804a5-14c9-4c6b-a796-49b3e83268c5	image	\N	generated	0.1
a49a8d86-d915-4488-b843-de71b33e91fd	3b4cb7ec-2e4d-4fb1-9e54-86360678b36f	image	\N	generated	0.1
b2cd1843-50e3-475c-b68b-24bcf035d14a	2aa78133-aae0-4227-bb39-a3085ae4dbe3	image	\N	generated	0.1
49214cd6-15b3-43e2-b004-f11980bd76e7	6856054e-c841-497e-96c4-1a644f8949a2	image	\N	generated	0.1
da38da3e-9316-49d8-af58-cfca2be2ecea	be2d1cc5-9c90-41cf-8b32-ab5d5e13c98a	image	\N	generated	0.1
06e503be-bdf4-4afe-9252-ad4307d77d34	f8f3b4dc-9638-4e45-b35d-1bbdeb583a93	image	\N	generated	0.1
e07bf42f-e0df-4ae0-8b19-59673c872bf2	dd5ab66e-3d1b-476d-90f1-c02de038d972	image	\N	generated	0.1
d9ff0e43-523c-4157-b412-c6e488086313	591f2209-4788-45b0-b51b-e5adaf02f5ae	image	\N	generated	0.1
73605445-18c0-4c79-aa20-abe75a2aa504	c82fd744-b408-40fd-8376-54c010131cb9	image	\N	generated	0.1
17d1d4a8-7fff-4e9d-be6b-1ad8cff6ebd6	82744681-6417-4f97-bff1-07319259aa66	image	\N	generated	0.1
0ff59da4-ea9a-48c5-9b60-96f17e2644b7	0e5b7c4f-7cda-4f64-8809-268fbb27a5c9	image	\N	generated	0.1
0c867821-28e1-489c-96ef-a33a16f96004	f7a34988-11fa-4c6c-b7fc-52e70064e6d4	image	\N	generated	0.1
6111d377-0b6c-4d93-b288-f7ebce6c00fc	412cb905-4b89-4b38-90e9-d684b1e008bb	image	\N	generated	0.1
18905b39-d6a0-4f41-8c02-9b817e1b009d	4b9e6a5b-6f0c-4ecf-96b7-8641b411048a	image	\N	generated	0.1
8b417aee-680e-4081-85f2-5a160fb2ff12	e5052887-2e87-4ae3-acd9-c47c78aa1d20	image	\N	generated	0.1
38b482a7-1f32-4ddc-9349-bcf1da86d546	5c8a7712-075f-48e8-b53f-b95574b09406	image	\N	generated	0.1
02152a87-fd48-4156-bd2f-afe94c4dc7a6	0d1695e4-f087-40d0-95bf-444090b0d3a3	image	\N	generated	0.1
6a47fed4-5e33-425c-bbc6-691c625d33a7	5b19880d-187e-4577-823a-a847d2f3b1a3	image	\N	generated	0.1
79cd4a3f-adcf-4ce5-9d29-62693c93adf2	9895c815-3119-467b-822b-d121c2ed48ee	image	\N	generated	0.1
c4391873-3533-4cad-977b-0323fced348e	c704ef6f-9904-40c9-914d-567db32cece5	image	\N	generated	0.1
c6338c80-214f-405b-9b0b-7594bb69d230	8a4949a2-91c3-4caa-a387-3662f6396a61	image	\N	generated	0.1
382f3f60-7d3c-4ffc-8b2f-94ce32b77254	dab300f3-03ae-4cb9-80b6-f84604873228	image	\N	generated	0.1
cf827a4b-a720-4825-84d4-29f047763f7e	df6c6902-bdea-4523-8222-84ac321363a6	image	\N	generated	0.1
d5806c60-9752-4845-9128-964d9b723f0b	aa3ab179-19c0-4d61-998a-52ca4578676d	image	\N	generated	0.1
96e0af22-02e2-46d4-8224-4db162bd27b6	5e9c94b7-b639-47e3-8381-f9ca68a462f6	image	\N	generated	0.1
9d0c77f5-485a-477d-80ec-8da875eb9852	9f3ff95e-e1fe-47e0-8798-aaa366aec137	image	\N	generated	0.1
c19c4f6a-3738-436e-b7dc-b27df3129b28	9c6edbeb-a161-4969-ac5a-715761580c16	image	\N	generated	0.1
2d78aa7b-b8fb-4cc0-9d8a-f6a927032041	3426a159-d6e5-47f5-b626-0726346784ac	image	\N	generated	0.1
dbebf850-836f-4532-807c-c1e3f5b5d597	b8ff28cd-c0f8-4c2c-809b-635f82f97196	image	\N	generated	0.1
453f03e0-cb8d-4681-b343-d681f27e84f8	7e4b4848-5506-4e0e-ace1-e45aceebe441	image	\N	generated	0.1
13d5f24a-3280-4db1-ae8d-4e7ac37dca9d	9bb46d70-d445-4d03-85ad-e86d2de467cf	image	\N	generated	0.1
40f8a8d7-327f-4f20-a15c-cbd9fb6f5e75	59c7d982-c015-48c4-ba63-246dbf52530f	image	\N	generated	0.1
8cfcaf67-4ae0-46c6-996e-6ce551b4096d	4a708a75-18a2-46ae-844a-7b16f9a94f06	image	\N	generated	0.1
05bb5c72-6613-4d45-a876-a6c5fb64222e	d88b8147-3326-4f5a-8b5d-8c8e2744e22d	image	\N	generated	0.1
37b80a41-5dec-4adb-ac19-126072ec4a13	232e5b3a-1589-4fc1-bd87-285fbfdac34b	image	\N	generated	0.1
514c19e7-d8eb-4f8a-b58c-db01659e571e	38f7c122-822f-4e21-bbbf-75014aa617e1	image	\N	generated	0.1
27ded357-dfee-45c6-844b-2108e05a105b	f55314fe-d50b-40ce-b638-b0a737417eca	image	\N	generated	0.1
affc16bb-f7a4-4ff2-90df-48caf7eebddc	34cc5fae-24bc-4dc5-afaa-f27587af59ab	image	\N	generated	0.1
cb0fe3b7-fbc8-479b-bd12-6acfeeeeffeb	82a57878-6af4-4c00-8371-a8f4d5bf65fa	image	\N	generated	0.1
c0f13516-b42b-4edf-8d54-260ed3432c91	230ede8f-a4b7-4589-9123-f6ebc169ed8e	image	\N	generated	0.1
a6b3ffd9-c2dc-4bf3-872f-1d4dfaff44ce	aeaeebad-9015-4006-a827-fa9338c5cfb0	image	\N	generated	0.1
4c18584e-0e3e-40cc-94a4-dd6106965efb	dafa769a-17c2-40e2-a78a-3e95cefb91a4	image	\N	generated	0.1
42be6f12-2662-427d-b3bb-9f8fb042cde5	14e10356-92c0-426b-a9c8-6ad7a4297171	image	\N	generated	0.1
a9a3a5fa-5c98-4e69-883b-2afa82b1877f	8ed32aa2-c871-4a8b-b72c-1c5298a18e32	image	\N	generated	0.1
69ceb13d-c6ba-480a-9bb6-8c94350b80bb	2bd3b353-e192-4fac-8f0b-b85a830bb9dd	image	\N	generated	0.1
6946eb18-50ec-477c-808d-f71c98670e15	1bf9a1b0-b062-4ba1-82f8-52d5ce55e99d	image	\N	generated	0.1
db738178-6c85-4003-814c-43efae201f66	e67193a4-b13e-4052-b14b-f18768eceb42	image	\N	generated	0.1
4b5f92c9-7d51-4b0e-a137-acd779a460c0	f9a68ddd-3b9c-4f60-bd0a-2df07edde64e	image	\N	generated	0.1
343b8afa-f5f3-413a-8faf-37c6af937323	1471d489-c894-4e39-ab22-92891d16f529	image	\N	generated	0.1
aa3eddc8-b910-47a9-b691-2ec377a4b6c3	a3d91a41-0d16-4182-8d49-2ac07cc6f966	image	\N	generated	0.1
10412ce9-7326-4907-98fb-f30f329eb834	56125447-eb08-4851-9aad-9a36bb5bb681	image	\N	generated	0.1
a7a83b3b-4904-468d-b1ff-79250bae2178	ec4d4491-64a8-4791-96ca-a6747930d42c	image	\N	generated	0.1
de64100b-0d55-4423-8139-e21bf67b1ba3	fa38f4df-4c60-43b8-9208-dc51fb224821	image	\N	generated	0.1
48f1cae9-db76-406a-84c3-4b1d3fd1f646	eb021b17-b13b-479a-90cd-ae38b47dfc61	image	\N	generated	0.1
bff99142-a62f-4628-a6ff-c053c6deb013	d75d1bad-33dc-4dec-8364-6ab068a69776	image	\N	generated	0.1
fb073968-3588-453a-85e2-75089d4c03f1	ce88727a-7d57-45c7-9561-d480828f36fa	image	\N	generated	0.1
377f4e07-93cb-4351-8c6b-62851338fdb0	1e31416d-8bbc-4ad3-acca-66dc5d434af9	image	\N	generated	0.1
19bdfc5a-e1d0-463a-b163-7d7a692f73b8	d9ec803b-13fa-40d2-a38c-6d6a40bb40bb	image	\N	generated	0.1
cbd20eb0-7239-4734-b82b-404600e7d66b	72b6bdb3-8aa5-416d-94d5-904f4c5d75bf	image	\N	generated	0.1
18c3479d-2072-411f-8d91-9a580608c627	9b1cb79d-a9fc-47cf-89df-78e198c42f1e	image	\N	generated	0.1
ca09ced3-7738-4c9e-887f-d34312c3d8e4	79944940-7b63-424f-b64d-1ed46405a713	image	\N	generated	0.1
07a6b221-981a-4cce-bb5d-3d5a872c97b7	130eaf1c-7f70-4054-920d-8d7fa23ea9ee	image	\N	generated	0.1
fa753e0b-bcb9-41b7-9c82-6fccd2333db1	5f1076ae-63cc-492a-8c39-47014def50db	image	\N	generated	0.1
100a7e1e-99f2-4b0d-8a9d-842a454a612f	2e46745d-0b42-43b7-9fc2-48135df3cd9f	image	\N	generated	0.1
41bd264e-1eb3-4ccb-ab43-221d92913239	6088940e-ee96-49be-a975-cfff9e06e38a	image	\N	generated	0.1
b80e97e3-fe08-465e-ac72-eea64d2d6182	7e5ecfeb-746e-42a2-a748-aa889c3d0407	image	\N	generated	0.1
ed596397-26d6-4d02-a2f1-dbbf5f8ab704	386f2e76-ef19-458d-a3d9-5df1031ff099	image	\N	generated	0.1
5d36c463-e893-43a2-b567-1e7fbcb3c80c	991201a4-437d-4f67-9fe4-465b213a6832	image	\N	generated	0.1
12e6bae8-cc3a-4a0d-b825-a37dd6092db4	d6c57720-b3d8-49a4-94da-30ac868c0765	image	\N	generated	0.1
b611f2f3-4dce-4565-9634-c5f67f16841f	cdc2ae3a-8ec2-42e4-8560-f56392794b16	image	\N	generated	0.1
af16d415-a7a8-426f-8d38-2ade72d8acb5	dcaaf785-b441-4bb5-90bc-a9c3fa17d558	image	\N	generated	0.1
a18f9d90-4ce4-4793-a9c1-9452712601a3	fcb0c1ae-d929-4909-ac1c-42e7c54f15d8	image	\N	generated	0.1
2421d8dc-3548-4b72-b606-b235ecdf5448	822d2b05-46f8-4db0-aedb-2707ace7852b	image	\N	generated	0.1
bb6389a5-9e20-4135-8648-8a813bb296b7	4ee4ab35-4da1-4217-a909-1703a9315d66	image	\N	generated	0.1
6447b600-e734-4067-87b1-b915998722b4	f7118b1c-026d-48b6-9c34-a83f79a8781a	image	\N	generated	0.1
a1fc9f0b-f1e6-4819-9cb5-1ce77541a1b5	72eab870-dd58-49b1-88fa-bc40f30a8bf7	image	\N	generated	0.1
25df9dd3-d744-4a1e-a96b-d1322d6952f5	bfc0f094-6bae-4e2d-b515-e8afd01b93a5	image	\N	generated	0.1
8e3909e7-8ee5-4db8-9278-087d2851a6f1	804567e1-2cb5-4226-b0a8-fe64e45cfce8	image	\N	generated	0.1
3fcc2af3-e524-4b65-9649-cc48a58b7463	573faf2d-ca28-4976-8a74-ed32b744c1b6	image	\N	generated	0.1
3045ab21-e78f-41cf-9f96-102cfd907777	336a0a3e-7186-408f-92b9-4509771ce656	image	\N	generated	0.1
211e6d92-06f3-4968-ab18-4d3606fb0313	d5bfde3e-537b-4771-92a0-1a5cd1754236	image	\N	generated	0.1
577c5ceb-5d82-4a67-914e-cc3249432558	d7a2288c-79e6-4afc-aa03-24a7c6b7d9c7	image	\N	generated	0.1
a9955bda-fedb-44d9-b5a6-33b7ceff70cc	556b9533-a8c8-43fb-86c6-f7ea2cbbef0d	image	\N	generated	0.1
cac6b96e-6c77-4c20-b201-5d059367fbf0	f2f2405e-a15e-4e0a-9617-bc700dfb80b3	image	\N	generated	0.1
40b83090-1da5-4f1a-85d6-884f75d306d9	078d9b00-caa1-4cb5-bab4-2cd1a109b69a	image	\N	generated	0.1
af6f8bce-ab49-4a79-a40c-4a4aba8d8552	2e16579b-94ea-4a2f-864d-25cf8094e154	image	\N	generated	0.1
7674a04d-8f67-4d07-9eab-998e344a03c9	c3ea426e-446b-4ee8-bc1c-c570b3872b7c	image	\N	generated	0.1
f97b5670-ef68-4a86-97c0-6385e6ae7405	ee4ab891-7e1b-4b9e-b02a-e5605b2b7b02	image	\N	generated	0.1
4fc26046-1ae2-4e60-99cf-95ef8ee6524a	cd4cd377-c405-471a-beab-62a92debc044	image	\N	generated	0.1
e332ef09-be23-4a9d-b003-f886bfae870d	30fa5388-a145-4f79-88d5-74a712eae2a9	image	\N	generated	0.1
88f0fd74-5fbe-402b-b1f9-8b0185f9b042	d9a1d1ac-9c42-4d27-965d-85997adc961f	image	\N	generated	0.1
7289ae0e-9605-4d46-aaee-5b05ddd96e59	3b48027b-c3c0-42d2-925f-04fa59f5eba0	image	\N	generated	0.1
b0318b61-a090-47a1-a30e-1f29ba099262	64852932-4e84-471e-9ddc-27a4b09682ec	image	\N	generated	0.1
26ec3ee2-f140-4f43-b13b-9299796dd2d1	034aa3e3-00fb-484b-a10f-3ba96e14fe04	image	\N	generated	0.1
9dab24c7-177d-4ec4-8c0b-2323b92d3d4a	409e705c-1d3b-4c61-abd3-6076140c2eda	image	\N	generated	0.1
1a6d5e85-787b-461f-8db7-9cd8f8d81ece	f504d1a5-29d5-4eb5-8730-30e4299d1c23	image	\N	generated	0.1
27b23042-92c6-4a49-b397-6c200041d8ee	340ac13c-66e6-4616-a738-5ad3e53de9dc	image	\N	generated	0.1
08f0acf7-18ec-45eb-8146-8042969d5c7a	5ad8dcfa-8d8d-41fc-b989-0f73233981d9	image	\N	generated	0.1
a03af7ca-2046-499e-b19d-b6571e696f89	c1ca9175-e2c9-495f-a3c6-11298192ced4	image	\N	generated	0.1
e7fd011f-5572-4ee9-a3de-2d9d4d5c818d	4b619ce7-7372-488a-b9d9-ee48cb107b71	image	\N	generated	0.1
4065ab51-f74f-42a2-9363-7146df43c932	89e935e9-e7e0-4494-838c-bb65f4ceea30	image	\N	generated	0.1
a07f2ed2-35ae-4720-ad65-a22fe59566d3	3af0c305-58db-42af-90b7-dd9b4efc8c08	image	\N	generated	0.1
02c4237f-a7f5-452b-82c3-1fe296af3c3c	ba7377fb-dc81-40a6-834d-670c09deab09	image	\N	generated	0.1
62b7cf0d-cf31-493a-85aa-8fa347acda25	0cadbb2d-24c4-4a82-a7f7-27f60a551952	image	\N	generated	0.1
ab3db038-d69b-451e-bba3-08e8119898b4	771b2e8f-206d-4cc2-b282-ae80c8cc6e8a	image	\N	generated	0.1
b685932b-8a27-4288-8795-f6e05e9e4cef	ce6762b7-7e3e-46e0-9886-b6ca5c0027b5	image	\N	generated	0.1
9cd7e4f4-8d1a-48da-abbc-075218e9e7a6	170bb8ee-7b96-41ca-9a9c-17b9e0321390	image	\N	generated	0.1
98d2ddcf-4cfa-4405-9501-d661884b1017	e7822cc4-83b6-4464-ab67-0bc58a6e43e9	image	\N	generated	0.1
d0655207-0783-4e94-98d2-176fe26849d8	9e98b6be-8783-467f-928f-60ff9b7c3a6a	image	\N	generated	0.1
bcad4d42-8a4f-4b72-a2e1-b607651d5c31	fbafdd74-cfed-4566-83f1-75d8597e7d95	image	\N	generated	0.1
9ed4929a-d3c0-4954-b272-227a89cbedec	f70d7dfb-2e5a-4e95-b5ea-c7e186eb3d7d	image	\N	generated	0.1
edcb7d15-e6ed-461f-b1b4-38a993ff2ec7	8cf7ffcc-5cb5-4f7f-9f44-122c1af5efb8	image	\N	generated	0.1
2f5d7c02-eadd-4eb2-8dd5-46a5ba51c3f8	0ef6160e-9f67-4e8a-871f-5e3b7bb5c328	image	\N	generated	0.1
0ad0a6eb-d13c-440c-b74c-0391605d9685	71e9741b-1f8b-4d70-832a-70f2cddd3813	image	\N	generated	0.1
2bb8c959-19b6-4951-8313-e6d0413c9a6f	6f9e9963-f647-44d3-9135-69690f20a2da	image	\N	generated	0.1
303a312c-4f87-408c-b20b-03d848ec9055	9cc600f5-b90d-4528-ba3e-9ba3b3a9192d	image	\N	generated	0.1
a32bfdcd-5dd9-4a93-85e7-c1e608df83ee	2cc6bd4e-e1b9-41fd-9c4b-b5d5e00004cf	image	\N	generated	0.1
5ccc6390-43ca-49f5-b6fa-84247d3e52af	bfd64608-24ef-423c-a760-130ea97b4369	image	\N	generated	0.1
df299e49-61f2-49ce-8051-e50cfc0b2650	9d9cbf6d-a548-4889-95ec-9c1c3ff9b091	image	\N	generated	0.1
86ef6ade-b308-467a-8c42-3c6e4c20ec8d	516220b1-1f8c-4b18-8682-6a3349650f58	image	\N	generated	0.1
e318d53f-7605-468a-b41d-051070be96a3	e83ef5f6-988b-4c5d-9fb0-bc0384b1eec3	image	\N	generated	0.1
efc0c233-0113-480b-b3e6-ca3275b5ffde	c7a83832-40f8-47e8-bb05-b097078dc96a	image	\N	generated	0.1
5808ae27-83d1-4163-9187-6a23f988dc97	4999a015-6398-4404-b3fd-bc549d2355de	image	\N	generated	0.1
e304e2e6-fd72-4399-b4d7-fb6416b81f0c	fd5f1279-e107-4f47-9391-d5c72f4ce2d0	image	\N	generated	0.1
678ae26f-569d-4c0e-b4a9-0a688fc0936a	711fb206-b49b-4bc7-96e7-8b79361db17c	image	\N	generated	0.1
6438657c-ee67-48b5-8de0-62eeb64e0a87	259da0b6-9437-4354-8629-e6adc9d242f7	image	\N	generated	0.1
e3216b17-e320-4d0f-ada0-b93e60caca02	f2c3df34-64c2-46e3-a4f3-3d86ca619d8c	image	\N	generated	0.1
63188d13-0344-4b51-aa79-19ea416c8cdd	bce294fb-1c21-4d3c-83b0-5648ab2fe866	image	\N	generated	0.1
17932bb9-836e-4db9-b27e-bd1b2f574954	db22b49a-7e80-4a4e-911c-d287ee41b877	image	\N	generated	0.1
459418c3-7fb1-4dd5-9c2b-6a0eb1e128a7	444612db-ffef-485c-b43d-928320cff072	image	\N	generated	0.1
4d88229f-55e4-476b-bfc0-096795c485e4	38ad435d-67cf-4700-ace1-9ee3cbbcc779	image	\N	generated	0.1
2ce612e7-1b0e-4a98-aab2-d00e087e7acd	ae8b882f-fcec-4a75-8c32-bd8f42af5bb2	image	\N	generated	0.1
f1c04ba0-d43a-4055-8726-0674ce5a9591	86c7febb-7802-4e68-96fe-0b641a807048	image	\N	generated	0.1
b4617646-5ec4-4d15-a573-c29cffb7c27f	84f277e7-4166-4dfa-be0d-d2e42cc1da82	image	\N	generated	0.1
c02600b3-e48e-4409-95a3-eb683e336b10	413349c8-f68f-4516-8d2b-dd5bf9dc47d2	image	\N	generated	0.1
fc365d4b-670e-4fca-8c15-bed27e9c7c64	9b71c1dd-3536-4f0c-b713-b98de5c7f8e0	image	\N	generated	0.1
b5bfff34-218c-48cd-b9ce-673eea91bda1	8d6b5528-8a57-4dc9-ae5f-52bb1085dbd8	image	\N	generated	0.1
0ef3d984-2e82-4672-bcd6-c49dfd8397b3	3fd50c70-1afe-43e7-bc94-86656ea77451	image	\N	generated	0.1
869589e4-a12e-4a97-9558-0e078bfadd07	1e1eeba1-d680-4ff1-9ac4-b891184dae82	image	\N	generated	0.1
fc37eb73-af1d-4f66-ab8d-ac6cd664ceea	1d78ca52-c1ca-45fb-ae1f-1565e49125de	image	\N	generated	0.1
f182189b-b6e2-4aee-bb22-5b1e555815b6	b10291cc-2eb3-4066-842d-643126c0d461	image	\N	generated	0.1
4a03155b-1956-495a-aa04-f02a9c3d31c8	3bcd22db-f050-4bf1-990e-e1955140c5a1	image	\N	generated	0.1
6b9cb1d4-e93d-40cb-8099-44f30eae119b	e9a5c834-139c-45db-9ab4-2b993e61da51	image	\N	generated	0.1
77c9a885-1040-44e4-8b7c-18dccb3b1a81	740d1b16-eb50-4c21-a908-86abf0a38e51	image	\N	generated	0.1
ab089221-71a5-4b3c-a06e-445f999eed0a	5d06d71f-8d4d-433b-a683-dda9e7e3e6b3	image	\N	generated	0.1
2954b16d-0db5-4232-8923-ca1c2a81be0a	8c9cff80-c54a-4d12-9ae3-0942ee3ac043	image	\N	generated	0.1
e072183d-f51e-4965-a227-e111304e8104	fbe66544-438a-42ec-9f8c-f8d847876827	image	\N	generated	0.1
d59dcfa3-ec8d-4789-81cd-22e13a9c829c	4318f833-dda2-44fe-a4af-6d84165aeff7	image	\N	generated	0.1
e32ad455-b5bd-49ef-b295-f81c8a11da16	226f373b-d4f7-4ae7-bbcd-4f6c08f46c0f	image	\N	generated	0.1
21d6e120-8fa3-4a51-9ade-436c7d77e075	1a7b0ac4-94ba-448e-8c85-0e58a266c720	image	\N	generated	0.1
efff145d-5625-4a2c-ac23-ffdccad3e85b	959e2060-3ad9-4409-9e13-4f546f4a473c	image	\N	generated	0.1
1a64a717-44a3-4308-9eaa-d6a37163544c	dbd0e22a-bcce-4037-946e-5f9eddc669d4	image	\N	generated	0.1
474c6490-57e2-4c5c-ad69-dc1c4cf6b1f5	2b210f3b-54a9-4220-80d0-5f1782b2bb9e	image	\N	generated	0.1
7f85773c-30b2-4ff2-877a-93f568213806	34ebaee5-8ad4-48a2-bd7b-780c9d41c1b0	image	\N	generated	0.1
4d87ace7-e3ee-4ea4-92f6-c395ef501428	81136f45-c431-4cf6-a6c8-4ccfc7ca4a7f	image	\N	generated	0.1
4d289278-e3f8-42ed-af6a-2d3259072f3f	6e251895-cdcc-4e5d-90f7-4fc5ddc6d5fa	image	\N	generated	0.1
ebffe864-14eb-465e-b745-192f6e5717bf	0e50f9a7-2915-4df1-a257-7019ff264535	image	\N	generated	0.1
fb9a49ca-e5e2-4be1-9e2c-5d77c4db770b	224ca70a-b633-4ec7-8a0e-6f34c5c9f8cd	image	\N	generated	0.1
150f7991-fbd0-429e-bdf9-c60b50b1aae6	492d7799-0a83-4c7c-ab88-8c823757fb40	image	\N	generated	0.1
569b5e54-a5e6-442c-94e0-64a8245dcd07	f4cda7c4-875e-4986-b652-4fcf560695d5	image	\N	generated	0.1
1525c80d-cf06-4108-bab9-0205f6ed78f7	8d9fb776-a316-4aa1-bee8-aa93402306dc	image	\N	generated	0.1
c6e7314c-8525-4191-80c2-2c3a921f415d	f88c0132-3217-4230-88d6-5d13fe63f341	image	\N	generated	0.1
01d04063-d9c3-43b8-9cd1-f2c365206958	59b34237-c2bd-4502-874d-7573847640f7	image	\N	generated	0.1
688a8c3f-fa38-4308-89d5-212d6faf8a77	12e61d73-e82c-4bac-bb03-a2da44d1e59a	image	\N	generated	0.1
80f0e0e1-a56b-4969-9328-300dd7d3889e	972991bf-8384-411d-8e75-3479aa9a1a80	image	\N	generated	0.1
bf4c1fb6-a269-4569-be90-6b6a998ee7b9	273283ae-f6e9-4fd2-a8c7-fc9a4d113497	image	\N	generated	0.1
4421a7a4-be54-4494-b732-9068a725e9b7	30c76af3-ba5b-4c20-90ff-2196b797bac9	image	\N	generated	0.1
5d9bfdd7-0a23-41a4-bff6-1d1b588e6b78	36db7ca3-3851-4159-95de-0f87933e95fb	image	\N	generated	0.1
9272aa0e-60be-48a7-b1a9-e260a3fcd3d2	f0f74e3c-545e-4318-b13b-f18c17bc4cda	image	\N	generated	0.1
cd6c4c38-b00a-4644-b1a1-7fc4b8c0ef46	54690207-21ab-4a49-a243-293efb1e6d52	image	\N	generated	0.1
903c34b0-9809-44ee-af0c-97ca045cde31	48f31bc3-4d9e-44aa-8079-7193101e3d28	image	\N	generated	0.1
ec564929-5d5d-4964-85c9-c2c00181550b	b430dbae-a37f-4933-bf53-4bb220af6705	image	\N	generated	0.1
eb5b0417-51b7-4630-89a7-fbac16715f99	616b4ff4-2bb4-481b-8879-f2828515f0f3	image	\N	generated	0.1
2f71377b-f84e-4d62-a2dd-610ad858eff9	9485838b-7711-448d-91ad-34f5f74693d1	image	\N	generated	0.1
ccefa4d3-0ac6-49b4-b548-44dbecf95314	4980e77e-0513-4aca-8f48-47c728b18367	image	\N	generated	0.1
641085c9-c0f6-4e22-ba3b-1fb94f36d101	cc6ae0fa-1ec9-4d02-8fa0-d1994c1c5d30	image	\N	generated	0.1
98771193-9965-407f-9a85-7fede6b77203	910d2e33-094d-4b86-aa3b-6e2ba2362c71	image	\N	generated	0.1
a4f48f59-b6eb-49b5-bda3-c4cbe0959ccc	b5d67a14-4e64-4a06-b6c0-51107c2aeb03	image	\N	generated	0.1
349fd483-5e87-4860-902e-0499901d0595	a0534bd2-9ed8-47f2-a595-bfe61b4ae0b2	image	\N	generated	0.1
9c9909c7-05a2-4227-acf9-28521c0da135	583b9645-0a3f-4487-8210-d9849a0d0eed	image	\N	generated	0.1
f305ad8e-b6cd-4ccb-8d44-e33845a294a1	fb733b26-eb1b-4c84-ac19-21b6e53afe49	image	\N	generated	0.1
baa2883c-e58b-4231-a08f-44235a4dea80	d4323fa1-4992-4de2-a48c-33c7b2450da4	image	\N	generated	0.1
0d8f1e65-863d-45d8-bd85-f7a7bb2a19d6	6da107b4-b94f-452e-94be-5ea2f904e6b5	image	\N	generated	0.1
1274b8fd-1c04-42fe-ae89-7ee5494a8909	360c8f8d-2c93-4fe4-9697-816037f7ac56	image	\N	generated	0.1
177aba49-3dfa-4284-870d-fb28b84d4534	95497327-6165-4ab7-84cd-3838fe66459d	image	\N	generated	0.1
a3e55969-7679-400e-b2f8-63e2955e54c2	b2499662-1d45-4d3b-aa9e-834932ef0f46	image	\N	generated	0.1
ccea675a-ef56-4f85-b8c5-317c8ce5a850	a04d5f18-7754-4063-9d53-caf7a01d1f79	image	\N	generated	0.1
3aa10c1e-2460-4377-b65a-f47990cf20a4	61c62405-b3f3-4c20-bed0-000d78d334bf	image	\N	generated	0.1
95049103-faa4-4e21-9165-033861d9c488	528333fb-a6fe-42dc-a9a2-a89ed4923f48	image	\N	generated	0.1
2c47bb0c-f0bc-43ef-97b7-ec4d8c96c29f	98339d49-74c0-461e-98e1-5447b8afee3a	image	\N	generated	0.1
c1b55a4f-d015-496a-97a5-0eda929e3dc3	b8d216cf-6639-4522-b792-1a5dc9eb44be	image	\N	generated	0.1
b8174b2e-1cb1-472c-ac48-c2a6912e48de	5170d295-f76f-4365-afaf-5744b0666f03	image	\N	generated	0.1
ef342171-814f-4d88-ba4b-9c3e820c63de	3646a368-e2b7-4396-bc98-7610171b8909	image	\N	generated	0.1
ff142781-a79f-4ff4-a703-7732aa9af9e3	684ec293-5fa6-444f-a8e8-b9e70471b711	image	\N	generated	0.1
53988c3d-02b2-4be9-95b5-739ffb19f562	abfbba91-7d56-4ee4-8067-a154254d6aee	image	\N	generated	0.1
90e0676d-9543-455e-b95b-033a3dc29094	9bc94a88-ace9-43fe-a9ed-6f2f2c177790	image	\N	generated	0.1
aa53d45e-4f36-4897-b499-3ed698190647	7c5b7074-7608-49d5-affd-f94ba956f7bb	image	\N	generated	0.1
0d2cac97-cb24-4e98-8c0f-4356b3e97f0a	4d5196c2-f573-4866-9c5f-2aaae69507e3	image	\N	generated	0.1
3781bb39-94d7-41ab-bddb-e6008d65fc3e	2b2c8b55-bebe-4b78-8ee3-8a97a5d61d6f	image	\N	generated	0.1
9c7b719e-b70f-4394-9ff1-ed98e6b5cc58	16bbf445-b315-4e26-9e26-a2393b248f41	image	\N	generated	0.1
e7450082-184d-42e5-9e10-1ba889b81e15	a380c129-2134-4575-a7d2-8b8cef053381	image	\N	generated	0.1
7f8cdea0-97fa-4f5c-a07d-339312618900	2b93061e-70ba-48ef-bfb1-a932c89f49f3	image	\N	generated	0.1
1cdd7dbf-0fb2-4741-b2ce-1648f6588f83	fdb1309a-f65b-47be-aa62-7faaedee33db	image	\N	generated	0.1
addb0a76-380c-4a6e-81a0-5642a291744d	e244aac4-c40d-4376-9355-5dfc53af9b25	image	\N	generated	0.1
37353a0a-b1de-4f16-ade8-742e357bff71	0aee3b31-8b1d-462c-9900-62e9f967029f	image	\N	generated	0.1
d806cbd2-e0cc-4e83-84a5-7e939ebd4b95	a816960f-bce8-44fd-b257-935532e42ae9	image	\N	generated	0.1
84970f72-5d25-45d2-96d7-3ed2f3315168	fb0d074e-77ed-49de-8751-03924355a4be	image	\N	generated	0.1
80fbbed9-4a78-4bd2-87e9-af704fc2de31	e507b2d1-f720-4e81-9ff7-98ddf2de30a2	image	\N	generated	0.1
8a2c8802-0ed7-4c68-b865-2b6b9b4e467b	2b8e44dc-af76-4299-9b91-334aa51d1b44	image	\N	generated	0.1
92491d57-33b8-476b-b82f-4d782b7925be	3733121c-87e7-406d-8a61-abadf11c8ff7	image	\N	generated	0.1
101a0017-9d06-4cab-9376-10fca55b80fe	42cac6b6-db0e-4650-9827-28aec37d1c4a	image	\N	generated	0.1
7a670221-9a34-46e2-b81b-1d7085b29ac8	2a7f1d46-706c-484f-989b-12570476e1b1	image	\N	generated	0.1
b486f1ad-7297-436a-929a-3696998a7284	e74a529a-4415-4cf6-9f54-0f508893e890	image	\N	generated	0.1
ef7e5768-abc3-451c-8700-eadd22e0526f	c13e985b-b576-43bd-a846-c07116f4e485	image	\N	generated	0.1
63993198-0f2e-4909-b4ec-c6e6b29c10e1	0f83c59e-894f-48d9-ae8e-37891f4a6b3f	image	\N	generated	0.1
785054cb-4641-468e-b119-e344676aba22	96efda3e-7e8a-45c7-9a18-2d6f5f600949	image	\N	generated	0.1
2641930a-9a92-4a93-a28c-017fc48fc1b3	a6138472-a810-458f-9219-ebb9d6004b03	image	\N	generated	0.1
4a2d3659-552c-4773-9281-2b75e2ba4bb6	13ece67d-af7a-4594-8854-99fdbd035893	image	\N	generated	0.1
78beb24a-058f-4cc9-864c-1d33949d4818	c6048d93-efac-4c04-9639-20b822e4f013	image	\N	generated	0.1
0889297c-d685-4c5d-bfc9-bba36110c15d	e96a429e-a78f-4c35-9510-e97ae7efd3af	image	\N	generated	0.1
acef61e7-7f4b-4b30-b6c5-425f9e36a90e	dd0d090e-3d47-4070-ad5c-0b7b5770bbd7	image	\N	generated	0.1
186f60d6-c7c7-467f-b4fe-fa7636f79a23	d3eed5c9-476f-4caa-addc-34a3f6f43a6c	image	\N	generated	0.1
4079e5e0-9e84-4432-b44a-32af8e59d4b6	30dbffd4-3520-48a4-ae5a-2978a005f217	image	\N	generated	0.1
29a4907b-3872-4537-b4c9-a42ef3e28b0e	38a98d5d-724c-4dc4-98f9-3d53f5e6ff2e	image	\N	generated	0.1
0881dc31-d7be-4ddb-99c9-8b6d0fa16990	371184cd-b71a-4187-a074-bc5a4dc019af	image	\N	generated	0.1
89e3921f-88ff-4fa8-9092-9e3260a671eb	43e295e0-71c9-436b-8d12-7e4ec121b357	image	\N	generated	0.1
22899238-2cb3-4920-ad5f-d00408f74869	f19f9a2a-712c-4fcb-b3e6-032120e03435	image	\N	generated	0.1
69b47d8f-7fea-4be2-b860-28261bd322a8	97e8f8ce-76c9-4eae-9387-85df2504aa3d	image	\N	generated	0.1
ed04eb26-1f11-4e73-bf37-9045f051da24	2bd52b53-522c-40b2-ba45-f2f1cb9362cf	image	\N	generated	0.1
82b0280e-102f-4227-8bdc-035191a662da	b09f653d-5448-4141-bb4c-73ca0a2a00f0	image	\N	generated	0.1
fc3455ee-1aca-499b-a15a-59daa28c0dae	90971154-1b26-46b5-a0a5-9dd831252224	image	\N	generated	0.1
73844c9a-3cfa-47e8-a779-2fd0f85cd1a4	90da206f-0378-41bc-8c6e-84b19a3fa3de	image	\N	generated	0.1
1395deb5-7679-416b-8a65-aaf8e835d7c3	47d95acc-9e3f-4267-8945-7d931cfd496e	image	\N	generated	0.1
6b95825f-39e7-468c-9658-f24c248a95ab	1aa8e75e-a677-4e7b-8fd5-8c3985434b08	image	\N	generated	0.1
ce7492b2-e891-474e-a19c-33b127c341bd	a09ac23f-0379-4eb9-8377-944baab42a23	image	\N	generated	0.1
29b851bc-bf09-44a9-8b92-fd986cecff07	6ebf92a4-f61a-4ce4-af23-c3094d4fce8a	image	\N	generated	0.1
18bd7af5-1bd8-4924-b5c8-04e122688eb3	e8969318-dbb4-4109-ad5e-c40c01946e2d	image	\N	generated	0.1
0901b3ca-de69-4dc6-8669-6257957ae39e	850737df-cacf-4f65-a0a8-569ad6b188fc	image	\N	generated	0.1
ecb61af6-0fbb-4eb0-bea9-b8c9f2fb8c69	487107b9-d3c6-4e39-b992-e549f858d17a	image	\N	generated	0.1
fa086000-f37b-4715-a2af-e114d3776051	8c830f1c-488b-4e81-8ff8-8eecddf1bd68	image	\N	generated	0.1
0ebae568-62bd-4e44-9ff7-798a7cf02baa	0c1aba4f-b5d7-4134-bca7-3c27991df4dd	image	\N	generated	0.1
8c5171fd-392e-49b3-9c7a-cac95ad4b712	d0445f0a-7d5a-4679-a821-c8909327cffe	image	\N	generated	0.1
00b72f94-9185-4684-b9c9-7391caff4082	684eda63-7488-4990-b248-127285655144	image	\N	generated	0.1
4108c416-a720-408e-b90c-c674d5e86d0c	f375ed3f-c5c6-4e46-a5e8-f673caae3b4b	image	\N	generated	0.1
d930d57f-4865-49e1-b97c-e8d38ea33778	b71c2fb5-64fa-4f92-a807-94ad9b4ff7e8	image	\N	generated	0.1
94ee1380-d4a5-45d7-aca4-98acc362d2ea	709775a4-bb62-4bc2-80f7-667166a750fe	image	\N	generated	0.1
fdc902c2-6087-4d6f-80c4-06dc3417dd09	babce5cf-36b8-420a-9166-f7d7de8fa28a	image	\N	generated	0.1
a8c53a76-9bd2-4da8-bcc2-507bf0391475	9dff43a3-b35f-45d0-acc7-b13fc8b0994b	image	\N	generated	0.1
ec48173e-93eb-43f2-986b-837f4d9ea0a3	904352aa-28f3-4b8b-9d72-71e23ff6bd63	image	\N	generated	0.1
4cf14171-7f85-401b-a1ed-240a930297d6	914fa68d-983a-4766-a0bf-c233526ae46a	image	\N	generated	0.1
5e2c38bc-5335-4dcc-b5fd-60f7c7da1f1d	eb6cb7cc-12e2-4328-a63f-769eefdb9171	image	\N	generated	0.1
6d78a687-8013-4ecd-8edc-b3eaf641d308	eae13c74-3271-47bd-9a9f-1de925b4e7d8	image	\N	generated	0.1
b4db985f-3cb5-4e0b-8269-75c0205a4a76	439bbf41-17b4-41b7-aa6d-f99ac557d3a1	image	\N	generated	0.1
e740dd73-61ff-47b3-b096-021863c558ef	6ecc9c68-44d8-4a4b-aa02-4c6a0c8cd073	image	\N	generated	0.1
f0f9852b-d33b-4d90-85f0-2672b9b52d4a	027381d0-1ca3-4d37-a6a4-0f75db489eb6	image	\N	generated	0.1
f7edc0a3-fffa-4af1-94d2-7ae07b266ec2	f26dcde1-d6bd-4404-9ca7-95c9753a7fc9	image	\N	generated	0.1
bfcf2856-cd19-4b19-9e9c-310f6f0c9823	9b79e144-0d30-4127-b1b3-f97f3b500156	image	\N	generated	0.1
3bf47c34-9cd2-4cac-a2f2-72a77040dc8b	978b04bb-6b9b-40b8-93a4-c824191433fc	image	\N	generated	0.1
f025cb63-fae9-478d-afac-8cd17a79f540	7c2c3342-941f-4137-8e8b-e2308e155df9	image	\N	generated	0.1
ddfcdeb7-606a-45f0-97b5-cb4b4ea01288	478916da-9356-4538-9508-89c3ef0fe4cf	image	\N	generated	0.1
bf95b772-5939-480b-9689-b8de3b17819c	8ffb2692-0865-46e2-99e5-02ce6c2076a4	image	\N	generated	0.1
79fae5b0-e815-4e6b-979c-3d40dcf82296	9ad0d99b-b389-4864-a21b-858a4c24a015	image	\N	generated	0.1
ab8c21a9-bb71-4b4f-aead-976a688c8f5b	80dbe3cf-1381-41e7-9000-480dd556191f	image	\N	generated	0.1
f9ad0b21-3622-4955-864f-b6acb6a20375	70474a76-f8a5-4fec-b8a6-872ee53dbf8a	image	\N	generated	0.1
aef0ef1f-cf70-43c3-8f1d-741c39e1a0e6	59459005-9568-4050-9861-c59c5b207499	image	\N	generated	0.1
116f0b0c-99bc-4284-be34-a8763f08c3ab	44f85f0a-e7f6-42e7-a625-d4df3a26769c	image	\N	generated	0.1
303c7791-8997-4438-ace3-bd9a7a7af3c4	bbf5bd9c-642b-46dd-8faf-9ea16ddc2112	image	\N	generated	0.1
a46cee26-7552-4afd-a7d4-5ca99238e8e8	cc66d7f7-5065-44b4-8d3e-43ebd8637080	image	\N	generated	0.1
9cb18f9e-63fe-4579-a41e-e5f782f33987	59db586e-4b36-4fe0-a118-5b86e6180c41	image	\N	generated	0.1
a418ca68-e9f5-4739-a62d-33c94119c313	03382ae0-ccd2-4c59-9526-c2cad363b327	image	\N	generated	0.1
77a3d378-3dea-4aa3-a7f5-7d85a45b2b08	01c540ee-2971-4341-84f2-451aaf8856f5	image	\N	generated	0.1
796992b1-1d1c-4c72-b5d0-2f661bcdd5ca	6f3762ed-5ffe-4e9b-a579-a5073c76b4f0	image	\N	generated	0.1
d120b9a3-e088-4a57-b7ca-0f1e5f0bbc37	2c9462ad-1010-49d8-8b6c-ee0acbf69fed	image	\N	generated	0.1
bb26c4bd-6b5f-4541-9263-5ffa9ce44a38	4ba9de36-3e25-4da5-9587-f971bc5789c5	image	\N	generated	0.1
1b88f539-bcd1-445c-91ef-f2389aefa47f	3bd631e3-c801-4ff0-9945-989b0b131bf2	image	\N	generated	0.1
21dcb036-b5c2-4347-86f1-dd9821202a18	05e5daf6-2391-4e0f-9815-e6402cef6752	image	\N	generated	0.1
cd3e4d12-a1e8-4bcc-a3ac-bdb037d54f65	b417d5ce-c83f-45a5-97b2-3e6569b9040e	image	\N	generated	0.1
7c2dff92-88b3-473b-a1ac-f563a1465fab	d08bea7a-3183-495a-8921-9b0c6eeef2c7	image	\N	generated	0.1
7a5d92aa-ee96-4190-afbe-5305d11457c0	54c518c3-042c-4de9-b74d-ebd4c5955276	image	\N	generated	0.1
97f54406-bbf5-4ac4-b333-90dee66684eb	9d82e4e6-41ba-4cd2-85cb-fb931650b7e4	image	\N	generated	0.1
1ddab371-a75b-4379-b61e-f9fcff7ce097	4838b30d-80e0-4dd6-a9e8-ed54b3645830	image	\N	generated	0.1
d76936cd-a489-4f46-badb-efdcd51e0121	008e99d4-28ab-4c8c-8c1e-5ea9c375efc3	image	\N	generated	0.1
e0b3453d-63ac-4135-a222-6ce145c529f9	0507c4f4-22d9-4807-8772-14fe68cc78dd	image	\N	generated	0.1
e61c37c0-b864-4ae4-a2db-2b50b1090fae	61bd340e-88d6-48c5-a7f1-d464b2e7da3f	image	\N	generated	0.1
3a576557-968c-4c65-9c20-c116ef03faa5	68bedddc-9b49-4ce8-bcc3-b867522725c2	image	\N	generated	0.1
07838efa-5b31-4dd8-8d4f-a928883b60ee	2fdca709-8fe5-4a71-8991-a399e142488f	image	\N	generated	0.1
c595c14a-43e1-4a8c-87b2-5c4e74179fb9	d0f3d919-cc82-4f7f-b333-d85ee6f6f0e0	image	\N	generated	0.1
d71e773c-4cb3-4ae4-8c78-e59f21a60a5a	961dab15-2404-4211-97f1-6a2f25eb46d8	image	\N	generated	0.1
9c17767f-b339-45c4-a57e-28e14851e190	bb968435-ce0b-48d1-8f8a-447b9a13572d	image	\N	generated	0.1
707e23b9-5293-45c5-bde4-9e41319c8c99	7f6d1246-6226-48e6-bc84-6ff423cd6c33	image	\N	generated	0.1
00c68864-7854-4516-bab6-fa52741ae1d9	8c3ab64a-e99d-4976-8044-be80d750b01a	image	\N	generated	0.1
1fa74a8a-aca9-4682-8770-0d1fe6f0918c	ec4afb8d-2472-4758-86bb-7ba7d542f808	image	\N	generated	0.1
da586753-c20c-41a3-aeff-6108198d4713	0448c939-5782-4214-9736-fc4d3e4ca216	image	\N	generated	0.1
fa6aff0e-c61f-4c99-af61-651804fc4564	e533e3f6-bb44-43db-8637-4f6397e49cb0	image	\N	generated	0.1
b1fbf5bf-015f-411e-bda5-c548828928f7	0f9587ff-f210-42c7-a3c3-34c21078abae	image	\N	generated	0.1
3d44429a-1122-467b-8ad3-0ebb7eac3ff5	08154935-9c28-4917-8c0d-b283a65a95a4	image	\N	generated	0.1
9f329a19-d8bd-4087-b958-ab1eee613494	c32fdc7a-2ef7-4412-8501-3d94c97a631a	image	\N	generated	0.1
6235687b-80ef-44e4-8431-ef5750867485	bed16258-095d-4b83-affd-d323148f80c7	image	\N	generated	0.1
d5645a4e-3891-44cf-80db-79737def4243	ca669c2f-e9e4-451d-97d9-21f5dcf98d2d	image	\N	generated	0.1
bde600f7-6539-4181-87b2-7406982a6e83	00f871d0-be59-4dc5-814d-63fadb836e85	image	\N	generated	0.1
77614a19-70c9-4c39-9fe0-a1fa8c11f5b9	1089e080-9a3c-46bd-b980-fd933583bfd3	image	\N	generated	0.1
69c5a87e-fd6e-4f1a-99ee-59225e26f0eb	a8d9db5a-bba5-4738-b404-41a24facc171	image	\N	generated	0.1
583331aa-8e5c-4bf8-817d-3247188566c3	b1010600-c1ff-41ab-8eec-595af9ae4cc3	image	\N	generated	0.1
2d57537f-08dc-4d12-b11b-15b43887e428	4e28a16c-41b9-4733-b936-dd2bfb685d24	image	\N	generated	0.1
\.


--
-- Data for Name: experiments; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.experiments (id, creative_id, variant, status, started_at) FROM stdin;
d8f1f795-3d0b-44c9-8532-70aca48d1523	latest_batch	v1	running	2026-04-25 21:49:28.264849
231a43e7-60bc-47d1-a45d-1414d57773f8	latest_batch	v2	running	2026-04-25 21:49:28.264849
2b94a636-ef2f-4ecb-95df-c160c077d584	latest_batch	v3	running	2026-04-25 21:49:28.264849
73ae2167-59d3-483b-921d-28271381697b	latest_batch	v1	running	2026-04-25 22:16:44.343106
a31ac4cc-12da-4a8f-91d8-f014b915f712	latest_batch	v2	running	2026-04-25 22:16:44.343106
30d21776-a4d8-4ea6-ab5d-2d3c8f116a48	latest_batch	v3	running	2026-04-25 22:16:44.343106
6323b0eb-031f-4c17-86a4-d67742606073	latest_batch	v1	running	2026-04-26 07:32:35.000623
8d7e9074-b251-4d27-8817-61b465d343b1	latest_batch	v2	running	2026-04-26 07:32:35.000623
b76d9159-4b07-4b3e-bc28-0f28bc5561c6	latest_batch	v3	running	2026-04-26 07:32:35.000623
f422eacd-b6a6-404a-963e-bd57edaf7ab8	latest_batch	v1	running	2026-04-26 11:04:20.472539
217959ab-f69b-4a42-9a79-be46ee6a691b	latest_batch	v2	running	2026-04-26 11:04:20.472539
2ece1c4a-a1d7-495d-8e3c-6a46d8ee4d32	latest_batch	v3	running	2026-04-26 11:04:20.472539
886cb2cb-1b92-447b-bc7a-0facc4e71f93	latest_batch	v1	running	2026-04-26 11:04:23.154311
20124ca5-bed3-44b4-b784-34b52ff2aa76	latest_batch	v2	running	2026-04-26 11:04:23.154311
983b2751-fbde-4f9b-81da-72fa7e3a3ff8	latest_batch	v3	running	2026-04-26 11:04:23.154311
99b131ba-9387-4b12-9f08-41c165ecc32d	latest_batch	v1	running	2026-04-26 11:04:25.96956
a7af05e5-76b5-46bc-932b-930d875805f2	latest_batch	v2	running	2026-04-26 11:04:25.96956
b8c9b677-3b66-44f0-b8dc-f2e07967a8a1	latest_batch	v3	running	2026-04-26 11:04:25.96956
3475439e-843b-453e-860f-26ffbcb221f7	latest_batch	v1	running	2026-04-26 11:04:28.790613
7d84ee0e-5b2d-4bc3-8c2e-c30cbba2b3fa	latest_batch	v2	running	2026-04-26 11:04:28.790613
3db24583-85e3-43df-9454-014fe599c34d	latest_batch	v3	running	2026-04-26 11:04:28.790613
5eda89b2-858b-4074-aa23-2921f1e4bcf9	latest_batch	v1	running	2026-04-26 11:04:31.460561
b98f6e8f-25b0-45ba-88a8-2ffc898acd27	latest_batch	v2	running	2026-04-26 11:04:31.460561
28bbf95a-1de7-445d-9c28-5948767ed497	latest_batch	v3	running	2026-04-26 11:04:31.460561
cd6f5244-c2fb-4714-907a-ee9c026fee5f	latest_batch	v1	running	2026-04-26 12:07:42.667488
12ab0117-3d72-4167-8bc5-94764eeac8fb	latest_batch	v2	running	2026-04-26 12:07:42.667488
fd4e8dac-8348-4ef7-ae85-6747f3655029	latest_batch	v3	running	2026-04-26 12:07:42.667488
24f2b8ce-ea3b-4714-9330-2fae6b990aff	latest_batch	v1	running	2026-04-26 12:07:46.515242
c06ee255-67bb-4d49-bfd3-91fd64bbe370	latest_batch	v2	running	2026-04-26 12:07:46.515242
3fc66d33-20d7-4d13-92dc-220c671ba49f	latest_batch	v3	running	2026-04-26 12:07:46.515242
d29467ee-f965-4bd8-b7f4-85337e1723d1	latest_batch	v1	running	2026-04-26 12:07:48.927926
ad0e52e0-9673-4953-ac4e-09e60a226707	latest_batch	v2	running	2026-04-26 12:07:48.927926
4fb6a122-cae8-4ea5-9351-570185352737	latest_batch	v3	running	2026-04-26 12:07:48.927926
a9f8ce89-3627-4405-89e6-716ec75b829d	latest_batch	v1	running	2026-04-26 13:06:38.260321
7cb32dca-476f-4c94-ba5e-2f9e1d69d0b0	latest_batch	v2	running	2026-04-26 13:06:38.260321
94ecffea-5634-4517-8586-5e9702c209d3	latest_batch	v3	running	2026-04-26 13:06:38.260321
8199b178-1ed8-43b1-8ca9-9ca6f405d249	latest_batch	v1	running	2026-04-26 13:06:43.739341
ced1c725-d23a-497d-b3a7-e9e24c0f1410	latest_batch	v2	running	2026-04-26 13:06:43.739341
db218c82-e572-47b3-b77f-884587371457	latest_batch	v3	running	2026-04-26 13:06:43.739341
3a8a33b7-e3c7-444b-a917-56d0f3fcf7b0	latest_batch	v1	running	2026-04-26 13:06:45.580556
6afc6779-2ba0-4dab-820c-4af4a21716d3	latest_batch	v2	running	2026-04-26 13:06:45.580556
818b4dad-e45c-4baa-b52a-5992b696ee16	latest_batch	v3	running	2026-04-26 13:06:45.580556
4ace1c5d-7982-472c-b080-48d8dfff238b	latest_batch	v1	running	2026-04-26 13:17:51.057618
821144a7-93f8-4d30-8d97-4177cbf82e49	latest_batch	v2	running	2026-04-26 13:17:51.057618
3e7a1409-763f-4229-9f7c-dcd19568204b	latest_batch	v3	running	2026-04-26 13:17:51.057618
113eeeab-7a7e-4210-9c75-a491510134a8	latest_batch	v1	running	2026-04-26 13:17:52.870068
af6a190a-918f-4da4-a102-10be7854873c	latest_batch	v2	running	2026-04-26 13:17:52.870068
4a1b41f0-d118-4f02-8a8c-b5a396d04d1c	latest_batch	v3	running	2026-04-26 13:17:52.870068
804a7292-f512-4148-b272-4d2a798bcbf3	latest_batch	v1	running	2026-04-26 13:17:54.68979
476b892e-8683-4577-b52f-c452bc95f5c2	latest_batch	v2	running	2026-04-26 13:17:54.68979
e038ae21-5f40-4640-a1b6-4af7ed1784cb	latest_batch	v3	running	2026-04-26 13:17:54.68979
b038f0a1-cdb6-48d6-af17-d9827817571b	latest_batch	v1	running	2026-04-26 13:17:56.496098
3bd31be8-9264-45fa-a441-26e57987ef82	latest_batch	v2	running	2026-04-26 13:17:56.496098
2f76f551-bc10-4473-9bae-3c2963a89e97	latest_batch	v3	running	2026-04-26 13:17:56.496098
1fc29fa7-8e1d-4b6b-a12c-5c3dd82b3e85	latest_batch	v1	running	2026-04-26 13:17:58.344975
29c29368-35e3-49d3-a117-ee6a168d7673	latest_batch	v2	running	2026-04-26 13:17:58.344975
1adcbff6-a85a-4ae0-b060-5612661f80d3	latest_batch	v3	running	2026-04-26 13:17:58.344975
b5f78ab6-25da-47fa-92db-f7f4f1339d89	latest_batch	v1	running	2026-04-26 17:46:18.899331
bd82f4ac-5c95-47f8-8614-93815ce153b2	latest_batch	v2	running	2026-04-26 17:46:18.899331
5b01d086-de73-4bcf-bd5b-2b7a25dd2c9d	latest_batch	v3	running	2026-04-26 17:46:18.899331
0dc7aa3e-04c6-4c8f-89e3-0761dc918178	latest_batch	v1	running	2026-04-26 17:46:21.700762
05ac1816-3027-4838-a5ea-e26663ea1b3b	latest_batch	v2	running	2026-04-26 17:46:21.700762
c2ae24c9-0134-4a87-bf87-1e2a6f6e6319	latest_batch	v3	running	2026-04-26 17:46:21.700762
366dae9c-1c9e-4501-bef1-731c3eefa1a0	latest_batch	v1	running	2026-04-26 17:46:24.545992
5cf1d47a-42ee-48db-9cdc-3d6af03b4bfe	latest_batch	v2	running	2026-04-26 17:46:24.545992
91967903-0a20-401e-9f3a-a12342f6d713	latest_batch	v3	running	2026-04-26 17:46:24.545992
\.


--
-- Data for Name: feedback_log; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.feedback_log (id, policy_id, success, latency, created_at) FROM stdin;
3a564908-cbab-44ea-b827-ca2862f87e92	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	596	2026-04-24 11:49:51.509228
4caace60-94f3-40ef-81bc-e590d00a7370	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1094	2026-04-24 13:38:45.500999
ffee9672-3f2c-4384-8234-c6d9406c1854	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1056	2026-04-25 08:01:47.579147
488d59c9-556d-4d8b-84ef-96ff3c6b5714	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1089	2026-04-25 08:41:04.446908
8d174289-b2b8-4737-ae3d-2276aba478ad	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1089	2026-04-25 08:48:36.901518
801db111-3757-4e83-9ded-8561a7b079c0	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1082	2026-04-25 10:41:16.499822
28b7efd0-7485-4195-8165-8d732b724f5f	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1281	2026-04-25 10:46:26.463908
5422cf5e-8041-473d-983a-fbf33b2e4a21	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1084	2026-04-25 11:24:22.803696
e4cf168e-af9c-4208-b799-1149ab231fc0	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1198	2026-04-25 11:28:56.93926
c6ce7b7a-cefa-4fc5-a7d3-2d87c214e915	cf08168d-22ef-465b-883f-f2392036b1a7	t	1088	2026-04-25 11:40:25.937108
2abd0c61-a92a-471f-b093-61b6dfde9594	9f1e02e2-eba0-4ac9-965c-8d6170267fab	t	1086	2026-04-25 11:41:29.491122
eb1bcd50-9b48-4016-88a0-f45ee0e3318e	19c2264c-5bd3-4f27-b66b-855f40a81830	t	1095	2026-04-25 11:48:45.478291
ab21c310-ba9e-474d-bac0-a55073650e8d	a2c53d62-d5e3-4597-b2b4-9487cb801909	t	1097	2026-04-25 11:48:49.246259
037bc5f4-6aef-46ea-9109-d008f43a1dac	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1091	2026-04-25 11:48:51.361461
1a00a600-085c-4011-9588-d015c7410ec2	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1082	2026-04-25 11:48:53.433327
a77d61a1-a384-4664-b000-49c6cc2aaab7	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1082	2026-04-25 11:48:55.767386
35bcf1ef-0cf2-4c79-a21e-cdc441696943	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1060	2026-04-25 12:01:29.229226
e03f65e1-4ddd-4cab-af7c-2a919f143e19	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1061	2026-04-25 12:01:30.838536
f3d595ef-a6bb-419a-87e4-0f08af3701e5	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1058	2026-04-25 12:01:32.429702
40afc11a-fa6e-4bbd-8b28-f782f4af3a0a	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1062	2026-04-25 12:01:34.038787
1db92492-eae0-477a-85e9-c4a322738e19	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1059	2026-04-25 12:01:35.648341
2a06936f-5a4a-4f3e-b455-fc288db57d18	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1062	2026-04-25 12:23:52.529298
52882e23-ff58-4724-b24e-535aa6a20402	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1059	2026-04-25 12:29:46.161105
b179393d-a0ef-48fc-b8fc-14e8c13f18c2	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1087	2026-04-25 18:42:59.143271
a985fc24-9266-4762-938d-f222d314b494	129a8c8d-54b1-43f9-a7c2-75993315998a	f	107	2026-04-25 19:18:24.516209
61277187-6a59-4352-a0f0-0e086c15b52b	129a8c8d-54b1-43f9-a7c2-75993315998a	f	196	2026-04-25 19:24:20.412029
2b39f60a-7d4b-40a8-a296-fa039c23483f	129a8c8d-54b1-43f9-a7c2-75993315998a	f	95	2026-04-25 19:30:25.263316
9bc07280-7cf2-4b95-b735-141de7a43e06	129a8c8d-54b1-43f9-a7c2-75993315998a	f	83	2026-04-25 19:33:42.437629
ccf6bc29-86b4-4f42-b293-d2218830b236	133de373-d757-4e31-8932-1de0179ea366	f	84	2026-04-25 19:34:25.27634
6a3631c6-7544-4990-958b-babde198d157	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1186	2026-04-25 20:11:27.430281
e18e9fa3-f9d2-4890-a71f-809a49e2da44	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1528	2026-04-25 21:49:28.273529
1a141722-3feb-4d9d-b9cc-7334adf25be9	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1514	2026-04-25 22:16:44.358565
3167a6ac-a6b4-43ef-97f9-91ec0ed8f49c	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1956	2026-04-26 07:32:35.014564
51e97f31-9063-4a44-a0e4-d288b59d8381	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1174	2026-04-26 11:04:20.487029
589d4b78-c650-47da-aed0-362dd118f9b1	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1151	2026-04-26 11:04:23.164634
894daf30-131d-4d32-a817-8f33aa7a6edb	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1185	2026-04-26 11:04:25.986764
9af7ab19-83b1-4252-8012-89ceef3115e2	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1154	2026-04-26 11:04:28.802466
47bb1ed7-1570-4de6-b833-a381dae472e1	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1160	2026-04-26 11:04:31.466111
1322a94b-5b17-4f63-9778-ad58db0a6dff	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1134	2026-04-26 12:07:42.672686
2dca6208-8aa2-4336-b08d-677583707078	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1133	2026-04-26 12:07:46.520281
aeb8f5e3-a07b-487e-89f4-dd27b1709f76	ce6ca3dd-00b4-4376-b91a-891ea3ec5e18	t	1125	2026-04-26 12:07:48.937363
ec620728-71f4-4eaa-8285-f81343a10000	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1080	2026-04-26 13:06:38.264927
e2ad385c-068d-43fb-8f15-c3278b5e22c4	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1064	2026-04-26 13:06:43.743759
b530f382-c8c3-4bac-8832-ec99b593dbc2	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1068	2026-04-26 13:06:45.58426
b27a1bc6-dbe3-41a0-8db8-3a3e0985c617	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1068	2026-04-26 13:17:51.062089
5b8e1bb0-5d55-4160-95c8-4e17b82f3f5c	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1067	2026-04-26 13:17:52.874405
bf86aae6-9e46-4ceb-b2d1-f52728f6a7c0	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1068	2026-04-26 13:17:54.694185
fd10a6f6-b4de-483f-9d83-ad315fab508b	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1068	2026-04-26 13:17:56.500105
be92f763-9647-4be1-a9cb-900242789253	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1074	2026-04-26 13:17:58.350911
26891ce0-d86a-4f3a-b274-c7d5fadc85d6	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1141	2026-04-26 17:46:18.905291
73e9b9c2-6b56-4a88-b765-ae53afd08e6a	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1093	2026-04-26 17:46:21.709251
4eaaf2db-2408-449f-b1ab-a0b53f9137c7	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1106	2026-04-26 17:46:24.553389
\.


--
-- Data for Name: hooks; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.hooks (id, product_id, category, text, score, created_at) FROM stdin;
876a2515-0fd7-451b-8390-b5deb73f9a34	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 11:28:55.858524
71578107-e883-496a-b37a-2eaa2d9cd9b4	test_product	generic	This changed everything	0.1	2026-04-25 11:28:55.858524
57bc71e2-21dc-419a-b889-6293002766b3	test_product	generic	This changed everything	0.1	2026-04-25 11:28:55.858524
f099b95a-b8ad-4651-a151-ee8764617f61	test_product	generic	Hidden secret revealed	0.1	2026-04-25 11:28:55.858524
9150ddc2-85d5-4498-8a52-39d8a447170c	test_product	generic	Nobody talks about this	0.1	2026-04-25 11:28:55.858524
c1cfb3f5-b5a5-4613-bc99-71e58b3db5f6	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 11:28:55.858524
2b18793b-c349-406a-a2a1-0fce352ecce0	test_product	generic	Hidden secret revealed	0.1	2026-04-25 11:28:55.858524
dffe37d1-5833-4810-b668-3a3fec39ea2e	test_product	generic	Hidden secret revealed	0.1	2026-04-25 11:28:55.858524
7a05fedd-c50e-44ab-9dc4-dbc3bd73241a	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 11:28:55.858524
a8f9bec7-b253-4745-8260-a3cffc143599	test_product	generic	This changed everything	0.1	2026-04-25 11:28:55.858524
e0adb874-6e57-46c6-922e-e1d2e2e6a670	test_product	generic	This changed everything	0.1	2026-04-25 11:28:55.858524
c3455e6a-90dc-4be9-9c5e-eb2e3c7e2a0b	test_product	generic	This changed everything	0.1	2026-04-25 11:28:55.858524
e30c02cf-e7b7-4feb-be78-7fc1fc578b2b	test_product	generic	This changed everything	0.1	2026-04-25 11:28:55.858524
f58b5a55-1cfe-4036-a5b9-1dad6407a45a	test_product	generic	Nobody talks about this	0.1	2026-04-25 11:28:55.858524
eb87efd3-891a-428a-afde-32bbb1442fb0	test_product	generic	Hidden secret revealed	0.1	2026-04-25 11:28:55.858524
e62959e0-b84c-4022-8ba3-228cf76a6a6f	test_product	generic	Hidden secret revealed	0.1	2026-04-25 11:28:55.858524
d67ad4d6-53ba-4a1b-9dea-09dd682494f6	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 11:28:55.858524
afe8f229-66c3-4566-b34a-b270e6867e47	test_product	generic	This works in 24 hours	0.1	2026-04-25 11:28:55.858524
168eca8f-2149-4626-9120-fdebd7b4b361	test_product	generic	This works in 24 hours	0.1	2026-04-25 11:28:55.858524
3f744025-0207-437d-9d66-93981b4ed0a7	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 11:28:55.858524
be731db3-3361-4106-8daa-21dcddfb3e28	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 11:28:55.858524
ea40d9c0-f316-4c22-a8d9-2a9b1b76656a	test_product	generic	This works in 24 hours	0.1	2026-04-25 11:28:55.858524
1c90f3c4-938e-478f-bfbf-2f310cb3e9f1	test_product	generic	Nobody talks about this	0.1	2026-04-25 11:28:55.858524
13125cf6-8418-48de-9369-d339b1a9cb9f	test_product	generic	Hidden secret revealed	0.1	2026-04-25 11:28:55.858524
48bfa792-8542-4b58-94ee-8d1a49b6489c	test_product	generic	Hidden secret revealed	0.1	2026-04-25 11:28:55.858524
0458ec95-5b24-4d04-86a2-256c3c09d250	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 11:28:55.858524
67b32ce0-f6ca-42c5-ac01-2eede62b4018	test_product	generic	Nobody talks about this	0.1	2026-04-25 11:28:55.858524
1f20aed0-6be5-4270-ae08-4fd3af94e02c	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 11:28:55.858524
3070a937-1ed5-418b-8ed6-39e54d6068b3	test_product	generic	This works in 24 hours	0.1	2026-04-25 11:28:55.858524
c1679a55-ade2-45f0-bc18-145bb3d28729	test_product	generic	Nobody talks about this	0.1	2026-04-25 11:28:55.858524
68f5c972-1c2b-4324-9a04-c413877de710	test_product	generic	This changed everything	0.1	2026-04-25 11:28:55.858524
9ac6c917-cfcd-423f-b97f-87281b4360b6	test_product	generic	Nobody talks about this	0.1	2026-04-25 11:28:55.858524
32e88c88-667c-47c7-a8ea-3ebc6f04ad65	test_product	generic	This changed everything	0.1	2026-04-25 11:28:55.858524
df7d676a-1306-49d4-823d-3222de4213f5	test_product	generic	Hidden secret revealed	0.1	2026-04-25 11:28:55.858524
b4d11b5d-3791-4482-9f6c-231f7d57ca90	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 11:28:55.858524
56880abc-68a7-4c01-a957-c7b51be9cdab	test_product	generic	This works in 24 hours	0.1	2026-04-25 11:28:55.858524
7c039d91-6843-4bbe-ac0b-0fa377aa9fc3	test_product	generic	This changed everything	0.1	2026-04-25 11:28:55.858524
e4c24a30-1310-42a8-99fc-678ac731f296	test_product	generic	Nobody talks about this	0.1	2026-04-25 11:28:55.858524
3fd578a4-22db-4b3a-8295-8a73d28c7af7	test_product	generic	This works in 24 hours	0.1	2026-04-25 11:28:55.858524
52270451-1505-4d0b-9db7-04494e9e17eb	test_product	generic	This works in 24 hours	0.1	2026-04-25 11:28:55.858524
37803e9c-7a03-4fdf-bead-56737778ea83	test_product	generic	Hidden secret revealed	0.1	2026-04-25 11:28:55.858524
9debe291-b36a-42ce-8f94-7e1fd97722e8	test_product	generic	Nobody talks about this	0.1	2026-04-25 11:28:55.858524
c7c05f49-4dea-4d11-9d26-ee19a9493144	test_product	generic	This changed everything	0.1	2026-04-25 11:28:55.858524
654cbfce-ba9f-4b93-a430-e930ea8c156d	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 11:28:55.858524
56144bd7-6234-49d0-b627-51aca3e2a644	test_product	generic	This works in 24 hours	0.1	2026-04-25 11:28:55.858524
24296821-e688-4efa-82c6-0d2ecd842878	test_product	generic	This works in 24 hours	0.1	2026-04-25 11:28:55.858524
d9e8df60-d9d2-43de-84fb-5f24964df139	test_product	generic	Hidden secret revealed	0.1	2026-04-25 11:28:55.858524
69225b4f-f5e7-4469-874c-8f6c4f5114de	test_product	generic	Hidden secret revealed	0.1	2026-04-25 11:28:55.858524
b1518d5e-e0b1-401f-bd1d-c1a512d9193d	test_product	generic	This works in 24 hours	0.1	2026-04-25 11:28:55.858524
832f2d8e-14db-4f5d-b8c8-df7e638afcd6	test_product	generic	Hidden secret revealed	0.1	2026-04-25 11:28:55.858524
64033866-7d81-42c9-810e-39d821a8d374	test_product	generic	Hidden secret revealed	0.1	2026-04-25 20:11:26.347657
e0b0c7ee-ec38-4c0b-8138-c1a41c3ebd04	test_product	generic	Nobody talks about this	0.1	2026-04-25 20:11:26.347657
cdb6466e-75d3-4e43-9bce-e948ebc3cb04	test_product	generic	Nobody talks about this	0.1	2026-04-25 20:11:26.347657
b88c3c9f-fbd5-4a50-af0d-d19fb5ad4aca	test_product	generic	Nobody talks about this	0.1	2026-04-25 20:11:26.347657
4e370532-0fa7-40f6-9c8b-411f661f795c	test_product	generic	This changed everything	0.1	2026-04-25 20:11:26.347657
91e17af1-d966-4d72-ab88-b3e38b8fb99a	test_product	generic	Nobody talks about this	0.1	2026-04-25 20:11:26.347657
af49fe65-31a0-4edc-b9ff-e44f2f60c794	test_product	generic	Hidden secret revealed	0.1	2026-04-25 20:11:26.347657
4bee565a-ae19-4c66-8720-2ad182b044c7	test_product	generic	This works in 24 hours	0.1	2026-04-25 20:11:26.347657
4027dc06-fbae-4931-ad7a-b6da7d708209	test_product	generic	Hidden secret revealed	0.1	2026-04-25 20:11:26.347657
3ca65e08-89e7-45ec-9f36-9623f24a3cbe	test_product	generic	Nobody talks about this	0.1	2026-04-25 20:11:26.347657
51fccaa3-59e1-4262-99f0-7e42e4d76008	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 20:11:26.347657
4ef2e37f-2f6b-4c47-8b79-fc0928eeec8d	test_product	generic	Nobody talks about this	0.1	2026-04-25 20:11:26.347657
9e9687c8-001d-48a2-9c76-41ef33254ae9	test_product	generic	This works in 24 hours	0.1	2026-04-25 20:11:26.347657
63895ee5-f1a9-40f4-94da-d74d3acfffca	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 20:11:26.347657
35b29c8f-f9f0-425e-95ae-45bf5e2c1b61	test_product	generic	Nobody talks about this	0.1	2026-04-25 20:11:26.347657
91a11f52-cdf6-430a-bae9-7a6d1fdbb8c0	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 20:11:26.347657
022bbb13-27ca-4642-ac05-a0253ede2532	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 20:11:26.347657
bc204221-4114-4b9f-bb45-0730ba7cf6eb	test_product	generic	This changed everything	0.1	2026-04-25 20:11:26.347657
06539ec9-97ce-4c88-a4fa-8d99d4f73053	test_product	generic	This changed everything	0.1	2026-04-25 20:11:26.347657
df452228-489d-4deb-87ab-299ea7f55b98	test_product	generic	Nobody talks about this	0.1	2026-04-25 20:11:26.347657
9b43efe3-63b1-4cb1-a546-71b824539c9d	test_product	generic	This changed everything	0.1	2026-04-25 20:11:26.347657
d67cd885-b855-411e-8b5c-1f4c54471358	test_product	generic	This changed everything	0.1	2026-04-25 20:11:26.347657
5a97bb9f-0453-4f02-9fbc-4f082423b14b	test_product	generic	This works in 24 hours	0.1	2026-04-25 20:11:26.347657
5f5b38fa-df4e-4864-a4c4-678a47d6526d	test_product	generic	Nobody talks about this	0.1	2026-04-25 20:11:26.347657
eadf884f-c2b6-44ec-88c6-5b8542de118b	test_product	generic	Hidden secret revealed	0.1	2026-04-25 20:11:26.347657
7dc0ec40-62d4-4d55-b688-ba13ea0b9555	test_product	generic	Hidden secret revealed	0.1	2026-04-25 20:11:26.347657
685c637a-6720-43f7-b6db-cd86fbfb5cd7	test_product	generic	Nobody talks about this	0.1	2026-04-25 20:11:26.347657
cb5514e9-80dd-4f35-b70d-79c3b17f0d8e	test_product	generic	This works in 24 hours	0.1	2026-04-25 20:11:26.347657
402f9d83-54bb-4cb4-ba74-ec975772c064	test_product	generic	Nobody talks about this	0.1	2026-04-25 20:11:26.347657
39a83e5a-85ea-4f91-8d81-37bf3381b10e	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 20:11:26.347657
0ee6905e-6601-4658-9906-93543ab1dacf	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 20:11:26.347657
be503a8e-8751-465d-b10b-fb77ad170f2a	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 20:11:26.347657
9744e1ef-1033-4d4c-912f-8bf00788da08	test_product	generic	This works in 24 hours	0.1	2026-04-25 20:11:26.347657
77eb1fc2-c5e8-4fdb-a852-1f83f1b15d16	test_product	generic	This changed everything	0.1	2026-04-25 20:11:26.347657
2e067ac6-c53d-45ca-8664-208395909df1	test_product	generic	Nobody talks about this	0.1	2026-04-25 20:11:26.347657
54657b2f-82f8-4c5c-b63b-f14aa981fa45	test_product	generic	This works in 24 hours	0.1	2026-04-25 20:11:26.347657
d3c3030d-9b7c-4faf-8957-1fd5e08fe9f5	test_product	generic	Hidden secret revealed	0.1	2026-04-25 20:11:26.347657
4ca6113d-9be2-4239-9ba3-059ec0e9e964	test_product	generic	This changed everything	0.1	2026-04-25 20:11:26.347657
ac2b4e61-06ad-43a9-9302-7e844cfbb76c	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 20:11:26.347657
273e4fdb-5be2-4fdc-afe7-ce7e91406f92	test_product	generic	Hidden secret revealed	0.1	2026-04-25 20:11:26.347657
674dc603-c242-4606-8a6b-65d1b200c5bd	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 20:11:26.347657
e8ec3be6-739d-4c30-b00f-385503942eb5	test_product	generic	This works in 24 hours	0.1	2026-04-25 20:11:26.347657
83d5dcdd-e6b8-4096-a0be-94d8c6e302a3	test_product	generic	This works in 24 hours	0.1	2026-04-25 20:11:26.347657
038e0173-ad81-4a01-8b44-cde09bf1c3f5	test_product	generic	Hidden secret revealed	0.1	2026-04-25 20:11:26.347657
a224f8cc-ef11-49e7-88c6-3309008ce988	test_product	generic	This changed everything	0.1	2026-04-25 20:11:26.347657
46d3a3b6-c21c-4dec-bfb5-e545ff7c6637	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 20:11:26.347657
c71ee8fb-9d03-4ed2-b378-a2912aa77cbe	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 20:11:26.347657
539dc106-025f-45d2-8379-3d1dc54e147d	test_product	generic	Nobody talks about this	0.1	2026-04-25 20:11:26.347657
2f989827-bc5e-4810-b82e-627d8ab6a2be	test_product	generic	This changed everything	0.1	2026-04-25 20:11:26.347657
56bb0f19-3ae0-4ee0-b247-d8471d9024b1	test_product	generic	This works in 24 hours	0.1	2026-04-25 20:11:26.347657
aa2e5144-57b8-451e-9eda-1e94eaabeeb4	test_product	generic	This changed everything	0.1	2026-04-25 21:49:27.190669
aa6e7be1-2a39-4baa-b191-1c1c06be1067	test_product	generic	Nobody talks about this	0.1	2026-04-25 21:49:27.190669
a6de8c65-0cef-4d0f-aabb-dce09c67e3bd	test_product	generic	Nobody talks about this	0.1	2026-04-25 21:49:27.190669
5a910c43-25c4-47c5-b088-c28620eda035	test_product	generic	This works in 24 hours	0.1	2026-04-25 21:49:27.190669
d4414ff0-96c0-4fc9-b089-fb007e9b1b35	test_product	generic	This works in 24 hours	0.1	2026-04-25 21:49:27.190669
889703ea-58cf-4148-8ada-6697ebd6b7ec	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 21:49:27.190669
52c91ae4-9374-4665-88cc-786c01b00c35	test_product	generic	This changed everything	0.1	2026-04-25 21:49:27.190669
8df2b58a-a065-4584-aa7f-77d0fe9db350	test_product	generic	Nobody talks about this	0.1	2026-04-25 21:49:27.190669
86c33d62-b721-45db-995a-b9bfb52dddd1	test_product	generic	Nobody talks about this	0.1	2026-04-25 21:49:27.190669
6dd404e6-8760-4e0b-bded-a7baf7f473ab	test_product	generic	Hidden secret revealed	0.1	2026-04-25 21:49:27.190669
fd0477ce-1902-45f8-a083-72ccc0e9655c	test_product	generic	Nobody talks about this	0.1	2026-04-25 21:49:27.190669
c462b65d-d2fd-4fd9-838a-7cf26610c6a2	test_product	generic	Nobody talks about this	0.1	2026-04-25 21:49:27.190669
3f46e853-5f03-493f-b5db-c454ed6e13cb	test_product	generic	Nobody talks about this	0.1	2026-04-25 21:49:27.190669
7220e718-eccd-447c-8b6d-7cf322050005	test_product	generic	This changed everything	0.1	2026-04-25 21:49:27.190669
bb1c79b1-6526-4d65-9da5-e4996e57bde6	test_product	generic	This works in 24 hours	0.1	2026-04-25 21:49:27.190669
504db8b2-aa42-4a63-89cd-a144b1d4509e	test_product	generic	This changed everything	0.1	2026-04-25 21:49:27.190669
ec6cbd64-9e1a-4ee1-bf58-db1c4839f1d0	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 21:49:27.190669
62bcae5b-35b2-461f-9986-bd09503cd691	test_product	generic	Hidden secret revealed	0.1	2026-04-25 21:49:27.190669
7a6504bb-2133-4068-9a95-7e505026a63e	test_product	generic	This works in 24 hours	0.1	2026-04-25 21:49:27.190669
19648e6f-ef90-449c-800a-3a3494926f01	test_product	generic	This changed everything	0.1	2026-04-25 21:49:27.190669
76398d33-254f-4f95-9a4e-4e141e2ffa4d	test_product	generic	This works in 24 hours	0.1	2026-04-25 21:49:27.190669
9836e8ce-e498-4c59-ac99-a4b5df8efc1b	test_product	generic	Hidden secret revealed	0.1	2026-04-25 21:49:27.190669
19d351b6-15d5-4efd-a51b-218abae774a0	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 21:49:27.190669
3b651e72-3e95-44cd-b68e-080565b32445	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 21:49:27.190669
9eb472ec-f821-4331-9deb-2cbb23ac3878	test_product	generic	Hidden secret revealed	0.1	2026-04-25 21:49:27.190669
bafa7739-38a8-41c6-b43d-51986a4e07e3	test_product	generic	Hidden secret revealed	0.1	2026-04-25 21:49:27.190669
4e8f1ee5-612c-4126-869d-6308df13e25d	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 21:49:27.190669
72cd349f-f34c-460a-856f-5ca2219ba1cc	test_product	generic	This works in 24 hours	0.1	2026-04-25 21:49:27.190669
2df5b8a8-f54e-46ff-b165-66b1f281fc3b	test_product	generic	This changed everything	0.1	2026-04-25 21:49:27.190669
938a550e-150d-4225-abdd-88b75a626c81	test_product	generic	This works in 24 hours	0.1	2026-04-25 21:49:27.190669
55a8d0fd-860d-42ad-a389-ceb5ee25b6ae	test_product	generic	Nobody talks about this	0.1	2026-04-25 21:49:27.190669
9639a522-192e-49af-b476-18d051796fb5	test_product	generic	This works in 24 hours	0.1	2026-04-25 21:49:27.190669
17522ef5-0df7-4d4b-9fc5-efae338aefaa	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 21:49:27.190669
4c0c4f49-94f5-47b4-8831-e045958dd016	test_product	generic	Nobody talks about this	0.1	2026-04-25 21:49:27.190669
c64b6feb-e158-43f2-b18b-506617708015	test_product	generic	This changed everything	0.1	2026-04-25 21:49:27.190669
50c87e3c-3d3c-4714-9b69-8ae953b7a697	test_product	generic	This changed everything	0.1	2026-04-25 21:49:27.190669
59a6f181-7b3e-43a7-b0d3-10f7f701cd60	test_product	generic	This works in 24 hours	0.1	2026-04-25 21:49:27.190669
4912f325-e762-400f-bd8c-8c7af3bd49b8	test_product	generic	Nobody talks about this	0.1	2026-04-25 21:49:27.190669
4435ca15-91ba-4492-8fde-86cd39adb3e7	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 21:49:27.190669
9a1807d8-99ff-4dcb-af88-a11d1f616569	test_product	generic	Hidden secret revealed	0.1	2026-04-25 21:49:27.190669
96de761a-8121-4524-af7e-fdac0dda9a9e	test_product	generic	This changed everything	0.1	2026-04-25 21:49:27.190669
97b0b7b9-bdd5-44b7-b62c-0f7b42cc2724	test_product	generic	This works in 24 hours	0.1	2026-04-25 21:49:27.190669
acd7db09-7a34-4744-9302-6e46caf23a1b	test_product	generic	This changed everything	0.1	2026-04-25 21:49:27.190669
519d4f60-6541-41ee-a7c8-de9560b2fc2b	test_product	generic	This changed everything	0.1	2026-04-25 21:49:27.190669
8a367569-ed88-4b7b-9428-d25906eebf8b	test_product	generic	Nobody talks about this	0.1	2026-04-25 21:49:27.190669
7b5ab40b-c1cf-4f4a-98a0-65b0e5e56cc9	test_product	generic	Hidden secret revealed	0.1	2026-04-25 21:49:27.190669
39691a9c-ab44-4762-aa13-20b3ebb19ca9	test_product	generic	This changed everything	0.1	2026-04-25 21:49:27.190669
cbd8feee-7a4c-4755-a0f7-7d9f3ceff485	test_product	generic	Nobody talks about this	0.1	2026-04-25 21:49:27.190669
4624e236-4f80-4808-a755-3eda03c006c3	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 21:49:27.190669
12149587-213c-4fa5-9ef7-19a5542d1166	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 21:49:27.190669
2b8a748b-84df-428c-a29e-ec931dc8304a	test_product	generic	Nobody talks about this	0.1	2026-04-25 22:16:43.284689
503e7b51-cd90-43fc-a698-a1a1e3d9df15	test_product	generic	This changed everything	0.1	2026-04-25 22:16:43.284689
ce2950d8-7e6c-448a-b366-484af3da6d25	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 22:16:43.284689
d0418046-e0cc-4144-be8d-786a2cc206b4	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 22:16:43.284689
fe37b667-b28b-4793-8842-6850197999f6	test_product	generic	This works in 24 hours	0.1	2026-04-25 22:16:43.284689
5df9463c-2baf-4c1d-9edc-6428c978aca9	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 22:16:43.284689
d60ad3a9-9a24-4a22-9eef-6f9660d593ef	test_product	generic	Hidden secret revealed	0.1	2026-04-25 22:16:43.284689
201f2acc-c45f-44f8-8439-8a9665d5f070	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 22:16:43.284689
13e13428-2236-482b-9944-98f82c3fdf91	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 22:16:43.284689
b6aceab5-8614-40fb-8506-5e92ab9fe963	test_product	generic	Hidden secret revealed	0.1	2026-04-25 22:16:43.284689
ce7310b2-b98f-4dbf-828a-75892d99d676	test_product	generic	Hidden secret revealed	0.1	2026-04-25 22:16:43.284689
961fa655-ae8e-4900-8a52-dc66edb4c467	test_product	generic	Nobody talks about this	0.1	2026-04-25 22:16:43.284689
572ef662-8ac4-4448-9a3d-2c00a39b9bff	test_product	generic	Hidden secret revealed	0.1	2026-04-25 22:16:43.284689
95ec7bb0-9f65-4e9b-8082-37e65479f526	test_product	generic	This works in 24 hours	0.1	2026-04-25 22:16:43.284689
68d0851b-8e59-48e2-966e-03c4ff7c6669	test_product	generic	This works in 24 hours	0.1	2026-04-25 22:16:43.284689
73486014-9e81-41d7-ac71-955bdee6f6f9	test_product	generic	Hidden secret revealed	0.1	2026-04-25 22:16:43.284689
9880de47-a12c-4a8c-a761-56f3d8947b02	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 22:16:43.284689
94b11611-d9b5-4730-9307-443cb65753e0	test_product	generic	Nobody talks about this	0.1	2026-04-25 22:16:43.284689
5a58f257-b1a6-4b98-89ea-72f5acc6d073	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 22:16:43.284689
ff087f2b-3417-44f0-9f18-77eeee75a840	test_product	generic	Hidden secret revealed	0.1	2026-04-25 22:16:43.284689
6660b0ae-5f55-4b04-9ec3-23f4a84a2318	test_product	generic	This changed everything	0.1	2026-04-25 22:16:43.284689
70822c17-321e-4dab-9193-a1b2bee0c4fb	test_product	generic	This works in 24 hours	0.1	2026-04-25 22:16:43.284689
52fc5566-9a14-4fed-aee0-0124e6ef47d1	test_product	generic	Hidden secret revealed	0.1	2026-04-25 22:16:43.284689
439594c6-6680-4fb8-813a-2ebd9d0dfbe0	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 22:16:43.284689
0a1f54fc-718c-4eca-910d-8fe91a65f58d	test_product	generic	Hidden secret revealed	0.1	2026-04-25 22:16:43.284689
4fbed40b-019e-4c89-8497-06b2c30fa8b3	test_product	generic	This works in 24 hours	0.1	2026-04-25 22:16:43.284689
17ec13a3-e915-4c75-ae49-57a6b77c4573	test_product	generic	Nobody talks about this	0.1	2026-04-25 22:16:43.284689
e92cc79a-cb46-4a8f-84a2-9e199b3e25e8	test_product	generic	This changed everything	0.1	2026-04-25 22:16:43.284689
170be697-d35c-43dd-891e-f93da100880b	test_product	generic	Hidden secret revealed	0.1	2026-04-25 22:16:43.284689
291bc053-2bb4-423f-a936-5656206c041f	test_product	generic	This works in 24 hours	0.1	2026-04-25 22:16:43.284689
5e861b6e-fe4f-437a-a32b-b726eb65971c	test_product	generic	This works in 24 hours	0.1	2026-04-25 22:16:43.284689
3a60439f-9ac9-425b-a4ca-abf6978f2689	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 22:16:43.284689
9075cd3a-ab1a-40da-81e2-094ebb93cf57	test_product	generic	This works in 24 hours	0.1	2026-04-25 22:16:43.284689
4223cc57-5230-433b-9a13-147be415a107	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 22:16:43.284689
e3c5d366-a89e-4c66-8449-eba25f138012	test_product	generic	Nobody talks about this	0.1	2026-04-25 22:16:43.284689
340bbe03-73c7-4600-9e3d-016ce114c408	test_product	generic	This works in 24 hours	0.1	2026-04-25 22:16:43.284689
8ebab941-cd60-4411-aa20-f563cc7ce32a	test_product	generic	Hidden secret revealed	0.1	2026-04-25 22:16:43.284689
0a9268cf-a2c1-40e4-a965-a55a038750cb	test_product	generic	Hidden secret revealed	0.1	2026-04-25 22:16:43.284689
7611f898-3167-4fa7-ad09-0a0fda1b4edd	test_product	generic	This works in 24 hours	0.1	2026-04-25 22:16:43.284689
1cfc96e2-06f9-4991-932a-6eb56796746b	test_product	generic	Hidden secret revealed	0.1	2026-04-25 22:16:43.284689
731fa2bd-41d4-41e5-a70d-54e89b468afb	test_product	generic	This changed everything	0.1	2026-04-25 22:16:43.284689
f7f1d59b-a075-4baf-8d0a-86f01173c9ee	test_product	generic	This changed everything	0.1	2026-04-25 22:16:43.284689
4018941d-97d5-43b6-838f-f394b01e4719	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 22:16:43.284689
8edab3f3-7b9d-487a-9909-52fafd0125d6	test_product	generic	This works in 24 hours	0.1	2026-04-25 22:16:43.284689
5d2eeda8-ce98-40c9-a0d1-8d132d6789f0	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 22:16:43.284689
f873bab0-c581-448a-8bb5-512d6b29a781	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 22:16:43.284689
b3564a6e-c7f9-4fda-b93d-0f2ebabdf2b7	test_product	generic	This changed everything	0.1	2026-04-25 22:16:43.284689
9b71aa09-dc29-4b3b-bd3d-a7941471c3af	test_product	generic	This works in 24 hours	0.1	2026-04-25 22:16:43.284689
e365c35f-c773-4453-aee4-671d7a4c443c	test_product	generic	Nobody talks about this	0.1	2026-04-25 22:16:43.284689
473131e8-f140-438e-8d11-0b31147247f1	test_product	generic	Stop wasting money on ads	0.1	2026-04-25 22:16:43.284689
b1cc1108-20d8-45ec-a6a5-336de7b2ae6e	test_product	generic	Nobody talks about this	0.1	2026-04-26 07:32:33.675364
8666bac2-2e8d-4a85-885a-cee9d942d2e8	test_product	generic	Hidden secret revealed	0.1	2026-04-26 07:32:33.675364
dd5e641c-3390-43b9-b754-95e438354580	test_product	generic	This changed everything	0.1	2026-04-26 07:32:33.675364
2d9bba28-3661-4b28-802f-fcf5ee7d73e8	test_product	generic	Hidden secret revealed	0.1	2026-04-26 07:32:33.675364
57d412b3-ff8f-4079-9378-2e73de36b45f	test_product	generic	This changed everything	0.1	2026-04-26 07:32:33.675364
88e384f5-6826-4835-924c-03e11d1c0847	test_product	generic	This works in 24 hours	0.1	2026-04-26 07:32:33.675364
6a3f219e-734b-447b-bf76-84f886f14e37	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 07:32:33.675364
0cf0a69e-bae3-4f21-b3bf-0a74655eb10d	test_product	generic	This changed everything	0.1	2026-04-26 07:32:33.675364
7fa158a3-1ec2-4485-9224-f871c34fe432	test_product	generic	Nobody talks about this	0.1	2026-04-26 07:32:33.675364
24ba700d-7f9a-41bc-ac69-26f91f76e255	test_product	generic	Hidden secret revealed	0.1	2026-04-26 07:32:33.675364
d6e8d205-c750-45bc-ab60-6a36c6b76a4b	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 07:32:33.675364
6a9477c0-8350-4a86-a478-c1f81b4f3bca	test_product	generic	This works in 24 hours	0.1	2026-04-26 07:32:33.675364
b1fac004-ba86-4b14-bc9b-fcd338d9a2b7	test_product	generic	This changed everything	0.1	2026-04-26 07:32:33.675364
7a48a021-ca5b-4107-8a07-a0130339d4c1	test_product	generic	Nobody talks about this	0.1	2026-04-26 07:32:33.675364
bbf4b676-0daa-4039-a09a-7d7be958621e	test_product	generic	This works in 24 hours	0.1	2026-04-26 07:32:33.675364
acb9d4c8-642e-4980-955d-fc0155fd22ef	test_product	generic	Hidden secret revealed	0.1	2026-04-26 07:32:33.675364
5433fa53-e9d4-4c82-aefc-706db5d0a816	test_product	generic	This works in 24 hours	0.1	2026-04-26 07:32:33.675364
4eb3598c-8773-4fb3-ab21-8e662f098a23	test_product	generic	This works in 24 hours	0.1	2026-04-26 07:32:33.675364
13babed1-a548-41ca-94ed-3eadef9bf1b6	test_product	generic	Hidden secret revealed	0.1	2026-04-26 07:32:33.675364
b122b30b-6810-4497-bfbc-a28ef27a1672	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 07:32:33.675364
e37d8901-39dd-4b2f-8f28-aea870e02874	test_product	generic	This works in 24 hours	0.1	2026-04-26 07:32:33.675364
05750f09-9eb4-4073-be21-533bb444a19c	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 07:32:33.675364
dd7270c1-51df-4a41-9c25-f1e355166358	test_product	generic	Hidden secret revealed	0.1	2026-04-26 07:32:33.675364
f46f06b4-c988-4fb9-b484-fc784cd042d4	test_product	generic	This changed everything	0.1	2026-04-26 07:32:33.675364
6b849ec2-8859-4c8a-95e8-23315fecdfe9	test_product	generic	Nobody talks about this	0.1	2026-04-26 07:32:33.675364
ae8f58ec-a77b-4445-aea9-387ceaeb8e7e	test_product	generic	Nobody talks about this	0.1	2026-04-26 07:32:33.675364
3773804f-9445-41bb-9f92-9d965cc91511	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 07:32:33.675364
4ea4aafb-a4ba-40b0-9a16-252f6cea137a	test_product	generic	This changed everything	0.1	2026-04-26 07:32:33.675364
2146c0da-69f7-4f50-ab9c-aa3d983b1f5a	test_product	generic	Hidden secret revealed	0.1	2026-04-26 07:32:33.675364
ebaf57d9-9b97-4e89-86be-861debe6c432	test_product	generic	This changed everything	0.1	2026-04-26 07:32:33.675364
ce58fb51-b673-4c9e-883a-032f8ca79103	test_product	generic	This works in 24 hours	0.1	2026-04-26 07:32:33.675364
3ddb1aa5-f09d-4195-8162-498f6d2e98cc	test_product	generic	This works in 24 hours	0.1	2026-04-26 07:32:33.675364
5aa94a09-a925-4e56-8ad0-cdc8b709294e	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 07:32:33.675364
aca2e611-3f52-4a08-81aa-2a7ae2c86385	test_product	generic	Hidden secret revealed	0.1	2026-04-26 07:32:33.675364
e8b5268f-cdc6-4126-940d-0d93668b81af	test_product	generic	Nobody talks about this	0.1	2026-04-26 07:32:33.675364
4e8a361c-d61c-4fb2-86cd-ff19d757fb3d	test_product	generic	Hidden secret revealed	0.1	2026-04-26 07:32:33.675364
00934d0c-bd94-4279-9c9f-6d21f7f2da25	test_product	generic	This works in 24 hours	0.1	2026-04-26 07:32:33.675364
626b80e6-f054-4b08-9cee-bf48b8be3497	test_product	generic	This changed everything	0.1	2026-04-26 07:32:33.675364
118284f0-7644-42c6-9223-14216c48f4ad	test_product	generic	This works in 24 hours	0.1	2026-04-26 07:32:33.675364
398060c5-f086-4065-a9af-ca74de602ddd	test_product	generic	This changed everything	0.1	2026-04-26 07:32:33.675364
45ef3c32-187b-409a-b601-ffb067638627	test_product	generic	Hidden secret revealed	0.1	2026-04-26 07:32:33.675364
6112e915-c821-41bc-94af-cbcf38bc253a	test_product	generic	This changed everything	0.1	2026-04-26 07:32:33.675364
226ddcc9-fe72-4f71-9323-0bc12118f833	test_product	generic	Hidden secret revealed	0.1	2026-04-26 07:32:33.675364
b3d7fe6f-8275-4cd1-8d39-1afbf9355ab4	test_product	generic	Nobody talks about this	0.1	2026-04-26 07:32:33.675364
845fffb2-cbc7-404a-b8fa-ac40ad183ae5	test_product	generic	Nobody talks about this	0.1	2026-04-26 07:32:33.675364
eb1f2b94-5256-458c-99db-6199c62a09f4	test_product	generic	This works in 24 hours	0.1	2026-04-26 07:32:33.675364
fbc59002-c3f8-49e1-8895-c9722679d1a5	test_product	generic	This works in 24 hours	0.1	2026-04-26 07:32:33.675364
4f89533e-1bb6-4b55-a93d-320bcd630568	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 07:32:33.675364
4ff1887c-c520-4642-ac1c-ae31b87b4a6b	test_product	generic	This works in 24 hours	0.1	2026-04-26 07:32:33.675364
f7283a02-f824-4417-adce-ab0b90b0d043	test_product	generic	Hidden secret revealed	0.1	2026-04-26 07:32:33.675364
92e7b865-e605-4246-adbe-49a86ecce316	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:36.738139
6ae9aa73-452c-4b5e-9253-19ac7e63b863	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:36.738139
62cbde44-fba3-4650-9219-39f3db1aad5c	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:36.738139
cf47f501-b2c4-45a2-8058-2945df0f3433	test_product	generic	This changed everything	0.1	2026-04-26 10:46:36.738139
10e28a10-148a-49a9-9840-1c96495fe1de	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:36.738139
8499a496-a651-4f57-b0c0-aadb504d728d	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:36.738139
d3ddc424-30f8-422c-81e4-4d43bf6fed51	test_product	generic	This changed everything	0.1	2026-04-26 10:46:36.738139
a08177d5-e9e4-40ff-be2f-16aa62bbf8db	test_product	generic	This changed everything	0.1	2026-04-26 10:46:36.738139
c96e9abe-27ff-4afb-8a39-b2ccdca2786a	test_product	generic	This changed everything	0.1	2026-04-26 10:46:36.738139
838b2e54-3fdb-43e7-b55d-6360e9f4fea5	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:36.738139
f26a3fcc-38bb-40d5-91e5-febaada547be	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:36.738139
1e2b1419-badb-42e3-b7ec-302eda17ca9b	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:36.738139
64cfb5f5-b32a-4cac-a795-ad3795de334b	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:36.738139
5d530823-5e87-41b0-a0ad-030d9bb158ec	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:36.738139
96c71a80-3061-4e4f-b1a8-1212b0fc6fec	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:36.738139
cf272485-52cd-4232-b5d5-7eae94542035	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:36.738139
d153c833-b1ce-4b04-aa95-c9c0b66c8701	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:36.738139
11fdb379-3566-4ac8-991e-655d12635893	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:36.738139
6745ecc8-6735-4b3b-b70b-199a222f301f	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:36.738139
4bf34a45-d500-4e47-86c9-d53866874450	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:36.738139
80c1543a-0cb5-4f23-84cb-07021eae4f77	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:36.738139
d04ac684-117e-43d3-82c9-1d570453fe2a	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:36.738139
c21184cd-d423-40ab-804e-156050ca16d8	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:36.738139
8e2f2d5f-fe0f-4cfa-adc2-c03b774f390a	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:36.738139
f8ce4da1-9f8a-4e1d-9d89-8fc684e4750f	test_product	generic	This changed everything	0.1	2026-04-26 10:46:36.738139
c4016aa4-6c46-4462-8bd1-640ea29e6bca	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:36.738139
ef6c8d95-163d-45db-a31e-a36b655f621e	test_product	generic	This changed everything	0.1	2026-04-26 10:46:36.738139
b56d4e7b-f1aa-4ce9-809a-2cf4bb289ee2	test_product	generic	This changed everything	0.1	2026-04-26 10:46:36.738139
db1f14dc-d98e-4273-b68c-186235eba1c1	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:36.738139
baeb1b60-579f-4cea-8c8f-5f5f51a0240f	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:36.738139
62d4ad78-7337-4df7-a659-12394a50cc68	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:36.738139
04285ac1-540a-4ff9-9fe5-f29ca67782ef	test_product	generic	This changed everything	0.1	2026-04-26 10:46:36.738139
25b3ed8c-4b67-4c51-b3cd-1228ed0f6bb1	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:36.738139
0c1ff21a-42e6-4005-b9e0-a24d57f6226c	test_product	generic	This changed everything	0.1	2026-04-26 10:46:36.738139
a25e5e4a-5f7e-49e2-bb11-73284a493cff	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:36.738139
764b5ae8-e3fd-40c7-b89c-e76866546bef	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:36.738139
cc02ce7b-8370-438e-85ef-d08d1bb18c90	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:36.738139
7ea88ba7-8702-4610-bc73-708b150f0a42	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:36.738139
e6b8fc59-c7c7-474e-a4c6-610ed6c1c421	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:36.738139
70d2d98e-8658-40cf-beff-8b71a9e53c42	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:36.738139
1ec55d3e-4868-41b7-bdc0-561975972c0b	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:36.738139
4ef26d83-b516-47d1-b38a-81bb90b5b7e9	test_product	generic	This changed everything	0.1	2026-04-26 10:46:36.738139
c74ee6fd-f215-4fc6-806a-a0e280a5fb66	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:36.738139
d8dd6cf7-7ca3-487c-9601-23ddb441d501	test_product	generic	This changed everything	0.1	2026-04-26 10:46:36.738139
d2fdc138-3203-4c77-9000-8678341c467f	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:36.738139
8af351a1-7a6f-4879-9e9f-054d75b60def	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:36.738139
fd09f769-5b31-49ad-bc8d-37a31ad101df	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:36.738139
763aef53-c386-4edf-ae35-234db6b1e3ec	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:36.738139
fd676a21-2a69-43cf-84c7-cf29a58670e9	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:36.738139
aaede7af-4e95-4d1a-ad40-d53a2dc5bc52	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:36.738139
bbd2c372-9421-4739-99bb-9f893d6472ce	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:39.409952
9bfbfcc3-5f77-43b4-bcb0-01230e30b139	test_product	generic	This changed everything	0.1	2026-04-26 10:46:39.409952
036bf71d-24e5-4129-9008-7ed2d32ccaae	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:39.409952
c07af563-b48e-4947-83e1-d6ddba362294	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:39.409952
e9649144-c445-44cc-b11e-5b64921baa46	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:39.409952
133cdd6f-8f61-45b7-b9da-f1fc915589a6	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:39.409952
758b2023-d0a7-4420-8059-3324633904fa	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:39.409952
acefb0e9-1051-483e-9c1c-611030ad0386	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:39.409952
b98e59b8-384e-41a2-a6d7-998e408ec8cc	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:39.409952
40b34a2a-97ba-451e-936c-c37b9200f0c7	test_product	generic	This changed everything	0.1	2026-04-26 10:46:39.409952
512a62bb-b817-4577-a6d6-b5ec2abfba9c	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:39.409952
db2edef5-ece7-41cc-9c04-84b9ed4bacb0	test_product	generic	This changed everything	0.1	2026-04-26 10:46:39.409952
a179ad1e-be22-4671-ac6d-d9905c5710ae	test_product	generic	This changed everything	0.1	2026-04-26 10:46:39.409952
38b9def5-eec6-4841-94a7-202293bed409	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:39.409952
c38b2e65-7b47-419a-832a-d3a38f451cec	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:39.409952
b8b276ea-7f49-4f05-9254-74477e677861	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:39.409952
00e39bf3-3728-46b1-b5b2-52be3ff62850	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:39.409952
537bfcdd-252f-4c86-b09d-86c320fe068d	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:39.409952
cfcb432f-f96a-4634-a4de-8224bb7d5a0b	test_product	generic	This changed everything	0.1	2026-04-26 10:46:39.409952
ebadd834-df19-43c4-8883-306f424fc974	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:39.409952
a92302b9-8a45-4010-95da-97dd53629f26	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:39.409952
627ae6c8-996f-4640-ae0b-780b68c0d238	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:39.409952
6ad70fd3-165d-44d0-8d2a-d8b0e9a0b05d	test_product	generic	This changed everything	0.1	2026-04-26 10:46:39.409952
4e7741e2-884e-4c4f-9622-7d4f04c0cb3f	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:39.409952
f5630fdc-9256-4239-8fe8-b2e9024a2dd5	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:39.409952
8e659d8d-49fc-4b8d-b0ac-756d80c6e147	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:39.409952
2e709ca8-57aa-4783-b9d0-245af63f12c1	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:39.409952
b1d88434-9d34-49b4-ada4-a6b45e8157b8	test_product	generic	This changed everything	0.1	2026-04-26 10:46:39.409952
353950bc-36d3-4084-a5d6-89249e675426	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:39.409952
2bbc7570-98a4-4afd-8c82-4f8743bb2246	test_product	generic	This changed everything	0.1	2026-04-26 10:46:39.409952
46d035c3-7c70-44bd-80b3-8864b93f08dc	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:39.409952
23009450-4624-43bf-90f3-80f0bbf99cc2	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:39.409952
7560dac1-0722-4913-9b27-b7e08c227807	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:39.409952
9d6d3fff-224e-43fb-86cc-9e23d78fd3d3	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:39.409952
f117d37e-d0b9-4ba7-a173-f0090a37c7d9	test_product	generic	This changed everything	0.1	2026-04-26 10:46:39.409952
40b30704-8d01-43d4-897b-db8dac277433	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:39.409952
8ffce37f-6a0a-4e38-83da-181e78bc0980	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:39.409952
c7c2950a-8435-47da-8078-b80238bdc70e	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:39.409952
e50714f9-fbd4-454c-b096-014a4fe68460	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:39.409952
ec9e1dc3-8b13-4410-89b3-6b273e929334	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:39.409952
7f9e8a08-7346-46aa-af9f-d1da18479f2d	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:39.409952
6b6f5fde-e768-4511-bd17-5b93d2a26460	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:39.409952
8f4cfd77-bf02-4442-b381-f21e67b15131	test_product	generic	This changed everything	0.1	2026-04-26 10:46:39.409952
a769556a-e970-4df4-86cf-869c5af86005	test_product	generic	This changed everything	0.1	2026-04-26 10:46:39.409952
a7d8c8d7-5221-4e6a-b801-426de22d6bcd	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:39.409952
6ba78f27-9368-4ad3-a1c0-e608cf4db346	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:39.409952
8a980fba-7f05-4de0-8f27-c8a315ad4f3a	test_product	generic	This changed everything	0.1	2026-04-26 10:46:39.409952
c1865727-8a4f-41b4-acb1-a4510510a914	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:39.409952
31e7f56a-523d-42da-9313-ebf39d6b7def	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:39.409952
5a18820e-53f9-47b7-9207-2133534e5c3e	test_product	generic	This changed everything	0.1	2026-04-26 10:46:39.409952
69c2687a-641a-45fa-9f34-454b374af0c7	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:41.618925
b1fcbb18-62e7-4578-bf21-5e61caeac15d	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:41.618925
3572a6cd-626a-4b12-b388-903165457be0	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:41.618925
4b459d45-0abb-4466-8e10-b0ac247f54e4	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:41.618925
82ab6160-4500-4aa2-aaac-705e84c1716b	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:41.618925
fbe8d2de-7a30-4147-ba7a-9180a8ca208d	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:41.618925
42b4e335-0fae-40cb-bbaf-a3c18c2c9ef8	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:41.618925
f982a56d-01bd-4986-9101-56f0466e4333	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:41.618925
43774f14-51ef-4cb7-97a6-45df3f78ef4a	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:41.618925
d4585f7e-87f6-42a2-a5a5-79fa4a7a1365	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:41.618925
d5349dc8-623f-4b4c-9abd-9cb27e35e81a	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:41.618925
2c543556-c136-4c93-be10-48d210113d27	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:41.618925
e9fce677-91ae-4444-9fe8-a5c42e4521f0	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:41.618925
6d6e91df-ad3f-4872-b4e8-ef3f4c58799c	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:41.618925
85fb36d9-d84c-44c0-aeec-bc0b9869ac68	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:41.618925
aac962e0-e2b2-4f4f-9dfb-cce61939ebed	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:41.618925
bb0a1aac-ae19-4cf6-b870-9429f6164817	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:41.618925
74bf5799-32e8-4714-857a-04c669ac320d	test_product	generic	This changed everything	0.1	2026-04-26 10:46:41.618925
5ca50fa7-6ab8-4bc1-baf3-236c83529b3f	test_product	generic	This changed everything	0.1	2026-04-26 10:46:41.618925
21f1e2bd-5477-46fb-bb31-97712615c216	test_product	generic	This changed everything	0.1	2026-04-26 10:46:41.618925
7c9c5096-f246-4713-8dac-d816ffe745da	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:41.618925
720e7f49-1a6b-40fc-be6c-c9d050fa9840	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:41.618925
b8fd1004-b673-4a38-bf93-ef265dc46245	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:41.618925
73fd9d6b-aad3-46cd-9db4-0fc6637c071c	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:41.618925
6b5428c9-1d96-498e-9620-d439e5924cb8	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:41.618925
9e6edd74-2ced-4818-86be-4b94ecbe378e	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:41.618925
6fcf1b6e-7cf2-4e99-9930-1fe175c15e39	test_product	generic	This changed everything	0.1	2026-04-26 10:46:41.618925
f77439a5-9655-49da-a9ec-a59b276198b9	test_product	generic	This changed everything	0.1	2026-04-26 10:46:41.618925
9c39a252-a404-4698-8f1d-f426341751ff	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:41.618925
80f5d10e-840b-4be2-8fbe-cced32d47722	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:41.618925
73472ed6-f5e6-4a1b-a6d9-e8620b29938c	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:41.618925
a20a0046-e546-48c8-a7db-d20b9f3efe72	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:41.618925
ae39db21-f0b0-4dd9-9a0b-18a544a33211	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:41.618925
a1ce6843-591c-434a-bc37-6bedaf28e860	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:41.618925
030888dc-5d1c-44ff-b1e7-26cf59f0c0cd	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:41.618925
df7a4f4f-8e96-41b0-b4cf-b19f72fd862e	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:41.618925
28f11b7a-f73e-497d-8a64-d6fff009471e	test_product	generic	This changed everything	0.1	2026-04-26 10:46:41.618925
70cb86ac-d387-4a0d-afa7-c3f0f1f18842	test_product	generic	This changed everything	0.1	2026-04-26 10:46:41.618925
9538d4cd-0715-4b25-b7a4-bea9247f24bd	test_product	generic	This changed everything	0.1	2026-04-26 10:46:41.618925
ccf870d2-5491-41a2-8ff3-1307b1767cde	test_product	generic	This changed everything	0.1	2026-04-26 10:46:41.618925
63db8fff-1809-4044-add2-60e23de8b05a	test_product	generic	This changed everything	0.1	2026-04-26 10:46:41.618925
0e18da0a-1dc6-499d-8aa4-be255ed63211	test_product	generic	This changed everything	0.1	2026-04-26 10:46:41.618925
5a9463c8-4f6d-4cba-9d92-80496b671b66	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:41.618925
bcb1e4da-4491-420d-b240-8cff65fd888c	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:41.618925
438c2d85-814d-4eff-90c5-a3c2d7f684bd	test_product	generic	This changed everything	0.1	2026-04-26 10:46:41.618925
d9c16b98-0e92-4aed-acb9-e8298df9d794	test_product	generic	This changed everything	0.1	2026-04-26 10:46:41.618925
2bbe071c-34ca-4cb1-b65b-e1b5de808023	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:41.618925
c2d0dbde-6c99-4f27-97fd-fbd220569aaf	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:41.618925
d2eec05a-9f37-4c32-9423-2bcab3c90666	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:41.618925
1d5ee6d3-1505-4f45-9817-88cd9efde663	test_product	generic	This changed everything	0.1	2026-04-26 10:46:41.618925
f9b780f5-e515-4326-8279-08ffb5c371a5	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:43.989825
79b6f633-2100-4d29-af5a-f8dce065f75c	test_product	generic	This changed everything	0.1	2026-04-26 10:46:43.989825
1618aaf5-37cc-46f6-b036-b2edc70a4ed6	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:43.989825
bccb8fe7-0c3b-42cc-b93f-a349f56d2a66	test_product	generic	This changed everything	0.1	2026-04-26 10:46:43.989825
e6df6fab-7d98-4120-8d3a-53230cb4a0b7	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:43.989825
5d47c7e6-11c2-42f7-8805-ce345258866f	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
7a3ea4b7-b4d2-4ecf-965b-19a6315fa6f9	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
c99092e3-c865-488e-b9b0-603680663469	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:43.989825
41fcc768-819e-4743-addb-b6b97732dc24	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
f19fada3-e503-4870-be84-dbdababef167	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:43.989825
1839ef6b-96af-44de-98c8-dda71ec8dea8	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
2e37330f-ac4e-40d9-8ef4-d37a55a4f964	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:43.989825
622b3d55-8138-4d56-81b6-0e8b379696dd	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
442c9e41-a506-4295-9a3c-57399f641e42	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
cd2c79bc-ce74-4cea-9e54-988e52ac2dc4	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:43.989825
24e675c9-3133-4a1e-a0dc-16d753c288e8	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
3661dccd-e325-4a10-9906-c138e3ea2362	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
c04518f4-5d35-4460-bba9-8a25267952c2	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:43.989825
dd8b6363-8de8-412b-ac04-b5c7bf0bdcc1	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:43.989825
7a3276c1-1221-4d9f-973f-f4707b8452b7	test_product	generic	This changed everything	0.1	2026-04-26 10:46:43.989825
32d74c99-1a08-4356-b2a0-3cf62bdc49ee	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:43.989825
8ffad065-7548-4837-a347-cd95adb94a86	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:43.989825
b69c812a-a9de-4413-993c-cf7ec947f9c7	test_product	generic	This changed everything	0.1	2026-04-26 10:46:43.989825
10db8414-7d5d-411e-b47a-5e47931ce771	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:43.989825
33802c91-02b9-492f-ad4e-2b5d764ad3e0	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
9baf7dfe-b895-44e2-b280-1bcdfbfbbc65	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:43.989825
29834e56-41df-436c-a038-3c1df7c72155	test_product	generic	This changed everything	0.1	2026-04-26 10:46:43.989825
61c4707b-05a2-4c81-b3e1-6aab34340494	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:43.989825
19bcd184-7b3f-47d5-a8d0-332f3b122ac4	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
155d5382-6f90-497a-bd9b-ebf73be1dbb9	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:43.989825
431eca07-e0a1-4a6b-8f0d-cf558fa64dd4	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
60a71fa3-b95c-4dda-86f5-48033314dd7e	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
42825cc7-5e89-4f28-b826-fa572b48563e	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:43.989825
4d926dfe-9356-41af-8622-1fd658c9fb74	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:43.989825
eea2df43-f846-4a34-95fa-9e1e16810b33	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
7ebbd6f3-be1a-4032-8f16-495b62099c51	test_product	generic	This changed everything	0.1	2026-04-26 10:46:43.989825
5f630985-6ed2-4b1a-8611-fb3a9abd90f6	test_product	generic	This changed everything	0.1	2026-04-26 10:46:43.989825
07145081-212c-432f-b921-8426619f5573	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:43.989825
84868142-4c3e-474f-87d8-eb28792e9183	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:43.989825
ea04e04d-80c3-4282-ab29-aa732d84725d	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:43.989825
9eee1572-289f-437f-afc7-9d980608e568	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:43.989825
430d228f-c193-4b8d-a87f-9da57a729c9b	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:43.989825
746306e6-9c56-431d-bcfc-6e127a0e3d0c	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:43.989825
e5463351-6dea-428f-a727-e0d7ac7b4860	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:43.989825
9e5bf777-4091-4325-9503-2da72a037eb5	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:43.989825
73ae82a0-cfaa-4647-bfab-1c79063c7a48	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
0c974c51-f167-4d37-a553-0850cef9e84b	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:43.989825
e6e0aa54-e8c2-4fce-a672-d552456854b7	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:43.989825
87f53772-95b8-4ba2-b091-0d0fc32f5d93	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:43.989825
66cfc56b-4978-424a-9b2c-51915931903b	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:43.989825
8e270a97-60ce-4aec-9fc9-05bc5e95ea85	test_product	generic	This changed everything	0.1	2026-04-26 10:46:46.554253
367226ba-9574-45d3-9fe5-2d5c80b38aef	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
e6007d15-698a-421c-bc0b-0a349bb481cc	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:46.554253
e7ce5ebe-7d39-4679-a719-5bbca799847c	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:46.554253
218f50af-bff1-426b-8aa9-543ad24e1c28	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
27cc122c-93d1-419b-ad43-f160faa322a4	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
f4354f15-3704-4175-b4f7-a87666577076	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:46.554253
977b77e2-6b81-48fe-b27d-44b6b9f9bc99	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
1f453910-540d-4c91-867c-2617fc163969	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:46.554253
677b84c3-732d-4578-abb2-04f8132f41f9	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:46.554253
feaf974c-ce21-4fbf-9aa5-3d9e277296af	test_product	generic	This changed everything	0.1	2026-04-26 10:46:46.554253
13428dfd-923f-45fe-ae37-a2c4e3733ecb	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
ab357138-9098-4a5f-914b-53e2eea89951	test_product	generic	This changed everything	0.1	2026-04-26 10:46:46.554253
8b61423a-37b5-4091-94bd-459eb0dd35fa	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:46.554253
d0e65b0b-6f89-48ba-8cc4-7d74f12ad793	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:46.554253
fb223a66-ca62-45c6-b6b0-6f9328003563	test_product	generic	This changed everything	0.1	2026-04-26 10:46:46.554253
75a9bb32-46bd-42dc-ae17-737f3376f365	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
ae8b4088-c213-47be-9553-b1b73f13398c	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
bdbd1f04-970a-46e4-9806-e9f9b62a5eea	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:46.554253
4fd85ba4-f26b-4747-ab61-1a93942e8864	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:46.554253
9893100a-6cdf-428b-83da-6b4bb88c1e1d	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
54114c56-a0d4-4015-b5f8-b8972269a8b8	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:46.554253
a0d9e4e0-583a-479c-b04e-298d47de354c	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:46.554253
a0779a7d-4c6a-4c58-bd4a-90e1550348cf	test_product	generic	This changed everything	0.1	2026-04-26 10:46:46.554253
062aac40-efa7-498c-8159-968862b9427f	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:46.554253
7fe5330e-7eec-49b9-b32b-68dbaa8021c7	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
135931f8-3867-4d73-84a6-8e9dba7e81d5	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:46.554253
4a69a960-be3a-45e9-9aef-a721e68a1969	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:46.554253
a5fa2f5a-61a4-497b-a507-b1ed7a5b9c0f	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:46.554253
3a989eab-8efe-4c9a-b200-f5ad81ee8153	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:46.554253
60e6d5cd-50f6-4285-a160-eca0f00bed94	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:46.554253
e43996f2-4957-4e1d-840a-437699b8f98d	test_product	generic	This changed everything	0.1	2026-04-26 10:46:46.554253
1093177d-bb02-45d9-acde-a61230f90224	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:46.554253
6ecc023b-4beb-49e6-92b4-a3129447a0f0	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:46.554253
02bccf75-d9fd-4def-8464-1515cb2ca741	test_product	generic	This changed everything	0.1	2026-04-26 10:46:46.554253
36573309-ff8b-44f2-bc54-38ec7680348b	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
5fa2a1e1-8527-45fb-aa26-7a3fa129ddb2	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
53de45fc-aa08-4b89-84f0-29ed0899a6c4	test_product	generic	This changed everything	0.1	2026-04-26 10:46:46.554253
3c01c36f-99e4-46b6-b1db-d5a0bb12534c	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:46.554253
8ade67bf-a9e7-4acd-88ff-60f1e529645b	test_product	generic	This works in 24 hours	0.1	2026-04-26 10:46:46.554253
a122cacc-e9cb-431b-999e-e25d7b603d94	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:46.554253
30a953fe-b6d9-400f-aab5-5c2e47b45971	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
98d63cec-4f12-4d47-969f-67ec614a8b84	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
4e5d392c-78b2-451b-a146-b76c37f110f7	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:46.554253
fe0888d4-fd01-4dbb-ad83-b6d62cbed54e	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
9c3bac74-23e0-452a-bae4-555b380f1a20	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:46.554253
e88d6719-8e4a-4642-9a1f-12815c2b3136	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 10:46:46.554253
cf4aa3b3-03cc-4b58-a5ed-0e79d987e804	test_product	generic	This changed everything	0.1	2026-04-26 10:46:46.554253
bc035d5a-c7ef-47ee-a002-fa15167ece8c	test_product	generic	Hidden secret revealed	0.1	2026-04-26 10:46:46.554253
a0b12c22-5ef6-4630-bd67-971445847fad	test_product	generic	Nobody talks about this	0.1	2026-04-26 10:46:46.554253
8b84c571-166e-469f-bf6e-436fc9760f12	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:18.876931
5ffd85b3-53bd-4e7e-9968-1ed43927bbbc	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
0632b15c-973f-485e-ae70-5a3afbc909f1	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:18.876931
063616de-9062-44c9-9530-649e49fab758	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:18.876931
66a3f5bc-f575-4a9e-85f1-516467f8ac7b	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:18.876931
aab60291-70cf-4169-bc7f-5bc4481bc2e1	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:18.876931
cb56b48e-1bc7-4659-80f2-fdefde52ca09	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:18.876931
23dc5d34-73b7-499c-aab3-24d25d0ee8b1	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:18.876931
fba95a73-4a9a-428c-88ee-272dd55124fd	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:18.876931
a6e22a23-df98-4aad-b9a2-2284806cb4fe	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
375210e9-1d75-4a63-bbc9-f2d5323274b1	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:18.876931
39c58d0c-c1e3-445a-8cca-206430c53bd3	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
68bc3fb3-dd5a-4508-a9f9-8094573329f7	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
c7b218c9-f621-4bea-9215-73c488c56c95	test_product	generic	This changed everything	0.1	2026-04-26 11:04:18.876931
3b4eff89-75c6-4a7f-9cab-13a521911afc	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:18.876931
48555f31-9b2c-4ce3-b1b1-68180ac0896a	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:18.876931
139af135-aed5-4360-9b20-46ec84e44d88	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:18.876931
9895f1bd-ada8-44f3-ae95-e6b8caf6a0b8	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
bf9145dc-db01-4a7f-b8ed-f71f09180fb0	test_product	generic	This changed everything	0.1	2026-04-26 11:04:18.876931
1f1f1e2d-abf5-4163-8234-64d5ddb81b6e	test_product	generic	This changed everything	0.1	2026-04-26 11:04:18.876931
e82445e0-18d6-45a4-bb76-75c45090d1f8	test_product	generic	This changed everything	0.1	2026-04-26 11:04:18.876931
9e5010b1-0d38-4b8f-b623-bc64430acf4b	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:18.876931
55bbc0e7-89d9-453d-898a-9309dc7d503e	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:18.876931
fde8cfa3-0c5f-4df6-a8b5-cff4977b4bdf	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
68bc8d07-cbe8-4aa2-a336-8e47ca887f0b	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
9d81d7d7-d441-4a32-a6f0-7ddfdf0d2dc6	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
127bb11c-6c4b-4e5d-8680-32ef32d7acb9	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:18.876931
46a500ac-2adc-4512-a1f7-28675be93d59	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:18.876931
4b3be947-6d9d-49b2-8084-94ecb97a7b8f	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:18.876931
b192e400-28af-4956-841c-f1750e7a6961	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:18.876931
51952f1b-e9a2-48bd-9182-c6b9845adebf	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
db0ba2d9-2124-48b5-9a6b-a3e08761eb01	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:18.876931
79864d35-d295-40c1-aac0-e745cb1a3c35	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
76088f0c-16f3-44cf-b27d-3859c9f7a0d9	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:18.876931
cc27f93d-3f0a-420f-bd0b-70c28a8ee220	test_product	generic	This changed everything	0.1	2026-04-26 11:04:18.876931
66b40362-1d90-4996-9f28-10fa6096207f	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:18.876931
0ed82957-9ada-488f-a25f-087c85dd7f3b	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:18.876931
b40da7e6-35eb-47bb-b7a6-e8440dca02d6	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
aaa49990-ed7d-486b-9ede-c156192dd82f	test_product	generic	This changed everything	0.1	2026-04-26 11:04:18.876931
004f39d3-b6da-4a53-a77a-5471b27adc29	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:18.876931
9cd7ff20-abaa-476b-9a89-4abc4ca7c6d2	test_product	generic	This changed everything	0.1	2026-04-26 11:04:18.876931
4ee58524-2c65-4f39-8b6a-599583a4d42c	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:18.876931
bd3aef87-1bc6-418d-921d-e67bfbac8c94	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:18.876931
46c11f12-e46a-40fd-97cc-a856c8edce74	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
1371c32b-68c5-4e19-8d6d-83cd5247bf5f	test_product	generic	This changed everything	0.1	2026-04-26 11:04:18.876931
38669d8d-275c-4540-9226-c54683b4670d	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:18.876931
b837d56d-dcc2-472d-b59a-169708e2310e	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:18.876931
d7d86e94-a07f-441c-aeba-f1dd56a687aa	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
131ba571-7204-468d-bcdf-759f7516e3bd	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
251c243e-85cd-4d10-9dc9-cc8a5c4ee59a	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:18.876931
7138062f-d973-420b-8a37-69cf4dae497b	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:20.300058
6420093a-dd4e-41c3-9867-fe9c18bad861	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:20.300058
96cd9f58-2fd3-418c-b2e4-4e709e0b998c	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:20.300058
738277ee-5d19-4fd2-a586-af21c44b6df5	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:20.300058
28154792-c153-465d-b6f1-588bd4c35c34	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
1f82b411-19c3-48bd-abec-1246b74033dc	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:20.300058
2013cbc3-6ec9-4c64-9ba1-2877404eee90	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:20.300058
39df389b-f9b5-45d5-a953-58ceeaa6b5ff	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:20.300058
bf4f8ba6-14c8-45bf-b75e-1a578426c17d	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
d61d2687-361d-4f8b-846e-32a91ac3c518	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
267329d0-88fa-4514-a708-1284ad7d678f	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:20.300058
298669cb-ea10-459e-b08c-a9c3a81b4968	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
5dbb065a-4e7f-40ec-a02c-a638f6b02b90	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
9192e73d-e691-4486-89e9-ff47a46fc604	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:20.300058
7ccff621-4a82-47d5-891f-72c803b8ec26	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:20.300058
2a9be5d6-4378-4dc7-9a88-3a6b6d1e15a4	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
fc0aef48-3582-4191-ad3d-2b44dcfeba66	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:20.300058
33289f48-29ae-45b9-b0f7-20d414c13961	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:20.300058
58055ddf-57b3-46a3-b0ee-01d42a7f3729	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
c919cabc-1c57-4708-b385-d955b6d27e0d	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
a07dd3d8-c94e-4c12-ae27-d06410c5ad80	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:20.300058
8690aa15-41c7-4d2a-9878-3a69ff5649b1	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:20.300058
ee089661-1111-4055-8e54-02a3bcc7d417	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:20.300058
64679dc0-26c4-49cf-9972-4adc07161093	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
cbf99691-8360-4ee1-b030-41c3f5f86420	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:20.300058
5c497636-9683-4c2e-817e-19cb813e8e72	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:20.300058
f4b62793-07b9-4041-9c67-be3356290c24	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
97faa705-a167-4780-a1f5-f3f237c58585	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:20.300058
bb7e9aa3-5bf2-4c87-b245-d13e41c6459c	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
1e86616c-e2fd-4d68-8d25-61685e7284ed	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:20.300058
420e32b5-b5a2-445a-9dcf-e76e922cfcec	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:20.300058
cb5f1820-fc23-448b-a8ba-49f89110b5c4	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:20.300058
6d1f98aa-0ab7-4230-b748-ebb9bdef9172	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:20.300058
8e234ff2-5931-46c0-8014-d2607f2e3b8b	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:20.300058
2ca35d78-05ed-46eb-b4cf-a95df8edab65	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:20.300058
52b3bbe1-be5b-4eee-977a-eab16597fac7	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
f06714db-478f-42aa-b57a-67d871a50cc3	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:20.300058
aeb428cc-ba8c-4500-b384-90c5c436dc69	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:20.300058
bf640bd0-e9d9-4f7d-96e0-c0c98a811fd2	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
cfa20081-e93c-4d21-a9d1-765768bebd11	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:20.300058
6e37c0e0-dadb-42f1-bbb8-8ab2e2f37112	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:20.300058
4250a734-5b06-438d-a368-70df9cd19bb1	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:20.300058
d2c48dcd-55a7-401e-97c0-89d739b820c2	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:20.300058
ac8a1886-d9a5-4be9-a961-5d2f6955ffaa	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
20802a4e-5c54-434b-a666-b1af48180fde	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
5fb5289e-a8a1-4406-af3d-5fef8e501f17	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:20.300058
e2ca3f96-d858-4bff-aee8-56d25f41d0e6	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:20.300058
f56f0133-2466-4882-9e26-93ce545d00d3	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
956ba1d4-8b2c-4516-aee9-04c3285b35d1	test_product	generic	This changed everything	0.1	2026-04-26 11:04:20.300058
dfc9c8a8-2d00-4734-af58-b960c398fb4c	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:20.300058
853cbcce-8eb9-463c-874d-d145c91adef2	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:21.654944
286a53b4-ba56-490f-add3-c903358f7a27	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:21.654944
13f9ea92-b8a1-44c5-b7c5-f78ed092d431	test_product	generic	This changed everything	0.1	2026-04-26 11:04:21.654944
0253bd21-213b-420c-a5bd-686335e9af3a	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:21.654944
eb8f3d9e-6ff6-4785-854a-a69a07a03df9	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:21.654944
9d62ddb3-8302-4ecb-8e8f-12c131af5107	test_product	generic	This changed everything	0.1	2026-04-26 11:04:21.654944
6711447d-8404-40ba-8a78-899a7822f741	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:21.654944
66759545-dc3a-4021-8701-29a2996aec4d	test_product	generic	This changed everything	0.1	2026-04-26 11:04:21.654944
d5e0d1c3-0da6-40bd-80ca-cec59c1b9f22	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:21.654944
e2c460ee-d8de-42d6-81f9-90110b4cc9c4	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:21.654944
97ad0777-ef5e-47f7-8d7f-bb2a0b2bc81d	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:21.654944
2a01dce2-4550-4740-b523-dfee4f5148cc	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:21.654944
abb32136-5196-4f6d-aadc-e8d015042f14	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:21.654944
b1f1af28-31f7-4b52-a2a0-24227ce67b5a	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:21.654944
5b93bf8e-fa79-4769-a94e-de48e9c715ec	test_product	generic	This changed everything	0.1	2026-04-26 11:04:21.654944
6105068e-dc97-49de-bb20-2fb4e75d525e	test_product	generic	This changed everything	0.1	2026-04-26 11:04:21.654944
9c9cf450-3c1d-4bdd-81db-d4609fdef3c6	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:21.654944
c480a3aa-f9ac-4d9a-ae32-c288ddda34ac	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:21.654944
71ab38b8-3fbf-4f23-8256-977b4e23816f	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:21.654944
cbd66b9a-4570-4115-813a-cd74f2506c34	test_product	generic	This changed everything	0.1	2026-04-26 11:04:21.654944
0f8ad971-6071-486b-a851-3c63f9eae7ed	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:21.654944
6f01e802-616e-4d47-a261-a5a368e51366	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:21.654944
208c106b-e492-4663-bf33-659ccac1c80c	test_product	generic	This changed everything	0.1	2026-04-26 11:04:21.654944
39464aeb-29ab-4a2f-9d95-2e97599059f9	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:21.654944
d56538bf-589e-429b-b5a8-a5ca9722682f	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:21.654944
8c08c63e-1998-43f1-a4e5-4d89590cc796	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:21.654944
fc7c76a3-ea06-4208-98ce-2858f365e1d8	test_product	generic	This changed everything	0.1	2026-04-26 11:04:21.654944
ef7db574-5782-47d8-bc0c-6a4d81a7f115	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:21.654944
d9cd219c-78b0-44cd-833c-7bd2bd268a95	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:21.654944
e570c574-6a88-4b4a-9743-541c8c11aa89	test_product	generic	This changed everything	0.1	2026-04-26 11:04:21.654944
da4affd9-791b-4bc8-b63a-e0cad4fdde8b	test_product	generic	This changed everything	0.1	2026-04-26 11:04:21.654944
8780d226-592c-47f5-8244-3eac2d142bc8	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:21.654944
d845fd13-20ff-4e9e-a7d7-79be161823c2	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:21.654944
04f5789c-22c8-4ba7-a2fa-20c68659d9b8	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:21.654944
e6adc0de-b966-4662-9d92-80d3fc2acff8	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:21.654944
341ce5f6-d126-4f21-959d-81ffbac2e3fa	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:21.654944
4b090f32-0601-4417-bf4b-25e335776887	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:21.654944
59e3a219-9651-4a5c-bd98-e559f9f7b052	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:21.654944
87b14b85-b74c-45ad-a1eb-df247d615ff0	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:21.654944
72367cdb-241f-4e74-a37e-85b6c43bb630	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:21.654944
1d2db858-ecda-4c61-ae44-73feac735f43	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:21.654944
151e21d7-ea2c-4953-a226-7931c1ab3b33	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:21.654944
16f15819-008a-4020-9557-c010208c33a1	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:21.654944
bbc448a9-bcf6-4943-a508-b3116bb677cc	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:21.654944
c7606e4e-3919-40db-b20b-a8610f0f3b4a	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:21.654944
8b573f3e-784c-4497-a053-42e3e657ece3	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:21.654944
44bafb48-126f-486d-b87f-710d7396b292	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:21.654944
b86b8724-ecbe-4e4a-9ecd-56b5498a2ee5	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:21.654944
a344e922-52ed-493d-ab9e-ad769a3abb8f	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:21.654944
5f40d207-c05d-438d-962c-353ea2981dd6	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:21.654944
ca013939-6275-45ad-82b4-14df7e22d8e1	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:22.995806
27e77bc3-1793-490e-a5ac-d17709a9d4c8	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:22.995806
ad2bc73a-6fb7-4ff0-b446-bfda3504c620	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:22.995806
e85c4a4b-3958-4aab-afeb-ac0d2cba2bd9	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:22.995806
1e9ef74a-6e66-4d58-a289-d7e13770aae3	test_product	generic	This changed everything	0.1	2026-04-26 11:04:22.995806
f12e66be-7c40-4bee-85a0-d4fa0a8f1210	test_product	generic	This changed everything	0.1	2026-04-26 11:04:22.995806
a2e3d6ba-5a46-42ca-bfee-3f48cf72a99c	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:22.995806
4f7777c9-7da9-4025-9db8-d0ae7e256b73	test_product	generic	This changed everything	0.1	2026-04-26 11:04:22.995806
6b92af56-0d35-40ab-a804-e8cc1aeed46c	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:22.995806
960a6335-f88d-46ad-9f98-6de6acd356cb	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:22.995806
55278929-34e8-4403-9aa5-23727de03350	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:22.995806
2515d39b-5a1c-4dd3-94b1-ce5d565577b5	test_product	generic	This changed everything	0.1	2026-04-26 11:04:22.995806
8ff64ded-d7f0-4ed9-8be8-dd4d74ada1d5	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:22.995806
6e079771-2fad-4aa9-8a19-89249c686782	test_product	generic	This changed everything	0.1	2026-04-26 11:04:22.995806
71e52a8e-f1db-4d69-95d1-fb1fc787c48d	test_product	generic	This changed everything	0.1	2026-04-26 11:04:22.995806
0d04d220-70ae-4e04-9ee3-10ae3b0c7014	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:22.995806
05053908-8917-456d-8efa-c6221cd9409d	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:22.995806
9f2c8e83-892d-48d4-bd8f-3e3e65c5b968	test_product	generic	This changed everything	0.1	2026-04-26 11:04:22.995806
7af4b204-7a41-4201-b845-0d4af5f664a9	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:22.995806
eba94c55-747d-4485-bf38-63eda2338835	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:22.995806
43318a2b-f378-4f7b-b2bd-d3480ffc231c	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:22.995806
7f17885c-21c0-4a1b-9a4d-b154ea04f2de	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:22.995806
859f143a-4231-4fa8-bdee-3ab0336c73e2	test_product	generic	This changed everything	0.1	2026-04-26 11:04:22.995806
61f077bb-7692-4a28-8a3f-a77604417cfc	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:22.995806
e5e3ba43-bc75-477b-b8c1-fe05720fc032	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:22.995806
2f89d8d9-cafc-4f74-8634-7b4cf69416aa	test_product	generic	This changed everything	0.1	2026-04-26 11:04:22.995806
ff5103ce-c47a-4d85-9f3f-48d7c9d61078	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:22.995806
4db0e0a4-d828-41e0-89af-c80b7dd12db5	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:22.995806
eb444c76-0b83-4f87-8a1c-9b9df87befdc	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:22.995806
6898d5df-c586-403f-8bc6-9fcde3c7a223	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:22.995806
5576d313-9dae-4780-b155-3399258a61be	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:22.995806
0240356e-53bb-44a8-b933-f16d569c8942	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:22.995806
9d42b9ff-dccd-4b75-99dd-e88df35463eb	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:22.995806
ecea2319-192f-4583-a7ca-1c4916fab133	test_product	generic	This changed everything	0.1	2026-04-26 11:04:22.995806
60da6d2e-09e8-429b-92d2-86a13913d485	test_product	generic	This changed everything	0.1	2026-04-26 11:04:22.995806
645a6d63-0669-470d-9d68-d8b2bcbbca11	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:22.995806
d6c651df-fb1a-4fc7-b3a9-babb80bc320f	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:22.995806
0223aa3a-68bf-4a26-8b1e-a5ed82fc6bb0	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:22.995806
0a4b3e87-ffae-4c46-90f9-06b9a98de4a8	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:22.995806
354657c1-7e5e-48f1-afbf-00af82c62ed3	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:22.995806
5fe03f80-aa13-40ce-8825-23e521d2093c	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:22.995806
d0d80292-dd18-4c0a-b17c-15c3fff04522	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:22.995806
2d76447f-65f2-42bd-acb3-9f44e732bbd0	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:22.995806
9c819a32-14a1-4273-8bc5-b41e65a41bc8	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:22.995806
7878ff1e-c3f6-4cda-a194-4c2856ed7a07	test_product	generic	This changed everything	0.1	2026-04-26 11:04:22.995806
8754bbaf-1f5a-41ba-b317-326717789222	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:22.995806
7f412929-d865-4863-9d2b-bb56e7d8e016	test_product	generic	This changed everything	0.1	2026-04-26 11:04:22.995806
7b4e345b-a8a2-43a5-906e-216571b25b48	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:22.995806
c6bc15cd-5495-4a47-bfb0-34607766e08b	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:22.995806
0e0e54e7-2d3f-405c-9f08-04d15e882236	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:22.995806
704fcb18-bec0-4ef8-b116-8d5105ff0926	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
44c54deb-0bf4-42d3-9382-0e414bd53a7f	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:24.331911
13a25535-4809-4957-a871-a8b3d87674ec	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
f47e4bba-7906-4598-97e1-6378077c1778	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
0f227649-b0ee-4ffb-9e33-c506c5299319	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
889cccc8-8b8f-4446-92ba-b7a150bda7be	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:24.331911
75f4bcf2-6caf-46ed-9088-d8dc7ed14432	test_product	generic	This changed everything	0.1	2026-04-26 11:04:24.331911
6377991f-4e05-4406-b543-d58803e79971	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:24.331911
81a9ece6-5c1e-4a09-8453-724bc0a013c0	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:24.331911
52360625-fde9-45dc-a7a4-d66dd9227263	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:24.331911
82a9fc68-72ab-4776-9b9f-0cde7b2e5624	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
4071b276-15e8-44a7-be59-6fdd7033a141	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:24.331911
055a0693-b909-4b71-9aac-f584a6277f1d	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:24.331911
cd5efdcd-2789-4c2f-a292-c84f931e80ab	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
132c6ff3-932f-41f4-8f5b-e4dcc20c33b3	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:24.331911
e6ba1579-7d5e-4118-89b2-66c790de809e	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:24.331911
3e854387-32b0-4788-9413-4bdd002f34c0	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
0cda824b-a7dc-4516-aec1-e53e359009a4	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:24.331911
a0589d4e-09cf-4574-8106-4921fc02641f	test_product	generic	This changed everything	0.1	2026-04-26 11:04:24.331911
eaaaea8f-cfe3-4984-9c4f-c651f2614351	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:24.331911
0bba64ab-d287-4b78-a58d-e90752fef088	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:24.331911
ea3ea87e-0920-4d45-8f72-1de1c3d54a5f	test_product	generic	This changed everything	0.1	2026-04-26 11:04:24.331911
15ede5fe-6c88-4caa-8c03-7b0683b0c94a	test_product	generic	This changed everything	0.1	2026-04-26 11:04:24.331911
b56b315b-9ab5-45d6-b6a5-80029c3b1c36	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:24.331911
57c64bb8-3e8b-4ce5-bd53-d8f1aeec2579	test_product	generic	This changed everything	0.1	2026-04-26 11:04:24.331911
abe86644-f568-4040-84ce-c92ffbaf2687	test_product	generic	This changed everything	0.1	2026-04-26 11:04:24.331911
df44cf74-48eb-4fdb-b70d-92c0097f2c83	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:24.331911
abba653c-720e-4d49-a90d-77542e9ae752	test_product	generic	This changed everything	0.1	2026-04-26 11:04:24.331911
ab50b55b-9100-4fdb-938b-b1c51fec64e3	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
fa3cc012-dec4-4621-9364-c8158649129f	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:24.331911
0cce48fd-f9cb-45ea-adb2-0f150e4849e7	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:24.331911
29b509c7-c1b2-4603-b0ba-6ab2dacf8caf	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:24.331911
037d0582-a85c-4466-a074-b65c9eeee92f	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
4c7ff562-1db2-4ce3-9382-20926b5f8b71	test_product	generic	This changed everything	0.1	2026-04-26 11:04:24.331911
7bf36b86-9fe2-4cb2-ad64-334445ff69d9	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:24.331911
ee72a0c7-756f-447b-abd0-b8c47e57dcb9	test_product	generic	This changed everything	0.1	2026-04-26 11:04:24.331911
717f4ee3-2f9b-4795-9b24-da2c3745d6cf	test_product	generic	This changed everything	0.1	2026-04-26 11:04:24.331911
6ac23c77-5b13-4e47-b14e-196ee78ed572	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:24.331911
b532d9c4-e0e6-4bd7-a447-38979ebf094f	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
55e5e5af-4584-4642-a0f7-79b7c7247ed0	test_product	generic	This changed everything	0.1	2026-04-26 11:04:24.331911
bbd27b13-2cd6-4200-8480-694e3009dbfd	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
88f4a785-0b35-471e-9064-2a54a0012981	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
82c7cc5f-6b97-4d4b-808d-8c7b5626c1be	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:24.331911
5c20497f-5a98-40cb-b10f-75618af7dc0f	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
e22a709d-2742-445c-bd96-cc46f52aab71	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
4bd318e0-5586-44df-b1a9-195ede4458e6	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:24.331911
241c2ff6-7f86-467d-b10c-5cd4ade1a2dc	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
646ca0cd-fc69-481c-9172-29040f8cb03f	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:24.331911
80fd02fd-f190-4229-9f99-12c96e99485e	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:24.331911
f4ee8105-05cd-4765-95c5-54b144ab3014	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:24.331911
8f3fdc0a-d750-4c90-9900-ef854c348eb6	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:25.775779
0aef59af-9821-43bc-b542-66af0db0167b	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:25.775779
5cd1c146-20a5-45b9-91e8-5fa6830793d8	test_product	generic	This changed everything	0.1	2026-04-26 11:04:25.775779
691aeef0-58b6-44f9-b666-dc9715586901	test_product	generic	This changed everything	0.1	2026-04-26 11:04:25.775779
8f357fa1-2270-4ad1-9287-4ac8640babd5	test_product	generic	This changed everything	0.1	2026-04-26 11:04:25.775779
74d03931-09c7-460e-b77e-37f6782fc3dc	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:25.775779
cc73892e-ec68-42de-a2ef-961b0d478740	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:25.775779
20c7d8db-8fe7-4765-96a7-606bd6be9bbe	test_product	generic	This changed everything	0.1	2026-04-26 11:04:25.775779
ac37dba2-931c-4467-bb66-11bd99ada152	test_product	generic	This changed everything	0.1	2026-04-26 11:04:25.775779
b1845123-32b3-4579-bfaf-247c9ef6b0a9	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:25.775779
b4053d5a-1ed4-4ee6-91bd-a0ed71fbf024	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:25.775779
dd4fe9f8-a4c4-442f-bf22-b07068729bc0	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:25.775779
35da936d-0097-4858-967c-7f98a9c67528	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:25.775779
4bbd608d-632b-4c33-8e55-4379214c22bb	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:25.775779
1782659d-e94b-48d4-9ec1-1cdec7554d29	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:25.775779
7173cfc3-0e49-434e-b7ad-601d652ab21d	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:25.775779
585b6496-d6fd-40bf-9d45-d13e1a3e791e	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:25.775779
677cdb4b-4c83-4220-a3af-82ac20f7d813	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:25.775779
1ee97b26-0181-402b-a89d-08b958f9c21a	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:25.775779
66dca6c4-91fc-4fe9-9f83-7923382884e2	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:25.775779
48dc79bf-a6c6-4cb1-a18e-0109690a3379	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:25.775779
77c741f3-d83e-4e91-ab3d-a76f05344054	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:25.775779
13db8e55-b898-4eed-baa5-9b10f33e6caf	test_product	generic	This changed everything	0.1	2026-04-26 11:04:25.775779
3159cec4-5624-49e8-b4a7-cf4b8132efc9	test_product	generic	This changed everything	0.1	2026-04-26 11:04:25.775779
460e95ea-37c1-4dd7-ad2b-1b375ca80260	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:25.775779
271739c8-caef-47e2-8b87-d0585a3ef441	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:25.775779
9e482f86-7526-4658-8e29-f2be8496733f	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:25.775779
f5d6a708-0b2b-400b-a2a9-38124949654b	test_product	generic	This changed everything	0.1	2026-04-26 11:04:25.775779
978f9cb8-9622-43dc-a363-eba5ff604dc7	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:25.775779
1438c03d-414e-451c-8ffa-b50fe20ef0aa	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:25.775779
b0d63504-bfc7-4909-ad08-beb7f769ea09	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:25.775779
4888e7ca-d822-405f-8df4-23735d96b671	test_product	generic	This changed everything	0.1	2026-04-26 11:04:25.775779
ee08e4e2-dbdd-488b-ae80-8a6bc187de50	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:25.775779
2c34f93d-75f6-4639-ab00-12de6dacb3da	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:25.775779
6a66838c-8c66-478c-9a6c-d63f19cbecc7	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:25.775779
c0fdaf86-7290-428f-92cc-6fbef59cc5e3	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:25.775779
d415d518-d6eb-48b1-8a81-39010071a9cb	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:25.775779
ee2e285c-53b6-4578-95e4-7bee758faf61	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:25.775779
7bf6edba-e7ca-40f4-8dbc-0837be404dde	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:25.775779
830b7994-7121-4f7e-85e3-87cbe90042e9	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:25.775779
2ab292b2-8bb5-4293-9fce-1eb8d990cab6	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:25.775779
9c53d569-e774-400e-85e5-e674143cbfd6	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:25.775779
4d7f9135-3147-4449-ac5e-8b574319e46f	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:25.775779
3ceb9ceb-c374-4e9d-b13a-fc35838ff05e	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:25.775779
75aac803-52ee-4fcb-8067-f16273dc2931	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:25.775779
af4e374e-8b24-40f3-b873-14e6d9fa0019	test_product	generic	This changed everything	0.1	2026-04-26 11:04:25.775779
0b0f9fa1-73c7-4787-b567-5844195342ae	test_product	generic	This changed everything	0.1	2026-04-26 11:04:25.775779
0dd6e468-486e-417f-aaed-3ff142837bfe	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:25.775779
5a0b0e62-9ab2-46e1-86e2-5dba80d406be	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:25.775779
0dafde19-bab3-44a0-956a-e31e877e8765	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:25.775779
150f7a76-2112-4716-896c-6b0bbffd4df0	test_product	generic	This changed everything	0.1	2026-04-26 11:04:27.055761
743c3017-9fb4-47c6-a7af-09cf9609d22e	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:27.055761
ca920878-173c-4021-af24-d162c1ae54e5	test_product	generic	This changed everything	0.1	2026-04-26 11:04:27.055761
3966eda0-da0b-446b-b607-b00ab1871c4b	test_product	generic	This changed everything	0.1	2026-04-26 11:04:27.055761
6c8f1375-7205-44e2-a04a-4a8b30e9294a	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:27.055761
d0816468-e6d9-4f8a-962e-fa91cf2090c5	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:27.055761
301858fa-ca32-4ea1-b5c3-6c61d778cee3	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:27.055761
92ede9d5-c8c5-4465-a583-8c3c8db62a6c	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:27.055761
3d5cce4c-2382-4485-8e69-aa2b69866c85	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:27.055761
91796710-4867-4173-9cfe-e44953fe5c25	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:27.055761
9d74a6c2-2a13-4ebd-bc63-8b3b00611eba	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:27.055761
2634db65-ef38-414f-9909-e727559a2239	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:27.055761
fde41596-de0e-48bf-ad0e-965a9334e985	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:27.055761
5c39cc69-31ad-4cba-bc40-8ceac794016e	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:27.055761
5dc5629c-ba24-4fed-b22a-bef40e2a3670	test_product	generic	This changed everything	0.1	2026-04-26 11:04:27.055761
b9dd131a-0efe-4af7-b80a-85fd9e7548ac	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:27.055761
0cff65d0-61e9-4450-b775-6f5385cee46c	test_product	generic	This changed everything	0.1	2026-04-26 11:04:27.055761
8559f280-9f7d-48d8-8e1e-60f54a3de413	test_product	generic	This changed everything	0.1	2026-04-26 11:04:27.055761
f52b110d-9c43-49de-896e-eca517de5cbb	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:27.055761
be7dd45b-1821-4047-9adb-5728b9702639	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:27.055761
0db3ff64-3c56-4562-a3d3-ff1646091a95	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:27.055761
a30bccb5-ba06-4283-8e65-96a012df7a7f	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:27.055761
6e525d40-6834-4744-b16c-23d125bb2a2f	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:27.055761
4ba0c2ef-2ad7-437a-8588-8eb7e315217f	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:27.055761
7cf7e20b-79db-4eea-8da6-ef167cd45495	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:27.055761
eff64f48-c40d-4eaf-ae12-018292559c99	test_product	generic	This changed everything	0.1	2026-04-26 11:04:27.055761
35a2d90f-410f-4d10-bd8a-85e6d3751ab1	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:27.055761
7f6328ae-154f-4a1c-acf8-f0e19aaac57b	test_product	generic	This changed everything	0.1	2026-04-26 11:04:27.055761
3f43e507-6fca-4fb7-ae4d-00207f57fe8e	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:27.055761
aa697ff5-2e1c-4574-bd04-19b5157104e5	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:27.055761
0e005427-8541-43a2-9343-f1c3740dc1e0	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:27.055761
61e751a8-a0bf-41c5-a8a6-a851812c6232	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:27.055761
9d54759e-74e6-43f0-8164-a79904070ee1	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:27.055761
2c2eb6bf-f377-49eb-b53a-d5e990e69680	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:27.055761
d4977c82-cb3c-4484-af6b-b431c53304e7	test_product	generic	This changed everything	0.1	2026-04-26 11:04:27.055761
ddd39739-6fbb-4d3a-8b34-18b17c6b111f	test_product	generic	This changed everything	0.1	2026-04-26 11:04:27.055761
a474cedb-4f0f-4281-b8dd-7a8a9f8e7f64	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:27.055761
a5b9a177-2a1b-4d41-81dc-5b1e79a258b5	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:27.055761
6221e1e2-77dc-4e1b-9348-a56bd8c2efbc	test_product	generic	This changed everything	0.1	2026-04-26 11:04:27.055761
ea386127-8256-474d-be59-416ba30bb314	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:27.055761
71cc2685-3dcb-4eeb-8f09-fad968b82171	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:27.055761
c1183aa3-6c49-40e6-a84e-b75e962f9062	test_product	generic	This changed everything	0.1	2026-04-26 11:04:27.055761
8760c9e3-85cc-4d78-9697-165c16cd6513	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:27.055761
27fdab2e-a666-4393-a87d-ecd6e8d3f7da	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:27.055761
fa1b3bf1-f1eb-4db8-a98f-3c53ae1d3737	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:27.055761
ec01c94b-6e4d-4f63-a432-613797e10f21	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:27.055761
0e7363cd-3ccb-4fca-b747-d7d15632cba6	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:27.055761
2807a86b-5f62-4bcd-a376-32663e89a984	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:27.055761
42464447-9af5-4499-a806-28c093a94e6d	test_product	generic	This changed everything	0.1	2026-04-26 11:04:27.055761
187eab6e-4e10-4462-89f1-5838abb47f71	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:27.055761
3968af74-15f6-4769-96d1-a39b56a4b39b	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:28.601989
2774e85e-27bc-41d0-8957-8132133a65a1	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
53fae0a0-f25d-4929-b448-4c1069c9f9b9	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:28.601989
79ae2d36-7a11-43b1-8d84-81023e5a647b	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
ff303344-7669-42b9-a2fe-f60baf7452e5	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:28.601989
771f60cd-78bb-435f-8527-25a953ca0f63	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:28.601989
fbe876a7-3b6e-48a7-867b-18c06013f4b6	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
723f1487-104e-4055-89a0-a9cf7cb090f0	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:28.601989
bea17461-8890-4112-9278-e0527d7ef115	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
184d4859-3e78-4213-abba-230c98b93b1f	test_product	generic	This changed everything	0.1	2026-04-26 11:04:28.601989
d22468ab-6bdb-4282-b9fd-8c1badd9c568	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
58aae96e-dba1-4c23-91e0-4a18fa2d2bf3	test_product	generic	This changed everything	0.1	2026-04-26 11:04:28.601989
f3b8db68-974f-4b46-b940-753393a12dd5	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
437137b9-c076-4725-9ad3-8ce34955e3ab	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
f7826379-1e08-45a7-be50-58b86a444926	test_product	generic	This changed everything	0.1	2026-04-26 11:04:28.601989
53a6ba29-5f29-4940-b7ee-8bc2236c468f	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:28.601989
447c14b9-48af-465e-8d83-549359585c78	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
80dbd802-2e15-423b-86c4-bcff18ef4822	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
164ceb8d-1cdf-4348-a056-c96d86f01c12	test_product	generic	This changed everything	0.1	2026-04-26 11:04:28.601989
23187d6c-deed-4e7a-871a-66649043fc09	test_product	generic	This changed everything	0.1	2026-04-26 11:04:28.601989
b428be4d-63ac-4171-abb9-a6a6136828d0	test_product	generic	This changed everything	0.1	2026-04-26 11:04:28.601989
7819df71-e4b5-4b23-93a3-fa7a90f26d9d	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
0e17d924-adf6-42e4-827a-3c4504b4d1a9	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
5dbaf952-8130-4f5f-8b86-9f30de4e8fca	test_product	generic	This changed everything	0.1	2026-04-26 11:04:28.601989
5b3f2da6-fff5-4a2b-8ace-16c46e3a7239	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:28.601989
ac616b9d-10eb-4f18-9067-837332c8eaf9	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
cf87f9e7-d1e6-4631-a068-9296610028da	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:28.601989
eba9ce4a-da33-4400-8127-d3fe7992c581	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:28.601989
725b25f5-b98b-4328-858b-82e6681229c7	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:28.601989
b5d06bbd-0786-4f9f-ba00-0df4606c1967	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
c0e4225b-dfcf-46cd-a41d-cab7268b1209	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:28.601989
f8f1e528-0b29-401e-b215-a40fca12e2f5	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:28.601989
490c1404-ae52-4821-a71e-f109c5218903	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:28.601989
fee74a9a-4145-406b-9624-658961b0bbc9	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:28.601989
4411231c-da42-4ad8-aa20-3997a117cc7f	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:28.601989
a9697c3d-2f7b-4742-8cd3-393e02b36f03	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:28.601989
c8dee6b8-e3d2-4de6-b212-1f365ae0d6c1	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
79da1695-4376-4e42-ad36-5145ac900335	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:28.601989
a3fc517e-21e0-4858-b98b-34d40abc7c00	test_product	generic	This changed everything	0.1	2026-04-26 11:04:28.601989
98ccd39d-d52e-4500-830f-f2a81f944a31	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:28.601989
9ee9181a-a6eb-4e41-9eea-5d9b6bdd47fb	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:28.601989
f90e0153-cbe6-48c5-80c5-dc8036439c6e	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:28.601989
958a40ee-d6dd-480a-95cc-31a0838987e5	test_product	generic	This changed everything	0.1	2026-04-26 11:04:28.601989
84a29d07-5894-49b4-a243-3d90cb9f8bc6	test_product	generic	This changed everything	0.1	2026-04-26 11:04:28.601989
0a26d78f-f044-487c-aa0b-add8043f5284	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:28.601989
bf4a21cb-806e-420f-a17e-653d93248e1c	test_product	generic	This changed everything	0.1	2026-04-26 11:04:28.601989
629bb270-782c-400f-af33-d97c345ceac2	test_product	generic	This changed everything	0.1	2026-04-26 11:04:28.601989
198c9ae8-de50-41c5-bdd9-f5b3241c9e06	test_product	generic	This changed everything	0.1	2026-04-26 11:04:28.601989
e6c6ef27-d3b0-4ef1-8b13-460e7dcde244	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:28.601989
eff5110c-1c38-4b64-9c87-c01ffdb6b9ea	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:28.601989
5d3556ba-9ea0-413c-8ed2-dbd3df1e3a4f	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:29.894406
e3c60a43-8eba-4767-8c2b-a366b112aaf1	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:29.894406
49088693-3597-49e8-b8fa-9d42359e4c60	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:29.894406
1f3c9443-127f-4694-94d2-0005688eee1f	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:29.894406
a7b342e5-0a32-4613-b7ab-78baef4e3fbd	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
6f20f803-4433-4456-a7fb-27875195bde9	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
8898b6ae-c785-4339-bd33-883339bcdc6c	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
8a0f4c8d-6360-4139-8f98-6bd7b3725cac	test_product	generic	This changed everything	0.1	2026-04-26 11:04:29.894406
25c56572-3573-43f4-80ed-07209c6009dc	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
71baeec3-d6ea-41c1-9df1-e9b04e85283b	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:29.894406
efde7182-a9a2-4a60-a59b-7b14e0730e33	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:29.894406
a9ba5ab7-8bc8-4be3-9b33-24a08afce9cd	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:29.894406
e16d7212-8f24-46fc-a1eb-e9b850cbc29e	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:29.894406
5dabb8dd-272a-48db-be67-d85fee421747	test_product	generic	This changed everything	0.1	2026-04-26 11:04:29.894406
964b0e52-3f1e-4449-98f2-6a9955d3729d	test_product	generic	This changed everything	0.1	2026-04-26 11:04:29.894406
d34a2c50-20e1-4e25-a209-f863b156668c	test_product	generic	This changed everything	0.1	2026-04-26 11:04:29.894406
c3f3ab0e-46a0-4a4b-8a97-d9c2bf1f79c6	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:29.894406
38fabe89-4b43-4292-9c74-c023f45b8e27	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
789e07b3-c42f-4830-8050-17b7b1a48067	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
6fa1da71-ed1c-47ab-8251-93e11e245524	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:29.894406
56cb7f73-ccd8-4b6f-a8b8-e034b57f0e30	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
a64e8de8-51b8-42a0-9e56-330505ef441f	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:29.894406
90d315f4-775b-4c62-bc50-8f331ad06d52	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
a3e58d48-3f2d-4162-ad68-80b3e3849768	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:29.894406
d5b0fc48-eda0-4134-8322-775886849cca	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:29.894406
f28a5ce8-b34d-42ee-9df5-f3276a1a6435	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:29.894406
3c86f235-9d76-4127-88cc-a9fe23171d68	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:29.894406
d0a484d4-3283-4bdc-87e0-c08a921e42a4	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:29.894406
28fcc177-b62e-4a02-9c73-e33707847a71	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
6ece5553-0c38-484d-ab9c-ec5e4a64eb1e	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
7543d5f2-17b8-48cf-8cf9-29c3e9f202b8	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:29.894406
cfded23b-8b10-430b-9ab0-528d965d3ef6	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
f08a1225-0390-4204-9bb1-23caa60b687b	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:29.894406
a774baf3-a6e1-40cc-be0f-0fef1b0993ad	test_product	generic	This changed everything	0.1	2026-04-26 11:04:29.894406
c6a5a3ca-9e97-44ae-ab04-569db9d5c22c	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
b7de92e3-d5c0-42e5-b028-c23f16e6b9e0	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:29.894406
29f2df7a-ae14-4393-b7ed-c7c5d567cce9	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:29.894406
9d578dac-42e4-4c61-8d52-aaff3949cd69	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:29.894406
5bda041f-2c80-4c4d-8b1a-a3e17176322f	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
979e11cc-9b95-43fd-b91a-a187d92c8d9e	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
38870dce-ab43-4399-b7ca-cde7202e3d9a	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:29.894406
ab330d62-7951-4d46-83cd-bf1ca87bb787	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
899db5e1-02ff-4a5e-bd6d-8aad0a9b67e3	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:29.894406
b97e09e6-12d6-47f5-896f-e259b12e90fa	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:29.894406
541027d0-c4e7-4016-b744-26e41e2ecce2	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:29.894406
152a496d-d7e5-4333-9569-56d5fd0b9199	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:29.894406
96123844-4c89-4da6-b3ee-0a9c43084923	test_product	generic	This changed everything	0.1	2026-04-26 11:04:29.894406
4837e5c2-a5d8-49d0-9d1e-dfdfed2f0384	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:29.894406
99a9878d-9d4f-4b72-bea9-2ae912cbe8f6	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:29.894406
e4ceb3ba-8ccc-4589-8a56-55427cbd74ad	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:29.894406
d322cdb5-7267-48bb-8736-56f60a35faf5	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:31.396008
574c977a-664c-44d0-a1f2-c0e0d174b3c5	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:31.396008
0b53066c-68f8-4385-9062-13bbc206c68f	test_product	generic	This changed everything	0.1	2026-04-26 11:04:31.396008
4d9f35b8-c973-4a68-a538-e61589f18588	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:31.396008
9cec3581-54c9-42f3-a496-2c8789e7d915	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:31.396008
06037f6a-40e5-4ce7-8f7d-b28167309e81	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:31.396008
1dbd3e96-0e27-427a-92c9-85a3b837ab2a	test_product	generic	This changed everything	0.1	2026-04-26 11:04:31.396008
289200d9-da84-469e-aba0-c4e5dffd557c	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:31.396008
1abf996c-d0e5-435d-be5f-31f62f4d9bc6	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:31.396008
2274f059-2a47-44de-8683-914e5b2ce995	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:31.396008
991d2854-e6e1-4bf9-a3b2-8c7769f94db4	test_product	generic	This changed everything	0.1	2026-04-26 11:04:31.396008
95db7da2-9e63-4ed8-a0ed-080641c15e87	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:31.396008
c10a84e1-3e6f-4645-87f9-67794bd91be7	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:31.396008
d4058856-43dd-4628-b33d-dfa684e71418	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:31.396008
6615dc4a-ba2c-46a1-97ff-4aa5ea425fea	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:31.396008
352106cd-062c-429c-bb67-0e1797c53a8a	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:31.396008
02610a30-1909-456b-aba4-48b99c90ddfd	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:31.396008
98578537-85e2-4560-9a4a-896d6c3bb725	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:31.396008
26a50e71-8fe1-43b4-bb28-5f5d41a1e975	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:31.396008
3010f563-7a7d-44d9-942b-c189dce06699	test_product	generic	This changed everything	0.1	2026-04-26 11:04:31.396008
56e5e992-4394-49cf-bd55-9894590693b1	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:31.396008
4457ba3d-2341-4992-942e-6ff1aa177e1d	test_product	generic	This changed everything	0.1	2026-04-26 11:04:31.396008
c3bdc356-92ec-4d05-b9db-06ff2ea186eb	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:31.396008
48f4a036-1ee3-497c-87e3-3c32fd37223b	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:31.396008
d1a4474a-b4b1-439e-bd48-bdd04b964c7e	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:31.396008
8766e38b-d8a5-4207-b41c-bb8afbbe16d9	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:31.396008
afde3aa4-9a14-4dc8-8463-53a1c3ccb549	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:31.396008
f62daedc-0fd0-4fc5-b7c9-3499ffd85faa	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:31.396008
e6874779-45cf-4fe0-b7a8-781d7ec283b0	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:31.396008
57b6aa71-7d9f-4756-89bb-9a582b31ae3c	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:31.396008
3a651fef-9c19-4985-a16f-4e69997a289d	test_product	generic	This changed everything	0.1	2026-04-26 11:04:31.396008
82321542-c2a2-4a6b-ac77-f07603198b14	test_product	generic	This changed everything	0.1	2026-04-26 11:04:31.396008
4050136e-9b86-49a9-935e-c420ec6e3447	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:31.396008
90e97d39-b09e-4ea6-9bbd-12ead5af2f48	test_product	generic	This changed everything	0.1	2026-04-26 11:04:31.396008
eddb22b8-531b-4f63-b864-39403c63f1d3	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:31.396008
c033856e-44a2-427f-9f7c-aab1e2f4c106	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:31.396008
b817e4be-64ee-4a72-b485-381eba09416c	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:31.396008
213bffe1-345f-488c-842f-b5d886dc3af2	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:31.396008
98ae3553-b5b3-412c-a1fa-4d4ad4608449	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:31.396008
eecd902c-edc9-4921-bd88-f41d016f11dd	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:31.396008
7e846388-6715-47e8-8a99-1aec7c4d3c7e	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:31.396008
3945bb18-95a2-40df-8c9c-d98b3c4f0c9d	test_product	generic	Hidden secret revealed	0.1	2026-04-26 11:04:31.396008
2b794314-0ee2-49e2-8eca-25f9c5641157	test_product	generic	This changed everything	0.1	2026-04-26 11:04:31.396008
290bdd33-7a5a-4666-8a68-95470ae35bb2	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:31.396008
12eddfa4-a86e-4783-aaf4-747fa0dd01c5	test_product	generic	This works in 24 hours	0.1	2026-04-26 11:04:31.396008
ab7d203e-4428-435c-96ff-3f26aca17709	test_product	generic	Nobody talks about this	0.1	2026-04-26 11:04:31.396008
184e0ff2-79eb-4572-9539-0df91bdc1769	test_product	generic	This changed everything	0.1	2026-04-26 11:04:31.396008
cc06b73a-3173-41fe-92f0-61f6c941a39d	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:31.396008
79397003-cc0e-4628-98d5-3a9926190f6f	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:31.396008
3f2f5a3c-5fe9-4953-920e-8eb4e5598981	test_product	generic	Stop wasting money on ads	0.1	2026-04-26 11:04:31.396008
499da728-ef77-4511-b7fc-64be7288b193	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:41.115891
8007644f-7595-4841-b2fc-68e156af22d2	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:41.115891
2556cbaf-5c06-47b6-8851-2f7979d3cf9d	default	generic	This changed everything	0.1	2026-04-26 12:07:41.115891
873bb4b9-93d5-429f-900f-76e5272c2461	default	generic	This changed everything	0.1	2026-04-26 12:07:41.115891
ff1cadea-298c-4a2e-8bdd-d908a1990cec	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:41.115891
3c0cfa48-674a-4eb4-b1ca-7339e9227fd5	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:41.115891
6f2534c5-1591-4ed7-8a55-6033c8c5e823	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:41.115891
8d12549f-94e8-4e6e-9d88-d27d4944c307	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:41.115891
e57b4b7c-52a2-4a03-bff9-8a2774caffbb	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:41.115891
1a54b840-61bc-43a5-b2aa-53cfd3343800	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:41.115891
93618135-3f17-4920-9614-5cc39d56d0db	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:41.115891
7abc34bd-5bc9-442c-9b7f-0557870f0c24	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:41.115891
158c854a-b770-4200-a209-294e6704feaf	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:41.115891
a13df94e-1b7e-4d33-9332-74d10dd27964	default	generic	This changed everything	0.1	2026-04-26 12:07:41.115891
60a5e1ad-deb4-4f59-b4a1-6df006016ae3	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:41.115891
a0351fad-c8e2-4d00-a097-e87b7b06ac70	default	generic	This changed everything	0.1	2026-04-26 12:07:41.115891
af31d9c6-830b-49dd-afed-1364a86c8db7	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:41.115891
1a8899c1-a82f-4690-b52a-4280db69fac7	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:41.115891
92af0940-bad5-4409-841e-3be944f07d10	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:41.115891
19be46f0-7bb5-4cdb-8f0c-da0a934290e5	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:41.115891
e2b4e27a-1071-479f-96fe-0c9b482acc0f	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:41.115891
008abb02-c0d3-4c89-b3dd-13fe0ff278af	default	generic	This changed everything	0.1	2026-04-26 12:07:41.115891
9d3e3003-8770-4511-97ba-287a2cbe90ff	default	generic	This changed everything	0.1	2026-04-26 12:07:41.115891
fb5e47a3-08e2-4af4-9448-0d4e1904a82c	default	generic	This changed everything	0.1	2026-04-26 12:07:41.115891
616c8f28-c17b-4f78-82a5-24ac45ff08a7	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:41.115891
019f7898-ddd0-4214-b433-acb7e7d09ada	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:41.115891
529833f0-728a-4911-b0dd-9f14cc098f9c	default	generic	This changed everything	0.1	2026-04-26 12:07:41.115891
d5570b86-ac41-4b3a-813a-25f22ad159f1	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:41.115891
9f525321-40e5-4413-8fc3-028a1adbeb73	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:41.115891
769c5474-8a5b-423a-a1ed-6329dfdb60af	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:41.115891
e203fe55-4e26-4643-bc73-bab7ece409b6	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:41.115891
065ebda9-e257-4801-a1dd-386965ea00be	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:41.115891
808670a4-1678-4d34-abde-69f269517e43	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:41.115891
f8b34bef-b3e5-4013-ac0c-b6c5a37fddcd	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:41.115891
dc4b52d4-be5c-484a-b196-d7b00bb451c2	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:41.115891
41dc3319-72f7-4661-9f2f-448da69783b2	default	generic	This changed everything	0.1	2026-04-26 12:07:41.115891
a6de48c2-215f-45a8-ba96-6d71609da6ae	default	generic	This changed everything	0.1	2026-04-26 12:07:41.115891
904a0b40-5718-44a9-91d0-de9daae079d6	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:41.115891
e3daac72-7874-4a18-8658-77c5db5a380a	default	generic	This changed everything	0.1	2026-04-26 12:07:41.115891
cbb2fbbd-4005-4ab9-9746-690381f8deea	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:41.115891
b38ff53c-ac61-4910-a131-5180e13a69dd	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:41.115891
5e01d662-43b6-40f7-83db-daafc75c459d	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:41.115891
6e2c6a0c-099a-4a89-bc9f-9c45e9421575	default	generic	This changed everything	0.1	2026-04-26 12:07:41.115891
a5a14638-3f34-4630-a96c-e8325640cc9d	default	generic	This changed everything	0.1	2026-04-26 12:07:41.115891
06586d52-aa56-4957-8567-385bb9acc3d8	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:41.115891
0dbfa211-76c9-4814-9521-4fa46bc11f94	default	generic	This changed everything	0.1	2026-04-26 12:07:41.115891
5c8e6d00-5132-414e-bbc2-d05bbcb12ce8	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:41.115891
409189ea-58ea-475d-bd35-fe89945d49d0	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:41.115891
08c1f87d-e772-4661-ad8d-51eecfa0ca72	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:41.115891
b715307d-5b92-43fc-aa86-a7718e26f203	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:41.115891
5e323efa-f6ab-4b1f-8ef2-e0e1970c1b16	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:42.619504
11eb9817-9d8f-4853-ad71-0945daf183ad	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:42.619504
bfff2b04-1680-45fb-91e7-9e8fd894279c	default	generic	This changed everything	0.1	2026-04-26 12:07:42.619504
8e736cbf-b4c9-4b88-8d28-9e6a6e8345ef	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:42.619504
7e320760-ed22-4649-b4f8-6df0d69704a2	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:42.619504
92ca5c18-31c2-481b-b8e4-7352359b0ba3	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:42.619504
4202baf6-78f4-44f8-81bd-1226bc0d4e15	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:42.619504
580d07f8-1fee-4ed3-92b0-d33cd5ccc728	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:42.619504
c3265caf-00da-4b7a-aa36-748e2b1a46b2	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:42.619504
72befc66-6911-4b7a-a520-129520116bf8	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:42.619504
d1e10f3d-82cc-4bd4-8013-af84c4c19b5a	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:42.619504
85ed1487-3322-4bcc-be69-0acc1ce083a8	default	generic	This changed everything	0.1	2026-04-26 12:07:42.619504
1ec74605-0f7d-47ad-8f62-22851e9bca3c	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:42.619504
83fd6e10-a521-454c-9f87-412cc43564ba	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:42.619504
36557492-f498-41a3-869b-695832695187	default	generic	This changed everything	0.1	2026-04-26 12:07:42.619504
e940e29a-b874-495b-b1de-ab341775f063	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:42.619504
9cfd4c9b-079e-4ef8-9a2c-76bbfc2dfeb4	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:42.619504
e2ad7aab-858c-4a5d-a16e-ac7fd6046c0d	default	generic	This changed everything	0.1	2026-04-26 12:07:42.619504
a4627366-b7da-4eda-9110-12d143118132	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:42.619504
a63cbca0-da0d-455f-96d9-073530b79350	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:42.619504
4b0463f5-a093-4310-bdf8-a9b4d712d63e	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:42.619504
6b830354-63de-4681-977c-68acfb2e55d7	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:42.619504
3ced4ecd-f217-4e58-8d2d-60fe33302da2	default	generic	This changed everything	0.1	2026-04-26 12:07:42.619504
1e907a81-580b-4760-b782-2dfe9a198232	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:42.619504
216bc001-c5f6-4e17-8e70-c59725bb068a	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:42.619504
c8bb0e1b-23cd-45f4-a295-90b3516d8c3a	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:42.619504
dbb4805e-fc50-4c46-b82f-1d047f9281eb	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:42.619504
753b123e-60c1-435d-b714-e33bb3272b9f	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:42.619504
7b42f6e4-d8e6-4931-82be-7942c769b65e	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:42.619504
c9943915-b51b-43f2-b432-57ff2331e6d9	default	generic	This changed everything	0.1	2026-04-26 12:07:42.619504
755867c0-ebd2-434d-9d2c-98f004edfa52	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:42.619504
b63d1cef-f532-4a95-a173-0cdfd2ad2147	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:42.619504
b2ac5898-f07f-452c-be5b-3faa47e3ec62	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:42.619504
0d954d0c-ac58-44e2-9fa1-1509fc608113	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:42.619504
52205473-aee8-4ea0-a802-3d9cc12a18be	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:42.619504
5d134b10-4fc5-48fc-b3ec-9042efeaed49	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:42.619504
04da5b8c-d84d-4d7b-8600-40648eb671cf	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:42.619504
2299acbb-7bb6-456d-9707-ddae1a1282c5	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:42.619504
ffd0fb58-b2fc-494a-afcd-20d48d2579a6	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:42.619504
4bb6eddb-e191-4c06-bddd-fabc748ff478	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:42.619504
dccba878-8981-41e6-8c43-266c4554e1bc	default	generic	This changed everything	0.1	2026-04-26 12:07:42.619504
1ddcba99-271e-4e9f-b284-1c80d3e18459	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:42.619504
f7fd4880-0383-4358-993c-e31471a1fd48	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:42.619504
10727e49-6a99-429c-aaaf-e9eea286136e	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:42.619504
4dd13fe7-ab7b-44ef-ac6c-accbd11fa8b3	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:42.619504
3cc2c443-9948-4469-ab3c-edb399fdf3a8	default	generic	This changed everything	0.1	2026-04-26 12:07:42.619504
1b08db9f-3f90-46ce-9aa2-738021b28f61	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:42.619504
ed410372-051d-45bd-b6d4-331292a9ac62	default	generic	This changed everything	0.1	2026-04-26 12:07:42.619504
7afe1775-4125-489a-8a58-7160af8df2cc	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:42.619504
1426bd8f-e43b-45dd-93d5-2cc72acf15c7	default	generic	This changed everything	0.1	2026-04-26 12:07:42.619504
aaff94bb-c124-4aad-8941-6a3b2bd33949	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:44.923746
afe5f927-f4d7-4106-9ed1-c613ce2447dc	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:44.923746
3decc9d6-2c25-484d-97ed-0ee09ed5907b	default	generic	This changed everything	0.1	2026-04-26 12:07:44.923746
b79304fb-cabe-432d-a084-ee75d3481eba	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:44.923746
bdc76598-8a60-4987-8ddf-a8fc3b9f7eeb	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:44.923746
64530faa-30ad-4397-a5cd-c37c4eac4abb	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:44.923746
78df5b39-25ac-4804-8718-c83403a427a3	default	generic	This changed everything	0.1	2026-04-26 12:07:44.923746
dbfc8df8-5692-472c-a840-3b24f1e375cf	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:44.923746
5abb2a65-fc4b-45b2-b96d-f1e4512e9e32	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:44.923746
15d0bf65-e3c8-4a91-8750-9256611968b1	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:44.923746
53710b1e-273f-43bb-923d-f63942c0c2ca	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:44.923746
622d3ff9-098d-44fa-ba96-12dff18c8a90	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:44.923746
d8f24f0a-d75e-494f-932d-122510786fdd	default	generic	This changed everything	0.1	2026-04-26 12:07:44.923746
cef65ab7-a304-4e6d-83f5-f4a22b740d9a	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:44.923746
2d2cb53c-3e16-4b1a-afc8-cb8c69798b04	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:44.923746
af6e20a0-01b0-4988-980a-4c174f382449	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:44.923746
1785bbd2-2186-49e9-831e-c27d3fc7b8af	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:44.923746
1a5eadbf-4364-4828-9787-1480316e5db9	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:44.923746
62a037a3-9a28-4041-a0e3-f45626266ecf	default	generic	This changed everything	0.1	2026-04-26 12:07:44.923746
a89122c4-b949-4fa7-a81d-11360d68b413	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:44.923746
105ee2e1-2b39-4ab4-8b38-48d17f874286	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:44.923746
aa6414e1-d134-4ace-8ec9-0734cc331058	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:44.923746
d4308bf3-2905-446b-8c5a-d87fd0495098	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:44.923746
8acef1bc-78cf-4711-b0b7-c51d0d3e49b0	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:44.923746
099c9450-3a23-40e2-ac9d-5ee7d70e22d5	default	generic	This changed everything	0.1	2026-04-26 12:07:44.923746
1f975f07-c72a-417c-abb5-e05e0464ce7d	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:44.923746
3b3572cf-98b5-4adc-9886-222d788166e6	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:44.923746
24d4a1ae-c31c-4788-b224-9fbafbe854d7	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:44.923746
611970b0-d438-43c6-8441-40882ca65be1	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:44.923746
3db92bfe-d949-4fa4-9468-5c9cccaf4d3a	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:44.923746
3842f4c7-a445-46b4-93d0-e4edafd51c54	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:44.923746
88be12ff-e86f-47b4-a39b-0a5752247d19	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:44.923746
7199827d-99b6-409c-b9bd-4ba605c75920	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:44.923746
313da6f3-c55c-4d6a-8e15-ac841fa39f06	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:44.923746
f82c567a-b8f3-444b-be96-71aaaa671705	default	generic	This changed everything	0.1	2026-04-26 12:07:44.923746
80410db5-9fe6-467f-b742-c6f0c231fe6b	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:44.923746
6cc90acf-83d2-4b25-96b7-9a0c616c284d	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:44.923746
c13061b1-053d-4ea0-9148-687324680292	default	generic	This changed everything	0.1	2026-04-26 12:07:44.923746
bd3c47cf-289e-446b-bc28-10c831c1651a	default	generic	This changed everything	0.1	2026-04-26 12:07:44.923746
e0db849b-2299-4c49-8577-264ff17f1e4c	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:44.923746
16898441-0816-413c-975f-c67598459d44	default	generic	This changed everything	0.1	2026-04-26 12:07:44.923746
6325f4b4-cc6b-4372-9860-5eaac4419cba	default	generic	This changed everything	0.1	2026-04-26 12:07:44.923746
9656e9f2-bc3e-4848-a4a6-abf78a2a8765	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:44.923746
dfb54040-10c6-4f18-8ca6-a25c35029523	default	generic	This changed everything	0.1	2026-04-26 12:07:44.923746
da7b21ba-ae99-4ca5-9849-9b2a788ea6f0	default	generic	This changed everything	0.1	2026-04-26 12:07:44.923746
a1414172-5a76-4590-9707-d3481972799f	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:44.923746
0c8b3fa9-6294-436f-954c-e5e56376f337	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:44.923746
3d1eb492-f088-435b-9e7b-87d7b28cd766	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:44.923746
615d1115-6edc-4417-8584-13b012183ac1	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:44.923746
efa64bfa-6246-4c19-aad6-1cbdd97ec0e0	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:44.923746
da19c895-db86-4728-b344-7a2a2d558b77	default	generic	This changed everything	0.1	2026-04-26 12:07:46.439983
9aee01a2-aaad-44e6-a154-5a30b520ec76	default	generic	This changed everything	0.1	2026-04-26 12:07:46.439983
6ec0cd46-4430-4d0e-8114-0063c19a8084	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:46.439983
18eafa46-f332-4736-85f3-13058e0f1c74	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:46.439983
e4a54105-e491-4a72-9f0d-4506aa0459e6	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:46.439983
86fef383-9409-429c-b03f-b6f9f82b776e	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:46.439983
b9589e6d-1321-4d5b-a4d4-1d3a30d23578	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:46.439983
47aa069c-2ca8-4f6d-bb76-10e4c6618866	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:46.439983
1fa1de33-8bec-43ff-b418-7ad3d84786dd	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:46.439983
40fbfdde-3b88-4aa3-abca-63379458127c	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:46.439983
3d7d5853-b232-41b2-b90f-aa8785b61b1f	default	generic	This changed everything	0.1	2026-04-26 12:07:46.439983
4e550c74-820c-4480-9e9d-726ae59d473f	default	generic	This changed everything	0.1	2026-04-26 12:07:46.439983
656408de-ed85-4ec4-9e4a-a01c345e9df6	default	generic	This changed everything	0.1	2026-04-26 12:07:46.439983
c9226e3b-606b-4b54-9adc-a2980746e226	default	generic	This changed everything	0.1	2026-04-26 12:07:46.439983
3c572c2b-3f9a-4ac1-8f04-ee4141440917	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:46.439983
fa1a9ccf-b1ce-4926-9a52-a0de1f909bed	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:46.439983
232a089d-88ad-4189-ae29-274f55fffb9f	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:46.439983
290f6ed1-2649-4162-8ccb-e91f6e1ac691	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:46.439983
eb81ff71-71f0-4ff1-a7d3-7ae7c9d819c1	default	generic	This changed everything	0.1	2026-04-26 12:07:46.439983
80ca73f2-92ac-45ac-969b-da7ac6374753	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:46.439983
f5fb7cb5-5ebd-461d-ba7d-66a39cf5b61e	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:46.439983
46d66da2-a40d-4b9c-ac22-a480a6cdce7a	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:46.439983
06ec58c9-bb08-4a7f-8281-9ff6080c4db7	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:46.439983
4561cac6-09dd-4c89-8eda-c336d2fbd488	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:46.439983
183b5d67-7a4c-4cfd-b20d-7a6bc2c5f107	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:46.439983
5715cc05-1634-4e2b-8833-9c7623aa7550	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:46.439983
01c24bcd-204d-4cf5-afb9-939d6b8baa11	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:46.439983
a8c9b2f7-0faf-4d45-84f7-ad0adb327632	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:46.439983
0866e8fb-285d-47ea-88d1-b18979e7df1b	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:46.439983
afa09c35-17d8-44a1-890c-827cf80567cc	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:46.439983
da14ccb3-f234-4ac2-b4fc-6e2549cc0fd8	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:46.439983
3dde30c7-682d-4a37-8933-ef0dc51ef697	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:46.439983
5a0b708c-41e3-4369-abfd-0bab2e33bb77	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:46.439983
7c5d5f7e-49e3-47db-8367-b7ea2a47889e	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:46.439983
db06013e-0d90-4d41-a7cd-4ab666283f67	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:46.439983
2a664016-4ee6-4186-82dc-3b247e58455b	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:46.439983
3ed78117-0de5-4ccb-8d54-b70bb85c0a4e	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:46.439983
a050e414-851b-4415-9ab6-624f931c1076	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:46.439983
86fb0ce2-4368-40d9-a4e9-9d17348bdf90	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:46.439983
4546aac8-58e4-47f2-85a6-041eea5e70ca	default	generic	This changed everything	0.1	2026-04-26 12:07:46.439983
59a1f380-b639-4709-91e4-af1dcc4bf09a	default	generic	This changed everything	0.1	2026-04-26 12:07:46.439983
ea757bfd-746f-4d31-8de6-5c11927d7611	default	generic	This changed everything	0.1	2026-04-26 12:07:46.439983
6bde20a2-16ec-4a4d-ae8a-81c0e282a52f	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:46.439983
316fb152-a7fd-4e33-b098-854ba59825f6	default	generic	This changed everything	0.1	2026-04-26 12:07:46.439983
b9bbca37-e3ef-40d6-ac78-b21876b88df9	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:46.439983
0d9ae3ec-c38d-42d7-9b6a-705dac0a4b47	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:46.439983
2359d588-86f8-416e-8e07-329ff5cad0e5	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:46.439983
e1404241-3795-4e95-8e4f-c2e027162e59	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:46.439983
18c1544e-78f2-4437-9b79-dc1958ad6e6b	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:46.439983
1ceab407-fcd0-466b-a73c-ba081487287a	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:46.439983
4e2307be-efa9-46fd-b340-80313d6aaedd	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:47.385922
08ea7f7d-0192-4a4f-86bd-873f4e6fbc07	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:47.385922
3c3ec71c-ff6f-43e9-bc7c-d83cf7ea17db	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:47.385922
b531718f-453e-4211-9a35-e4f03cf8ce2b	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:47.385922
b9b147cc-36fb-4db7-b95c-82a798b1892b	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:47.385922
e52e3da1-38a3-440f-96c5-1f89492c7d95	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:47.385922
928f668e-e8ec-4309-93b1-965d982d7bd0	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:47.385922
35a3c642-0f4f-47ea-b189-cafd0fe874cd	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:47.385922
dc212ae9-032a-49d0-b9b9-20de1fd70529	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:47.385922
b955728b-fb70-426d-a746-ea8d3aba03f0	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:47.385922
f22fdf33-0fc6-4188-a8b1-b385aebf6374	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:47.385922
b38ccbfa-07e3-4263-b962-a4e467a37e63	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:47.385922
02629c5e-e4f3-496a-b179-12bff6dcae80	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:47.385922
5d7b3acf-bd50-4e96-bdbc-abf94a4000f6	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:47.385922
609d845d-53ae-45f8-b330-fcd3ab7a7124	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:47.385922
8474a7b5-7cb1-422e-ba10-9e477d8b91fc	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:47.385922
c339cec1-8620-4d22-baf8-5de4e6455e5a	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:47.385922
39261c52-8dcb-430b-8f80-58406a9cc62c	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:47.385922
b35d3188-e26c-433c-b660-7c85a0e17033	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:47.385922
aa3b439f-3a2d-40a5-9370-996f04d32c83	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:47.385922
5f6ae065-377e-4d7f-ae70-8def59691efe	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:47.385922
e7577856-7290-48bb-bc5d-de4893efb81c	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:47.385922
3fc60894-39bb-462d-94d6-1f36cbb030f7	default	generic	This changed everything	0.1	2026-04-26 12:07:47.385922
8e69db6a-8557-4fe3-870d-42ff1667bcb6	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:47.385922
66ff9f24-5b88-45dc-8ea3-b7869e28b317	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:47.385922
8a07ab74-16f2-4506-a048-2a696d2a928b	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:47.385922
9b071c4b-79de-4796-bf1a-cbae6c109aad	default	generic	This changed everything	0.1	2026-04-26 12:07:47.385922
620fa3a9-d5bf-4993-9c9e-e8c347dd4694	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:47.385922
0160e76d-ef59-47e2-9b54-5ab1c3ee7190	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:47.385922
593a0637-2e80-4547-818f-d729b1cafd19	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:47.385922
d68bd8e0-39d9-43c5-a30d-70c465ad2a35	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:47.385922
1b15996c-89b1-4168-b18f-4c999326d37c	default	generic	This changed everything	0.1	2026-04-26 12:07:47.385922
ea65ab8f-907d-46da-955f-4bcffa2ab6af	default	generic	This changed everything	0.1	2026-04-26 12:07:47.385922
fe9fcbaa-925e-4bb2-9d58-a47dd410e620	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:47.385922
0e093c36-85aa-4695-82e2-f6965224cd05	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:47.385922
f9a50fcc-1a02-4b96-984a-3835b0469c07	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:47.385922
2a0556ec-c56f-43e5-906c-f1024d5a6935	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:47.385922
9b1c22b4-85bc-41a4-9d5b-5a6088e57c60	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:47.385922
5367c6bf-3309-4476-a1f7-63b4d7849190	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:47.385922
ec10e5cc-2eaa-4e02-b610-975ee6b8f868	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:47.385922
97f1cee8-4def-4eb2-8895-da672871bbdd	default	generic	This changed everything	0.1	2026-04-26 12:07:47.385922
3f4507b4-f2aa-4a5a-ae4f-c1fb2b0eae72	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:47.385922
f30843dc-09dc-4ae5-b4f0-9bbbfb9403f7	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:47.385922
4ef237a5-6a56-4e79-a7b3-7dc1a9ba9d6f	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:47.385922
a002cee3-8175-41b9-bb75-1ca6fee28580	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:47.385922
7993a55f-9fc5-4818-ad3d-403567534e6d	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:47.385922
d050112e-298b-4c0c-9eb6-4acf233c3bb8	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:47.385922
ea00180b-366b-4b37-a76e-eb54fa3cbf04	default	generic	This changed everything	0.1	2026-04-26 12:07:47.385922
d4af7832-782c-48ef-ac91-fc25f2eae66e	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:47.385922
1d2fdfbf-8d0d-423c-a56f-9e27f8176a1f	default	generic	This changed everything	0.1	2026-04-26 12:07:47.385922
470d6220-1cc8-4460-98d4-1d5175148a46	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:48.845872
c0bd4d3a-ae2e-4b2a-85ba-2562055ddd9e	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:48.845872
5e15bbf5-02a3-427a-99ee-c20054e6a6e3	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:48.845872
29444789-770e-4391-8875-93825eac01b0	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:48.845872
262caebf-87c0-4817-afd4-026220659229	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:48.845872
93add8e4-2c13-40b0-a554-535612c5a3db	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:48.845872
6867bde2-d34f-40a0-a72a-725e76a95122	default	generic	This changed everything	0.1	2026-04-26 12:07:48.845872
6a4d121b-4cb8-421e-83bd-963711d4c685	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:48.845872
402c1902-9996-484f-9065-e77f4bb33d50	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:48.845872
2471a52c-0c82-4693-b9ad-fe5957a78d4f	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:48.845872
abf1602b-6c9d-4999-9736-164a1f09257d	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:48.845872
96bff942-d73d-4414-b2bb-5728b7fb71a2	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:48.845872
1755a8dc-eee2-4dac-8d29-8c8ace393136	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:48.845872
88880e10-2a2a-483a-84a2-ba70884c3902	default	generic	This changed everything	0.1	2026-04-26 12:07:48.845872
351c9aac-ff60-4b36-a72d-61a96da6af0a	default	generic	This changed everything	0.1	2026-04-26 12:07:48.845872
c0567f34-69d4-4520-911f-8c90989cff88	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:48.845872
026c209a-a75c-4530-bd0d-2b1da5aad4ba	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:48.845872
53816b11-479b-4c55-97fa-eb879355736c	default	generic	This changed everything	0.1	2026-04-26 12:07:48.845872
64e69619-1b95-4e88-a4bb-e36bbd4b3aa1	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:48.845872
9e754d84-afeb-4189-9fc3-79cdef8ba81f	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:48.845872
1868d05b-449f-4697-952d-169475655cfd	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:48.845872
e08bf180-91e8-4f5d-8db7-2dd38f669449	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:48.845872
3b5dfc90-b714-447c-97ab-94a36978cc1f	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:48.845872
3b9764ee-ba6c-4bfd-9f32-9559a334975c	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:48.845872
e0b00013-a4f4-48c7-8405-c90a8f510803	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:48.845872
de5d128c-d8a6-446c-9612-8a1500027de3	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:48.845872
4d05eed1-facd-41fa-a862-ee55d91a49c7	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:48.845872
039f2b58-3388-4e02-8d6d-edf661778ce4	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:48.845872
f6879645-76df-4bda-9699-08c294f5da23	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:48.845872
0d8eedc4-6d03-4ce9-b1a0-14c2ab348771	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:48.845872
aa3771ad-e764-462a-8fa8-12b807d732af	default	generic	This changed everything	0.1	2026-04-26 12:07:48.845872
b2501911-aef6-4006-b3bd-2152d32056ad	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:48.845872
49e84f87-4ce0-405b-a90b-88f9e270c0e2	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:48.845872
4873f6c7-8fae-4ee9-9c57-b49e89032ec7	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:48.845872
85db995c-c084-46c5-ba94-d6d7a2de0817	default	generic	This changed everything	0.1	2026-04-26 12:07:48.845872
ad4254e6-5431-406e-9b5c-9b39eb9f13c8	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:48.845872
b91f43db-5ba9-49ad-9995-ed08d143a4c4	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:48.845872
b9b5976e-7771-48fb-8a1c-94dfa5a59a40	default	generic	This changed everything	0.1	2026-04-26 12:07:48.845872
31d579f5-f1a8-4da2-8199-de6a995cf31c	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:48.845872
b439b3ea-4074-4732-8e7f-c174ee1ec652	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:48.845872
3c075549-6a5a-4783-8be3-5f68a8ab0e51	default	generic	This changed everything	0.1	2026-04-26 12:07:48.845872
b14f4f05-f345-4e62-8b45-b0f24301ceef	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:48.845872
0ec7eb90-3c9c-42db-9d8c-6fdb887996f7	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:48.845872
3fedfc6f-db39-4f6d-a7f5-e4b414108977	default	generic	This works in 24 hours	0.1	2026-04-26 12:07:48.845872
f9f9d604-af10-47d6-99ac-6616b0d1de5a	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:48.845872
4911ddfb-d828-43e8-9f00-5c8c21f341e1	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:48.845872
1dedda19-c553-4bb5-882f-6e73c7e93993	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:48.845872
cfbe587a-3ad1-49b1-9a15-a89fb1658017	default	generic	Nobody talks about this	0.1	2026-04-26 12:07:48.845872
33a3d739-7a70-4aa4-9370-8aa954a3d771	default	generic	Hidden secret revealed	0.1	2026-04-26 12:07:48.845872
fc615712-c558-43d3-99f4-a49f7762dae7	default	generic	Stop wasting money on ads	0.1	2026-04-26 12:07:48.845872
b3ea44f2-765c-46ca-98d4-955c64196220	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:38.215103
fd2c7a30-70c2-4045-a1f1-2361dba1fad9	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:38.215103
1351fcc1-84e1-4541-a8e6-747c1a258b1c	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:38.215103
90def8d4-07c7-4935-9dcd-c66c4d93a4fb	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:38.215103
7bf0dcdd-2a42-4b53-a373-8c08d493a549	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:38.215103
509c09d3-7f21-47a1-96cd-02f8b85c71a8	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:38.215103
35f345e9-d7ba-4889-b0a2-ba16a6ed5efb	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:38.215103
59bb5d9b-9d56-4850-9fef-0bfea7a14f9d	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:38.215103
fadb8add-2998-4dfb-90b5-73cd64559ac1	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:38.215103
940657f8-245d-4b85-a724-3fe5710c13d7	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:38.215103
50a244c0-80f2-432f-8158-679f80d47cb4	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:38.215103
732cd02b-0b51-4e4b-9efe-128f3fe8bc12	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:38.215103
994da3c8-74e2-412a-8fbc-c6ea83e6a340	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:38.215103
83751a70-a8a7-4cbe-bbd2-1171084ec1d3	default	generic	This changed everything	0.1	2026-04-26 13:06:38.215103
05717858-5230-488e-a9d0-8f0bbd0161c1	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:38.215103
ba3772b6-410b-4f89-a5fd-0d949ebde1d4	default	generic	This changed everything	0.1	2026-04-26 13:06:38.215103
4a72a392-4101-4680-9b5a-d0fcc9fb1185	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:38.215103
a8b420fc-fed6-4bab-834f-f0272383e91a	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:38.215103
e2e9475b-9e10-49e2-a36f-6348a7604ea8	default	generic	This changed everything	0.1	2026-04-26 13:06:38.215103
79158bc3-ef83-498b-98ca-d81bceb58d71	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:38.215103
0bf72e55-5f02-473b-a631-7fc1109bc1aa	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:38.215103
5025f828-8412-4e8f-8ef8-057fe51d668a	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:38.215103
6634c7b7-e5c9-437c-aac6-f2609bb3f919	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:38.215103
65d70c98-f28f-424f-81cd-4484f5a3a039	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:38.215103
dfc64df7-3683-436b-a619-2704229fd25b	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:38.215103
0f8675db-7415-4481-a792-3e8025a7e850	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:38.215103
75b032a9-3de2-4266-ba06-f96e233b68f6	default	generic	This changed everything	0.1	2026-04-26 13:06:38.215103
6ee5fe4f-a8a7-4dbe-bbca-0d82803b3c88	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:38.215103
74692cf6-35c9-4a70-ab7d-74454025b88d	default	generic	This changed everything	0.1	2026-04-26 13:06:38.215103
cab17b3f-7742-4c8b-9e10-ba84bc7376d5	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:38.215103
dede71be-2951-48c3-80b4-1f4de1943a3b	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:38.215103
33cf56eb-ad5e-4945-a282-2cbb4cf85550	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:38.215103
89320f84-96fe-49eb-8f82-0b7c5b6d0c45	default	generic	This changed everything	0.1	2026-04-26 13:06:38.215103
7fd05bc9-9e2c-46b4-bb55-38c176d32d98	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:38.215103
625eaa70-9dfe-40e4-805a-ea8b6a5b3127	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:38.215103
56ad7a94-61ee-42c1-9722-9e8c284444a1	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:38.215103
ef662d3f-bc86-41f8-9fc9-a742b80fc903	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:38.215103
212daab4-43b2-4e37-afe1-bab5da41252f	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:38.215103
52e8ed8f-9335-4821-901b-4f8ae7d9854c	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:38.215103
eca64e48-a45a-4b53-9fea-fdebda771cb1	default	generic	This changed everything	0.1	2026-04-26 13:06:38.215103
d9ee1e38-859d-48f7-8b3a-3767296f5ddf	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:38.215103
011c6e56-927d-494b-993c-907712a73cff	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:38.215103
9e1c8b0b-f5cd-4f98-af8e-6eea98feb53f	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:38.215103
43555bac-0461-4673-b1df-022f0b00ff29	default	generic	This changed everything	0.1	2026-04-26 13:06:38.215103
85663096-0382-44b5-9315-8671e61cc533	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:38.215103
49b7b1ba-9b1f-42c7-90e6-dc591bbf301f	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:38.215103
9023f954-ae20-41d9-b047-ee1ec724b3b6	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:38.215103
4322dd2c-43de-43d4-8b5c-df5949d3c106	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:38.215103
dd87d7da-1e3b-4ecd-8d47-9aec2c268dd0	default	generic	This changed everything	0.1	2026-04-26 13:06:38.215103
88e32840-4e90-4326-a396-8f670d55accd	default	generic	This changed everything	0.1	2026-04-26 13:06:38.215103
432054ad-1eb8-4e02-a194-cdf1289743e7	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
ba42d380-1515-47ef-be19-90f1a6feb784	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
dc1597fc-81fe-4490-a22a-7012a76d9583	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:43.700789
66c925c0-4e7c-4474-ac20-8d4d67abfd03	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:43.700789
cbfd5cc5-22f2-431a-b385-d0efec02e629	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:43.700789
9a90186e-346e-46e9-ac61-19f1afcea5b2	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
c94fdb43-5b3f-4647-aef8-3552fb22c7ac	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
c80536dd-ba94-4cf7-9f02-54241c3ef20e	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:43.700789
6e56550d-5a3a-4eea-b77d-3745c087e26b	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
611201fb-cb10-4476-9146-b9a18302bd9f	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:43.700789
e4054330-6cd8-44f7-bca6-460d7f082fe8	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:43.700789
0c0554e7-c734-46d8-9a7d-39633c6bbf19	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:43.700789
04833b0c-139b-49b2-b85f-d25b6f79c882	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:43.700789
43426f47-2328-446a-9b3e-ebcc050dbd15	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:43.700789
afe9e12f-c6b5-4e00-8199-18477350c927	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:43.700789
b91379be-053a-4b13-8f66-62303faa311a	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
ecc1052d-c531-41cc-8516-fbfac0ecf4e7	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:43.700789
a5209898-ec8b-481f-8ee5-83ea369c9c8e	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:43.700789
8b5e9bba-8438-4caf-a9bd-18f709713be0	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
53159ba3-bdfe-4cb6-9174-fb85789b88d6	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:43.700789
8341af74-f97d-46ae-84f5-4d4909265736	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
985c499c-dea2-47a1-b915-a41f370c5a15	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
c8542142-d6ba-41ce-9f11-c94722529f70	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:43.700789
e6ae9d1d-c6c9-4259-8cce-c6d54d019da2	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:43.700789
0f2ed637-f72a-440f-b52b-c9bb281a7a25	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
0ab3de2e-abcd-457c-b644-4c8aac4e7d77	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:43.700789
394dfbf9-4114-403c-9b8f-0ecb98a142e2	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:43.700789
c651dd58-afb1-4b6f-929e-0269e1886ca1	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:43.700789
f30a47e4-6ab7-499c-9fb1-8bee08e7e271	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:43.700789
b3a5feaf-5522-4207-b07b-babad2e86034	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:43.700789
6a024920-7de6-4cad-8117-138c41f8c800	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:43.700789
a3283f5b-2fa8-4bc2-9711-c29aac5e0444	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:43.700789
6db9edfc-a6cd-4473-a403-426656a7a26f	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:43.700789
070107b8-2beb-4764-abef-d62624b83432	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
9d9acecf-064e-4986-aa87-44e8339e7b74	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:43.700789
4f8677e7-b3eb-4f51-a2f0-92375ee0458d	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:43.700789
5c9156bf-2b9a-4a50-b1d8-196465eb40f7	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
0f04cc83-1c74-42fc-872c-240bcfe6aff1	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:43.700789
d30ed2ac-2910-456d-91c4-7993d194210f	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:43.700789
ac6ede56-34d6-4bc2-a065-3683359eda85	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:43.700789
21de7bd9-e956-4c00-8cdf-cf2d2fa13cf2	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
d7d39bf5-ee50-45c7-864e-00c789e29fb9	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:43.700789
3abcf9f0-45b6-4250-884d-2fa729163a78	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:43.700789
71866903-66f4-43a9-ad7e-c7c8d5717cb3	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:43.700789
7798d7f3-fe01-4e04-84e0-6bc8c9d81516	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
2e9b2046-4d56-4bda-8ea0-042cfba9eac5	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:43.700789
98e68565-e341-46ad-a596-6947c106b97a	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:43.700789
44b607b9-ca72-4316-854c-cc07a41b0090	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:43.700789
6039078d-cd15-4135-9361-0368e97d672c	default	generic	This changed everything	0.1	2026-04-26 13:06:43.700789
db79b0e4-1ec5-41b1-a1f7-75882dae427e	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:43.700789
bf5819bb-2c50-4e6d-bbac-c971245f29a3	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:45.537772
225be0e8-9288-4e2d-8b43-359ed7103e9f	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:45.537772
abbbc53d-3131-46dd-983e-840537fafb88	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:45.537772
e4e04afa-9d4d-430c-83fe-63311c59e216	default	generic	This changed everything	0.1	2026-04-26 13:06:45.537772
359a1bf0-4ea2-4301-9dc9-e98b3b1dd243	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:45.537772
e6891b99-5a31-441c-bce7-bfc37917e75c	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:45.537772
4ff87823-6486-4d3f-b806-4102d37517df	default	generic	This changed everything	0.1	2026-04-26 13:06:45.537772
8e9409be-22bf-4a37-b388-a080e8c98ec1	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:45.537772
a9b15af0-091f-4180-bc24-5bb692a834e8	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:45.537772
2b085efb-9267-4167-ac43-e4845c6eb367	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:45.537772
2737c10e-049c-4127-8231-76fdcc8aa6e6	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:45.537772
79c5821a-dcf4-4fd2-a5d1-c1bf9aabb44b	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:45.537772
9d8e3908-6c26-4df1-b456-b28d53b220a2	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:45.537772
ff1617cc-04c1-484c-9326-712f50d51714	default	generic	This changed everything	0.1	2026-04-26 13:06:45.537772
28f0ac25-f8b4-4277-adbe-4211ab814a33	default	generic	This changed everything	0.1	2026-04-26 13:06:45.537772
04298b90-e28f-4f6e-835e-6a162af5aa55	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:45.537772
633f0796-3324-4a80-83e4-4ddfca8447ce	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:45.537772
e402d434-57ab-4540-804f-32dccccc69a3	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:45.537772
195a36b5-8215-4ff2-80d6-1a7b2fc7a7fb	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:45.537772
22788664-146a-4ae6-b4b2-ff4bff205e32	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:45.537772
1e5d1eb1-b01e-41b2-9a25-9e1d42b66747	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:45.537772
248495f0-958a-4d82-9c1c-47ef799a73a1	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:45.537772
7bfbc87b-9c9a-427d-8bec-7c2d12f614b7	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:45.537772
2639e61d-2ee6-4352-ac3d-d5b1ae04510a	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:45.537772
fe6e45cf-e124-45e8-bad1-1cf8243a342d	default	generic	This changed everything	0.1	2026-04-26 13:06:45.537772
63167fe6-96ce-4a4b-88a4-8e9ce137dbc0	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:45.537772
b25ca7f9-f765-46ec-b450-06667987ff97	default	generic	This changed everything	0.1	2026-04-26 13:06:45.537772
bf098096-4800-47cb-bdde-66ff63b14a7f	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:45.537772
45d73808-e7bf-44cd-bf9b-b489705e6195	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:45.537772
7fe66a43-d66a-4952-a12c-dbc3864ef406	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:45.537772
a8e7b839-665b-4f45-b857-9277e0a7a08f	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:45.537772
d542a951-d56d-48e2-a2e2-bfffa6eba9f7	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:06:45.537772
fff9d9b1-6c5c-4fb7-8d56-f21189eb6bea	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:45.537772
0be21f90-0e1b-4396-a182-3f0f5f2b81be	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:45.537772
33510c8a-6ffb-4c1f-b94e-aab1d4724523	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:45.537772
c953653b-1495-4bee-9317-b73a36153401	default	generic	This changed everything	0.1	2026-04-26 13:06:45.537772
c5fbac32-36e4-4015-af3f-09df33e4f436	default	generic	This changed everything	0.1	2026-04-26 13:06:45.537772
7fc442e0-0c4d-4eb2-b34d-43511dcddbac	default	generic	This changed everything	0.1	2026-04-26 13:06:45.537772
fb11957b-4a6b-472b-bbe4-8cfc036e2194	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:45.537772
1817c023-4941-4547-8ecc-21165ea85429	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:45.537772
ae1ada35-853e-4757-a4dd-47237d2ca675	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:45.537772
c07670ff-b261-4045-b8c8-df14378adf7a	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:45.537772
37d4b89c-440a-4b48-91fe-604c9fe39097	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:45.537772
75563f70-5612-40b5-84c2-f05ce9e801b7	default	generic	This changed everything	0.1	2026-04-26 13:06:45.537772
4cb18c03-93f2-42f6-a0f8-06bbf5217f39	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:45.537772
72d3277e-93fb-4a49-9ba6-6b6a731a09c4	default	generic	This changed everything	0.1	2026-04-26 13:06:45.537772
6cb11380-0f40-48fa-8549-515eb03020a8	default	generic	Nobody talks about this	0.1	2026-04-26 13:06:45.537772
bc4f974d-e433-4467-946f-4f4f30ff75d5	default	generic	This works in 24 hours	0.1	2026-04-26 13:06:45.537772
bd213b53-a598-4bf7-9a8a-8cf23ed581d0	default	generic	This changed everything	0.1	2026-04-26 13:06:45.537772
543bdb20-7612-42a4-be22-968667da279b	default	generic	Hidden secret revealed	0.1	2026-04-26 13:06:45.537772
37c8e627-0729-4251-8f8f-e6a6c6864d83	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
67c66b14-cd71-4eb8-9f7b-d2f81c036a4b	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:51.013922
7638745c-7351-40d3-bb1e-2d9d0e89e6b8	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:51.013922
20e1dcb5-2e78-4d66-99b1-edb3531e24cc	default	generic	This changed everything	0.1	2026-04-26 13:17:51.013922
ce5b5e8b-050f-49f9-a8d6-ad422e6188f4	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
d3770319-90eb-4821-816a-3216fca48c42	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
44a4f089-d37f-4ad2-8015-daad4969bcae	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:51.013922
ede6aa08-f620-4146-b96b-7ff8db526ff4	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:51.013922
5d0bd4be-df2a-4e27-a105-bb9ecf2da99b	default	generic	This changed everything	0.1	2026-04-26 13:17:51.013922
ddf0a8b4-2bc2-4d01-ac0d-03bf2613401d	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:51.013922
b2d42c3d-14b7-4a99-aca5-c432eca58f36	default	generic	This changed everything	0.1	2026-04-26 13:17:51.013922
d559c341-8ff8-4885-880b-7cb9a6bfa764	default	generic	This changed everything	0.1	2026-04-26 13:17:51.013922
42753632-d6fe-43cd-9807-8e4e5de6c763	default	generic	This changed everything	0.1	2026-04-26 13:17:51.013922
f1492b08-1901-4158-bbd1-25733da1ab98	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
bed7591d-790c-400e-ab74-d0d56e1ddaeb	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
34819555-9a21-44be-aaf4-43658e841ee1	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:51.013922
4a756b11-5bf0-41ba-81af-bdd6ee4c4f16	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:51.013922
e9413f3c-5430-477b-93c9-b0740895cfcb	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:51.013922
15fa1308-cbc7-48d5-9d03-34c621bb843c	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:51.013922
3704e3fc-69ff-4585-9e5d-e2e5ef37831b	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:51.013922
3c193676-8b6b-4b93-8271-a11640d9aeb0	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:51.013922
adf3c5ff-d83e-4829-8e19-da977ea61ad1	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:51.013922
035faaad-e6dc-46df-a294-0b443a6838bc	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
203228df-face-4a50-955d-d413107ac88e	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:51.013922
1afe2e35-a153-49b2-b7a1-ae87e9394b03	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:51.013922
3096896a-002e-451d-82b1-965b591c2427	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:51.013922
f291a986-879c-4a49-9f7a-6d32394a6898	default	generic	This changed everything	0.1	2026-04-26 13:17:51.013922
6e692fdf-3d65-45bf-adf7-3d3e4de9eba9	default	generic	This changed everything	0.1	2026-04-26 13:17:51.013922
d5b11e8f-2123-42f1-b458-63eac78e2801	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:51.013922
0e785a76-0b7b-4fb8-b6be-73a5c9c2527b	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
0c60d0fd-6be8-4241-a138-af5bf93aab4b	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:51.013922
d734ab4f-4e3e-47d2-ad6b-7d3e48de1633	default	generic	This changed everything	0.1	2026-04-26 13:17:51.013922
cdb6d091-aef6-4e58-ac5e-6e5bc25be312	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:51.013922
1f410feb-464f-4046-958c-22d2715178f9	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:51.013922
a384a10e-d660-45a7-81d3-3c64c450785d	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
dcde0f84-5b3a-4e7d-9889-09841ec82b71	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
2b7520f2-1c7a-4811-b501-84b9680401aa	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:51.013922
9cd9f23b-4cdb-4164-955b-efe2f3b1f732	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
499c3f7a-ad89-4a83-af64-29e0e317a35b	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
c72a6a89-8b65-482f-9b1f-643a91dd0b9b	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:51.013922
8f6c7fbc-a8c8-4c6f-b677-4dc06d878b25	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:51.013922
4496f830-88eb-4ea4-bdf7-cdc345d038d9	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:51.013922
17e97042-5dee-40af-af49-a8f5c6cec8c6	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:51.013922
91359c44-31f5-4786-b481-34d8a3e44b7a	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:51.013922
9ffc2cba-2a1d-40ae-bdd1-f55d22934b60	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
6382276b-752b-4c58-8876-b933fbb55a7a	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
522a4beb-3e48-4bf1-8d10-1bd82466b0a3	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
110a6dc4-78a2-427c-b46e-39c2213ea170	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:51.013922
615c2528-a65f-4ad0-8261-4041744a54ed	default	generic	This changed everything	0.1	2026-04-26 13:17:51.013922
31762a31-384b-477d-9ec6-3cea15004a4d	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:51.013922
8e87ea9c-475c-44e2-b50f-add2477201e5	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:52.834004
060d90e2-52d3-445f-a786-1b97ccb59aa9	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:52.834004
bd0c012f-f134-4eea-bb56-d578ff84d8b6	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:52.834004
7f1dd182-2dab-4289-8f7b-2bf47151569a	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:52.834004
e3d2b48e-2421-48a9-baa3-a4b64eb945cf	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
d438e056-4730-4db8-838d-169ba53afb54	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:52.834004
09f71655-acfe-458c-a422-c3823f1a2e07	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
60a2a8cc-0444-4e1f-96a4-937adb6f8e41	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:52.834004
4d976152-62d9-4c25-ab6b-959b0ff22940	default	generic	This changed everything	0.1	2026-04-26 13:17:52.834004
6d85489c-bfe6-4d03-ab26-2b5065781e7a	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
9abea42b-7b73-413f-837b-21ef2780bc1b	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:52.834004
0e51fb46-108d-4a73-8cd7-629af7b4834e	default	generic	This changed everything	0.1	2026-04-26 13:17:52.834004
c46ba984-c45e-4c7f-bb56-13b2675d47ce	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
bdf0d38f-826f-4ad8-9428-da655fa0817d	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:52.834004
8ae39fb3-d1d8-46e9-925f-0817ce330743	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
9bb3e273-f614-4930-908a-c08448f13e3e	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
abb14285-5aff-4824-9d3c-ed1993810c7d	default	generic	This changed everything	0.1	2026-04-26 13:17:52.834004
dc4cb844-a900-40bf-a552-7f8347db8c9e	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:52.834004
47c73373-e945-4c91-86a6-037ddac0d750	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
4293abaf-3e45-48a9-86f6-6c85f40d6465	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
943a19fe-ceea-4138-8408-d21fc0b0f768	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:52.834004
eb414c3c-db4d-4f5f-aef6-08aabc9e1c38	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:52.834004
8fe0681b-7371-4553-a06a-e0fb9ba49513	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
b9ffff9e-b7f6-4646-b924-13be10daa320	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
05176b3e-1566-4182-a41b-b2cdd7c1456c	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
a8c9503c-2b01-412f-a599-29a686ed11fe	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:52.834004
31514682-b5da-4ed0-a472-569408db9175	default	generic	This changed everything	0.1	2026-04-26 13:17:52.834004
894c6a15-d66e-45d3-894e-238e8a272608	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:52.834004
156ddad0-1b05-4c7b-99e2-4fe2532d2e1c	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
3210f08e-78e8-4fec-b1d1-d4f715445a80	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:52.834004
32a7418f-f0a8-4b68-93de-3ea2744d0176	default	generic	This changed everything	0.1	2026-04-26 13:17:52.834004
ef5c15b6-3739-4205-b2cd-9d729671de87	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:52.834004
b2169600-b6dd-479b-a270-c7bfe39d0e07	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:52.834004
f553abc1-738e-4fc9-83ad-04956d1ff61f	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
4ab73db2-3165-4f6b-8103-261cc957d90f	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
5f773760-1201-4849-a364-f5eb39e1b185	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:52.834004
72ee8e20-4d3f-42c7-8a13-0aa83d5aff9d	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:52.834004
67ee3be8-4712-4f57-babc-0d5de82fc53d	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:52.834004
2893ab2c-0d60-42ab-b9ed-aac77050d920	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:52.834004
1b8557fe-ba33-4439-b188-bcddfec320e9	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:52.834004
0d900c3c-2717-4988-8ed9-77b4ab9b9c70	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:52.834004
c32d7303-ddab-4532-9389-f908517705dd	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:52.834004
a256c6f6-69c0-4b3c-a7e1-9afa1de77501	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:52.834004
c248d4c8-91ca-4463-856b-e2efd5980810	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
5fb21564-d722-4504-87b0-0009c9e03da7	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:52.834004
6bf0ed13-31bc-4ced-bac5-b87ff86b5b65	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:52.834004
b55358b0-6949-4f0c-bb53-0b099866fea9	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:52.834004
678235e9-4782-4720-aedb-67b13c4e6fed	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
50a70d27-4883-40af-8fbd-92dfbe59404a	default	generic	This changed everything	0.1	2026-04-26 13:17:52.834004
74e086cc-ae42-4871-aefb-e66757b07a5a	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:52.834004
7a57f64c-cb2c-4e13-a719-467b7bcdb2fe	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:54.64816
94f07196-2acf-4783-8d8d-b4674f675d4b	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:54.64816
02e682f9-0c2a-4a64-a56f-5ff31e0761d0	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:54.64816
14a03c35-8f5b-426a-869c-5205f666d1a1	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:54.64816
3d80c3b7-9cc4-47d9-8449-2ed5c9c5a33f	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:54.64816
95b3f013-7ae0-46f7-862e-3491cd00aadd	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:54.64816
5e305f8f-43e9-49bb-8869-335eea031356	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:54.64816
516a27d9-6540-49ca-8e45-469e4d53e01f	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:54.64816
8efe7416-fa08-4c38-a392-8fef35d8513c	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:54.64816
e79b692c-d1e2-4630-8769-0d9f1e5711e8	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:54.64816
794c6bf4-097b-4406-9baf-205ef08b301a	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:54.64816
e1d41289-442b-40db-95d7-48236256bb5e	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:54.64816
2349bbca-20ad-4e6c-8edc-766d5ea468c5	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:54.64816
cc4c14e2-b32c-4f3c-bbbc-490f49af754a	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:54.64816
ca9417c1-cbfa-44fb-a623-dc8743a6585d	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:54.64816
55195eb7-d7ef-4d66-a9bc-b235bd6ad73f	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:54.64816
789b3b55-e678-40c3-b081-c0231a40ae6d	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:54.64816
62ff11f9-2327-4c79-ae4a-7c6364594316	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:54.64816
802acef1-e12b-4d59-a8f1-ad80ff6b2d13	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:54.64816
051a4725-39d8-4e23-82fc-ed3423fb0883	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:54.64816
2cd766cc-ce3f-4b18-b79f-6b1eed1850b0	default	generic	This changed everything	0.1	2026-04-26 13:17:54.64816
9569c37f-feca-4a14-921a-f88445fda093	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:54.64816
2ce36843-d48c-4026-b2c4-b84ed42943cc	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:54.64816
20481dad-727b-4064-8377-6531cc1ed296	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:54.64816
26007644-b0bc-4d19-857d-532579a03b73	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:54.64816
efc96ed1-6bfc-4789-ba64-aed722edefa4	default	generic	This changed everything	0.1	2026-04-26 13:17:54.64816
873ab3ef-e512-47a0-b9f3-b07226f72b97	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:54.64816
aaca269d-3a2f-43f6-adce-876b518968ad	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:54.64816
23f93e33-eed9-4e0d-9ac0-f3ee7860af67	default	generic	This changed everything	0.1	2026-04-26 13:17:54.64816
6b6795a5-475a-4a01-943f-41edd120d21b	default	generic	This changed everything	0.1	2026-04-26 13:17:54.64816
892fe7b1-b6c1-449a-9dab-c8b9ed381286	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:54.64816
ee3f5b2a-767f-4b98-85e8-b71f38ef5e81	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:54.64816
26968aa5-21f8-433b-b58a-8af36d3dea28	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:54.64816
6bf6ca80-2935-453e-8afe-6613097828d9	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:54.64816
003093dd-e1ff-433f-a43b-9e4f4a317a46	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:54.64816
ca2f998b-eb84-4996-b487-36cb50b9de00	default	generic	This changed everything	0.1	2026-04-26 13:17:54.64816
3158065c-12fc-4056-b7fa-51bbc83bda96	default	generic	This changed everything	0.1	2026-04-26 13:17:54.64816
27c12452-61bc-4eb1-bae5-e25d7d18c189	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:54.64816
1ae310b6-8008-4fc2-94d5-883a75d0bafb	default	generic	This changed everything	0.1	2026-04-26 13:17:54.64816
715741e2-79dd-44bc-84fc-19678d41f89f	default	generic	This changed everything	0.1	2026-04-26 13:17:54.64816
525d81ef-41fc-4000-8a33-7b3720351a7c	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:54.64816
5454e53d-7b7e-4224-a761-b9b37fbf9028	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:54.64816
1a61cc39-90a5-4c4d-9270-4fe0fd1b0429	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:54.64816
dd4215e0-1f87-488f-99ef-377efef77d5d	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:54.64816
e2253393-6f7d-4ce6-94d6-3732b2094bc8	default	generic	This changed everything	0.1	2026-04-26 13:17:54.64816
270f4f14-1eb5-4467-a039-33e93742ae55	default	generic	This changed everything	0.1	2026-04-26 13:17:54.64816
9d5d3119-a3b6-4e06-9e2a-1059d0fc5db0	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:54.64816
f8381a5e-8d7e-47bb-b28f-a0229b6b6989	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:54.64816
2f6909e2-64dd-4163-b451-4bcafebd958e	default	generic	This changed everything	0.1	2026-04-26 13:17:54.64816
2aec4528-5e17-4b69-919d-9a03a4f5ea0c	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:54.64816
6eecb6ac-c93a-40f8-bc3f-21464c613902	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:56.452692
21d0709b-4c0b-424c-864f-e81432763d0d	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:56.452692
c76d5a27-301f-4f63-8b83-9b2a439a32e7	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:56.452692
a02f8346-1d57-48aa-871e-80dc28191a1f	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:56.452692
85787ab5-3dcb-4a6a-b637-c4a369dd0808	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:56.452692
e87fbb77-1346-45d9-a25c-891bc968b2f1	default	generic	This changed everything	0.1	2026-04-26 13:17:56.452692
46f14546-6eb4-47d4-a520-22122d218daf	default	generic	This changed everything	0.1	2026-04-26 13:17:56.452692
6dcff7a3-ba59-440e-b702-18c6d2de3ebd	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:56.452692
f6a0176f-0c5e-4b7a-96d3-51e1ba726c44	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:56.452692
d6d50c92-c722-4046-beda-8962fbcb73ad	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:56.452692
83029a4b-8670-464b-bbcc-e0b3774ef46a	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:56.452692
173f66a2-35a6-4e98-a073-8d4b8d91f848	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:56.452692
5845fe3e-6260-4c62-8c06-42e464085786	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:56.452692
c5a47702-5bb7-4059-a820-6e1827cd6084	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:56.452692
44189a29-7300-4184-9422-5382fd52af46	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:56.452692
74d76057-ab70-4dec-8747-d19c916b216b	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:56.452692
eca3f336-30a2-431d-819a-59fcd119e213	default	generic	This changed everything	0.1	2026-04-26 13:17:56.452692
1f809f48-fc2d-4259-a118-9459270e2e21	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:56.452692
17829918-70ee-4db3-8670-14dc7d1f281c	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:56.452692
d0d4ce31-2b57-4a87-86f0-b6bf588f2165	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:56.452692
3ce122a5-e190-4b66-bf02-050343172a33	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:56.452692
ebdb5505-1b31-46be-8956-e7d7d4f4ca22	default	generic	This changed everything	0.1	2026-04-26 13:17:56.452692
2fdea06d-e712-4138-b6ed-e78777abb072	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:56.452692
82960b6b-90e8-45ea-afb5-88bf6ce54471	default	generic	This changed everything	0.1	2026-04-26 13:17:56.452692
15adb4ea-04a1-4268-9971-256e93e7b361	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:56.452692
4f7b9c53-b07f-4b64-aa9d-0923e54486f9	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:56.452692
f3f65c73-522e-42b7-861c-b3719c409531	default	generic	This changed everything	0.1	2026-04-26 13:17:56.452692
b9875ab8-e445-4797-87b8-fd66219d6e9f	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:56.452692
03fc328f-2a97-4dee-8311-14478002befa	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:56.452692
0db08b29-4bf5-4d05-8cda-5fe07096627e	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:56.452692
d90a26f1-483e-4ebd-ae6a-d65882faebef	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:56.452692
e923fa38-c191-48a5-bea5-116101a88c48	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:56.452692
c98bb7fc-c456-410e-b489-829a554db8a7	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:56.452692
91abba0c-3c03-4efd-8106-537a7e340307	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:56.452692
8ac959e1-e0b4-442b-9cce-310a3dd545dc	default	generic	This changed everything	0.1	2026-04-26 13:17:56.452692
1f8ffe3a-41d8-44cb-ba13-6d95be9aa848	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:56.452692
51eee86e-f058-47b4-8bbf-ad75fcd0e128	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:56.452692
9f273c6f-0099-4394-8f9d-635d99ee19e3	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:56.452692
cdaca359-0f73-4215-bd0e-e15e587913b1	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:56.452692
80869c53-6edf-4efb-879b-34e7d8cf73d4	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:56.452692
e3b3c1a2-7406-4272-b185-7a75941f04ea	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:56.452692
999e86f8-f33c-4a0c-bc27-0fa742799ae3	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:56.452692
7d1a051f-51e9-4b72-8e5b-f8caef1dd98c	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:56.452692
a7be07d7-63c0-48eb-b6b4-a53f9f770374	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:56.452692
ffc6c94c-cf02-4258-92aa-ffb82c01dac3	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:56.452692
4b02474f-e2e4-449c-835a-3075e91c9fb0	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:56.452692
b4ead2ec-042f-449d-9e76-3d164b11f069	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:56.452692
53170c5e-51f7-4bc4-8da7-01ed0950ebb2	default	generic	This changed everything	0.1	2026-04-26 13:17:56.452692
c0839551-8aab-43ac-83d8-e34612fa29b1	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:56.452692
3fde77e1-6270-4f07-a6f9-f6bf70731dad	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:56.452692
b44f25d4-24a1-4d9b-b5be-4d892991fac9	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:58.301979
154c8d27-72d9-455a-9a73-588303794837	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:58.301979
25d44daa-6ef2-4b24-90b1-9c16e8f9758e	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:58.301979
78d0582f-93e8-4949-9dac-28644c4eb081	default	generic	This changed everything	0.1	2026-04-26 13:17:58.301979
70de4349-1b45-4457-ba6e-be2afb685b8c	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:58.301979
5ba37c68-3c22-4467-9085-67660556722c	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:58.301979
c97a91bb-57a6-4bf0-9661-f8b7ab918be7	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:58.301979
63abd579-bc0e-40f1-a4b7-4037108d3b5e	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:58.301979
d3ded896-cd9a-493d-9c7c-39e7f73f6683	default	generic	This changed everything	0.1	2026-04-26 13:17:58.301979
ad27536d-beee-41b4-b192-edbdb04d3dc1	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:58.301979
b3ef083e-fdf7-4b32-8a39-1027fdc216ec	default	generic	This changed everything	0.1	2026-04-26 13:17:58.301979
9dae8275-1143-47bc-b359-e49af44c7560	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:58.301979
f9ae4291-26ba-4540-b5ef-4e8bf79cbfd9	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:58.301979
4caba5b1-2bff-47c3-9b2c-edc80a7c91ae	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:58.301979
a4232da6-9f03-45c8-9c8c-96d6152aac62	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:58.301979
9f8fca00-8e11-4ad8-9da4-06a534c2e539	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:58.301979
d6b8cfc3-d4b0-4951-b3ae-62888b9aee81	default	generic	This changed everything	0.1	2026-04-26 13:17:58.301979
2c6241b5-fe4b-4f34-b32b-99682d2d8174	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:58.301979
fb0a34d6-6956-484f-89c9-ae40e21a5b74	default	generic	This changed everything	0.1	2026-04-26 13:17:58.301979
6c1730f2-402c-485f-bf6b-aa7f4e3db485	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:58.301979
19cd02ce-f057-4d21-937a-a90a84d25d63	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:58.301979
1c934c99-2fb7-49f6-96fc-9d48bf559937	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:58.301979
9092e34d-66e4-451c-9bc3-89eb9fad226f	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:58.301979
3cd4c0cd-aaea-4a1d-ab5f-b807b621b0d1	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:58.301979
a44da0fe-3ee0-4171-9388-ea01d0b8eb48	default	generic	This changed everything	0.1	2026-04-26 13:17:58.301979
1eac8930-82ac-41bb-8e9d-f7e59f69ce44	default	generic	This changed everything	0.1	2026-04-26 13:17:58.301979
1fd6d236-69a1-4e03-996d-e17b44095ef4	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:58.301979
374abd6f-e1cc-48ba-ba37-21d3a33e6dcf	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:58.301979
2f7e78fc-64b7-4a25-aa9c-c5d4b7ba5882	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:58.301979
5ca53343-a76c-45d6-93fb-3a76dd23b08a	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:58.301979
1f8c19f6-319b-4b4a-9741-096c060ff0f2	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:58.301979
8405462c-69f9-46b8-b45a-28d6c58b5cc9	default	generic	This changed everything	0.1	2026-04-26 13:17:58.301979
597b7bda-c99f-4dd6-a11d-b18638b67a4f	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:58.301979
375f9a76-57fe-4631-af5e-b1ac9d76e1ac	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:58.301979
0715083e-a718-45f4-ab60-dc0beba1ecd9	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:58.301979
966cf1d6-874c-4956-93bd-57bea2c29791	default	generic	This changed everything	0.1	2026-04-26 13:17:58.301979
f40160a7-8457-4714-9ade-25c37b02a1c7	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:58.301979
9d1a8c6f-8e43-4139-90e4-af1ef0bb6031	default	generic	This changed everything	0.1	2026-04-26 13:17:58.301979
f3d63102-5c4f-43e0-be31-bdf91e068ad5	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:58.301979
1ad38af2-7147-4393-a6e8-a795cde8e313	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:58.301979
7b87a972-c8d1-4807-84fa-6ae0edd53b1c	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:58.301979
5a62d957-7fbb-4915-915b-a2f77afe1684	default	generic	This changed everything	0.1	2026-04-26 13:17:58.301979
e2cfb472-ff17-4e59-b943-ab923f51e796	default	generic	This works in 24 hours	0.1	2026-04-26 13:17:58.301979
5d50cbae-1142-4038-956d-ed01079be5e1	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:58.301979
17c210d5-104b-457a-979c-da5255f7a9b4	default	generic	This changed everything	0.1	2026-04-26 13:17:58.301979
4abff28f-6cfc-4aba-8299-c7ed36f97a22	default	generic	Nobody talks about this	0.1	2026-04-26 13:17:58.301979
21526e0b-65de-4b58-8d87-4e7a360a09fb	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:58.301979
b362624b-f546-4adc-ac59-e70dc9e193c4	default	generic	Stop wasting money on ads	0.1	2026-04-26 13:17:58.301979
11ea6416-2a0e-403d-b4c4-0384b8d51ab4	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:58.301979
485dcbf8-91f3-4632-8f47-8fcc1226b628	default	generic	Hidden secret revealed	0.1	2026-04-26 13:17:58.301979
9a3c7471-62bb-49a5-9898-6b6fdfac89d1	default	generic	This changed everything	0.1	2026-04-26 17:46:18.834365
48a767eb-36bb-41b0-a492-5a0d2d4411f8	default	generic	This changed everything	0.1	2026-04-26 17:46:18.834365
dadea0c2-3505-4aec-9694-b7a65971e029	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:18.834365
6e6b18ab-9052-4194-847d-b4fe179bcb96	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:18.834365
1a5ea328-c08a-41b3-9d72-6c67bc3ae5e1	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:18.834365
e1fcff15-b0e4-42ff-b67d-386ecbcb010e	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:18.834365
8da06662-9998-4bf4-94dc-2c72713dd9f2	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:18.834365
de86346a-da32-4c1c-8114-48e5d032ee0e	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:18.834365
b32aa581-f52b-447c-bb5e-0a802984c2a0	default	generic	This changed everything	0.1	2026-04-26 17:46:18.834365
65e3c0d5-ad0f-4a36-aa21-044671aab2fe	default	generic	This changed everything	0.1	2026-04-26 17:46:18.834365
22eaad28-792b-4faa-88b1-ec059aa7988f	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:18.834365
631ca221-1cf2-4829-99de-f29639c1d68c	default	generic	This changed everything	0.1	2026-04-26 17:46:18.834365
0df869bd-0ccb-4f40-8820-d1032ae30ec9	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:18.834365
05d12366-ba8b-438f-809e-240a5ae54d2b	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:18.834365
cdba6791-74ed-4f10-9552-32454da1d3aa	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:18.834365
7f66ab77-4250-4c6b-85d2-c8c7685ddfda	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:18.834365
743b4e85-92d1-4355-8e9c-73a2f3bd762f	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:18.834365
64224113-3069-4b52-86ae-445ae8bbe1be	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:18.834365
22c91ab3-6c17-4096-8cd8-709d3d7d748f	default	generic	This changed everything	0.1	2026-04-26 17:46:18.834365
addfe86e-d4b2-43fb-b54c-6380bbc78c23	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:18.834365
eabb6fef-ccbc-4306-b792-e301f065055c	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:18.834365
3e083a22-ba27-4290-9655-58e13a5b5bf2	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:18.834365
d404d47e-8343-457f-bff3-90a32ad5a25e	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:18.834365
845fe922-6b51-4220-a8f0-9a67cae47748	default	generic	This changed everything	0.1	2026-04-26 17:46:18.834365
71fe7b9a-9462-48eb-b627-17ba8cdd5b6a	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:18.834365
d5fac92d-b99a-451a-be98-f11999866ef0	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:18.834365
db7a9f36-791e-477d-b563-ad98a4676490	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:18.834365
a09e64e8-f5d5-4117-a940-d32ee4f57582	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:18.834365
f5c9940d-28d7-4403-b5e7-5825f7eab62d	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:18.834365
3b92e89b-7f8a-4130-be86-0addb35137fa	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:18.834365
ee49090a-dd67-424e-b4bb-a365781e48d3	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:18.834365
1db04811-c4df-45fc-b636-c3bfb4a2e2c0	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:18.834365
7ba62e93-f93e-49d4-ad0c-8c57805c4d6e	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:18.834365
22589a2f-0d49-498c-897c-2dbe69b4b6a2	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:18.834365
19bb7cab-333d-43c3-9640-4efa0b349e9e	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:18.834365
401909fd-3edd-43b9-9b11-fe4c45372589	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:18.834365
49663f8a-0599-4b54-b043-6b9e8c212068	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:18.834365
a6c01831-3841-4032-8b95-ec47d679170e	default	generic	This changed everything	0.1	2026-04-26 17:46:18.834365
ff6161c2-55c7-49aa-afca-e45de30d892c	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:18.834365
86433da6-15a2-43e3-80e3-8950b6570fd2	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:18.834365
4402c620-74ea-4334-8472-ca67ff606675	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:18.834365
352fc1c3-ff31-4cb5-96f1-a86c3f2e6103	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:18.834365
e97a3204-643e-4258-80de-fc3dcd7dcf92	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:18.834365
72498df8-6078-45fe-98c2-8d41d6a454e5	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:18.834365
b889058e-f6b9-4d3f-a68c-279c243834b6	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:18.834365
dc60a27b-aa8b-434d-b293-32a43931d8e5	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:18.834365
a7c7d02b-2ff3-44dd-9442-a633327b211b	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:18.834365
de305429-b1ae-4885-b2af-0fe42ed5cd18	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:18.834365
5c00b0a0-2f23-4d20-9af3-cd54a68c2488	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:18.834365
86e2c317-4a03-4185-9463-b91539d265fd	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:18.834365
6f13a794-4f72-4f89-9ab6-4937d718d4c5	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:21.59546
dfa90ccd-b439-4544-b862-3eaff05572b2	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:21.59546
707cfc93-e43e-4e5e-8cad-f8dcdbc44fb0	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:21.59546
4ee7b758-190a-4d8c-b724-0be3f53f730d	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:21.59546
0c20eafc-bc56-440c-8c81-1add23f1b50b	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:21.59546
5694b17b-3b11-4a87-931a-99bc7479aee4	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:21.59546
596b2c45-92b7-43d7-987b-318c14b616a7	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:21.59546
b8c09ca6-a054-436a-bcb3-cd562360bf3f	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:21.59546
61725bd6-3a60-40b0-bdf0-a307a466e1e7	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:21.59546
7abd12e6-1d72-43bd-8593-360c534aedde	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:21.59546
8d1ba123-aca7-4913-b368-0c81ef3a3ea6	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:21.59546
48f940c7-eeb4-40a9-9c64-72fbdab1dc91	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:21.59546
08fef210-b96c-4e0f-80cb-83c9e4fe8355	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:21.59546
06ddc7a3-bbe4-4ecb-a008-a1f9ec5891bb	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:21.59546
71f74e0d-34db-4eab-b910-de45e26604a1	default	generic	This changed everything	0.1	2026-04-26 17:46:21.59546
323ff259-1640-45c6-8b55-2f6fc6b97649	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:21.59546
81eda853-6cd8-4c3c-862f-cf39e0515f57	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:21.59546
d22b31a0-f7df-4f7f-a6c2-00217bc5ebac	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:21.59546
b6601b5b-7c7b-4d51-b741-d054cf6a539f	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:21.59546
68dad62b-6c98-452a-a9a5-be5f0b73e6b0	default	generic	This changed everything	0.1	2026-04-26 17:46:21.59546
6b24313d-7d61-43a6-80f5-be140fd427e0	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:21.59546
c9098151-3938-4ad7-9330-703a59d975c3	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:21.59546
e6ae10cf-7f45-47c0-ad63-26cf2f928112	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:21.59546
0eb1fa9b-2cc0-4448-9c8f-4429f5e9b24e	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:21.59546
65ae23e9-c696-416a-8051-8f4e4a02afcc	default	generic	This changed everything	0.1	2026-04-26 17:46:21.59546
464b4abb-27d0-4bd9-b95a-1e005e7e4cef	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:21.59546
87055eb4-996a-4a66-9709-025395f5ff9b	default	generic	This changed everything	0.1	2026-04-26 17:46:21.59546
bed35460-686d-4eae-ad25-92380d30a902	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:21.59546
b0f78005-34d5-45f3-919c-6b462505efd4	default	generic	This changed everything	0.1	2026-04-26 17:46:21.59546
18f7a876-78f5-4adf-a934-c7ad85056509	default	generic	This changed everything	0.1	2026-04-26 17:46:21.59546
71cfba7e-e7ed-4618-b61f-1bb34aed9640	default	generic	This changed everything	0.1	2026-04-26 17:46:21.59546
7d58163e-a63c-4215-9da6-3d504b002a4c	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:21.59546
d2e8dd62-e602-4e52-bd20-297492a1621e	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:21.59546
4ed0d007-dd09-4470-a3fd-d7d570432b71	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:21.59546
c8701c80-72be-473f-8c6e-6680bf856717	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:21.59546
d162e653-9a09-45a8-872d-79b2f351239f	default	generic	This changed everything	0.1	2026-04-26 17:46:21.59546
e14cc8d6-389b-4338-9e44-d9e7be85fd96	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:21.59546
87f04729-5c7d-4a12-bac5-9c0a7825f107	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:21.59546
5931b82d-605a-49d9-a8ce-a60fd5b35a56	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:21.59546
4a063bc9-0515-47b8-9d47-240b9c983e4e	default	generic	This changed everything	0.1	2026-04-26 17:46:21.59546
07f419cd-dfb9-414a-b6f8-d94155049630	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:21.59546
dafae156-4b2e-4fbd-8dbf-a073dbcb17ca	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:21.59546
1f00511a-2c6b-4a2d-aa4c-0a84e0cd8340	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:21.59546
39de75c9-ebc9-4962-b3a7-9c7efb1ee6b4	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:21.59546
2bfd2e20-a2d5-4115-b074-9d7b90db4736	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:21.59546
e49fe948-2e8a-4247-ad7d-fbd2cd567f75	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:21.59546
efd777eb-05d1-49e0-91c9-2634b1c25909	default	generic	This changed everything	0.1	2026-04-26 17:46:21.59546
05cd063e-eca2-46c2-9352-40efbf7e28cb	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:21.59546
a766c69c-4100-4712-af09-4f0d14c844fe	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:21.59546
8672a7e2-96d1-4feb-8af6-7f264badbb79	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:21.59546
f81a5c95-c755-4857-ad4b-17962656b9dd	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:24.425479
0818653e-a60e-414a-98c9-218fdb6612f5	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:24.425479
a11c286b-65ed-45dc-b6f5-6f0f9d4d651d	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:24.425479
19519809-b8c3-437b-a335-2f38de965358	default	generic	This changed everything	0.1	2026-04-26 17:46:24.425479
a8dfe3af-2b5b-4c15-bb64-876cc6354fa2	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:24.425479
fc361954-66cc-44f3-b5b5-1104d1823bba	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:24.425479
45a7790e-6071-4ccd-b74e-54498b7c38f3	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:24.425479
86e3c22d-7655-481e-885e-190054604c6b	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:24.425479
badee154-dcef-4d11-9ca8-655ec6d0e15c	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:24.425479
c3bb921d-659d-45f2-bc05-287af331fc06	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:24.425479
30269f7f-8b91-457f-827e-e11c016ac070	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:24.425479
f61c1088-cfa7-42f4-9db7-f7dbfd641e1e	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:24.425479
67f91fac-2287-421c-8300-0d2e9633caf4	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:24.425479
11357389-cf93-4ea0-a13d-cf28ffbca744	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:24.425479
b3cca4fd-1fef-477a-9d18-7fb75884aa82	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:24.425479
3e14f5ec-b065-4185-85d9-997348fee2fe	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:24.425479
4daa356c-5620-4134-98ed-837f25cb7dc1	default	generic	This changed everything	0.1	2026-04-26 17:46:24.425479
ca4e9545-23e2-4ada-9cf4-7ccc1ccdf977	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:24.425479
12f8867c-4c34-4afc-b48e-a92402fe5f28	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:24.425479
8004d987-d3e1-4464-8036-b1e275c559b2	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:24.425479
4fbde878-f29d-4a0c-b854-3366134f85a7	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:24.425479
581ccb1b-0e74-422a-9d6a-06e57728413b	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:24.425479
9dd4dd4a-587b-42b3-9dec-19db9e9e488a	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:24.425479
7792cbe7-262c-47ee-ab9c-343e38dc5c47	default	generic	This changed everything	0.1	2026-04-26 17:46:24.425479
d45bb645-8df7-40d4-becb-412ae76eb6fa	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:24.425479
b1160430-2300-44b5-aa64-2ae6eadf97b2	default	generic	This changed everything	0.1	2026-04-26 17:46:24.425479
03c281a9-fb28-44f5-b396-0833bcd2eb95	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:24.425479
61cb2e07-feef-49ee-aa5a-d3c976fd91a6	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:24.425479
64a9e20b-1585-4d0d-925a-79a0ab30bd15	default	generic	This changed everything	0.1	2026-04-26 17:46:24.425479
4c2e44ee-a84e-44f5-8097-9d018c8385f1	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:24.425479
a07ab615-2c9a-4d32-9b95-bd99fe220058	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:24.425479
d4b77751-a52c-4c4d-9d3a-c4ccb6bb7375	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:24.425479
abe2f0f1-2613-4f97-a621-32e67f0bec20	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:24.425479
77c34afb-a649-4459-9f16-4daf6b5e2847	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:24.425479
ab7fae04-aeb1-4f56-b74c-c8283a68fef9	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:24.425479
7e438271-fb0e-4906-91e0-bb95a94c878e	default	generic	This changed everything	0.1	2026-04-26 17:46:24.425479
c9c69138-eb3f-4142-b029-36ad276fe814	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:24.425479
a86c86af-8904-4b85-8228-656dc39beda5	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:24.425479
1ea9dc9c-ec12-4eff-9c5c-31ea08e453de	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:24.425479
934365a5-aeed-4fbf-b4c6-a8a8442d2fd1	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:24.425479
46850808-4897-441a-ae78-6ab083282569	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:24.425479
73df2412-744a-4134-bdeb-d7855e697a25	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:24.425479
3e4b4abf-7d3c-4bbc-932e-a5ec78ae64fe	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:24.425479
16bd5f1a-7ac7-47c8-9ddc-24e32113e95d	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:24.425479
92f78cbc-a1cc-4364-845a-7994082f79cb	default	generic	Stop wasting money on ads	0.1	2026-04-26 17:46:24.425479
55daf5fa-782b-4ce0-8a5f-5851adbab8b3	default	generic	This works in 24 hours	0.1	2026-04-26 17:46:24.425479
38c4f2d9-19c1-4014-9f86-08196b38f909	default	generic	This changed everything	0.1	2026-04-26 17:46:24.425479
f0220db2-a697-493d-a428-ffc026d30f62	default	generic	Hidden secret revealed	0.1	2026-04-26 17:46:24.425479
b67c045e-e89f-4637-8a57-7ff4b5893333	default	generic	Nobody talks about this	0.1	2026-04-26 17:46:24.425479
7abfc334-d617-476b-bc97-689efa8f5872	default	generic	This changed everything	0.1	2026-04-26 17:46:24.425479
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.invoices (id, tenant_id, plan_id, amount, status, created_at) FROM stdin;
inv_c6bc6fc2	tenant_0e46a852	pro	499	pending	2026-04-20 19:01:08.276092
inv_351cae89	tenant_0e46a852	pro	499	pending	2026-04-20 19:01:49.64978
inv_04f83651	tenant_0e46a852	pro	499	pending	2026-04-20 19:39:03.986618
inv_c8b11a1a	tenant_0e46a852	pro	499	pending	2026-04-20 21:30:21.4006
inv_429bebf6	tenant_0e46a852	pro	499	pending	2026-04-20 21:31:26.886588
inv_733cf55f	tenant_0e46a852	pro	499	pending	2026-04-21 08:48:58.575782
inv_4a90e0f2	tenant_a0ff45bf	pro	499	pending	2026-04-21 19:18:10.383884
inv_05c8c772	tenant_0e46a852	pro	499	pending	2026-04-21 21:13:12.853925
inv_cc27e67d	tenant_0e46a852	pro	499	pending	2026-04-21 21:17:51.096801
inv_d3bc70cb	tenant_0e46a852	pro	499	pending	2026-04-21 21:17:54.065537
inv_33652975	tenant_0e46a852	pro	499	pending	2026-04-21 21:34:11.391268
inv_3102674f	tenant_a0ff45bf	pro	499	pending	2026-04-22 00:41:26.453178
inv_34d3149c	tenant_a0ff45bf	pro	499	pending	2026-04-22 00:41:41.188725
inv_46df009c	tenant_a0ff45bf	pro	499	pending	2026-04-22 00:46:19.860395
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.jobs (id, tenant_id, status, payload, result, created_at, updated_at, type, retries, error, policy_id) FROM stdin;
9cb96c17-96b6-4124-bc9f-41197b75762f	free	queued	{"input": "test"}	\N	2026-04-23 09:47:02.048313	2026-04-23 09:47:02.048313	ai	0	\N	\N
572caa01-1cf8-493b-b00f-04710d1fad0b	free	queued	{"input": "test"}	\N	2026-04-23 09:47:23.107144	2026-04-23 09:47:23.107144	ai	0	\N	\N
c9683b2b-12f5-43f8-bf46-2a0912387a97	free	queued	{"input": "test"}	\N	2026-04-23 09:58:07.566142	2026-04-23 09:58:07.566142	ai	0	\N	\N
9dce1c13-072c-4f81-928f-ae2cbca6e06a	free	queued	{"input": "test"}	\N	2026-04-23 10:05:54.942324	2026-04-23 10:05:54.942324	ai	0	\N	\N
a0eed03e-77d3-47d2-9fef-30815d1b039d	free	queued	{"input": "test"}	\N	2026-04-23 10:15:29.01228	2026-04-23 10:15:29.01228	ai	0	\N	\N
78d87ed6-ec1e-4095-a677-09eed47f7beb	free	running	{"input": "test"}	\N	2026-04-23 10:34:24.415348	2026-04-23 10:34:24.415348	ai	0	\N	95753f89-22e1-4d5e-b82e-7a3655a90ee8
d3d6e463-5b2a-4256-9ebf-0d0c2fbe0f41	free	failed	{"input": "test"}	\N	2026-04-23 12:47:51.669498	2026-04-23 12:47:51.669498	ai	0	'Job' object has no attribute 'created_at'	d44e31d5-ddcb-432e-b457-6847aec0e070
90d11804-1150-4a64-bcb0-4779b9bce88d	free	failed	{"input": "test"}	\N	2026-04-23 12:47:38.398422	2026-04-23 12:47:38.398422	ai	0	'Job' object has no attribute 'created_at'	d44e31d5-ddcb-432e-b457-6847aec0e070
7361d075-29f6-4fb7-9109-3c92aaa454ec	free	failed	{"input": "test"}	{"input": {"input": "test"}, "status": "success", "message": "AI job executed"}	2026-04-23 10:52:42.581969	2026-04-23 10:52:42.581969	ai	0	(psycopg2.errors.UndefinedTable) relation "learning_memory" does not exist\nLINE 2:             INSERT INTO learning_memory (policy_id, outcome,...\n                                ^\n\n[SQL: \n            INSERT INTO learning_memory (policy_id, outcome, latency)\n            VALUES (%(pid)s, %(outcome)s, %(latency)s)\n        ]\n[parameters: {'pid': UUID('95753f89-22e1-4d5e-b82e-7a3655a90ee8'), 'outcome': True, 'latency': 1087}]\n(Background on this error at: https://sqlalche.me/e/20/f405)	95753f89-22e1-4d5e-b82e-7a3655a90ee8
097277e0-7090-4b0a-9292-bfd9b1b6c113	free	completed	{"input": "test"}	{"input": {"input": "test"}, "status": "success", "message": "AI job executed"}	2026-04-23 10:54:58.489691	2026-04-23 10:54:58.489691	ai	0	\N	95753f89-22e1-4d5e-b82e-7a3655a90ee8
5820a833-d278-4d9a-8013-d80664c65bb5	free	completed	{"input": "test"}	{"input": {"input": "test"}, "status": "success", "message": "AI job executed"}	2026-04-23 10:55:30.708672	2026-04-23 10:55:30.708672	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
b4111af3-e9c3-431b-b5bc-7372d028cb2b	free	failed	{"input": "test"}	\N	2026-04-23 12:47:40.067412	2026-04-23 12:47:40.067412	ai	0	'Job' object has no attribute 'created_at'	d44e31d5-ddcb-432e-b457-6847aec0e070
6509cab2-9cbb-46fe-bea3-0ab0e9022653	free	completed	{"input": "test"}	{"input": {"input": "test"}, "status": "success", "message": "AI job executed"}	2026-04-23 11:18:07.801425	2026-04-23 11:18:07.801425	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
f8c522e1-f026-4f70-85e6-c2fcc21fbc7c	free	completed	{"input": "test"}	{"input": {"input": "test"}, "status": "success", "message": "AI job executed"}	2026-04-23 11:18:10.872348	2026-04-23 11:18:10.872348	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
efcd92e3-0228-485d-ae17-d7be76faf399	free	failed	"{\\"input\\": \\"test\\"}"	\N	2026-04-23 13:13:48.970992	2026-04-23 13:13:48.970992	ai	0	cannot convert dictionary update sequence element #0 to a sequence	d44e31d5-ddcb-432e-b457-6847aec0e070
585d7c9a-bc7d-4502-8106-542d67932a6a	free	completed	{"input": "test"}	{"input": {"input": "test"}, "status": "success", "message": "AI job executed"}	2026-04-23 11:18:13.130372	2026-04-23 11:18:13.130372	ai	0	\N	344b884c-f5f1-4d83-9356-b509480822e6
4b69302f-51b6-428e-b161-b4d01125c3b6	free	failed	{"input": "test"}	\N	2026-04-23 12:47:41.302601	2026-04-23 12:47:41.302601	ai	0	'Job' object has no attribute 'created_at'	d44e31d5-ddcb-432e-b457-6847aec0e070
6061d9f6-e779-49cf-8cce-6e1cc517c923	free	completed	{"input": "test"}	{"input": {"input": "test"}, "status": "success", "message": "AI job executed"}	2026-04-23 11:49:51.209063	2026-04-23 11:49:51.209063	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
d284010e-e5b6-4dee-8bc7-5acf08e9cba6	free	completed	{"input": "test"}	{"input": {"input": "test"}, "status": "success", "message": "AI job executed"}	2026-04-23 11:50:16.483308	2026-04-23 11:50:16.483308	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
2a12b013-b4e6-4dbb-af52-87995b5586e0	free	failed	{"input": "test"}	\N	2026-04-23 12:47:52.885364	2026-04-23 12:47:52.885364	ai	0	'Job' object has no attribute 'created_at'	d44e31d5-ddcb-432e-b457-6847aec0e070
3ca89214-1cbd-470b-a334-6c8dc7e72268	free	completed	{"input": "test"}	{"input": {"input": "test"}, "status": "success", "message": "AI job executed"}	2026-04-23 12:05:17.28988	2026-04-23 12:05:17.28988	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
79d129fd-85af-4392-8cdd-9347352c70a9	free	failed	{"input": "test"}	\N	2026-04-23 12:47:43.586121	2026-04-23 12:47:43.586121	ai	0	'Job' object has no attribute 'created_at'	d44e31d5-ddcb-432e-b457-6847aec0e070
c451623f-d1d5-48ba-a2fa-9e326cf4030f	free	completed	{"input": "test"}	{"input": {"input": "test"}, "status": "success", "message": "AI job executed"}	2026-04-23 12:05:19.839592	2026-04-23 12:05:19.839592	ai	0	\N	cee6563f-766e-460d-8b29-837f2fac0756
80acf3f9-4036-4bc9-9d72-adc01dced02b	free	completed	{"input": "test"}	{"input": {"input": "test"}, "status": "success", "message": "AI job executed"}	2026-04-23 12:05:23.037401	2026-04-23 12:05:23.037401	ai	0	\N	15cc7c08-c1cc-4801-95c7-265a6f2ea8f8
62923f8e-6012-4cb4-bf63-a99c1253d51d	free	failed	{"input": "test"}	\N	2026-04-23 12:47:45.130057	2026-04-23 12:47:45.130057	ai	0	'Job' object has no attribute 'created_at'	d44e31d5-ddcb-432e-b457-6847aec0e070
5d57ea51-ae9b-494a-a329-a01f908c1cd1	free	failed	{"input": "test"}	\N	2026-04-23 12:47:57.30136	2026-04-23 12:47:57.30136	ai	0	'Job' object has no attribute 'created_at'	d44e31d5-ddcb-432e-b457-6847aec0e070
8301983f-e5ea-4b8a-8f31-a4e446b66d16	free	failed	{"input": "test"}	\N	2026-04-23 12:47:46.76951	2026-04-23 12:47:46.76951	ai	0	'Job' object has no attribute 'created_at'	d44e31d5-ddcb-432e-b457-6847aec0e070
68c4a4e9-6b6a-4a19-90c2-431e94c48543	free	failed	{"input": "test"}	\N	2026-04-23 12:47:54.008217	2026-04-23 12:47:54.008217	ai	0	'Job' object has no attribute 'created_at'	d44e31d5-ddcb-432e-b457-6847aec0e070
da454ed2-28eb-4ce0-a6f0-0674576f6423	free	failed	{"input": "test"}	\N	2026-04-23 12:47:48.672405	2026-04-23 12:47:48.672405	ai	0	'Job' object has no attribute 'created_at'	d44e31d5-ddcb-432e-b457-6847aec0e070
27692cd0-2df3-4d3a-936a-33e3c45d74dd	free	failed	{"input": "test"}	\N	2026-04-23 12:47:50.417519	2026-04-23 12:47:50.417519	ai	0	'Job' object has no attribute 'created_at'	d44e31d5-ddcb-432e-b457-6847aec0e070
2764ca20-476a-4f47-a30b-ab87fc546243	free	failed	"{\\"input\\": \\"test\\"}"	\N	2026-04-23 13:13:47.286028	2026-04-23 13:13:47.286028	ai	0	cannot convert dictionary update sequence element #0 to a sequence	d44e31d5-ddcb-432e-b457-6847aec0e070
36492520-dace-463e-8871-aa74e03bc931	free	failed	{"input": "test"}	\N	2026-04-23 12:47:55.094693	2026-04-23 12:47:55.094693	ai	0	'Job' object has no attribute 'created_at'	d44e31d5-ddcb-432e-b457-6847aec0e070
654f1da9-2fdc-4d66-a413-0687579c58f3	free	failed	"{\\"input\\": \\"test\\"}"	\N	2026-04-23 13:13:33.45288	2026-04-23 13:13:33.45288	ai	0	cannot convert dictionary update sequence element #0 to a sequence	d44e31d5-ddcb-432e-b457-6847aec0e070
735237fd-76c3-4e5d-a70d-b16e651557aa	free	failed	{"input": "test"}	\N	2026-04-23 12:47:56.187256	2026-04-23 12:47:56.187256	ai	0	'Job' object has no attribute 'created_at'	d44e31d5-ddcb-432e-b457-6847aec0e070
c9aecd31-8e31-4d94-9e81-0bb10a7180ea	free	failed	"{\\"input\\": \\"test\\"}"	\N	2026-04-23 13:13:44.739979	2026-04-23 13:13:44.739979	ai	0	cannot convert dictionary update sequence element #0 to a sequence	d44e31d5-ddcb-432e-b457-6847aec0e070
0b5b74a5-fe7d-4e96-8dd7-b1517b7570ce	free	failed	"{\\"input\\": \\"test\\"}"	\N	2026-04-23 13:13:50.268046	2026-04-23 13:13:50.268046	ai	0	cannot convert dictionary update sequence element #0 to a sequence	d44e31d5-ddcb-432e-b457-6847aec0e070
c7fb3175-2f05-4edb-89e4-74f88b11e7b5	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"explore\\", \\"message\\": \\"AI explore execution\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"explore\\"}}"	2026-04-23 13:19:11.650412	2026-04-23 13:19:11.650412	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
79f90f8c-f3f1-440b-86bd-6dedebeee90c	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"exploit\\", \\"message\\": \\"AI exploit execution\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"exploit\\"}}"	2026-04-23 13:19:33.453747	2026-04-23 13:19:33.453747	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
488abd9f-2aec-49e0-b9ed-275681ad361c	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"explore\\", \\"message\\": \\"AI explore execution\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"explore\\"}}"	2026-04-23 13:19:25.686423	2026-04-23 13:19:25.686423	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
23ac0ee1-422e-4872-9254-562ce250f2d5	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"explore\\", \\"message\\": \\"AI explore execution\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"explore\\"}}"	2026-04-23 13:19:27.163319	2026-04-23 13:19:27.163319	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
02b253c6-1532-4c3e-a122-3260febf776e	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"explore\\", \\"message\\": \\"AI explore execution\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"explore\\"}}"	2026-04-23 13:19:28.942958	2026-04-23 13:19:28.942958	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
f33457fc-711c-44a1-ae0d-76fa7e1dee88	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"exploit\\", \\"message\\": \\"AI exploit execution\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"exploit\\"}}"	2026-04-23 13:19:30.870059	2026-04-23 13:19:30.870059	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
8bf6ec13-4f6f-4894-9283-7453710dae2f	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"exploit\\", \\"message\\": \\"AI exploit execution\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"exploit\\"}}"	2026-04-23 13:19:32.21063	2026-04-23 13:19:32.21063	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
870a3cf0-86b7-4ec5-9572-0b071f58025a	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:08:55.666576	2026-04-23 22:08:55.666576	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
4d7f7fc5-6267-46d1-810d-0629419984ad	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 21:27:21.25612	2026-04-23 21:27:21.25612	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
9b1e82ae-481e-49c8-b5e8-ab56397fffc4	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 21:27:23.897565	2026-04-23 21:27:23.897565	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
331f6a7d-1261-4eb0-b16f-a2b314c4aef3	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 21:27:25.395443	2026-04-23 21:27:25.395443	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
3e6bd0ee-f0d3-4868-82a2-95ddde595142	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:08:58.444064	2026-04-23 22:08:58.444064	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
e6f9bbba-34ff-4a80-b4a8-f58a586e2358	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 21:27:34.678121	2026-04-23 21:27:34.678121	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
4dedf5cf-95a8-414a-bd0f-343a93b4cae9	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 21:27:35.77311	2026-04-23 21:27:35.77311	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
2d49991c-cf4d-49e1-8894-004bafe1b48a	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 21:27:37.803793	2026-04-23 21:27:37.803793	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
821b38ec-92bd-4668-ac28-740479cb65ad	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:09:00.647816	2026-04-23 22:09:00.647816	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
4cab01e1-e7f0-49c0-85e8-6b3de6e88d4b	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 21:27:39.729521	2026-04-23 21:27:39.729521	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
c38930f5-218b-4a5e-8f77-571be045b3d9	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 21:27:41.98784	2026-04-23 21:27:41.98784	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
6d6aead2-cc62-4d3a-bca7-0104936de4ae	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 21:27:45.505831	2026-04-23 21:27:45.505831	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
4a1da20f-2e72-4bc8-bd01-a6dc7b723650	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 21:27:47.332335	2026-04-23 21:27:47.332335	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
2dd5b685-c88e-403b-85c9-8eb26b737160	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:09:02.698081	2026-04-23 22:09:02.698081	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
9a4f4bd3-d9fd-4d7f-bc6f-7cc985d48a53	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 21:48:43.564886	2026-04-23 21:48:43.564886	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
e9203c7d-db34-4f20-a133-8ba43e19b771	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:20:17.633615	2026-04-23 22:20:17.633615	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
198e0a21-01a9-4fc8-accf-d40e74d4da0e	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:08:52.750111	2026-04-23 22:08:52.750111	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
8a892053-66ab-40af-a096-7c86befce289	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:20:22.733838	2026-04-23 22:20:22.733838	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
5710380f-ae8b-4ea7-a69b-6da4b75b8cb0	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:09:04.179019	2026-04-23 22:09:04.179019	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
ca34f4dd-0955-4110-865b-d64613c093d7	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:20:19.385313	2026-04-23 22:20:19.385313	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
2bd63b2b-7b45-4752-a38e-b93cb87f861a	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:09:06.58879	2026-04-23 22:09:06.58879	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
6b9dd4a8-6e30-4697-a6c4-1cef2f738991	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:20:13.990623	2026-04-23 22:20:13.990623	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
d4616c64-1c8b-4c64-bfbf-9e65949ea2a1	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:20:21.616526	2026-04-23 22:20:21.616526	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
94852fa6-a6bf-4c83-814c-42368137692e	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:43:16.206889	2026-04-23 22:43:16.206889	ai	0	\N	d44e31d5-ddcb-432e-b457-6847aec0e070
89463a8c-0a24-4d5c-bd5e-770afd8ba6e0	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:43:18.140123	2026-04-23 22:43:18.140123	ai	0	\N	0c2561d1-e194-4793-bfca-7044307d7e5f
cb7b3581-9cf3-4d9d-8dc2-38bc218dc548	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:43:20.483338	2026-04-23 22:43:20.483338	ai	0	\N	63c9599e-61be-4162-8502-fe5c6ce6ac39
b24a327a-624b-48dd-9eea-feecd4cf4255	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:43:23.037733	2026-04-23 22:43:23.037733	ai	0	\N	61583d2b-3f7a-4eaf-bb2f-785fa0bd83a9
2dcec032-061a-4d10-9600-759160d54e8b	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:43:24.482181	2026-04-23 22:43:24.482181	ai	0	\N	335c5c6a-1a88-415a-bc49-a760889d9297
44f482c4-65db-4cd8-aef4-2e3d26f9ec0b	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 22:43:26.877776	2026-04-23 22:43:26.877776	ai	0	\N	8ed287c8-7ec7-4e21-864d-3da6d4595c0d
4d47b586-7a1e-493d-ad03-cee7abda1bf8	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-23 23:46:47.140722	2026-04-23 23:46:47.140722	ai	0	\N	cb089a3a-13a9-422d-a95f-f87730f44e78
ae27a8d6-d337-4b4e-9fe6-f19b7b580627	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.355574	2026-04-24 00:52:41.355574	ai	0	\N	133de373-d757-4e31-8932-1de0179ea366
455549dd-105d-4c03-b153-310ff6ce7e2e	free	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:21:03.026995	2026-04-24 00:21:03.026995	ai	0	\N	23afd7d5-47a4-40f5-b405-37caf091796a
e7b12959-d9c8-4f15-9f76-b042da6487e7	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.639602	2026-04-24 00:52:41.639602	ai	0	\N	b1ea5268-3cb9-41bd-94e0-16fa770908cb
96e36279-b2a2-4f5b-babf-7ef313de6694	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:46:42.897581	2026-04-24 00:46:42.897581	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
4e83a3a9-343d-48d7-8fd3-239c77f1ec4d	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.395768	2026-04-24 00:52:41.395768	ai	0	\N	49e4c548-89d1-446e-9545-9d4e8e91a83e
ccec4278-0bcd-449a-8a2a-8cd99499f7f6	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.054176	2026-04-24 00:52:41.054176	ai	0	\N	3c6b827e-3b36-48b6-9ae2-0f54544e326e
32547d9c-244b-467d-b242-09246ee705e8	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.897424	2026-04-24 00:52:41.897424	ai	0	\N	9f06f56f-d1e3-4fe0-9dd0-f376e3b5859b
76e617f0-6e07-400c-8e10-25d929377387	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.111699	2026-04-24 00:52:41.111699	ai	0	\N	ffadab01-5d5a-4ed7-a4d7-fa35ce3feb7d
ec0ab8e9-b86d-4e6f-acde-0c1e6c5b4add	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.433811	2026-04-24 00:52:41.433811	ai	0	\N	5717693c-a9dc-4bc8-8811-c1a346cc39bb
7c282635-85e2-4869-841c-3a534829dc77	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.158753	2026-04-24 00:52:41.158753	ai	0	\N	9f1e02e2-eba0-4ac9-965c-8d6170267fab
de82ccc2-aa46-4f9a-a956-e6fb68b6fe95	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.681352	2026-04-24 00:52:41.681352	ai	0	\N	55255ebc-68f0-409a-b7be-9754d1babb74
21b68d5d-64c8-4cce-a006-41d003983a70	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.197904	2026-04-24 00:52:41.197904	ai	0	\N	4377fcc5-0da2-47d8-9f70-c4b26db7488d
4994b33e-b3fc-4768-ac66-000dd38dba23	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.47528	2026-04-24 00:52:41.47528	ai	0	\N	9a446794-c9cc-4db0-8fda-d563f7563935
6883c77a-fb56-47ea-a584-c3afb5232532	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.238361	2026-04-24 00:52:41.238361	ai	0	\N	cf08168d-22ef-465b-883f-f2392036b1a7
db849342-4536-4937-a5f7-0b2b183c5152	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.275587	2026-04-24 00:52:41.275587	ai	0	\N	19c2264c-5bd3-4f27-b66b-855f40a81830
a0c5eb8b-1030-4ff2-a952-a97061335c7c	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.523994	2026-04-24 00:52:41.523994	ai	0	\N	c6d0a662-a4a7-4e2e-af8b-edbbd1de8a45
cc930971-4abc-4e37-9bf4-16943f5b888e	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.316207	2026-04-24 00:52:41.316207	ai	0	\N	a2c53d62-d5e3-4597-b2b4-9487cb801909
48d1ca12-4b1f-4baa-9505-2a5149d18b8c	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.734218	2026-04-24 00:52:41.734218	ai	0	\N	67782314-f2d4-446c-b344-e405f8151e8f
4b8178c2-b528-48a9-9cb6-97d0eaef06da	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.560932	2026-04-24 00:52:41.560932	ai	0	\N	4ce5c0c4-def1-453f-853c-a4ded1256705
f5f49f0d-415f-461a-acac-855b0421b542	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.601295	2026-04-24 00:52:41.601295	ai	0	\N	633b552c-bab5-4ac1-b845-24cff0b4db63
d8f897fd-f7bf-49f6-bd95-83f1eea12bee	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.794149	2026-04-24 00:52:41.794149	ai	0	\N	a801e65e-d157-4b78-88a3-ad1d2133418d
50cf2cf7-f226-4687-a171-2ea447298f0e	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 00:52:41.848192	2026-04-24 00:52:41.848192	ai	0	\N	fb9d4be5-8328-4b41-b486-eb658a4f320b
99f4c049-a0b0-46e4-994b-c3dfe4bc71eb	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:22.577371	2026-04-24 01:28:22.577371	ai	0	\N	60c4d433-ebb4-478d-8e6d-cb1cf8b4d65d
985ce869-8267-453b-b8cb-865563effcfc	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:22.676943	2026-04-24 01:28:22.676943	ai	0	\N	992857cb-54e4-4314-82b3-dd44cf59613d
70a78875-92df-492f-a769-0ed7abb0901e	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:22.774586	2026-04-24 01:28:22.774586	ai	0	\N	7346ffbf-257d-4b87-8adf-a154cc386933
5f2a4a07-8e92-428b-b934-9eec80626d66	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:22.873668	2026-04-24 01:28:22.873668	ai	0	\N	849d5726-d2bd-4992-b953-4eb295d78b74
31698ee5-2a89-42c1-99aa-716a2183ab54	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:22.977082	2026-04-24 01:28:22.977082	ai	0	\N	63cbac38-6662-4984-9e54-f9b2566b7633
fa8437e9-0a05-4a62-b456-beda55866a02	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:23.076231	2026-04-24 01:28:23.076231	ai	0	\N	19c2264c-5bd3-4f27-b66b-855f40a81830
7a61ced5-77bb-4744-8268-07cfc13bd650	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:23.261752	2026-04-24 01:28:23.261752	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
5438f5e3-26da-4330-8fa2-1427099e5d34	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:22.272624	2026-04-24 01:28:22.272624	ai	0	\N	232e69f2-7c5a-4338-acf6-780dfeeeb8c2
734f125d-9300-4f7e-bda9-504c6012c310	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:22.459547	2026-04-24 01:28:22.459547	ai	0	\N	47004496-511f-4ff8-ab44-0f8251a3e56f
92ecf741-4887-4cb3-807a-1f8f7961df98	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:22.626841	2026-04-24 01:28:22.626841	ai	0	\N	1cee6e52-3278-426c-903c-d697aa3c1a8c
10832fdd-99f2-4e5f-b878-7f59569af78d	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:22.72288	2026-04-24 01:28:22.72288	ai	0	\N	23e82e6a-5f1d-4e3a-ba0e-11c5896e4026
2c58750b-d317-4599-bf51-e546c94cc3f9	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:22.824875	2026-04-24 01:28:22.824875	ai	0	\N	2cd962c2-e25a-42ab-88ee-f9dcac391339
a4b3359d-dca7-4a69-b33b-7fb2edad8e0e	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:22.92548	2026-04-24 01:28:22.92548	ai	0	\N	b18d7623-bdc8-41b4-bb23-61fb0a51b857
17aa8eb7-ddf6-449a-9499-0036c16f8292	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:23.026626	2026-04-24 01:28:23.026626	ai	0	\N	cf5d755d-a355-4faf-b654-6074e043a9a2
4bdea51f-3451-4284-af05-fd49e4bd9840	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:23.128178	2026-04-24 01:28:23.128178	ai	0	\N	a2c53d62-d5e3-4597-b2b4-9487cb801909
33dbef0c-d2ad-4978-a281-4b3f252b7e99	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:23.324217	2026-04-24 01:28:23.324217	ai	0	\N	133de373-d757-4e31-8932-1de0179ea366
525d8338-a83d-47e5-986c-73efeb358d9a	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:23.395776	2026-04-24 01:28:23.395776	ai	0	\N	3c6b827e-3b36-48b6-9ae2-0f54544e326e
52d14e43-4c45-4691-8e4a-a358e8208989	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:23.455108	2026-04-24 01:28:23.455108	ai	0	\N	1ba64459-214c-4257-87cb-707d82abbcdc
8a5069d2-73b0-4e56-a59f-9e77060fceb2	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:30.116434	2026-04-24 01:48:30.116434	ai	0	\N	7de00605-784a-4322-9f59-89e2b83838c2
8a71e5f7-5149-4e35-8e7d-08f8a2ca6546	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:23.506218	2026-04-24 01:28:23.506218	ai	0	\N	9f1e02e2-eba0-4ac9-965c-8d6170267fab
219ea95a-aa40-465c-b907-68ef5ca66c0e	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:28:23.559165	2026-04-24 01:28:23.559165	ai	0	\N	9f1e02e2-eba0-4ac9-965c-8d6170267fab
8d727296-8c7e-4e3c-bb06-fed4801ca49a	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:30.280737	2026-04-24 01:48:30.280737	ai	0	\N	ce6ca3dd-00b4-4376-b91a-891ea3ec5e18
dff764bf-2fb7-44b2-8efa-4694281ade1d	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:29.925431	2026-04-24 01:48:29.925431	ai	0	\N	36c09f80-929d-4137-a8f0-ce0fe0e35dd4
dd6e5b26-f70e-47ff-9275-cc6578cf7393	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:30.515249	2026-04-24 01:48:30.515249	ai	0	\N	e2c414c2-a2ae-47c0-90e7-ec69df21112b
f6f657c2-97d0-449f-89ca-969837ba56f4	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:30.724875	2026-04-24 01:48:30.724875	ai	0	\N	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
a3002e38-bc42-4d83-b2a1-224a83840019	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:30.36238	2026-04-24 01:48:30.36238	ai	0	\N	2a00557b-a245-462c-bfe6-dcf34598a5da
c94615b1-49ac-443b-bfe2-4e9965457f4f	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:30.594384	2026-04-24 01:48:30.594384	ai	0	\N	b37e536a-8290-43b4-bf1f-4756dc34a7be
c65faa6f-32f5-4747-abc4-554293b5f2c8	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:30.428236	2026-04-24 01:48:30.428236	ai	0	\N	9597531d-b911-4fa7-ae31-35790fcfdce8
4f443ad0-491b-4f37-90ab-d8c23944b5a1	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:30.884051	2026-04-24 01:48:30.884051	ai	0	\N	e999c7bf-195a-4a3c-aa82-ca1afbdf8414
75e2da9b-684c-4a57-b56d-82df8291d410	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:30.653305	2026-04-24 01:48:30.653305	ai	0	\N	7de00605-784a-4322-9f59-89e2b83838c2
8d86d307-7124-466b-8f14-cde926ecdfe8	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:30.809758	2026-04-24 01:48:30.809758	ai	0	\N	54b45389-2af3-4740-ab70-d0b44252aeae
0eefd672-26b8-4064-89d1-576b0876d5df	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:30.943258	2026-04-24 01:48:30.943258	ai	0	\N	9aae50bf-c437-4c5c-8ee2-be11616f31d8
90c801af-7de0-4433-85ac-576896067a45	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:31.010493	2026-04-24 01:48:31.010493	ai	0	\N	30a5f88e-3c8b-45fc-aa4f-cdb518d97980
d90902cc-4e5e-46e9-8c46-c9382a493e95	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:31.104844	2026-04-24 01:48:31.104844	ai	0	\N	9bc21cd9-d678-4419-8340-17f2f3d6cb3e
ce2cdf49-98c4-48d3-b1e2-bd887e5daa61	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:31.182524	2026-04-24 01:48:31.182524	ai	0	\N	354041a1-c8fa-4717-8a72-2663ceca0b20
2f4ae6a4-1c32-4d3d-9295-ce9eb702479c	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:31.334786	2026-04-24 01:48:31.334786	ai	0	\N	7de00605-784a-4322-9f59-89e2b83838c2
bdda1c38-e428-414d-975f-f1df851f82b2	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:31.406103	2026-04-24 01:48:31.406103	ai	0	\N	9f1e02e2-eba0-4ac9-965c-8d6170267fab
e84a88ff-5dbd-4553-b2e0-012386fe781c	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:31.487856	2026-04-24 01:48:31.487856	ai	0	\N	ce6ca3dd-00b4-4376-b91a-891ea3ec5e18
e5bf57cc-de72-44ed-b572-83d84dad90bb	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:31.680852	2026-04-24 01:48:31.680852	ai	0	\N	7de00605-784a-4322-9f59-89e2b83838c2
6a6d4d69-f14c-4c71-89ef-d7aaf0630c77	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"default\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"default\\"}}"	2026-04-24 01:48:31.568549	2026-04-24 01:48:31.568549	ai	0	\N	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
7c422803-d8e7-4028-9cbd-97901ee0d215	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 11:48:43.295568	2026-04-25 11:48:43.295568	ai	0	\N	19c2264c-5bd3-4f27-b66b-855f40a81830
6dfeedd4-dade-472e-a12a-d075dc7b9070	tenant_0e46a852	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"exploit\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"exploit\\"}}"	2026-04-24 10:47:51.152072	2026-04-24 10:47:51.152072	ai	0	\N	4377fcc5-0da2-47d8-9f70-c4b26db7488d
3f19af22-7a39-4b94-a583-d0c3ae033908	tenant_1	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"exploit\\", \\"input\\": {\\"input\\": \\"test\\", \\"mode\\": \\"exploit\\"}}"	2026-04-24 11:49:49.79901	2026-04-24 11:49:49.79901	ai	0	\N	4377fcc5-0da2-47d8-9f70-c4b26db7488d
339f6de8-f3ec-480c-a702-1c6e76902ce0	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 11:48:43.365776	2026-04-25 11:48:43.365776	ai	0	\N	a2c53d62-d5e3-4597-b2b4-9487cb801909
8bd5b6f6-4b45-4ee6-99e1-9fbb84549a5d	tenant_1	completed	"{\\"input\\": \\"test\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"balanced\\"}"	2026-04-24 13:38:43.424263	2026-04-24 13:38:43.424263	ai	0	\N	4377fcc5-0da2-47d8-9f70-c4b26db7488d
15f8be18-24d5-4e57-95f5-c4afac61f6bc	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 12:01:27.608099	2026-04-25 12:01:27.608099	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
86ec6466-0fb2-4cdc-b925-62a92a614d3a	tenant_1	completed	"{\\"input\\": \\"test\\", \\"campaign_id\\": \\"test_1\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"balanced\\"}"	2026-04-25 08:01:45.939745	2026-04-25 08:01:45.939745	ai	0	\N	4377fcc5-0da2-47d8-9f70-c4b26db7488d
a28863c5-daa1-4e85-a1fe-484802a198c7	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 11:48:43.421483	2026-04-25 11:48:43.421483	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
17faa97f-27f6-4023-b9be-8c7b638a7b7e	tenant_1	failed	"{\\"campaign_id\\": \\"test_1\\"}"	\N	2026-04-25 08:28:49.718749	2026-04-25 08:28:49.718749	ai	0	name 'select_final_strategy' is not defined	4377fcc5-0da2-47d8-9f70-c4b26db7488d
debd30aa-10bf-4a43-9b89-2a3c77b0bffe	tenant_1	completed	"{\\"campaign_id\\": \\"test_1\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 08:41:02.377271	2026-04-25 08:41:02.377271	ai	0	\N	4377fcc5-0da2-47d8-9f70-c4b26db7488d
4cb9c7ac-fa7f-4af8-a49b-68ba2047e78f	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 11:48:43.478076	2026-04-25 11:48:43.478076	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
1b763b49-2255-42a8-a6d0-1f642caab855	tenant_1	completed	"{\\"campaign_id\\": \\"test_1\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 08:48:34.727209	2026-04-25 08:48:34.727209	ai	0	\N	4377fcc5-0da2-47d8-9f70-c4b26db7488d
d3bb4d85-370e-43d3-8f78-042a4ec678f3	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"failed\\", \\"error\\": \\"cannot access local variable 'strategy' where it is not associated with a value\\"}"	2026-04-25 19:18:22.998632	2026-04-25 19:18:22.998632	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
afd35aa9-8c23-40f1-a456-343b6dbceac0	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 10:41:14.354428	2026-04-25 10:41:14.354428	ai	0	\N	4377fcc5-0da2-47d8-9f70-c4b26db7488d
aa41edc1-f240-4b71-b7c1-1a62b63f5ebe	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 11:48:43.535922	2026-04-25 11:48:43.535922	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
9c9ddcb4-1441-44c5-b98a-af6481bbf3e4	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-25 10:46:23.956228	2026-04-25 10:46:23.956228	ai	0	\N	4377fcc5-0da2-47d8-9f70-c4b26db7488d
92e02034-5b94-482a-8ec7-befd4c279410	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 11:24:20.684837	2026-04-25 11:24:20.684837	ai	0	\N	4377fcc5-0da2-47d8-9f70-c4b26db7488d
f2f47cb0-0213-449d-8b64-8e94fb549bcd	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-25 11:28:54.606304	2026-04-25 11:28:54.606304	ai	0	\N	4377fcc5-0da2-47d8-9f70-c4b26db7488d
c84d8121-9714-454b-a3c4-c402a07827bb	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 11:40:23.655673	2026-04-25 11:40:23.655673	ai	0	\N	cf08168d-22ef-465b-883f-f2392036b1a7
b043b440-c2fa-4893-aab3-64edc188dbf1	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 11:41:27.435057	2026-04-25 11:41:27.435057	ai	0	\N	9f1e02e2-eba0-4ac9-965c-8d6170267fab
66b83693-b3e3-4535-91a6-7a317b3a9302	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"balanced\\"}"	2026-04-25 12:23:50.822317	2026-04-25 12:23:50.822317	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
e0a963e1-c1d1-4846-a852-2f6ead187627	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 12:01:27.471978	2026-04-25 12:01:27.471978	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
fffab30e-403f-4ed7-a1ac-cec34274e1c2	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 12:01:27.516129	2026-04-25 12:01:27.516129	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
87a4fd6c-7fdf-4c3c-8247-a157f61392be	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 12:29:44.50804	2026-04-25 12:29:44.50804	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
55f276ea-3c21-4596-8231-bd51fd810ec9	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 12:01:27.545245	2026-04-25 12:01:27.545245	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
009ddea8-dfdd-4fbc-a140-9664fb10dfa9	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 12:01:27.576655	2026-04-25 12:01:27.576655	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
7d182199-a33b-4d9e-9737-ddeb46f90bde	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"scale\\"}"	2026-04-25 18:42:56.874201	2026-04-25 18:42:56.874201	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
3b1b17d7-fccc-4f03-81ea-871f37a8f78c	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"failed\\", \\"error\\": \\"cannot access local variable 'strategy' where it is not associated with a value\\"}"	2026-04-25 19:24:18.733057	2026-04-25 19:24:18.733057	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
041d14cc-a650-41d6-92b8-8c320b9cfd5e	tenant_1	failed	"{\\"product_id\\": \\"test_product\\"}"	\N	2026-04-25 19:03:24.587161	2026-04-25 19:03:24.587161	ai	0	cannot access local variable 'latency' where it is not associated with a value	129a8c8d-54b1-43f9-a7c2-75993315998a
7fb8a6a0-c52f-4299-b069-f7ed01eaec86	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"failed\\", \\"error\\": \\"cannot access local variable 'strategy' where it is not associated with a value\\"}"	2026-04-25 19:33:41.45269	2026-04-25 19:33:41.45269	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
ded03088-90fa-4cf6-917c-aa43ae372fe2	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"failed\\", \\"error\\": \\"cannot access local variable 'strategy' where it is not associated with a value\\"}"	2026-04-25 19:30:24.016124	2026-04-25 19:30:24.016124	ai	0	\N	129a8c8d-54b1-43f9-a7c2-75993315998a
68658ee6-2ffe-43ab-a9ca-05b78196fc5d	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"failed\\", \\"error\\": \\"cannot access local variable 'strategy' where it is not associated with a value\\"}"	2026-04-25 19:34:24.356994	2026-04-25 19:34:24.356994	ai	0	\N	133de373-d757-4e31-8932-1de0179ea366
44bbd9bc-ae02-4e29-8e69-ec56e0042ac8	tenant_1	pending	"{\\"enable_meta_sync\\": true, \\"ad_account_id\\": \\"1234567890\\"}"	\N	2026-04-25 21:24:45.359198	2026-04-25 21:24:45.359198	ai	0	\N	\N
ff12e941-8a0b-42aa-9031-6e120f4e77ce	tenant_1	failed	"{\\"product_id\\": \\"test_product\\"}"	\N	2026-04-25 19:41:49.139676	2026-04-25 19:41:49.139676	ai	0	'Job' object has no attribute 'policy'	3c6b827e-3b36-48b6-9ae2-0f54544e326e
2f1562b9-df1b-4ddf-a424-c06995ff9812	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-25 20:11:24.951112	2026-04-25 20:11:24.951112	ai	0	\N	3c6b827e-3b36-48b6-9ae2-0f54544e326e
8451d25d-1abc-4d1f-80fe-405d55fa3d6b	tenant_1	pending	"{\\"enable_meta_sync\\": true, \\"ad_account_id\\": \\"1234567890\\"}"	\N	2026-04-25 21:26:10.681688	2026-04-25 21:26:10.681688	ai	0	\N	\N
de51f38c-6ed1-417a-b969-8ad114a7c6df	tenant_1	completed	"{\\"product_id\\": \\"test_product\\", \\"enable_meta_sync\\": true, \\"ad_account_id\\": \\"1234567890\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-25 21:49:25.957151	2026-04-25 21:49:25.957151	ai	0	\N	3c6b827e-3b36-48b6-9ae2-0f54544e326e
48be9952-c21e-4603-b7d2-b759f0d977b3	tenant_1	completed	"{\\"product_id\\": \\"test_product\\", \\"ad_account_id\\": \\"1234567890\\", \\"auto_deploy\\": true, \\"enable_meta_sync\\": true}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-25 22:16:42.116628	2026-04-25 22:16:42.116628	ai	0	\N	3c6b827e-3b36-48b6-9ae2-0f54544e326e
17659cbc-4575-4b8f-b1b5-6a50c679daf1	tenant_1	completed	"{\\"product_id\\": \\"test_product\\", \\"ad_account_id\\": \\"1234567890\\", \\"auto_deploy\\": true, \\"enable_meta_sync\\": true}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 07:32:31.459022	2026-04-26 07:32:31.459022	ai	0	\N	3c6b827e-3b36-48b6-9ae2-0f54544e326e
0c937357-7ac8-488a-af78-7e361c8d11dc	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 11:04:17.67231	2026-04-26 11:04:17.67231	ai	0	\N	3c6b827e-3b36-48b6-9ae2-0f54544e326e
827cb2f2-28ad-477f-8424-9f6b40a8234a	tenant_1	failed	"{\\"product_id\\": \\"test_product\\"}"	\N	2026-04-26 10:46:34.586569	2026-04-26 10:46:34.586569	ai	0	(psycopg2.errors.UndefinedFunction) operator does not exist: uuid = text\nLINE 4:             JOIN creatives c ON c.id = cm.creative_id\n                                             ^\nHINT:  No operator matches the given name and argument types. You might need to add explicit type casts.\n\n[SQL: \n            SELECT cm.creative_id, cm.ctr, cm.cpa, cm.frequency\n            FROM creative_metrics cm\n            JOIN creatives c ON c.id = cm.creative_id\n            WHERE c.status = 'generated'\n        ]\n(Background on this error at: https://sqlalche.me/e/20/f405)	3c6b827e-3b36-48b6-9ae2-0f54544e326e
d10693a6-45ac-4406-acae-e7ccdf52e928	tenant_1	failed	"{\\"product_id\\": \\"test_product\\"}"	\N	2026-04-26 10:46:34.66018	2026-04-26 10:46:34.66018	ai	0	(psycopg2.errors.UndefinedFunction) operator does not exist: uuid = text\nLINE 4:             JOIN creatives c ON c.id = cm.creative_id\n                                             ^\nHINT:  No operator matches the given name and argument types. You might need to add explicit type casts.\n\n[SQL: \n            SELECT cm.creative_id, cm.ctr, cm.cpa, cm.frequency\n            FROM creative_metrics cm\n            JOIN creatives c ON c.id = cm.creative_id\n            WHERE c.status = 'generated'\n        ]\n(Background on this error at: https://sqlalche.me/e/20/f405)	3c6b827e-3b36-48b6-9ae2-0f54544e326e
30427cc6-3b73-438f-81d0-97ff9dc8ff09	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 11:04:17.74111	2026-04-26 11:04:17.74111	ai	0	\N	3c6b827e-3b36-48b6-9ae2-0f54544e326e
980aef76-a5df-4406-9a28-a31af88e2048	tenant_1	failed	"{\\"product_id\\": \\"test_product\\"}"	\N	2026-04-26 10:46:34.724185	2026-04-26 10:46:34.724185	ai	0	(psycopg2.errors.UndefinedFunction) operator does not exist: uuid = text\nLINE 4:             JOIN creatives c ON c.id = cm.creative_id\n                                             ^\nHINT:  No operator matches the given name and argument types. You might need to add explicit type casts.\n\n[SQL: \n            SELECT cm.creative_id, cm.ctr, cm.cpa, cm.frequency\n            FROM creative_metrics cm\n            JOIN creatives c ON c.id = cm.creative_id\n            WHERE c.status = 'generated'\n        ]\n(Background on this error at: https://sqlalche.me/e/20/f405)	3c6b827e-3b36-48b6-9ae2-0f54544e326e
1339f4d0-17a6-432a-9483-ed7e36e4c42e	tenant_1	failed	"{\\"product_id\\": \\"test_product\\"}"	\N	2026-04-26 10:46:34.78645	2026-04-26 10:46:34.78645	ai	0	(psycopg2.errors.UndefinedFunction) operator does not exist: uuid = text\nLINE 4:             JOIN creatives c ON c.id = cm.creative_id\n                                             ^\nHINT:  No operator matches the given name and argument types. You might need to add explicit type casts.\n\n[SQL: \n            SELECT cm.creative_id, cm.ctr, cm.cpa, cm.frequency\n            FROM creative_metrics cm\n            JOIN creatives c ON c.id = cm.creative_id\n            WHERE c.status = 'generated'\n        ]\n(Background on this error at: https://sqlalche.me/e/20/f405)	3c6b827e-3b36-48b6-9ae2-0f54544e326e
7ecfd895-1856-4284-8a87-0cad3f27db94	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 11:04:17.790498	2026-04-26 11:04:17.790498	ai	0	\N	3c6b827e-3b36-48b6-9ae2-0f54544e326e
69d734d0-2df4-44cb-86e3-57143cf98a6b	tenant_1	failed	"{\\"product_id\\": \\"test_product\\"}"	\N	2026-04-26 10:46:34.870637	2026-04-26 10:46:34.870637	ai	0	(psycopg2.errors.UndefinedFunction) operator does not exist: uuid = text\nLINE 4:             JOIN creatives c ON c.id = cm.creative_id\n                                             ^\nHINT:  No operator matches the given name and argument types. You might need to add explicit type casts.\n\n[SQL: \n            SELECT cm.creative_id, cm.ctr, cm.cpa, cm.frequency\n            FROM creative_metrics cm\n            JOIN creatives c ON c.id = cm.creative_id\n            WHERE c.status = 'generated'\n        ]\n(Background on this error at: https://sqlalche.me/e/20/f405)	3c6b827e-3b36-48b6-9ae2-0f54544e326e
93ba1e1a-b7f8-4343-b6a7-7e1dc4135003	tenant_1	completed	"{\\"mode\\": \\"explore\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 12:07:43.898467	2026-04-26 12:07:43.898467	ai	0	\N	3c6b827e-3b36-48b6-9ae2-0f54544e326e
a2b589b9-970e-4e3d-856e-21e6027bab9a	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 11:04:17.842406	2026-04-26 11:04:17.842406	ai	0	\N	3c6b827e-3b36-48b6-9ae2-0f54544e326e
de9b9aa9-9371-4d6e-aecf-7653cae544ac	tenant_1	completed	"{\\"product_id\\": \\"test_product\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 11:04:17.888534	2026-04-26 11:04:17.888534	ai	0	\N	3c6b827e-3b36-48b6-9ae2-0f54544e326e
20d7e653-258b-4036-a5a7-2d21ff8b1465	tenant_1	completed	"{\\"mode\\": \\"explore\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 12:07:45.333863	2026-04-26 12:07:45.333863	ai	0	\N	ce6ca3dd-00b4-4376-b91a-891ea3ec5e18
beafcc7d-68d6-4adf-9439-ae510b38840d	tenant_1	completed	"{\\"mode\\": \\"explore\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 12:07:39.976352	2026-04-26 12:07:39.976352	ai	0	\N	3c6b827e-3b36-48b6-9ae2-0f54544e326e
82bd37e5-07a3-491a-8c35-1336d8eae6bd	tenant_1	failed	"{\\"mode\\": \\"explore\\"}"	\N	2026-04-26 12:57:12.362696	2026-04-26 12:57:12.362696	ai	0	(psycopg2.errors.UniqueViolation) duplicate key value violates unique constraint "creative_metrics_pkey"\nDETAIL:  Key (creative_id)=(6a47fed4-5e33-425c-bbc6-691c625d33a7) already exists.\n\n[SQL: \n                    INSERT INTO creative_metrics (\n                        creative_id, ctr, cpa, roas, frequency, updated_at\n                    )\n                    SELECT creative_id, ctr, cpa, roas, frequency, NOW()\n                    FROM creative_metrics\n                    WHERE creative_id = %(cid)s\n                    ORDER BY updated_at DESC\n                    LIMIT 1\n                ]\n[parameters: {'cid': '6a47fed4-5e33-425c-bbc6-691c625d33a7'}]\n(Background on this error at: https://sqlalche.me/e/20/gkpj)	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
73d5b21c-81b1-43b7-b6b4-90954b005cdd	tenant_1	failed	"{\\"mode\\": \\"explore\\"}"	\N	2026-04-26 12:57:14.035336	2026-04-26 12:57:14.035336	ai	0	(psycopg2.errors.UniqueViolation) duplicate key value violates unique constraint "creative_metrics_pkey"\nDETAIL:  Key (creative_id)=(6a47fed4-5e33-425c-bbc6-691c625d33a7) already exists.\n\n[SQL: \n                    INSERT INTO creative_metrics (\n                        creative_id, ctr, cpa, roas, frequency, updated_at\n                    )\n                    SELECT creative_id, ctr, cpa, roas, frequency, NOW()\n                    FROM creative_metrics\n                    WHERE creative_id = %(cid)s\n                    ORDER BY updated_at DESC\n                    LIMIT 1\n                ]\n[parameters: {'cid': '6a47fed4-5e33-425c-bbc6-691c625d33a7'}]\n(Background on this error at: https://sqlalche.me/e/20/gkpj)	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
2fc351ae-f0c2-4173-a60e-44bb95357bd1	tenant_1	failed	"{\\"mode\\": \\"explore\\"}"	\N	2026-04-26 12:57:15.340476	2026-04-26 12:57:15.340476	ai	0	(psycopg2.errors.UniqueViolation) duplicate key value violates unique constraint "creative_metrics_pkey"\nDETAIL:  Key (creative_id)=(6a47fed4-5e33-425c-bbc6-691c625d33a7) already exists.\n\n[SQL: \n                    INSERT INTO creative_metrics (\n                        creative_id, ctr, cpa, roas, frequency, updated_at\n                    )\n                    SELECT creative_id, ctr, cpa, roas, frequency, NOW()\n                    FROM creative_metrics\n                    WHERE creative_id = %(cid)s\n                    ORDER BY updated_at DESC\n                    LIMIT 1\n                ]\n[parameters: {'cid': '6a47fed4-5e33-425c-bbc6-691c625d33a7'}]\n(Background on this error at: https://sqlalche.me/e/20/gkpj)	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
4d9a3f9a-1b8b-4188-80be-ad760318e1b2	tenant_1	failed	"{\\"mode\\": \\"explore\\"}"	\N	2026-04-26 13:00:17.522387	2026-04-26 13:00:17.522387	ai	0	(psycopg2.errors.InvalidColumnReference) there is no unique or exclusion constraint matching the ON CONFLICT specification\n\n[SQL: \n            INSERT INTO creative_metrics (\n                creative_id, ctr, cpa, roas, frequency\n            )\n            VALUES (\n                %(creative_id)s,\n                %(ctr)s,\n                %(cpa)s,\n                %(roas)s,\n                %(frequency)s\n            )\n            ON CONFLICT (creative_id)\n            DO UPDATE SET\n                ctr = EXCLUDED.ctr,\n                cpa = EXCLUDED.cpa,\n                roas = EXCLUDED.roas,\n                frequency = EXCLUDED.frequency\n        ]\n[parameters: {'creative_id': UUID('083b503f-bc9a-4761-9232-985118e3bde4'), 'ctr': 1.26, 'cpa': 157.16, 'roas': 2.31, 'frequency': 2.21}]\n(Background on this error at: https://sqlalche.me/e/20/f405)	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
f4a2837c-e3ad-4425-a5c3-8eee69d5cd73	tenant_1	failed	"{\\"mode\\": \\"explore\\"}"	\N	2026-04-26 13:01:26.896877	2026-04-26 13:01:26.896877	ai	0	(psycopg2.errors.InvalidColumnReference) there is no unique or exclusion constraint matching the ON CONFLICT specification\n\n[SQL: \n            INSERT INTO creative_metrics (\n                creative_id, ctr, cpa, roas, frequency\n            )\n            VALUES (\n                %(creative_id)s,\n                %(ctr)s,\n                %(cpa)s,\n                %(roas)s,\n                %(frequency)s\n            )\n            ON CONFLICT (creative_id)\n            DO UPDATE SET\n                ctr = EXCLUDED.ctr,\n                cpa = EXCLUDED.cpa,\n                roas = EXCLUDED.roas,\n                frequency = EXCLUDED.frequency\n        ]\n[parameters: {'creative_id': UUID('083b503f-bc9a-4761-9232-985118e3bde4'), 'ctr': 0.95, 'cpa': 162.09, 'roas': 1.06, 'frequency': 2.75}]\n(Background on this error at: https://sqlalche.me/e/20/f405)	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
96a16bbe-3b06-4f77-8bc6-eed8fefa2363	tenant_1	completed	"{\\"mode\\": \\"explore\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 13:17:53.30718	2026-04-26 13:17:53.30718	ai	0	\N	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
f079e77d-a5fe-470d-963b-61f87d43707a	tenant_1	completed	"{\\"mode\\": \\"explore\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 13:06:36.246658	2026-04-26 13:06:36.246658	ai	0	\N	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
31597b62-cf31-469c-9d7b-e2fd71b226b0	tenant_1	completed	"{\\"mode\\": \\"explore\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 13:06:41.988311	2026-04-26 13:06:41.988311	ai	0	\N	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
668ced5f-5efa-47f1-957e-9b8eb61cc211	tenant_1	completed	"{\\"mode\\": \\"explore\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 13:06:43.58457	2026-04-26 13:06:43.58457	ai	0	\N	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
b882d6b4-331b-45d3-a133-8e3db19b8fc7	tenant_1	completed	"{\\"mode\\": \\"explore\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 13:17:49.204446	2026-04-26 13:17:49.204446	ai	0	\N	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
932668df-ec2e-452f-9b02-49271a3dce38	tenant_1	completed	"{\\"mode\\": \\"explore\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 17:46:15.921501	2026-04-26 17:46:15.921501	ai	0	\N	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
54e7a804-78ea-42d0-9836-09c342b7939e	tenant_1	completed	"{\\"mode\\": \\"explore\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 13:17:50.298736	2026-04-26 13:17:50.298736	ai	0	\N	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
aaeb6773-c29d-44e4-928b-1d990ba7c5f1	tenant_1	completed	"{\\"mode\\": \\"explore\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 13:17:51.436358	2026-04-26 13:17:51.436358	ai	0	\N	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
4177606e-20ae-47d3-94f8-b6a271a58b56	tenant_1	completed	"{\\"mode\\": \\"explore\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 13:17:52.506337	2026-04-26 13:17:52.506337	ai	0	\N	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
78ebf00b-1dfa-491e-afd6-3b104eb99adf	tenant_1	completed	"{\\"mode\\": \\"explore\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 17:46:17.090654	2026-04-26 17:46:17.090654	ai	0	\N	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
56f04bb3-a076-4490-ad04-a69c8278d397	tenant_1	completed	"{\\"mode\\": \\"explore\\"}"	"{\\"status\\": \\"success\\", \\"mode\\": \\"generate_creative\\"}"	2026-04-26 17:46:19.21609	2026-04-26 17:46:19.21609	ai	0	\N	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103
\.


--
-- Data for Name: learning_insights; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.learning_insights (id, pattern, confidence, created_at) FROM stdin;
\.


--
-- Data for Name: learning_memory; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.learning_memory (id, policy_id, outcome, latency, created_at) FROM stdin;
b6ea0b31-f766-4089-974b-b7b258acd0cd	95753f89-22e1-4d5e-b82e-7a3655a90ee8	t	1075	2026-04-23 10:55:00.332286
6d171dae-896d-46c2-a834-0f005ac581da	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1073	2026-04-23 10:55:32.538483
fdd573a7-36f7-4a26-9179-40ddcfb5bb99	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1308	2026-04-23 11:18:11.073232
06af1824-9fb4-48cb-bce8-6995ca143363	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1281	2026-04-23 11:18:14.773234
8440fadf-a73c-4f47-9c1e-847277914a5c	344b884c-f5f1-4d83-9356-b509480822e6	t	1347	2026-04-23 11:18:19.394153
0b25f32b-d1e4-490b-98f2-f10337265433	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1055	2026-04-23 11:49:52.769535
521f2bbd-f14e-4137-b6e7-6ff5c7b3b4a2	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1057	2026-04-23 11:50:17.947152
bb970a11-6f0c-43fb-be11-c33d988fb56a	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1056	2026-04-23 12:05:18.92895
ef4d595f-6b7a-4b7e-b661-9ce9e4883842	cee6563f-766e-460d-8b29-837f2fac0756	t	1075	2026-04-23 12:05:21.528306
90ef137f-1340-41da-bfb6-97068d101583	15cc7c08-c1cc-4801-95c7-265a6f2ea8f8	t	1050	2026-04-23 12:05:24.502004
b55c9a29-1d53-440e-8062-7c8fb5f0db4d	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:39.495845
a6233086-b0d6-4bf8-a7de-feccdb55c901	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:41.111315
26d6c255-df72-4c4d-93a8-04daca4c55d0	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:42.338883
e15d1fef-c11f-4ebb-9a26-9c336d4d956f	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:44.72566
8d6451ff-72ef-4829-86eb-c96f417aee52	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:46.371259
330c7c02-8e6e-440e-8a0b-c542355598d5	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:47.816874
c8b400c4-c073-40a9-b7c2-765a41c30db9	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:49.807886
6099bd18-e161-4371-91fa-14cd7433725f	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:51.444824
97d4e893-d877-4f1a-931a-af336709beaa	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:52.540267
f9f06080-f6d0-46b8-a893-69912c7a4e09	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:53.736445
d83e9da7-3815-4cfa-a91c-007c544f536e	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:54.89143
6c478e42-7a2c-4421-b74a-82a9ef1bea96	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:55.994093
f797fe25-3c33-44f4-86ce-add1687f12b4	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:57.027957
6fac4ba6-14f5-4422-8a3d-646be07177ce	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:58.090775
d7b67300-0161-48c6-843d-5d5b4a29ee6c	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 13:13:34.604827
4c4464a3-0dc5-4475-abb0-0ead7df71583	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 13:13:45.631789
0ca77103-2969-43df-9718-9ce3835a4128	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 13:13:48.095257
f2528aaf-e283-4722-b392-f64870fe7eaf	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 13:13:49.797711
b42861aa-e100-4ed9-adce-cf01fb0877ae	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 13:13:51.041561
787cd29d-2896-4be6-8625-1e6711f901c5	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1625	2026-04-23 13:19:14.445105
c9722fd8-1688-4ac0-bad6-f28b585f7c67	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1584	2026-04-23 13:19:28.213681
41fdafe7-4387-4ef0-8211-d1f21c686aab	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1596	2026-04-23 13:19:30.636389
a1f9849e-b803-4b2b-ae46-fb0e41ee7981	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1587	2026-04-23 13:19:33.150072
51d13ca8-d26d-46f8-8235-a8004b3f7331	d44e31d5-ddcb-432e-b457-6847aec0e070	t	587	2026-04-23 13:19:34.615662
f81bffb7-6f3d-4fb5-bb15-00f417d8aaf1	d44e31d5-ddcb-432e-b457-6847aec0e070	t	582	2026-04-23 13:19:36.043711
e027907e-8a91-4c51-9ba4-8fd3f3bc4809	d44e31d5-ddcb-432e-b457-6847aec0e070	t	582	2026-04-23 13:19:37.591932
ad0fa8a3-863c-443d-93a9-ac056dc65fcf	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1085	2026-04-23 21:27:23.365601
ea1a5ebb-77e7-4aa4-826c-8fff345f71ee	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1083	2026-04-23 21:27:25.692938
cbc62e83-bd62-4846-bd88-64bc261102d0	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1084	2026-04-23 21:27:27.617125
cd3a7a9a-c0bf-495f-b405-8021d5f3c4f6	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1089	2026-04-23 21:27:36.444926
343519ee-675c-4d25-98d9-cc84169288ad	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1081	2026-04-23 21:27:38.365483
1e55186c-57c6-479d-afac-41ad95ebdff8	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1083	2026-04-23 21:27:40.307997
53510250-db97-4a18-82e0-489aafc2e863	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1081	2026-04-23 21:27:42.182546
a64bd9d9-aa9b-4d73-b576-b6c2bc79e620	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1090	2026-04-23 21:27:44.085937
220d0ce7-1813-41a7-ad56-e0c0169bd9ce	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1082	2026-04-23 21:27:47.657208
0bf1896c-da23-49cd-86ce-389bb6f4ee37	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1081	2026-04-23 21:27:49.532475
036ab6ac-cf70-4fd2-9302-a3f13b59b51a	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1082	2026-04-23 21:48:45.4295
65c0fa51-35fc-4552-871b-c6dd6cec99ea	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1081	2026-04-23 22:08:54.930671
69fe0a77-01b0-44cc-8ecb-d935a4226cce	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1089	2026-04-23 22:08:57.516733
9b70f185-7be2-482e-8cca-c4f52166a46c	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1076	2026-04-23 22:09:00.267938
4ded4fd9-0556-49cd-a6c2-2db99bc99c86	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1080	2026-04-23 22:09:02.489542
0a77686f-47d3-463d-ae24-e53e27361b25	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1080	2026-04-23 22:09:04.46733
f5d02585-9e8b-44d5-8cca-6a17c6ab5f84	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1079	2026-04-23 22:09:06.330209
c3eedb29-c035-4bc6-879f-73547aed07c2	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1077	2026-04-23 22:09:08.444522
d69e6137-48a3-4bd8-b140-e5fa824fdc02	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1093	2026-04-23 22:20:16.147654
c039ca93-e37e-40c3-a87d-d2fe492be5a3	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1086	2026-04-23 22:20:19.601736
451f0ccc-5929-4f48-a034-9ede00cbe7b1	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1080	2026-04-23 22:20:21.437039
9c491377-e85d-4fc6-9600-7900ccd9843e	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1082	2026-04-23 22:20:23.467431
9daaa422-27fd-49c2-ba0d-354fbf8e81a3	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1078	2026-04-23 22:20:25.287181
7f52e285-d058-454e-a788-429f948a1d23	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1083	2026-04-23 22:43:18.32549
4e367695-5925-4023-8303-cb1b8f0c9e44	0c2561d1-e194-4793-bfca-7044307d7e5f	t	1098	2026-04-23 22:43:20.284367
b80d1a75-80f2-4ac1-9972-8892cafaadd0	63c9599e-61be-4162-8502-fe5c6ce6ac39	t	1099	2026-04-23 22:43:22.466253
2d79ec24-7421-41c2-8435-af954498dc87	61583d2b-3f7a-4eaf-bb2f-785fa0bd83a9	t	1096	2026-04-23 22:43:24.860822
964a4348-8a1a-4fba-861b-0d15d467bd73	335c5c6a-1a88-415a-bc49-a760889d9297	t	1082	2026-04-23 22:43:26.822672
6ee29d9d-510f-4353-8259-a6d2bcaa408b	8ed287c8-7ec7-4e21-864d-3da6d4595c0d	t	1084	2026-04-23 22:43:28.739086
2e58ef95-c19f-4512-ae27-ce6fa0522fa3	cb089a3a-13a9-422d-a95f-f87730f44e78	t	1056	2026-04-23 23:46:48.755471
7c4c3118-e72d-42f0-8b1f-e4de94661cec	23afd7d5-47a4-40f5-b405-37caf091796a	t	1088	2026-04-24 00:21:05.48442
b8c88c5f-31ee-40b1-b0cc-fbda7377194e	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1084	2026-04-24 00:46:45.037328
bd4af4c4-a18d-450a-9d0c-d036bcc3a7a8	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1100	2026-04-24 00:52:43.176954
643ae4d5-71cc-46a5-a525-402ed27edf28	ffadab01-5d5a-4ed7-a4d7-fa35ce3feb7d	t	1077	2026-04-24 00:52:44.970221
ccf18ca7-2998-49e4-84ae-99d7fd54b96b	9f1e02e2-eba0-4ac9-965c-8d6170267fab	t	1084	2026-04-24 00:52:46.877373
70a05048-8462-4dbf-ae7e-d395fffb9fdf	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1078	2026-04-24 00:52:48.800052
ef6df713-67c3-464d-bb33-d7d22b99badc	cf08168d-22ef-465b-883f-f2392036b1a7	t	1081	2026-04-24 00:52:50.75345
4b34e911-dda0-441d-b154-b521682f88b6	19c2264c-5bd3-4f27-b66b-855f40a81830	t	1102	2026-04-24 00:52:53.120093
4db81882-9e39-4c11-964b-ecf3ad4364d6	a2c53d62-d5e3-4597-b2b4-9487cb801909	t	1087	2026-04-24 00:52:55.141026
9f79eae5-ab4a-477a-ae16-ba88458ee0ac	133de373-d757-4e31-8932-1de0179ea366	t	1104	2026-04-24 00:52:57.11915
e4d7ca48-d741-49d4-8e05-78deb861a881	49e4c548-89d1-446e-9545-9d4e8e91a83e	t	1075	2026-04-24 00:52:59.294507
b803fb22-f735-45af-a8cf-7dedd6aad928	5717693c-a9dc-4bc8-8811-c1a346cc39bb	t	1163	2026-04-24 00:53:02.01936
a6bfd9c1-7e17-40c8-8002-e22fa2f1e406	9a446794-c9cc-4db0-8fda-d563f7563935	t	1100	2026-04-24 00:53:03.98612
72bbed91-fc1c-4b3a-89b3-aacba911ff88	c6d0a662-a4a7-4e2e-af8b-edbbd1de8a45	t	1090	2026-04-24 00:53:06.028911
ee1f53c2-9c32-4213-b33b-d86529170898	4ce5c0c4-def1-453f-853c-a4ded1256705	t	1075	2026-04-24 00:53:07.89058
e6771eaf-2504-4787-b6af-e7373cf0b413	633b552c-bab5-4ac1-b845-24cff0b4db63	t	1078	2026-04-24 00:53:09.772521
0b8e0898-4814-476e-9e5a-795457a28203	b1ea5268-3cb9-41bd-94e0-16fa770908cb	t	1081	2026-04-24 00:53:11.709491
840cf3cf-55c1-400b-bef9-4529e7a0d16f	55255ebc-68f0-409a-b7be-9754d1babb74	t	1083	2026-04-24 00:53:14.023036
6dfa51c6-f496-4ca0-8576-cf36963ee3b9	67782314-f2d4-446c-b344-e405f8151e8f	t	1093	2026-04-24 00:53:16.227318
854b3335-7e10-4eb9-a7fc-6a764a0b3937	a801e65e-d157-4b78-88a3-ad1d2133418d	t	1072	2026-04-24 00:53:18.169084
ee3998e6-328f-423d-9ff8-b8d952b588d7	fb9d4be5-8328-4b41-b486-eb658a4f320b	t	1077	2026-04-24 00:53:20.117931
8619b4f8-4d41-474c-a4db-b62027953a10	9f06f56f-d1e3-4fe0-9dd0-f376e3b5859b	t	1075	2026-04-24 00:53:21.909294
3d78e760-e5f6-43c9-8fea-ab9588de3a3c	232e69f2-7c5a-4338-acf6-780dfeeeb8c2	t	1104	2026-04-24 01:28:24.751718
48859764-7bc3-4c83-97e8-2dacdd4f7f7e	47004496-511f-4ff8-ab44-0f8251a3e56f	t	1084	2026-04-24 01:28:27.024316
12428ed0-a7a1-4417-9b6e-c507cc3ba86a	60c4d433-ebb4-478d-8e6d-cb1cf8b4d65d	t	1080	2026-04-24 01:28:29.27619
f354914d-5f04-4168-97a5-2d27fe061de5	1cee6e52-3278-426c-903c-d697aa3c1a8c	t	1083	2026-04-24 01:28:31.324717
147d3747-08df-4022-8aac-c3dbfd05289b	992857cb-54e4-4314-82b3-dd44cf59613d	t	1087	2026-04-24 01:28:33.570479
9ca7211f-eb30-41b5-a1c3-a886eae52ae4	23e82e6a-5f1d-4e3a-ba0e-11c5896e4026	t	1099	2026-04-24 01:28:35.827357
68285a4d-1e55-46ed-b1c2-1ee160e503bd	7346ffbf-257d-4b87-8adf-a154cc386933	t	1088	2026-04-24 01:28:38.037658
74686352-0183-432d-85d2-822d1ba0fa01	2cd962c2-e25a-42ab-88ee-f9dcac391339	t	1099	2026-04-24 01:28:40.291295
e78cc4b6-2a16-467e-ad70-ad6a389a7bbd	849d5726-d2bd-4992-b953-4eb295d78b74	t	1091	2026-04-24 01:28:42.429092
bd570b0c-4dc5-4442-9138-d860eabed3fb	b18d7623-bdc8-41b4-bb23-61fb0a51b857	t	1081	2026-04-24 01:28:44.361511
8777c102-fdb2-4f7f-abc2-43e863c3e434	63cbac38-6662-4984-9e54-f9b2566b7633	t	1082	2026-04-24 01:28:46.374659
ec4f5558-bce8-4b59-b8d7-78d4452453c5	cf5d755d-a355-4faf-b654-6074e043a9a2	t	1085	2026-04-24 01:28:48.478538
9318caea-37bc-4b2e-999a-36f7791b1485	19c2264c-5bd3-4f27-b66b-855f40a81830	t	1097	2026-04-24 01:28:50.759517
e990febd-bbe1-4027-a449-d833881c42a1	a2c53d62-d5e3-4597-b2b4-9487cb801909	t	1081	2026-04-24 01:28:52.975557
0a300508-4ea2-4acb-a8c1-7476cd040338	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1082	2026-04-24 01:28:55.284436
27c268b2-9629-4510-9398-90960f5a96f9	133de373-d757-4e31-8932-1de0179ea366	t	1114	2026-04-24 01:28:57.565562
ccf9a02f-d59b-4175-9065-126699114488	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1084	2026-04-24 01:28:59.950603
0df27d45-95f3-45f3-b592-fcce7a462a01	1ba64459-214c-4257-87cb-707d82abbcdc	t	1087	2026-04-24 01:29:02.032738
bed80a6b-8d5e-429e-b75f-4215587417d4	9f1e02e2-eba0-4ac9-965c-8d6170267fab	t	1082	2026-04-24 01:29:04.302385
e8a1a484-c47e-4257-bd70-36a0499e0e82	9f1e02e2-eba0-4ac9-965c-8d6170267fab	t	1098	2026-04-24 01:29:06.579613
16f87a96-75ac-442e-859c-cdfed8dfdc63	36c09f80-929d-4137-a8f0-ce0fe0e35dd4	t	1157	2026-04-24 01:48:32.337491
2ab54020-06dd-4a59-8b3c-e3c97010b11b	7de00605-784a-4322-9f59-89e2b83838c2	t	1113	2026-04-24 01:48:34.854839
052e7098-ae6b-4cb7-9ec8-68239364ae56	ce6ca3dd-00b4-4376-b91a-891ea3ec5e18	t	1132	2026-04-24 01:48:37.074993
f5ade92f-9593-40b7-a92f-392dbd8263c4	2a00557b-a245-462c-bfe6-dcf34598a5da	t	1107	2026-04-24 01:48:39.182998
3e492a8d-fd03-4204-89ad-99041ccce4e0	9597531d-b911-4fa7-ae31-35790fcfdce8	t	1084	2026-04-24 01:48:41.172581
6ee4692e-7e53-4a13-a84f-d8da41b6fe98	e2c414c2-a2ae-47c0-90e7-ec69df21112b	t	1085	2026-04-24 01:48:43.248444
088a8f8d-fcb3-4ebe-ad8e-4f87611c2b4b	b37e536a-8290-43b4-bf1f-4756dc34a7be	t	1081	2026-04-24 01:48:45.469747
8069d5ac-a6c4-42e5-a600-6320baaa91db	7de00605-784a-4322-9f59-89e2b83838c2	t	1085	2026-04-24 01:48:47.894828
8aa85459-5d64-43d3-be1a-e2da477fa14e	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1088	2026-04-24 01:48:49.96526
4cc8e8c9-6757-49b6-a548-1f75eafb16d9	54b45389-2af3-4740-ab70-d0b44252aeae	t	1097	2026-04-24 01:48:52.253271
a8c6251d-6f4c-4de2-9cfa-ed2789237082	e999c7bf-195a-4a3c-aa82-ca1afbdf8414	t	1136	2026-04-24 01:48:54.781012
fdd3b87e-16d1-402e-90ee-5e6cc8d734f9	9aae50bf-c437-4c5c-8ee2-be11616f31d8	t	1085	2026-04-24 01:48:57.037898
db42db20-83be-4ff8-92b7-4380c6ad69f2	30a5f88e-3c8b-45fc-aa4f-cdb518d97980	t	1088	2026-04-24 01:48:58.992526
26e44aa5-3084-4ffa-957d-188724c112ea	9bc21cd9-d678-4419-8340-17f2f3d6cb3e	t	1085	2026-04-24 01:49:01.340087
ac7e7f01-f3e8-4e48-8236-ac958d2d650e	354041a1-c8fa-4717-8a72-2663ceca0b20	t	1085	2026-04-24 01:49:03.88129
db4ddadc-2d66-4990-86cf-d771fa76b1b9	7de00605-784a-4322-9f59-89e2b83838c2	t	1094	2026-04-24 01:49:05.860687
b4bcdb9a-bf39-4915-a30e-d657f41327bf	9f1e02e2-eba0-4ac9-965c-8d6170267fab	t	1085	2026-04-24 01:49:08.210831
53e6fa56-13e1-42a9-99b8-44864e21705c	ce6ca3dd-00b4-4376-b91a-891ea3ec5e18	t	1162	2026-04-24 01:49:10.646203
98ae70b0-5ca6-4333-aa8a-007374a4d6d8	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1084	2026-04-24 01:49:12.780568
d05205d2-4fba-4056-a73e-a8ec701fcd02	7de00605-784a-4322-9f59-89e2b83838c2	t	1098	2026-04-24 01:49:15.046912
cd212987-4d92-4374-9be8-d3e2a8e1f816	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	643	2026-04-24 10:47:52.835396
090f3a44-7c50-40d6-a316-4396f31069ef	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	596	2026-04-24 11:49:51.612922
9f5d3418-8429-4e5e-a19f-3b653c8f6daa	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1094	2026-04-24 13:38:45.574551
2cde45ad-7e39-4fff-b51c-7afd9ff77594	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1056	2026-04-25 08:01:47.614713
b056226c-da16-4f53-b52a-7fc254a45b99	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1089	2026-04-25 08:41:05.082509
0e815f3c-2e12-4753-b658-d5a6f9f5a7ce	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1089	2026-04-25 08:48:37.412166
cf30f0f1-045c-48b1-ad10-f773c08f87f6	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1082	2026-04-25 10:41:16.538891
7f28a9e6-bb7a-42ad-85ac-2208404bcb47	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1281	2026-04-25 10:46:26.517561
e12a9ed2-b81c-4700-8278-b792c7cd174c	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1084	2026-04-25 11:24:22.852807
62b26b72-b9c1-4e29-9f0b-65c5514c2545	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1198	2026-04-25 11:28:56.99507
aea43cf1-e4c5-477b-938d-83acf328708d	cf08168d-22ef-465b-883f-f2392036b1a7	t	1088	2026-04-25 11:40:25.987082
a1ea9418-97e7-4884-bfb9-c58cf91076eb	9f1e02e2-eba0-4ac9-965c-8d6170267fab	t	1086	2026-04-25 11:41:29.543977
5200e60c-e9de-4d6e-b135-b8e6fbadfb11	19c2264c-5bd3-4f27-b66b-855f40a81830	t	1095	2026-04-25 11:48:46.560112
5ff32120-149c-4b0f-b3ab-98929c5a4d94	a2c53d62-d5e3-4597-b2b4-9487cb801909	t	1097	2026-04-25 11:48:49.302501
2110f424-4e56-411f-8099-349e8dee12a5	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1091	2026-04-25 11:48:51.399946
8310cd01-ae6b-42f9-b2f6-1f14a8943036	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1082	2026-04-25 11:48:53.488965
d666b78f-0499-457c-98cb-b18e25ce6abe	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1082	2026-04-25 11:48:55.786946
674d960c-fdef-4973-90ca-a877b1bed2b8	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1060	2026-04-25 12:01:29.259001
0c358652-1b6f-4179-9c49-d65185afd7a8	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1061	2026-04-25 12:01:30.867955
8b76d7a1-8f28-40f4-a14f-4d6e02bff036	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1058	2026-04-25 12:01:32.469281
41974391-d352-4ccb-8786-202cb6a750db	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1062	2026-04-25 12:01:34.057055
ccbc86cd-04b6-48c0-b3d9-a6e879396c39	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1059	2026-04-25 12:01:35.675236
0d3a807d-e307-4b21-bb53-6d7408e2b54f	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1062	2026-04-25 12:23:52.560305
5a99fb7e-dc43-4a11-a2b7-07d2c1117cf5	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1059	2026-04-25 12:29:46.190898
9104bd6e-f355-40b9-ae07-4ce61a7d0108	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1087	2026-04-25 18:42:59.208604
08358609-69aa-4ac4-8c16-36c8693243f4	129a8c8d-54b1-43f9-a7c2-75993315998a	f	107	2026-04-25 19:18:24.544824
94043adb-11b5-459e-9c28-dff35664f221	129a8c8d-54b1-43f9-a7c2-75993315998a	f	196	2026-04-25 19:24:20.440959
4b7c5dea-a8da-4b76-9c35-5486f4fb58a3	129a8c8d-54b1-43f9-a7c2-75993315998a	f	95	2026-04-25 19:30:25.315792
3465610e-008f-4a15-b23f-59e7d487f806	129a8c8d-54b1-43f9-a7c2-75993315998a	f	83	2026-04-25 19:33:42.457268
ad9966be-f756-4f1f-9f0e-d897e2055ce9	133de373-d757-4e31-8932-1de0179ea366	f	84	2026-04-25 19:34:25.296204
bd1e1cd0-4409-495a-9496-8ae31ef91c91	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1186	2026-04-25 20:11:27.498671
cfb2e527-994e-49d9-8f44-eda7a521eba5	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1528	2026-04-25 21:49:28.297234
b483f8e4-ad35-4089-98c7-607f5cea56d9	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1514	2026-04-25 22:16:44.417839
12a94219-dcc1-48c0-bb39-8bcf7d05df86	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1956	2026-04-26 07:32:35.074651
919e1a7f-878b-44cb-9ba2-11a2cb28fa72	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1174	2026-04-26 11:04:20.554031
94a2e722-e2c4-4e9f-bf61-8f07f624d27e	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1151	2026-04-26 11:04:23.214245
038a218e-60f9-49ef-84bb-63ead7ef4ced	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1185	2026-04-26 11:04:26.045781
cefb2071-720c-4655-ba2b-2f75a7d0b189	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1154	2026-04-26 11:04:28.84547
bd41fa17-26ea-4ce6-a0ab-01a8ef302322	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1160	2026-04-26 11:04:31.487024
7c503017-69bd-432a-8ce3-3ce91b265d85	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1134	2026-04-26 12:07:42.69257
4262955c-fe7e-47eb-a6ea-fd76323fd313	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1133	2026-04-26 12:07:46.540131
981fa44e-3f87-40ad-a566-92ad4bcd067e	ce6ca3dd-00b4-4376-b91a-891ea3ec5e18	t	1125	2026-04-26 12:07:48.973686
fa020150-6947-42d4-a4eb-587d829ed116	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1080	2026-04-26 13:06:38.285112
0e54c9a8-8565-4fb0-bc86-eca5246180b4	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1064	2026-04-26 13:06:43.75705
d8a089bb-0661-4419-803b-39318e6486d2	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1068	2026-04-26 13:06:45.596321
213d7902-fd94-4d5f-8d7b-fc9338c8af4f	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1068	2026-04-26 13:17:51.076429
d879221f-4cbc-4f28-b55e-d98f32e994d8	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1067	2026-04-26 13:17:52.886573
8ca2a29c-d3ce-46cb-bd18-32e6fc8bb5cd	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1068	2026-04-26 13:17:54.707694
e53feaf7-e75e-4369-b47e-42c7637fca00	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1068	2026-04-26 13:17:56.512735
8bc5c9c3-262d-4e92-a335-97cf2d401853	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1074	2026-04-26 13:17:58.364061
3aefedf7-80cd-4a84-bc07-e8953cea7b64	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1141	2026-04-26 17:46:18.938442
fea573d5-e3d9-4adb-b877-c36fa5fb2c5d	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1093	2026-04-26 17:46:21.734509
0c470580-c679-4e49-ba5a-7d8558a045e2	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1106	2026-04-26 17:46:24.577519
\.


--
-- Data for Name: outcomes_log; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.outcomes_log (id, policy_id, success, latency, created_at) FROM stdin;
7fce4a57-c4cc-4a56-be56-6bcb2df61330	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1308	2026-04-23 11:18:11.048813
c68b87a5-b6a2-4a8b-8de7-2c22ebd48240	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1281	2026-04-23 11:18:14.748064
254e8f69-4b23-49a7-b281-4dd66d8b30cd	344b884c-f5f1-4d83-9356-b509480822e6	t	1347	2026-04-23 11:18:19.369646
d82ea7b5-7be1-455d-a84b-3405b1483ad6	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1055	2026-04-23 11:49:52.75151
372f816a-8554-4243-b042-94c0595811e5	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1057	2026-04-23 11:50:17.931709
b7d4bd22-f3b7-4d2a-a366-70209d252625	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1056	2026-04-23 12:05:18.906665
214264f5-63fa-4407-9c37-adf9717105ce	cee6563f-766e-460d-8b29-837f2fac0756	t	1075	2026-04-23 12:05:21.304914
0a3928ce-abd1-4803-b3c1-5f1c31267a0e	15cc7c08-c1cc-4801-95c7-265a6f2ea8f8	t	1050	2026-04-23 12:05:24.476511
38f15eee-8cb2-4a02-8962-0bb20b56efc4	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:39.476828
62a6263f-560e-4bc4-b6e3-760f8ec58e94	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:41.09496
4ee49bec-f805-4dba-946b-8ab22d0fa232	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:42.324377
f858462f-2e0c-4ff1-ab93-c524527c5a47	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:44.711782
6f39a932-43ac-43ce-bf72-c2d7cbd4e041	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:46.354193
6d028e93-bde2-4d8f-9c59-8dff7554c0d2	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:47.806965
1a1d60c8-6fa2-4461-87e0-64a9f8008ed1	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:49.800069
537f471e-9bbb-4942-86d8-3c37706ffcb5	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:51.433563
2faa0452-98e8-4d3c-b142-87fbc72995f0	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:52.52776
8645e049-29e6-45f1-8a48-55477074a9f2	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:53.727988
c873d72f-d0dd-44c4-bc40-65be6ea8407c	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:54.882969
237fc52c-7fbf-4935-9b97-170bb0dbeaa8	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:55.986851
6be2dc17-102f-48b2-8731-6b375679f704	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:57.019969
31fc4230-aa0f-4808-b6ae-987eb7e7933d	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 12:47:58.082162
4d66c6a7-2494-4e7d-a45f-bf938a2b195d	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 13:13:34.594926
1d5d3698-ad98-4ce4-b30b-f08379c67e9a	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 13:13:45.623021
fbf4c00e-deee-4d0a-b934-4256e77b62b6	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 13:13:48.087274
e74e63b3-6b69-4c2e-b979-11cb6272184e	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 13:13:49.789254
c5573c2f-4c56-4cd9-95f7-96ce2bc94935	d44e31d5-ddcb-432e-b457-6847aec0e070	f	0	2026-04-23 13:13:51.033799
9674b0bd-2886-40b7-ae13-82f140e1f077	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1625	2026-04-23 13:19:14.417697
148929dd-0ff0-4e26-ad80-565872cc68c3	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1584	2026-04-23 13:19:28.168627
8392162e-ff5c-4077-b743-37cf2ae9b411	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1596	2026-04-23 13:19:30.612869
557b6827-6750-4ce8-bd08-4e8094cee87d	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1587	2026-04-23 13:19:33.126665
0178b323-9580-464e-b7e5-ae0fc41bbdc6	d44e31d5-ddcb-432e-b457-6847aec0e070	t	587	2026-04-23 13:19:34.591367
14959afc-1ba4-4902-b2f1-f6b9b403f299	d44e31d5-ddcb-432e-b457-6847aec0e070	t	582	2026-04-23 13:19:36.021694
a7d49b85-7544-436d-9449-f4113a6759c0	d44e31d5-ddcb-432e-b457-6847aec0e070	t	582	2026-04-23 13:19:37.578596
252307aa-2288-4e64-9291-d44512d63f12	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1085	2026-04-23 21:27:23.335207
2755b14d-948f-4d2e-9428-f4cb396efbe3	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1083	2026-04-23 21:27:25.67048
d4bc2713-4cf6-4b88-b5b5-c2f1fd88baf7	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1084	2026-04-23 21:27:27.59162
dc2779cd-70cf-4b0e-8007-d7a6085b5eb2	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1089	2026-04-23 21:27:36.420995
85b06044-f2c6-43a2-99bc-96e9f853e9ef	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1081	2026-04-23 21:27:38.341292
dadc0763-1c62-425f-befe-189d37c218b6	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1083	2026-04-23 21:27:40.284868
847e51be-646e-4bdd-8e6c-fdaabf7f8499	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1081	2026-04-23 21:27:42.156546
9e6ad59e-98a1-438a-ab79-d25b86109ffc	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1090	2026-04-23 21:27:44.062146
50ffa30d-99e6-4857-9337-0c4a45291a6c	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1082	2026-04-23 21:27:47.632776
6d2e6533-843a-4952-8b22-b2edba92958d	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1081	2026-04-23 21:27:49.507543
1b6c914f-bbff-478f-a019-6e8f92af95f2	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1082	2026-04-23 21:48:45.408387
a4a3cae5-086d-4cd1-8b9b-4572224eabd6	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1081	2026-04-23 22:08:54.90163
a9c1cb9a-39d7-4ab7-ba03-645e427d7f35	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1089	2026-04-23 22:08:57.506193
49035557-b5d6-4fcd-b63e-bba77f9d3f4d	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1076	2026-04-23 22:09:00.243378
37e803f2-8480-46b1-af5d-de4f7b116a54	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1080	2026-04-23 22:09:02.466726
acd962e3-4e07-403a-b80e-81a57800f571	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1080	2026-04-23 22:09:04.445365
1260dfae-b56f-45dc-aceb-a7592fecaf9d	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1079	2026-04-23 22:09:06.307092
1b43bbf1-3437-4e39-9273-ad959a4332c0	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1077	2026-04-23 22:09:08.420903
a20ae005-0651-402e-acf8-fdd694b64dc7	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1093	2026-04-23 22:20:16.11756
bda83736-6a88-4fc4-b59f-4f5db7e552de	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1086	2026-04-23 22:20:19.574271
bf003b3e-22d4-472b-8116-c2da825497c1	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1080	2026-04-23 22:20:21.412069
992eb31a-baef-4f1c-8fdb-2e0a97e68779	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1082	2026-04-23 22:20:23.435335
67c5efa5-cffd-476b-aee4-20d40886d860	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1078	2026-04-23 22:20:25.263436
9a94ad25-20ec-4657-b407-2883593f28ca	d44e31d5-ddcb-432e-b457-6847aec0e070	t	1083	2026-04-23 22:43:18.301139
9acee391-c66c-4500-ac81-1d5a683ef8d0	0c2561d1-e194-4793-bfca-7044307d7e5f	t	1098	2026-04-23 22:43:20.263097
d9fa64d8-2c60-4c62-9f65-71e6e63eecd6	63c9599e-61be-4162-8502-fe5c6ce6ac39	t	1099	2026-04-23 22:43:22.448434
813c5522-caae-42dd-8bd8-4c45fb0e93bb	61583d2b-3f7a-4eaf-bb2f-785fa0bd83a9	t	1096	2026-04-23 22:43:24.839818
fde138a5-44cd-4278-b976-4217bc65096b	335c5c6a-1a88-415a-bc49-a760889d9297	t	1082	2026-04-23 22:43:26.781523
56c2db9f-f838-44fb-92fd-710df9c74e93	8ed287c8-7ec7-4e21-864d-3da6d4595c0d	t	1084	2026-04-23 22:43:28.715675
8b9858f9-e85a-4dd1-8c7a-e259f43957ca	cb089a3a-13a9-422d-a95f-f87730f44e78	t	1056	2026-04-23 23:46:48.743712
46e554cb-3103-4004-8987-1fa3267b11ca	23afd7d5-47a4-40f5-b405-37caf091796a	t	1088	2026-04-24 00:21:05.460561
b86cc5fb-c014-4249-bb16-de2c57cf4578	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1084	2026-04-24 00:46:45.0121
577372cf-3bfc-47bc-a741-74aec27c372e	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1100	2026-04-24 00:52:43.148674
c5ae6be3-2e8a-40bc-91bb-5dd7de0ada6e	ffadab01-5d5a-4ed7-a4d7-fa35ce3feb7d	t	1077	2026-04-24 00:52:44.953799
908b1c58-5695-4d3f-92c4-e5f5ee46f205	9f1e02e2-eba0-4ac9-965c-8d6170267fab	t	1084	2026-04-24 00:52:46.858381
a35e818d-5aac-4f96-9b45-1dcac390ee1b	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1078	2026-04-24 00:52:48.780346
b23f7a62-e8e2-4fb8-9c47-61911999778f	cf08168d-22ef-465b-883f-f2392036b1a7	t	1081	2026-04-24 00:52:50.724221
fe6533a6-e35c-420a-a2c4-3b9a33f312d1	19c2264c-5bd3-4f27-b66b-855f40a81830	t	1102	2026-04-24 00:52:53.090093
a5343b28-b142-48f9-85e0-8b08c5b17146	a2c53d62-d5e3-4597-b2b4-9487cb801909	t	1087	2026-04-24 00:52:55.131948
e02f9939-4aeb-4f03-8def-9a676d6bf68b	133de373-d757-4e31-8932-1de0179ea366	t	1104	2026-04-24 00:52:57.100577
740e3b3f-1918-4c68-9b0e-00c02e00586e	49e4c548-89d1-446e-9545-9d4e8e91a83e	t	1075	2026-04-24 00:52:59.278241
6435e02e-5fb3-4d6d-bc59-2478cea51b46	5717693c-a9dc-4bc8-8811-c1a346cc39bb	t	1163	2026-04-24 00:53:02.004507
9744c9ca-1da9-42ba-a61a-59dd28dc3bc9	9a446794-c9cc-4db0-8fda-d563f7563935	t	1100	2026-04-24 00:53:03.976776
186d756d-d1ac-4778-ad5f-cd11930b6d54	c6d0a662-a4a7-4e2e-af8b-edbbd1de8a45	t	1090	2026-04-24 00:53:06.014027
b8687535-f7a1-4acf-8c5f-6082edecaed3	4ce5c0c4-def1-453f-853c-a4ded1256705	t	1075	2026-04-24 00:53:07.874019
a9559855-6952-47e6-aa8a-8bd27653d0e9	633b552c-bab5-4ac1-b845-24cff0b4db63	t	1078	2026-04-24 00:53:09.756913
1b241598-56a1-4c76-989e-f2f10b2283c5	b1ea5268-3cb9-41bd-94e0-16fa770908cb	t	1081	2026-04-24 00:53:11.681747
e3739b71-c0f7-430f-8bfa-e1b60135786d	55255ebc-68f0-409a-b7be-9754d1babb74	t	1083	2026-04-24 00:53:13.993689
85a0ad7d-f244-4924-a7c9-4fa85b777ad4	67782314-f2d4-446c-b344-e405f8151e8f	t	1093	2026-04-24 00:53:16.209822
b7252f4a-0446-46d9-8a9a-29fd11695703	a801e65e-d157-4b78-88a3-ad1d2133418d	t	1072	2026-04-24 00:53:18.151472
f039b4a1-c0a4-4143-9bd3-cbf80f0ada75	fb9d4be5-8328-4b41-b486-eb658a4f320b	t	1077	2026-04-24 00:53:20.108805
a0cf12e6-c6e2-4f94-8422-39c341c093ce	9f06f56f-d1e3-4fe0-9dd0-f376e3b5859b	t	1075	2026-04-24 00:53:21.886728
95dc6921-ca40-4ec8-a078-c94a4e973260	232e69f2-7c5a-4338-acf6-780dfeeeb8c2	t	1104	2026-04-24 01:28:24.724275
0e516923-5c15-402b-bcb1-551f878d2d7b	47004496-511f-4ff8-ab44-0f8251a3e56f	t	1084	2026-04-24 01:28:27.003554
8b60470a-d9ba-4ea9-9f86-bf9589f26bc4	60c4d433-ebb4-478d-8e6d-cb1cf8b4d65d	t	1080	2026-04-24 01:28:29.263356
ead45e2c-4c93-4e4f-8566-b9f3753b92a0	1cee6e52-3278-426c-903c-d697aa3c1a8c	t	1083	2026-04-24 01:28:31.302503
26bf9615-8567-404b-880d-361476b86a8a	992857cb-54e4-4314-82b3-dd44cf59613d	t	1087	2026-04-24 01:28:33.548072
32b50039-1244-41c7-9301-63d4f344d475	23e82e6a-5f1d-4e3a-ba0e-11c5896e4026	t	1099	2026-04-24 01:28:35.806014
da5ccd6e-8775-4bce-8365-c6a4b649ebac	7346ffbf-257d-4b87-8adf-a154cc386933	t	1088	2026-04-24 01:28:38.014661
4676ef8a-f3ed-40ca-aee2-00275edb413d	2cd962c2-e25a-42ab-88ee-f9dcac391339	t	1099	2026-04-24 01:28:40.271551
0ad6c6b2-247e-4c23-8c8e-6f02800e8786	849d5726-d2bd-4992-b953-4eb295d78b74	t	1091	2026-04-24 01:28:42.420058
37385013-1bc6-4ca2-b358-db72a4c3d8da	b18d7623-bdc8-41b4-bb23-61fb0a51b857	t	1081	2026-04-24 01:28:44.351556
199c96ef-0b1f-4b01-ba92-b52c123dd206	63cbac38-6662-4984-9e54-f9b2566b7633	t	1082	2026-04-24 01:28:46.351783
0bfec615-4d2c-412a-98c9-53f82a4bb8b9	cf5d755d-a355-4faf-b654-6074e043a9a2	t	1085	2026-04-24 01:28:48.454682
9803cb60-b1d7-48b0-a60c-4112eb6ec19d	19c2264c-5bd3-4f27-b66b-855f40a81830	t	1097	2026-04-24 01:28:50.738883
60acd2af-0959-4976-95f5-6ad3183a1da7	a2c53d62-d5e3-4597-b2b4-9487cb801909	t	1081	2026-04-24 01:28:52.952774
1cfcda0e-817a-4b65-81d8-c9c31cd21871	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1082	2026-04-24 01:28:55.266167
1cde2c25-3384-4e5d-988a-d2a0e6f8192d	133de373-d757-4e31-8932-1de0179ea366	t	1114	2026-04-24 01:28:57.543915
9bab50cd-c57f-4fdc-9920-6901c3d6ee8b	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1084	2026-04-24 01:28:59.928582
4a633e29-546e-47af-9b16-ee6dd0c03448	1ba64459-214c-4257-87cb-707d82abbcdc	t	1087	2026-04-24 01:29:02.008139
8e0484c9-abec-48c6-ac1a-ac9696fccd05	9f1e02e2-eba0-4ac9-965c-8d6170267fab	t	1082	2026-04-24 01:29:04.284014
a573ea5a-0d30-4bba-8973-96adcc4b6078	9f1e02e2-eba0-4ac9-965c-8d6170267fab	t	1098	2026-04-24 01:29:06.557517
b376c6f1-4ca9-4d75-b17e-240174c9458e	36c09f80-929d-4137-a8f0-ce0fe0e35dd4	t	1157	2026-04-24 01:48:32.315447
1ad729e4-cd13-4aaf-b31f-10f95a1b6822	7de00605-784a-4322-9f59-89e2b83838c2	t	1113	2026-04-24 01:48:34.836556
0977045c-8a5f-4fc1-8210-d45942acc03d	ce6ca3dd-00b4-4376-b91a-891ea3ec5e18	t	1132	2026-04-24 01:48:37.06112
88014b65-0c35-4883-86a0-08d57d644295	2a00557b-a245-462c-bfe6-dcf34598a5da	t	1107	2026-04-24 01:48:39.17382
43215098-f0a1-4229-b4ef-c4fdf4627778	9597531d-b911-4fa7-ae31-35790fcfdce8	t	1084	2026-04-24 01:48:41.152034
64182403-de61-4b9b-919a-968ea5eaa077	e2c414c2-a2ae-47c0-90e7-ec69df21112b	t	1085	2026-04-24 01:48:43.231145
906428b7-5929-4a6c-8776-1c7b3e02bf3a	b37e536a-8290-43b4-bf1f-4756dc34a7be	t	1081	2026-04-24 01:48:45.446699
7e49106b-f70a-4947-ae81-416001631e52	7de00605-784a-4322-9f59-89e2b83838c2	t	1085	2026-04-24 01:48:47.863512
41d69b2f-0d7a-4b0c-87b1-e7d8541f2f86	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1088	2026-04-24 01:48:49.942795
b812b33e-8fd7-40e2-94b5-41d857a13376	54b45389-2af3-4740-ab70-d0b44252aeae	t	1097	2026-04-24 01:48:52.231194
0d5e7ac0-2ab8-4176-aab5-7f542b813465	e999c7bf-195a-4a3c-aa82-ca1afbdf8414	t	1136	2026-04-24 01:48:54.759484
4a4b1b56-7956-44cf-8473-195c6527c0ec	9aae50bf-c437-4c5c-8ee2-be11616f31d8	t	1085	2026-04-24 01:48:57.019921
77c7ce9d-df11-4b61-afcc-79f558c3f763	30a5f88e-3c8b-45fc-aa4f-cdb518d97980	t	1088	2026-04-24 01:48:58.970277
c6a6c6cf-3966-437e-a8f3-33f2ad2e1fe8	9bc21cd9-d678-4419-8340-17f2f3d6cb3e	t	1085	2026-04-24 01:49:01.31546
65bd27c8-5e15-41fc-86f4-55907d68ab76	354041a1-c8fa-4717-8a72-2663ceca0b20	t	1085	2026-04-24 01:49:03.870981
bd8e04ec-aed1-4cbf-aa01-2a55b9e93125	7de00605-784a-4322-9f59-89e2b83838c2	t	1094	2026-04-24 01:49:05.839494
c502d43b-0099-4a7a-bdf1-359c6aaf6c8c	9f1e02e2-eba0-4ac9-965c-8d6170267fab	t	1085	2026-04-24 01:49:08.192141
2eeb2e42-e612-4a7c-a5d6-95d281baa145	ce6ca3dd-00b4-4376-b91a-891ea3ec5e18	t	1162	2026-04-24 01:49:10.62851
1fc6d36a-6041-4347-a873-1c4727d90d77	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	t	1084	2026-04-24 01:49:12.761179
e91be9f6-b070-41cc-be02-a06a6d44b4fe	7de00605-784a-4322-9f59-89e2b83838c2	t	1098	2026-04-24 01:49:15.02689
2a5165f4-0838-466d-9a76-bb12bf9f655a	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	643	2026-04-24 10:47:52.822783
c7ec317b-e1c4-4189-81a7-4920686ff6a4	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	596	2026-04-24 11:49:51.573682
84dd5132-95c7-4fb6-bd4c-8e02b9363398	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1094	2026-04-24 13:38:45.551351
a7040946-24ae-43b0-978a-f61201af9fd4	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1056	2026-04-25 08:01:47.605462
56792da8-d503-4787-a26b-5ef5271c1cca	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1089	2026-04-25 08:41:05.063843
1f24c579-9675-4cdf-9021-8162c12c2981	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1089	2026-04-25 08:48:37.394048
5a656494-da94-4ada-b006-9746231e7567	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1082	2026-04-25 10:41:16.524518
58031e49-68d4-4b5b-a958-8397c94a5f08	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1281	2026-04-25 10:46:26.497891
0f47b139-1d5f-4de4-9b41-e0ce1ad2d624	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1084	2026-04-25 11:24:22.835778
6005647a-2ae3-46f1-90b7-2d3b3717dc0e	4377fcc5-0da2-47d8-9f70-c4b26db7488d	t	1198	2026-04-25 11:28:56.975393
40fbd9ee-eacb-4e22-b822-8ccf8a0c80f7	cf08168d-22ef-465b-883f-f2392036b1a7	t	1088	2026-04-25 11:40:25.968581
4c500cae-4bbd-42a8-9440-e5fba111f964	9f1e02e2-eba0-4ac9-965c-8d6170267fab	t	1086	2026-04-25 11:41:29.52699
b2bfda07-9eb7-44ad-9853-bb0d03967714	19c2264c-5bd3-4f27-b66b-855f40a81830	t	1095	2026-04-25 11:48:46.252695
ec4dcafc-c30e-4504-b135-08f376f95484	a2c53d62-d5e3-4597-b2b4-9487cb801909	t	1097	2026-04-25 11:48:49.28284
238815fe-e0ee-4913-b73e-7f1477723d7a	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1091	2026-04-25 11:48:51.386543
bf2124ea-c6fa-47c5-aef4-976086a2a1ee	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1082	2026-04-25 11:48:53.466335
8afb921a-d306-4450-aafa-7a191d7d9501	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1082	2026-04-25 11:48:55.779081
c9def36f-c088-486d-bae8-b1fa2000ae44	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1060	2026-04-25 12:01:29.250456
e725a045-dc49-4839-ac84-535a844f5af8	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1061	2026-04-25 12:01:30.859173
cca1f4ba-24c2-4b75-8269-fd0a32ffd755	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1058	2026-04-25 12:01:32.457811
df0e5f2f-08ff-497a-8e33-f1615a488b90	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1062	2026-04-25 12:01:34.050478
8a3eed3f-f261-4d16-abd6-cdbf1f5b18bc	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1059	2026-04-25 12:01:35.66815
dc9cd696-1c2a-42ab-ba96-1f1acf95da26	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1062	2026-04-25 12:23:52.551769
a228565e-a947-42a6-931d-7a99a02ae041	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1059	2026-04-25 12:29:46.182843
3f831a42-602d-4070-9d35-46212b7f7e88	129a8c8d-54b1-43f9-a7c2-75993315998a	t	1087	2026-04-25 18:42:59.187871
288b19a9-9704-4cc0-ad83-37bcb56b1386	129a8c8d-54b1-43f9-a7c2-75993315998a	f	107	2026-04-25 19:18:24.535483
ae5e5f8a-5c26-43b0-a1c3-c1ee574e5eb3	129a8c8d-54b1-43f9-a7c2-75993315998a	f	196	2026-04-25 19:24:20.427548
fc830b3a-b741-41ab-9d94-920e0b262a00	129a8c8d-54b1-43f9-a7c2-75993315998a	f	95	2026-04-25 19:30:25.298139
061e0d3e-bdc8-4b93-9d32-57aa30b20118	129a8c8d-54b1-43f9-a7c2-75993315998a	f	83	2026-04-25 19:33:42.449485
c14bbb9a-c9dc-4a3f-8436-7b3177a3708b	133de373-d757-4e31-8932-1de0179ea366	f	84	2026-04-25 19:34:25.288544
8bf3cf59-8338-400d-b199-7829e179813f	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1186	2026-04-25 20:11:27.479202
98730978-3887-4538-a7ce-08841912ee20	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1528	2026-04-25 21:49:28.289254
cde2e85c-1f9e-445a-ba53-89fd44f8870e	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1514	2026-04-25 22:16:44.397062
0d14f0d4-d867-4c9d-8d9e-0713bd9a7c7d	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1956	2026-04-26 07:32:35.054226
24ae2866-59fb-4282-9f68-65efcade9840	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1174	2026-04-26 11:04:20.529117
e05f41a4-3f2d-4482-b20a-3f1f7e4a1a11	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1151	2026-04-26 11:04:23.195744
46a23dd2-73de-46a6-a020-0dd339333b52	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1185	2026-04-26 11:04:26.02152
d9358d5e-0663-4c76-8dad-330ed2c8963f	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1154	2026-04-26 11:04:28.829131
d8b5cc95-82bc-4538-ab95-45d1dfec6095	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1160	2026-04-26 11:04:31.478765
1e9712cf-3b18-49ff-bf5b-5641167e3e8b	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1134	2026-04-26 12:07:42.68405
61f59e39-0672-4696-a894-e888c3f4adb0	3c6b827e-3b36-48b6-9ae2-0f54544e326e	t	1133	2026-04-26 12:07:46.532094
9deee3bc-5dc8-4a80-b3d3-9ed97a0b46ec	ce6ca3dd-00b4-4376-b91a-891ea3ec5e18	t	1125	2026-04-26 12:07:48.959335
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.payments (id, invoice_id, amount, method, status, created_at) FROM stdin;
\.


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.plans (id, name, request_limit, price, created_at) FROM stdin;
free	Free Plan	100	0	2026-04-20 18:07:19.788576
pro	Pro Plan	1000	499	2026-04-20 18:07:19.788576
enterprise	Enterprise Plan	10000	1999	2026-04-20 18:07:19.788576
\.


--
-- Data for Name: policies; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.policies (id, agent_type, condition, action, weight, approval_status, created_at, score, usage_count, last_used) FROM stdin;
1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	test_job	{"max_latency": 1056.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 01:48:47.941338	26.1	13	2026-04-26 17:46:22.692865
7de00605-784a-4322-9f59-89e2b83838c2	test_job	{"max_latency": 1082.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 01:48:32.367156	8.1	4	2026-04-24 01:49:14.003201
3c6b827e-3b36-48b6-9ae2-0f54544e326e	test_job	{"max_latency": 1075.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 00:21:05.507221	22.6	13	2026-04-26 12:07:44.918119
ce6ca3dd-00b4-4376-b91a-891ea3ec5e18	test_job	{"max_latency": 1088.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 01:48:32.367156	6.1	3	2026-04-26 12:07:47.380961
129a8c8d-54b1-43f9-a7c2-75993315998a	test_job	{"max_latency": 1347.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 00:21:05.507221	23	17	2026-04-25 19:33:42.430699
4377fcc5-0da2-47d8-9f70-c4b26db7488d	test_job	{"max_latency": 1347.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 00:46:45.060786	20.2	11	2026-04-25 11:28:55.848261
133de373-d757-4e31-8932-1de0179ea366	test_job	{"max_latency": 1082.0, "min_success_rate": 1.0}	{"priority": 5}	3	approved	2026-04-24 00:52:43.195384	2.5	3	2026-04-25 19:34:25.268676
cf08168d-22ef-465b-883f-f2392036b1a7	test_job	{"max_latency": 1050.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 00:46:45.060786	3	2	2026-04-25 11:40:24.925558
49e4c548-89d1-446e-9545-9d4e8e91a83e	test_job	{"max_latency": 1100.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 00:52:43.195384	1	1	2026-04-24 00:52:58.260583
9f1e02e2-eba0-4ac9-965c-8d6170267fab	test_job	{"max_latency": 1084.0, "min_success_rate": 1.0}	{"priority": 5}	3	approved	2026-04-24 00:21:05.507221	9	5	2026-04-25 11:41:28.479255
19c2264c-5bd3-4f27-b66b-855f40a81830	test_job	{"max_latency": 1075.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 00:52:43.195384	5	3	2026-04-25 11:48:44.46365
5717693c-a9dc-4bc8-8811-c1a346cc39bb	test_job	{"max_latency": 1056.0, "min_success_rate": 1.0}	{"priority": 5}	3	approved	2026-04-24 00:52:59.310494	1	1	2026-04-24 00:53:00.985152
9a446794-c9cc-4db0-8fda-d563f7563935	test_job	{"max_latency": 1087.0, "min_success_rate": 1.0}	{"priority": 5}	3	approved	2026-04-24 00:52:59.310494	1	1	2026-04-24 00:53:02.964627
a2c53d62-d5e3-4597-b2b4-9487cb801909	test_job	{"max_latency": 1096.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 00:52:43.195384	5	3	2026-04-25 11:48:48.231371
23afd7d5-47a4-40f5-b405-37caf091796a	test_job	{"max_latency": 1096.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-23 23:46:48.763045	1	1	2026-04-24 00:21:04.428577
cb089a3a-13a9-422d-a95f-f87730f44e78	test_job	{"max_latency": 1098.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-23 22:43:20.300884	1	1	2026-04-23 23:46:47.715057
c6d0a662-a4a7-4e2e-af8b-edbbd1de8a45	test_job	{"max_latency": 1075.0, "min_success_rate": 1.0}	{"priority": 5}	3	approved	2026-04-24 00:52:55.151843	1	1	2026-04-24 00:53:04.996314
ffadab01-5d5a-4ed7-a4d7-fa35ce3feb7d	test_job	{"max_latency": 1050.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 00:21:05.507221	1	1	2026-04-24 00:52:43.93487
36c09f80-929d-4137-a8f0-ce0fe0e35dd4	test_job	{"max_latency": 1081.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 01:29:06.611991	2	1	2026-04-24 01:48:31.252134
60c4d433-ebb4-478d-8e6d-cb1cf8b4d65d	test_job	{"max_latency": 1163.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 01:28:27.047458	2	1	2026-04-24 01:28:28.246987
30a5f88e-3c8b-45fc-aa4f-cdb518d97980	test_job	{"max_latency": 1093.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 01:48:57.063948	2.1	1	2026-04-24 01:48:57.944189
4ce5c0c4-def1-453f-853c-a4ded1256705	test_job	{"max_latency": 1100.0, "min_success_rate": 1.0}	{"priority": 5}	3	approved	2026-04-24 00:53:02.035853	1	1	2026-04-24 00:53:06.854024
633b552c-bab5-4ac1-b845-24cff0b4db63	test_job	{"max_latency": 1087.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 00:53:03.998899	1	1	2026-04-24 00:53:08.73776
b18d7623-bdc8-41b4-bb23-61fb0a51b857	test_job	{"max_latency": 1091.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 01:28:42.439714	2	1	2026-04-24 01:28:43.337455
1cee6e52-3278-426c-903c-d697aa3c1a8c	test_job	{"max_latency": 1090.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 01:28:29.292426	2	1	2026-04-24 01:28:30.277378
54b45389-2af3-4740-ab70-d0b44252aeae	test_job	{"max_latency": 1157.0, "min_success_rate": 1.0}	{"priority": 5}	3	approved	2026-04-24 01:48:49.996317	2.1	1	2026-04-24 01:48:51.201227
b1ea5268-3cb9-41bd-94e0-16fa770908cb	test_job	{"max_latency": 1347.0, "min_success_rate": 1.0}	{"priority": 5}	3	approved	2026-04-24 00:53:07.908617	1	1	2026-04-24 00:53:10.658734
55255ebc-68f0-409a-b7be-9754d1babb74	test_job	{"max_latency": 1099.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 00:53:09.787378	1	1	2026-04-24 00:53:12.960053
b37e536a-8290-43b4-bf1f-4756dc34a7be	test_job	{"max_latency": 1085.0, "min_success_rate": 1.0}	{"priority": 5}	3	approved	2026-04-24 01:48:43.267912	2.1	1	2026-04-24 01:48:44.427114
992857cb-54e4-4314-82b3-dd44cf59613d	test_job	{"max_latency": 1084.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 01:28:31.352322	2	1	2026-04-24 01:28:32.523938
2a00557b-a245-462c-bfe6-dcf34598a5da	test_job	{"max_latency": 1084.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 01:48:37.089735	2.1	1	2026-04-24 01:48:38.160177
9597531d-b911-4fa7-ae31-35790fcfdce8	test_job	{"max_latency": 1163.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 01:48:37.089735	2.1	1	2026-04-24 01:48:40.131849
e2c414c2-a2ae-47c0-90e7-ec69df21112b	test_job	{"max_latency": 1077.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 01:48:37.089735	2.1	1	2026-04-24 01:48:42.210759
67782314-f2d4-446c-b344-e405f8151e8f	test_job	{"max_latency": 1078.0, "min_success_rate": 1.0}	{"priority": 5}	3	approved	2026-04-24 00:53:11.733079	1	1	2026-04-24 00:53:15.190977
a801e65e-d157-4b78-88a3-ad1d2133418d	test_job	{"max_latency": 1083.0, "min_success_rate": 1.0}	{"priority": 5}	3	approved	2026-04-24 00:53:14.06715	1	1	2026-04-24 00:53:17.130434
63cbac38-6662-4984-9e54-f9b2566b7633	test_job	{"max_latency": 1093.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 01:28:44.374347	2	1	2026-04-24 01:28:45.32585
354041a1-c8fa-4717-8a72-2663ceca0b20	test_job	{"max_latency": 1157.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 01:49:01.386492	2.1	1	2026-04-24 01:49:02.856077
23e82e6a-5f1d-4e3a-ba0e-11c5896e4026	test_job	{"max_latency": 1090.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 01:28:33.598931	2	1	2026-04-24 01:28:34.781431
e999c7bf-195a-4a3c-aa82-ca1afbdf8414	test_job	{"max_latency": 1081.0, "min_success_rate": 1.0}	{"priority": 5}	3	approved	2026-04-24 01:48:52.286175	2.1	1	2026-04-24 01:48:53.733062
9aae50bf-c437-4c5c-8ee2-be11616f31d8	test_job	{"max_latency": 1083.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 01:48:52.286175	2.1	1	2026-04-24 01:48:55.99808
fb9d4be5-8328-4b41-b486-eb658a4f320b	test_job	{"max_latency": 1083.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 00:53:16.247465	1	1	2026-04-24 00:53:19.097476
9f06f56f-d1e3-4fe0-9dd0-f376e3b5859b	test_job	{"max_latency": 1163.0, "min_success_rate": 1.0}	{"priority": 5}	3	approved	2026-04-24 00:53:18.188222	1	1	2026-04-24 00:53:20.867417
232e69f2-7c5a-4338-acf6-780dfeeeb8c2	test_job	{"max_latency": 1099.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 00:53:21.932498	2	1	2026-04-24 01:28:23.691101
47004496-511f-4ff8-ab44-0f8251a3e56f	test_job	{"max_latency": 1088.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 00:53:21.932498	2	1	2026-04-24 01:28:25.978836
9bc21cd9-d678-4419-8340-17f2f3d6cb3e	test_job	{"max_latency": 1096.0, "min_success_rate": 1.0}	{"priority": 5}	3	approved	2026-04-24 01:48:59.03544	2.1	1	2026-04-24 01:49:00.285464
7346ffbf-257d-4b87-8adf-a154cc386933	test_job	{"max_latency": 1078.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 01:28:35.856019	2	1	2026-04-24 01:28:36.985349
2cd962c2-e25a-42ab-88ee-f9dcac391339	test_job	{"max_latency": 1081.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 01:28:35.856019	2	1	2026-04-24 01:28:39.247449
cf5d755d-a355-4faf-b654-6074e043a9a2	test_job	{"max_latency": 1087.0, "min_success_rate": 1.0}	{"priority": 4}	3	approved	2026-04-24 01:28:46.408524	2	1	2026-04-24 01:28:47.428449
849d5726-d2bd-4992-b953-4eb295d78b74	test_job	{"max_latency": 1102.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 01:28:38.066356	2	1	2026-04-24 01:28:41.404786
1ba64459-214c-4257-87cb-707d82abbcdc	test_job	{"max_latency": 1092.0, "min_success_rate": 1.0}	{"priority": 6}	3	approved	2026-04-24 01:28:59.981203	2	1	2026-04-24 01:29:00.979525
\.


--
-- Data for Name: policy_metrics; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.policy_metrics (policy_id, success_count, failure_count, avg_latency, last_updated) FROM stdin;
133de373-d757-4e31-8932-1de0179ea366	2	1	1109	2026-04-24 00:52:57.11105
95753f89-22e1-4d5e-b82e-7a3655a90ee8	2	1	1081	2026-04-23 10:52:44.720822
344b884c-f5f1-4d83-9356-b509480822e6	1	0	1347	2026-04-23 11:18:19.384748
d44e31d5-ddcb-432e-b457-6847aec0e070	37	19	1081.613900888522	2026-04-23 10:55:32.527336
cee6563f-766e-460d-8b29-837f2fac0756	1	0	1075	2026-04-23 12:05:21.396453
15cc7c08-c1cc-4801-95c7-265a6f2ea8f8	1	0	1050	2026-04-23 12:05:24.490904
0c2561d1-e194-4793-bfca-7044307d7e5f	1	0	1098	2026-04-23 22:43:20.275914
63c9599e-61be-4162-8502-fe5c6ce6ac39	1	0	1099	2026-04-23 22:43:22.458531
61583d2b-3f7a-4eaf-bb2f-785fa0bd83a9	1	0	1096	2026-04-23 22:43:24.849949
335c5c6a-1a88-415a-bc49-a760889d9297	1	0	1082	2026-04-23 22:43:26.803619
8ed287c8-7ec7-4e21-864d-3da6d4595c0d	1	0	1084	2026-04-23 22:43:28.729094
cb089a3a-13a9-422d-a95f-f87730f44e78	1	0	1056	2026-04-23 23:46:48.7503
23afd7d5-47a4-40f5-b405-37caf091796a	1	0	1088	2026-04-24 00:21:05.474584
ffadab01-5d5a-4ed7-a4d7-fa35ce3feb7d	1	0	1077	2026-04-24 00:52:44.963255
49e4c548-89d1-446e-9545-9d4e8e91a83e	1	0	1075	2026-04-24 00:52:59.28761
5717693c-a9dc-4bc8-8811-c1a346cc39bb	1	0	1163	2026-04-24 00:53:02.012983
9a446794-c9cc-4db0-8fda-d563f7563935	1	0	1100	2026-04-24 00:53:03.982114
c6d0a662-a4a7-4e2e-af8b-edbbd1de8a45	1	0	1090	2026-04-24 00:53:06.02262
4ce5c0c4-def1-453f-853c-a4ded1256705	1	0	1075	2026-04-24 00:53:07.883677
633b552c-bab5-4ac1-b845-24cff0b4db63	1	0	1078	2026-04-24 00:53:09.765677
b1ea5268-3cb9-41bd-94e0-16fa770908cb	1	0	1081	2026-04-24 00:53:11.694874
55255ebc-68f0-409a-b7be-9754d1babb74	1	0	1083	2026-04-24 00:53:14.012286
67782314-f2d4-446c-b344-e405f8151e8f	1	0	1093	2026-04-24 00:53:16.219705
a801e65e-d157-4b78-88a3-ad1d2133418d	1	0	1072	2026-04-24 00:53:18.161988
fb9d4be5-8328-4b41-b486-eb658a4f320b	1	0	1077	2026-04-24 00:53:20.114108
9f06f56f-d1e3-4fe0-9dd0-f376e3b5859b	1	0	1075	2026-04-24 00:53:21.899386
232e69f2-7c5a-4338-acf6-780dfeeeb8c2	1	0	1104	2026-04-24 01:28:24.739734
47004496-511f-4ff8-ab44-0f8251a3e56f	1	0	1084	2026-04-24 01:28:27.015365
60c4d433-ebb4-478d-8e6d-cb1cf8b4d65d	1	0	1080	2026-04-24 01:28:29.270813
1cee6e52-3278-426c-903c-d697aa3c1a8c	1	0	1083	2026-04-24 01:28:31.314795
992857cb-54e4-4314-82b3-dd44cf59613d	1	0	1087	2026-04-24 01:28:33.559533
23e82e6a-5f1d-4e3a-ba0e-11c5896e4026	1	0	1099	2026-04-24 01:28:35.81631
7346ffbf-257d-4b87-8adf-a154cc386933	1	0	1088	2026-04-24 01:28:38.028003
2cd962c2-e25a-42ab-88ee-f9dcac391339	1	0	1099	2026-04-24 01:28:40.28272
849d5726-d2bd-4992-b953-4eb295d78b74	1	0	1091	2026-04-24 01:28:42.425057
b18d7623-bdc8-41b4-bb23-61fb0a51b857	1	0	1081	2026-04-24 01:28:44.357412
63cbac38-6662-4984-9e54-f9b2566b7633	1	0	1082	2026-04-24 01:28:46.365864
cf5d755d-a355-4faf-b654-6074e043a9a2	1	0	1085	2026-04-24 01:28:48.470065
1ba64459-214c-4257-87cb-707d82abbcdc	1	0	1087	2026-04-24 01:29:02.022753
36c09f80-929d-4137-a8f0-ce0fe0e35dd4	1	0	1157	2026-04-24 01:48:32.327158
2a00557b-a245-462c-bfe6-dcf34598a5da	1	0	1107	2026-04-24 01:48:39.179057
9597531d-b911-4fa7-ae31-35790fcfdce8	1	0	1084	2026-04-24 01:48:41.164737
e2c414c2-a2ae-47c0-90e7-ec69df21112b	1	0	1085	2026-04-24 01:48:43.239732
b37e536a-8290-43b4-bf1f-4756dc34a7be	1	0	1081	2026-04-24 01:48:45.460156
3c6b827e-3b36-48b6-9ae2-0f54544e326e	13	0	1144.5146484375	2026-04-24 00:52:43.164667
54b45389-2af3-4740-ab70-d0b44252aeae	1	0	1097	2026-04-24 01:48:52.243924
e999c7bf-195a-4a3c-aa82-ca1afbdf8414	1	0	1136	2026-04-24 01:48:54.772024
9aae50bf-c437-4c5c-8ee2-be11616f31d8	1	0	1085	2026-04-24 01:48:57.030722
30a5f88e-3c8b-45fc-aa4f-cdb518d97980	1	0	1088	2026-04-24 01:48:58.983225
9bc21cd9-d678-4419-8340-17f2f3d6cb3e	1	0	1085	2026-04-24 01:49:01.331555
354041a1-c8fa-4717-8a72-2663ceca0b20	1	0	1085	2026-04-24 01:49:03.876655
ce6ca3dd-00b4-4376-b91a-891ea3ec5e18	3	0	1136	2026-04-24 01:48:37.066281
7de00605-784a-4322-9f59-89e2b83838c2	4	0	1097.25	2026-04-24 01:48:34.848502
4377fcc5-0da2-47d8-9f70-c4b26db7488d	11	0	1164.1650390625	2026-04-24 00:52:48.7916
cf08168d-22ef-465b-883f-f2392036b1a7	2	0	1084.5	2026-04-24 00:52:50.743524
9f1e02e2-eba0-4ac9-965c-8d6170267fab	5	0	1086.875	2026-04-24 00:52:46.869158
19c2264c-5bd3-4f27-b66b-855f40a81830	3	0	1097.25	2026-04-24 00:52:53.106586
a2c53d62-d5e3-4597-b2b4-9487cb801909	3	0	1090.5	2026-04-24 00:52:55.136778
1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	13	0	1102.7529296875	2026-04-24 01:48:49.956051
129a8c8d-54b1-43f9-a7c2-75993315998a	13	4	1073.5673828125	2026-04-24 00:46:45.02677
\.


--
-- Data for Name: scripts; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.scripts (id, hook_id, format, content, version, created_at) FROM stdin;
66c91fd1-369a-4fcc-8b8a-77de610f2288	876a2515-0fd7-451b-8390-b5deb73f9a34	video	Stop wasting money on ads → Here's how it works...	1	2026-04-25 11:28:55.858524
9af44914-8729-4269-b4c6-ff69960db5b0	71578107-e883-496a-b37a-2eaa2d9cd9b4	video	This changed everything → Here's how it works...	1	2026-04-25 11:28:55.858524
4ce5624a-3c9d-455f-ada1-2b8c5d3c5c5f	57bc71e2-21dc-419a-b889-6293002766b3	video	This changed everything → Here's how it works...	1	2026-04-25 11:28:55.858524
d42d6a12-2a67-451e-a515-5fcc9e97a367	f099b95a-b8ad-4651-a151-ee8764617f61	video	Hidden secret revealed → Here's how it works...	1	2026-04-25 11:28:55.858524
cdd8ee96-7ee8-4cd1-84e9-9999e12ef8f0	9150ddc2-85d5-4498-8a52-39d8a447170c	video	Nobody talks about this → Here's how it works...	1	2026-04-25 11:28:55.858524
8d8eab50-1c65-440c-bfd2-e3ba1c98d895	c1cfb3f5-b5a5-4613-bc99-71e58b3db5f6	video	Stop wasting money on ads → Here's how it works...	1	2026-04-25 11:28:55.858524
424dd0d6-aec1-4027-8380-ebb1dead0b81	2b18793b-c349-406a-a2a1-0fce352ecce0	video	Hidden secret revealed → Here's how it works...	1	2026-04-25 11:28:55.858524
4246688f-44d6-4980-a4a3-d773511dbe97	dffe37d1-5833-4810-b668-3a3fec39ea2e	video	Hidden secret revealed → Here's how it works...	1	2026-04-25 11:28:55.858524
7ca844cf-0bd0-4c71-a174-14f2a13acf07	7a05fedd-c50e-44ab-9dc4-dbc3bd73241a	video	Stop wasting money on ads → Here's how it works...	1	2026-04-25 11:28:55.858524
931e4a17-1290-4a3f-8ed5-36db7ccb6f31	a8f9bec7-b253-4745-8260-a3cffc143599	video	This changed everything → Here's how it works...	1	2026-04-25 11:28:55.858524
7c0513e5-a3f5-46e5-b182-6a15cc107b69	64033866-7d81-42c9-810e-39d821a8d374	video	Hidden secret revealed → Here's how it works...	1	2026-04-25 20:11:26.347657
bb62e7ca-a0fe-4c4d-b1ee-2824177fc488	e0b0c7ee-ec38-4c0b-8138-c1a41c3ebd04	video	Nobody talks about this → Here's how it works...	1	2026-04-25 20:11:26.347657
ca2eabe5-072e-4cb6-a8d0-77793bec2b01	cdb6466e-75d3-4e43-9bce-e948ebc3cb04	video	Nobody talks about this → Here's how it works...	1	2026-04-25 20:11:26.347657
f3117122-94eb-4da2-86e3-c56e71784fb5	b88c3c9f-fbd5-4a50-af0d-d19fb5ad4aca	video	Nobody talks about this → Here's how it works...	1	2026-04-25 20:11:26.347657
dfca5310-eb41-4fe6-ac8b-5bf3ea935497	4e370532-0fa7-40f6-9c8b-411f661f795c	video	This changed everything → Here's how it works...	1	2026-04-25 20:11:26.347657
c1e8f107-7146-4599-b305-6d31fc5b2cb7	91e17af1-d966-4d72-ab88-b3e38b8fb99a	video	Nobody talks about this → Here's how it works...	1	2026-04-25 20:11:26.347657
ad5e9266-27cd-4444-8155-3e388c2f4d49	af49fe65-31a0-4edc-b9ff-e44f2f60c794	video	Hidden secret revealed → Here's how it works...	1	2026-04-25 20:11:26.347657
7b1b665b-bc65-4d43-9a62-4d2b282462f6	4bee565a-ae19-4c66-8720-2ad182b044c7	video	This works in 24 hours → Here's how it works...	1	2026-04-25 20:11:26.347657
99733d0f-e03d-43eb-9bb9-32c65d50b83c	4027dc06-fbae-4931-ad7a-b6da7d708209	video	Hidden secret revealed → Here's how it works...	1	2026-04-25 20:11:26.347657
d7f596be-91dd-4bc5-b3f2-15974b9e06dc	3ca65e08-89e7-45ec-9f36-9623f24a3cbe	video	Nobody talks about this → Here's how it works...	1	2026-04-25 20:11:26.347657
ca9c3f93-a9ef-492c-97cc-795bcc115ec0	aa2e5144-57b8-451e-9eda-1e94eaabeeb4	video	This changed everything → Here's how it works...	1	2026-04-25 21:49:27.190669
f2a6a642-6ea4-4663-8c49-e544be3d548b	aa6e7be1-2a39-4baa-b191-1c1c06be1067	video	Nobody talks about this → Here's how it works...	1	2026-04-25 21:49:27.190669
224a25c4-77c4-4104-bac8-1ec2085332b4	a6de8c65-0cef-4d0f-aabb-dce09c67e3bd	video	Nobody talks about this → Here's how it works...	1	2026-04-25 21:49:27.190669
1b7dd6c2-eb4c-453d-b56c-791eb197b218	5a910c43-25c4-47c5-b088-c28620eda035	video	This works in 24 hours → Here's how it works...	1	2026-04-25 21:49:27.190669
7eae75d1-51e4-4d14-ad34-630ed7db3a5a	d4414ff0-96c0-4fc9-b089-fb007e9b1b35	video	This works in 24 hours → Here's how it works...	1	2026-04-25 21:49:27.190669
fc6496bd-0ca3-4903-8453-45889dddae89	889703ea-58cf-4148-8ada-6697ebd6b7ec	video	Stop wasting money on ads → Here's how it works...	1	2026-04-25 21:49:27.190669
493b5b50-d868-4ce7-a4c1-ff4165783e04	52c91ae4-9374-4665-88cc-786c01b00c35	video	This changed everything → Here's how it works...	1	2026-04-25 21:49:27.190669
29b71314-3986-4e86-b757-f4081bfd57e2	8df2b58a-a065-4584-aa7f-77d0fe9db350	video	Nobody talks about this → Here's how it works...	1	2026-04-25 21:49:27.190669
29d45795-e91e-44c4-a43f-984343f5bb06	86c33d62-b721-45db-995a-b9bfb52dddd1	video	Nobody talks about this → Here's how it works...	1	2026-04-25 21:49:27.190669
b3500473-88a0-478f-8502-f0211830a6c8	6dd404e6-8760-4e0b-bded-a7baf7f473ab	video	Hidden secret revealed → Here's how it works...	1	2026-04-25 21:49:27.190669
fad9c39f-c1d7-4d09-91a3-641e7cb3678c	2b8a748b-84df-428c-a29e-ec931dc8304a	video	Nobody talks about this → Here's how it works...	1	2026-04-25 22:16:43.284689
c479e3f1-5578-48de-a890-4170ecc721e1	503e7b51-cd90-43fc-a698-a1a1e3d9df15	video	This changed everything → Here's how it works...	1	2026-04-25 22:16:43.284689
b2f0a7ea-29f6-4374-b784-691d3873bc2b	ce2950d8-7e6c-448a-b366-484af3da6d25	video	Stop wasting money on ads → Here's how it works...	1	2026-04-25 22:16:43.284689
c1d98470-6b0b-4682-8015-c3ce947ccf8c	d0418046-e0cc-4144-be8d-786a2cc206b4	video	Stop wasting money on ads → Here's how it works...	1	2026-04-25 22:16:43.284689
69e24ab6-15ea-4e05-87d9-d533d3bd4149	fe37b667-b28b-4793-8842-6850197999f6	video	This works in 24 hours → Here's how it works...	1	2026-04-25 22:16:43.284689
030c1c2f-8367-491c-83b5-2fe94c233892	5df9463c-2baf-4c1d-9edc-6428c978aca9	video	Stop wasting money on ads → Here's how it works...	1	2026-04-25 22:16:43.284689
518bb5b5-6d0f-415c-986a-d6df2dd4c0f8	d60ad3a9-9a24-4a22-9eef-6f9660d593ef	video	Hidden secret revealed → Here's how it works...	1	2026-04-25 22:16:43.284689
83b827fe-7c5d-4c60-b2bd-4ec94ce56e5b	201f2acc-c45f-44f8-8439-8a9665d5f070	video	Stop wasting money on ads → Here's how it works...	1	2026-04-25 22:16:43.284689
863e6709-5be0-47dc-82fa-30bdfed98bbf	13e13428-2236-482b-9944-98f82c3fdf91	video	Stop wasting money on ads → Here's how it works...	1	2026-04-25 22:16:43.284689
19444e0f-8898-4e33-8022-da0a0b7efa3d	b6aceab5-8614-40fb-8506-5e92ab9fe963	video	Hidden secret revealed → Here's how it works...	1	2026-04-25 22:16:43.284689
838a54a0-aabe-4ddd-9893-a25126c897a8	b1cc1108-20d8-45ec-a6a5-336de7b2ae6e	video	Nobody talks about this → Here's how it works...	1	2026-04-26 07:32:33.675364
1a675cd8-1265-49ba-b479-bbe773c4ddc4	8666bac2-2e8d-4a85-885a-cee9d942d2e8	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 07:32:33.675364
bec66dce-00f1-40ae-97c8-3b95ae47152d	dd5e641c-3390-43b9-b754-95e438354580	video	This changed everything → Here's how it works...	1	2026-04-26 07:32:33.675364
cef0128c-73e7-4c04-8e49-d72277244254	2d9bba28-3661-4b28-802f-fcf5ee7d73e8	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 07:32:33.675364
1cfb46fa-1acf-4f7a-b7aa-289cb2755237	57d412b3-ff8f-4079-9378-2e73de36b45f	video	This changed everything → Here's how it works...	1	2026-04-26 07:32:33.675364
699db022-3da1-43a4-8e3f-b4b73e095991	88e384f5-6826-4835-924c-03e11d1c0847	video	This works in 24 hours → Here's how it works...	1	2026-04-26 07:32:33.675364
9763d16b-ccf2-43f4-a46b-042cadb8ef6d	6a3f219e-734b-447b-bf76-84f886f14e37	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 07:32:33.675364
e871daca-16a6-48af-b7ed-a1903a19cc86	0cf0a69e-bae3-4f21-b3bf-0a74655eb10d	video	This changed everything → Here's how it works...	1	2026-04-26 07:32:33.675364
8b728143-60fd-47d8-ba06-66fdb49197e2	7fa158a3-1ec2-4485-9224-f871c34fe432	video	Nobody talks about this → Here's how it works...	1	2026-04-26 07:32:33.675364
61e980ba-45e9-4857-8b08-cc1ad440143e	24ba700d-7f9a-41bc-ac69-26f91f76e255	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 07:32:33.675364
673e9632-f743-48d4-9500-219395205d50	92e7b865-e605-4246-adbe-49a86ecce316	video	Nobody talks about this → Here's how it works...	1	2026-04-26 10:46:36.738139
ec19fb9a-3e29-4988-a7c1-adc00d340dab	6ae9aa73-452c-4b5e-9253-19ac7e63b863	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:36.738139
ff14b1d0-6a11-4dad-914e-a50372d1cd50	62cbde44-fba3-4650-9219-39f3db1aad5c	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:36.738139
57a95db5-673a-47fb-88fc-d8280bf28cf2	cf47f501-b2c4-45a2-8058-2945df0f3433	video	This changed everything → Here's how it works...	1	2026-04-26 10:46:36.738139
ed975b55-8398-4e7f-ab2e-11a6edc9777a	10e28a10-148a-49a9-9840-1c96495fe1de	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:36.738139
ec8cd967-ef39-4422-916c-5b41698f84f5	8499a496-a651-4f57-b0c0-aadb504d728d	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 10:46:36.738139
2a231a6d-7760-47ca-b89e-e6ea7bdd5d95	d3ddc424-30f8-422c-81e4-4d43bf6fed51	video	This changed everything → Here's how it works...	1	2026-04-26 10:46:36.738139
34b41175-2eaa-4429-b185-cf1929636b5d	a08177d5-e9e4-40ff-be2f-16aa62bbf8db	video	This changed everything → Here's how it works...	1	2026-04-26 10:46:36.738139
4f30e2c5-67c8-4844-8cec-112a93c2b730	c96e9abe-27ff-4afb-8a39-b2ccdca2786a	video	This changed everything → Here's how it works...	1	2026-04-26 10:46:36.738139
31e34cd8-7eee-42d3-a132-86243b38d79e	838b2e54-3fdb-43e7-b55d-6360e9f4fea5	video	This works in 24 hours → Here's how it works...	1	2026-04-26 10:46:36.738139
4f85d0ff-6815-471a-a0a9-0ccbe27ed4f3	bbd2c372-9421-4739-99bb-9f893d6472ce	video	This works in 24 hours → Here's how it works...	1	2026-04-26 10:46:39.409952
95930088-dce6-41cb-8df6-d9185e302644	9bfbfcc3-5f77-43b4-bcb0-01230e30b139	video	This changed everything → Here's how it works...	1	2026-04-26 10:46:39.409952
6f24980b-9013-4221-b78c-eca425f6c5e9	036bf71d-24e5-4129-9008-7ed2d32ccaae	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:39.409952
a2759bf2-47ee-4492-98b7-b318ca0a3ec6	c07af563-b48e-4947-83e1-d6ddba362294	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 10:46:39.409952
b135062b-c143-4473-a0a0-9283dc3f5abf	e9649144-c445-44cc-b11e-5b64921baa46	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:39.409952
f68347ae-bcfe-45b4-a42c-49a17588fe72	133cdd6f-8f61-45b7-b9da-f1fc915589a6	video	This works in 24 hours → Here's how it works...	1	2026-04-26 10:46:39.409952
c6b804a5-14c9-4c6b-a796-49b3e83268c5	758b2023-d0a7-4420-8059-3324633904fa	video	This works in 24 hours → Here's how it works...	1	2026-04-26 10:46:39.409952
3b4cb7ec-2e4d-4fb1-9e54-86360678b36f	acefb0e9-1051-483e-9c1c-611030ad0386	video	Nobody talks about this → Here's how it works...	1	2026-04-26 10:46:39.409952
2aa78133-aae0-4227-bb39-a3085ae4dbe3	b98e59b8-384e-41a2-a6d7-998e408ec8cc	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:39.409952
6856054e-c841-497e-96c4-1a644f8949a2	40b34a2a-97ba-451e-936c-c37b9200f0c7	video	This changed everything → Here's how it works...	1	2026-04-26 10:46:39.409952
be2d1cc5-9c90-41cf-8b32-ab5d5e13c98a	69c2687a-641a-45fa-9f34-454b374af0c7	video	This works in 24 hours → Here's how it works...	1	2026-04-26 10:46:41.618925
f8f3b4dc-9638-4e45-b35d-1bbdeb583a93	b1fcbb18-62e7-4578-bf21-5e61caeac15d	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:41.618925
dd5ab66e-3d1b-476d-90f1-c02de038d972	3572a6cd-626a-4b12-b388-903165457be0	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 10:46:41.618925
591f2209-4788-45b0-b51b-e5adaf02f5ae	4b459d45-0abb-4466-8e10-b0ac247f54e4	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:41.618925
c82fd744-b408-40fd-8376-54c010131cb9	82ab6160-4500-4aa2-aaac-705e84c1716b	video	This works in 24 hours → Here's how it works...	1	2026-04-26 10:46:41.618925
82744681-6417-4f97-bff1-07319259aa66	fbe8d2de-7a30-4147-ba7a-9180a8ca208d	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:41.618925
0e5b7c4f-7cda-4f64-8809-268fbb27a5c9	42b4e335-0fae-40cb-bbaf-a3c18c2c9ef8	video	This works in 24 hours → Here's how it works...	1	2026-04-26 10:46:41.618925
f7a34988-11fa-4c6c-b7fc-52e70064e6d4	f982a56d-01bd-4986-9101-56f0466e4333	video	Nobody talks about this → Here's how it works...	1	2026-04-26 10:46:41.618925
412cb905-4b89-4b38-90e9-d684b1e008bb	43774f14-51ef-4cb7-97a6-45df3f78ef4a	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:41.618925
4b9e6a5b-6f0c-4ecf-96b7-8641b411048a	d4585f7e-87f6-42a2-a5a5-79fa4a7a1365	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 10:46:41.618925
e5052887-2e87-4ae3-acd9-c47c78aa1d20	f9b780f5-e515-4326-8279-08ffb5c371a5	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 10:46:43.989825
5c8a7712-075f-48e8-b53f-b95574b09406	79b6f633-2100-4d29-af5a-f8dce065f75c	video	This changed everything → Here's how it works...	1	2026-04-26 10:46:43.989825
0d1695e4-f087-40d0-95bf-444090b0d3a3	1618aaf5-37cc-46f6-b036-b2edc70a4ed6	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:43.989825
5b19880d-187e-4577-823a-a847d2f3b1a3	bccb8fe7-0c3b-42cc-b93f-a349f56d2a66	video	This changed everything → Here's how it works...	1	2026-04-26 10:46:43.989825
9895c815-3119-467b-822b-d121c2ed48ee	e6df6fab-7d98-4120-8d3a-53230cb4a0b7	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:43.989825
c704ef6f-9904-40c9-914d-567db32cece5	5d47c7e6-11c2-42f7-8805-ce345258866f	video	Nobody talks about this → Here's how it works...	1	2026-04-26 10:46:43.989825
8a4949a2-91c3-4caa-a387-3662f6396a61	7a3ea4b7-b4d2-4ecf-965b-19a6315fa6f9	video	Nobody talks about this → Here's how it works...	1	2026-04-26 10:46:43.989825
dab300f3-03ae-4cb9-80b6-f84604873228	c99092e3-c865-488e-b9b0-603680663469	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:43.989825
df6c6902-bdea-4523-8222-84ac321363a6	41fcc768-819e-4743-addb-b6b97732dc24	video	Nobody talks about this → Here's how it works...	1	2026-04-26 10:46:43.989825
aa3ab179-19c0-4d61-998a-52ca4578676d	f19fada3-e503-4870-be84-dbdababef167	video	This works in 24 hours → Here's how it works...	1	2026-04-26 10:46:43.989825
5e9c94b7-b639-47e3-8381-f9ca68a462f6	8e270a97-60ce-4aec-9fc9-05bc5e95ea85	video	This changed everything → Here's how it works...	1	2026-04-26 10:46:46.554253
9f3ff95e-e1fe-47e0-8798-aaa366aec137	367226ba-9574-45d3-9fe5-2d5c80b38aef	video	Nobody talks about this → Here's how it works...	1	2026-04-26 10:46:46.554253
9c6edbeb-a161-4969-ac5a-715761580c16	e6007d15-698a-421c-bc0b-0a349bb481cc	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 10:46:46.554253
3426a159-d6e5-47f5-b626-0726346784ac	e7ce5ebe-7d39-4679-a719-5bbca799847c	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:46.554253
b8ff28cd-c0f8-4c2c-809b-635f82f97196	218f50af-bff1-426b-8aa9-543ad24e1c28	video	Nobody talks about this → Here's how it works...	1	2026-04-26 10:46:46.554253
7e4b4848-5506-4e0e-ace1-e45aceebe441	27cc122c-93d1-419b-ad43-f160faa322a4	video	Nobody talks about this → Here's how it works...	1	2026-04-26 10:46:46.554253
9bb46d70-d445-4d03-85ad-e86d2de467cf	f4354f15-3704-4175-b4f7-a87666577076	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 10:46:46.554253
59c7d982-c015-48c4-ba63-246dbf52530f	977b77e2-6b81-48fe-b27d-44b6b9f9bc99	video	Nobody talks about this → Here's how it works...	1	2026-04-26 10:46:46.554253
4a708a75-18a2-46ae-844a-7b16f9a94f06	1f453910-540d-4c91-867c-2617fc163969	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 10:46:46.554253
d88b8147-3326-4f5a-8b5d-8c8e2744e22d	677b84c3-732d-4578-abb2-04f8132f41f9	video	This works in 24 hours → Here's how it works...	1	2026-04-26 10:46:46.554253
232e5b3a-1589-4fc1-bd87-285fbfdac34b	8b84c571-166e-469f-bf6e-436fc9760f12	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:18.876931
38f7c122-822f-4e21-bbbf-75014aa617e1	5ffd85b3-53bd-4e7e-9968-1ed43927bbbc	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:18.876931
f55314fe-d50b-40ce-b638-b0a737417eca	0632b15c-973f-485e-ae70-5a3afbc909f1	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:18.876931
34cc5fae-24bc-4dc5-afaa-f27587af59ab	063616de-9062-44c9-9530-649e49fab758	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:18.876931
82a57878-6af4-4c00-8371-a8f4d5bf65fa	66a3f5bc-f575-4a9e-85f1-516467f8ac7b	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:18.876931
230ede8f-a4b7-4589-9123-f6ebc169ed8e	aab60291-70cf-4169-bc7f-5bc4481bc2e1	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:18.876931
aeaeebad-9015-4006-a827-fa9338c5cfb0	cb56b48e-1bc7-4659-80f2-fdefde52ca09	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:18.876931
dafa769a-17c2-40e2-a78a-3e95cefb91a4	23dc5d34-73b7-499c-aab3-24d25d0ee8b1	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:18.876931
14e10356-92c0-426b-a9c8-6ad7a4297171	fba95a73-4a9a-428c-88ee-272dd55124fd	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:18.876931
8ed32aa2-c871-4a8b-b72c-1c5298a18e32	a6e22a23-df98-4aad-b9a2-2284806cb4fe	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:18.876931
2bd3b353-e192-4fac-8f0b-b85a830bb9dd	7138062f-d973-420b-8a37-69cf4dae497b	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:20.300058
1bf9a1b0-b062-4ba1-82f8-52d5ce55e99d	6420093a-dd4e-41c3-9867-fe9c18bad861	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:20.300058
e67193a4-b13e-4052-b14b-f18768eceb42	96cd9f58-2fd3-418c-b2e4-4e709e0b998c	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:20.300058
f9a68ddd-3b9c-4f60-bd0a-2df07edde64e	738277ee-5d19-4fd2-a586-af21c44b6df5	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:20.300058
1471d489-c894-4e39-ab22-92891d16f529	28154792-c153-465d-b6f1-588bd4c35c34	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:20.300058
a3d91a41-0d16-4182-8d49-2ac07cc6f966	1f82b411-19c3-48bd-abec-1246b74033dc	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:20.300058
56125447-eb08-4851-9aad-9a36bb5bb681	2013cbc3-6ec9-4c64-9ba1-2877404eee90	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:20.300058
ec4d4491-64a8-4791-96ca-a6747930d42c	39df389b-f9b5-45d5-a953-58ceeaa6b5ff	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:20.300058
fa38f4df-4c60-43b8-9208-dc51fb224821	bf4f8ba6-14c8-45bf-b75e-1a578426c17d	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:20.300058
eb021b17-b13b-479a-90cd-ae38b47dfc61	d61d2687-361d-4f8b-846e-32a91ac3c518	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:20.300058
d75d1bad-33dc-4dec-8364-6ab068a69776	853cbcce-8eb9-463c-874d-d145c91adef2	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:21.654944
ce88727a-7d57-45c7-9561-d480828f36fa	286a53b4-ba56-490f-add3-c903358f7a27	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:21.654944
1e31416d-8bbc-4ad3-acca-66dc5d434af9	13f9ea92-b8a1-44c5-b7c5-f78ed092d431	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:21.654944
d9ec803b-13fa-40d2-a38c-6d6a40bb40bb	0253bd21-213b-420c-a5bd-686335e9af3a	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:21.654944
72b6bdb3-8aa5-416d-94d5-904f4c5d75bf	eb8f3d9e-6ff6-4785-854a-a69a07a03df9	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:21.654944
9b1cb79d-a9fc-47cf-89df-78e198c42f1e	9d62ddb3-8302-4ecb-8e8f-12c131af5107	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:21.654944
79944940-7b63-424f-b64d-1ed46405a713	6711447d-8404-40ba-8a78-899a7822f741	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:21.654944
130eaf1c-7f70-4054-920d-8d7fa23ea9ee	66759545-dc3a-4021-8701-29a2996aec4d	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:21.654944
5f1076ae-63cc-492a-8c39-47014def50db	d5e0d1c3-0da6-40bd-80ca-cec59c1b9f22	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:21.654944
2e46745d-0b42-43b7-9fc2-48135df3cd9f	e2c460ee-d8de-42d6-81f9-90110b4cc9c4	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:21.654944
6088940e-ee96-49be-a975-cfff9e06e38a	ca013939-6275-45ad-82b4-14df7e22d8e1	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:22.995806
7e5ecfeb-746e-42a2-a748-aa889c3d0407	27e77bc3-1793-490e-a5ac-d17709a9d4c8	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:22.995806
386f2e76-ef19-458d-a3d9-5df1031ff099	ad2bc73a-6fb7-4ff0-b446-bfda3504c620	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:22.995806
991201a4-437d-4f67-9fe4-465b213a6832	e85c4a4b-3958-4aab-afeb-ac0d2cba2bd9	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:22.995806
d6c57720-b3d8-49a4-94da-30ac868c0765	1e9ef74a-6e66-4d58-a289-d7e13770aae3	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:22.995806
cdc2ae3a-8ec2-42e4-8560-f56392794b16	f12e66be-7c40-4bee-85a0-d4fa0a8f1210	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:22.995806
dcaaf785-b441-4bb5-90bc-a9c3fa17d558	a2e3d6ba-5a46-42ca-bfee-3f48cf72a99c	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:22.995806
fcb0c1ae-d929-4909-ac1c-42e7c54f15d8	4f7777c9-7da9-4025-9db8-d0ae7e256b73	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:22.995806
822d2b05-46f8-4db0-aedb-2707ace7852b	6b92af56-0d35-40ab-a804-e8cc1aeed46c	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:22.995806
4ee4ab35-4da1-4217-a909-1703a9315d66	960a6335-f88d-46ad-9f98-6de6acd356cb	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:22.995806
f7118b1c-026d-48b6-9c34-a83f79a8781a	704fcb18-bec0-4ef8-b116-8d5105ff0926	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:24.331911
72eab870-dd58-49b1-88fa-bc40f30a8bf7	44c54deb-0bf4-42d3-9382-0e414bd53a7f	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:24.331911
bfc0f094-6bae-4e2d-b515-e8afd01b93a5	13a25535-4809-4957-a871-a8b3d87674ec	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:24.331911
804567e1-2cb5-4226-b0a8-fe64e45cfce8	f47e4bba-7906-4598-97e1-6378077c1778	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:24.331911
573faf2d-ca28-4976-8a74-ed32b744c1b6	0f227649-b0ee-4ffb-9e33-c506c5299319	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:24.331911
336a0a3e-7186-408f-92b9-4509771ce656	889cccc8-8b8f-4446-92ba-b7a150bda7be	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:24.331911
d5bfde3e-537b-4771-92a0-1a5cd1754236	75f4bcf2-6caf-46ed-9088-d8dc7ed14432	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:24.331911
d7a2288c-79e6-4afc-aa03-24a7c6b7d9c7	6377991f-4e05-4406-b543-d58803e79971	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:24.331911
556b9533-a8c8-43fb-86c6-f7ea2cbbef0d	81a9ece6-5c1e-4a09-8453-724bc0a013c0	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:24.331911
f2f2405e-a15e-4e0a-9617-bc700dfb80b3	52360625-fde9-45dc-a7a4-d66dd9227263	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:24.331911
078d9b00-caa1-4cb5-bab4-2cd1a109b69a	8f3fdc0a-d750-4c90-9900-ef854c348eb6	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:25.775779
2e16579b-94ea-4a2f-864d-25cf8094e154	0aef59af-9821-43bc-b542-66af0db0167b	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:25.775779
c3ea426e-446b-4ee8-bc1c-c570b3872b7c	5cd1c146-20a5-45b9-91e8-5fa6830793d8	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:25.775779
ee4ab891-7e1b-4b9e-b02a-e5605b2b7b02	691aeef0-58b6-44f9-b666-dc9715586901	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:25.775779
cd4cd377-c405-471a-beab-62a92debc044	8f357fa1-2270-4ad1-9287-4ac8640babd5	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:25.775779
30fa5388-a145-4f79-88d5-74a712eae2a9	74d03931-09c7-460e-b77e-37f6782fc3dc	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:25.775779
d9a1d1ac-9c42-4d27-965d-85997adc961f	cc73892e-ec68-42de-a2ef-961b0d478740	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:25.775779
3b48027b-c3c0-42d2-925f-04fa59f5eba0	20c7d8db-8fe7-4765-96a7-606bd6be9bbe	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:25.775779
64852932-4e84-471e-9ddc-27a4b09682ec	ac37dba2-931c-4467-bb66-11bd99ada152	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:25.775779
034aa3e3-00fb-484b-a10f-3ba96e14fe04	b1845123-32b3-4579-bfaf-247c9ef6b0a9	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:25.775779
409e705c-1d3b-4c61-abd3-6076140c2eda	150f7a76-2112-4716-896c-6b0bbffd4df0	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:27.055761
f504d1a5-29d5-4eb5-8730-30e4299d1c23	743c3017-9fb4-47c6-a7af-09cf9609d22e	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:27.055761
340ac13c-66e6-4616-a738-5ad3e53de9dc	ca920878-173c-4021-af24-d162c1ae54e5	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:27.055761
5ad8dcfa-8d8d-41fc-b989-0f73233981d9	3966eda0-da0b-446b-b607-b00ab1871c4b	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:27.055761
c1ca9175-e2c9-495f-a3c6-11298192ced4	6c8f1375-7205-44e2-a04a-4a8b30e9294a	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:27.055761
4b619ce7-7372-488a-b9d9-ee48cb107b71	d0816468-e6d9-4f8a-962e-fa91cf2090c5	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:27.055761
89e935e9-e7e0-4494-838c-bb65f4ceea30	301858fa-ca32-4ea1-b5c3-6c61d778cee3	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:27.055761
3af0c305-58db-42af-90b7-dd9b4efc8c08	92ede9d5-c8c5-4465-a583-8c3c8db62a6c	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:27.055761
ba7377fb-dc81-40a6-834d-670c09deab09	3d5cce4c-2382-4485-8e69-aa2b69866c85	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:27.055761
0cadbb2d-24c4-4a82-a7f7-27f60a551952	91796710-4867-4173-9cfe-e44953fe5c25	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:27.055761
771b2e8f-206d-4cc2-b282-ae80c8cc6e8a	3968af74-15f6-4769-96d1-a39b56a4b39b	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:28.601989
ce6762b7-7e3e-46e0-9886-b6ca5c0027b5	2774e85e-27bc-41d0-8957-8132133a65a1	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:28.601989
170bb8ee-7b96-41ca-9a9c-17b9e0321390	53fae0a0-f25d-4929-b448-4c1069c9f9b9	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:28.601989
e7822cc4-83b6-4464-ab67-0bc58a6e43e9	79ae2d36-7a11-43b1-8d84-81023e5a647b	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:28.601989
9e98b6be-8783-467f-928f-60ff9b7c3a6a	ff303344-7669-42b9-a2fe-f60baf7452e5	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:28.601989
fbafdd74-cfed-4566-83f1-75d8597e7d95	771f60cd-78bb-435f-8527-25a953ca0f63	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:28.601989
f70d7dfb-2e5a-4e95-b5ea-c7e186eb3d7d	fbe876a7-3b6e-48a7-867b-18c06013f4b6	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:28.601989
8cf7ffcc-5cb5-4f7f-9f44-122c1af5efb8	723f1487-104e-4055-89a0-a9cf7cb090f0	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:28.601989
0ef6160e-9f67-4e8a-871f-5e3b7bb5c328	bea17461-8890-4112-9278-e0527d7ef115	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:28.601989
71e9741b-1f8b-4d70-832a-70f2cddd3813	184d4859-3e78-4213-abba-230c98b93b1f	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:28.601989
6f9e9963-f647-44d3-9135-69690f20a2da	5d3556ba-9ea0-413c-8ed2-dbd3df1e3a4f	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:29.894406
9cc600f5-b90d-4528-ba3e-9ba3b3a9192d	e3c60a43-8eba-4767-8c2b-a366b112aaf1	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:29.894406
2cc6bd4e-e1b9-41fd-9c4b-b5d5e00004cf	49088693-3597-49e8-b8fa-9d42359e4c60	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:29.894406
bfd64608-24ef-423c-a760-130ea97b4369	1f3c9443-127f-4694-94d2-0005688eee1f	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:29.894406
9d9cbf6d-a548-4889-95ec-9c1c3ff9b091	a7b342e5-0a32-4613-b7ab-78baef4e3fbd	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:29.894406
516220b1-1f8c-4b18-8682-6a3349650f58	6f20f803-4433-4456-a7fb-27875195bde9	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:29.894406
e83ef5f6-988b-4c5d-9fb0-bc0384b1eec3	8898b6ae-c785-4339-bd33-883339bcdc6c	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:29.894406
c7a83832-40f8-47e8-bb05-b097078dc96a	8a0f4c8d-6360-4139-8f98-6bd7b3725cac	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:29.894406
4999a015-6398-4404-b3fd-bc549d2355de	25c56572-3573-43f4-80ed-07209c6009dc	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:29.894406
fd5f1279-e107-4f47-9391-d5c72f4ce2d0	71baeec3-d6ea-41c1-9df1-e9b04e85283b	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:29.894406
711fb206-b49b-4bc7-96e7-8b79361db17c	d322cdb5-7267-48bb-8736-56f60a35faf5	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:31.396008
259da0b6-9437-4354-8629-e6adc9d242f7	574c977a-664c-44d0-a1f2-c0e0d174b3c5	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 11:04:31.396008
f2c3df34-64c2-46e3-a4f3-3d86ca619d8c	0b53066c-68f8-4385-9062-13bbc206c68f	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:31.396008
bce294fb-1c21-4d3c-83b0-5648ab2fe866	4d9f35b8-c973-4a68-a538-e61589f18588	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:31.396008
db22b49a-7e80-4a4e-911c-d287ee41b877	9cec3581-54c9-42f3-a496-2c8789e7d915	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 11:04:31.396008
444612db-ffef-485c-b43d-928320cff072	06037f6a-40e5-4ce7-8f7d-b28167309e81	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:31.396008
38ad435d-67cf-4700-ace1-9ee3cbbcc779	1dbd3e96-0e27-427a-92c9-85a3b837ab2a	video	This changed everything → Here's how it works...	1	2026-04-26 11:04:31.396008
ae8b882f-fcec-4a75-8c32-bd8f42af5bb2	289200d9-da84-469e-aba0-c4e5dffd557c	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:31.396008
86c7febb-7802-4e68-96fe-0b641a807048	1abf996c-d0e5-435d-be5f-31f62f4d9bc6	video	This works in 24 hours → Here's how it works...	1	2026-04-26 11:04:31.396008
84f277e7-4166-4dfa-be0d-d2e42cc1da82	2274f059-2a47-44de-8683-914e5b2ce995	video	Nobody talks about this → Here's how it works...	1	2026-04-26 11:04:31.396008
413349c8-f68f-4516-8d2b-dd5bf9dc47d2	499da728-ef77-4511-b7fc-64be7288b193	video	This works in 24 hours → Here's how it works...	1	2026-04-26 12:07:41.115891
9b71c1dd-3536-4f0c-b713-b98de5c7f8e0	8007644f-7595-4841-b2fc-68e156af22d2	video	This works in 24 hours → Here's how it works...	1	2026-04-26 12:07:41.115891
8d6b5528-8a57-4dc9-ae5f-52bb1085dbd8	2556cbaf-5c06-47b6-8851-2f7979d3cf9d	video	This changed everything → Here's how it works...	1	2026-04-26 12:07:41.115891
3fd50c70-1afe-43e7-bc94-86656ea77451	873bb4b9-93d5-429f-900f-76e5272c2461	video	This changed everything → Here's how it works...	1	2026-04-26 12:07:41.115891
1e1eeba1-d680-4ff1-9ac4-b891184dae82	ff1cadea-298c-4a2e-8bdd-d908a1990cec	video	This works in 24 hours → Here's how it works...	1	2026-04-26 12:07:41.115891
1d78ca52-c1ca-45fb-ae1f-1565e49125de	3c0cfa48-674a-4eb4-b1ca-7339e9227fd5	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 12:07:41.115891
b10291cc-2eb3-4066-842d-643126c0d461	6f2534c5-1591-4ed7-8a55-6033c8c5e823	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 12:07:41.115891
3bcd22db-f050-4bf1-990e-e1955140c5a1	8d12549f-94e8-4e6e-9d88-d27d4944c307	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 12:07:41.115891
e9a5c834-139c-45db-9ab4-2b993e61da51	e57b4b7c-52a2-4a03-bff9-8a2774caffbb	video	Nobody talks about this → Here's how it works...	1	2026-04-26 12:07:41.115891
740d1b16-eb50-4c21-a908-86abf0a38e51	1a54b840-61bc-43a5-b2aa-53cfd3343800	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 12:07:41.115891
5d06d71f-8d4d-433b-a683-dda9e7e3e6b3	5e323efa-f6ab-4b1f-8ef2-e0e1970c1b16	video	This works in 24 hours → Here's how it works...	1	2026-04-26 12:07:42.619504
8c9cff80-c54a-4d12-9ae3-0942ee3ac043	11eb9817-9d8f-4853-ad71-0945daf183ad	video	Nobody talks about this → Here's how it works...	1	2026-04-26 12:07:42.619504
fbe66544-438a-42ec-9f8c-f8d847876827	bfff2b04-1680-45fb-91e7-9e8fd894279c	video	This changed everything → Here's how it works...	1	2026-04-26 12:07:42.619504
4318f833-dda2-44fe-a4af-6d84165aeff7	8e736cbf-b4c9-4b88-8d28-9e6a6e8345ef	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 12:07:42.619504
226f373b-d4f7-4ae7-bbcd-4f6c08f46c0f	7e320760-ed22-4649-b4f8-6df0d69704a2	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 12:07:42.619504
1a7b0ac4-94ba-448e-8c85-0e58a266c720	92ca5c18-31c2-481b-b8e4-7352359b0ba3	video	Nobody talks about this → Here's how it works...	1	2026-04-26 12:07:42.619504
959e2060-3ad9-4409-9e13-4f546f4a473c	4202baf6-78f4-44f8-81bd-1226bc0d4e15	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 12:07:42.619504
dbd0e22a-bcce-4037-946e-5f9eddc669d4	580d07f8-1fee-4ed3-92b0-d33cd5ccc728	video	Nobody talks about this → Here's how it works...	1	2026-04-26 12:07:42.619504
2b210f3b-54a9-4220-80d0-5f1782b2bb9e	c3265caf-00da-4b7a-aa36-748e2b1a46b2	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 12:07:42.619504
34ebaee5-8ad4-48a2-bd7b-780c9d41c1b0	72befc66-6911-4b7a-a520-129520116bf8	video	Nobody talks about this → Here's how it works...	1	2026-04-26 12:07:42.619504
81136f45-c431-4cf6-a6c8-4ccfc7ca4a7f	aaff94bb-c124-4aad-8941-6a3b2bd33949	video	Nobody talks about this → Here's how it works...	1	2026-04-26 12:07:44.923746
6e251895-cdcc-4e5d-90f7-4fc5ddc6d5fa	afe5f927-f4d7-4106-9ed1-c613ce2447dc	video	This works in 24 hours → Here's how it works...	1	2026-04-26 12:07:44.923746
0e50f9a7-2915-4df1-a257-7019ff264535	3decc9d6-2c25-484d-97ed-0ee09ed5907b	video	This changed everything → Here's how it works...	1	2026-04-26 12:07:44.923746
224ca70a-b633-4ec7-8a0e-6f34c5c9f8cd	b79304fb-cabe-432d-a084-ee75d3481eba	video	This works in 24 hours → Here's how it works...	1	2026-04-26 12:07:44.923746
492d7799-0a83-4c7c-ab88-8c823757fb40	bdc76598-8a60-4987-8ddf-a8fc3b9f7eeb	video	Nobody talks about this → Here's how it works...	1	2026-04-26 12:07:44.923746
f4cda7c4-875e-4986-b652-4fcf560695d5	64530faa-30ad-4397-a5cd-c37c4eac4abb	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 12:07:44.923746
8d9fb776-a316-4aa1-bee8-aa93402306dc	78df5b39-25ac-4804-8718-c83403a427a3	video	This changed everything → Here's how it works...	1	2026-04-26 12:07:44.923746
f88c0132-3217-4230-88d6-5d13fe63f341	dbfc8df8-5692-472c-a840-3b24f1e375cf	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 12:07:44.923746
59b34237-c2bd-4502-874d-7573847640f7	5abb2a65-fc4b-45b2-b96d-f1e4512e9e32	video	This works in 24 hours → Here's how it works...	1	2026-04-26 12:07:44.923746
12e61d73-e82c-4bac-bb03-a2da44d1e59a	15d0bf65-e3c8-4a91-8750-9256611968b1	video	This works in 24 hours → Here's how it works...	1	2026-04-26 12:07:44.923746
972991bf-8384-411d-8e75-3479aa9a1a80	da19c895-db86-4728-b344-7a2a2d558b77	video	This changed everything → Here's how it works...	1	2026-04-26 12:07:46.439983
273283ae-f6e9-4fd2-a8c7-fc9a4d113497	9aee01a2-aaad-44e6-a154-5a30b520ec76	video	This changed everything → Here's how it works...	1	2026-04-26 12:07:46.439983
30c76af3-ba5b-4c20-90ff-2196b797bac9	6ec0cd46-4430-4d0e-8114-0063c19a8084	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 12:07:46.439983
36db7ca3-3851-4159-95de-0f87933e95fb	18eafa46-f332-4736-85f3-13058e0f1c74	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 12:07:46.439983
f0f74e3c-545e-4318-b13b-f18c17bc4cda	e4a54105-e491-4a72-9f0d-4506aa0459e6	video	Nobody talks about this → Here's how it works...	1	2026-04-26 12:07:46.439983
54690207-21ab-4a49-a243-293efb1e6d52	86fef383-9409-429c-b03f-b6f9f82b776e	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 12:07:46.439983
48f31bc3-4d9e-44aa-8079-7193101e3d28	b9589e6d-1321-4d5b-a4d4-1d3a30d23578	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 12:07:46.439983
b430dbae-a37f-4933-bf53-4bb220af6705	47aa069c-2ca8-4f6d-bb76-10e4c6618866	video	This works in 24 hours → Here's how it works...	1	2026-04-26 12:07:46.439983
616b4ff4-2bb4-481b-8879-f2828515f0f3	1fa1de33-8bec-43ff-b418-7ad3d84786dd	video	This works in 24 hours → Here's how it works...	1	2026-04-26 12:07:46.439983
9485838b-7711-448d-91ad-34f5f74693d1	40fbfdde-3b88-4aa3-abca-63379458127c	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 12:07:46.439983
4980e77e-0513-4aca-8f48-47c728b18367	4e2307be-efa9-46fd-b340-80313d6aaedd	video	Nobody talks about this → Here's how it works...	1	2026-04-26 12:07:47.385922
cc6ae0fa-1ec9-4d02-8fa0-d1994c1c5d30	08ea7f7d-0192-4a4f-86bd-873f4e6fbc07	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 12:07:47.385922
910d2e33-094d-4b86-aa3b-6e2ba2362c71	3c3ec71c-ff6f-43e9-bc7c-d83cf7ea17db	video	Nobody talks about this → Here's how it works...	1	2026-04-26 12:07:47.385922
b5d67a14-4e64-4a06-b6c0-51107c2aeb03	b531718f-453e-4211-9a35-e4f03cf8ce2b	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 12:07:47.385922
a0534bd2-9ed8-47f2-a595-bfe61b4ae0b2	b9b147cc-36fb-4db7-b95c-82a798b1892b	video	Nobody talks about this → Here's how it works...	1	2026-04-26 12:07:47.385922
583b9645-0a3f-4487-8210-d9849a0d0eed	e52e3da1-38a3-440f-96c5-1f89492c7d95	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 12:07:47.385922
fb733b26-eb1b-4c84-ac19-21b6e53afe49	928f668e-e8ec-4309-93b1-965d982d7bd0	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 12:07:47.385922
d4323fa1-4992-4de2-a48c-33c7b2450da4	35a3c642-0f4f-47ea-b189-cafd0fe874cd	video	This works in 24 hours → Here's how it works...	1	2026-04-26 12:07:47.385922
6da107b4-b94f-452e-94be-5ea2f904e6b5	dc212ae9-032a-49d0-b9b9-20de1fd70529	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 12:07:47.385922
360c8f8d-2c93-4fe4-9697-816037f7ac56	b955728b-fb70-426d-a746-ea8d3aba03f0	video	Nobody talks about this → Here's how it works...	1	2026-04-26 12:07:47.385922
95497327-6165-4ab7-84cd-3838fe66459d	470d6220-1cc8-4460-98d4-1d5175148a46	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 12:07:48.845872
b2499662-1d45-4d3b-aa9e-834932ef0f46	c0bd4d3a-ae2e-4b2a-85ba-2562055ddd9e	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 12:07:48.845872
a04d5f18-7754-4063-9d53-caf7a01d1f79	5e15bbf5-02a3-427a-99ee-c20054e6a6e3	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 12:07:48.845872
61c62405-b3f3-4c20-bed0-000d78d334bf	29444789-770e-4391-8875-93825eac01b0	video	This works in 24 hours → Here's how it works...	1	2026-04-26 12:07:48.845872
528333fb-a6fe-42dc-a9a2-a89ed4923f48	262caebf-87c0-4817-afd4-026220659229	video	Nobody talks about this → Here's how it works...	1	2026-04-26 12:07:48.845872
98339d49-74c0-461e-98e1-5447b8afee3a	93add8e4-2c13-40b0-a554-535612c5a3db	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 12:07:48.845872
b8d216cf-6639-4522-b792-1a5dc9eb44be	6867bde2-d34f-40a0-a72a-725e76a95122	video	This changed everything → Here's how it works...	1	2026-04-26 12:07:48.845872
5170d295-f76f-4365-afaf-5744b0666f03	6a4d121b-4cb8-421e-83bd-963711d4c685	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 12:07:48.845872
3646a368-e2b7-4396-bc98-7610171b8909	402c1902-9996-484f-9065-e77f4bb33d50	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 12:07:48.845872
684ec293-5fa6-444f-a8e8-b9e70471b711	2471a52c-0c82-4693-b9ad-fe5957a78d4f	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 12:07:48.845872
abfbba91-7d56-4ee4-8067-a154254d6aee	b3ea44f2-765c-46ca-98d4-955c64196220	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 13:06:38.215103
9bc94a88-ace9-43fe-a9ed-6f2f2c177790	fd2c7a30-70c2-4045-a1f1-2361dba1fad9	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 13:06:38.215103
7c5b7074-7608-49d5-affd-f94ba956f7bb	1351fcc1-84e1-4541-a8e6-747c1a258b1c	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:06:38.215103
4d5196c2-f573-4866-9c5f-2aaae69507e3	90def8d4-07c7-4935-9dcd-c66c4d93a4fb	video	Nobody talks about this → Here's how it works...	1	2026-04-26 13:06:38.215103
2b2c8b55-bebe-4b78-8ee3-8a97a5d61d6f	7bf0dcdd-2a42-4b53-a373-8c08d493a549	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:06:38.215103
16bbf445-b315-4e26-9e26-a2393b248f41	509c09d3-7f21-47a1-96cd-02f8b85c71a8	video	Nobody talks about this → Here's how it works...	1	2026-04-26 13:06:38.215103
a380c129-2134-4575-a7d2-8b8cef053381	35f345e9-d7ba-4889-b0a2-ba16a6ed5efb	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 13:06:38.215103
2b93061e-70ba-48ef-bfb1-a932c89f49f3	59bb5d9b-9d56-4850-9fef-0bfea7a14f9d	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:06:38.215103
fdb1309a-f65b-47be-aa62-7faaedee33db	fadb8add-2998-4dfb-90b5-73cd64559ac1	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 13:06:38.215103
e244aac4-c40d-4376-9355-5dfc53af9b25	940657f8-245d-4b85-a724-3fe5710c13d7	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 13:06:38.215103
0aee3b31-8b1d-462c-9900-62e9f967029f	432054ad-1eb8-4e02-a194-cdf1289743e7	video	This changed everything → Here's how it works...	1	2026-04-26 13:06:43.700789
a816960f-bce8-44fd-b257-935532e42ae9	ba42d380-1515-47ef-be19-90f1a6feb784	video	This changed everything → Here's how it works...	1	2026-04-26 13:06:43.700789
fb0d074e-77ed-49de-8751-03924355a4be	dc1597fc-81fe-4490-a22a-7012a76d9583	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:06:43.700789
e507b2d1-f720-4e81-9ff7-98ddf2de30a2	66c925c0-4e7c-4474-ac20-8d4d67abfd03	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:06:43.700789
2b8e44dc-af76-4299-9b91-334aa51d1b44	cbfd5cc5-22f2-431a-b385-d0efec02e629	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:06:43.700789
3733121c-87e7-406d-8a61-abadf11c8ff7	9a90186e-346e-46e9-ac61-19f1afcea5b2	video	This changed everything → Here's how it works...	1	2026-04-26 13:06:43.700789
42cac6b6-db0e-4650-9827-28aec37d1c4a	c94fdb43-5b3f-4647-aef8-3552fb22c7ac	video	This changed everything → Here's how it works...	1	2026-04-26 13:06:43.700789
2a7f1d46-706c-484f-989b-12570476e1b1	c80536dd-ba94-4cf7-9f02-54241c3ef20e	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:06:43.700789
e74a529a-4415-4cf6-9f54-0f508893e890	6e56550d-5a3a-4eea-b77d-3745c087e26b	video	This changed everything → Here's how it works...	1	2026-04-26 13:06:43.700789
c13e985b-b576-43bd-a846-c07116f4e485	611201fb-cb10-4476-9146-b9a18302bd9f	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 13:06:43.700789
0f83c59e-894f-48d9-ae8e-37891f4a6b3f	bf5819bb-2c50-4e6d-bbac-c971245f29a3	video	Nobody talks about this → Here's how it works...	1	2026-04-26 13:06:45.537772
96efda3e-7e8a-45c7-9a18-2d6f5f600949	225be0e8-9288-4e2d-8b43-359ed7103e9f	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:06:45.537772
a6138472-a810-458f-9219-ebb9d6004b03	abbbc53d-3131-46dd-983e-840537fafb88	video	Nobody talks about this → Here's how it works...	1	2026-04-26 13:06:45.537772
13ece67d-af7a-4594-8854-99fdbd035893	e4e04afa-9d4d-430c-83fe-63311c59e216	video	This changed everything → Here's how it works...	1	2026-04-26 13:06:45.537772
c6048d93-efac-4c04-9639-20b822e4f013	359a1bf0-4ea2-4301-9dc9-e98b3b1dd243	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:06:45.537772
e96a429e-a78f-4c35-9510-e97ae7efd3af	e6891b99-5a31-441c-bce7-bfc37917e75c	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 13:06:45.537772
dd0d090e-3d47-4070-ad5c-0b7b5770bbd7	4ff87823-6486-4d3f-b806-4102d37517df	video	This changed everything → Here's how it works...	1	2026-04-26 13:06:45.537772
d3eed5c9-476f-4caa-addc-34a3f6f43a6c	8e9409be-22bf-4a37-b388-a080e8c98ec1	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:06:45.537772
30dbffd4-3520-48a4-ae5a-2978a005f217	a9b15af0-091f-4180-bc24-5bb692a834e8	video	Nobody talks about this → Here's how it works...	1	2026-04-26 13:06:45.537772
38a98d5d-724c-4dc4-98f9-3d53f5e6ff2e	2b085efb-9267-4167-ac43-e4845c6eb367	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:06:45.537772
371184cd-b71a-4187-a074-bc5a4dc019af	37c8e627-0729-4251-8f8f-e6a6c6864d83	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:51.013922
43e295e0-71c9-436b-8d12-7e4ec121b357	67c66b14-cd71-4eb8-9f7b-d2f81c036a4b	video	Nobody talks about this → Here's how it works...	1	2026-04-26 13:17:51.013922
f19f9a2a-712c-4fcb-b3e6-032120e03435	7638745c-7351-40d3-bb1e-2d9d0e89e6b8	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:17:51.013922
97e8f8ce-76c9-4eae-9387-85df2504aa3d	20e1dcb5-2e78-4d66-99b1-edb3531e24cc	video	This changed everything → Here's how it works...	1	2026-04-26 13:17:51.013922
2bd52b53-522c-40b2-ba45-f2f1cb9362cf	ce5b5e8b-050f-49f9-a8d6-ad422e6188f4	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:51.013922
b09f653d-5448-4141-bb4c-73ca0a2a00f0	d3770319-90eb-4821-816a-3216fca48c42	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:51.013922
90971154-1b26-46b5-a0a5-9dd831252224	44a4f089-d37f-4ad2-8015-daad4969bcae	video	Nobody talks about this → Here's how it works...	1	2026-04-26 13:17:51.013922
90da206f-0378-41bc-8c6e-84b19a3fa3de	ede6aa08-f620-4146-b96b-7ff8db526ff4	video	Nobody talks about this → Here's how it works...	1	2026-04-26 13:17:51.013922
47d95acc-9e3f-4267-8945-7d931cfd496e	5d0bd4be-df2a-4e27-a105-bb9ecf2da99b	video	This changed everything → Here's how it works...	1	2026-04-26 13:17:51.013922
1aa8e75e-a677-4e7b-8fd5-8c3985434b08	ddf0a8b4-2bc2-4d01-ac0d-03bf2613401d	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:17:51.013922
a09ac23f-0379-4eb9-8377-944baab42a23	8e87ea9c-475c-44e2-b50f-add2477201e5	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:52.834004
6ebf92a4-f61a-4ce4-af23-c3094d4fce8a	060d90e2-52d3-445f-a786-1b97ccb59aa9	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 13:17:52.834004
e8969318-dbb4-4109-ad5e-c40c01946e2d	bd0c012f-f134-4eea-bb56-d578ff84d8b6	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:52.834004
850737df-cacf-4f65-a0a8-569ad6b188fc	7f1dd182-2dab-4289-8f7b-2bf47151569a	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 13:17:52.834004
487107b9-d3c6-4e39-b992-e549f858d17a	e3d2b48e-2421-48a9-baa3-a4b64eb945cf	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:17:52.834004
8c830f1c-488b-4e81-8ff8-8eecddf1bd68	d438e056-4730-4db8-838d-169ba53afb54	video	Nobody talks about this → Here's how it works...	1	2026-04-26 13:17:52.834004
0c1aba4f-b5d7-4134-bca7-3c27991df4dd	09f71655-acfe-458c-a422-c3823f1a2e07	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:17:52.834004
d0445f0a-7d5a-4679-a821-c8909327cffe	60a2a8cc-0444-4e1f-96a4-937adb6f8e41	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:52.834004
684eda63-7488-4990-b248-127285655144	4d976152-62d9-4c25-ab6b-959b0ff22940	video	This changed everything → Here's how it works...	1	2026-04-26 13:17:52.834004
f375ed3f-c5c6-4e46-a5e8-f673caae3b4b	6d85489c-bfe6-4d03-ab26-2b5065781e7a	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:17:52.834004
b71c2fb5-64fa-4f92-a807-94ad9b4ff7e8	7a57f64c-cb2c-4e13-a719-467b7bcdb2fe	video	Nobody talks about this → Here's how it works...	1	2026-04-26 13:17:54.64816
709775a4-bb62-4bc2-80f7-667166a750fe	94f07196-2acf-4783-8d8d-b4674f675d4b	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:54.64816
babce5cf-36b8-420a-9166-f7d7de8fa28a	02e682f9-0c2a-4a64-a56f-5ff31e0761d0	video	Nobody talks about this → Here's how it works...	1	2026-04-26 13:17:54.64816
9dff43a3-b35f-45d0-acc7-b13fc8b0994b	14a03c35-8f5b-426a-869c-5205f666d1a1	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:17:54.64816
904352aa-28f3-4b8b-9d72-71e23ff6bd63	3d80c3b7-9cc4-47d9-8449-2ed5c9c5a33f	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:54.64816
914fa68d-983a-4766-a0bf-c233526ae46a	95b3f013-7ae0-46f7-862e-3491cd00aadd	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 13:17:54.64816
eb6cb7cc-12e2-4328-a63f-769eefdb9171	5e305f8f-43e9-49bb-8869-335eea031356	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:17:54.64816
eae13c74-3271-47bd-9a9f-1de925b4e7d8	516a27d9-6540-49ca-8e45-469e4d53e01f	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:54.64816
439bbf41-17b4-41b7-aa6d-f99ac557d3a1	8efe7416-fa08-4c38-a392-8fef35d8513c	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:17:54.64816
6ecc9c68-44d8-4a4b-aa02-4c6a0c8cd073	e79b692c-d1e2-4630-8769-0d9f1e5711e8	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 13:17:54.64816
027381d0-1ca3-4d37-a6a4-0f75db489eb6	6eecb6ac-c93a-40f8-bc3f-21464c613902	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:17:56.452692
f26dcde1-d6bd-4404-9ca7-95c9753a7fc9	21d0709b-4c0b-424c-864f-e81432763d0d	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:56.452692
9b79e144-0d30-4127-b1b3-f97f3b500156	c76d5a27-301f-4f63-8b83-9b2a439a32e7	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:56.452692
978b04bb-6b9b-40b8-93a4-c824191433fc	a02f8346-1d57-48aa-871e-80dc28191a1f	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:17:56.452692
7c2c3342-941f-4137-8e8b-e2308e155df9	85787ab5-3dcb-4a6a-b637-c4a369dd0808	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:56.452692
478916da-9356-4538-9508-89c3ef0fe4cf	e87fbb77-1346-45d9-a25c-891bc968b2f1	video	This changed everything → Here's how it works...	1	2026-04-26 13:17:56.452692
8ffb2692-0865-46e2-99e5-02ce6c2076a4	46f14546-6eb4-47d4-a520-22122d218daf	video	This changed everything → Here's how it works...	1	2026-04-26 13:17:56.452692
9ad0d99b-b389-4864-a21b-858a4c24a015	6dcff7a3-ba59-440e-b702-18c6d2de3ebd	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 13:17:56.452692
80dbe3cf-1381-41e7-9000-480dd556191f	f6a0176f-0c5e-4b7a-96d3-51e1ba726c44	video	Nobody talks about this → Here's how it works...	1	2026-04-26 13:17:56.452692
70474a76-f8a5-4fec-b8a6-872ee53dbf8a	d6d50c92-c722-4046-beda-8962fbcb73ad	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:17:56.452692
59459005-9568-4050-9861-c59c5b207499	b44f25d4-24a1-4d9b-b5be-4d892991fac9	video	Nobody talks about this → Here's how it works...	1	2026-04-26 13:17:58.301979
44f85f0a-e7f6-42e7-a625-d4df3a26769c	154c8d27-72d9-455a-9a73-588303794837	video	Nobody talks about this → Here's how it works...	1	2026-04-26 13:17:58.301979
bbf5bd9c-642b-46dd-8faf-9ea16ddc2112	25d44daa-6ef2-4b24-90b1-9c16e8f9758e	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:17:58.301979
cc66d7f7-5065-44b4-8d3e-43ebd8637080	78d0582f-93e8-4949-9dac-28644c4eb081	video	This changed everything → Here's how it works...	1	2026-04-26 13:17:58.301979
59db586e-4b36-4fe0-a118-5b86e6180c41	70de4349-1b45-4457-ba6e-be2afb685b8c	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:17:58.301979
03382ae0-ccd2-4c59-9526-c2cad363b327	5ba37c68-3c22-4467-9085-67660556722c	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:58.301979
01c540ee-2971-4341-84f2-451aaf8856f5	c97a91bb-57a6-4bf0-9661-f8b7ab918be7	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:58.301979
6f3762ed-5ffe-4e9b-a579-a5073c76b4f0	63abd579-bc0e-40f1-a4b7-4037108d3b5e	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 13:17:58.301979
2c9462ad-1010-49d8-8b6c-ee0acbf69fed	d3ded896-cd9a-493d-9c7c-39e7f73f6683	video	This changed everything → Here's how it works...	1	2026-04-26 13:17:58.301979
4ba9de36-3e25-4da5-9587-f971bc5789c5	ad27536d-beee-41b4-b192-edbdb04d3dc1	video	This works in 24 hours → Here's how it works...	1	2026-04-26 13:17:58.301979
3bd631e3-c801-4ff0-9945-989b0b131bf2	9a3c7471-62bb-49a5-9898-6b6fdfac89d1	video	This changed everything → Here's how it works...	1	2026-04-26 17:46:18.834365
05e5daf6-2391-4e0f-9815-e6402cef6752	48a767eb-36bb-41b0-a492-5a0d2d4411f8	video	This changed everything → Here's how it works...	1	2026-04-26 17:46:18.834365
b417d5ce-c83f-45a5-97b2-3e6569b9040e	dadea0c2-3505-4aec-9694-b7a65971e029	video	This works in 24 hours → Here's how it works...	1	2026-04-26 17:46:18.834365
d08bea7a-3183-495a-8921-9b0c6eeef2c7	6e6b18ab-9052-4194-847d-b4fe179bcb96	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 17:46:18.834365
54c518c3-042c-4de9-b74d-ebd4c5955276	1a5ea328-c08a-41b3-9d72-6c67bc3ae5e1	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 17:46:18.834365
9d82e4e6-41ba-4cd2-85cb-fb931650b7e4	e1fcff15-b0e4-42ff-b67d-386ecbcb010e	video	Nobody talks about this → Here's how it works...	1	2026-04-26 17:46:18.834365
4838b30d-80e0-4dd6-a9e8-ed54b3645830	8da06662-9998-4bf4-94dc-2c72713dd9f2	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 17:46:18.834365
008e99d4-28ab-4c8c-8c1e-5ea9c375efc3	de86346a-da32-4c1c-8114-48e5d032ee0e	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 17:46:18.834365
0507c4f4-22d9-4807-8772-14fe68cc78dd	b32aa581-f52b-447c-bb5e-0a802984c2a0	video	This changed everything → Here's how it works...	1	2026-04-26 17:46:18.834365
61bd340e-88d6-48c5-a7f1-d464b2e7da3f	65e3c0d5-ad0f-4a36-aa21-044671aab2fe	video	This changed everything → Here's how it works...	1	2026-04-26 17:46:18.834365
68bedddc-9b49-4ce8-bcc3-b867522725c2	6f13a794-4f72-4f89-9ab6-4937d718d4c5	video	Nobody talks about this → Here's how it works...	1	2026-04-26 17:46:21.59546
2fdca709-8fe5-4a71-8991-a399e142488f	dfa90ccd-b439-4544-b862-3eaff05572b2	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 17:46:21.59546
d0f3d919-cc82-4f7f-b333-d85ee6f6f0e0	707cfc93-e43e-4e5e-8cad-f8dcdbc44fb0	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 17:46:21.59546
961dab15-2404-4211-97f1-6a2f25eb46d8	4ee7b758-190a-4d8c-b724-0be3f53f730d	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 17:46:21.59546
bb968435-ce0b-48d1-8f8a-447b9a13572d	0c20eafc-bc56-440c-8c81-1add23f1b50b	video	Nobody talks about this → Here's how it works...	1	2026-04-26 17:46:21.59546
7f6d1246-6226-48e6-bc84-6ff423cd6c33	5694b17b-3b11-4a87-931a-99bc7479aee4	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 17:46:21.59546
8c3ab64a-e99d-4976-8044-be80d750b01a	596b2c45-92b7-43d7-987b-318c14b616a7	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 17:46:21.59546
ec4afb8d-2472-4758-86bb-7ba7d542f808	b8c09ca6-a054-436a-bcb3-cd562360bf3f	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 17:46:21.59546
0448c939-5782-4214-9736-fc4d3e4ca216	61725bd6-3a60-40b0-bdf0-a307a466e1e7	video	Nobody talks about this → Here's how it works...	1	2026-04-26 17:46:21.59546
e533e3f6-bb44-43db-8637-4f6397e49cb0	7abd12e6-1d72-43bd-8593-360c534aedde	video	Nobody talks about this → Here's how it works...	1	2026-04-26 17:46:21.59546
0f9587ff-f210-42c7-a3c3-34c21078abae	f81a5c95-c755-4857-ad4b-17962656b9dd	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 17:46:24.425479
08154935-9c28-4917-8c0d-b283a65a95a4	0818653e-a60e-414a-98c9-218fdb6612f5	video	Nobody talks about this → Here's how it works...	1	2026-04-26 17:46:24.425479
c32fdc7a-2ef7-4412-8501-3d94c97a631a	a11c286b-65ed-45dc-b6f5-6f0f9d4d651d	video	This works in 24 hours → Here's how it works...	1	2026-04-26 17:46:24.425479
bed16258-095d-4b83-affd-d323148f80c7	19519809-b8c3-437b-a335-2f38de965358	video	This changed everything → Here's how it works...	1	2026-04-26 17:46:24.425479
ca669c2f-e9e4-451d-97d9-21f5dcf98d2d	a8dfe3af-2b5b-4c15-bb64-876cc6354fa2	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 17:46:24.425479
00f871d0-be59-4dc5-814d-63fadb836e85	fc361954-66cc-44f3-b5b5-1104d1823bba	video	Nobody talks about this → Here's how it works...	1	2026-04-26 17:46:24.425479
1089e080-9a3c-46bd-b980-fd933583bfd3	45a7790e-6071-4ccd-b74e-54498b7c38f3	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 17:46:24.425479
a8d9db5a-bba5-4738-b404-41a24facc171	86e3c22d-7655-481e-885e-190054604c6b	video	Stop wasting money on ads → Here's how it works...	1	2026-04-26 17:46:24.425479
b1010600-c1ff-41ab-8eec-595af9ae4cc3	badee154-dcef-4d11-9ca8-655ec6d0e15c	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 17:46:24.425479
4e28a16c-41b9-4733-b936-dd2bfb685d24	c3bb921d-659d-45f2-bc05-287af331fc06	video	Hidden secret revealed → Here's how it works...	1	2026-04-26 17:46:24.425479
\.


--
-- Data for Name: strategy_memory; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.strategy_memory (id, policy_id, strategy, success, latency, context, created_at) FROM stdin;
d1db8810-5b15-455d-bbc8-fcd4bf61ad54	4377fcc5-0da2-47d8-9f70-c4b26db7488d	balanced	t	1094	{"payload": {"input": "test"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-24 13:38:43.424263"}	2026-04-24 13:38:44.485424
43a23ce7-3955-4166-8b67-a03b2d8e7894	4377fcc5-0da2-47d8-9f70-c4b26db7488d	balanced	t	1056	{"payload": {"input": "test", "campaign_id": "test_1"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 08:01:45.939745"}	2026-04-25 08:01:46.568445
dc89d73d-a3b4-4eea-9298-1ef92a27b4ed	4377fcc5-0da2-47d8-9f70-c4b26db7488d	scale	t	1089	{"payload": {"campaign_id": "test_1"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 08:41:02.377271"}	2026-04-25 08:41:03.431245
1b652433-1df1-4bb4-beeb-07dbf97de068	4377fcc5-0da2-47d8-9f70-c4b26db7488d	scale	t	1089	{"payload": {"campaign_id": "test_1"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 08:48:34.727209"}	2026-04-25 08:48:35.88939
608b36be-27e6-4c96-8619-48ece7ca47f5	4377fcc5-0da2-47d8-9f70-c4b26db7488d	scale	t	1082	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 10:41:14.354428"}	2026-04-25 10:41:15.488781
3ffa2466-23d4-4d6d-98ad-758a110ff9d5	4377fcc5-0da2-47d8-9f70-c4b26db7488d	generate_creative	t	1281	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 10:46:23.956228"}	2026-04-25 10:46:25.343576
4488b74f-9d97-41e3-b7e9-f01bfe29723a	4377fcc5-0da2-47d8-9f70-c4b26db7488d	scale	t	1084	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 11:24:20.684837"}	2026-04-25 11:24:21.79221
fdf50cd3-1d0b-485a-8af9-446d809e8632	4377fcc5-0da2-47d8-9f70-c4b26db7488d	generate_creative	t	1198	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 11:28:54.606304"}	2026-04-25 11:28:55.848261
4b161d7f-455a-447b-b4f1-a99b8bf0f0f8	cf08168d-22ef-465b-883f-f2392036b1a7	scale	t	1088	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 11:40:23.655673"}	2026-04-25 11:40:24.925558
95b7cf5b-3d36-4b3a-a2dc-66999781d86d	9f1e02e2-eba0-4ac9-965c-8d6170267fab	scale	t	1086	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 11:41:27.435057"}	2026-04-25 11:41:28.479255
ed6bf48f-00e7-4f3d-b4ca-fc95bfd5c1b8	19c2264c-5bd3-4f27-b66b-855f40a81830	scale	t	1095	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 11:48:43.295568"}	2026-04-25 11:48:44.46365
4c7301a2-1339-4527-973d-3e9cfeddab4f	a2c53d62-d5e3-4597-b2b4-9487cb801909	scale	t	1097	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 11:48:43.365776"}	2026-04-25 11:48:48.231371
aaa5e4a9-6dc1-4156-85e1-64eb921ed29c	129a8c8d-54b1-43f9-a7c2-75993315998a	scale	t	1091	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 11:48:43.421483"}	2026-04-25 11:48:50.350989
a3e7c544-6ade-4ccd-8dfa-ea4969f65179	129a8c8d-54b1-43f9-a7c2-75993315998a	scale	t	1082	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 11:48:43.478076"}	2026-04-25 11:48:52.422033
bc81c1f4-8566-4687-b14e-5895aa8ecc45	129a8c8d-54b1-43f9-a7c2-75993315998a	scale	t	1082	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 11:48:43.535922"}	2026-04-25 11:48:54.759943
09118849-7010-4094-a1ae-1f2223fb690b	129a8c8d-54b1-43f9-a7c2-75993315998a	scale	t	1060	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 12:01:27.471978"}	2026-04-25 12:01:28.216928
a1611970-4014-48d7-9d87-72d977d21d18	129a8c8d-54b1-43f9-a7c2-75993315998a	scale	t	1061	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 12:01:27.516129"}	2026-04-25 12:01:29.829246
60b85370-022e-45df-a3aa-079bc0845ed1	129a8c8d-54b1-43f9-a7c2-75993315998a	scale	t	1058	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 12:01:27.545245"}	2026-04-25 12:01:31.419973
c9c384c0-bfba-432c-890e-360feff969b7	129a8c8d-54b1-43f9-a7c2-75993315998a	scale	t	1062	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 12:01:27.576655"}	2026-04-25 12:01:33.030858
b0cede09-8870-43b6-9a05-6bbfd35cdf18	129a8c8d-54b1-43f9-a7c2-75993315998a	scale	t	1059	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 12:01:27.608099"}	2026-04-25 12:01:34.639045
7adb2389-8659-4aec-b0e7-825b730f9abf	129a8c8d-54b1-43f9-a7c2-75993315998a	balanced	t	1062	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 12:23:50.822317"}	2026-04-25 12:23:51.515613
1edf7a4e-5f1a-4e9b-98f6-fa81488cd986	129a8c8d-54b1-43f9-a7c2-75993315998a	scale	t	1059	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 12:29:44.508040"}	2026-04-25 12:29:45.152246
0ea8174e-0766-4793-8adb-bae68b8090e3	129a8c8d-54b1-43f9-a7c2-75993315998a	scale	t	1087	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 18:42:56.874201"}	2026-04-25 18:42:58.128682
08544733-67a6-4d67-b8b8-7b2aaa540b30	129a8c8d-54b1-43f9-a7c2-75993315998a	scale	f	107	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 19:18:22.998632"}	2026-04-25 19:18:24.50428
6c8e4876-8cfa-48ba-8791-812dd7f8930f	129a8c8d-54b1-43f9-a7c2-75993315998a	scale	f	196	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 19:24:18.733057"}	2026-04-25 19:24:20.399949
2564ed0a-a047-4d2d-aa20-f68fb3224d98	129a8c8d-54b1-43f9-a7c2-75993315998a	scale	f	95	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 19:30:24.016124"}	2026-04-25 19:30:25.252304
bbb71af9-996f-4acb-be14-c6468e892812	129a8c8d-54b1-43f9-a7c2-75993315998a	scale	f	83	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 19:33:41.452690"}	2026-04-25 19:33:42.430699
92444fb7-493a-4bd0-9767-9e37da740a5b	133de373-d757-4e31-8932-1de0179ea366	scale	f	84	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 19:34:24.356994"}	2026-04-25 19:34:25.268676
d6c1f8b3-51f3-4f81-9035-b10bb6b5d6ae	3c6b827e-3b36-48b6-9ae2-0f54544e326e	generate_creative	t	1186	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 20:11:24.951112"}	2026-04-25 20:11:26.340137
bed76baf-beb0-4a53-b86e-df52d22b2b7b	3c6b827e-3b36-48b6-9ae2-0f54544e326e	generate_creative	t	1528	{"payload": {"product_id": "test_product", "ad_account_id": "1234567890", "enable_meta_sync": true}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 21:49:25.957151"}	2026-04-25 21:49:27.183526
2397ea89-c4d1-4db1-8c0f-f425178bd109	3c6b827e-3b36-48b6-9ae2-0f54544e326e	generate_creative	t	1514	{"payload": {"product_id": "test_product", "auto_deploy": true, "ad_account_id": "1234567890", "enable_meta_sync": true}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-25 22:16:42.116628"}	2026-04-25 22:16:43.279365
c3411612-c9ba-4a34-a356-b3fc5491dfe5	3c6b827e-3b36-48b6-9ae2-0f54544e326e	generate_creative	t	1956	{"payload": {"product_id": "test_product", "auto_deploy": true, "ad_account_id": "1234567890", "enable_meta_sync": true}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 07:32:31.459022"}	2026-04-26 07:32:33.655059
cb0a1feb-6f8e-4d9a-87e4-0dadb03a2059	3c6b827e-3b36-48b6-9ae2-0f54544e326e	generate_creative	t	1174	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 11:04:17.672310"}	2026-04-26 11:04:18.869611
e584dab4-9583-485c-b716-349386fc4d84	3c6b827e-3b36-48b6-9ae2-0f54544e326e	generate_creative	t	1151	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 11:04:17.741110"}	2026-04-26 11:04:21.648343
128a95be-3ef9-4b55-8be2-5a91dbea24ab	3c6b827e-3b36-48b6-9ae2-0f54544e326e	generate_creative	t	1185	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 11:04:17.790498"}	2026-04-26 11:04:24.325182
aec5181f-f4c2-42c2-b841-1e51dfb8e0a9	3c6b827e-3b36-48b6-9ae2-0f54544e326e	generate_creative	t	1154	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 11:04:17.842406"}	2026-04-26 11:04:27.048802
93b8c48a-625f-4f78-9240-da0498135967	3c6b827e-3b36-48b6-9ae2-0f54544e326e	generate_creative	t	1160	{"payload": {"product_id": "test_product"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 11:04:17.888534"}	2026-04-26 11:04:29.888178
b8701458-0418-4c27-a1bc-6e41cb87eb40	3c6b827e-3b36-48b6-9ae2-0f54544e326e	generate_creative	t	1134	{"payload": {"mode": "explore"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 12:07:39.976352"}	2026-04-26 12:07:41.109918
7ae2aece-e163-4c14-b6b8-a60ab55cf3a3	3c6b827e-3b36-48b6-9ae2-0f54544e326e	generate_creative	t	1133	{"payload": {"mode": "explore"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 12:07:43.898467"}	2026-04-26 12:07:44.918119
18ce18a0-8a30-4895-a940-fe388fd36700	ce6ca3dd-00b4-4376-b91a-891ea3ec5e18	generate_creative	t	1125	{"payload": {"mode": "explore"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 12:07:45.333863"}	2026-04-26 12:07:47.380961
9337ac30-dcce-407c-8664-26863f3f3a97	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	generate_creative	t	1080	{"payload": {"mode": "explore"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 13:06:36.246658"}	2026-04-26 13:06:37.021718
9afecba2-e391-4880-87f7-1a6b37e518a7	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	generate_creative	t	1064	{"payload": {"mode": "explore"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 13:06:41.988311"}	2026-04-26 13:06:42.507482
aaaf9a14-eaaf-48da-93a0-8aef3fa1c536	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	generate_creative	t	1068	{"payload": {"mode": "explore"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 13:06:43.584570"}	2026-04-26 13:06:44.307844
3ce11dc9-61b1-463d-b4cd-37b75ccc476e	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	generate_creative	t	1068	{"payload": {"mode": "explore"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 13:17:49.204446"}	2026-04-26 13:17:49.836769
6cbb4fb4-de9a-4309-91d2-44bd5f584ee8	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	generate_creative	t	1067	{"payload": {"mode": "explore"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 13:17:50.298736"}	2026-04-26 13:17:51.633996
bcb5d877-33ab-4fbc-b59f-ccd157ddf9c3	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	generate_creative	t	1068	{"payload": {"mode": "explore"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 13:17:51.436358"}	2026-04-26 13:17:53.455569
6a3fcac7-531e-4fad-8b52-d117089c3b19	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	generate_creative	t	1068	{"payload": {"mode": "explore"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 13:17:52.506337"}	2026-04-26 13:17:55.257665
11cda43e-6dd1-49ea-883d-23231435d47e	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	generate_creative	t	1074	{"payload": {"mode": "explore"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 13:17:53.307180"}	2026-04-26 13:17:57.089481
1a6bdf0d-7bc8-4bee-8a43-4bdf2fbcef84	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	generate_creative	t	1141	{"payload": {"mode": "explore"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 17:46:15.921501"}	2026-04-26 17:46:17.241589
a7c8e829-a460-4313-ba2e-215d41749faf	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	generate_creative	t	1093	{"payload": {"mode": "explore"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 17:46:17.090654"}	2026-04-26 17:46:19.974033
b0f73524-9551-4418-8e11-f62f2670d924	1a763aee-ebc0-4c11-9e5d-bbe2acdf1103	generate_creative	t	1106	{"payload": {"mode": "explore"}, "job_type": "ai", "tenant_id": "tenant_1", "timestamp": "2026-04-26 17:46:19.216090"}	2026-04-26 17:46:22.692865
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.subscriptions (id, tenant_id, plan_id, status, start_date) FROM stdin;
sub_068ddcb6	tenant_0e46a852	free	active	2026-04-20 18:39:55.091859
18271253-c0a3-4b8b-a22a-8a520cd3a918	tenant_1	free	active	2026-04-24 11:16:22.347043
\.


--
-- Data for Name: system_goals; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.system_goals (id, name, priority, target_metric, is_active) FROM stdin;
fe5af36c-fdb3-40cf-8d95-b950dadb04b4	Optimize Latency	10	latency	t
90b6baf6-30d6-49a8-8620-e823a86180b0	Maximize Success Rate	9	success	t
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.tenants (id, name, created_at) FROM stdin;
tenant_a0ff45bf	test_company	2026-04-20 17:49:15.415444
tenant_0e46a852	test_company	2026-04-20 18:37:24.938483
tenant_adb21fa8	test	2026-04-21 20:09:15.273693
tenant_1	Test Tenant	2026-04-24 11:16:04.648144
\.


--
-- Data for Name: usage_logs; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.usage_logs (id, tenant_id, endpoint, created_at) FROM stdin;
use_7d5fa203	tenant_0e46a852	/billing/invoice	2026-04-21 21:13:12.843704
use_c95e516f	tenant_0e46a852	/billing/invoice	2026-04-21 21:17:51.090188
use_fc0b4d4e	tenant_0e46a852	/billing/invoice	2026-04-21 21:17:54.059126
use_4fd804b5	tenant_0e46a852	/billing/invoice	2026-04-21 21:34:11.377461
use_e86886fd	tenant_0e46a852	/billing/invoice	2026-04-21 21:34:15.548063
use_c62976bf	tenant_a0ff45bf	/billing/invoice	2026-04-22 00:41:26.442514
use_16fed7ce	tenant_a0ff45bf	/billing/invoice	2026-04-22 00:41:41.17969
use_0408bb15	tenant_a0ff45bf	/billing/invoice	2026-04-22 00:46:19.854271
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.users (id, email, password, role, tenant_id, created_at) FROM stdin;
user_4dd0dd51	test@test.com	$2b$12$thYWtDosJHjNodfY1doG/OHwGfHK4ZjjWxGBYUNdBjJZZTuJhFfR6	admin	tenant_a0ff45bf	2026-04-20 17:51:33.096585
\.


--
-- Name: creative_ad_map_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.creative_ad_map_id_seq', 2, true);


--
-- Name: creative_metrics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.creative_metrics_id_seq', 3605, true);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (key);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: campaign_metrics campaign_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.campaign_metrics
    ADD CONSTRAINT campaign_metrics_pkey PRIMARY KEY (id);


--
-- Name: creative_ad_map creative_ad_map_ad_id_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.creative_ad_map
    ADD CONSTRAINT creative_ad_map_ad_id_key UNIQUE (ad_id);


--
-- Name: creative_ad_map creative_ad_map_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.creative_ad_map
    ADD CONSTRAINT creative_ad_map_pkey PRIMARY KEY (id);


--
-- Name: creative_metrics creative_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.creative_metrics
    ADD CONSTRAINT creative_metrics_pkey PRIMARY KEY (id);


--
-- Name: creatives creatives_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.creatives
    ADD CONSTRAINT creatives_pkey PRIMARY KEY (id);


--
-- Name: experiments experiments_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.experiments
    ADD CONSTRAINT experiments_pkey PRIMARY KEY (id);


--
-- Name: feedback_log feedback_log_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.feedback_log
    ADD CONSTRAINT feedback_log_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: learning_insights learning_insights_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.learning_insights
    ADD CONSTRAINT learning_insights_pkey PRIMARY KEY (id);


--
-- Name: learning_memory learning_memory_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.learning_memory
    ADD CONSTRAINT learning_memory_pkey PRIMARY KEY (id);


--
-- Name: outcomes_log outcomes_log_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.outcomes_log
    ADD CONSTRAINT outcomes_log_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


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
-- Name: scripts scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.scripts
    ADD CONSTRAINT scripts_pkey PRIMARY KEY (id);


--
-- Name: strategy_memory strategy_memory_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.strategy_memory
    ADD CONSTRAINT strategy_memory_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: system_goals system_goals_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.system_goals
    ADD CONSTRAINT system_goals_pkey PRIMARY KEY (id);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: usage_logs usage_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.usage_logs
    ADD CONSTRAINT usage_logs_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: api_keys api_keys_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: invoices invoices_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: payments payments_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON DELETE CASCADE;


--
-- Name: subscriptions subscriptions_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.plans(id);


--
-- Name: subscriptions subscriptions_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: users users_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict FHunRdAPRC5svBFy3HB0W8wqfhRrFTivdqpbSgyUpvCX6cTNiuNjUgvaWwfIj98

