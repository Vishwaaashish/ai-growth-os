--
-- PostgreSQL database cluster dump
--

\restrict pEQXjOx41sqCjRMYTYjGkPi9O6cQReuuL6G0rkDSRCwhhA5hZGNLJeePxJad8MM

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE odoo;
ALTER ROLE odoo WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:LhhFlIXvKI7foKwzJkPVWg==$fEyWKN6th8g1gaQ7hbb3oRR6rGBn2rU/jJLQdzL2/YA=:AxLic1y+rYREaFKJgR8ZfwJBcqOkZB5PhFq3V1nrtr8=';

--
-- User Configurations
--








\unrestrict pEQXjOx41sqCjRMYTYjGkPi9O6cQReuuL6G0rkDSRCwhhA5hZGNLJeePxJad8MM

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict bNgEnugs1Oo9CCc2ruoLSwTn2Agt5xuFiQppA17uEbLwf6uaPDZpzduENgCHgs5

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
-- PostgreSQL database dump complete
--

\unrestrict bNgEnugs1Oo9CCc2ruoLSwTn2Agt5xuFiQppA17uEbLwf6uaPDZpzduENgCHgs5

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict aWd8mkQQsvibbVdDL0zF8VXggdIbmaADRhYd4uwCUEGc81zYI3ayFxYcyVdgXAv

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
-- PostgreSQL database dump complete
--

\unrestrict aWd8mkQQsvibbVdDL0zF8VXggdIbmaADRhYd4uwCUEGc81zYI3ayFxYcyVdgXAv

--
-- PostgreSQL database cluster dump complete
--

