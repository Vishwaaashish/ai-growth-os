--
-- PostgreSQL database dump
--

\restrict jSuWi3tA6wiUB28XbOeOX1KZuKCQYMbX2YZrQYl6uxIwtZynv9kId0y51NIneiA

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
-- Name: commands; Type: TABLE; Schema: public; Owner: odoo
--

CREATE TABLE public.commands (
    id integer NOT NULL,
    user_id character varying(100),
    input_text text NOT NULL,
    output_text text,
    status character varying(50),
    created_at timestamp without time zone
);


ALTER TABLE public.commands OWNER TO odoo;

--
-- Name: commands_id_seq; Type: SEQUENCE; Schema: public; Owner: odoo
--

CREATE SEQUENCE public.commands_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.commands_id_seq OWNER TO odoo;

--
-- Name: commands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: odoo
--

ALTER SEQUENCE public.commands_id_seq OWNED BY public.commands.id;


--
-- Name: commands id; Type: DEFAULT; Schema: public; Owner: odoo
--

ALTER TABLE ONLY public.commands ALTER COLUMN id SET DEFAULT nextval('public.commands_id_seq'::regclass);


--
-- Data for Name: commands; Type: TABLE DATA; Schema: public; Owner: odoo
--

COPY public.commands (id, user_id, input_text, output_text, status, created_at) FROM stdin;
1	aashish	store-this	Processed command: store-this	completed	2026-03-17 22:52:32.603363
\.


--
-- Name: commands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: odoo
--

SELECT pg_catalog.setval('public.commands_id_seq', 1, true);


--
-- Name: commands commands_pkey; Type: CONSTRAINT; Schema: public; Owner: odoo
--

ALTER TABLE ONLY public.commands
    ADD CONSTRAINT commands_pkey PRIMARY KEY (id);


--
-- Name: ix_commands_id; Type: INDEX; Schema: public; Owner: odoo
--

CREATE INDEX ix_commands_id ON public.commands USING btree (id);


--
-- PostgreSQL database dump complete
--

\unrestrict jSuWi3tA6wiUB28XbOeOX1KZuKCQYMbX2YZrQYl6uxIwtZynv9kId0y51NIneiA

