--
-- PostgreSQL database dump
--

-- Dumped from database version 13.10 (Debian 13.10-1.pgdg110+1)
-- Dumped by pg_dump version 13.10 (Debian 13.10-1.pgdg110+1)

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
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

-- CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

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
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: postgres; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE postgres SET search_path TO '$user', 'public', 'topology', 'tiger';


\connect postgres

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
-- Name: pgagent; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgagent;


ALTER SCHEMA pgagent OWNER TO postgres;

--
-- Name: SCHEMA pgagent; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';


--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

-- CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

-- CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

-- CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- Name: gender; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender AS ENUM (
    'M',
    'F'
);


ALTER TYPE public.gender OWNER TO postgres;

--
-- Name: source; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.source AS ENUM (
    'website',
    'facebook',
    'instagram',
    'tripadvisor',
    'flickr',
    'twitter',
    'wikipedia'
);


ALTER TYPE public.source OWNER TO postgres;

--
-- Name: weekday; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.weekday AS ENUM (
    'mon',
    'tue',
    'wed',
    'thu',
    'fri',
    'sat',
    'sun'
);


ALTER TYPE public.weekday OWNER TO postgres;

--
-- Name: location_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.location_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    new.location :=
        ST_SetSRID(ST_MakePoint(new.lat, new.lon), 4326);
    return new;
end;
$$;


ALTER FUNCTION public.location_trigger() OWNER TO postgres;

--
-- Name: poi_tsvector_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.poi_tsvector_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    new.document_with_weights :=
        setweight(to_tsvector('italian', coalesce(new.name, '')), 'B') ||
        setweight(to_tsvector('italian', coalesce(new.description, '')), 'A');
    return new;
end
$$;


ALTER FUNCTION public.poi_tsvector_trigger() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: city; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.city (
    city_id integer NOT NULL,
    province_id integer NOT NULL,
    name character varying(256),
    lat numeric(9,7),
    lon numeric(9,7),
    is_active boolean DEFAULT true
);


ALTER TABLE public.city OWNER TO postgres;

--
-- Name: cities_city_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.city ALTER COLUMN city_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.cities_city_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: day_and_hour; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.day_and_hour (
    dah_id integer NOT NULL,
    poh_id integer NOT NULL,
    weekday public.weekday NOT NULL,
    opening_hour time without time zone NOT NULL,
    closing_hour time without time zone NOT NULL,
    is_active boolean DEFAULT true
);


ALTER TABLE public.day_and_hour OWNER TO postgres;

--
-- Name: day_and_hours_dan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.day_and_hour ALTER COLUMN dah_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.day_and_hours_dan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image (
    image_id integer NOT NULL,
    poi_id integer NOT NULL,
    url character varying(1024),
    is_active boolean DEFAULT true
);


ALTER TABLE public.image OWNER TO postgres;

--
-- Name: images_image_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.image ALTER COLUMN image_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.images_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: place; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.place (
    place_id character varying(1024) NOT NULL,
    json character varying(8192),
    last_modification timestamp without time zone
);


ALTER TABLE public.place OWNER TO postgres;

--
-- Name: poi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poi (
    poi_id integer NOT NULL,
    city_id integer NOT NULL,
    name character varying(256) NOT NULL,
    lat numeric(9,7) NOT NULL,
    lon numeric(9,7) NOT NULL,
    address character varying(256),
    type character varying(128) NOT NULL,
    phone character varying(64),
    email character varying(128),
    average_visiting_time integer,
    is_active boolean DEFAULT true,
    poh_id integer,
    utility_score integer DEFAULT (random() * (100)::double precision),
    description character varying(4096),
    document_with_idx tsvector,
    document_with_weights tsvector,
    location public.geometry(Point,4326)
);


ALTER TABLE public.poi OWNER TO postgres;

--
-- Name: poi_opening_hour; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poi_opening_hour (
    poh_id integer NOT NULL,
    is_active boolean DEFAULT true
);


ALTER TABLE public.poi_opening_hour OWNER TO postgres;

--
-- Name: poi_opening_hour_poh_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.poi_opening_hour ALTER COLUMN poh_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.poi_opening_hour_poh_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: poi_poi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.poi ALTER COLUMN poi_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.poi_poi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: province; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.province (
    province_id integer NOT NULL,
    region_id integer NOT NULL,
    name character varying(256),
    lat numeric(9,7),
    lon numeric(9,7),
    is_active boolean DEFAULT true
);


ALTER TABLE public.province OWNER TO postgres;

--
-- Name: provinces_province_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.province ALTER COLUMN province_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.provinces_province_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region (
    region_id integer NOT NULL,
    name character varying(128),
    min_lat numeric(9,7),
    min_lon numeric(9,7),
    max_lat numeric(9,7),
    max_lon numeric(9,7),
    is_active boolean DEFAULT true
);


ALTER TABLE public.region OWNER TO postgres;

--
-- Name: regions_region_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.region ALTER COLUMN region_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.regions_region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: social_interaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.social_interaction (
    si_id integer NOT NULL,
    url character varying(1024) NOT NULL,
    source_type public.source NOT NULL,
    wos_id integer,
    poi_id integer,
    is_active boolean DEFAULT true
);


ALTER TABLE public.social_interaction OWNER TO postgres;

--
-- Name: social_interactions_si_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.social_interaction ALTER COLUMN si_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.social_interactions_si_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: social_media; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.social_media (
    sm_id integer NOT NULL,
    url character varying(1024) NOT NULL,
    source_type public.source NOT NULL,
    city_id integer,
    poi_id integer,
    is_active boolean DEFAULT true
);


ALTER TABLE public.social_media OWNER TO postgres;

--
-- Name: tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tag (
    tag_id integer NOT NULL,
    tag character varying(128) NOT NULL,
    si_id integer,
    is_active boolean DEFAULT true
);


ALTER TABLE public.tag OWNER TO postgres;

--
-- Name: tags_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tag ALTER COLUMN tag_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tags_tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_account (
    user_id integer NOT NULL,
    email character varying(128) NOT NULL,
    password character varying(32) NOT NULL,
    age integer NOT NULL,
    gender public.gender,
    disability integer NOT NULL,
    is_active boolean DEFAULT true
);


ALTER TABLE public.user_account OWNER TO postgres;

--
-- Name: user_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_tag (
    ut_id integer NOT NULL,
    user_id integer NOT NULL,
    tag_id integer NOT NULL,
    is_active boolean DEFAULT true
);


ALTER TABLE public.user_tag OWNER TO postgres;

--
-- Name: user_tags_ut_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.user_tag ALTER COLUMN ut_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.user_tags_ut_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.user_account ALTER COLUMN user_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: webpage_or_social_wos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.social_media ALTER COLUMN sm_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.webpage_or_social_wos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add city	7	add_city
26	Can change city	7	change_city
27	Can delete city	7	delete_city
28	Can view city	7	view_city
29	Can add day and hour	8	add_dayandhour
30	Can change day and hour	8	change_dayandhour
31	Can delete day and hour	8	delete_dayandhour
32	Can view day and hour	8	view_dayandhour
33	Can add image	9	add_image
34	Can change image	9	change_image
35	Can delete image	9	delete_image
36	Can view image	9	view_image
37	Can add poi	10	add_poi
38	Can change poi	10	change_poi
39	Can delete poi	10	delete_poi
40	Can view poi	10	view_poi
41	Can add province	11	add_province
42	Can change province	11	change_province
43	Can delete province	11	delete_province
44	Can view province	11	view_province
45	Can add region	12	add_region
46	Can change region	12	change_region
47	Can delete region	12	delete_region
48	Can view region	12	view_region
49	Can add social interaction	13	add_socialinteraction
50	Can change social interaction	13	change_socialinteraction
51	Can delete social interaction	13	delete_socialinteraction
52	Can view social interaction	13	view_socialinteraction
53	Can add social media	14	add_socialmedia
54	Can change social media	14	change_socialmedia
55	Can delete social media	14	delete_socialmedia
56	Can view social media	14	view_socialmedia
57	Can add tag	15	add_tag
58	Can change tag	15	change_tag
59	Can delete tag	15	delete_tag
60	Can view tag	15	view_tag
61	Can add user tag	16	add_usertag
62	Can change user tag	16	change_usertag
63	Can delete user tag	16	delete_usertag
64	Can view user tag	16	view_usertag
65	Can add user	17	add_user
66	Can change user	17	change_user
67	Can delete user	17	delete_user
68	Can view user	17	view_user
69	Can add itinerary	18	add_itinerary
70	Can change itinerary	18	change_itinerary
71	Can delete itinerary	18	delete_itinerary
72	Can view itinerary	18	view_itinerary
73	Can add daily schedule	19	add_dailyschedule
74	Can change daily schedule	19	change_dailyschedule
75	Can delete daily schedule	19	delete_dailyschedule
76	Can view daily schedule	19	view_dailyschedule
77	Can add poi opening hour	20	add_poiopeninghour
78	Can change poi opening hour	20	change_poiopeninghour
79	Can delete poi opening hour	20	delete_poiopeninghour
80	Can view poi opening hour	20	view_poiopeninghour
81	Can add place	21	add_place
82	Can change place	21	change_place
83	Can delete place	21	delete_place
84	Can view place	21	view_place
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: city; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.city (city_id, province_id, name, lat, lon, is_active) FROM stdin;
1	1	Acquapendente	42.7439961	11.8649880	t
2	1	Bagnoregio	42.6269800	12.0908718	t
3	1	Barbarano Romano	42.2498341	12.0673735	t
4	1	Bassano Romano	42.2183916	12.1930062	t
5	1	Bassano in Teverina	42.4660738	12.3130342	t
6	1	Blera	42.2725220	12.0316620	t
7	1	Bolsena	42.6441069	11.9849554	t
8	1	Bomarzo	42.4819280	12.2487640	t
9	1	Calcata	42.2197263	12.4259417	t
10	1	Canepina	42.3809608	12.2336522	t
11	1	Canino	42.4639626	11.7495088	t
12	1	Capodimonte	42.5465270	11.9047550	t
13	1	Capranica	42.2564918	12.1776114	t
14	1	Caprarola	42.3266250	12.2357660	t
15	1	Carbognano	42.3316250	12.2643660	t
16	1	Castel Sant'Elia	42.2517755	12.3717955	t
17	1	Castiglione in Teverina	42.6449715	12.2038975	t
18	1	Celleno	42.5597682	12.1257580	t
19	1	Cellere	42.5104250	11.7716530	t
20	1	Civita Castellana	42.2952260	12.4091700	t
21	1	Civitella d'Agliano	42.6053622	12.1876584	t
22	1	Corchiano	42.3449260	12.3556680	t
23	1	Fabrica di Roma	42.3351260	12.2997670	t
24	1	Fabrica di Roma 	42.3351260	12.2997670	t
25	1	Faleria	42.2261788	12.4431811	t
26	1	Farnese	42.5494260	11.7256520	t
27	1	Gallese	42.3732869	12.4028042	t
28	1	Gradoli	42.6436919	11.8548880	t
29	1	Graffignano	42.5749030	12.2044306	t
30	1	Grotte di Castro	42.6745290	11.8722530	t
31	1	Ischia di Castro	42.5446546	11.7540140	t
32	1	Latera	42.6290280	11.8274530	t
33	1	Lubriano	42.6362310	12.1087590	t
34	1	Marta	42.5339112	11.9249120	t
35	1	Montalto di Castro	42.3534605	11.6063117	t
36	1	Monte Romano	42.2678823	11.8986478	t
37	1	Montefiascone	42.5379248	12.0309974	t
38	1	Monterosi	42.1958230	12.3084690	t
39	1	Nepi	42.2428240	12.3455700	t
40	1	Onano	42.6928561	11.8163999	t
41	1	Oriolo Romano	42.1593028	12.1383489	t
42	1	Orte	42.4605984	12.3856056	t
43	1	Piansano	42.5179320	11.8282734	t
44	1	Proceno	42.7571602	11.8302614	t
45	1	Ronciglione	42.2902415	12.2138064	t
46	1	San Lorenzo Nuovo	42.6867300	11.9066530	t
47	1	San Martino al Cimino	42.3679225	12.1275715	t
48	1	Soriano nel Cimino	42.4187606	12.2343075	t
49	1	Sutri	42.2470230	12.2150670	t
50	1	Tarquinia	42.2532394	11.7591747	t
51	1	Tuscania	42.4202141	11.8702611	t
52	1	Valentano	42.5684597	11.8187556	t
53	1	Vallerano	41.7907359	12.4696439	t
54	1	Vasanello	42.4144251	12.3464168	t
55	1	Vejano	42.2167570	12.0952017	t
56	1	Vetralla	42.3205336	12.0575000	t
57	1	Vignanello	42.3838260	12.2767660	t
58	1	Viterbo	42.4168441	12.1051148	t
59	1	Vitorchiano	42.4654270	12.1724620	t
\.


--
-- Data for Name: day_and_hour; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.day_and_hour (dah_id, poh_id, weekday, opening_hour, closing_hour, is_active) FROM stdin;
1	1	mon	08:00:00	20:00:00	t
2	1	tue	08:00:00	20:00:00	t
3	1	wed	08:00:00	20:00:00	t
4	1	thu	08:00:00	20:00:00	t
5	1	fri	08:00:00	20:00:00	t
6	1	sat	08:00:00	20:00:00	t
7	1	sun	08:00:00	20:00:00	t
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	api	city
8	api	dayandhour
9	api	image
10	api	poi
11	api	province
12	api	region
13	api	socialinteraction
14	api	socialmedia
15	api	tag
16	api	usertag
17	api	user
18	api	itinerary
19	api	dailyschedule
20	api	poiopeninghour
21	api	place
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2023-02-24 10:59:57.578137+00
2	auth	0001_initial	2023-02-24 10:59:57.612977+00
3	admin	0001_initial	2023-02-24 10:59:57.620108+00
4	admin	0002_logentry_remove_auto_add	2023-02-24 10:59:57.623595+00
5	admin	0003_logentry_add_action_flag_choices	2023-02-24 10:59:57.626401+00
6	api	0001_initial	2023-02-24 10:59:57.630523+00
7	api	0002_usertag	2023-02-24 10:59:57.63168+00
8	api	0003_user_delete_useraccount	2023-02-24 10:59:57.63306+00
9	contenttypes	0002_remove_content_type_name	2023-02-24 10:59:57.64104+00
10	auth	0002_alter_permission_name_max_length	2023-02-24 10:59:57.644501+00
11	auth	0003_alter_user_email_max_length	2023-02-24 10:59:57.64787+00
12	auth	0004_alter_user_username_opts	2023-02-24 10:59:57.651178+00
13	auth	0005_alter_user_last_login_null	2023-02-24 10:59:57.655439+00
14	auth	0006_require_contenttypes_0002	2023-02-24 10:59:57.657203+00
15	auth	0007_alter_validators_add_error_messages	2023-02-24 10:59:57.660365+00
16	auth	0008_alter_user_username_max_length	2023-02-24 10:59:57.6675+00
17	auth	0009_alter_user_last_name_max_length	2023-02-24 10:59:57.67156+00
18	auth	0010_alter_group_name_max_length	2023-02-24 10:59:57.676206+00
19	auth	0011_update_proxy_permissions	2023-02-24 10:59:57.680886+00
20	auth	0012_alter_user_first_name_max_length	2023-02-24 10:59:57.68439+00
21	sessions	0001_initial	2023-02-24 10:59:57.691574+00
22	api	0004_itinerary_dailyschedule	2023-02-24 16:25:32.062515+00
23	api	0005_remove_itinerary_user_delete_dailyschedule_and_more	2023-02-26 16:16:31.374792+00
24	api	0006_poiopeninghour	2023-03-07 22:54:41.203824+00
25	api	0007_place	2023-03-23 14:45:30.124513+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.image (image_id, poi_id, url, is_active) FROM stdin;
\.


--
-- Data for Name: place; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.place (place_id, json, last_modification) FROM stdin;
5121e1c9416430284059082d7d6ec0364540f00102f9013c0ff6100000000092031a42657374205765737465726e20486f74656c205669746572626f	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'website': 'hotelviterbo.com', 'brand': 'Best Western', 'brand_details': {'wikidata': 'Q830334'}, 'name': 'Best Western Hotel Viterbo', 'contact': {'phone': '+39 0761 270100'}, 'accommodation': {'stars': 4}, 'building': {'height': 25}, 'categories': ['accommodation', 'accommodation.hotel', 'building', 'building.accommodation'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': 'Best Western Hotel Viterbo', 'brand': 'Best Western', 'phone': '+39 0761 270100', 'stars': 4, 'height': 25, 'osm_id': 284561212, 'tourism': 'hotel', 'website': 'hotelviterbo.com', 'building': 'yes', 'osm_type': 'w', 'addr:street': 'Via San Camillo de Lellis', 'brand:wikidata': 'Q830334', 'addr:housenumber': 6}}, 'housenumber': '6', 'street': 'Via San Camillo de Lellis', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'Best Western Hotel Viterbo, Via San Camillo de Lellis, 6, 01100 Viterbo VT, Italy', 'address_line1': 'Best Western Hotel Viterbo', 'address_line2': 'Via San Camillo de Lellis, 6, 01100 Viterbo VT, Italy', 'lat': 42.42774755, 'lon': 12.0945149, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '5121e1c9416430284059082d7d6ec0364540f00102f9013c0ff6100000000092031a42657374205765737465726e20486f74656c205669746572626f'}, 'geometry': {'type': 'Polygon', 'coordinates': [[[12.0943882, 42.427839801], [12.0944298, 42.427632201], [12.0944813, 42.427637801], [12.0946416, 42.427655301], [12.0946, 42.427862901], [12.0943882, 42.427839801]]]}}]}	2023-03-22 16:30:51.307568
5163686b9bfb392840591dcd670ab8344540f00102f901cda2e71800000000920311486f74656c204d696e692050616c616365	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'website': 'http://www.minipalacehotel.com/', 'name': 'Hotel Mini Palace', 'contact': {'phone': '+39 0761 309742', 'email': 'info@minipalacehotel.com'}, 'facilities': {'internet_access': True}, 'accommodation': {'stars': 4}, 'categories': ['accommodation', 'accommodation.hotel', 'building', 'building.accommodation', 'internet_access', 'internet_access.free'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': 'Hotel Mini Palace', 'email': 'info@minipalacehotel.com', 'phone': '+39 0761 309742', 'stars': 4, 'osm_id': 417833677, 'tourism': 'hotel', 'website': 'http://www.minipalacehotel.com/', 'building': 'yes', 'osm_type': 'w', 'addr:street': 'Via Santa Maria della Grotticella', 'internet_access': 'wlan', 'addr:housenumber': '2/B', 'internet_access:fee': 'no'}}, 'housenumber': '2/B', 'street': 'Via Santa Maria della Grotticella', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'Hotel Mini Palace, Via Santa Maria della Grotticella, 2/B, 01100 Viterbo VT, Italy', 'address_line1': 'Hotel Mini Palace', 'address_line2': 'Via Santa Maria della Grotticella, 2/B, 01100 Viterbo VT, Italy', 'lat': 42.4118808, 'lon': 12.113294464791533, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '5163686b9bfb392840591dcd670ab8344540f00102f901cda2e71800000000920311486f74656c204d696e692050616c616365'}, 'geometry': {'type': 'Polygon', 'coordinates': [[[12.1130927, 42.411708401], [12.1133465, 42.411698701], [12.1133814, 42.411728901], [12.1133871, 42.411912901], [12.1133659, 42.411958001], [12.1131853, 42.412089001], [12.113121, 42.412077601], [12.1131068, 42.412003001], [12.1131649, 42.411974801], [12.1131649, 42.411963801], [12.1131502, 42.411964001], [12.1131499, 42.411952001], [12.1131496, 42.411941501], [12.1131648, 42.411941301], [12.1131647, 42.411930101], [12.1132047, 42.411930001], [12.1132016, 42.411848701], [12.1131776, 42.411818801], [12.1131006, 42.411821701], [12.1130927, 42.411708401]]]}}]}	2023-03-22 16:30:52.128602
51458b7d13543628405965c41da4f1344540f00103f901966e0aad010000009203174f73706974616c652064656c2050656c6c656772696e6f	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'website': 'https://www.amicidellaviafrancigenaviterbo.com/', 'opening_hours': 'Mar-Sep 15:30-18:30', 'operator': 'Associazione Amici della Via Francigena Viterbo', 'name': 'Ospitale del Pellegrino', 'contact': {'phone': '+39 334 696 0175', 'email': 'ospitaledelpellegrino@gmail.com;mirvin@virgilio.it;amiciviafrancigenaviterbo@gmail.com'}, 'accommodation': {'beds': 12}, 'categories': ['accommodation', 'accommodation.hostel'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'beds': 12, 'name': 'Ospitale del Pellegrino', 'osm_id': 7198109334, 'tourism': 'hostel', 'operator': 'Associazione Amici della Via Francigena Viterbo', 'osm_type': 'n', 'addr:city': 'Viterbo', 'addr:street': 'Via San Pellegrino', 'addr:postcode': '01100', 'contact:email': 'ospitaledelpellegrino@gmail.com;mirvin@virgilio.it;amiciviafrancigenaviterbo@gmail.com', 'contact:phone': '+39 334 696 0175', 'opening_hours': 'Mar-Sep 15:30-18:30', 'contact:website': 'https://www.amicidellaviafrancigenaviterbo.com/', 'addr:housenumber': 49, 'contact:facebook': 'https://www.facebook.com/ospitaledelpellegrino/'}}, 'housenumber': '49', 'street': 'Via San Pellegrino', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'Ospitale del Pellegrino, Via San Pellegrino, 49, 01100 Viterbo VT, Italy', 'address_line1': 'Ospitale del Pellegrino', 'address_line2': 'Via San Pellegrino, 49, 01100 Viterbo VT, Italy', 'lat': 42.4136243, 'lon': 12.1061102, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '51458b7d13543628405965c41da4f1344540f00103f901966e0aad010000009203174f73706974616c652064656c2050656c6c656772696e6f'}, 'geometry': {'type': 'Point', 'coordinates': [12.1061102, 42.413624301]}}]}	2023-03-22 16:30:52.840291
51f98fbdb29e3b284059f3fe41b4ae354540f00101f90152b55e0000000000920320436f6e76656e746f204672617469204d696e6f72692043617070756363696e69	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'name': 'Convento Frati Minori Cappuccini', 'contact': {'phone': '+39 0761 321945;+39 347 5900953', 'email': 'edybertolo@libero.it'}, 'building': {'type': 'residential'}, 'categories': ['accommodation', 'accommodation.hostel', 'building', 'building.accommodation', 'building.residential'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': 'Convento Frati Minori Cappuccini', 'osm_id': -6206802, 'tourism': 'hostel', 'building': 'residential', 'osm_type': 'r', 'addr:city': 'Viterbo', 'addr:street': 'Via San Crispino', 'addr:country': 'IT', 'addr:postcode': '01100', 'contact:email': 'edybertolo@libero.it', 'contact:phone': '+39 0761 321945;+39 347 5900953', 'addr:housenumber': 6}}, 'housenumber': '6', 'street': 'Via San Crispino', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'Convento Frati Minori Cappuccini, Via San Crispino, 6, 01100 Viterbo VT, Italy', 'address_line1': 'Convento Frati Minori Cappuccini', 'address_line2': 'Via San Crispino, 6, 01100 Viterbo VT, Italy', 'lat': 42.41939685, 'lon': 12.116260990097231, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '51f98fbdb29e3b284059f3fe41b4ae354540f00101f90152b55e0000000000920320436f6e76656e746f204672617469204d696e6f72692043617070756363696e69'}, 'geometry': {'type': 'Polygon', 'coordinates': [[[12.1160628, 42.419471401], [12.1162479, 42.419178301], [12.1162911, 42.419109801], [12.1163051, 42.419115201], [12.1163621, 42.419139701], [12.1163973, 42.419189501], [12.1164611, 42.419213201], [12.1164791, 42.419176801], [12.1166691, 42.419240101], [12.116675, 42.419230601], [12.116802, 42.419278401], [12.1166977, 42.419454901], [12.116708, 42.419461801], [12.1166516, 42.419551701], [12.1166391, 42.419547201], [12.1165371, 42.419701501], [12.1164067, 42.419645701], [12.1164768, 42.419534701], [12.1162308, 42.419446401], [12.1161875, 42.419514201], [12.1160628, 42.419471401]], [[12.1162871, 42.419350701], [12.1165371, 42.419443001], [12.1166283, 42.419299501], [12.1163743, 42.419212901], [12.1162871, 42.419350701]]]}}]}	2023-03-22 16:30:54.112509
51eb11b4136f362840599db6d0ca07354540f00103f9011524bd70000000009203154c61204c6f63616e64612064656c2052696363696f	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'website': 'http://www.lalocandadelriccio.it/', 'name': 'La Locanda del Riccio', 'categories': ['accommodation', 'accommodation.guest_house'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': 'La Locanda del Riccio', 'osm_id': 1891443733, 'tourism': 'guest_house', 'website': 'http://www.lalocandadelriccio.it/', 'osm_type': 'n'}}, 'street': 'Via del Riccio', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'La Locanda del Riccio, Via del Riccio, 01100 Viterbo VT, Italy', 'address_line1': 'La Locanda del Riccio', 'address_line2': 'Via del Riccio, 01100 Viterbo VT, Italy', 'lat': 42.4143003, 'lon': 12.1063162, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '51eb11b4136f362840599db6d0ca07354540f00103f9011524bd70000000009203154c61204c6f63616e64612064656c2052696363696f'}, 'geometry': {'type': 'Point', 'coordinates': [12.1063162, 42.414300301]}}]}	2023-03-22 16:30:54.888216
51601dc70f95362840590a26e9853b354540f00103f901728cae9a00000000920309536166666920313033	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'name': 'Saffi 103', 'contact': {'phone': '+39 339 4926105'}, 'categories': ['accommodation', 'accommodation.guest_house'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': 'Saffi 103', 'phone': '+39 339 4926105', 'osm_id': 2595130482, 'tourism': 'guest_house', 'osm_type': 'n', 'addr:city': 'Viterbo', 'addr:street': 'Via Aurelio Saffi', 'addr:country': 'IT', 'addr:postcode': '01100', 'addr:housename': 'Saffi 103', 'addr:housenumber': 103}}, 'housenumber': '103', 'street': 'Via Aurelio Saffi', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'Saffi 103, Via Aurelio Saffi, 103, 01100 Viterbo VT, Italy', 'address_line1': 'Saffi 103', 'address_line2': 'Via Aurelio Saffi, 103, 01100 Viterbo VT, Italy', 'lat': 42.415879, 'lon': 12.106606, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '51601dc70f95362840590a26e9853b354540f00103f901728cae9a00000000920309536166666920313033'}, 'geometry': {'type': 'Point', 'coordinates': [12.106606, 42.415879001]}}]}	2023-03-22 16:30:55.393386
518f2b3fba22362840590b20507c10354540f00103f9012d7851cf0000000092030c416c2043617264696e616c65	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'website': 'http://www.alcardinale.it/', 'name': 'Al Cardinale', 'categories': ['accommodation', 'accommodation.guest_house'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': 'Al Cardinale', 'osm_id': 3478222893, 'tourism': 'guest_house', 'website': 'http://www.alcardinale.it/', 'osm_type': 'n', 'addr:city': 'Viterbo', 'addr:street': 'Via Ottusa', 'addr:postcode': '01100', 'addr:housenumber': 8}}, 'housenumber': '8', 'street': 'Via Ottusa', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'Al Cardinale, Via Ottusa, 8, 01100 Viterbo VT, Italy', 'address_line1': 'Al Cardinale', 'address_line2': 'Via Ottusa, 8, 01100 Viterbo VT, Italy', 'lat': 42.4145656, 'lon': 12.1057337, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '518f2b3fba22362840590b20507c10354540f00103f9012d7851cf0000000092030c416c2043617264696e616c65'}, 'geometry': {'type': 'Point', 'coordinates': [12.1057337, 42.414565601]}}]}	2023-03-22 16:30:56.113615
5145cfd2bab23428405936829f12c6344540f00103f901535f364901000000920310416c2043617264696e616c6520422642	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'website': 'http://www.alcardinale.it/', 'name': 'Al Cardinale B&B', 'contact': {'phone': '+39 0761 228196;', 'email': 'ilcardinalebb@yahoo.it'}, 'facilities': {'wheelchair': False}, 'accommodation': {'rooms': 3}, 'categories': ['accommodation', 'accommodation.guest_house'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': 'Al Cardinale B&B', 'rooms': 3, 'osm_id': 5523267411, 'tourism': 'guest_house', 'osm_type': 'n', 'addr:city': 'Viterbo', 'wheelchair': 'no', 'addr:street': 'Via San Carlo', 'addr:postcode': '01100', 'contact:email': 'ilcardinalebb@yahoo.it', 'contact:phone': '+39 0761 228196;', 'contact:website': 'http://www.alcardinale.it/', 'addr:housenumber': 6, 'contact:facebook': 'https://www.facebook.com/Al-Cardinale-Bed-and-Breakfast-137098203537/'}}, 'housenumber': '6', 'street': 'Via San Carlo', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'Al Cardinale B&B, Via San Carlo, 6, 01100 Viterbo VT, Italy', 'address_line1': 'Al Cardinale B&B', 'address_line2': 'Via San Carlo, 6, 01100 Viterbo VT, Italy', 'lat': 42.4122947, 'lon': 12.1029261, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '5145cfd2bab23428405936829f12c6344540f00103f901535f364901000000920310416c2043617264696e616c6520422642'}, 'geometry': {'type': 'Point', 'coordinates': [12.1029261, 42.412294701]}}]}	2023-03-22 16:30:56.367675
515e903ef72f3a28405988034bf48d354540f00103f901986e0aad01000000920319436173612070657220666572696520496c2056696c6c696e6f	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'website': 'http://ilvillinodiviterbo.it/', 'name': 'Casa per ferie Il Villino', 'contact': {'phone': '+39 0761 341900; +39 388 7307841'}, 'accommodation': {'beds': 26}, 'categories': ['accommodation', 'accommodation.hostel'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'beds': 26, 'name': 'Casa per ferie Il Villino', 'osm_id': 7198109336, 'tourism': 'hostel', 'osm_type': 'n', 'contact:phone': '+39 0761 341900; +39 388 7307841', 'contact:website': 'http://ilvillinodiviterbo.it/'}}, 'street': 'Viale IV novembre', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'Casa per ferie Il Villino, Viale IV novembre, 01100 Viterbo VT, Italy', 'address_line1': 'Casa per ferie Il Villino', 'address_line2': 'Viale IV novembre, 01100 Viterbo VT, Italy', 'lat': 42.4183946, 'lon': 12.1136472, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '515e903ef72f3a28405988034bf48d354540f00103f901986e0aad01000000920319436173612070657220666572696520496c2056696c6c696e6f'}, 'geometry': {'type': 'Point', 'coordinates': [12.1136472, 42.418394601]}}]}	2023-03-22 16:30:57.126074
516ed3e98a6336284059628ec400d3344540f00103f901f1c10cad010000009203214361736120706572206665726965205265736964656e7a61204e617a6172657468	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'website': 'http://www.nazarethresidence.com/', 'operator': 'Enova Sociale Società Cooperativa Sociale ONLUS', 'name': 'Casa per ferie Residenza Nazareth', 'contact': {'phone': '+39 0761 1564612', 'fax': '+39 0761 332077'}, 'accommodation': {'beds': 67}, 'categories': ['accommodation', 'accommodation.hotel'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'beds': 67, 'name': 'Casa per ferie Residenza Nazareth', 'osm_id': 7198261745, 'tourism': 'hotel', 'operator': 'Enova Sociale Società Cooperativa Sociale ONLUS', 'osm_type': 'n', 'addr:city': 'Viterbo', 'addr:street': 'Via San Tommaso', 'contact:fax': '+39 0761 332077', 'addr:postcode': '01100', 'contact:phone': '+39 0761 1564612', 'contact:website': 'http://www.nazarethresidence.com/', 'addr:housenumber': 30}}, 'housenumber': '30', 'street': 'Via San Tommaso', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'Casa per ferie Residenza Nazareth, Via San Tommaso, 30, 01100 Viterbo VT, Italy', 'address_line1': 'Casa per ferie Residenza Nazareth', 'address_line2': 'Via San Tommaso, 30, 01100 Viterbo VT, Italy', 'lat': 42.4126893, 'lon': 12.1062282, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '516ed3e98a6336284059628ec400d3344540f00103f901f1c10cad010000009203214361736120706572206665726965205265736964656e7a61204e617a6172657468'}, 'geometry': {'type': 'Point', 'coordinates': [12.1062282, 42.412689301]}}]}	2023-03-22 16:30:57.566923
51076cbf55cc352840595527d9f887364540f00101f90125b3e4000000000092031542616c6c657474692050616c61636520486f74656c	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'name': 'Balletti Palace Hotel', 'building': {'type': 'hotel'}, 'categories': ['accommodation', 'accommodation.hotel', 'building', 'building.accommodation'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': 'Balletti Palace Hotel', 'osm_id': -14988069, 'tourism': 'hotel', 'building': 'hotel', 'osm_type': 'r', 'addr:city': 'Viterbo', 'addr:street': 'Via Fernando Molini', 'addr:postcode': '01100', 'addr:housenumber': 8}}, 'housenumber': '8', 'street': 'Via Fernando Molini', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'Balletti Palace Hotel, Via Fernando Molini, 8, 01100 Viterbo VT, Italy', 'address_line1': 'Balletti Palace Hotel', 'address_line2': 'Via Fernando Molini, 8, 01100 Viterbo VT, Italy', 'lat': 42.42603305, 'lon': 12.105067166736859, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '51076cbf55cc352840595527d9f887364540f00101f90125b3e4000000000092031542616c6c657474692050616c61636520486f74656c'}, 'geometry': {'type': 'Polygon', 'coordinates': [[[12.1047997, 42.426217101], [12.1051336, 42.425774801], [12.1051844, 42.425756601], [12.105259, 42.425761001], [12.105308, 42.425801501], [12.1053218, 42.425849001], [12.1050123, 42.426300701], [12.1047997, 42.426217101]]]}}]}	2023-03-22 16:30:58.151084
514e2c2f29ed3728405939aa66446a354540f00102f9014ca6213700000000920317477565737420486f75736520532e204361746572696e61	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'name': 'Guest House S. Caterina', 'categories': ['accommodation', 'accommodation.guest_house', 'building', 'building.accommodation'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': 'Guest House S. Caterina', 'osm_id': 924952140, 'tourism': 'guest_house', 'building': 'yes', 'osm_type': 'w', 'guest_house': 'guest_house'}}, 'street': 'Via Niccoló di Tuccia', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'Guest House S. Caterina, Via Niccoló di Tuccia, 01100 Viterbo VT, Italy', 'address_line1': 'Guest House S. Caterina', 'address_line2': 'Via Niccoló di Tuccia, 01100 Viterbo VT, Italy', 'lat': 42.4172933, 'lon': 12.109208950836116, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '514e2c2f29ed3728405939aa66446a354540f00102f9014ca6213700000000920317477565737420486f75736520532e204361746572696e61'}, 'geometry': {'type': 'Polygon', 'coordinates': [[[12.1090877, 42.417267401], [12.1091464, 42.417221101], [12.1093779, 42.417340701], [12.1093444, 42.417371901], [12.1093173, 42.417377401], [12.1092664, 42.417370101], [12.1091758, 42.417319201], [12.1090877, 42.417267401]]]}}]}	2023-03-22 16:30:58.66249
51d9a326b0ef35284059d80139a7ed344540f00103f9011c66600b0100000092030a4c27696e636f6e74726f	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'name': "L'incontro", 'facilities': {'internet_access': True, 'smoking': False}, 'categories': ['accommodation', 'accommodation.guest_house', 'internet_access', 'internet_access.free'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': "L'incontro", 'osm_id': 4485834268, 'smoking': 'no', 'tourism': 'guest_house', 'osm_type': 'n', 'internet_access': 'yes', 'internet_access:fee': 'no'}}, 'street': 'Via Incontro', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': "L'incontro, Via Incontro, 01100 Viterbo VT, Italy", 'address_line1': "L'incontro", 'address_line2': 'Via Incontro, 01100 Viterbo VT, Italy', 'lat': 42.4135026, 'lon': 12.1053443, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '51d9a326b0ef35284059d80139a7ed344540f00103f9011c66600b0100000092030a4c27696e636f6e74726f'}, 'geometry': {'type': 'Point', 'coordinates': [12.1053443, 42.413502601]}}]}	2023-03-22 16:30:59.08534
518dff4cce9a212840593ce313e7f2344540f00103f9011dddaf9401000000920314486f74656c205465726d65206465692050617069	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'brand': 'Terme dei Papi', 'name': 'Hotel Terme dei Papi', 'facilities': {'internet_access': True}, 'accommodation': {'rooms': 23}, 'categories': ['accommodation', 'accommodation.hotel', 'internet_access'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': 'Hotel Terme dei Papi', 'brand': 'Terme dei Papi', 'rooms': 23, 'osm_id': 6789520669, 'tourism': 'hotel', 'osm_type': 'n', 'addr:city': 'Viterbo', 'addr:street': 'Strada Bagni', 'internet_access': 'yes', 'internet_access:fee': 'yes'}}, 'street': 'Strada Bagni', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'Hotel Terme dei Papi, Strada Bagni, 01100 Viterbo VT, Italy', 'address_line1': 'Hotel Terme dei Papi', 'address_line2': 'Strada Bagni, 01100 Viterbo VT, Italy', 'lat': 42.4136628, 'lon': 12.0656342, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '518dff4cce9a212840593ce313e7f2344540f00103f9011dddaf9401000000920314486f74656c205465726d65206465692050617069'}, 'geometry': {'type': 'Point', 'coordinates': [12.0656342, 42.413662801]}}]}	2023-03-22 16:31:00.521374
51cecfc3bfbe20284059c7111710ff344540f00103f9017d07b1940100000092030e5465726d65206465692050617069	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'brand': 'Terme dei Papi', 'name': 'Terme dei Papi', 'facilities': {'internet_access': True}, 'accommodation': {'rooms': 23}, 'categories': ['accommodation', 'accommodation.hotel', 'internet_access'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': 'Terme dei Papi', 'brand': 'Terme dei Papi', 'rooms': 23, 'osm_id': 6789597053, 'tourism': 'hotel', 'osm_type': 'n', 'addr:city': 'Viterbo', 'addr:street': 'Strada Bagni', 'internet_access': 'yes', 'internet_access:fee': 'yes'}}, 'street': 'Strada Bagni', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'Terme dei Papi, Strada Bagni, 01100 Viterbo VT, Italy', 'address_line1': 'Terme dei Papi', 'address_line2': 'Strada Bagni, 01100 Viterbo VT, Italy', 'lat': 42.4140339, 'lon': 12.0639553, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '51cecfc3bfbe20284059c7111710ff344540f00103f9017d07b1940100000092030e5465726d65206465692050617069'}, 'geometry': {'type': 'Point', 'coordinates': [12.0639553, 42.414033901]}}]}	2023-03-22 16:31:01.542826
51d2448e63da352840597729d75af3344540f00103f901151fb29c010000009203124c612073756974652064656c20626f72676f	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'name': 'La suite del borgo', 'categories': ['accommodation', 'accommodation.guest_house'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': 'La suite del borgo', 'osm_id': 6923886357, 'tourism': 'guest_house', 'osm_type': 'n'}}, 'street': 'Via Scacciaricci', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'La suite del borgo, Via Scacciaricci, 01100 Viterbo VT, Italy', 'address_line1': 'La suite del borgo', 'address_line2': 'Via Scacciaricci, 01100 Viterbo VT, Italy', 'lat': 42.4136766, 'lon': 12.1051818, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '51d2448e63da352840597729d75af3344540f00103f901151fb29c010000009203124c612073756974652064656c20626f72676f'}, 'geometry': {'type': 'Point', 'coordinates': [12.1051818, 42.413676601]}}]}	2023-03-22 16:31:03.372024
51246bc317dc41284059ecf78afe75334540f00103f901c827759f010000009203194220616e642042206c612076696c6c61206469206c75636961	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'name': 'B and B la villa di lucia', 'categories': ['accommodation', 'accommodation.guest_house'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': 'B and B la villa di lucia', 'osm_id': 6970222536, 'tourism': 'guest_house', 'osm_type': 'n'}}, 'street': 'Strada Roncone', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '02046', 'country': 'Italy', 'country_code': 'it', 'formatted': 'B and B la villa di lucia, Strada Roncone, 02046 Viterbo VT, Italy', 'address_line1': 'B and B la villa di lucia', 'address_line2': 'Strada Roncone, 02046 Viterbo VT, Italy', 'lat': 42.4020384, 'lon': 12.1286323, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '51246bc317dc41284059ecf78afe75334540f00103f901c827759f010000009203194220616e642042206c612076696c6c61206469206c75636961'}, 'geometry': {'type': 'Point', 'coordinates': [12.1286323, 42.402038401]}}]}	2023-03-22 16:31:04.104951
51fb2b75da64362840593ece1304d9344540f00103f90146ea05a00100000092030b496c20436f6e636c617665	{'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'properties': {'feature_type': 'details', 'name': 'Il Conclave', 'categories': ['accommodation', 'accommodation.guest_house'], 'datasource': {'sourcename': 'openstreetmap', 'attribution': '© OpenStreetMap contributors', 'license': 'Open Database Licence', 'url': 'https://www.openstreetmap.org/copyright', 'raw': {'name': 'Il Conclave', 'osm_id': 6979709510, 'tourism': 'guest_house', 'osm_type': 'n', 'guest_house': 'bed_and_breakfast'}}, 'street': 'Via Borgolungo', 'city': 'Viterbo', 'county': 'Viterbo', 'state': 'Lazio', 'postcode': '01100', 'country': 'Italy', 'country_code': 'it', 'formatted': 'Il Conclave, Via Borgolungo, 01100 Viterbo VT, Italy', 'address_line1': 'Il Conclave', 'address_line2': 'Via Borgolungo, 01100 Viterbo VT, Italy', 'lat': 42.4128728, 'lon': 12.1062382, 'timezone': {'name': 'Europe/Rome', 'offset_STD': '+01:00', 'offset_STD_seconds': 3600, 'offset_DST': '+02:00', 'offset_DST_seconds': 7200, 'abbreviation_STD': 'CET', 'abbreviation_DST': 'CEST'}, 'place_id': '51fb2b75da64362840593ece1304d9344540f00103f90146ea05a00100000092030b496c20436f6e636c617665'}, 'geometry': {'type': 'Point', 'coordinates': [12.1062382, 42.412872801]}}]}	2023-03-22 16:31:04.923739
\.


--
-- Data for Name: poi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.poi (poi_id, city_id, name, lat, lon, address, type, phone, email, average_visiting_time, is_active, poh_id, utility_score, description, document_with_idx, document_with_weights, location) FROM stdin;
10	1	Chiesa di San Rocco	42.7439961	11.8649880	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	64	\N	'chies':1 'rocc':4 'san':3	'chies':1B 'rocc':4B 'san':3B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
165	9	Chiesa della Madonna della Cava	42.2197263	12.4259417	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	54	\N	'cav':5 'chies':1 'madonn':3	'cav':5B 'chies':1B 'madonn':3B	0101000020E61000005A01CF0715DA28401949CCFD1F1C4540
167	9	Porta del Borgo	42.2197263	12.4259417	NaN	Architettura fortificata	NaN	NaN	9000	t	1	66	\N	'borg':3 'port':1	'borg':3B 'port':1B	0101000020E61000005A01CF0715DA28401949CCFD1F1C4540
168	10	MUSEO DELLE TRADIZIONI POPOLARI DI CANEPINA	42.3818609	12.2308363	LARGO MARIA DE MATTIAS; 7	Museo, galleria e/o raccolta	761327677	info@cmcimini.it	9000	t	1	13	\N	'canepin':6 'muse':1 'popolar':4 'tradizion':3	'canepin':6B 'muse':1B 'popolar':4B 'tradizion':3B	0101000020E61000009475EE2C30762840818F66D1E0304540
170	10	Biblioteca comunale	42.3809608	12.2336522	Via Guido Rossa	Biblioteca	NaN	NaN	7200	t	1	44	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E6100000E346DB42A17728406C87D052C3304540
171	10	Castello dei Conti Anguillara	42.3809608	12.2336522	Via Soriano	Architettura fortificata	NaN	NaN	5400	t	1	76	\N	'anguillar':4 'castell':1 'cont':3	'anguillar':4B 'castell':1B 'cont':3B	0101000020E6100000E346DB42A17728406C87D052C3304540
172	10	Chiesa parrocchiale cattedrale di santa maria assunta	42.2642760	12.6839720	Via Portapiagge, 51	Chiesa o edificio di culto	NaN	NaN	7200	t	1	1	\N	'assunt':7 'cattedral':3 'chies':1 'mar':6 'parrocchial':2 'sant':5	'assunt':7B 'cattedral':3B 'chies':1B 'mar':6B 'parrocchial':2B 'sant':5B	0101000020E61000006AC2F693315E2940118FC4CBD3214540
173	10	Chiesa di San Michele Arcangelo	42.3809608	12.2336522	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	21	\N	'arcangel':5 'chies':1 'michel':4 'san':3	'arcangel':5B 'chies':1B 'michel':4B 'san':3B	0101000020E6100000E346DB42A17728406C87D052C3304540
175	11	MUSEO ARCHEOLOGICO DI VULCI	42.4409520	11.6840589	-	Museo, galleria e/o raccolta	0761 437787	sba-em@beniculturali.it	3600	t	1	18	\N	'archeolog':2 'muse':1 'vulc':4	'archeolog':2B 'muse':1B 'vulc':4B	0101000020E61000005213D8F73C5E27408B8D791D71384540
176	11	Biblioteca comunale Giosuè Carducci	42.4670321	11.7504805	Via Udine	Biblioteca	+39 0761439030	NaN	10800	t	1	12	\N	'bibliotec':1 'carducc':4 'comunal':2 'giosu':3	'bibliotec':1B 'carducc':4B 'comunal':2B 'giosu':3B	0101000020E61000004B92E7FA3E80274052D735B5C73B4540
177	11	Ex Convento di San Francesco	42.4639626	11.7495088	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	40	\N	'convent':2 'ex':1 'francesc':5 'san':4	'convent':2B 'ex':1B 'francesc':5B 'san':4B	0101000020E6100000DF20109EBF7F274098C86020633B4540
178	11	Castello Ponte Dell'Abbadia (o Castello di Vulci)	42.4639626	11.7495088	NaN	Architettura fortificata	NaN	NaN	5400	t	1	75	\N	'abbad':4 'castell':1,6 'pont':2 'vulc':8	'abbad':4B 'castell':1B,6B 'pont':2B 'vulc':8B	0101000020E6100000DF20109EBF7F274098C86020633B4540
130	7	Cappella del Miracolo	42.6434006	11.9895659	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	32	\N	'cappell':1 'miracol':3	'cappell':1B 'miracol':3B	0101000020E61000003F79B361A8FA2740079D6BF35A524540
182	11	Teatro napoleonico	42.4667609	11.6974815	NaN	Architettura civile	NaN	NaN	3600	t	1	89	\N	'napoleon':2 'teatr':1	'napoleon':2B 'teatr':1B	0101000020E61000004B21904B1C652740984638D2BE3B4540
185	11	Chiesa di S. Croce	42.4639626	11.7495088	Via Cavour, 45	Chiesa o edificio di culto	NaN	NaN	7200	t	1	76	\N	'chies':1 'croc':4 's':3	'chies':1B 'croc':4B 's':3B	0101000020E6100000DF20109EBF7F274098C86020633B4540
186	11	Torre Campanaria della Chiesa degli Apostoli Giovanni e Andrea	42.4639626	11.7495088	NaN	Architettura fortificata	NaN	NaN	9000	t	1	53	\N	'andre':9 'apostol':6 'campanar':2 'chies':4 'giovann':7 'torr':1	'andre':9B 'apostol':6B 'campanar':2B 'chies':4B 'giovann':7B 'torr':1B	0101000020E6100000DF20109EBF7F274098C86020633B4540
187	11	PARCO NATURALISTICO ARCHEOLOGICO DI VULCI	42.4107656	11.6555277	STRADA PROVINCIALE 105, SNC	Area o parco archeologico	NaN	NaN	9000	t	1	59	\N	'archeolog':3 'naturalist':2 'parc':1 'vulc':5	'archeolog':3B 'naturalist':2B 'parc':1B 'vulc':5B	0101000020E6100000843EA253A14F2740312999F793344540
188	11	Castello Torlonia	42.2169001	12.0212749	NaN	Architettura fortificata	NaN	NaN	10800	t	1	14	\N	'castell':1 'torlon':2	'castell':1B 'torlon':2B	0101000020E61000008B732F8BE40A2840E3FFE961C31B4540
189	12	Chiesa della Madonna del Soccorso	42.5465270	11.9047550	Corso Amedeo di Savoia Duca D'Aosta	Chiesa o edificio di culto	NaN	NaN	10800	t	1	7	\N	'chies':1 'madonn':3 'soccors':5	'chies':1B 'madonn':3B 'soccors':5B	0101000020E6100000F3C81F0C3CCF2740C4B0C398F4454540
190	12	Rocca Farnese (o Castello Farnese)	42.5509980	11.9128270	Piazza della Rocca, 1	Architettura fortificata	NaN	NaN	10800	t	1	14	\N	'castell':4 'farnes':2,5 'rocc':1	'castell':4B 'farnes':2B,5B 'rocc':1B	0101000020E6100000C4CF7F0F5ED32740A9143B1A87464540
191	12	Chiesa S. Maria Assunta in Cielo	42.5465270	11.9047550	Piazza della Rocca	Chiesa o edificio di culto	NaN	NaN	7200	t	1	10	\N	'assunt':4 'chies':1 'ciel':6 'mar':3 's':2	'assunt':4B 'chies':1B 'ciel':6B 'mar':3B 's':2B	0101000020E6100000F3C81F0C3CCF2740C4B0C398F4454540
192	12	Chiesa di San Rocco	42.5465270	11.9047550	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	54	\N	'chies':1 'rocc':4 'san':3	'chies':1B 'rocc':4B 'san':3B	0101000020E6100000F3C81F0C3CCF2740C4B0C398F4454540
193	12	Centro Storico Di Capodimonte	42.5465270	11.9047550	NaN	Architettura fortificata	NaN	NaN	7200	t	1	33	\N	'capodimont':4 'centr':1 'storic':2	'capodimont':4B 'centr':1B 'storic':2B	0101000020E6100000F3C81F0C3CCF2740C4B0C398F4454540
194	12	Palazzo del Comune	42.5465270	11.9047550	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	10	\N	'comun':3 'palazz':1	'comun':3B 'palazz':1B	0101000020E6100000F3C81F0C3CCF2740C4B0C398F4454540
196	12	Chiesa di San Carlo	42.5465270	11.9047550	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	27	\N	'carl':4 'chies':1 'san':3	'carl':4B 'chies':1B 'san':3B	0101000020E6100000F3C81F0C3CCF2740C4B0C398F4454540
197	12	Biblioteca comunale Annibal Caro	42.4645280	11.7483661	Via Roma 31	Biblioteca	+39 0761870043	capodimonte@pelagus.it	5400	t	1	82	\N	'annibal':3 'bibliotec':1 'car':4 'comunal':2	'annibal':3B 'bibliotec':1B 'car':4B 'comunal':2B	0101000020E6100000C1DE69D7297F2740C4094CA7753B4540
244	17	Palazzo Comunale	42.6449715	12.2038975	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	9	\N	'comunal':2 'palazz':1	'comunal':2B 'palazz':1B	0101000020E6100000EA78CC406568284010AD156D8E524540
358	27	Palazzo Municipale	42.3732869	12.4028042	Piazza Duomo, 1	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	53	\N	'municipal':2 'palazz':1	'municipal':2B 'palazz':1B	0101000020E61000000562235A3CCE28403AC379DDC72F4540
923	58	ex chiesa di S. Biagio	42.4168441	12.1051148	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	73	\N	'biag':5 'chies':2 'ex':1 's':4	'biag':5B 'chies':2B 'ex':1B 's':4B	0101000020E6100000B3A6689BD1352840E983C0255B354540
174	11	Ponte Dell'Abbadia	42.4639626	11.7495088	NaN	Monumento	NaN	NaN	10800	t	1	73	\N	'abbad':3 'pont':1	'abbad':3B 'pont':1B	0101000020E6100000DF20109EBF7F274098C86020633B4540
201	13	Museo delle confraternite	42.2595445	12.1746311	via Annibal Caro	Museo, galleria e/o raccolta	0761 6679209	capranicasegreteria@hotmail.com	3600	t	1	18	\N	'confratern':3 'muse':1	'confratern':3B 'muse':1B	0101000020E6100000A0BA5E3F69592840A7AD11C138214540
204	13	Chiesa San Francesco	42.2564918	12.1776114	Corso Francesco Petrarca, 42	Chiesa o edificio di culto	NaN	NaN	7200	t	1	55	\N	'chies':1 'francesc':3 'san':2	'chies':1B 'francesc':3B 'san':2B	0101000020E610000026CBA4E1EF5A284099582AB9D4204540
113	7	Palazzo del Drago (o Palazzo Cozza Spada del Drago)	42.6441069	11.9849554	Via Francesco Cozza	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	67	\N	'cozz':6 'drag':3,9 'palazz':1,5 'spad':7	'cozz':6B 'drag':3B,9B 'palazz':1B,5B 'spad':7B	0101000020E61000008609FE124CF8274060504B1872524540
114	7	Chiesa Madonna del Giglio	42.6441069	11.9849554	Via Madonna del Giglio, 49	Chiesa o edificio di culto	NaN	NaN	7200	t	1	4	\N	'chies':1 'gigl':4 'madonn':2	'chies':1B 'gigl':4B 'madonn':2B	0101000020E61000008609FE124CF8274060504B1872524540
520	39	Palazzo della "Corte o Curia" sede del tribunale	42.2428240	12.3455700	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	10	\N	'cort':3 'cur':5 'palazz':1 'sed':6 'tribunal':8	'cort':3B 'cur':5B 'palazz':1B 'sed':6B 'tribunal':8B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
521	39	Biblioteca dell'Istituto superiore di scienze religiose	42.2486690	12.3440930	Via monsignor G. Gori, 11	Biblioteca	+39 0761.556394	info@issr.eu	10800	t	1	39	\N	'bibliotec':1 'istit':3 'relig':7 'scienz':6 'superior':4	'bibliotec':1B 'istit':3B 'relig':7B 'scienz':6B 'superior':4B	0101000020E6100000A8902BF52CB02840B743C362D41F4540
205	13	Biblioteca comunale Alfredo Signoretti	42.2559600	12.1817900	Piazza Sette Luglio	Biblioteca	+39 0761678040	capranicabiblioteca@thunder.it	3600	t	1	48	\N	'alfred':3 'bibliotec':1 'comunal':2 'signorett':4	'alfred':3B 'bibliotec':1B 'comunal':2B 'signorett':4B	0101000020E6100000CC7A3194135D2840C68A1A4CC3204540
206	13	Torri D'Orlando	42.2816490	12.1256527	NaN	Architettura fortificata	NaN	NaN	10800	t	1	8	\N	'd':2 'orland':3 'torr':1	'd':2B 'orland':3B 'torr':1B	0101000020E6100000E64EFA8C55402840BEF90D130D244540
207	13	Castello degli Anguillara	42.3814501	12.2343732	NaN	Architettura fortificata	NaN	NaN	9000	t	1	99	\N	'anguillar':3 'castell':1	'anguillar':3B 'castell':1B	0101000020E6100000241E9AC3FF77284029475C5BD3304540
208	14	PALAZZO FARNESE (o Villa Farnese)	42.3289720	12.2366450	PIAZZALE FARNESE, 1	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	91	\N	'farnes':2,5 'palazz':1 'vill':4	'farnes':2B,5B 'palazz':1B 'vill':4B	0101000020E61000001A868F88297928405DA626C11B2A4540
209	14	Parrocchia S. Michele Arcangelo	42.3266250	12.2357660	Via Filippo Nicolai, 371	Chiesa o edificio di culto	NaN	NaN	7200	t	1	46	\N	'arcangel':4 'michel':3 'parrocc':1 's':2	'arcangel':4B 'michel':3B 'parrocc':1B 's':2B	0101000020E610000079043752B67828402B8716D9CE294540
210	14	Cantine del Palazzo Farnese-Cantinone	42.3266250	12.2357660	PIAZZALE FARNESE, 1	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	7	\N	'cantin':1 'cantinon':6 'farnes':5 'farnese-cantinon':4 'palazz':3	'cantin':1B 'cantinon':6B 'farnes':5B 'farnese-cantinon':4B 'palazz':3B	0101000020E610000079043752B67828402B8716D9CE294540
211	14	Chiesa Madonna delle Grazie	42.3266250	12.2357660	Palombella	Chiesa o edificio di culto	NaN	NaN	7200	t	1	3	\N	'chies':1 'graz':4 'madonn':2	'chies':1B 'graz':4B 'madonn':2B	0101000020E610000079043752B67828402B8716D9CE294540
212	14	Chiesa di Santa Teresa	42.3266250	12.2357660	Viale Santa Teresa, 101	Chiesa o edificio di culto	NaN	NaN	3600	t	1	54	\N	'chies':1 'sant':3 'teres':4	'chies':1B 'sant':3B 'teres':4B	0101000020E610000079043752B67828402B8716D9CE294540
213	14	Biblioteca comunale	42.3266250	12.2357660	Viale Regina Margherita 2	Biblioteca	NaN	NaN	10800	t	1	41	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E610000079043752B67828402B8716D9CE294540
214	14	Scuderie Palazzo Farnese	42.3332388	12.2238967	Via Regina Margherita, 2	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	66	\N	'farnes':3 'palazz':2 'scuder':1	'farnes':3B 'palazz':2B 'scuder':1B	0101000020E6100000595D9896A27228400FE1A991A72A4540
215	14	Museo multimediale di Caprarola	42.3266250	12.2357660	NaN	Museo, galleria e/o raccolta	NaN	NaN	10800	t	1	75	\N	'caprarol':4 'multimedial':2 'muse':1	'caprarol':4B 'multimedial':2B 'muse':1B	0101000020E610000079043752B67828402B8716D9CE294540
216	14	Biblioteca Teresiana	42.3268830	12.2326870	Viale S. Teresa 11	Biblioteca	+39 0761646013	NaN	10800	t	1	87	\N	'bibliotec':1 'teresian':2	'bibliotec':1B 'teresian':2B	0101000020E6100000A1681EC022772840274F594DD7294540
217	14	S. Marco - Suore del Divino Amore	42.3266250	12.2357660	Via XX Settembre, 11	Chiesa o edificio di culto	NaN	NaN	3600	t	1	27	\N	'amor':6 'divin':5 'marc':2 's':1 'suor':3	'amor':6B 'divin':5B 'marc':2B 's':1B 'suor':3B	0101000020E610000079043752B67828402B8716D9CE294540
203	13	Villa Sansoni già Thierry	42.2564918	12.1776114	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	25	\N	'già':3 'sanson':2 'thierry':4 'vill':1	'già':3B 'sanson':2B 'thierry':4B 'vill':1B	0101000020E610000026CBA4E1EF5A284099582AB9D4204540
122	7	Palazzo Cozza Caposavi	42.6441069	11.9849554	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	39	\N	'capos':3 'cozz':2 'palazz':1	'capos':3B 'cozz':2B 'palazz':1B	0101000020E61000008609FE124CF8274060504B1872524540
123	7	Chiesa della Madonna dell'Arcale	42.6441069	11.9849554	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	83	\N	'arcal':5 'chies':1 'madonn':3	'arcal':5B 'chies':1B 'madonn':3B	0101000020E61000008609FE124CF8274060504B1872524540
218	14	Chiesa della Madonna della Consolazione	42.3266250	12.2357660	Piazza Vittorio Emanuele	Chiesa o edificio di culto	NaN	NaN	3600	t	1	93	\N	'chies':1 'consol':5 'madonn':3	'chies':1B 'consol':5B 'madonn':3B	0101000020E610000079043752B67828402B8716D9CE294540
252	17	Chiesa della Madonna delle Grazie	42.6449715	12.2038975	Sermugnano	Chiesa o edificio di culto	NaN	NaN	9000	t	1	2	\N	'chies':1 'graz':5 'madonn':3	'chies':1B 'graz':5B 'madonn':3B	0101000020E6100000EA78CC406568284010AD156D8E524540
254	18	Convento di S. Giovanni Battista	42.5597682	12.1257580	Via Roma, 5	Chiesa o edificio di culto	NaN	NaN	3600	t	1	64	\N	'battist':5 'convent':1 'giovann':4 's':3	'battist':5B 'convent':1B 'giovann':4B 's':3B	0101000020E6100000B56B425A634028409F2B007CA6474540
308	22	Palazzo Ridolfi	42.7383559	12.7363345	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	54	\N	'palazz':1 'ridolf':2	'palazz':1B 'ridolf':2B	0101000020E610000041D5E8D50079294082A73572825E4540
258	18	Chiesa di S. Carlo	42.5597682	12.1257580	Piazza S. Rocco, 14	Chiesa o edificio di culto	NaN	NaN	5400	t	1	79	\N	'carl':4 'chies':1 's':3	'carl':4B 'chies':1B 's':3B	0101000020E6100000B56B425A634028409F2B007CA6474540
259	18	Biblioteca comunale	42.5597682	12.1257580	Piazza della Repubblica	Biblioteca	NaN	NaN	10800	t	1	84	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E6100000B56B425A634028409F2B007CA6474540
260	18	Chiesa di S. Rocco	42.5597682	12.1257580	Piazza S. Rocco	Chiesa o edificio di culto	NaN	NaN	7200	t	1	24	\N	'chies':1 'rocc':4 's':3	'chies':1B 'rocc':4B 's':3B	0101000020E6100000B56B425A634028409F2B007CA6474540
522	39	Torre dei Valle	42.2428240	12.3455700	NaN	Architettura fortificata	NaN	NaN	5400	t	1	72	\N	'torr':1 'vall':3	'torr':1B 'vall':3B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
523	39	Chiesa di S. Maria di Falleri	42.2428240	12.3455700	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	95	\N	'chies':1 'faller':6 'mar':4 's':3	'chies':1B 'faller':6B 'mar':4B 's':3B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
29	1	Biblioteca comunale	42.4703000	12.1742160	Piazza S. Agnese 16	Biblioteca	NaN	NaN	7200	t	1	56	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E61000003FE1ECD63259284087A757CA323C4540
240	17	Chiesa di S. Rocco	42.6449715	12.2038975	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	82	\N	'chies':1 'rocc':4 's':3	'chies':1B 'rocc':4B 's':3B	0101000020E6100000EA78CC406568284010AD156D8E524540
261	18	Centro Storico di Celleno Vecchia	42.5597682	12.1257580	NaN	Architettura fortificata	NaN	NaN	7200	t	1	40	\N	'cellen':4 'centr':1 'storic':2 'vecc':5	'cellen':4B 'centr':1B 'storic':2B 'vecc':5B	0101000020E6100000B56B425A634028409F2B007CA6474540
262	18	Castello Orsini (o Castello di Celleno)	42.5630230	12.1439980	SP11	Architettura fortificata	NaN	NaN	9000	t	1	58	\N	'castell':1,4 'cellen':6 'orsin':2	'castell':1B,4B 'cellen':6B 'orsin':2B	0101000020E6100000FA60191BBA492840AAF23D2311484540
263	18	Chiesa di S. Donato	42.5597682	12.1257580	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	24	\N	'chies':1 'don':4 's':3	'chies':1B 'don':4B 's':3B	0101000020E6100000B56B425A634028409F2B007CA6474540
264	18	Palazzo Caprini	42.5597682	12.1257580	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	49	\N	'caprin':2 'palazz':1	'caprin':2B 'palazz':1B	0101000020E6100000B56B425A634028409F2B007CA6474540
265	19	Torre dell'Orologio	42.5104250	11.7716530	Via Camillo Benso Conte di Cavour	Architettura fortificata	NaN	NaN	7200	t	1	98	\N	'orolog':3 'torr':1	'orolog':3B 'torr':1B	0101000020E610000078B81D1A168B2740C8073D9B55414540
266	19	Chiesa di Sant'Egidio	42.5104250	11.7716530	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	32	\N	'chies':1 'egid':4 'sant':3	'chies':1B 'egid':4B 'sant':3B	0101000020E610000078B81D1A168B2740C8073D9B55414540
132	7	Rocca Monaldeschi della Cervara (o Palazzo Monaldeschi della Cervara)	42.6460800	11.9853970	Piazza Monaldeschi, 61	Architettura fortificata	NaN	NaN	9000	t	1	38	\N	'cervar':4,9 'monaldesc':2,7 'palazz':6 'rocc':1	'cervar':4B,9B 'monaldesc':2B,7B 'palazz':6B 'rocc':1B	0101000020E61000002D27A1F485F82740C24CDBBFB2524540
133	7	Convento Chiesa della Madonna dei Cacciatori	42.6441069	11.9849554	Via Madonna del Cacciatore, 141	Chiesa o edificio di culto	NaN	NaN	10800	t	1	20	\N	'cacciator':6 'chies':2 'convent':1 'madonn':4	'cacciator':6B 'chies':2B 'convent':1B 'madonn':4B	0101000020E61000008609FE124CF8274060504B1872524540
267	19	Rocca Farnese	42.5509834	11.9128378	NaN	Architettura fortificata	NaN	NaN	7200	t	1	34	\N	'farnes':2 'rocc':1	'farnes':2B 'rocc':1B	0101000020E6100000ED1AE3795FD32740C7D1C19F86464540
268	19	Fontana dei Delfini	42.5104250	11.7716530	Via Napoli	Monumento	NaN	NaN	10800	t	1	98	\N	'delfin':3 'fontan':1	'delfin':3B 'fontan':1B	0101000020E610000078B81D1A168B2740C8073D9B55414540
269	19	Museo del brigantaggio di Cellere	42.5114590	11.7755321	Via Guglielmo Marconi - Cellere	Museo, Galleria e/o raccolta	NaN	NaN	5400	t	1	24	\N	'brigantagg':3 'cell':5 'muse':1	'brigantagg':3B 'cell':5B 'muse':1B	0101000020E610000014FF1C8B128D2740581F0F7D77414540
359	27	Chiesa di San Filippo e Giacomo	42.3732869	12.4028042	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	50	\N	'chies':1 'filipp':4 'giacom':6 'san':3	'chies':1B 'filipp':4B 'giacom':6B 'san':3B	0101000020E61000000562235A3CCE28403AC379DDC72F4540
360	27	MUSEO DI GALLESE E CENTRO CULTURALE 'MARCO SCACCHI'	42.3716913	12.4026010	VIA LORENZO FILIPPINI; SNC - GALLESE	Museo, galleria e/o raccolta	761495503	museo@comune.gallese.vt.it	7200	t	1	85	\N	'centr':5 'cultural':6 'galles':3 'marc':7 'muse':1 'scacc':8	'centr':5B 'cultural':6B 'galles':3B 'marc':7B 'muse':1B 'scacc':8B	0101000020E61000007EACE0B721CE284097DA9C94932F4540
361	27	Palazzo Massa	42.3732869	12.4028042	Via Filippini 7a	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	60	\N	'mass':2 'palazz':1	'mass':2B 'palazz':1B	0101000020E61000000562235A3CCE28403AC379DDC72F4540
270	19	Parrocchia Santa Maria Assunta	42.5104250	11.7716530	Piazza Castelfidardo	Chiesa o edificio di culto	NaN	NaN	7200	t	1	30	\N	'assunt':4 'mar':3 'parrocc':1 'sant':2	'assunt':4B 'mar':3B 'parrocc':1B 'sant':2B	0101000020E610000078B81D1A168B2740C8073D9B55414540
271	19	Borgo di Pianiano a Cellere	42.5093370	11.7731670	Pianino	Architettura fortificata	NaN	NaN	5400	t	1	16	\N	'borg':1 'cell':5 'pian':3	'borg':1B 'cell':5B 'pian':3B	0101000020E610000060B1868BDC8B274046D26EF431414540
272	19	Museo del brigantaggio	42.5111064	11.7732155	via Marconi; 20	Museo, galleria e/o raccolta	0761 451791 - 392 7013553	info@museobrigantaggiocellere.it	7200	t	1	26	\N	'brigantagg':3 'muse':1	'brigantagg':3B 'muse':1B	0101000020E61000004485EAE6E28B27405E633CEF6B414540
275	20	Chiesa dell' Ospedale di S. Maria delle Grazie	42.2952260	12.4091700	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	66	\N	'chies':1 'graz':8 'mar':6 'ospedal':3 's':5	'chies':1B 'graz':8B 'mar':6B 'ospedal':3B 's':5B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
276	20	Palazzo Privato Trocchi	42.2952260	12.4091700	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	24	\N	'palazz':1 'priv':2 'trocc':3	'palazz':1B 'priv':2B 'trocc':3B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
279	20	Ponte Clementino	42.2900920	12.4124479	Viale Repubblica, 4B	Monumento	NaN	NaN	9000	t	1	67	\N	'clementin':2 'pont':1	'clementin':2B 'pont':1B	0101000020E6100000969B035F2CD32840666A12BC21254540
280	20	Chiesa San Lorenzo	42.2952260	12.4091700	Via Attilio Bonanni, 6	Chiesa o edificio di culto	NaN	NaN	9000	t	1	69	\N	'chies':1 'lorenz':3 'san':2	'chies':1B 'lorenz':3B 'san':2B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
281	20	MUSEO ARCHEOLOGICO DELL'AGRO FALISCO E FORTE SANGALLO	42.2880258	12.4085077	Via del Forte; snc	Museo, galleria e/o raccolta	0761 513735	-	9000	t	1	62	\N	'agro':4 'archeolog':2 'fal':5 'fort':7 'muse':1 'sangall':8	'agro':4B 'archeolog':2B 'fal':5B 'fort':7B 'muse':1B 'sangall':8B	0101000020E61000000F54D7EB27D12840BEB38707DE244540
282	20	COMUNE DI CIVITA CASTELLANA - MUSEO DELLA CERAMICA 'CASIMIRO MARCANTONI'	42.2883780	12.4153931	VIA A. GRAMSCI 3	Museo, galleria e/o raccolta	7615901	comune.civitacastellana@legalmail.it	10800	t	1	21	\N	'casimir':8 'castellan':4 'ceram':7 'civ':3 'comun':1 'marcanton':9 'muse':5	'casimir':8B 'castellan':4B 'ceram':7B 'civ':3B 'comun':1B 'marcanton':9B 'muse':5B	0101000020E6100000D6F78667AED428406571FF91E9244540
284	20	Biblioteca comunale Enrico Minio	42.2885200	12.4137100	Via U. Midossi 3	Biblioteca	+39 0761590233	bibliotecaminio@thunder.it	7200	t	1	98	\N	'bibliotec':1 'comunal':2 'enric':3 'min':4	'bibliotec':1B 'comunal':2B 'enric':3B 'min':4B	0101000020E61000006B0E10CCD1D32840F71E2E39EE244540
525	39	Catacomba di Santa Savinilla	42.2443524	12.3399837	Via del Cimitero, 29	Area o parco archeologico	NaN	NaN	3600	t	1	83	\N	'catacomb':1 'sant':3 'savinill':4	'catacomb':1B 'sant':3B 'savinill':4B	0101000020E61000009D58F15712AE28407C597FF0461F4540
526	39	Chiesa di San Biagio	42.2428240	12.3455700	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	29	\N	'biag':4 'chies':1 'san':3	'biag':4B 'chies':1B 'san':3B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
285	20	Chiesa di San Benedetto	42.2952260	12.4091700	Via Vincenzo Ferretti, 94/102	Chiesa o edificio di culto	NaN	NaN	9000	t	1	65	\N	'benedett':4 'chies':1 'san':3	'benedett':4B 'chies':1B 'san':3B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
286	20	Chiesa Conventuale di Santa Maria del Carmine	42.2952260	12.4091700	Via Vincenzo Ferretti, 157/161	Chiesa o edificio di culto	NaN	NaN	10800	t	1	3	\N	'carmin':7 'chies':1 'conventual':2 'mar':5 'sant':4	'carmin':7B 'chies':1B 'conventual':2B 'mar':5B 'sant':4B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
287	20	Biblioteca dell'ISIS Colasanti	42.3457025	12.3503741	Via E. Berlinguer	Biblioteca	NaN	NaN	9000	t	1	79	\N	'bibliotec':1 'colas':4 'isis':3	'bibliotec':1B 'colas':4B 'isis':3B	0101000020E61000001ABBE93B64B328409ED2C1FA3F2C4540
288	20	Cattedrale di Santa Maria Maggiore	42.2952260	12.4091700	Piazza del Duomo	Chiesa o edificio di culto	NaN	NaN	5400	t	1	32	\N	'cattedral':1 'maggior':5 'mar':4 'sant':3	'cattedral':1B 'maggior':5B 'mar':4B 'sant':3B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
289	20	Cappella della Madonna delle Rose	42.2952260	12.4091700	Via Madonna delle Rose, 42	Chiesa o edificio di culto	NaN	NaN	5400	t	1	41	\N	'cappell':1 'madonn':3 'ros':5	'cappell':1B 'madonn':3B 'ros':5B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
290	20	Chiesa Privata S. Antonio Abate	42.2952260	12.4091700	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	20	\N	'abat':5 'anton':4 'chies':1 'priv':2 's':3	'abat':5B 'anton':4B 'chies':1B 'priv':2B 's':3B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
291	20	Chiesa della Madonna delle Piagge	42.2952260	12.4091700	Via Fontana Lunga, 1	Chiesa o edificio di culto	NaN	NaN	3600	t	1	53	\N	'chies':1 'madonn':3 'piagg':5	'chies':1B 'madonn':3B 'piagg':5B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
362	27	Chiesa di S. Lorenzo Martire	42.3732869	12.4028042	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	56	\N	'chies':1 'lorenz':4 'mart':5 's':3	'chies':1B 'lorenz':4B 'mart':5B 's':3B	0101000020E61000000562235A3CCE28403AC379DDC72F4540
363	28	Chiesa di S. Maria Maddalena	42.6436919	11.8548880	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	11	\N	'chies':1 'maddalen':5 'mar':4 's':3	'chies':1B 'maddalen':5B 'mar':4B 's':3B	0101000020E6100000577C43E1B3B527409D99057F64524540
364	28	Chiesa di S. Magno	42.6436919	11.8548880	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	9	\N	'chies':1 'magn':4 's':3	'chies':1B 'magn':4B 's':3B	0101000020E6100000577C43E1B3B527409D99057F64524540
292	20	Auditorium Santa Chiara	42.2952260	12.4091700	Via Vincenzo Ferretti, 126	Chiesa o edificio di culto	NaN	NaN	3600	t	1	45	\N	'auditorium':1 'chiar':3 'sant':2	'auditorium':1B 'chiar':3B 'sant':2B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
293	20	Chiesa parrocchiale di S. Gregorio	42.2952260	12.4091700	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	56	\N	'chies':1 'gregor':5 'parrocchial':2 's':4	'chies':1B 'gregor':5B 'parrocchial':2B 's':4B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
295	20	Chiesa Conventuale di Santa Chiara	42.2952260	12.4091700	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	47	\N	'chiar':5 'chies':1 'conventual':2 'sant':4	'chiar':5B 'chies':1B 'conventual':2B 'sant':4B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
296	20	Palazzo Montalto	42.2952260	12.4091700	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	58	\N	'montalt':2 'palazz':1	'montalt':2B 'palazz':1B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
297	20	Oratorio del Sacro Cuore di Maria	42.2952260	12.4091700	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	32	\N	'cuor':4 'mar':6 'orator':1 'sacr':3	'cuor':4B 'mar':6B 'orator':1B 'sacr':3B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
299	20	Palazzo Privato Della Ex Stazione di Posta	42.2952260	12.4091700	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	21	\N	'ex':4 'palazz':1 'post':7 'priv':2 'stazion':5	'ex':4B 'palazz':1B 'post':7B 'priv':2B 'stazion':5B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
300	21	Castello di S. Maria	42.6053622	12.1876584	Località Santa Maria	Architettura fortificata	NaN	NaN	7200	t	1	39	\N	'castell':1 'mar':4 's':3	'castell':1B 'mar':4B 's':3B	0101000020E6100000AEA305C314602840089E31827C4D4540
301	21	Chiesa dell'Immacolata Concezione	42.6053622	12.1876584	S. Michele in Teverina	Chiesa o edificio di culto	NaN	NaN	10800	t	1	27	\N	'chies':1 'concezion':4 'immacol':3	'chies':1B 'concezion':4B 'immacol':3B	0101000020E6100000AEA305C314602840089E31827C4D4540
302	21	Palazzo Montholon	42.6053622	12.1876584	S. Michele in Teverina	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	69	\N	'montholon':2 'palazz':1	'montholon':2B 'palazz':1B	0101000020E6100000AEA305C314602840089E31827C4D4540
662	49	ANFITEATRO ROMANO	42.2470230	12.2150670	VIA CASSIA, KM 49,00	Monumento	NaN	NaN	5400	t	1	97	\N	'anfiteatr':1 'rom':2	'anfiteatr':1B 'rom':2B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
306	21	Torre Monaldeschi	42.7555416	11.9443469	Piazza Unità D'Italia, 231	Architettura fortificata	NaN	NaN	9000	t	1	2	\N	'monaldesc':2 'torr':1	'monaldesc':2B 'torr':1B	0101000020E61000007028D76F81E327403E624F96B5604540
307	21	Chiesa dei SS. Pietro e Callisto	42.6053622	12.1876584	Piazza Unità D'Italia, 3	Chiesa o edificio di culto	NaN	NaN	5400	t	1	37	\N	'callist':6 'chies':1 'pietr':4 'ss':3	'callist':6B 'chies':1B 'pietr':4B 'ss':3B	0101000020E6100000AEA305C314602840089E31827C4D4540
309	22	Chiesa di S. Egidio	42.3449260	12.3556680	la Cannara	Chiesa o edificio di culto	NaN	NaN	3600	t	1	89	\N	'chies':1 'egid':4 's':3	'chies':1B 'egid':4B 's':3B	0101000020E6100000AB77B81D1AB6284022C50089262C4540
310	22	Chiesa della Madonna delle Grazie	42.3449260	12.3556680	Madonna delle Grazie	Chiesa o edificio di culto	NaN	NaN	9000	t	1	93	\N	'chies':1 'graz':5 'madonn':3	'chies':1B 'graz':5B 'madonn':3B	0101000020E6100000AB77B81D1AB6284022C50089262C4540
311	22	Biblioteca comunale S. Valentino	42.3323141	12.2659463	Piazza XX settembre 15	Biblioteca	+39 0761572472	bibliocorchiano@libero.it	7200	t	1	34	\N	'bibliotec':1 'comunal':2 's':3 'valentin':4	'bibliotec':1B 'comunal':2B 's':3B 'valentin':4B	0101000020E610000002FC091D2A882840F5BFB744892A4540
312	22	Chiesa di S. Maria del Soccorso	42.3449260	12.3556680	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	31	\N	'chies':1 'mar':4 's':3 'soccors':6	'chies':1B 'mar':4B 's':3B 'soccors':6B	0101000020E6100000AB77B81D1AB6284022C50089262C4540
313	22	Torre di S. Bruna	42.8351062	12.7056209	Castellaccio /              Santa Bruna	Architettura fortificata	NaN	NaN	10800	t	1	10	\N	'brun':4 's':3 'torr':1	'brun':4B 's':3B 'torr':1B	0101000020E610000088BF812447692940EAD78CC2E46A4540
314	22	Chiesa di S. Maria del Rosario	42.2185940	12.4158720	Via Vittorio Emanuele, III	Chiesa o edificio di culto	NaN	NaN	10800	t	1	95	\N	'chies':1 'mar':4 'rosar':6 's':3	'chies':1B 'mar':4B 'rosar':6B 's':3B	0101000020E6100000ECA4BE2CEDD42840098D60E3FA1B4540
315	22	Chiesa di San Biagio	42.3449260	12.3556680	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	47	\N	'biag':4 'chies':1 'san':3	'biag':4B 'chies':1B 'san':3B	0101000020E6100000AB77B81D1AB6284022C50089262C4540
316	22	Forre e Borgo di Corchiano	42.3454859	12.3606221	Località Madonna del Soccorso	Architettura fortificata	NaN	NaN	10800	t	1	41	\N	'borg':3 'corc':5 'forr':1	'borg':3B 'corc':5B 'forr':1B	0101000020E6100000006EBB75A3B8284054DDC8E1382C4540
317	22	Casale (ex chiesa) di S. Bruna	42.3449260	12.3556680	Castellaccio /              Santa Bruna	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	27	\N	'brun':6 'casal':1 'chies':3 'ex':2 's':5	'brun':6B 'casal':1B 'chies':3B 'ex':2B 's':5B	0101000020E6100000AB77B81D1AB6284022C50089262C4540
365	28	Palazzo Farnese	42.6436919	11.8548880	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	14	\N	'farnes':2 'palazz':1	'farnes':2B 'palazz':1B	0101000020E6100000577C43E1B3B527409D99057F64524540
18	1	Palazzo Boncompagni-Ludovisi	42.7439961	11.8649880	Via Bourbon del Monte, 12, Trevinano	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	67	\N	'boncompagn':3 'boncompagni-ludovis':2 'ludovis':4 'palazz':1	'boncompagn':3B 'boncompagni-ludovis':2B 'ludovis':4B 'palazz':1B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
19	1	Casale San Vittorio	42.7439961	11.8649880	S. Vittorio	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	100	\N	'casal':1 'san':2 'vittor':3	'casal':1B 'san':2B 'vittor':3B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
320	23	Biblioteca comunale Silvano Ricci	42.3344178	12.2959506	Piazza del Duomo, 17	Biblioteca	+39 0761569078	p.sanapo@bibliotecafabricadiroma.it	5400	t	1	24	\N	'bibliotec':1 'comunal':2 'ricc':4 'silv':3	'bibliotec':1B 'comunal':2B 'ricc':4B 'silv':3B	0101000020E6100000917648D686972840A219D533CE2A4540
321	24	Chiesa di S. Maria di Falleri	42.3351260	12.2997670	Via dei Falisci, 40	Chiesa o edificio di culto	NaN	NaN	3600	t	1	85	\N	'chies':1 'faller':6 'mar':4 's':3	'chies':1B 'faller':6B 'mar':4B 's':3B	0101000020E61000000ED76A0F7B9928400805A568E52A4540
322	24	Chiesa Collegiata di San Silvestro Papa	42.3351260	12.2997670	Piazza Duomo, 221	Chiesa o edificio di culto	NaN	NaN	3600	t	1	40	\N	'chies':1 'colleg':2 'pap':6 'san':4 'silvestr':5	'chies':1B 'colleg':2B 'pap':6B 'san':4B 'silvestr':5B	0101000020E61000000ED76A0F7B9928400805A568E52A4540
323	24	Falerii Novi	42.2995342	12.3591211	(Falerii Novi)	Architettura fortificata	NaN	NaN	7200	t	1	60	\N	'faler':1 'nov':2	'faler':1B 'nov':2B	0101000020E61000006A9B87B8DEB728404A84FC2257264540
324	24	Rocca Farnese (o Castello Farnese)	42.5509980	11.9128270	Via A. Cencelli, 21	Architettura fortificata	NaN	NaN	3600	t	1	23	\N	'castell':4 'farnes':2,5 'rocc':1	'castell':4B 'farnes':2B,5B 'rocc':1B	0101000020E6100000C4CF7F0F5ED32740A9143B1A87464540
325	24	Cortile del casale farnesiano	42.3351260	12.2997670	(Falerii Novi)	Parco o Giardino di interesse storico o artistico	NaN	NaN	10800	t	1	30	\N	'casal':3 'cortil':1 'farnes':4	'casal':3B 'cortil':1B 'farnes':4B	0101000020E61000000ED76A0F7B9928400805A568E52A4540
326	24	Casale farnesiano	42.3351260	12.2997670	(Falerii Novi)	Architettura fortificata	NaN	NaN	5400	t	1	71	\N	'casal':1 'farnes':2	'casal':1B 'farnes':2B	0101000020E61000000ED76A0F7B9928400805A568E52A4540
327	25	Castel Paterno	42.2261788	12.4431811	NaN	Architettura fortificata	NaN	NaN	10800	t	1	1	\N	'castel':1 'patern':2	'castel':1B 'patern':2B	0101000020E61000001E6915A2E8E2284036864A6DF31C4540
328	25	Chiesa della Misericordia	42.2261788	12.4431811	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	4	\N	'chies':1 'misericord':3	'chies':1B 'misericord':3B	0101000020E61000001E6915A2E8E2284036864A6DF31C4540
329	25	Eremo Di San Famiano	42.2464107	12.4304602	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	6	\N	'erem':1 'fam':4 'san':3	'erem':1B 'fam':4B 'san':3B	0101000020E61000009175824765DC284036F1C4628A1F4540
330	25	Porta del Borgo	42.2261788	12.4431811	NaN	Architettura fortificata	NaN	NaN	5400	t	1	53	\N	'borg':3 'port':1	'borg':3B 'port':1B	0101000020E61000001E6915A2E8E2284036864A6DF31C4540
331	25	Castel Fogliano (o Foiano)	42.2261788	12.4431811	NaN	Architettura fortificata	NaN	NaN	5400	t	1	68	\N	'castel':1 'fogl':2 'foi':4	'castel':1B 'fogl':2B 'foi':4B	0101000020E61000001E6915A2E8E2284036864A6DF31C4540
332	25	Chiesa di S. Giovanni Decollato	42.2261788	12.4431811	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	89	\N	'chies':1 'decoll':5 'giovann':4 's':3	'chies':1B 'decoll':5B 'giovann':4B 's':3B	0101000020E61000001E6915A2E8E2284036864A6DF31C4540
333	25	Chiesa della Madonna di Pietrafitta	42.2261788	12.4431811	Via Belvedere	Chiesa o edificio di culto	NaN	NaN	9000	t	1	57	\N	'chies':1 'madonn':3 'pietrafitt':5	'chies':1B 'madonn':3B 'pietrafitt':5B	0101000020E61000001E6915A2E8E2284036864A6DF31C4540
334	25	Rocca degli Anguillara (o Palazzo Anguillara, Castello Anguillara, Casale degli Anguillara-casaletto della Carlotta)	42.2261788	12.4431811	Piazza della Collegiata	Architettura fortificata	NaN	NaN	3600	t	1	40	\N	'anguillar':3,6,8,12 'anguillara-casalett':11 'carlott':15 'casal':9 'casalett':13 'castell':7 'palazz':5 'rocc':1	'anguillar':3B,6B,8B,12B 'anguillara-casalett':11B 'carlott':15B 'casal':9B 'casalett':13B 'castell':7B 'palazz':5B 'rocc':1B	0101000020E61000001E6915A2E8E2284036864A6DF31C4540
336	25	Chiesa di S. Giuliano	42.2261788	12.4431811	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	42	\N	'chies':1 'giul':4 's':3	'chies':1B 'giul':4B 's':3B	0101000020E61000001E6915A2E8E2284036864A6DF31C4540
337	26	Riserva Naturale Regionale Selva del Lamone	42.5494260	11.7256520	Loc.tà Bottino s.n.c.	Parco o Giardino di interesse storico o artistico	NaN	NaN	3600	t	1	61	\N	'lamon':6 'natural':2 'regional':3 'riserv':1 'selv':4	'lamon':6B 'natural':2B 'regional':3B 'riserv':1B 'selv':4B	0101000020E6100000D28DB0A8887327403AC9569753464540
339	26	Chiesa del SS. Salvatore	42.5494260	11.7256520	Via XX Settembre, 273	Chiesa o edificio di culto	NaN	NaN	3600	t	1	36	\N	'chies':1 'salvator':4 'ss':3	'chies':1B 'salvator':4B 'ss':3B	0101000020E6100000D28DB0A8887327403AC9569753464540
340	26	Chiesa di S. Maria della Neve	42.5494260	11.7256520	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	99	\N	'chies':1 'mar':4 'nev':6 's':3	'chies':1B 'mar':4B 'nev':6B 's':3B	0101000020E6100000D28DB0A8887327403AC9569753464540
341	26	Chiesa rurale di S. Anna	42.5494260	11.7256520	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	49	\N	'anna':5 'chies':1 'rural':2 's':4	'anna':5B 'chies':1B 'rural':2B 's':4B	0101000020E6100000D28DB0A8887327403AC9569753464540
166	9	Chiesa di S. Giovanni 	42.2197263	12.4259417	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	62	\N	'chies':1 'giovann':4 's':3	'chies':1B 'giovann':4B 's':3B	0101000020E61000005A01CF0715DA28401949CCFD1F1C4540
366	28	Biblioteca comunale	42.6436919	11.8548880	Piazza L. Palombini 2	Biblioteca	NaN	NaN	10800	t	1	100	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E6100000577C43E1B3B527409D99057F64524540
369	28	Museo della chiesa di Santa Maria Maddalena	42.6436919	11.8548880	Via Cavour - Gradoli	Museo, Galleria e/o raccolta	NaN	NaN	10800	t	1	23	\N	'chies':3 'maddalen':7 'mar':6 'muse':1 'sant':5	'chies':3B 'maddalen':7B 'mar':6B 'muse':1B 'sant':5B	0101000020E6100000577C43E1B3B527409D99057F64524540
370	29	Parrocchia S. Martino Vescovo	42.5749030	12.2044306	Piazza G. Marconi, 14	Chiesa o edificio di culto	NaN	NaN	7200	t	1	95	\N	'martin':3 'parrocc':1 's':2 'vescov':4	'martin':3B 'parrocc':1B 's':2B 'vescov':4B	0101000020E6100000739AAA20AB682840A7AFE76B96494540
371	29	Complesso di S. Leonardo	42.5749030	12.2044306	S. Leonardo	Chiesa o edificio di culto	NaN	NaN	9000	t	1	85	\N	'compless':1 'leonard':4 's':3	'compless':1B 'leonard':4B 's':3B	0101000020E6100000739AAA20AB682840A7AFE76B96494540
372	29	Chiesa di San Vincenzo	42.5749030	12.2044306	Sipicciano	Chiesa o edificio di culto	NaN	NaN	10800	t	1	46	\N	'chies':1 'san':3 'vincenz':4	'chies':1B 'san':3B 'vincenz':4B	0101000020E6100000739AAA20AB682840A7AFE76B96494540
373	29	Chiesa di San Bernardino	42.5749030	12.2044306	Sipicciano	Chiesa o edificio di culto	NaN	NaN	5400	t	1	89	\N	'bernardin':4 'chies':1 'san':3	'bernardin':4B 'chies':1B 'san':3B	0101000020E6100000739AAA20AB682840A7AFE76B96494540
374	29	Chiesa della Madonna delle Vigne	42.5749030	12.2044306	Località S.Francesco, 20	Chiesa o edificio di culto	NaN	NaN	10800	t	1	1	\N	'chies':1 'madonn':3 'vign':5	'chies':1B 'madonn':3B 'vign':5B	0101000020E6100000739AAA20AB682840A7AFE76B96494540
375	29	Palazzo Baronale	42.5749030	12.2044306	Sipicciano	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	70	\N	'baronal':2 'palazz':1	'baronal':2B 'palazz':1B	0101000020E6100000739AAA20AB682840A7AFE76B96494540
527	39	MUSEO CIVICO ARCHEOLOGICO DI NEPI	42.2429920	12.3478650	VIA XIII SETTEMBRE; 1	Museo, galleria e/o raccolta	761570604	museo@comune.nepi.vt.it	9000	t	1	52	\N	'archeolog':3 'civic':2 'muse':1 'nep':5	'archeolog':3B 'civic':2B 'muse':1B 'nep':5B	0101000020E610000099D87C5C1BB228404698A25C1A1F4540
529	39	Cascata di Cavaterra	42.2407464	12.3453374	Via Porta Romana	Parco o Giardino di interesse storico o artistico	NaN	NaN	10800	t	1	45	\N	'casc':1 'cavaterr':3	'casc':1B 'cavaterr':3B	0101000020E6100000DD2B4E10D0B028409B502DC7D01E4540
376	29	Chiesa di Santa Maria Assunta	42.5749030	12.2044306	Sipicciano	Chiesa o edificio di culto	NaN	NaN	5400	t	1	76	\N	'assunt':5 'chies':1 'mar':4 'sant':3	'assunt':5B 'chies':1B 'mar':4B 'sant':3B	0101000020E6100000739AAA20AB682840A7AFE76B96494540
377	29	Santuario della Madonna del Castellonchio	42.5749030	12.2044306	Selve	Chiesa o edificio di culto	NaN	NaN	5400	t	1	39	\N	'castellonc':5 'madonn':3 'santuar':1	'castellonc':5B 'madonn':3B 'santuar':1B	0101000020E6100000739AAA20AB682840A7AFE76B96494540
378	29	Castello di Sipicciano (o Castello Baglioni, Bulgarini)	42.5749030	12.2044306	Sipicciano	Architettura fortificata	NaN	NaN	3600	t	1	92	\N	'baglion':6 'bulgarin':7 'castell':1,5 'sipicc':3	'baglion':6B 'bulgarin':7B 'castell':1B,5B 'sipicc':3B	0101000020E6100000739AAA20AB682840A7AFE76B96494540
379	30	Casale Poggio la Camera	42.6745290	11.8722530	Poggio la Camera	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	30	\N	'camer':4 'casal':1 'pogg':2	'camer':4B 'casal':1B 'pogg':2B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
380	30	Monumento a Paolo di Castro	42.6745290	11.8722530	NaN	Monumento	NaN	NaN	10800	t	1	49	\N	'castr':5 'monument':1 'paol':3	'castr':5B 'monument':1B 'paol':3B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
381	30	Palazzo Comunale	42.6745290	11.8722530	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	21	\N	'comunal':2 'palazz':1	'comunal':2B 'palazz':1B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
382	30	Chiesa di Santa Maria di Castelvecchio	42.6745290	11.8722530	Castelvecchio	Chiesa o edificio di culto	NaN	NaN	10800	t	1	79	\N	'castelvecc':6 'chies':1 'mar':4 'sant':3	'castelvecc':6B 'chies':1B 'mar':4B 'sant':3B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
384	30	Chiesa di S. Maria delle Colonne	42.6745290	11.8722530	S. Maria delle Colonne	Chiesa o edificio di culto	NaN	NaN	5400	t	1	19	\N	'chies':1 'colonn':6 'mar':4 's':3	'chies':1B 'colonn':6B 'mar':4B 's':3B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
385	30	Palazzo Orzi	42.6745290	11.8722530	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	79	\N	'orzi':2 'palazz':1	'orzi':2B 'palazz':1B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
386	30	Palazzo Presutti	42.6745290	11.8722530	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	33	\N	'palazz':1 'presutt':2	'palazz':1B 'presutt':2B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
162	9	Il Borgo di Calcata	42.2164161	12.4188287	NaN	Architettura fortificata	NaN	NaN	5400	t	1	82	\N	'borg':2 'calc':4	'borg':2B 'calc':4B	0101000020E61000009D4022B770D62840F7E9D385B31B4540
389	30	Chiesa di San Marco	42.6745290	11.8722530	Piazza Paolo di Castro, 17	Chiesa o edificio di culto	NaN	NaN	3600	t	1	39	\N	'chies':1 'marc':4 'san':3	'chies':1B 'marc':4B 'san':3B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
390	30	Chiesa di San Pietro Apostolo	42.6745290	11.8722530	Via Unione, 1A	Chiesa o edificio di culto	NaN	NaN	9000	t	1	6	\N	'apostol':5 'chies':1 'pietr':4 'san':3	'apostol':5B 'chies':1B 'pietr':4B 'san':3B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
391	30	MUSEO CIVITA	42.6743629	11.8725378	PIAZZA GIACOMO MATTEOTTI, snc	Museo, galleria e/o raccolta	NaN	NaN	5400	t	1	4	\N	'civ':2 'muse':1	'civ':2B 'muse':1B	0101000020E61000002E0C4746BDBE27405F91048651564540
392	30	Museo archeologico e delle tradizioni popolari	42.6745290	11.8722530	piazza Giacomo Matteotti	Museo, Galleria e/o raccolta	NaN	NaN	5400	t	1	30	\N	'archeolog':2 'muse':1 'popolar':6 'tradizion':5	'archeolog':2B 'muse':1B 'popolar':6B 'tradizion':5B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
395	30	museo archeologico e delle tradizioni popolari	42.6852104	11.9022259	piazza Giacomo Matteotti	Museo, galleria e/o raccolta	0763 796983	bibliotecagrotte@libero.it	9000	t	1	43	\N	'archeolog':2 'muse':1 'popolar':6 'tradizion':5	'archeolog':2B 'muse':1B 'popolar':6B 'tradizion':5B	0101000020E610000055359C8DF0CD2740867071F9B4574540
396	30	Palazzo Tramontana	42.6745290	11.8722530	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	36	\N	'palazz':1 'tramontan':2	'palazz':1B 'tramontan':2B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
398	30	Chiesa di Santa Maria dell' Annunziata	42.6745290	11.8722530	Annunziata	Chiesa o edificio di culto	NaN	NaN	7200	t	1	32	\N	'annunz':6 'chies':1 'mar':4 'sant':3	'annunz':6B 'chies':1B 'mar':4B 'sant':3B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
399	30	Cappella del SS. Sacramento	42.6745290	11.8722530	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	82	\N	'cappell':1 'sacr':4 'ss':3	'cappell':1B 'sacr':4B 'ss':3B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
400	30	Grotte di Castro	42.6745290	11.8722530	Grotte di Castro - Grotte di Castro	Museo, Galleria e/o raccolta	NaN	NaN	9000	t	1	94	\N	'castr':3 'grott':1	'castr':3B 'grott':1B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
401	30	Museo della Basilica - Santuario di Maria Santissima del Suffragio	42.6745290	11.8722530	Piazza San Giovanni - Grotte di Castro	Museo, Galleria e/o raccolta	NaN	NaN	9000	t	1	93	\N	'basil':3 'mar':6 'muse':1 'santissim':7 'santuar':4 'suffrag':9	'basil':3B 'mar':6B 'muse':1B 'santissim':7B 'santuar':4B 'suffrag':9B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
402	31	Romitori di Ischia di Castro	42.5442470	11.7530960	NaN	Architettura fortificata	NaN	NaN	5400	t	1	10	\N	'castr':5 'ischi':3 'romitor':1	'castr':5B 'ischi':3B 'romitor':1B	0101000020E6100000307F85CC958127401AF9BCE2A9454540
403	31	Monastero Dei SS. Filippo e Giacomo	42.5446546	11.7540140	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	84	\N	'filipp':4 'giacom':6 'monaster':1 'ss':3	'filipp':4B 'giacom':6B 'monaster':1B 'ss':3B	0101000020E6100000C9737D1F0E822740D84EEF3DB7454540
404	31	Chiesa della Madonna delle Rose	42.5446546	11.7540140	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	9	\N	'chies':1 'madonn':3 'ros':5	'chies':1B 'madonn':3B 'ros':5B	0101000020E6100000C9737D1F0E822740D84EEF3DB7454540
406	31	Rocca Farnese (o Palazzo Farnese)	42.5509980	11.9128270	Piazza Regina Margherita, 1	Architettura fortificata	NaN	NaN	5400	t	1	26	\N	'farnes':2,5 'palazz':4 'rocc':1	'farnes':2B,5B 'palazz':4B 'rocc':1B	0101000020E6100000C4CF7F0F5ED32740A9143B1A87464540
407	31	Ischia di Castro (o complesso antica Città di Castro)	42.5442470	11.7530960	Ischia di Castro - Ischia di Castro	Museo, Galleria e/o raccolta	NaN	NaN	3600	t	1	65	\N	'antic':6 'castr':3,9 'citt':7 'compless':5 'ischi':1	'antic':6B 'castr':3B,9B 'citt':7B 'compless':5B 'ischi':1B	0101000020E6100000307F85CC958127401AF9BCE2A9454540
408	31	Chiesa di S. Giuseppe	42.5446546	11.7540140	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	26	\N	'chies':1 'giusepp':4 's':3	'chies':1B 'giusepp':4B 's':3B	0101000020E6100000C9737D1F0E822740D84EEF3DB7454540
409	31	Rovine di Castro	42.5446546	11.7540140	NaN	Architettura fortificata	NaN	NaN	9000	t	1	34	\N	'castr':3 'rovin':1	'castr':3B 'rovin':1B	0101000020E6100000C9737D1F0E822740D84EEF3DB7454540
410	31	Santuario della Madonna del Giglio	42.5446546	11.7540140	(Fosso Cellerano)	Chiesa o edificio di culto	NaN	NaN	10800	t	1	0	\N	'gigl':5 'madonn':3 'santuar':1	'gigl':5B 'madonn':3B 'santuar':1B	0101000020E6100000C9737D1F0E822740D84EEF3DB7454540
411	31	Duomo di S. Ermete	42.5446546	11.7540140	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	18	\N	'duom':1 'ermet':4 's':3	'duom':1B 'ermet':4B 's':3B	0101000020E6100000C9737D1F0E822740D84EEF3DB7454540
412	31	Chiesa della SS. Trinità	42.5446546	11.7540140	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	89	\N	'chies':1 'ss':3 'trinit':4	'chies':1B 'ss':3B 'trinit':4B	0101000020E6100000C9737D1F0E822740D84EEF3DB7454540
413	31	Chiesa di S. Rocco	42.5446546	11.7540140	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	43	\N	'chies':1 'rocc':4 's':3	'chies':1B 'rocc':4B 's':3B	0101000020E6100000C9737D1F0E822740D84EEF3DB7454540
888	58	Fontana Dei Fiumi	42.4168441	12.1051148	NaN	Monumento	NaN	NaN	3600	t	1	94	\N	'fium':3 'fontan':1	'fium':3B 'fontan':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
416	31	MUSEO CIVICO ARCHEOLOGICO 'PIETRO E TURIDDO LOTTI'	42.5443643	11.7559713	PIAZZA CAVALIERI VITTORIO VENETO	Museo, galleria e/o raccolta	0761-425455	ischia_museocivico@libero.it	7200	t	1	83	\N	'archeolog':3 'civic':2 'lott':7 'muse':1 'pietr':4 'turidd':6	'archeolog':3B 'civic':2B 'lott':7B 'muse':1B 'pietr':4B 'turidd':6B	0101000020E6100000E16D94AB0E83274012CEB8BAAD454540
418	32	Chiesa  della Madonna della Cava	42.6290280	11.8274530	SP117	Chiesa o edificio di culto	NaN	NaN	5400	t	1	79	\N	'cav':5 'chies':1 'madonn':3	'cav':5B 'chies':1B 'madonn':3B	0101000020E610000045F46BEBA7A72740572250FD83504540
419	32	Palazzo Farnese	42.6290280	11.8274530	cd. Rocca	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	12	\N	'farnes':2 'palazz':1	'farnes':2B 'palazz':1B	0101000020E610000045F46BEBA7A72740572250FD83504540
421	32	Fontana del Piscero	42.6290280	11.8274530	NaN	Monumento	NaN	NaN	9000	t	1	22	\N	'fontan':1 'piscer':3	'fontan':1B 'piscer':3B	0101000020E610000045F46BEBA7A72740572250FD83504540
422	32	Fontana Ducale	42.6290280	11.8274530	Via Ripetta, 16	Monumento	NaN	NaN	3600	t	1	52	\N	'ducal':2 'fontan':1	'ducal':2B 'fontan':1B	0101000020E610000045F46BEBA7A72740572250FD83504540
424	32	Chiesa  di S. Clemente	42.6290280	11.8274530	Piazza S. Clemente, 11	Chiesa o edificio di culto	NaN	NaN	9000	t	1	57	\N	'chies':1 'clement':4 's':3	'chies':1B 'clement':4B 's':3B	0101000020E610000045F46BEBA7A72740572250FD83504540
425	32	Piazza IV Novembre	42.6290280	11.8274530	Corso Vittorio Emanuele III	Monumento	NaN	NaN	3600	t	1	78	\N	'iv':2 'novembr':3 'piazz':1	'iv':2B 'novembr':3B 'piazz':1B	0101000020E610000045F46BEBA7A72740572250FD83504540
589	43	Rocca di Piansano	42.5230610	11.8300000	NaN	Architettura fortificata	NaN	NaN	7200	t	1	79	\N	'pians':3 'rocc':1	'pians':3B 'rocc':1B	0101000020E6100000295C8FC2F5A827401268B0A9F3424540
426	32	Chiesa di S. Giuseppe	42.6290280	11.8274530	Via S. Giuseppe, 1	Chiesa o edificio di culto	NaN	NaN	3600	t	1	89	\N	'chies':1 'giusepp':4 's':3	'chies':1B 'giusepp':4B 's':3B	0101000020E610000045F46BEBA7A72740572250FD83504540
427	32	Chiesa di S. Rocco	42.6290280	11.8274530	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	5	\N	'chies':1 'rocc':4 's':3	'chies':1B 'rocc':4B 's':3B	0101000020E610000045F46BEBA7A72740572250FD83504540
367	28	MUSEO DEL COSTUME FARNESIANO	42.6440900	11.8561900	PIAZZA LUIGI PALOMBINI; 2	Museo, galleria e/o raccolta	761456082	comunedigradoli@legalmail.it	9000	t	1	90	\N	'costum':3 'farnes':4 'muse':1	'costum':3B 'farnes':4B 'muse':1B	0101000020E6100000115322895EB627401FD7868A71524540
368	28	Chiesa di S. Michele Arcangelo	42.6436919	11.8548880	Via Camillo Benso Conte di Cavour, 98	Chiesa o edificio di culto	NaN	NaN	9000	t	1	22	\N	'arcangel':5 'chies':1 'michel':4 's':3	'arcangel':5B 'chies':1B 'michel':4B 's':3B	0101000020E6100000577C43E1B3B527409D99057F64524540
528	39	Chiesa di San Giovanni	42.2428240	12.3455700	Piazza S. Giovanni, 7	Chiesa o edificio di culto	NaN	NaN	5400	t	1	56	\N	'chies':1 'giovann':4 'san':3	'chies':1B 'giovann':4B 'san':3B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
428	32	Chiesa di Santi Pietro e Paolo	42.6290280	11.8274530	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	70	\N	'chies':1 'paol':6 'pietr':4 'sant':3	'chies':1B 'paol':6B 'pietr':4B 'sant':3B	0101000020E610000045F46BEBA7A72740572250FD83504540
429	32	Biblioteca comunale	42.6290280	11.8274530	Via Piave 3	Biblioteca	NaN	NaN	10800	t	1	77	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E610000045F46BEBA7A72740572250FD83504540
430	32	MUSEO DELLA TERRA	42.6300003	11.8280678	VIA DELL'OSTERIA; SNC	Museo, galleria e/o raccolta	761459041	museo@comune.latera.vt.it	3600	t	1	12	\N	'muse':1 'terr':3	'muse':1B 'terr':3B	0101000020E6100000C8BDAF80F8A727402F7C8ED9A3504540
431	32	Piazza Della Rocca	42.2744493	12.0256516	Piazza della Rocca	Monumento	NaN	NaN	5400	t	1	38	\N	'piazz':1 'rocc':3	'piazz':1B 'rocc':3B	0101000020E61000001E2EDE34220D28407EF4972721234540
432	32	Chiesa della Madonna del Carmine	42.6290280	11.8274530	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	53	\N	'carmin':5 'chies':1 'madonn':3	'carmin':5B 'chies':1B 'madonn':3B	0101000020E610000045F46BEBA7A72740572250FD83504540
433	32	Chiesa di S. Sebastiano	42.6290280	11.8274530	Via S. Sebastiano, 660	Chiesa o edificio di culto	NaN	NaN	10800	t	1	14	\N	'chies':1 's':3 'sebast':4	'chies':1B 's':3B 'sebast':4B	0101000020E610000045F46BEBA7A72740572250FD83504540
434	32	Chiesa della Madonna delle Grazie	42.6290280	11.8274530	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	44	\N	'chies':1 'graz':5 'madonn':3	'chies':1B 'graz':5B 'madonn':3B	0101000020E610000045F46BEBA7A72740572250FD83504540
436	33	Fontana La Pucciotta	42.6362310	12.1087590	Piazza S. Giovanni Battista, 8/1	Monumento	NaN	NaN	5400	t	1	28	\N	'fontan':1 'pucciott':3	'fontan':1B 'pucciott':3B	0101000020E6100000944A7842AF372840C7D9740470514540
437	33	Chiesa di S. Giovanni Battista	42.6362310	12.1087590	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	5	\N	'battist':5 'chies':1 'giovann':4 's':3	'battist':5B 'chies':1B 'giovann':4B 's':3B	0101000020E6100000944A7842AF372840C7D9740470514540
438	33	Cappella del Castello di Seppie	42.6362310	12.1087590	Seppie	Chiesa o edificio di culto	NaN	NaN	9000	t	1	83	\N	'cappell':1 'castell':3 'sepp':5	'cappell':1B 'castell':3B 'sepp':5B	0101000020E6100000944A7842AF372840C7D9740470514540
439	33	Ex Palazzo Municipale	42.6362310	12.1087590	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	46	\N	'ex':1 'municipal':3 'palazz':2	'ex':1B 'municipal':3B 'palazz':2B	0101000020E6100000944A7842AF372840C7D9740470514540
530	39	Villa  tenuta "Casale" o tenuta "Pazzielli"	42.2428240	12.3455700	Casale	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	47	\N	'casal':3 'pazziell':6 'ten':2,5 'vill':1	'casal':3B 'pazziell':6B 'ten':2B,5B 'vill':1B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
748	51	Chiesa San Pietro	42.4185731	11.8703089	-	Museo, galleria e/o raccolta	-	-	7200	t	1	68	\N	'chies':1 'pietr':3 'san':2	'chies':1B 'pietr':3B 'san':2B	0101000020E6100000E1D5CD2099BD274020BEA7CD93354540
440	33	Torre del Sole o di Santa Caterina	42.6362310	12.1087590	NaN	Architettura fortificata	NaN	NaN	5400	t	1	80	\N	'caterin':7 'sant':6 'sol':3 'torr':1	'caterin':7B 'sant':6B 'sol':3B 'torr':1B	0101000020E6100000944A7842AF372840C7D9740470514540
441	33	Chiesa di S. Caterina	42.6362310	12.1087590	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	95	\N	'caterin':4 'chies':1 's':3	'caterin':4B 'chies':1B 's':3B	0101000020E6100000944A7842AF372840C7D9740470514540
442	33	Teatro dei Calanchi	42.6521484	12.1040617	Via Roma 39	Architettura civile	NaN	NaN	7200	t	1	79	\N	'calanc':3 'teatr':1	'calanc':3B 'teatr':1B	0101000020E610000047883C9347352840C211499979534540
443	33	MUSEO NATURALISTICO DI LUBRIANO	42.6364620	12.1108139	piazza Col di Lana; 12	Museo, galleria e/o raccolta	0761 780391 - 327 0289027	info@museolubriano.com	5400	t	1	76	\N	'lubr':4 'muse':1 'naturalist':2	'lubr':4B 'muse':1B 'naturalist':2B	0101000020E61000006AE27899BC382840C992399677514540
444	33	Grotta di S. Procolo	42.6362310	12.1087590	NaN	Area o parco archeologico	NaN	NaN	9000	t	1	95	\N	'grott':1 'procol':4 's':3	'grott':1B 'procol':4B 's':3B	0101000020E6100000944A7842AF372840C7D9740470514540
445	33	Torre Medievale (o Torre Monaldeschi)	42.6362310	12.1087590	Via della Torre, 171	Architettura fortificata	NaN	NaN	3600	t	1	90	\N	'medieval':2 'monaldesc':5 'torr':1,4	'medieval':2B 'monaldesc':5B 'torr':1B,4B	0101000020E6100000944A7842AF372840C7D9740470514540
446	33	Chiesa della Madonna del Poggio	42.6362310	12.1087590	Via G. Marconi, 271	Chiesa o edificio di culto	NaN	NaN	7200	t	1	32	\N	'chies':1 'madonn':3 'pogg':5	'chies':1B 'madonn':3B 'pogg':5B	0101000020E6100000944A7842AF372840C7D9740470514540
447	34	Palazzo Comunale	42.5339112	11.9249120	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	26	\N	'comunal':2 'palazz':1	'comunal':2B 'palazz':1B	0101000020E61000001D5BCF108ED92740EB7BC33357444540
294	20	Chiesa San Pietro	42.4185731	11.8703089	-	Chiesa o edificio di culto	-	-	3600	t	1	16	\N	'chies':1 'pietr':3 'san':2	'chies':1B 'pietr':3B 'san':2B	0101000020E6100000E1D5CD2099BD274020BEA7CD93354540
448	34	Palazzo Orsini-Farnese	42.5339112	11.9249120	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	76	\N	'farnes':4 'orsin':3 'orsini-farnes':2 'palazz':1	'farnes':4B 'orsin':3B 'orsini-farnes':2B 'palazz':1B	0101000020E61000001D5BCF108ED92740EB7BC33357444540
449	34	Palazzo Tarquini	42.5339112	11.9249120	 p.za Umberto I	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	62	\N	'palazz':1 'tarquin':2	'palazz':1B 'tarquin':2B	0101000020E61000001D5BCF108ED92740EB7BC33357444540
450	34	Palazzo Sforza-Ciotti	42.5339112	11.9249120	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	53	\N	'ciott':4 'palazz':1 'sforz':3 'sforza-ciott':2	'ciott':4B 'palazz':1B 'sforz':3B 'sforza-ciott':2B	0101000020E61000001D5BCF108ED92740EB7BC33357444540
451	34	Biblioteca comunale Alfredo Tarquini	42.5348010	11.9252188	Via N. Bixio 10	Biblioteca	+39 0761870476	bibmarta@inwind.it	9000	t	1	59	\N	'alfred':3 'bibliotec':1 'comunal':2 'tarquin':4	'alfred':3B 'bibliotec':1B 'comunal':2B 'tarquin':4B	0101000020E6100000EA494F47B6D927401E6FF25B74444540
453	34	Chiesa del Santissimo Crocifisso	42.5339112	11.9249120	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	37	\N	'chies':1 'crocifiss':4 'santissim':3	'chies':1B 'crocifiss':4B 'santissim':3B	0101000020E61000001D5BCF108ED92740EB7BC33357444540
454	34	Sito Templare di Castell'Araldo	42.5339112	11.9249120	NaN	Architettura fortificata	NaN	NaN	7200	t	1	28	\N	'arald':5 'castell':4 'sit':1 'templ':2	'arald':5B 'castell':4B 'sit':1B 'templ':2B	0101000020E61000001D5BCF108ED92740EB7BC33357444540
455	34	Chiesa di S. Marta e S. Biagio	42.5339112	11.9249120	Lg. S. Biagio, 5	Chiesa o edificio di culto	NaN	NaN	3600	t	1	32	\N	'biag':7 'chies':1 'mart':4 's':3,6	'biag':7B 'chies':1B 'mart':4B 's':3B,6B	0101000020E61000001D5BCF108ED92740EB7BC33357444540
456	34	Chiesa Madonna del Monte	42.5339112	11.9249120	Strada Provinciale Verentana	Chiesa o edificio di culto	NaN	NaN	3600	t	1	97	\N	'chies':1 'madonn':2 'mont':4	'chies':1B 'madonn':2B 'mont':4B	0101000020E61000001D5BCF108ED92740EB7BC33357444540
458	34	Lungolago di Marta	42.5350730	11.9269318	Via Laertina, 1181	Parco o Giardino di interesse storico o artistico	NaN	NaN	10800	t	1	49	\N	'lungolag':1 'mart':3	'lungolag':1B 'mart':3B	0101000020E6100000AD3E0DCE96DA27407EFCA5457D444540
459	34	Chiesa della Madonna del Castagno	42.5339112	11.9249120	Via Capodimonte	Chiesa o edificio di culto	NaN	NaN	7200	t	1	33	\N	'castagn':5 'chies':1 'madonn':3	'castagn':5B 'chies':1B 'madonn':3B	0101000020E61000001D5BCF108ED92740EB7BC33357444540
460	34	Palazzo Vescovile	42.5339112	11.9249120	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	67	\N	'palazz':1 'vescovil':2	'palazz':1B 'vescovil':2B	0101000020E61000001D5BCF108ED92740EB7BC33357444540
461	34	Isola Martana	42.5496684	11.9529794	Isola Martana	Parco o Giardino di interesse storico o artistico	NaN	NaN	7200	t	1	58	\N	'isol':1 'martan':2	'isol':1B 'martan':2B	0101000020E6100000FE8579EAECE7274084D2BC885B464540
462	35	Madonna dello Speronello	42.3534605	11.6063117	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	46	\N	'madonn':1 'speronell':3	'madonn':1B 'speronell':3B	0101000020E6100000445DB57C6E362740C2F693313E2D4540
463	35	Parco Archeologico Naturalistico di Vulci	42.4107656	11.6555277	NaN	Area o parco archeologico	NaN	NaN	3600	t	1	8	\N	'archeolog':2 'naturalist':3 'parc':1 'vulc':5	'archeolog':2B 'naturalist':3B 'parc':1B 'vulc':5B	0101000020E6100000843EA253A14F2740312999F793344540
464	35	Chiesa di Santa Maria Assunta	42.3534605	11.6063117	Via S. Paolo della Croce, 3	Chiesa o edificio di culto	NaN	NaN	10800	t	1	22	\N	'assunt':5 'chies':1 'mar':4 'sant':3	'assunt':5B 'chies':1B 'mar':4B 'sant':3B	0101000020E6100000445DB57C6E362740C2F693313E2D4540
466	35	Biblioteca comunale	42.3534605	11.6063117	Via Tirrenia 6	Biblioteca	NaN	NaN	3600	t	1	42	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E6100000445DB57C6E362740C2F693313E2D4540
467	35	Castello Guglielmi	42.3534605	11.6063117	Circonvallazione Vulci, 23	Architettura fortificata	NaN	NaN	5400	t	1	78	\N	'castell':1 'guglielm':2	'castell':1B 'guglielm':2B	0101000020E6100000445DB57C6E362740C2F693313E2D4540
468	35	Centro Storico	42.3534605	11.6063117	NaN	Architettura fortificata	NaN	NaN	5400	t	1	39	\N	'centr':1 'storic':2	'centr':1B 'storic':2B	0101000020E6100000445DB57C6E362740C2F693313E2D4540
435	33	Castello di Seppie	42.6362310	12.1087590	NaN	Architettura fortificata	NaN	NaN	9000	t	1	36	\N	'castell':1 'sepp':3	'castell':1B 'sepp':3B	0101000020E6100000944A7842AF372840C7D9740470514540
469	35	Fontana del Mascherone	42.3534605	11.6063117	Via del Mascherone, 9	Monumento	NaN	NaN	7200	t	1	46	\N	'fontan':1 'mascheron':3	'fontan':1B 'mascheron':3B	0101000020E6100000445DB57C6E362740C2F693313E2D4540
383	30	Fontana Grande	42.6745290	11.8722530	Piazza Cardinale Carlo Salotti, 13	Monumento	NaN	NaN	9000	t	1	92	\N	'fontan':1 'grand':2	'fontan':1B 'grand':2B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
470	35	Ponte del Diavolo	42.3534605	11.6063117	NaN	Monumento	NaN	NaN	5400	t	1	0	\N	'diavol':3 'pont':1	'diavol':3B 'pont':1B	0101000020E6100000445DB57C6E362740C2F693313E2D4540
541	40	Castello di Onano	42.6922190	11.8169410	NaN	Architettura fortificata	NaN	NaN	10800	t	1	93	\N	'castell':1 'onan':3	'castell':1B 'onan':3B	0101000020E6100000E8853B1746A22740BD55D7A19A584540
471	35	Chiesa di Santa Croce	42.3534605	11.6063117	Piazza Felice Guglielmi, 19	Chiesa o edificio di culto	NaN	NaN	9000	t	1	31	\N	'chies':1 'croc':4 'sant':3	'chies':1B 'croc':4B 'sant':3B	0101000020E6100000445DB57C6E362740C2F693313E2D4540
472	35	Teatro Comunale Lea Padovani	42.3534605	11.6063117	Via Aurelia Tarquinia, 58	Architettura civile	NaN	NaN	3600	t	1	61	\N	'comunal':2 'lea':3 'padovan':4 'teatr':1	'comunal':2B 'lea':3B 'padovan':4B 'teatr':1B	0101000020E6100000445DB57C6E362740C2F693313E2D4540
473	36	Fontana a largo S. Corona	42.2665210	11.8937590	NaN	Monumento	NaN	NaN	7200	t	1	68	\N	'coron':5 'fontan':1 'larg':3 's':4	'coron':5B 'fontan':1B 'larg':3B 's':4B	0101000020E6100000E60297C79AC927403E59315C1D224540
79	3	Museo della Tuscia Rupestre Francesco Spallone	42.2498341	12.0673735	NaN	Museo, galleria e/o raccolta	NaN	NaN	3600	t	1	66	\N	'francesc':5 'muse':1 'rupestr':4 'spallon':6 'tusc':3	'francesc':5B 'muse':1B 'rupestr':4B 'spallon':6B 'tusc':3B	0101000020E6100000EF3B86C77E2228407A765490FA1F4540
474	36	Chiesa del S. Spirito a largo S. Corona	42.2665210	11.8937590	Via Santo Spirito	Chiesa o edificio di culto	NaN	NaN	5400	t	1	47	\N	'chies':1 'coron':8 'larg':6 's':3,7 'spir':4	'chies':1B 'coron':8B 'larg':6B 's':3B,7B 'spir':4B	0101000020E6100000E60297C79AC927403E59315C1D224540
479	36	Fontana del Mascherone	42.2665210	11.8937590	NaN	Monumento	NaN	NaN	9000	t	1	13	\N	'fontan':1 'mascheron':3	'fontan':1B 'mascheron':3B	0101000020E6100000E60297C79AC927403E59315C1D224540
480	36	Teatro Comunale Rotonda	42.2665210	11.8937590	Piazza XXIV maggio	Architettura civile	NaN	NaN	3600	t	1	72	\N	'comunal':2 'rotond':3 'teatr':1	'comunal':2B 'rotond':3B 'teatr':1B	0101000020E6100000E60297C79AC927403E59315C1D224540
481	37	Teatro Eliseo	42.5599207	12.0297937	Corso Cavour 55	Architettura civile	NaN	NaN	7200	t	1	79	\N	'elise':2 'teatr':1	'elise':2B 'teatr':1B	0101000020E6100000F140AE1E410F28403D6D437BAB474540
482	37	Palazzo Scoppola Iacopini	42.5379248	12.0309974	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	18	\N	'iacopin':3 'palazz':1 'scoppol':2	'iacopin':3B 'palazz':1B 'scoppol':2B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
483	37	Chiesa di San Francesco	42.5379248	12.0309974	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	67	\N	'chies':1 'francesc':4 'san':3	'chies':1B 'francesc':4B 'san':3B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
387	30	Casale Borgo	42.6745290	11.8722530	Val di Lago	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	82	\N	'borg':2 'casal':1	'borg':2B 'casal':1B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
485	37	Basilica di San Flaviano	42.5379248	12.0309974	Via San Flaviano	Chiesa o edificio di culto	NaN	NaN	9000	t	1	36	\N	'basil':1 'flav':4 'san':3	'basil':1B 'flav':4B 'san':3B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
486	37	Biblioteca comunale	42.5379248	12.0309974	Largo S. Pietro 1	Biblioteca	NaN	NaN	5400	t	1	73	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
512	39	Palazzo Celsi	42.2428240	12.3455700	Via Garibaldi, 116	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	54	\N	'cels':2 'palazz':1	'cels':2B 'palazz':1B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
487	37	Chiesa di Santa Maria delle Grazie	42.5379248	12.0309974	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	80	\N	'chies':1 'graz':6 'mar':4 'sant':3	'chies':1B 'graz':6B 'mar':4B 'sant':3B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
488	37	Palazzo Renzi-Doria	42.5379248	12.0309974	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	6	\N	'dor':4 'palazz':1 'renz':3 'renzi-dor':2	'dor':4B 'palazz':1B 'renz':3B 'renzi-dor':2B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
489	37	Biblioteca del Seminario vescovile Barbarigo	42.5357331	12.0285281	Via Trento, 57	Biblioteca	+39 0761.826070	cedi.do@libero.it	10800	t	1	41	\N	'barbarig':5 'bibliotec':1 'seminar':3 'vescovil':4	'barbarig':5B 'bibliotec':1B 'seminar':3B 'vescovil':4B	0101000020E6100000B708313C9B0E28403EF1F7E692444540
490	37	Museo dell'architettura di Antonio da Sangallo Il Giovane	42.5379248	12.0309974	Piazza Urbano V - Montefiascone	Museo, Galleria e/o raccolta	NaN	NaN	5400	t	1	5	\N	'anton':5 'architettur':3 'giovan':9 'muse':1 'sangall':7	'anton':5B 'architettur':3B 'giovan':9B 'muse':1B 'sangall':7B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
491	37	Chiesa di Santa Maria della Potenza o del Divino Amore	42.5379248	12.0309974	Corso Camillo Benso Conte di Cavour, 64A	Chiesa o edificio di culto	NaN	NaN	10800	t	1	95	\N	'amor':10 'chies':1 'divin':9 'mar':4 'potenz':6 'sant':3	'amor':10B 'chies':1B 'divin':9B 'mar':4B 'potenz':6B 'sant':3B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
492	37	Palazzo Buti-Volpiani	42.5379248	12.0309974	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	81	\N	'but':3 'buti-volpian':2 'palazz':1 'volpian':4	'but':3B 'buti-volpian':2B 'palazz':1B 'volpian':4B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
493	37	Monumento al Pellegrino	42.5379248	12.0309974	Piazza Urbano V	Monumento	NaN	NaN	3600	t	1	29	\N	'monument':1 'pellegrin':3	'monument':1B 'pellegrin':3B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
494	37	Rocca dei Papi	42.5366122	12.0280798	Piazza Urbano V	Architettura fortificata	NaN	NaN	5400	t	1	18	\N	'pap':3 'rocc':1	'pap':3B 'rocc':1B	0101000020E6100000405BBD79600E28403BD164B5AF444540
495	37	Biblioteca dell'Istituto tecnico commerciale e per geometri Carlo Alberto Dalla Chiesa	42.5457646	12.0329183	Via A. Moro 1	Biblioteca	NaN	NaN	9000	t	1	58	\N	'albert':10 'bibliotec':1 'carl':9 'chies':12 'commercial':5 'geometr':8 'istit':3 'tecnic':4	'albert':10B 'bibliotec':1B 'carl':9B 'chies':12B 'commercial':5B 'geometr':8B 'istit':3B 'tecnic':4B	0101000020E61000003DE1DBAADA10284042284A9DDB454540
134	7	Biblioteca comunale Giuseppe Cozza Luzi	42.6060008	11.9576317	Largo S. Giovanni Battista de La Salle 3	Biblioteca	+39 0761795319	biblioteca@comunebolsena.it	9000	t	1	74	\N	'bibliotec':1 'comunal':2 'cozz':4 'giusepp':3 'luz':5	'bibliotec':1B 'comunal':2B 'cozz':4B 'giusepp':3B 'luz':5B	0101000020E6100000CC39C2B34EEA2740C7AC286F914D4540
513	39	La Via Armerina	42.2428240	12.3455700	NaN	Area o parco archeologico	NaN	NaN	3600	t	1	64	\N	'armerin':3 'via':2	'armerin':3B 'via':2B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
509	39	Castello di Ponte Nepesino	42.2151905	12.3364733	Via Umilta, 5277	Architettura fortificata	NaN	NaN	9000	t	1	9	\N	'castell':1 'nepesin':4 'pont':3	'castell':1B 'nepesin':4B 'pont':3B	0101000020E610000053F4763A46AC284077F4BF5C8B1B4540
511	39	Chiesa di San Vito	42.2428240	12.3455700	Via S. Vito, 21	Chiesa o edificio di culto	NaN	NaN	5400	t	1	38	\N	'chies':1 'san':3 'vit':4	'chies':1B 'san':3B 'vit':4B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
535	39	Duomo di S. Maria Assunta e Anastasia	42.2428240	12.3455700	Via Luigi Cadorna, 6	Chiesa o edificio di culto	NaN	NaN	3600	t	1	85	\N	'anastas':7 'assunt':5 'duom':1 'mar':4 's':3	'anastas':7B 'assunt':5B 'duom':1B 'mar':4B 's':3B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
80	3	Tomba Margareth	42.2585300	12.0788570	NaN	Area o parco archeologico	NaN	NaN	7200	t	1	12	\N	'margareth':2 'tomb':1	'margareth':2B 'tomb':1B	0101000020E6100000101FD8F15F2828407784D38217214540
120	7	Casale Gazzetta	42.6441069	11.9849554	Gazzetta	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	9	\N	'casal':1 'gazzett':2	'casal':1B 'gazzett':2B	0101000020E61000008609FE124CF8274060504B1872524540
536	39	Chiesa Parrocchiale di S. Croce	42.2428240	12.3455700	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	87	\N	'chies':1 'croc':5 'parrocchial':2 's':4	'chies':1B 'croc':5B 'parrocchial':2B 's':4B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
538	40	Chiesa di S. Maria della Concezione	42.6928561	11.8163999	Piazza Papa Pio XII, 2	Chiesa o edificio di culto	NaN	NaN	5400	t	1	48	\N	'chies':1 'concezion':6 'mar':4 's':3	'chies':1B 'concezion':6B 'mar':4B 's':3B	0101000020E610000054EAED2AFFA12740C42A3982AF584540
539	40	Chiesa della Madonna delle Grazie	42.6928561	11.8163999	Madonna delle Grazie	Chiesa o edificio di culto	NaN	NaN	10800	t	1	75	\N	'chies':1 'graz':5 'madonn':3	'chies':1B 'graz':5B 'madonn':3B	0101000020E610000054EAED2AFFA12740C42A3982AF584540
540	40	Chiesa della Madonna del Piano	42.8933120	11.5380150	Madonna del Piano	Chiesa o edificio di culto	NaN	NaN	5400	t	1	11	\N	'chies':1 'madonn':3 'pian':5	'chies':1B 'madonn':3B 'pian':5B	0101000020E6100000CF83BBB376132740EB8F300C58724540
542	41	Convento di Sant'Antonio da Padova	42.1593028	12.1383489	Via Roma, 28	Chiesa o edificio di culto	NaN	NaN	9000	t	1	9	\N	'anton':4 'convent':1 'padov':6 'sant':3	'anton':4B 'convent':1B 'padov':6B 'sant':3B	0101000020E61000000AE0C1AAD5462840A314BE0864144540
543	41	Parco della Mola	42.0898778	12.2867656	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	3600	t	1	27	\N	'mol':3 'parc':1	'mol':3B 'parc':1B	0101000020E6100000533CD3F0D292284076D1A11D810B4540
545	41	La Faggeta Di Oriolo Romano	42.1613021	12.1520257	Via delle Cerase, 31	Parco o Giardino di interesse storico o artistico	NaN	NaN	7200	t	1	78	\N	'fagget':2 'oriol':4 'rom':5	'fagget':2B 'oriol':4B 'rom':5B	0101000020E6100000924D0350D64D28405823168CA5144540
546	41	Parrocchia San Giorgio Martire	42.1593028	12.1383489	Piazza Claudia, 10	Chiesa o edificio di culto	NaN	NaN	5400	t	1	62	\N	'giorg':3 'mart':4 'parrocc':1 'san':2	'giorg':3B 'mart':4B 'parrocc':1B 'san':2B	0101000020E61000000AE0C1AAD5462840A314BE0864144540
547	41	PALAZZO ALTIERI	41.8964245	12.4798454	PIAZZA UMBERTO PRIMO, 1	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	4	\N	'altier':2 'palazz':1	'altier':2B 'palazz':1B	0101000020E6100000A745D84BAEF52840A56ABB09BEF24440
549	41	Parco di Villa Altieri	42.1593028	12.1383489	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	9000	t	1	4	\N	'altier':4 'parc':1 'vill':3	'altier':4B 'parc':1B 'vill':3B	0101000020E61000000AE0C1AAD5462840A314BE0864144540
30	1	Palazzo Vescovile della Diocesi di Acquapendente	42.7439961	11.8649880	Via Roma, 85	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	56	\N	'acquapendent':6 'dioces':4 'palazz':1 'vescovil':2	'acquapendent':6B 'dioces':4B 'palazz':1B 'vescovil':2B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
31	1	Chiesa di S. Antonio Abate e S. Caterina	42.7439961	11.8649880	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	2	\N	'abat':5 'anton':4 'caterin':8 'chies':1 's':3,7	'abat':5B 'anton':4B 'caterin':8B 'chies':1B 's':3B,7B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
32	1	Palazzo Costantini	42.7439961	11.8649880	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	8	\N	'costantin':2 'palazz':1	'costantin':2B 'palazz':1B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
33	1	Anfiteatro Cordeschi	42.7633912	11.8703856	Strada Onanese	Monumento	NaN	NaN	10800	t	1	14	\N	'anfiteatr':1 'cordesc':2	'anfiteatr':1B 'cordesc':2B	0101000020E610000095D16D2EA3BD2740F00687CDB6614540
34	1	Palazzo Piccioni	42.7439961	11.8649880	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	21	\N	'palazz':1 'piccion':2	'palazz':1B 'piccion':2B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
550	41	Palazzo Altieri	42.1590238	12.1380751	Piazza Umberto I; 1	Museo, galleria e/o raccolta	699837145	-	5400	t	1	95	\N	'altier':2 'palazz':1	'altier':2B 'palazz':1B	0101000020E6100000ABC88DC7B1462840902452E45A144540
551	42	Palazzo Alberti	42.4605984	12.3856056	via Regina Margherita	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	31	\N	'albert':2 'palazz':1	'albert':2B 'palazz':1B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
552	42	Santuario della Santissima Trinità	42.4605984	12.3856056	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	3	\N	'santissim':3 'santuar':1 'trinit':4	'santissim':3B 'santuar':1B 'trinit':4B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
553	42	Palazzo Roberteschi	42.4605984	12.3856056	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	42	\N	'palazz':1 'robertesc':2	'palazz':1B 'robertesc':2B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
554	42	Chiesa di S. Agostino	42.4605984	12.3856056	Via Giordano Bruno, 11	Chiesa o edificio di culto	NaN	NaN	7200	t	1	68	\N	'agostin':4 'chies':1 's':3	'agostin':4B 'chies':1B 's':3B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
555	42	Museo archeologico di Orte	42.4605984	12.3856056	Via Gerolamo Savonarola - Orte	Museo, Galleria e/o raccolta	NaN	NaN	7200	t	1	1	\N	'archeolog':2 'muse':1 'orte':4	'archeolog':2B 'muse':1B 'orte':4B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
556	42	Chiesa di San Pietro	42.4605984	12.3856056	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	84	\N	'chies':1 'pietr':4 'san':3	'chies':1B 'pietr':4B 'san':3B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
557	42	Teatro Alberini	42.4722500	12.3845508	Via del Plebiscito	Architettura civile	NaN	NaN	7200	t	1	93	\N	'alberin':2 'teatr':1	'alberin':2B 'teatr':1B	0101000020E6100000204DABD7E3C428409CC420B0723C4540
559	42	Biblioteca comunale	42.4605984	12.3856056	Via Vittorio Emanuele 5	Biblioteca	NaN	NaN	3600	t	1	52	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
560	42	Biblioteca dell'Ente ottava medievale	42.2690694	11.9005853	Via Vittorio Emanuele 5	Biblioteca	+39 0761494948	NaN	9000	t	1	48	\N	'bibliotec':1 'ente':3 'medieval':5 'ottav':4	'bibliotec':1B 'ente':3B 'medieval':5B 'ottav':4B	0101000020E61000004684358419CD27405BADB8DD70224540
561	42	Biblioteca della Curia vescovile	42.4608660	12.3847945	Via Cavour 14	Biblioteca	NaN	NaN	9000	t	1	37	\N	'bibliotec':1 'cur':3 'vescovil':4	'bibliotec':1B 'cur':3B 'vescovil':4B	0101000020E6100000815CE2C803C528404FEB36A8FD3A4540
562	42	MUSEO DELLE CONFRATERNITE	42.4574411	12.3869837	PIAZZA DEL POPOLO; SNC	Museo, galleria e/o raccolta	3206280189	robertorondelli@confraterniteorte.it	5400	t	1	77	\N	'confratern':3 'muse':1	'confratern':3B 'muse':1B	0101000020E61000008F2B3FBA22C62840522C126E8D3A4540
563	42	Museo comunale di Orte	42.4605984	12.3856056	Via Pie' di Marmo - Orte	Museo, Galleria e/o raccolta	NaN	NaN	9000	t	1	3	\N	'comunal':2 'muse':1 'orte':4	'comunal':2B 'muse':1B 'orte':4B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
23	1	Monastero di S. Chiara	42.7439961	11.8649880	Via Malintoppa, 12	Chiesa o edificio di culto	NaN	NaN	5400	t	1	92	\N	'chiar':4 'monaster':1 's':3	'chiar':4B 'monaster':1B 's':3B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
565	42	Palazzo dell'Orologio	42.4605984	12.3856056	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	36	\N	'orolog':3 'palazz':1	'orolog':3B 'palazz':1B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
566	42	Museo diocesano	42.4600180	12.3863150	piazza Colonna; 5	Museo, galleria e/o raccolta	0761 404357	museodartesacraorte@gmail.com	10800	t	1	21	\N	'dioces':2 'muse':1	'dioces':2B 'muse':1B	0101000020E610000092E86514CBC5284021C9ACDEE13A4540
567	42	Palazzo Primavera e Magnaterra	42.4605984	12.3856056	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	55	\N	'magnaterr':4 'palazz':1 'primaver':2	'magnaterr':4B 'palazz':1B 'primaver':2B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
39	1	Castello Cahen (o Castello di Torre Alfina)	42.7439961	11.8649880	Via Monaldeschi della Cervara, 1, Fraz. Torre Alfina	Architettura fortificata	NaN	NaN	10800	t	1	88	\N	'alfin':7 'cahen':2 'castell':1,4 'torr':6	'alfin':7B 'cahen':2B 'castell':1B,4B 'torr':6B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
570	42	Chiesa di Santa Maria delle Grazie	42.4605984	12.3856056	Via le Grazie, 111	Chiesa o edificio di culto	NaN	NaN	7200	t	1	35	\N	'chies':1 'graz':6 'mar':4 'sant':3	'chies':1B 'graz':6B 'mar':4B 'sant':3B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
571	42	Torre S. Masseo	42.4605984	12.3856056	S. Masseo	Architettura fortificata	NaN	NaN	5400	t	1	24	\N	'masse':3 's':2 'torr':1	'masse':3B 's':2B 'torr':1B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
572	42	Chiesa di S. Antonio	42.3721886	12.8454886	Via Giuseppe Garibaldi, 221	Chiesa o edificio di culto	NaN	NaN	3600	t	1	91	\N	'anton':4 'chies':1 's':3	'anton':4B 'chies':1B 's':3B	0101000020E61000001A48BCE1E3B02940D67844E0A32F4540
573	42	Chiesa di Santa Maria di Loreto	42.4605984	12.3856056	Castel Bagnolo	Chiesa o edificio di culto	NaN	NaN	9000	t	1	95	\N	'chies':1 'loret':6 'mar':4 'sant':3	'chies':1B 'loret':6B 'mar':4B 'sant':3B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
574	42	Palazzo Squarti	42.4605984	12.3856056	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	28	\N	'palazz':1 'squart':2	'palazz':1B 'squart':2B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
575	42	Palazzo della Cassa di Risparmio (Sabatini)	42.4605984	12.3856056	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	48	\N	'cass':3 'palazz':1 'risparm':5 'sabatin':6	'cass':3B 'palazz':1B 'risparm':5B 'sabatin':6B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
576	42	Museo civico	42.4605279	12.3870936	via Pie' di marmo	Museo, galleria e/o raccolta	0761 4041	info@comune.orte.vt.it	10800	t	1	81	\N	'civic':2 'muse':1	'civic':2B 'muse':1B	0101000020E610000058FBE02131C62840A2B20694F23A4540
577	42	Chiesa di San Francesco	42.4605984	12.3856056	81 Piazza Senatore Manni	Chiesa o edificio di culto	NaN	NaN	9000	t	1	44	\N	'chies':1 'francesc':4 'san':3	'chies':1B 'francesc':4B 'san':3B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
650	49	Museo del patrimonium	42.2409277	12.2245800	Via di Porta Vecchia - Sutri	Museo, Galleria e/o raccolta	NaN	NaN	3600	t	1	65	\N	'muse':1 'patrimonium':3	'muse':1B 'patrimonium':3B	0101000020E6100000DEAB5626FC722840AA1908B8D61E4540
578	42	Chiesa Cattedrale di S. Maria Assunta	42.4605984	12.3856056	Via Giulio Roscio, 10	Chiesa o edificio di culto	NaN	NaN	9000	t	1	94	\N	'assunt':6 'cattedral':2 'chies':1 'mar':5 's':4	'assunt':6B 'cattedral':2B 'chies':1B 'mar':5B 's':4B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
24	1	MUSEO DELLA CITTA' CIVICO E DIOCESANO DI ACQUAPENDENTE	42.7439961	11.8649880	VIA ROMA, 85	Museo, galleria e/o raccolta	NaN	NaN	5400	t	1	10	\N	'acquapendent':8 'citt':3 'civic':4 'dioces':6 'muse':1	'acquapendent':8B 'citt':3B 'civic':4B 'dioces':6B 'muse':1B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
25	1	Bosco monumentale del Sasseto e i giardini Cahen d’Anvers di Torre Alfina	42.7439961	11.8649880	piazzale Sant'Angelo - Acquapendente	Parco o Giardino di interesse storico o artistico	NaN	NaN	5400	t	1	88	\N	'alfin':13 'anvers':10 'bosc':1 'cahen':8 'd':9 'giardin':7 'monumental':2 'sasset':4 'torr':12	'alfin':13B 'anvers':10B 'bosc':1B 'cahen':8B 'd':9B 'giardin':7B 'monumental':2B 'sasset':4B 'torr':12B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
584	42	MUSEO D'ARTE SACRA DI ORTE DI IMPORTANZA DIOCESANA	42.4605984	12.3856056	VIA GIULIO ROSCIO, 10	Museo, Galleria e/o raccolta	NaN	NaN	5400	t	1	48	\N	'arte':3 'd':2 'diocesan':9 'import':8 'muse':1 'orte':6 'sacr':4	'arte':3B 'd':2B 'diocesan':9B 'import':8B 'muse':1B 'orte':6B 'sacr':4B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
585	42	Chiesa di San Silvestro	42.4605984	12.3856056	Via G. Matteotti, 781	Chiesa o edificio di culto	NaN	NaN	9000	t	1	47	\N	'chies':1 'san':3 'silvestr':4	'chies':1B 'san':3B 'silvestr':4B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
586	42	Centro Storico di Orte	42.4599890	12.3862190	NaN	Architettura fortificata	NaN	NaN	5400	t	1	22	\N	'centr':1 'orte':4 'storic':2	'centr':1B 'orte':4B 'storic':2B	0101000020E61000000A302C7FBEC5284087C267EBE03A4540
598	44	Chiesa di S. Martino	42.7571602	11.8302614	Corso Regina Margherita, 21	Chiesa o edificio di culto	NaN	NaN	5400	t	1	9	\N	'chies':1 'martin':4 's':3	'chies':1B 'martin':4B 's':3B	0101000020E61000002943B00518A927409A6A1CA0EA604540
599	44	Chiesa di S. Maria della Neve	42.7571602	11.8302614	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	29	\N	'chies':1 'mar':4 'nev':6 's':3	'chies':1B 'mar':4B 'nev':6B 's':3B	0101000020E61000002943B00518A927409A6A1CA0EA604540
26	1	Biblioteca dell'ex Seminario vescovile	42.7426527	11.8689048	Via Roma, 85	Biblioteca	+39 0761.325584	cedi.do@libero.it	3600	t	1	72	\N	'bibliotec':1 'ex':3 'seminar':4 'vescovil':5	'bibliotec':1B 'ex':3B 'seminar':4B 'vescovil':5B	0101000020E6100000C2AC0617E1BC27409F64613E0F5F4540
22	1	Casale Tirolle	42.7439961	11.8649880	Tirolle	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	25	\N	'casal':1 'tiroll':2	'casal':1B 'tiroll':2B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
465	35	Vulci	42.3558920	11.5922396	NaN	Area o parco archeologico	NaN	NaN	9000	t	1	89	\N	'vulc':1	'vulc':1B	0101000020E6100000D0CA62073A2F27403A747ADE8D2D4540
564	42	Acquedotto Rinascimentale	42.1335903	12.0793680	NaN	Area o parco archeologico	NaN	NaN	3600	t	1	78	\N	'acquedott':1 'rinascimental':2	'acquedott':1B 'rinascimental':2B	0101000020E6100000A7B228ECA22828400BC8A87C19114540
393	30	Palazzo Iuzzi	42.6745290	11.8722530	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	40	\N	'iuzz':2 'palazz':1	'iuzz':2B 'palazz':1B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
27	1	Convento dei Padri Cappuccini e chiesa di S. Francesco d' Assisi	42.7439961	11.8649880	Via Cesare Battisti	Chiesa o edificio di culto	NaN	NaN	9000	t	1	17	\N	'assis':11 'cappuccin':4 'chies':6 'convent':1 'd':10 'francesc':9 'padr':3 's':8	'assis':11B 'cappuccin':4B 'chies':6B 'convent':1B 'd':10B 'francesc':9B 'padr':3B 's':8B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
601	45	Chiesa di Santa Maria della Provvidenza	42.2902415	12.2138064	Via Borgo di Sopra, 71	Chiesa o edificio di culto	NaN	NaN	10800	t	1	9	\N	'chies':1 'mar':4 'provvident':6 'sant':3	'chies':1B 'mar':4B 'provvident':6B 'sant':3B	0101000020E6100000DA594F08786D284093382BA226254540
602	45	Fontana degli Unicorni	42.2902415	12.2138064	Piazza Principe di Napoli, 18	Monumento	NaN	NaN	10800	t	1	82	\N	'fontan':1 'unicorn':3	'fontan':1B 'unicorn':3B	0101000020E6100000DA594F08786D284093382BA226254540
603	45	Chiesa di Santa Maria della Pace e Sant’ Andrea	42.2902415	12.2138064	Via Cassia Cimina, 2	Chiesa o edificio di culto	NaN	NaN	7200	t	1	43	\N	'andre':9 'chies':1 'mar':4 'pac':6 'sant':3,8	'andre':9B 'chies':1B 'mar':4B 'pac':6B 'sant':3B,8B	0101000020E6100000DA594F08786D284093382BA226254540
501	37	Palazzo Codini	42.5379248	12.0309974	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	16	\N	'codin':2 'palazz':1	'codin':2B 'palazz':1B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
606	45	Ponte Ferroviario di Ronciglione	42.2868520	12.2158080	Via Roma	Architettura civile	NaN	NaN	9000	t	1	0	\N	'ferroviar':2 'pont':1 'ronciglion':4	'ferroviar':2B 'pont':1B 'ronciglion':4B	0101000020E61000002B6EDC627E6E28406765FB90B7244540
3	1	Chiesa della Madonna della Quercia	42.7439961	11.8649880	SP51, Trevinano	Chiesa o edificio di culto	NaN	NaN	7200	t	1	23	\N	'chies':1 'madonn':3 'querc':5	'chies':1B 'madonn':3B 'querc':5B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
5	1	Mura urbiche di Acquapendente	42.7439961	11.8649880	NaN	Architettura fortificata	NaN	NaN	10800	t	1	92	\N	'acquapendent':4 'mur':1 'urbic':2	'acquapendent':4B 'mur':1B 'urbic':2B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
304	21	Chiesa della Madonna delle Grazie	42.6053622	12.1876584	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	38	Il santuario della Madonna delle Grazie sorge alle spalle della chiesa parrocchiale dei SS. Pietro e Callisto e in aderenza alle antiche Mura cittadine.\nProspetta con il suo lato sud su di un piccolo vicolo, realizzato a seguito dell’edificazione della chiesa e collegato con piazza dell’Unità d’Italia; a nord confina con via di Porta Vecchia, che corre ad una quota molto più bassa, ad ovest, tramite la sacrestia e un ambiente di servizio, con le Mura, mentre ad est in parte con la chiesa parrocchiale.\nL’impianto, disposto in direzione da sud a nord, è ad aula rettangolare con angoli smussati. Le pareti, inoltre, sono articolate da rincassi poco profondi e di pari ampiezza, sia sull’asse longitudinale, sia su quello trasversale: all’ estremità sud vi è ospitato l’antico ingresso principale, oggi non più agibile, preceduto da tre gradini e sormontato dalla cantoria lignea; a nord è invece collocato l’altare maggiore; mentre ai due lati si ergono simmetricamente due altari minori.\nL’attuale accesso alla chiesa avviene sul lato est tramite una porta preceduta da una breve rampa inclinata, posta al lato del vicolo.\nInternamente l’aula è scandita da un ordine architettonico su paraste tuscaniche, la cui trabeazione s’interrompe nei quattro rincassi, in corrispondenza dei quali s’innalzano archi a tutto sesto. La volta a padiglione a copertura dell’ambiente è articolata pertanto dalle unghie delle lunette lungo i due assi.\nIl presbiterio è separato dall’aula tramite una balaustra in legno; l’altare si erge contro la parete di fondo, rialzato di un gradino e formato da un frontespizio con colonne corinzie binate su piedistalli, che sorreggono un timpano curvo spezzato, al centro del quale si apre una finestra ovale circondata da cherubini.\nAi lati ricurvi del presbiterio si aprono due porte: quella di sinistra conduce alla sagrestia, mentre quella di destra è murata e coperta da una tenda.\nGli altari secondari, aggettanti nell’aula e rialzati di un gradino, sono arricchiti anch’essi da frontespizi su colonne corinzie.\nLa cantoria è sorretta da due pilastri quadrati, ed è accessibile tramite una scala situata nell’ambiente di servizio ad ovest della chiesa, al quale si accede tramite una porta posta nel tratto curvo dell’aula.\nLa chiesa è illuminata da una finestra rettangolare posta in controfacciata, dalla finestra ovale del presbiterio e da una grande finestra rettangolare posta al di sopra dell’altare secondario di sinistra, mentre la corrispondente è dipinta.\nLe superfici interne si presentano riccamente decorate con marmi, finti marmi e pitture; l’intera volta è affrescata con una finta architettura.\nIl tetto dell’aula è a padiglione, mentre gli ambienti collaterali ad ovest hanno coperture più basse ad unico spiovente.\nLa facciata è priva di articolazioni, semplicemente intonacata e si conclude orizzontalmente con lo sporto del tetto; perpendicolarmente ad essa si erge un campaniletto a vela, in linea con il lato ovest dell’aula. In asse al prospetto si trova l’antico ingresso alla chiesa (oggi obliterato e soprelevato rispetto alla quota del vicolo), di forma rettangolare, con cornice in peperino. Più in alto si apre la finestra rettangolare priva d’incorniciatura.\nIl breve tratto di prospetto laterale sulla destra, anch’esso intonacato, ospita l’attuale ingresso con portale analogo a quello originario.	'acced':368 'access':173,352 'aderent':24 'affresc':431 'aggett':325 'agibil':143 'altar':159,169,255,323,405 'alto':519 'ambient':78,231,358,445 'ampiezz':121 'analog':545 'anch':335,536 'angol':107 'antic':26,137,497 'apre':289,521 'apron':302 'archi':220 'architetton':202 'architettur':435 'arricc':334 'articol':113,233,461 'asse':124,491 'assi':242 'attual':172,541 'aul':104,196,248,327,377,439,489 'avvien':176 'balaustr':251 'bass':70,452 'bin':275 'brev':186,529 'callist':21 'campanilett':479 'cantor':151,343 'centr':285 'cherubin':295 'chies':1,15,46,91,175,364,379,500 'circond':293 'cittadin':28 'collateral':446 'colleg':48 'colloc':157 'colonn':273,340 'conclud':466 'conduc':308 'confin':57 'controfacc':388 'copert':318 'copertur':229,450 'corinz':274,341 'cornic':514 'corr':64 'corrispondent':215,411 'curv':282,375 'd':53,526 'decor':420 'destr':314,535 'dipint':413 'direzion':97 'dispost':95 'due':163,168,241,303,347 'edif':44 'erge':257,477 'ergon':166 'essa':475 'essi':336 'esso':537 'est':86,179 'estrem':131 'facc':457 'finestr':291,384,390,398,523 'fint':423,434 'fond':262 'form':268,511 'frontespiz':271,338 'gradin':147,266,332 'grand':397 'graz':10 'grazieil':5 'illumin':381 'impiant':94 'inclin':188 'incorniciatur':527 'ingress':138,498,542 'innalz':219 'inoltr':111 'inter':428 'intern':194,416 'interromp':210 'intonac':463,538 'invec':156 'ital':54 'lat':33,164,178,191,297,486 'lateral':533 'legn':253 'ligne':152 'line':483 'longitudinal':125 'lunett':238 'lung':239 'madonn':3,8 'maggior':160 'marm':422,424 'mentr':84,161,311,409,443 'minor':170 'molt':68 'mur':27,83,316 'nord':56,101,154 'obliter':502 'oggi':140,501 'ordin':201 'originar':548 'orizzontal':467 'ospit':135,539 'oval':292,391 'ovest':72,362,448,487 'padiglion':227,442 'par':120,260 'parast':204 'paret':110 'parrocchial':16,92 'part':88 'peperin':516 'perpendicolar':473 'pertant':234 'piazz':50 'piccol':38 'piedistall':277 'pietr':19 'pilastr':348 'pittur':426 'poc':116 'port':61,182,304,371 'portal':544 'post':189,372,386,400 'preced':144,183 'presbiter':244,300,393 'present':418 'principal':139 'priv':459,525 'profond':117 'prospett':29,493,532 'quadr':349 'qual':217 'quattr':212 'quot':67,507 'ramp':187 'realizz':40 'rettangol':105,385,399,512,524 'rialz':263,329 'ricc':419 'ricurv':298 'rinc':115,213 'rispett':505 's':209,218 'sacrest':75 'sagrest':310 'santuar':6 'scal':355 'scand':198 'secondar':324,406 'segu':42 'semplic':462 'separ':246 'serviz':80,360 'sest':223 'simmetr':167 'sinistr':307,408 'situ':356 'smuss':108 'sopr':403 'soprelev':504 'sorg':11 'sormont':149 'sorregg':279 'sorrett':345 'spall':13 'spezz':283 'spiovent':455 'sport':470 'ss':18 'sud':34,99,132 'superf':415 'tend':321 'tett':437,472 'timp':281 'trabeazion':208 'tram':73,180,249,353,369 'trasversal':129 'tratt':374,530 'tre':146 'trov':495 'tuscan':205 'unghi':236 'unic':454 'unit':52 'vecc':62 'vel':481 'via':59 'vicol':39,193,509 'volt':225,429	'acced':369A 'access':174A,353A 'aderent':25A 'affresc':432A 'aggett':326A 'agibil':144A 'altar':160A,170A,256A,324A,406A 'alto':520A 'ambient':79A,232A,359A,446A 'ampiezz':122A 'analog':546A 'anch':336A,537A 'angol':108A 'antic':27A,138A,498A 'apre':290A,522A 'apron':303A 'archi':221A 'architetton':203A 'architettur':436A 'arricc':335A 'articol':114A,234A,462A 'asse':125A,492A 'assi':243A 'attual':173A,542A 'aul':105A,197A,249A,328A,378A,440A,490A 'avvien':177A 'balaustr':252A 'bass':71A,453A 'bin':276A 'brev':187A,530A 'callist':22A 'campanilett':480A 'cantor':152A,344A 'centr':286A 'cherubin':296A 'chies':1B,16A,47A,92A,176A,365A,380A,501A 'circond':294A 'cittadin':29A 'collateral':447A 'colleg':49A 'colloc':158A 'colonn':274A,341A 'conclud':467A 'conduc':309A 'confin':58A 'controfacc':389A 'copert':319A 'copertur':230A,451A 'corinz':275A,342A 'cornic':515A 'corr':65A 'corrispondent':216A,412A 'curv':283A,376A 'd':54A,527A 'decor':421A 'destr':315A,536A 'dipint':414A 'direzion':98A 'dispost':96A 'due':164A,169A,242A,304A,348A 'edif':45A 'erge':258A,478A 'ergon':167A 'essa':476A 'essi':337A 'esso':538A 'est':87A,180A 'estrem':132A 'facc':458A 'finestr':292A,385A,391A,399A,524A 'fint':424A,435A 'fond':263A 'form':269A,512A 'frontespiz':272A,339A 'gradin':148A,267A,333A 'grand':398A 'graz':5B,11A 'illumin':382A 'impiant':95A 'inclin':189A 'incorniciatur':528A 'ingress':139A,499A,543A 'innalz':220A 'inoltr':112A 'inter':429A 'intern':195A,417A 'interromp':211A 'intonac':464A,539A 'invec':157A 'ital':55A 'lat':34A,165A,179A,192A,298A,487A 'lateral':534A 'legn':254A 'ligne':153A 'line':484A 'longitudinal':126A 'lunett':239A 'lung':240A 'madonn':3B,9A 'maggior':161A 'marm':423A,425A 'mentr':85A,162A,312A,410A,444A 'minor':171A 'molt':69A 'mur':28A,84A,317A 'nord':57A,102A,155A 'obliter':503A 'oggi':141A,502A 'ordin':202A 'originar':549A 'orizzontal':468A 'ospit':136A,540A 'oval':293A,392A 'ovest':73A,363A,449A,488A 'padiglion':228A,443A 'par':121A,261A 'parast':205A 'paret':111A 'parrocchial':17A,93A 'part':89A 'peperin':517A 'perpendicolar':474A 'pertant':235A 'piazz':51A 'piccol':39A 'piedistall':278A 'pietr':20A 'pilastr':349A 'pittur':427A 'poc':117A 'port':62A,183A,305A,372A 'portal':545A 'post':190A,373A,387A,401A 'preced':145A,184A 'presbiter':245A,301A,394A 'present':419A 'principal':140A 'priv':460A,526A 'profond':118A 'prospett':30A,494A,533A 'quadr':350A 'qual':218A 'quattr':213A 'quot':68A,508A 'ramp':188A 'realizz':41A 'rettangol':106A,386A,400A,513A,525A 'rialz':264A,330A 'ricc':420A 'ricurv':299A 'rinc':116A,214A 'rispett':506A 's':210A,219A 'sacrest':76A 'sagrest':311A 'santuar':7A 'scal':356A 'scand':199A 'secondar':325A,407A 'segu':43A 'semplic':463A 'separ':247A 'serviz':81A,361A 'sest':224A 'simmetr':168A 'sinistr':308A,409A 'situ':357A 'smuss':109A 'sopr':404A 'soprelev':505A 'sorg':12A 'sormont':150A 'sorregg':280A 'sorrett':346A 'spall':14A 'spezz':284A 'spiovent':456A 'sport':471A 'ss':19A 'sud':35A,100A,133A 'superf':416A 'tend':322A 'tett':438A,473A 'timp':282A 'trabeazion':209A 'tram':74A,181A,250A,354A,370A 'trasversal':130A 'tratt':375A,531A 'tre':147A 'trov':496A 'tuscan':206A 'unghi':237A 'unic':455A 'unit':53A 'vecc':63A 'vel':482A 'via':60A 'vicol':40A,194A,510A 'volt':226A,430A	0101000020E6100000AEA305C314602840089E31827C4D4540
638	48	Complesso architettonico e paesaggisticoTorre di Chia	42.4187606	12.2343075	Strada Provinciale 151 Ortana	Area o parco archeologico	NaN	NaN	10800	t	1	41	\N	'architetton':2 'chi':6 'compless':1 'paesaggisticotorr':4	'architetton':2B 'chi':6B 'compless':1B 'paesaggisticotorr':4B	0101000020E6100000406A1327F77728403AED84F299354540
641	48	Chiesa di San Nicola di Bari	42.4187606	12.2343075	Piazza Vittorio Emanuele II 26	Chiesa o edificio di culto	NaN	NaN	7200	t	1	70	\N	'bar':6 'chies':1 'nicol':4 'san':3	'bar':6B 'chies':1B 'nicol':4B 'san':3B	0101000020E6100000406A1327F77728403AED84F299354540
642	49	Chiesa di San Francesco	42.2470230	12.2150670	Piazza S. Francesco	Chiesa o edificio di culto	NaN	NaN	3600	t	1	17	\N	'chies':1 'francesc':4 'san':3	'chies':1B 'francesc':4B 'san':3B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
643	49	Chiesa di Santa Maria del Monte	42.2470230	12.2150670	SR2	Chiesa o edificio di culto	NaN	NaN	7200	t	1	37	\N	'chies':1 'mar':4 'mont':6 'sant':3	'chies':1B 'mar':4B 'mont':6B 'sant':3B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
644	49	Porta Morone	42.2428103	12.2218014	Via Giuseppe Garibaldi	Architettura fortificata	NaN	NaN	10800	t	1	34	\N	'moron':2 'port':1	'moron':2B 'port':1B	0101000020E6100000FE69FEF38F712840E4D06C68141F4540
645	49	Chiesa Madonna del Parto	42.2470230	12.2150670	Piazza Sacello, 39	Chiesa o edificio di culto	NaN	NaN	10800	t	1	90	\N	'chies':1 'madonn':2 'part':4	'chies':1B 'madonn':2B 'part':4B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
646	49	Chiesa di Santa Croce	42.2470230	12.2150670	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	60	\N	'chies':1 'croc':4 'sant':3	'chies':1B 'croc':4B 'sant':3B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
647	49	Piazza Del Comune	42.2470230	12.2150670	NaN	Monumento	NaN	NaN	9000	t	1	51	\N	'comun':3 'piazz':1	'comun':3B 'piazz':1B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
648	49	Saturno a Cavallo	42.2470230	12.2150670	NaN	Monumento	NaN	NaN	3600	t	1	60	\N	'cavall':3 'saturn':1	'cavall':3B 'saturn':1B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
649	49	Sentiero Natura Il Grande Leccio	42.2470230	12.2150670	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	9000	t	1	61	\N	'grand':4 'lecc':5 'natur':2 'sentier':1	'grand':4B 'lecc':5B 'natur':2B 'sentier':1B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
651	49	Chiesa di San Rocco	42.2470230	12.2150670	Via Tauro Statilio, 11	Chiesa o edificio di culto	NaN	NaN	10800	t	1	40	\N	'chies':1 'rocc':4 'san':3	'chies':1B 'rocc':4B 'san':3B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
136	7	AREA DEL FORO E DOMUS PRIVATAE DELLA CITTA' ROMANA DI VOLSINII	42.6441069	11.9849554	VIA ORVIETANA, snc	Area o parco archeologico	NaN	NaN	7200	t	1	23	\N	'are':1 'citt':8 'domus':5 'for':3 'privata':6 'roman':9 'volsin':11	'are':1B 'citt':8B 'domus':5B 'for':3B 'privata':6B 'roman':9B 'volsin':11B	0101000020E61000008609FE124CF8274060504B1872524540
137	7	Basilica di Santa Cristina e Catacomba del Santuario Eucaristico	42.6441069	11.9849554	Via Giuseppe Mazzini - Bolsena	Chiesa o edificio di culto	NaN	NaN	9000	t	1	84	\N	'basil':1 'catacomb':6 'cristin':4 'eucarist':9 'sant':3 'santuar':8	'basil':1B 'catacomb':6B 'cristin':4B 'eucarist':9B 'sant':3B 'santuar':8B	0101000020E61000008609FE124CF8274060504B1872524540
44	1	Chiesa di S. Maria Assunta	42.7439961	11.8649880	Piazza S. Maria	Chiesa o edificio di culto	NaN	NaN	9000	t	1	82	\N	'assunt':5 'chies':1 'mar':4 's':3	'assunt':5B 'chies':1B 'mar':4B 's':3B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
531	39	Acquedotto di Nepi	42.2440210	12.3444280	Piazzale della Bottata, 19	Area o parco archeologico	NaN	NaN	7200	t	1	65	\N	'acquedott':1 'nep':3	'acquedott':1B 'nep':3B	0101000020E610000044A7E7DD58B02840C34483143C1F4540
45	1	Cattedrale del S. Sepolcro	42.7425120	11.8714670	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	60	\N	'cattedral':1 's':3 'sepolcr':4	'cattedral':1B 's':3B 'sepolcr':4B	0101000020E6100000231631EC30BE27409B711AA20A5F4540
46	1	Palazzo Taurelli-Salimbeni	42.7439961	11.8649880	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	12	\N	'palazz':1 'salimben':4 'taurell':3 'taurelli-salimben':2	'palazz':1B 'salimben':4B 'taurell':3B 'taurelli-salimben':2B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
242	17	Piazza Maggiore	42.6449715	12.2038975	NaN	Monumento	NaN	NaN	5400	t	1	61	\N	'maggior':2 'piazz':1	'maggior':2B 'piazz':1B	0101000020E6100000EA78CC406568284010AD156D8E524540
40	1	Palazzo Cozza-Nardelli	42.7439961	11.8649880	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	54	\N	'cozz':3 'cozza-nardell':2 'nardell':4 'palazz':1	'cozz':3B 'cozza-nardell':2B 'nardell':4B 'palazz':1B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
654	49	Cappella di Santa Maria del Tempio o Cappella dei Cavalieri di Malta	42.2470230	12.2150670	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	25	\N	'cappell':1,8 'cavalier':10 'malt':12 'mar':4 'sant':3 'temp':6	'cappell':1B,8B 'cavalier':10B 'malt':12B 'mar':4B 'sant':3B 'temp':6B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
655	49	Chiesa della Santissima Concezione	42.2470230	12.2150670	Via Giuseppe Garibaldi, 1	Chiesa o edificio di culto	NaN	NaN	9000	t	1	26	\N	'chies':1 'concezion':4 'santissim':3	'chies':1B 'concezion':4B 'santissim':3B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
658	49	Museo Palazzo Doebbing	42.1016550	12.1736760	Piazza Del Duomo	Museo, Galleria e/o raccolta	NaN	NaN	9000	t	1	42	\N	'doebbing':3 'muse':1 'palazz':2	'doebbing':3B 'muse':1B 'palazz':2B	0101000020E61000004033880FEC582840C93CF207030D4540
663	49	Area archeologica di Sutri	42.2470230	12.2150670	via Cassia km 50,00 - Sutri	Area o parco archeologico	NaN	NaN	5400	t	1	22	\N	'archeolog':2 'are':1 'sutr':4	'archeolog':2B 'are':1B 'sutr':4B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
664	49	Atrio Comunale	42.2470230	12.2150670	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	77	\N	'atri':1 'comunal':2	'atri':1B 'comunal':2B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
665	49	Porta Franceta	42.2470230	12.2150670	NaN	Architettura fortificata	NaN	NaN	5400	t	1	78	\N	'francet':2 'port':1	'francet':2B 'port':1B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
666	49	Villa Savorelli	42.2393174	12.2269327	SR2	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	37	\N	'savorell':2 'vill':1	'savorell':2B 'vill':1B	0101000020E610000035C9D985307428408F2EDBF3A11E4540
667	49	Castello detto di Carlo Magno	42.2470230	12.2150670	Colle Savorelli	Architettura fortificata	NaN	NaN	3600	t	1	55	\N	'carl':4 'castell':1 'dett':2 'magn':5	'carl':4B 'castell':1B 'dett':2B 'magn':5B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
668	49	Antico Lavatoio	42.2470230	12.2150670	Piazza Dell'Assemblea, 9	Monumento	NaN	NaN	3600	t	1	31	\N	'antic':1 'lavatoi':2	'antic':1B 'lavatoi':2B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
669	49	Chiesa di San Silvestro Papa	42.2470230	12.2150670	Piazza della Rocca	Chiesa o edificio di culto	NaN	NaN	5400	t	1	30	\N	'chies':1 'pap':5 'san':3 'silvestr':4	'chies':1B 'pap':5B 'san':3B 'silvestr':4B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
670	49	Anfiteatro Romano	42.2439027	12.2185381	Via Cassia; Km 49	Museo, galleria e/o raccolta	-	-	7200	t	1	74	\N	'anfiteatr':1 'rom':2	'anfiteatr':1B 'rom':2B	0101000020E610000026DCD039E46F2840FBF32334381F4540
671	49	Concattedrale di S. Maria Assunta in Cielo	42.2470230	12.2150670	Piazza Del Duomo, 1	Chiesa o edificio di culto	NaN	NaN	9000	t	1	45	\N	'assunt':5 'ciel':7 'concattedral':1 'mar':4 's':3	'assunt':5B 'ciel':7B 'concattedral':1B 'mar':4B 's':3B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
672	50	Biblioteca comunale Dante Alighieri	42.2524377	11.7557965	Via Umberto I  5	Biblioteca	+39 0766849224	comunetarquinia@tarquinia.net	9000	t	1	99	\N	'alighier':4 'bibliotec':1 'comunal':2 'dant':3	'alighier':4B 'bibliotec':1B 'comunal':2B 'dant':3B	0101000020E6100000CFDC43C2F782274084E3E8E04F204540
673	50	Chiesa e Convento di San Francesco	42.2532394	11.7591747	Via di Porta Tarquinia, 24	Chiesa o edificio di culto	NaN	NaN	9000	t	1	64	\N	'chies':1 'convent':3 'francesc':6 'san':5	'chies':1B 'convent':3B 'francesc':6B 'san':5B	0101000020E6100000B7E6D88BB284274082870E266A204540
139	8	Torre (presso chiesa di S. Vincenzo)	42.4819280	12.2487640	Mugnano in Teverina	Architettura fortificata	NaN	NaN	9000	t	1	47	\N	'chies':3 'press':2 's':5 'torr':1 'vincenz':6	'chies':3B 'press':2B 's':5B 'torr':1B 'vincenz':6B	0101000020E610000023D8B8FE5D7F28406B8313D1AF3D4540
140	8	Chiesa della Misericordia	42.4819280	12.2487640	Mugnano in Teverina	Chiesa o edificio di culto	NaN	NaN	5400	t	1	17	\N	'chies':1 'misericord':3	'chies':1B 'misericord':3B	0101000020E610000023D8B8FE5D7F28406B8313D1AF3D4540
141	8	Torre del Mugnano	42.4819280	12.2487640	Mugnano in Teverina	Architettura fortificata	NaN	NaN	10800	t	1	16	\N	'mugn':3 'torr':1	'mugn':3B 'torr':1B	0101000020E610000023D8B8FE5D7F28406B8313D1AF3D4540
676	50	Impianto delle Saline	42.2532394	11.7591747	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	7200	t	1	50	\N	'impiant':1 'salin':3	'impiant':1B 'salin':3B	0101000020E6100000B7E6D88BB284274082870E266A204540
677	50	Porto Clementino	42.2125967	11.7106350	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	5400	t	1	89	\N	'clementin':2 'port':1	'clementin':2B 'port':1B	0101000020E610000032C9C859D86B274067DE605E361B4540
678	50	Fontana monumentale	42.2532394	11.7591747	NaN	Monumento	NaN	NaN	9000	t	1	100	\N	'fontan':1 'monumental':2	'fontan':1B 'monumental':2B	0101000020E6100000B7E6D88BB284274082870E266A204540
47	1	Chiesa di S. Lorenzo Martire e S. Michele Arcangelo	42.7439961	11.8649880	Via G. Marconi, 85	Chiesa o edificio di culto	NaN	NaN	3600	t	1	30	\N	'arcangel':9 'chies':1 'lorenz':4 'mart':5 'michel':8 's':3,7	'arcangel':9B 'chies':1B 'lorenz':4B 'mart':5B 'michel':8B 's':3B,7B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
51	2	Chiesa di S. Donato	42.6269800	12.0908718	Piazza S. Donato	Chiesa o edificio di culto	NaN	NaN	7200	t	1	93	\N	'chies':1 'don':4 's':3	'chies':1B 'don':4B 's':3B	0101000020E6100000DF41A2BF862E2840809F71E140504540
532	39	Rocca dei Borgia (o Castello Borgiano)	42.2417390	12.3456400	Via Enrico Galvaligi	Architettura fortificata	NaN	NaN	5400	t	1	83	\N	'borg':3,6 'castell':5 'rocc':1	'borg':3B,6B 'castell':5B 'rocc':1B	0101000020E6100000FE60E0B9F7B028407995B54DF11E4540
52	2	Chiesa della Madonna del Carmine	42.6269800	12.0908718	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	63	\N	'carmin':5 'chies':1 'madonn':3	'carmin':5B 'chies':1B 'madonn':3B	0101000020E6100000DF41A2BF862E2840809F71E140504540
49	2	Palazzo Comunale	42.6269800	12.0908718	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	96	\N	'comunal':2 'palazz':1	'comunal':2B 'palazz':1B	0101000020E6100000DF41A2BF862E2840809F71E140504540
53	2	Palazzo Antiseri	42.6269800	12.0908718	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	86	\N	'antiser':2 'palazz':1	'antiser':2B 'palazz':1B	0101000020E6100000DF41A2BF862E2840809F71E140504540
533	39	Chiesa di San Tolomeo	42.2421242	12.3533679	Via Garibaldi, 165	Chiesa o edificio di culto	NaN	NaN	10800	t	1	63	\N	'chies':1 'san':3 'tolome':4	'chies':1B 'san':3B 'tolome':4B	0101000020E610000093E92BA3ECB42840FB4800EDFD1E4540
679	50	Torre del Seminario e Casa Medievale	42.2532394	11.7591747	via di Porta Castello   1-5	Architettura fortificata	NaN	NaN	3600	t	1	58	\N	'cas':5 'medieval':6 'seminar':3 'torr':1	'cas':5B 'medieval':6B 'seminar':3B 'torr':1B	0101000020E6100000B7E6D88BB284274082870E266A204540
681	50	Torre di S. Spirito	42.2532394	11.7591747	via delle Torri,55	Architettura fortificata	NaN	NaN	7200	t	1	17	\N	's':3 'spir':4 'torr':1	's':3B 'spir':4B 'torr':1B	0101000020E6100000B7E6D88BB284274082870E266A204540
682	50	MUSEO DELLA CERAMICA D'USO A CORNETO - SOC.TARQUINIENSE, ARTE E STORIA	42.2532394	11.7591747	VIA DELLE TORRI, 31	Museo, galleria e/o raccolta	NaN	NaN	5400	t	1	33	\N	'arte':9 'ceram':3 'cornet':7 'd':4 'muse':1 'soc.tarquiniense':8 'stor':11 'uso':5	'arte':9B 'ceram':3B 'cornet':7B 'd':4B 'muse':1B 'soc.tarquiniense':8B 'stor':11B 'uso':5B	0101000020E6100000B7E6D88BB284274082870E266A204540
683	50	Biblioteca della Società tarquiniense di arte e storia	42.2542133	11.7572653	Via delle Torri 29-33	Biblioteca	+39 0766858194	NaN	3600	t	1	47	\N	'arte':6 'bibliotec':1 'societ':3 'stor':8 'tarquiniens':4	'arte':6B 'bibliotec':1B 'societ':3B 'stor':8B 'tarquiniens':4B	0101000020E610000090CA0347B8832740A8DAB80F8A204540
684	50	MUSEO ARCHEOLOGICO NAZIONALE	42.4214931	11.8705543	Largo Mario Moretti; 1	Museo, galleria e/o raccolta	0761 436209	sba-em@beniculturali.it	9000	t	1	74	\N	'archeolog':2 'muse':1 'nazional':3	'archeolog':2B 'muse':1B 'nazional':3B	0101000020E6100000CBC80F4BB9BD2740ADFE637CF3354540
685	50	Chiesa di Santa Maria di Castello (o di Valverde)	42.2532394	11.7591747	Via Valverde, 23	Chiesa o edificio di culto	NaN	NaN	9000	t	1	10	\N	'castell':6 'chies':1 'mar':4 'sant':3 'valverd':9	'castell':6B 'chies':1B 'mar':4B 'sant':3B 'valverd':9B	0101000020E6100000B7E6D88BB284274082870E266A204540
686	50	Villa Bruschi Falgari	42.2409784	11.7617258	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	8	\N	'brusc':2 'falgar':3 'vill':1	'brusc':2B 'falgar':3B 'vill':1B	0101000020E6100000F4098FEC008627406E855561D81E4540
687	50	Duomo dei Santi Margherita e Martino	42.2532394	11.7591747	Piazza del Duomo, 4	Chiesa o edificio di culto	NaN	NaN	5400	t	1	44	\N	'duom':1 'margher':4 'martin':6 'sant':3	'duom':1B 'margher':4B 'martin':6B 'sant':3B	0101000020E6100000B7E6D88BB284274082870E266A204540
688	50	Chiesa del Salvatore	42.2532394	11.7591747	Via S. Giacomo, 57	Chiesa o edificio di culto	NaN	NaN	7200	t	1	16	\N	'chies':1 'salvator':3	'chies':1B 'salvator':3B	0101000020E6100000B7E6D88BB284274082870E266A204540
2	1	Chiesa della Natività della SS.ma Vergine	42.7439961	11.8649880	Trevinano	Chiesa o edificio di culto	NaN	NaN	5400	t	1	66	\N	'chies':1 'nativ':3 'ss.ma':5 'vergin':6	'chies':1B 'nativ':3B 'ss.ma':5B 'vergin':6B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
11	1	Chiesa di S. Vittoria	42.7439961	11.8649880	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	32	\N	'chies':1 's':3 'vittor':4	'chies':1B 's':3B 'vittor':4B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
220	14	Pozzo del Diavolo	42.3420478	12.1812291	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	3600	t	1	70	\N	'diavol':3 'pozz':1	'diavol':3B 'pozz':1B	0101000020E6100000C22A830FCA5C28409A55E938C82B4540
221	14	Palazzo delle Scuderie	42.3266250	12.2357660	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	14	\N	'palazz':1 'scuder':3	'palazz':1B 'scuder':3B	0101000020E610000079043752B67828402B8716D9CE294540
656	49	Anfiteatro	42.2495074	12.2190389	Via Cassia km 49.600	Architettura civile	NaN	NaN	9000	t	1	72	\N	'anfiteatr':1	'anfiteatr':1B	0101000020E6100000871AE0DD25702840148EC5DBEF1F4540
581	42	Torre Zelli	42.4605984	12.3856056	NaN	Architettura fortificata	NaN	NaN	3600	t	1	62	\N	'torr':1 'zell':2	'torr':1B 'zell':2B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
689	50	Chiesa di S. Maria del Suffragio	42.2532394	11.7591747	Piazza Giacomo Matteotti	Chiesa o edificio di culto	NaN	NaN	10800	t	1	41	\N	'chies':1 'mar':4 's':3 'suffrag':6	'chies':1B 'mar':4B 's':3B 'suffrag':6B	0101000020E6100000B7E6D88BB284274082870E266A204540
718	50	Palazzo Sacchetti	42.2532394	11.7591747	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	22	\N	'palazz':1 'sacchett':2	'palazz':1B 'sacchett':2B	0101000020E6100000B7E6D88BB284274082870E266A204540
690	50	MUSEO DIOCESANO DI CIVITAVECCHIA - TARQUINIA	42.2526729	11.7565463	VIA ROMA; 11	Museo, galleria e/o raccolta	766840843	insolera.giovanni@libero.it	3600	t	1	57	\N	'civitavecc':4 'dioces':2 'muse':1 'tarquin':5	'civitavecc':4B 'dioces':2B 'muse':1B 'tarquin':5B	0101000020E6100000D2D160095A832740F10AE99557204540
691	50	Ara della Regina. Civita	42.2588160	11.8015510	. - Tarquinia	Area o parco archeologico	NaN	NaN	7200	t	1	32	\N	'ara':1 'civ':4 'regin':3	'ara':1B 'civ':4B 'regin':3B	0101000020E6100000F62686E4649A27403DD7F7E120214540
692	50	Chiesa dell' Annunziata	42.2532394	11.7591747	Via S. Giacomo, 3	Chiesa o edificio di culto	NaN	NaN	10800	t	1	99	\N	'annunz':3 'chies':1	'annunz':3B 'chies':1B	0101000020E6100000B7E6D88BB284274082870E266A204540
693	50	Biblioteca ex Convento S. Marco	42.2555420	11.7545300	Via dei Granari 30 - presso Archivio storico comunale	Biblioteca	+39 0766858073	NaN	5400	t	1	12	\N	'bibliotec':1 'convent':3 'ex':2 'marc':5 's':4	'bibliotec':1B 'convent':3B 'ex':2B 'marc':5B 's':4B	0101000020E6100000A7B393C1518227409160AA99B5204540
694	50	NECROPOLI DI MONTEROZZI	42.2503180	11.7719400	VIA RIPAGRETTA, 68	Area o parco archeologico	NaN	NaN	10800	t	1	66	\N	'monterozz':3 'necropol':1	'monterozz':3B 'necropol':1B	0101000020E6100000D0F23CB83B8B2740D1CC936B0A204540
695	50	Chiesa di S. Martino il Vecchio	42.2532394	11.7591747	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	79	\N	'chies':1 'martin':4 's':3 'vecc':6	'chies':1B 'martin':4B 's':3B 'vecc':6B	0101000020E6100000B7E6D88BB284274082870E266A204540
698	50	Torre Barucci	42.2552179	11.7554946	Piazza S. Stefano	Architettura fortificata	NaN	NaN	7200	t	1	2	\N	'barucc':2 'torr':1	'barucc':2B 'torr':1B	0101000020E6100000F59B2E30D082274049EDEAFAAA204540
699	50	Torre Presso S. Maria di Castello	42.2532394	11.7591747	NaN	Architettura fortificata	NaN	NaN	3600	t	1	7	\N	'castell':6 'mar':4 'press':2 's':3 'torr':1	'castell':6B 'mar':4B 'press':2B 's':3B 'torr':1B	0101000020E6100000B7E6D88BB284274082870E266A204540
701	50	Necropoli	42.2541846	11.7575684	Via Ripagretta; snc	Museo, galleria e/o raccolta	0766 856308	-	5400	t	1	100	\N	'necropol':1	'necropol':1B	0101000020E610000052F75C01E0832740CC12F81E89204540
893	58	Tenuta La Pazzaglia	42.4168441	12.1051148	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	78	\N	'pazzagl':3 'ten':1	'pazzagl':3B 'ten':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
702	50	Chiesa dei SS. Giovanni Battista e Antonio Abate	42.2532394	11.7591747	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	6	\N	'abat':8 'anton':7 'battist':5 'chies':1 'giovann':4 'ss':3	'abat':8B 'anton':7B 'battist':5B 'chies':1B 'giovann':4B 'ss':3B	0101000020E6100000B7E6D88BB284274082870E266A204540
703	50	Etruscopolis	42.2532394	11.7591747	Vicolo delle Pietrare	Museo, galleria e/o raccolta	NaN	NaN	5400	t	1	15	\N	'etruscopolis':1	'etruscopolis':1B	0101000020E6100000B7E6D88BB284274082870E266A204540
704	50	Chiesa di S. Antonio	42.2532394	11.7591747	Via XX Settembre, 75	Chiesa o edificio di culto	NaN	NaN	10800	t	1	63	\N	'anton':4 'chies':1 's':3	'anton':4B 'chies':1B 's':3B	0101000020E6100000B7E6D88BB284274082870E266A204540
705	50	Torre Draghi	42.2546748	11.7562891	via delle Torri ang. P. Verdi	Architettura fortificata	NaN	NaN	9000	t	1	23	\N	'drag':2 'torr':1	'drag':2B 'torr':1B	0101000020E61000007EA42D5338832740C38E102F99204540
706	50	Chiesa di S. Giovanni Gerosolimitano	42.2532394	11.7591747	Via Roma, 2	Chiesa o edificio di culto	NaN	NaN	7200	t	1	45	\N	'chies':1 'gerosolimit':5 'giovann':4 's':3	'chies':1B 'gerosolimit':5B 'giovann':4B 's':3B	0101000020E6100000B7E6D88BB284274082870E266A204540
707	50	Palazzo Comunale	42.2532394	11.7591747	Piazza Giacomo Matteotti, 13	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	21	\N	'comunal':2 'palazz':1	'comunal':2B 'palazz':1B	0101000020E6100000B7E6D88BB284274082870E266A204540
708	50	Centro Storico Di Tarquinia	42.2521745	11.7583816	NaN	Architettura fortificata	NaN	NaN	3600	t	1	93	\N	'centr':1 'storic':2 'tarquin':4	'centr':1B 'storic':2B 'tarquin':4B	0101000020E6100000BCC6D3974A8427404D31074147204540
223	14	Palazzo Farnese	42.3279900	12.2377600	Piazzale Farnese; 1	Museo, galleria e/o raccolta	0761 646052	-	10800	t	1	18	\N	'farnes':2 'palazz':1	'farnes':2B 'palazz':1B	0101000020E61000000B98C0ADBB79284020B58993FB294540
224	15	Chiesa della Madonna della Valle	42.3316250	12.2643660	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	92	\N	'chies':1 'madonn':3 'vall':5	'chies':1B 'madonn':3B 'vall':5B	0101000020E61000004359F8FA5A8728409CC420B0722A4540
225	15	Parrocchia di San Pietro Apostolo	42.3316250	12.2643660	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	76	\N	'apostol':5 'parrocc':1 'pietr':4 'san':3	'apostol':5B 'parrocc':1B 'pietr':4B 'san':3B	0101000020E61000004359F8FA5A8728409CC420B0722A4540
227	15	Ex Chiesa Santa Maria dell’Immacolata Concezione	42.3316250	12.2643660	Piazza Santa Maria - Carbognano	Museo, Galleria e/o raccolta	NaN	NaN	10800	t	1	75	\N	'chies':2 'concezion':7 'ex':1 'immacol':6 'mar':4 'sant':3	'chies':2B 'concezion':7B 'ex':1B 'immacol':6B 'mar':4B 'sant':3B	0101000020E61000004359F8FA5A8728409CC420B0722A4540
228	16	Castel Porciano	42.2215157	12.3582771	NaN	Architettura fortificata	NaN	NaN	10800	t	1	50	\N	'castel':1 'porc':2	'castel':1B 'porc':2B	0101000020E6100000BBCF961870B7284078865FA05A1C4540
229	16	Ipogeo di San Leonardo	42.2517755	12.3717955	NaN	Area o parco archeologico	NaN	NaN	3600	t	1	46	\N	'ipoge':1 'leonard':4 'san':3	'ipoge':1B 'leonard':4B 'san':3B	0101000020E61000009599D2FA5BBE28408F37F92D3A204540
48	2	Palazzo Cellesi	42.6269800	12.0908718	Castel Cellesi	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	44	\N	'celles':2 'palazz':1	'celles':2B 'palazz':1B	0101000020E6100000DF41A2BF862E2840809F71E140504540
709	50	Palazzo Vitelleschi	42.2538184	11.7557250	Corso Vittorio Emanuele	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	24	\N	'palazz':1 'vitellesc':2	'palazz':1B 'vitellesc':2B	0101000020E6100000098A1F63EE822740C08F0F1F7D204540
710	50	Porta di città, o Torrione della Contessa Matilde	42.2532394	11.7591747	Via Porta Castello, 52	Architettura fortificata	NaN	NaN	5400	t	1	78	\N	'citt':3 'contess':7 'matild':8 'port':1 'torrion':5	'citt':3B 'contess':7B 'matild':8B 'port':1B 'torrion':5B	0101000020E6100000B7E6D88BB284274082870E266A204540
712	50	Chiesa di San Leonardo	42.2532394	11.7591747	P.za Trento e Trieste, 7	Chiesa o edificio di culto	NaN	NaN	7200	t	1	15	\N	'chies':1 'leonard':4 'san':3	'chies':1B 'leonard':4B 'san':3B	0101000020E6100000B7E6D88BB284274082870E266A204540
713	50	COLLEZIONE GIUSEPPE CULTRERA - MUSEO DELLA CERAMICA; DELLA SOCIETA' TARQUINIENSE; D'ARTE E STORIA	42.2542133	11.7572653	VIA DELLE TORRI; 31	Museo, galleria e/o raccolta	766858194	tarquiniense@gmail.com	10800	t	1	98	\N	'arte':11 'ceram':6 'collezion':1 'cultrer':3 'd':10 'giusepp':2 'muse':4 'societ':8 'stor':13 'tarquiniens':9	'arte':11B 'ceram':6B 'collezion':1B 'cultrer':3B 'd':10B 'giusepp':2B 'muse':4B 'societ':8B 'stor':13B 'tarquiniens':9B	0101000020E610000090CA0347B8832740A8DAB80F8A204540
714	50	Chiesa della Santissima Trinità	42.2532394	11.7591747	Via Alberata Dante Alighieri, 27	Chiesa o edificio di culto	NaN	NaN	3600	t	1	83	\N	'chies':1 'santissim':3 'trinit':4	'chies':1B 'santissim':3B 'trinit':4B	0101000020E6100000B7E6D88BB284274082870E266A204540
715	50	Palazzo Castelleschi	42.2544485	11.7574653	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	43	\N	'castellesc':2 'palazz':1	'castellesc':2B 'palazz':1B	0101000020E6100000ACB5E67DD28327401502B9C491204540
716	50	Torre Cialdi	42.2532394	11.7591747	via della Ripa 	Architettura fortificata	NaN	NaN	9000	t	1	11	\N	'ciald':2 'torr':1	'ciald':2B 'torr':1B	0101000020E6100000B7E6D88BB284274082870E266A204540
717	50	Torre Mozza	42.2532394	11.7591747	via delle Torri,45	Architettura fortificata	NaN	NaN	3600	t	1	52	\N	'mozz':2 'torr':1	'mozz':2B 'torr':1B	0101000020E6100000B7E6D88BB284274082870E266A204540
580	42	Chiesa di San Biagio	42.4605984	12.3856056	Via Novara, 531	Chiesa o edificio di culto	NaN	NaN	9000	t	1	45	\N	'biag':4 'chies':1 'san':3	'biag':4B 'chies':1B 'san':3B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
726	51	Chiesa Di San Giuseppe	42.4202141	11.8702611	Largo Cavour	Chiesa o edificio di culto	NaN	NaN	9000	t	1	10	\N	'chies':1 'giusepp':4 'san':3	'chies':1B 'giusepp':4B 'san':3B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
727	51	Palazzo Fani	42.4202141	11.8702611	Via Pozzo Bianco, 131	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	72	\N	'fan':2 'palazz':1	'fan':2B 'palazz':1B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
756	52	Chiesa di Santa Croce	42.5684597	11.8187556	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	44	\N	'chies':1 'croc':4 'sant':3	'chies':1B 'croc':4B 'sant':3B	0101000020E61000006ED51AEF33A32740074C9649C3484540
728	51	Area Archeologica Colle Di San Pietro	42.4202141	11.8702611	Str. S. Pietro	Area o parco archeologico	NaN	NaN	5400	t	1	92	\N	'archeolog':2 'are':1 'coll':3 'pietr':6 'san':5	'archeolog':2B 'are':1B 'coll':3B 'pietr':6B 'san':5B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
135	7	Oratorio di S. Leonardo	42.6441069	11.9849554	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	12	\N	'leonard':4 'orator':1 's':3	'leonard':4B 'orator':1B 's':3B	0101000020E61000008609FE124CF8274060504B1872524540
729	51	Teatro Comunale Il Rivellino	42.4364920	11.8571108	Largo del Teatro	Architettura civile	NaN	NaN	9000	t	1	94	\N	'comunal':2 'rivellin':4 'teatr':1	'comunal':2B 'rivellin':4B 'teatr':1B	0101000020E6100000C7180E3AD7B627409A7B48F8DE374540
730	51	MUSEO ARCHEOLOGICO NAZIONALE	42.4202141	11.8702611	LARGO MARIO MORETTI, 1	Museo, galleria e/o raccolta	NaN	NaN	3600	t	1	78	\N	'archeolog':2 'muse':1 'nazional':3	'archeolog':2B 'muse':1B 'nazional':3B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
731	51	Necropoli Pian di Mola	42.4243520	11.8862820	Necropoli_di_Pian_di_Mola	Area o parco archeologico	NaN	NaN	7200	t	1	79	\N	'mol':4 'necropol':1 'pian':2	'mol':4B 'necropol':1B 'pian':2B	0101000020E610000023111AC1C6C5274000FF942A51364540
732	51	Casa Museo Pietro Moschini	42.4202141	11.8702611	Via della Scrofa, 8	Museo, galleria e/o raccolta	NaN	NaN	5400	t	1	14	\N	'cas':1 'moschin':4 'muse':2 'pietr':3	'cas':1B 'moschin':4B 'muse':2B 'pietr':3B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
733	51	Biblioteca comunale	42.4202141	11.8702611	Piazza F. Basile 6	Biblioteca	NaN	NaN	7200	t	1	24	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
734	51	Fontana delle sette cannelle	42.6341662	11.6681677	NaN	Monumento	NaN	NaN	7200	t	1	5	\N	'cannell':4 'fontan':1 'sett':3	'cannell':4B 'fontan':1B 'sett':3B	0101000020E6100000B17CA7131A562740439DA85B2C514540
735	51	Chiesa Di San Giovanni Decollato	42.4202141	11.8702611	Piazza Giacomo Matteotti	Chiesa o edificio di culto	NaN	NaN	5400	t	1	42	\N	'chies':1 'decoll':5 'giovann':4 'san':3	'chies':1B 'decoll':5B 'giovann':4B 'san':3B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
736	51	Chiesa di San Marco	42.4202141	11.8702611	Largo Bixio	Chiesa o edificio di culto	NaN	NaN	5400	t	1	28	\N	'chies':1 'marc':4 'san':3	'chies':1B 'marc':4B 'san':3B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
737	51	Antica Via Clodia	42.4202141	11.8702611	Via del Comune, 41	Area o parco archeologico	NaN	NaN	7200	t	1	40	\N	'antic':1 'clod':3 'via':2	'antic':1B 'clod':3B 'via':2B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
738	51	Palazzo Quaglia	42.4202141	11.8702611	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	57	\N	'palazz':1 'quagl':2	'palazz':1B 'quagl':2B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
739	51	CHIESA SAN PIETRO	42.4202141	11.8702611	STRADA SAN PIETRO, 1	Chiesa o edificio di culto	NaN	NaN	7200	t	1	85	\N	'chies':1 'pietr':3 'san':2	'chies':1B 'pietr':3B 'san':2B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
753	51	Chiesa Santa Maria della Rosa	42.4202141	11.8702611	Via XII Settembre	Chiesa o edificio di culto	NaN	NaN	3600	t	1	20	\N	'chies':1 'mar':3 'ros':5 'sant':2	'chies':1B 'mar':3B 'ros':5B 'sant':2B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
534	39	Cascata del Picchio	42.2428240	12.3455700	Via Garibaldi	Parco o Giardino di interesse storico o artistico	NaN	NaN	3600	t	1	30	\N	'casc':1 'picc':3	'casc':1B 'picc':3B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
15	1	Osservatorio Astronomico "Nuova Pegasus"	42.7439961	11.8649880	Via Postierla, 59	Museo, galleria e/o raccolta	NaN	NaN	9000	t	1	37	\N	'astronom':2 'nuov':3 'osservator':1 'pegasus':4	'astronom':2B 'nuov':3B 'osservator':1B 'pegasus':4B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
16	1	Casale San Giorgio	42.7439961	11.8649880	S. Giorgio	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	12	\N	'casal':1 'giorg':3 'san':2	'casal':1B 'giorg':3B 'san':2B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
722	50	Necropoli di Tarquinia	42.1948646	11.8578725	Via Ripagretta	Area o parco archeologico	NaN	NaN	10800	t	1	28	\N	'necropol':1 'tarquin':3	'necropol':1B 'tarquin':3B	0101000020E6100000884677103BB72740F612BE52F1184540
754	51	Fontana di Montascide	42.4202141	11.8702611	Piazza Giuseppe Mazzini, 71	Monumento	NaN	NaN	5400	t	1	9	\N	'fontan':1 'montascid':3	'fontan':1B 'montascid':3B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
755	51	Spazio teatrale Supercinema	42.4384570	11.8875923	Via Garibaldi 1	Architettura civile	NaN	NaN	5400	t	1	57	\N	'spaz':1 'supercinem':3 'teatral':2	'spaz':1B 'supercinem':3B 'teatral':2B	0101000020E6100000E35C797F72C62740E4D9E55B1F384540
81	4	Monastero San Vincenzo - Santuario del Santo Volto	42.2183916	12.1930062	Via S. Vincenzo, 88	Chiesa o edificio di culto	NaN	NaN	7200	t	1	77	\N	'monaster':1 'san':2 'sant':6 'santuar':4 'vincenz':3 'volt':7	'monaster':1B 'san':2B 'sant':6B 'santuar':4B 'vincenz':3B 'volt':7B	0101000020E6100000B8D969B5D16228404DDC8541F41B4540
82	4	Parrocchia Maria S.S. Assunta in Cielo	42.2183916	12.1930062	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	20	\N	'assunt':4 'ciel':6 'mar':2 'parrocc':1 's.s':3	'assunt':4B 'ciel':6B 'mar':2B 'parrocc':1B 's.s':3B	0101000020E6100000B8D969B5D16228404DDC8541F41B4540
757	52	MUSEO DELLA PREISTORIA DELLA TUSCIA E DELLA ROCCA FARNESE	42.5685644	11.8192069	piazza della Vittoria; 11	Museo, galleria e/o raccolta	761420018	museo.valentano@alice.it	9000	t	1	64	\N	'farnes':9 'muse':1 'preistor':3 'rocc':8 'tusc':5	'farnes':9B 'muse':1B 'preistor':3B 'rocc':8B 'tusc':5B	0101000020E6100000A95038166FA32740BED5DFB7C6484540
758	52	Lago di Mezzano	42.6117155	11.7697165	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	5400	t	1	26	\N	'lag':1 'mezz':3	'lag':1B 'mezz':3B	0101000020E61000001762F547188A2740687A89B14C4E4540
759	52	Palazzo Vitozzi	42.5686870	11.8184229	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	53	\N	'palazz':1 'vitozz':2	'palazz':1B 'vitozz':2B	0101000020E61000004F988B5308A32740865451BCCA484540
760	52	Chiesa di Santa Maria dell' Eschio	42.5684597	11.8187556	Eschio	Chiesa o edificio di culto	NaN	NaN	3600	t	1	48	\N	'chies':1 'eschi':6 'mar':4 'sant':3	'chies':1B 'eschi':6B 'mar':4B 'sant':3B	0101000020E61000006ED51AEF33A32740074C9649C3484540
761	52	Chiesa della Madonna del Monte	42.5684597	11.8187556	Madonna del Monte	Chiesa o edificio di culto	NaN	NaN	5400	t	1	19	\N	'chies':1 'madonn':3 'mont':5	'chies':1B 'madonn':3B 'mont':5B	0101000020E61000006ED51AEF33A32740074C9649C3484540
762	52	Centro Storico di Valentano	42.5664350	11.8192040	NaN	Architettura fortificata	NaN	NaN	10800	t	1	3	\N	'centr':1 'storic':2 'valent':4	'centr':1B 'storic':2B 'valent':4B	0101000020E61000003881E9B46EA32740A6272CF180484540
763	52	Porta di S. Martino	42.5684597	11.8187556	NaN	Architettura fortificata	NaN	NaN	5400	t	1	78	\N	'martin':4 'port':1 's':3	'martin':4B 'port':1B 's':3B	0101000020E61000006ED51AEF33A32740074C9649C3484540
764	52	Chiesa di S. Maria	42.5684597	11.8187556	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	11	\N	'chies':1 'mar':4 's':3	'chies':1B 'mar':4B 's':3B	0101000020E61000006ED51AEF33A32740074C9649C3484540
765	52	Porta Urbana-Porta Magenta	42.5684597	11.8187556	Piazza Cavour, 11	Architettura fortificata	NaN	NaN	5400	t	1	15	\N	'magent':5 'port':1,4 'urban':3 'urbana-port':2	'magent':5B 'port':1B,4B 'urban':3B 'urbana-port':2B	0101000020E61000006ED51AEF33A32740074C9649C3484540
767	52	Biblioteca comunale	42.5684597	11.8187556	Piazza della Vittoria 9	Biblioteca	NaN	NaN	10800	t	1	65	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E61000006ED51AEF33A32740074C9649C3484540
768	52	Palazzo Comunale	42.5684597	11.8187556	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	22	\N	'comunal':2 'palazz':1	'comunal':2B 'palazz':1B	0101000020E61000006ED51AEF33A32740074C9649C3484540
769	52	Chiesa di San Giovanni Apostolo ed Evangelista 	42.5684597	11.8187556	Piazza della Vittoria, 61	Chiesa o edificio di culto	NaN	NaN	7200	t	1	31	\N	'apostol':5 'chies':1 'evangel':7 'giovann':4 'san':3	'apostol':5B 'chies':1B 'evangel':7B 'giovann':4B 'san':3B	0101000020E61000006ED51AEF33A32740074C9649C3484540
770	52	Santuario della Madonna della Salute	42.5684597	11.8187556	VIa del Ritiro	Chiesa o edificio di culto	NaN	NaN	5400	t	1	42	\N	'madonn':3 'sal':5 'santuar':1	'madonn':3B 'sal':5B 'santuar':1B	0101000020E61000006ED51AEF33A32740074C9649C3484540
771	53	Chiesa SS. Crocefisso	41.7907359	12.4696439	Strada Provinciale Valleranese	Chiesa o edificio di culto	NaN	NaN	3600	t	1	31	\N	'chies':1 'crocefiss':3 'ss':2	'chies':1B 'crocefiss':3B 'ss':2B	0101000020E610000023884E2A75F02840F6227FD536E54440
772	53	Grotte dei Quadratini e dei Finestroni	41.7907359	12.4696439	NaN	Area o parco archeologico	NaN	NaN	9000	t	1	59	\N	'finestron':6 'grott':1 'quadratin':3	'finestron':6B 'grott':1B 'quadratin':3B	0101000020E610000023884E2A75F02840F6227FD536E54440
773	53	Eremo di San Salvatore	41.7907359	12.4696439	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	96	\N	'erem':1 'salvator':4 'san':3	'erem':1B 'salvator':4B 'san':3B	0101000020E610000023884E2A75F02840F6227FD536E54440
774	53	Santuario Mariano: Madonna della Pieve	41.7907359	12.4696439	Via della Pieve, 421	Chiesa o edificio di culto	NaN	NaN	7200	t	1	69	\N	'madonn':3 'mar':2 'piev':5 'santuar':1	'madonn':3B 'mar':2B 'piev':5B 'santuar':1B	0101000020E610000023884E2A75F02840F6227FD536E54440
775	53	Santuario Mariano: Chiesa della Madonna del Ruscello	41.7907359	12.4696439	Via Salita	Chiesa o edificio di culto	NaN	NaN	5400	t	1	9	\N	'chies':3 'madonn':5 'mar':2 'ruscell':7 'santuar':1	'chies':3B 'madonn':5B 'mar':2B 'ruscell':7B 'santuar':1B	0101000020E610000023884E2A75F02840F6227FD536E54440
62	2	Biblioteca del Centro studi bonaventuriani	42.6295576	12.0871305	Viale fratelli Agosti	Biblioteca	NaN	NaN	10800	t	1	24	\N	'bibliotec':1 'bonaventurian':5 'centr':3 'stud':4	'bibliotec':1B 'bonaventurian':5B 'centr':3B 'stud':4B	0101000020E6100000E0F76F5E9C2C28406079EB5795504540
63	2	Biblioteca del Seminario vescovile	42.6257296	12.0996384	Piazza S. Agostino, 10	Biblioteca	+39 0761.792036	cedi.do@libero.it	7200	t	1	80	\N	'bibliotec':1 'seminar':3 'vescovil':4	'bibliotec':1B 'seminar':3B 'vescovil':4B	0101000020E6100000FED9EACD03332840D01154E817504540
777	53	Biblioteca comunale Corrado Alvaro	42.3813915	12.2339467	via del Torrione	Biblioteca	+39 0761753764	biblioteca.vallerano@yahoo.it	9000	t	1	7	\N	'alvar':4 'bibliotec':1 'comunal':2 'corrad':3	'alvar':4B 'bibliotec':1B 'comunal':2B 'corrad':3B	0101000020E6100000A603A3DCC777284077BCC96FD1304540
778	53	Teatro Comunale	41.7907359	12.4696439	Piazza della Repubblica	Architettura civile	NaN	NaN	7200	t	1	92	\N	'comunal':2 'teatr':1	'comunal':2B 'teatr':1B	0101000020E610000023884E2A75F02840F6227FD536E54440
84	4	Chiesa di San Gratiliano	42.2183916	12.1930062	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	36	\N	'chies':1 'gratil':4 'san':3	'chies':1B 'gratil':4B 'san':3B	0101000020E6100000B8D969B5D16228404DDC8541F41B4540
85	4	Chiesa della Madonna della Pietà	42.2183916	12.1930062	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	12	\N	'chies':1 'madonn':3 'piet':5	'chies':1B 'madonn':3B 'piet':5B	0101000020E6100000B8D969B5D16228404DDC8541F41B4540
86	4	VILLA GIUSTINIANI (o Castello Odescalchi)	42.2183916	12.1930062	PIAZZA UMBERTO PRIMO, 1	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	1	\N	'castell':4 'giustinian':2 'odescalc':5 'vill':1	'castell':4B 'giustinian':2B 'odescalc':5B 'vill':1B	0101000020E6100000B8D969B5D16228404DDC8541F41B4540
124	7	Palazzo Serafini	42.6441069	11.9849554	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	86	\N	'palazz':1 'serafin':2	'palazz':1B 'serafin':2B	0101000020E61000008609FE124CF8274060504B1872524540
779	53	Grotte di San Leonardo	41.7907359	12.4696439	NaN	Area o parco archeologico	NaN	NaN	3600	t	1	16	\N	'grott':1 'leonard':4 'san':3	'grott':1B 'leonard':4B 'san':3B	0101000020E610000023884E2A75F02840F6227FD536E54440
780	53	Chiesa San Vittore	41.7907359	12.4696439	Piazza San Vittore	Chiesa o edificio di culto	NaN	NaN	9000	t	1	97	\N	'chies':1 'san':2 'vittor':3	'chies':1B 'san':2B 'vittor':3B	0101000020E610000023884E2A75F02840F6227FD536E54440
781	54	Lago Vadimone	42.4841106	12.3232080	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	10800	t	1	0	\N	'lag':1 'vadimon':2	'lag':1B 'vadimon':2B	0101000020E6100000739CDB847BA52840CF520D56F73D4540
782	54	Chiesa di San Silvestro	42.4144251	12.3464168	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	65	\N	'chies':1 'san':3 'silvestr':4	'chies':1B 'san':3B 'silvestr':4B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
783	54	Cunicolo Tra i Fossi Canale e Tre Fontane	42.4144251	12.3464168	NaN	Area o parco archeologico	NaN	NaN	9000	t	1	37	\N	'canal':5 'cunicol':1 'fontan':8 'tre':7	'canal':5B 'cunicol':1B 'fontan':8B 'tre':7B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
784	54	Zona Archeologica di Palazzolo	42.4144251	12.3464168	NaN	Area o parco archeologico	NaN	NaN	7200	t	1	49	\N	'archeolog':2 'palazzol':4 'zon':1	'archeolog':2B 'palazzol':4B 'zon':1B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
607	45	Chiesa Di Santa Maria Incoronata E Santa Lucia Vergine Martire	42.2902415	12.2138064	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	16	\N	'chies':1 'incoron':5 'luc':8 'mar':4 'mart':10 'sant':3,7 'vergin':9	'chies':1B 'incoron':5B 'luc':8B 'mar':4B 'mart':10B 'sant':3B,7B 'vergin':9B	0101000020E6100000DA594F08786D284093382BA226254540
786	54	Palazzo Celestini (Municipale)	42.4144251	12.3464168	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	42	\N	'celestin':2 'municipal':3 'palazz':1	'celestin':2B 'municipal':3B 'palazz':1B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
787	54	Castello Orsini (o Castello di Vasanello)	42.4177370	12.3466190	Piazza della Repubblica	Architettura fortificata	NaN	NaN	10800	t	1	13	\N	'castell':1,4 'orsin':2 'vasanell':6	'castell':1B,4B 'orsin':2B 'vasanell':6B	0101000020E61000002E58AA0B78B1284022AAF06778354540
788	54	Chiesa di San Salvatore	42.4144251	12.3464168	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	47	\N	'chies':1 'salvator':4 'san':3	'chies':1B 'salvator':4B 'san':3B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
789	54	Cella di Santa Rosa	42.4144251	12.3464168	NaN	Area o parco archeologico	NaN	NaN	3600	t	1	7	\N	'cell':1 'ros':4 'sant':3	'cell':1B 'ros':4B 'sant':3B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
790	54	Chiesa della Madonna del Rifugio	42.4144251	12.3464168	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	44	\N	'chies':1 'madonn':3 'rifug':5	'chies':1B 'madonn':3B 'rifug':5B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
791	54	Necropoli dei Morticelli	42.4144251	12.3464168	NaN	Area o parco archeologico	NaN	NaN	10800	t	1	42	\N	'morticell':3 'necropol':1	'morticell':3B 'necropol':1B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
792	54	Chiesa di S. Maria della Stella	42.4144251	12.3464168	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	52	\N	'chies':1 'mar':4 's':3 'stell':6	'chies':1B 'mar':4B 's':3B 'stell':6B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
793	54	La Torricella	42.4144251	12.3464168	NaN	Area o parco archeologico	NaN	NaN	5400	t	1	98	\N	'torricell':2	'torricell':2B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
794	54	Ex chiesa di S. Michele Arcangelo	42.4144251	12.3464168	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	26	\N	'arcangel':6 'chies':2 'ex':1 'michel':5 's':4	'arcangel':6B 'chies':2B 'ex':1B 'michel':5B 's':4B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
795	54	Palazzo Mercuri Pozzaglia	42.4144251	12.3464168	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	80	\N	'mercur':2 'palazz':1 'pozzagl':3	'mercur':2B 'palazz':1B 'pozzagl':3B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
721	50	Cencelle	42.1952998	11.8580819	NaN	Architettura fortificata	NaN	NaN	3600	t	1	29	\N	'cencell':1	'cencell':1B	0101000020E61000003F94C38256B727402AF57695FF184540
797	54	Museo della ceramica di Vasanello	42.4144251	12.3464168	San Salvatore - Vasanello	Museo, Galleria e/o raccolta	NaN	NaN	7200	t	1	96	\N	'ceram':3 'muse':1 'vasanell':5	'ceram':3B 'muse':1B 'vasanell':5B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
798	54	MUSEO DELLA CERAMICA DI VASANELLO	42.4183899	12.3469114	VIA S. SALVATORE; 19	Museo, galleria e/o raccolta	7614089302	tamarapatilli@libero.it	10800	t	1	100	\N	'ceram':3 'muse':1 'vasanell':5	'ceram':3B 'muse':1B 'vasanell':5B	0101000020E61000001A38FB5E9EB1284005BDDCCC8D354540
245	17	Chiesa di S. Silvestro	42.6449715	12.2038975	Sermugnano	Chiesa o edificio di culto	NaN	NaN	10800	t	1	4	\N	'chies':1 's':3 'silvestr':4	'chies':1B 's':3B 'silvestr':4B	0101000020E6100000EA78CC406568284010AD156D8E524540
247	17	Porta S. Giovanni	42.6449715	12.2038975	NaN	Architettura fortificata	NaN	NaN	3600	t	1	89	\N	'giovann':3 'port':1 's':2	'giovann':3B 'port':1B 's':2B	0101000020E6100000EA78CC406568284010AD156D8E524540
12	1	Casale Mulino	42.7439961	11.8649880	Subissone	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	18	\N	'casal':1 'mulin':2	'casal':1B 'mulin':2B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
119	7	Porta San Francesco	42.6441069	11.9849554	NaN	Architettura fortificata	NaN	NaN	9000	t	1	11	\N	'francesc':3 'port':1 'san':2	'francesc':3B 'port':1B 'san':2B	0101000020E61000008609FE124CF8274060504B1872524540
799	54	Cappella della Madonna delle Grazie	42.4144251	12.3464168	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	81	\N	'cappell':1 'graz':5 'madonn':3	'cappell':1B 'graz':5B 'madonn':3B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
65	2	ASSOCIAZIONE STORICO CULTURALE 'PIERO TARUFFI'	42.6269490	12.0974162	VIA FIDANZA; 55	Museo, galleria e/o raccolta	761780811	museotaruffi@libero.it	5400	t	1	64	\N	'assoc':1 'cultural':3 'pier':4 'storic':2 'taruff':5	'assoc':1B 'cultural':3B 'pier':4B 'storic':2B 'taruff':5B	0101000020E610000081334289E031284045A165DD3F504540
68	2	MUSEO GEOLOGICO E DELLE FRANE	42.6278153	12.1136284	piazza San Donato	Museo, galleria e/o raccolta	328 6657205	info@museogeologicodellefrane.it	10800	t	1	82	\N	'fran':5 'geolog':2 'muse':1	'fran':5B 'geolog':2B 'muse':1B	0101000020E61000002ACB6B802D3A2840D7B672405C504540
800	54	Biblioteca comunale Elisabetta e Francesco Froio	42.4183899	12.3469114	Via San Salvatore 19	Biblioteca	+39 0761409055	biblioteca@vasanellovt.info	9000	t	1	88	\N	'bibliotec':1 'comunal':2 'elisabett':3 'francesc':5 'froi':6	'bibliotec':1B 'comunal':2B 'elisabett':3B 'francesc':5B 'froi':6B	0101000020E61000001A38FB5E9EB1284005BDDCCC8D354540
801	54	Palazzo Ancellotti	42.4144251	12.3464168	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	47	\N	'ancellott':2 'palazz':1	'ancellott':2B 'palazz':1B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
802	54	Palazzo Del Modio - Mariani	42.4144251	12.3464168	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	57	\N	'marian':4 'mod':3 'palazz':1	'marian':4B 'mod':3B 'palazz':1B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
803	54	Palazzo dell'Orologio	42.4144251	12.3464168	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	2	\N	'orolog':3 'palazz':1	'orolog':3B 'palazz':1B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
861	58	Piazza del Plebiscito	42.4168441	12.1051148	NaN	Monumento	NaN	NaN	3600	t	1	34	\N	'piazz':1 'plebisc':3	'piazz':1B 'plebisc':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
804	54	Cattedrale di S. Maria Assunta	42.4144251	12.3464168	Piazza della Repubblica, 291	Chiesa o edificio di culto	NaN	NaN	7200	t	1	100	\N	'assunt':5 'cattedral':1 'mar':4 's':3	'assunt':5B 'cattedral':1B 'mar':4B 's':3B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
805	54	Fornace Aretina	42.4144251	12.3464168	NaN	Area o parco archeologico	NaN	NaN	9000	t	1	0	\N	'aretin':2 'fornac':1	'aretin':2B 'fornac':1B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
806	54	Ex chiesa di S. Sebastiano	42.4144251	12.3464168	"Arghetto"	Chiesa o edificio di culto	NaN	NaN	3600	t	1	33	\N	'chies':2 'ex':1 's':4 'sebast':5	'chies':2B 'ex':1B 's':4B 'sebast':5B	0101000020E6100000E891F58A5DB128401E92B5E10B354540
807	55	Chiesa Santa Maria Assunta	41.8823764	12.5636788	Piazza S. Maria, 12	Chiesa o edificio di culto	NaN	NaN	9000	t	1	86	\N	'assunt':4 'chies':1 'mar':3 'sant':2	'assunt':4B 'chies':1B 'mar':3B 'sant':2B	0101000020E6100000A5E5F6819A2029409061BAB5F1F04440
808	55	 "La Rocca dei Santacroce" 	42.2167570	12.0952017	NaN	Architettura fortificata	NaN	NaN	9000	t	1	66	\N	'rocc':2 'santacroc':4	'rocc':2B 'santacroc':4B	0101000020E6100000160CF846BE302840EC1681B1BE1B4540
809	55	Biblioteca comunale	42.2167570	12.0952017	Via XXV Aprile, 10	Biblioteca	NaN	NaN	10800	t	1	48	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E6100000160CF846BE302840EC1681B1BE1B4540
608	45	Castello Farnese	42.0194358	12.3921506	NaN	Architettura fortificata	NaN	NaN	10800	t	1	19	\N	'castell':1 'farnes':2	'castell':1B 'farnes':2B	0101000020E6100000AC36A4F6C7C8284090AF4EDF7C024540
609	45	Chiesa Sant'Eusebio	42.2902415	12.2138064	Via Sant Eusebio	Chiesa o edificio di culto	NaN	NaN	9000	t	1	37	\N	'chies':1 'euseb':3 'sant':2	'chies':1B 'euseb':3B 'sant':2B	0101000020E6100000DA594F08786D284093382BA226254540
810	55	Rocca di Vejano (o Castello di Vejano, Rocca Altieri)	42.2167570	12.0952017	Piazza Santa Maria	Architettura fortificata	NaN	NaN	7200	t	1	9	\N	'altier':9 'castell':5 'rocc':1,8 'vej':3,7	'altier':9B 'castell':5B 'rocc':1B,8B 'vej':3B,7B	0101000020E6100000160CF846BE302840EC1681B1BE1B4540
811	56	Chiesa di San Francesco	42.3205336	12.0575000	L.go S. Francesco, 11	Chiesa o edificio di culto	NaN	NaN	10800	t	1	79	\N	'chies':1 'francesc':4 'san':3	'chies':1B 'francesc':4B 'san':3B	0101000020E61000003D0AD7A3701D284073A2B83E07294540
812	56	Necropoli rupestre di Norchia	42.3386900	11.9454300	S.S. 1 Aurelia bis, tra Vetralla e Monte Romano - Vetralla	Area o parco archeologico	NaN	NaN	3600	t	1	47	\N	'necropol':1 'norc':4 'rupestr':2	'necropol':1B 'norc':4B 'rupestr':2B	0101000020E61000008750A5660FE42740BABDA4315A2B4540
813	56	Biblioteca comunale Alessandro Pistella	42.3183968	12.0586296	Via Brugiotti 1	Biblioteca	+39 0761461272	biblioteca.comunale@comune.vetralla.vt.it	7200	t	1	99	\N	'alessandr':3 'bibliotec':1 'comunal':2 'pistell':4	'alessandr':3B 'bibliotec':1B 'comunal':2B 'pistell':4B	0101000020E6100000B627EDB2041E28405693F139C1284540
125	7	Area del Foro e Domus Privatae della Città Romana di Volsinii	42.6474699	11.9980597	Via Orvietana	Museo, galleria e/o raccolta	-	-	5400	t	1	61	\N	'are':1 'citt':8 'domus':5 'for':3 'privata':6 'roman':9 'volsin':11	'are':1B 'citt':8B 'domus':5B 'for':3B 'privata':6B 'roman':9B 'volsin':11B	0101000020E610000041E955AE01FF27407BD22E4BE0524540
87	4	Chiesa di Santa Maria dei Monti	42.2183916	12.1930062	Str. Vicinale Fonte Vianello, 2	Chiesa o edificio di culto	NaN	NaN	10800	t	1	54	\N	'chies':1 'mar':4 'mont':6 'sant':3	'chies':1B 'mar':4B 'mont':6B 'sant':3B	0101000020E6100000B8D969B5D16228404DDC8541F41B4540
88	4	Biblioteca Comunale e Archivio Storico Comunale	42.2183916	12.1930062	NaN	Biblioteca	NaN	NaN	7200	t	1	27	\N	'archiv':4 'bibliotec':1 'comunal':2,6 'storic':5	'archiv':4B 'bibliotec':1B 'comunal':2B,6B 'storic':5B	0101000020E6100000B8D969B5D16228404DDC8541F41B4540
814	56	Museo Della Città e Del Territorio	42.3226187	12.0506456	Via di Porta Marchetta, 2	Museo, Galleria e/o raccolta	NaN	NaN	3600	t	1	38	\N	'citt':3 'muse':1 'territor':6	'citt':3B 'muse':1B 'territor':6B	0101000020E6100000625F5738EE192840FDC9CE914B294540
815	56	Chiesa Parrocchiale di S. Maria del Soccorso	42.3205336	12.0575000	Piazza S. Maria del Soccorso, 1	Chiesa o edificio di culto	NaN	NaN	9000	t	1	12	\N	'chies':1 'mar':5 'parrocchial':2 's':4 'soccors':7	'chies':1B 'mar':5B 'parrocchial':2B 's':4B 'soccors':7B	0101000020E61000003D0AD7A3701D284073A2B83E07294540
816	56	Palazzo Comunale di Vetralla	42.3205336	12.0575000	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	11	\N	'comunal':2 'palazz':1 'vetrall':4	'comunal':2B 'palazz':1B 'vetrall':4B	0101000020E61000003D0AD7A3701D284073A2B83E07294540
817	56	Tempio di Demetra	42.3205336	12.0575000	NaN	Area o parco archeologico	NaN	NaN	3600	t	1	29	\N	'demetr':3 'temp':1	'demetr':3B 'temp':1B	0101000020E61000003D0AD7A3701D284073A2B83E07294540
818	56	Castello di Norchia	42.3205336	12.0575000	Norchia	Architettura fortificata	NaN	NaN	5400	t	1	36	\N	'castell':1 'norc':3	'castell':1B 'norc':3B	0101000020E61000003D0AD7A3701D284073A2B83E07294540
69	2	Cattedrale di San Nicola	42.6269800	12.0908718	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	43	\N	'cattedral':1 'nicol':4 'san':3	'cattedral':1B 'nicol':4B 'san':3B	0101000020E6100000DF41A2BF862E2840809F71E140504540
70	2	ASSOCIAZIONE STORICO CULTURALE 'PIERO TARUFFI'	42.6269490	12.0974162	VIA FIDANZA, 55	Fondazione	761780811	museotaruffi@libero.it	7200	t	1	64	\N	'assoc':1 'cultural':3 'pier':4 'storic':2 'taruff':5	'assoc':1B 'cultural':3B 'pier':4B 'storic':2B 'taruff':5B	0101000020E610000081334289E031284045A165DD3F504540
71	2	Chiesa di S. Martino	42.6269800	12.0908718	Piazza Luigi Cristofori, 5	Chiesa o edificio di culto	NaN	NaN	3600	t	1	76	\N	'chies':1 'martin':4 's':3	'chies':1B 'martin':4B 's':3B	0101000020E6100000DF41A2BF862E2840809F71E140504540
72	2	Chiesa di San Francesco di Paola	42.6269800	12.0908718	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	33	\N	'chies':1 'francesc':4 'paol':6 'san':3	'chies':1B 'francesc':4B 'paol':6B 'san':3B	0101000020E6100000DF41A2BF862E2840809F71E140504540
74	3	MUSEO ARCHEOLOGICO DELLE NECROPOLI RUPESTRI	42.2498341	12.0673735	VIA SANT'ANGELO, 2	Museo, galleria e/o raccolta	NaN	NaN	3600	t	1	62	\N	'archeolog':2 'muse':1 'necropol':4 'rupestr':5	'archeolog':2B 'muse':1B 'necropol':4B 'rupestr':5B	0101000020E6100000EF3B86C77E2228407A765490FA1F4540
75	3	Parrocchia di Santa Maria Assunta	42.2498341	12.0673735	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	76	\N	'assunt':5 'mar':4 'parrocc':1 'sant':3	'assunt':5B 'mar':4B 'parrocc':1B 'sant':3B	0101000020E6100000EF3B86C77E2228407A765490FA1F4540
819	56	Chiesa di S. Maria in foro Cassio	42.3205336	12.0575000	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	68	\N	'cass':7 'chies':1 'for':6 'mar':4 's':3	'cass':7B 'chies':1B 'for':6B 'mar':4B 's':3B	0101000020E61000003D0AD7A3701D284073A2B83E07294540
820	56	Biblioteca Beato Lorenzo Salvi	42.3208563	12.0532440	Convento S. Angelo	Biblioteca	+39 0761471285	NaN	5400	t	1	52	\N	'beat':2 'bibliotec':1 'lorenz':3 'salv':4	'beat':2B 'bibliotec':1B 'lorenz':3B 'salv':4B	0101000020E61000009C6A2DCC421B2840989BB9D111294540
821	56	Grotta Porcina	42.2944985	12.0025033	S.S. Cassia bivio Vetralla - Vetralla	Area o parco archeologico	NaN	NaN	5400	t	1	79	\N	'grott':1 'porcin':2	'grott':1B 'porcin':2B	0101000020E6100000A043CF1C480128404C1C7920B2254540
822	56	Complesso Santa Maria di Foro Cassio	42.3297460	12.0662080	Strada Foro Cassio - Vetralla	Monumento	NaN	NaN	3600	t	1	66	\N	'cass':6 'compless':1 'for':5 'mar':3 'sant':2	'cass':6B 'compless':1B 'for':5B 'mar':3B 'sant':2B	0101000020E61000009677D503E621284050FEEE1D352A4540
823	56	Palazzo Franciosoni	42.3205336	12.0575000	Via Porfirio Fantozzini, 181	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	58	\N	'francioson':2 'palazz':1	'francioson':2B 'palazz':1B	0101000020E61000003D0AD7A3701D284073A2B83E07294540
824	56	Castello della Rocca (o Castello Vinci)	42.3205336	12.0575000	Via Castello Vinci, 11/13	Architettura fortificata	NaN	NaN	9000	t	1	6	\N	'castell':1,5 'rocc':3 'vinc':6	'castell':1B,5B 'rocc':3B 'vinc':6B	0101000020E61000003D0AD7A3701D284073A2B83E07294540
825	56	Santuario di Demetra a Macchia delle Valli	42.3205336	12.0575000	Strada Provinciale - Vetralla	Area o parco archeologico	NaN	NaN	5400	t	1	7	\N	'demetr':3 'macc':5 'santuar':1 'vall':7	'demetr':3B 'macc':5B 'santuar':1B 'vall':7B	0101000020E61000003D0AD7A3701D284073A2B83E07294540
826	56	Duomo di Vetralla	42.3205336	12.0575000	Via Cassia, 175	Chiesa o edificio di culto	NaN	NaN	3600	t	1	99	\N	'duom':1 'vetrall':3	'duom':1B 'vetrall':3B	0101000020E61000003D0AD7A3701D284073A2B83E07294540
827	57	Biblioteca comunale	42.3838260	12.2767660	Piazza della Repubblica, 4	Biblioteca	NaN	NaN	3600	t	1	8	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E61000001B4AED45B48D284060ADDA3521314540
89	5	Chiesa dell'Immacolata Concezione	42.4660738	12.3130342	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	76	\N	'chies':1 'concezion':4 'immacol':3	'chies':1B 'concezion':4B 'immacol':3B	0101000020E61000001E0FC70446A02840DF42684EA83B4540
91	5	Chiesa della Madonna della Quercia	42.4660738	12.3130342	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	53	\N	'chies':1 'madonn':3 'querc':5	'chies':1B 'madonn':3B 'querc':5B	0101000020E61000001E0FC70446A02840DF42684EA83B4540
93	5	Chiesa dei Santi Fidenzio e Terenzio	42.4660738	12.3130342	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	71	\N	'chies':1 'fidenz':4 'sant':3 'terenz':6	'chies':1B 'fidenz':4B 'sant':3B 'terenz':6B	0101000020E61000001E0FC70446A02840DF42684EA83B4540
94	5	Chiesa di S. Maria dei Lumi	42.4660738	12.3130342	Piazza Nazario Sauro	Chiesa o edificio di culto	NaN	NaN	9000	t	1	77	\N	'chies':1 'lum':6 'mar':4 's':3	'chies':1B 'lum':6B 'mar':4B 's':3B	0101000020E61000001E0FC70446A02840DF42684EA83B4540
95	6	Antiquitates	42.2725220	12.0316620	Localita' Le Fornaci	Museo, galleria e/o raccolta	NaN	NaN	9000	t	1	48	\N	'antiquitates':1	'antiquitates':1B	0101000020E61000004A0D6D003610284063B83A00E2224540
922	58	Palazzo degli Uffici	42.4168441	12.1051148	Piazza Plebiscito 19	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	85	\N	'palazz':1 'uffic':3	'palazz':1B 'uffic':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
828	57	I Connutti	42.3838260	12.2767660	Piazza della Repubblica	Area o parco archeologico	NaN	NaN	10800	t	1	74	\N	'connutt':2	'connutt':2B	0101000020E61000001B4AED45B48D284060ADDA3521314540
829	57	Chiesa di San Sebastiano Martire di Vignanello	42.3838260	12.2767660	Via della Mola, 5	Chiesa o edificio di culto	NaN	NaN	7200	t	1	81	\N	'chies':1 'mart':5 'san':3 'sebast':4 'vignanell':7	'chies':1B 'mart':5B 'san':3B 'sebast':4B 'vignanell':7B	0101000020E61000001B4AED45B48D284060ADDA3521314540
830	57	Chiesa della Madonna del Pianto	42.3851892	12.2804540	Via Valle Maggiore, 91	Chiesa o edificio di culto	NaN	NaN	5400	t	1	87	\N	'chies':1 'madonn':3 'piant':5	'chies':1B 'madonn':3B 'piant':5B	0101000020E61000009510ACAA978F2840DE6234E14D314540
831	57	Porta del Vignola	42.3838260	12.2767660	NaN	Architettura fortificata	NaN	NaN	9000	t	1	97	\N	'port':1 'vignol':3	'port':1B 'vignol':3B	0101000020E61000001B4AED45B48D284060ADDA3521314540
832	57	Castello Ruspoli (o Palazzo Rispoli)	42.3838260	12.2767660	Via dell'Uliveto, 200	Architettura fortificata	NaN	NaN	3600	t	1	98	\N	'castell':1 'palazz':4 'rispol':5 'ruspol':2	'castell':1B 'palazz':4B 'rispol':5B 'ruspol':2B	0101000020E61000001B4AED45B48D284060ADDA3521314540
833	57	Chiesa di San Giovanni Decollato	42.3838260	12.2767660	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	97	\N	'chies':1 'decoll':5 'giovann':4 'san':3	'chies':1B 'decoll':5B 'giovann':4B 'san':3B	0101000020E61000001B4AED45B48D284060ADDA3521314540
834	57	Chiesa Collegiata Santa Maria della Presentazione	42.5685120	11.8188300	Corso Giacomo Matteotti	Chiesa o edificio di culto	NaN	NaN	10800	t	1	82	\N	'chies':1 'colleg':2 'mar':4 'present':6 'sant':3	'chies':1B 'colleg':2B 'mar':4B 'present':6B 'sant':3B	0101000020E6100000A5F78DAF3DA3274018B14F00C5484540
835	57	Fontana Barocca	42.3838260	12.2767660	Corso Giuseppe Garibaldi, 41	Monumento	NaN	NaN	5400	t	1	43	\N	'barocc':2 'fontan':1	'barocc':2B 'fontan':1B	0101000020E61000001B4AED45B48D284060ADDA3521314540
836	58	Sala capitolare Ven. Confraternita del SS. Sacramento e S. Rosario	42.4168441	12.1051148	Piazza Duomo - Viterbo	Museo, Galleria e/o raccolta	NaN	NaN	10800	t	1	7	\N	'capitol':2 'confratern':4 'rosar':10 's':9 'sacr':7 'sal':1 'ss':6 'ven':3	'capitol':2B 'confratern':4B 'rosar':10B 's':9B 'sacr':7B 'sal':1B 'ss':6B 'ven':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
837	58	Necropoli rupestre di Castel d’Asso	42.3963770	12.0208830	Indicazioni dalla S.P. Tuscanese - Viterbo	Area o parco archeologico	NaN	NaN	9000	t	1	25	\N	'asso':6 'castel':4 'd':5 'necropol':1 'rupestr':2	'asso':6B 'castel':4B 'd':5B 'necropol':1B 'rupestr':2B	0101000020E6100000B115342DB10A28407CF1457BBC324540
838	58	Fontana al Paracadutista d’Italia	42.4168441	12.1051148	Via Filippo Ascenzi	Monumento	NaN	NaN	3600	t	1	79	\N	'd':4 'fontan':1 'ital':5 'paracadut':3	'd':4B 'fontan':1B 'ital':5B 'paracadut':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
839	58	Chiesa Di S.pellegrino	42.4168441	12.1051148	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	65	\N	'chies':1 's.pellegrino':3	'chies':1B 's.pellegrino':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
840	58	Giardino di Prato Giardino	42.6474589	12.2774983	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	10800	t	1	29	\N	'giardin':1,4 'prat':3	'giardin':1B,4B 'prat':3B	0101000020E61000002564D641148E28408780E8EEDF524540
842	58	Mura medievali	42.4168441	12.1051148	NaN	Architettura fortificata	NaN	NaN	7200	t	1	94	\N	'medieval':2 'mur':1	'medieval':2B 'mur':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
843	58	Fontana Grande	42.4168441	12.1051148	Piazza Fontana Grande, 6	Monumento	NaN	NaN	9000	t	1	53	\N	'fontan':1 'grand':2	'fontan':1B 'grand':2B	0101000020E6100000B3A6689BD1352840E983C0255B354540
844	58	Chiesa della Santissima Trinità	42.4168441	12.1051148	Piazza Trinità, 8	Chiesa o edificio di culto	NaN	NaN	5400	t	1	65	\N	'chies':1 'santissim':3 'trinit':4	'chies':1B 'santissim':3B 'trinit':4B	0101000020E6100000B3A6689BD1352840E983C0255B354540
845	58	Piazza della Morte	42.4150907	12.1034242	NaN	Monumento	NaN	NaN	3600	t	1	38	\N	'mort':3 'piazz':1	'mort':3B 'piazz':1B	0101000020E6100000DC3A4904F4342840D7AF2AB121354540
846	58	Castello Costaguti	42.5659059	12.1626622	Piazza Umberto I, 19	Architettura fortificata	NaN	NaN	3600	t	1	60	\N	'castell':1 'costag':2	'castell':1B 'costag':2B	0101000020E61000004097BA7548532840858EC29A6F484540
847	58	Piazza del Gesu	42.4168441	12.1051148	NaN	Monumento	NaN	NaN	5400	t	1	5	\N	'gesu':3 'piazz':1	'gesu':3B 'piazz':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
848	58	Castello di Montecalvello (o Castello di Balthus)	42.4168441	12.1051148	NaN	Architettura fortificata	NaN	NaN	5400	t	1	14	\N	'balthus':7 'castell':1,5 'montecalvell':3	'balthus':7B 'castell':1B,5B 'montecalvell':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
850	58	Chiesa di Santa Maria della Verità	42.4168441	12.1051148	Viale Raniero Capocci - Piazza Crispi	Chiesa o edificio di culto	NaN	NaN	5400	t	1	87	\N	'chies':1 'mar':4 'sant':3 'verit':6	'chies':1B 'mar':4B 'sant':3B 'verit':6B	0101000020E6100000B3A6689BD1352840E983C0255B354540
852	58	Mura Etrusche	42.4168441	12.1051148	NaN	Area o parco archeologico	NaN	NaN	10800	t	1	34	\N	'etrusc':2 'mur':1	'etrusc':2B 'mur':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
853	58	Piazza dell'Erbe	42.4168441	12.1051148	NaN	Monumento	NaN	NaN	3600	t	1	53	\N	'erbe':3 'piazz':1	'erbe':3B 'piazz':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
854	58	Cascate Dell'Acquarossa	42.4168441	12.1051148	Str. Pian del Cerro	Parco o Giardino di interesse storico o artistico	NaN	NaN	5400	t	1	32	\N	'acquaross':3 'casc':1	'acquaross':3B 'casc':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
855	58	Casa Poscia	42.4159612	12.1065463	Via Aurelio Saffi	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	83	\N	'cas':1 'posc':2	'cas':1B 'posc':2B	0101000020E61000000505943C8D362840D43373373E354540
856	58	Porta della Verità	42.4171083	12.1099826	Via della Verità	Architettura fortificata	NaN	NaN	3600	t	1	52	\N	'port':1 'verit':3	'port':1B 'verit':3B	0101000020E61000001342ACA34F382840F1B105CE63354540
857	58	Chiesa di Sant Angelo in Spatha	42.4168441	12.1051148	via, Roma, Piazza del Plebiscito	Chiesa o edificio di culto	NaN	NaN	3600	t	1	76	\N	'angel':4 'chies':1 'sant':3 'spath':6	'angel':4B 'chies':1B 'sant':3B 'spath':6B	0101000020E6100000B3A6689BD1352840E983C0255B354540
858	58	MUSEO NATURALISTICO SAN PIETRO	42.4168441	12.1051148	VIALE GENERALE ARMANDO DIAZ, 25	Museo, galleria e/o raccolta	NaN	NaN	5400	t	1	47	\N	'muse':1 'naturalist':2 'pietr':4 'san':3	'muse':1B 'naturalist':2B 'pietr':4B 'san':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
859	58	Via Francigena della Tuscia	42.4168441	12.1051148	NaN	Area o parco archeologico	NaN	NaN	10800	t	1	25	\N	'francigen':2 'tusc':4 'via':1	'francigen':2B 'tusc':4B 'via':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
860	58	Museo Roberto Joppolo	42.4168441	12.1051148	NaN	Museo, Galleria e/o raccolta	NaN	NaN	3600	t	1	7	\N	'joppol':3 'muse':1 'robert':2	'joppol':3B 'muse':1B 'robert':2B	0101000020E6100000B3A6689BD1352840E983C0255B354540
862	58	Chiesa di Sant'Andrea	42.4168441	12.1051148	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	42	\N	'andre':4 'chies':1 'sant':3	'andre':4B 'chies':1B 'sant':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
863	58	Cascate della Mola	42.4168441	12.1051148	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	51	\N	'casc':1 'mol':3	'casc':1B 'mol':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
610	45	Casino di caccia dei Farnese	42.2902415	12.2138064	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	24	\N	'cacc':3 'casin':1 'farnes':5	'cacc':3B 'casin':1B 'farnes':5B	0101000020E6100000DA594F08786D284093382BA226254540
611	45	Castello di Ronciglione	42.3026677	12.1843077	NaN	Architettura fortificata	NaN	NaN	3600	t	1	22	\N	'castell':1 'ronciglion':3	'castell':1B 'ronciglion':3B	0101000020E61000004DCD2F945D5E28401C87B0D0BD264540
612	45	Castello della Rovere	42.2902415	12.2138064	NaN	Architettura fortificata	NaN	NaN	5400	t	1	95	\N	'castell':1 'rov':3	'castell':1B 'rov':3B	0101000020E6100000DA594F08786D284093382BA226254540
864	58	SANTUARIO MADONNA DELLA QUERCIA	42.4296095	12.1302239	PIAZZA DEL SANTUARIO, 	Chiesa o edificio di culto	NaN	NaN	5400	t	1	89	\N	'madonn':2 'querc':4 'santuar':1	'madonn':2B 'querc':4B 'santuar':1B	0101000020E6100000AE50FFB4AC4228408446B071FD364540
865	58	Chiesa di Santa Maria della Salute	42.4168441	12.1051148	Via della Pescheria	Chiesa o edificio di culto	NaN	NaN	10800	t	1	95	\N	'chies':1 'mar':4 'sal':6 'sant':3	'chies':1B 'mar':4B 'sal':6B 'sant':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
866	58	Piazza S. Pellegrino	42.4168441	12.1051148	NaN	Monumento	NaN	NaN	5400	t	1	33	\N	'pellegrin':3 'piazz':1 's':2	'pellegrin':3B 'piazz':1B 's':2B	0101000020E6100000B3A6689BD1352840E983C0255B354540
867	58	AREA ARCHEOLOGICA ANTICA CITTA' DI FERENTO	42.4168441	12.1051148	STRADA FERENTO, snc	Area o parco archeologico	NaN	NaN	7200	t	1	47	\N	'antic':3 'archeolog':2 'are':1 'citt':4 'ferent':6	'antic':3B 'archeolog':2B 'are':1B 'citt':4B 'ferent':6B	0101000020E6100000B3A6689BD1352840E983C0255B354540
76	3	Porta Romana	42.2498341	12.0673735	NaN	Architettura fortificata	NaN	NaN	5400	t	1	65	\N	'port':1 'roman':2	'port':1B 'roman':2B	0101000020E6100000EF3B86C77E2228407A765490FA1F4540
102	6	Palazzo Municipale	42.2725220	12.0316620	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	63	\N	'municipal':2 'palazz':1	'municipal':2B 'palazz':1B	0101000020E61000004A0D6D003610284063B83A00E2224540
868	58	Chiesa di Santa Maria del Paradiso	42.4168441	12.1051148	Via del Paradiso, 22	Chiesa o edificio di culto	NaN	NaN	10800	t	1	24	\N	'chies':1 'mar':4 'paradis':6 'sant':3	'chies':1B 'mar':4B 'paradis':6B 'sant':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
869	58	Chiesa San Giovanni Battista degli Almadiani	42.4168441	12.1051148	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	13	\N	'almadian':6 'battist':4 'chies':1 'giovann':3 'san':2	'almadian':6B 'battist':4B 'chies':1B 'giovann':3B 'san':2B	0101000020E6100000B3A6689BD1352840E983C0255B354540
870	58	Biblioteca S. Giuseppe	42.4103600	12.1081500	Via A. Diaz, 25	Biblioteca	+39 0761.343134	biblioteca.sangiuseppe@teologicoviterbese.it	3600	t	1	49	\N	'bibliotec':1 'giusepp':3 's':2	'bibliotec':1B 'giusepp':3B 's':2B	0101000020E6100000F31FD26F5F37284014CB2DAD86344540
96	6	Castello di Civitella Cesi	42.2244252	12.0005892	 Via delle Case Nuove, Civitella Cesi	Architettura fortificata	NaN	NaN	10800	t	1	3	\N	'castell':1 'ces':4 'civitell':3	'castell':1B 'ces':4B 'civitell':3B	0101000020E61000002C76453A4D002840FA3207F7B91C4540
871	58	Chiesa di Santa Giacinta Marescotti	42.4168441	12.1051148	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	70	\N	'chies':1 'giacint':4 'marescott':5 'sant':3	'chies':1B 'giacint':4B 'marescott':5B 'sant':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
872	58	Piazza XX Settembre	42.4168441	12.1051148	Piazza XX Settembre	Monumento	NaN	NaN	5400	t	1	30	\N	'piazz':1 'settembr':3 'xx':2	'piazz':1B 'settembr':3B 'xx':2B	0101000020E6100000B3A6689BD1352840E983C0255B354540
873	58	Palazzo di Donna Olimpia	42.4168441	12.1051148	Via S. Pietro, 103	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	99	\N	'donn':3 'olimp':4 'palazz':1	'donn':3B 'olimp':4B 'palazz':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
878	58	Fontana del Piano	42.4126328	12.1035635	Via di Pianoscarano	Monumento	NaN	NaN	5400	t	1	76	\N	'fontan':1 'pian':3	'fontan':1B 'pian':3B	0101000020E61000005C1E6B4606352840E2A0CE26D1344540
879	58	Museo Erbario della Tuscia (UTV)	42.4168441	12.1051148	Via S. Camillo De Lellis - Viterbo	Museo, Galleria e/o raccolta	NaN	NaN	3600	t	1	30	\N	'erbar':2 'muse':1 'tusc':4 'utv':5	'erbar':2B 'muse':1B 'tusc':4B 'utv':5B	0101000020E6100000B3A6689BD1352840E983C0255B354540
796	54	Cappella di San Lanno	42.4157452	12.3478512	Via S. Lanno, 851	Chiesa o edificio di culto	NaN	NaN	7200	t	1	61	\N	'cappell':1 'lann':4 'san':3	'cappell':1B 'lann':4B 'san':3B	0101000020E6100000ABBF6F8D19B2284008BC822337354540
880	58	Museo Padre Felice Rossetti di arte moderna	42.4168441	12.1051148	Piazza S. Francesco Alla Rocca - Viterbo	Chiesa o edificio di culto	NaN	NaN	3600	t	1	90	\N	'arte':6 'felic':3 'modern':7 'muse':1 'padr':2 'rossett':4	'arte':6B 'felic':3B 'modern':7B 'muse':1B 'padr':2B 'rossett':4B	0101000020E6100000B3A6689BD1352840E983C0255B354540
881	58	Cattedrale di San Lorenzo	42.4168441	12.1051148	Piazza S. Lorenzo	Chiesa o edificio di culto	NaN	NaN	7200	t	1	20	\N	'cattedral':1 'lorenz':4 'san':3	'cattedral':1B 'lorenz':4B 'san':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
882	58	Biblioteca dell'Istituto S. Giuseppe artigiano	42.4172789	12.1180318	Via Murialdo 51	Biblioteca	+39 0761340893	NaN	5400	t	1	79	\N	'artig':6 'bibliotec':1 'giusepp':5 'istit':3 's':4	'artig':6B 'bibliotec':1B 'giusepp':5B 'istit':3B 's':4B	0101000020E6100000AAC601AA6E3C2840CA671E6569354540
924	58	Palazzo dei Lunensi	42.4168441	12.1051148	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	30	\N	'lunens':3 'palazz':1	'lunens':3B 'palazz':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
613	45	Duomo (Santi Pietro e Caterina)	42.2917590	12.2176823	Via del Duomo di Sotto, 1	Chiesa o edificio di culto	NaN	NaN	7200	t	1	7	\N	'caterin':5 'duom':1 'pietr':3 'sant':2	'caterin':5B 'duom':1B 'pietr':3B 'sant':2B	0101000020E61000000CD6EE0D746F284026A8E15B58254540
614	45	MUSEO DELLE FERRIERE VECCHIE	41.8734690	12.5015140	VIA DELLE CARTIERE, 	Museo, galleria e/o raccolta	NaN	NaN	7200	t	1	40	\N	'ferr':3 'muse':1 'vecc':4	'ferr':3B 'muse':1B 'vecc':4B	0101000020E6100000E8F86871C6002940F0880AD5CDEF4440
615	45	Lago di Vico	42.3204984	12.1748874	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	10800	t	1	59	\N	'lag':1 'vic':3	'lag':1B 'vic':3B	0101000020E610000006F75ED78A592840CD35711706294540
616	46	Chiesa San Lorenzo Martire	42.6867300	11.9066530	Piazza Europa, 10	Chiesa o edificio di culto	NaN	NaN	3600	t	1	42	\N	'chies':1 'lorenz':3 'mart':4 'san':2	'chies':1B 'lorenz':3B 'mart':4B 'san':2B	0101000020E6100000FDA36FD234D027404E97C5C4E6574540
617	46	Piazza Europa	42.6867300	11.9066530	Piazza Europa	Monumento	NaN	NaN	3600	t	1	77	\N	'europ':2 'piazz':1	'europ':2B 'piazz':1B	0101000020E6100000FDA36FD234D027404E97C5C4E6574540
618	46	Chiesa della Madonna di Torano	42.6867300	11.9066530	Torano	Chiesa o edificio di culto	NaN	NaN	7200	t	1	26	\N	'chies':1 'madonn':3 'tor':5	'chies':1B 'madonn':3B 'tor':5B	0101000020E6100000FDA36FD234D027404E97C5C4E6574540
619	46	Chiesa di S. Giovanni in Val di Lago	42.6539720	11.9063901	Val di Lago	Chiesa o edificio di culto	NaN	NaN	5400	t	1	41	\N	'chies':1 'giovann':4 'lag':8 's':3 'val':6	'chies':1B 'giovann':4B 'lag':8B 's':3B 'val':6B	0101000020E61000001AD6F95C12D02740F73FC05AB5534540
620	46	Chiesa di S. Maria Assunta	42.6867300	11.9066530	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	89	\N	'assunt':5 'chies':1 'mar':4 's':3	'assunt':5B 'chies':1B 'mar':4B 's':3B	0101000020E6100000FDA36FD234D027404E97C5C4E6574540
621	47	Palazzo Doria Pamphilj	41.8973329	12.4812657	Via Andrea Doria, 20	Architettura fortificata	NaN	NaN	7200	t	1	63	\N	'dor':2 'palazz':1 'pamphilj':3	'dor':2B 'palazz':1B 'pamphilj':3B	0101000020E6100000835F347568F62840FB8FF1CDDBF24440
622	47	MUSEO DELL'ABATE	42.3693457	12.1250064	piazza dell'oratorio	Museo, galleria e/o raccolta	0761 379803	NaN	9000	t	1	68	\N	'abat':3 'muse':1	'abat':3B 'muse':1B	0101000020E6100000D694BFD60040284088354BB8462F4540
623	47	Abbazia di San Martino al Cimino	42.3676010	12.1282217	Piazza dell'Oratorio, 2/A	Chiesa o edificio di culto	NaN	NaN	5400	t	1	58	\N	'abbaz':1 'cimin':6 'martin':4 'san':3	'abbaz':1B 'cimin':6B 'martin':4B 'san':3B	0101000020E610000069465046A64128400B7DB08C0D2F4540
624	48	Torre Di Santa Maria Di Luco	42.4187606	12.2343075	Via della Torre	Architettura fortificata	NaN	NaN	5400	t	1	41	\N	'luc':6 'mar':4 'sant':3 'torr':1	'luc':6B 'mar':4B 'sant':3B 'torr':1B	0101000020E6100000406A1327F77728403AED84F299354540
625	48	Chiesa di Sant'Agostino	42.4187606	12.2343075	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	87	\N	'agostin':4 'chies':1 'sant':3	'agostin':4B 'chies':1B 'sant':3B	0101000020E6100000406A1327F77728403AED84F299354540
898	58	Teatro dell'Unione	42.4404397	12.0856281	Piazza Giuseppe Verdi	Architettura civile	NaN	NaN	7200	t	1	99	\N	'teatr':1 'union':3	'teatr':1B 'union':3B	0101000020E6100000BB3C4272D72B284016AEFD5360384540
900	58	Cascata dell'Infernaccio	42.5273469	12.1310402	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	7200	t	1	6	\N	'casc':1 'infernacc':3	'casc':1B 'infernacc':3B	0101000020E61000002FEC7AB317432840D0926C1A80434540
901	58	Porta Romana	42.4168441	12.1051148	Via della Sapienza, 11	Architettura fortificata	NaN	NaN	3600	t	1	22	\N	'port':1 'roman':2	'port':1B 'roman':2B	0101000020E6100000B3A6689BD1352840E983C0255B354540
97	6	Palazzo Savini	42.2725220	12.0316620	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	38	\N	'palazz':1 'savin':2	'palazz':1B 'savin':2B	0101000020E61000004A0D6D003610284063B83A00E2224540
902	58	Museo Storico Didattico Cavalieri Templari di Viterbo	42.4168441	12.1051148	Via Chigi, 14	Museo, Galleria e/o raccolta	NaN	NaN	10800	t	1	6	\N	'cavalier':4 'didatt':3 'muse':1 'storic':2 'templar':5 'viterb':7	'cavalier':4B 'didatt':3B 'muse':1B 'storic':2B 'templar':5B 'viterb':7B	0101000020E6100000B3A6689BD1352840E983C0255B354540
903	58	Biblioteca diocesana	42.4153500	12.1014600	Piazza S. Lorenzo, 6/A	Biblioteca	+39 0761.222539	cedi.do@libero.it	9000	t	1	14	\N	'bibliotec':1 'diocesan':2	'bibliotec':1B 'diocesan':2B	0101000020E61000004EB4AB90F2332840613255302A354540
904	58	Chiesa Parrocchiale di Santo Stefano	42.4168441	12.1051148	Piazza dell'Unità	Chiesa o edificio di culto	NaN	NaN	7200	t	1	48	\N	'chies':1 'parrocchial':2 'sant':4 'stef':5	'chies':1B 'parrocchial':2B 'sant':4B 'stef':5B	0101000020E6100000B3A6689BD1352840E983C0255B354540
905	58	Villa Rossi Danielli	42.4168441	12.1051148	Str. Sammartinese, 10	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	9	\N	'daniell':3 'ross':2 'vill':1	'daniell':3B 'ross':2B 'vill':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
906	58	Centro Storico di Viterbo	42.2521745	11.7583816	NaN	Architettura fortificata	NaN	NaN	3600	t	1	38	\N	'centr':1 'storic':2 'viterb':4	'centr':1B 'storic':2B 'viterb':4B	0101000020E6100000BCC6D3974A8427404D31074147204540
907	58	Palazzo Chigi	42.4168441	12.1051148	Via Chigi, 15	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	56	\N	'chig':2 'palazz':1	'chig':2B 'palazz':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
908	58	Torre della Branca o Torre della Galliana	42.4168441	12.1051148	Castel d'Asso	Architettura fortificata	NaN	NaN	5400	t	1	55	\N	'branc':3 'gallian':7 'torr':1,5	'branc':3B 'gallian':7B 'torr':1B,5B	0101000020E6100000B3A6689BD1352840E983C0255B354540
909	58	MUSEO NAZIONALE ETRUSCO DI ROCCA ALBORNOZ	42.4216431	12.1044907	Piazza della Rocca; 21/b	Museo, galleria e/o raccolta	0761 325929	sba-em.roccaalbornoz@beniculturali.it	5400	t	1	99	\N	'albornoz':6 'etrusc':3 'muse':1 'nazional':2 'rocc':5	'albornoz':6B 'etrusc':3B 'muse':1B 'nazional':2B 'rocc':5B	0101000020E6100000E87816CE7F352840C28AAE66F8354540
910	58	Biblioteca convento della SS. Trinità dell'Ordine eremitano di S. Agostino	42.4189839	12.0992913	p.zza SS. Trinit?, 8	Biblioteca	+39 0761.342808	marmat47@hotmail.com	10800	t	1	62	\N	'agostin':11 'bibliotec':1 'convent':2 'eremit':8 'ordin':7 's':10 'ss':4 'trinit':5	'agostin':11B 'bibliotec':1B 'convent':2B 'eremit':8B 'ordin':7B 's':10B 'ss':4B 'trinit':5B	0101000020E6100000FE8D2C4FD63228407806B243A1354540
911	58	MUSEO CIVICO	42.4176727	12.1105913	PIAZZA FRANCESCO CRISPI; 2	Museo, galleria e/o raccolta	761348276	museocivico@comune.viterbo.it	5400	t	1	38	\N	'civic':2 'muse':1	'civic':2B 'muse':1B	0101000020E6100000BA71416C9F3828404C778D4C76354540
912	58	MUSEO DEL COLLE DEL DUOMO	42.4156470	12.1016440	PIAZZA S. LORENZO; 8A	Museo, galleria e/o raccolta	3477010187	museocolledelduomo@libero.it	7200	t	1	25	\N	'coll':3 'duom':5 'muse':1	'coll':3B 'duom':5B 'muse':1B	0101000020E610000054ABAFAE0A3428401BD7BFEB33354540
913	58	MUSEO DELLA CERAMICA DELLA TUSCIA	42.4157087	12.1064460	VIA CAVOUR; 67	Museo, galleria e/o raccolta	761346136	laboratorioceramica@libero.it	5400	t	1	74	\N	'ceram':3 'muse':1 'tusc':5	'ceram':3B 'muse':1B 'tusc':5B	0101000020E61000007D94111780362840D39453F135354540
914	58	VILLA LANTE BAGNAIA	42.4240622	12.1539991	VIA JACOPO BAROZZI, 71	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	15	\N	'bagnai':3 'lant':2 'vill':1	'bagnai':3B 'lant':2B 'vill':1B	0101000020E6100000143A54F8D84E2840233C90AB47364540
915	58	Scuderia di Palazzo Nini	42.4168441	12.1051148	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	52	\N	'nin':4 'palazz':3 'scuder':1	'nin':4B 'palazz':3B 'scuder':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
920	58	Palazzo Pagliacci	42.4168441	12.1051148	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	10	\N	'pagliacc':2 'palazz':1	'pagliacc':2B 'palazz':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
921	58	Palazzo Mazzatosta	42.4172780	12.1072507	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	26	\N	'mazzatost':2 'palazz':1	'mazzatost':2B 'palazz':1B	0101000020E61000003BF25190E93628408FAB915D69354540
974	59	Piazzale Umberto I	42.4654270	12.1724620	Piazzale Umberto I	Monumento	NaN	NaN	5400	t	1	15	\N	'piazzal':1 'umbert':2	'piazzal':1B 'umbert':2B	0101000020E6100000029B73F04C58284073D6A71C933B4540
925	58	Orto Botanico dell'Università della Tuscia	42.4168441	12.1051148	NaN	Museo, Galleria e/o raccolta	NaN	NaN	9000	t	1	3	\N	'botan':2 'orto':1 'tusc':6 'univers':4	'botan':2B 'orto':1B 'tusc':6B 'univers':4B	0101000020E6100000B3A6689BD1352840E983C0255B354540
231	16	Parrocchia Sant'Antonio Abate	42.2517755	12.3717955	Via Cancelleria Vecchia, 3	Chiesa o edificio di culto	NaN	NaN	5400	t	1	54	\N	'abat':4 'anton':3 'parrocc':1 'sant':2	'abat':4B 'anton':3B 'parrocc':1B 'sant':2B	0101000020E61000009599D2FA5BBE28408F37F92D3A204540
926	58	"Casa del Barbiere di Paolo III"	42.4168441	12.1051148	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	6	\N	'barb':3 'cas':1 'iii':6 'paol':5	'barb':3B 'cas':1B 'iii':6B 'paol':5B	0101000020E6100000B3A6689BD1352840E983C0255B354540
927	58	Palazzo Sacchi	42.4168441	12.1051148	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	13	\N	'palazz':1 'sacc':2	'palazz':1B 'sacc':2B	0101000020E6100000B3A6689BD1352840E983C0255B354540
928	58	Rocca Albornoz	42.4220064	12.1047309	NaN	Architettura fortificata	NaN	NaN	5400	t	1	9	\N	'albornoz':2 'rocc':1	'albornoz':2B 'rocc':1B	0101000020E6100000E4C2DC499F352840F259434E04364540
929	58	Palazzo Ducale	42.4168441	12.1051148	Bagnaia	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	38	\N	'ducal':2 'palazz':1	'ducal':2B 'palazz':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
930	58	Palazzo Nini	42.4168441	12.1051148	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	38	\N	'nin':2 'palazz':1	'nin':2B 'palazz':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
931	58	ex chiesa di S. Rocco	42.4168441	12.1051148	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	38	\N	'chies':2 'ex':1 'rocc':5 's':4	'chies':2B 'ex':1B 'rocc':5B 's':4B	0101000020E6100000B3A6689BD1352840E983C0255B354540
104	6	Biblioteca comunale	42.2725220	12.0316620	Via Roma 61	Biblioteca	NaN	NaN	3600	t	1	80	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E61000004A0D6D003610284063B83A00E2224540
932	58	MUSEO ERBARIO DELLA TUSCIA (UTV)	42.4265711	12.0896074	VIA S. CAMILLO DE LELLIS; SNC	Museo, galleria e/o raccolta	761357490	erbario@unitus.it	10800	t	1	0	\N	'erbar':2 'muse':1 'tusc':4 'utv':5	'erbar':2B 'muse':1B 'tusc':4B 'utv':5B	0101000020E61000008DF56805E12D284099F5BDE199364540
933	58	Terme Libere Piscine Carletti	42.4168441	12.1051148	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	3600	t	1	62	\N	'carlett':4 'lib':2 'piscin':3 'term':1	'carlett':4B 'lib':2B 'piscin':3B 'term':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
934	58	Palazzo Tedeschi 	42.4168441	12.1051148	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	65	\N	'palazz':1 'tedesc':2	'palazz':1B 'tedesc':2B	0101000020E6100000B3A6689BD1352840E983C0255B354540
935	58	Villa Lante della Rovere	42.4267541	12.1548165	Via Jacopo Barozzi; 71	Museo, galleria e/o raccolta	-	-	9000	t	1	93	\N	'lant':2 'rov':4 'vill':1	'lant':2B 'rov':4B 'vill':1B	0101000020E61000002BC3B81B444F28408A77DBE09F364540
936	58	Chiesa di Santa Maria del Suffragio	42.4168441	12.1051148	Via Fontanella del Suffragio, 10	Chiesa o edificio di culto	NaN	NaN	10800	t	1	95	\N	'chies':1 'mar':4 'sant':3 'suffrag':6	'chies':1B 'mar':4B 'sant':3B 'suffrag':6B	0101000020E6100000B3A6689BD1352840E983C0255B354540
937	58	Chiesa dei Santi Faustino e Giovita	42.4168441	12.1051148	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	1	\N	'chies':1 'faustin':4 'giov':6 'sant':3	'chies':1B 'faustin':4B 'giov':6B 'sant':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
938	58	Chiesa di San Giovanni in Zoccoli	42.4168441	12.1051148	Via Giuseppe Mazzini, 123	Chiesa o edificio di culto	NaN	NaN	7200	t	1	53	\N	'chies':1 'giovann':4 'san':3 'zoccol':6	'chies':1B 'giovann':4B 'san':3B 'zoccol':6B	0101000020E6100000B3A6689BD1352840E983C0255B354540
849	58	Porta San Marco	42.4168441	12.1051148	Via Teatro Nuovo, 48	Architettura fortificata	NaN	NaN	5400	t	1	93	\N	'marc':3 'port':1 'san':2	'marc':3B 'port':1B 'san':2B	0101000020E6100000B3A6689BD1352840E983C0255B354540
948	58	Palazzo dei Papi	42.4156137	12.1007084	Piazza S. Lorenzo, 1-8	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	99	\N	'palazz':1 'pap':3	'palazz':1B 'pap':3B	0101000020E61000006FDD280D9033284081A268D432354540
949	58	CONFRATERNITA SS.SACRAMENTO E S.ROSARIO	42.4157698	12.1133540	PIAZZA ORATORIO 5	Museo, galleria e/o raccolta	761379301	confraternitasanmartino@gmail.com	5400	t	1	42	\N	'confratern':1 's.rosario':4 'ss.sacramento':2	'confratern':1B 's.rosario':4B 'ss.sacramento':2B	0101000020E6100000D7BD1589093A28400DD5DEF137354540
950	58	Viterbo Sotterranea	42.4603608	12.3860395	NaN	Area o parco archeologico	NaN	NaN	5400	t	1	43	\N	'sotterrane':2 'viterb':1	'sotterrane':2B 'viterb':1B	0101000020E6100000ABED26F8A6C52840212E4A1AED3A4540
951	58	Biblioteca dell'Archivio di Stato di Viterbo	42.4109210	12.1102563	Via M. Romiti	Biblioteca	+39 0761342960	NaN	9000	t	1	34	\N	'archiv':3 'bibliotec':1 'stat':5 'viterb':7	'archiv':3B 'bibliotec':1B 'stat':5B 'viterb':7B	0101000020E61000001E5B858373382840AC1E300F99344540
952	58	Biblioteca della Provincia romana presso il Convento di S. Francesco alla Rocca	42.4218866	12.1064028	Piazza S. Francesco alla Rocca, 6	Biblioteca	+39 0761.341696	mallucci@ofmconv.org	9000	t	1	13	\N	'bibliotec':1 'convent':7 'francesc':10 'press':5 'provinc':3 'rocc':12 'roman':4 's':9	'bibliotec':1B 'convent':7B 'francesc':10B 'press':5B 'provinc':3B 'rocc':12B 'roman':4B 's':9B	0101000020E6100000D967846D7A36284071CF4E6100364540
954	58	Biblioteca del Liceo classico statale Mariano Buratti	42.4135803	12.1083063	Via T. Carletti 8	Biblioteca	+39 0761322420	NaN	5400	t	1	73	\N	'bibliotec':1 'buratt':7 'classic':4 'lice':3 'mar':6 'statal':5	'bibliotec':1B 'buratt':7B 'classic':4B 'lice':3B 'mar':6B 'statal':5B	0101000020E6100000CBE660EC733728408B620333F0344540
955	58	Biblioteca Pio XII	42.4292485	12.1280568	Via del Popolo 2	Biblioteca	+39 0761236965	NaN	5400	t	1	51	\N	'bibliotec':1 'pio':2 'xii':3	'bibliotec':1B 'pio':2B 'xii':3B	0101000020E6100000920F30A990412840B4AD669DF1364540
232	16	Castello di Filissano	42.2329720	12.3998550	NaN	Architettura fortificata	NaN	NaN	7200	t	1	20	\N	'castell':1 'filiss':3	'castell':1B 'filiss':3B	0101000020E6100000BF4868CBB9CC28401D71C806D21D4540
956	58	Centro per la biblioteca delle Facoltà di agraria e scienze matematiche, fisiche e naturali dell'Università degli studi della Tuscia - CEBAS	42.4271062	12.0909921	Via S. Camillo De Lellis, snc	Biblioteca	+39 0761357512	agbib@unitus.it	3600	t	1	33	\N	'agrar':8 'bibliotec':4 'cebas':21 'centr':1 'facolt':6 'fisic':12 'matemat':11 'natural':14 'scienz':10 'stud':18 'tusc':20 'univers':16	'agrar':8B 'bibliotec':4B 'cebas':21B 'centr':1B 'facolt':6B 'fisic':12B 'matemat':11B 'natural':14B 'scienz':10B 'stud':18B 'tusc':20B 'univers':16B	0101000020E610000083633B84962E28409C757C6AAB364540
957	58	Biblioteca dell'Accademia di belle arti Lorenzo da Viterbo	42.4172455	12.1071295	Via orologio vecchio	Biblioteca	+39 0761221842	NaN	5400	t	1	11	\N	'accadem':3 'arti':6 'bell':5 'bibliotec':1 'lorenz':7 'viterb':9	'accadem':3B 'arti':6B 'bell':5B 'bibliotec':1B 'lorenz':7B 'viterb':9B	0101000020E6100000A8DF85ADD93628409B73F04C68354540
958	58	Biblioteca San Paolo dei frati minori cappuccini della Provincia Romana	42.4190200	12.1154100	Via S. Crispino 6	Biblioteca	NaN	roma.bibliotecaprovinciale@fraticappuccini.it	10800	t	1	4	\N	'bibliotec':1 'cappuccin':7 'frat':5 'minor':6 'paol':3 'provinc':9 'roman':10 'san':2	'bibliotec':1B 'cappuccin':7B 'frat':5B 'minor':6B 'paol':3B 'provinc':9B 'roman':10B 'san':2B	0101000020E61000004243FF04173B28405A2F8672A2354540
959	58	Biblioteca provinciale Anselmo Anselmi	42.4249650	12.1058200	Viale Trento, presso Palazzo Garbini	Biblioteca	+39 0761228162	biblioteca-ardenti@libero.it	3600	t	1	48	\N	'anselm':3,4 'bibliotec':1 'provincial':2	'anselm':3B,4B 'bibliotec':1B 'provincial':2B	0101000020E61000008386FE092E362840EA78CC4065364540
960	58	Biblioteca della Camera di commercio, industria, artigianato e agricoltura - CCIAA	42.4211132	12.1083127	Via Fratelli Rosselli 4	Biblioteca	+39 0761341151	NaN	3600	t	1	18	\N	'agricoltur':9 'artigian':7 'bibliotec':1 'camer':3 'ccia':10 'commerc':5 'industr':6	'agricoltur':9B 'artigian':7B 'bibliotec':1B 'camer':3B 'ccia':10B 'commerc':5B 'industr':6B	0101000020E6100000A17B20C374372840FBF48E09E7354540
98	6	MUSEO CIVICO GUSTAVO VI ADOLFO DI SVEZIA - SEZIONE IL CAVALLO E L'UOMO	42.2759082	12.0254639	VIA UMBERTO I; SNC	Museo, galleria e/o raccolta	761471057	info_museoblera@yahoo.it	5400	t	1	66	\N	'adolf':5 'cavall':10 'civic':2 'gust':3 'muse':1 'sezion':8 'svez':7 'uom':13	'adolf':5B 'cavall':10B 'civic':2B 'gust':3B 'muse':1B 'sezion':8B 'svez':7B 'uom':13B	0101000020E61000000D75B39A090D284060D9BBF550234540
99	6	Palazzo dell'Asino Vecchio (detto)	42.2725220	12.0316620	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	1	\N	'asin':3 'dett':5 'palazz':1 'vecc':4	'asin':3B 'dett':5B 'palazz':1B 'vecc':4B	0101000020E61000004A0D6D003610284063B83A00E2224540
964	58	Biblioteca della Facoltà di conservazione dei beni culturali dell'Università degli studi della Tuscia	42.4271712	12.0861119	Largo dell'Universit?	Biblioteca	+39 0761357183	bcbib@unitus.it	3600	t	1	17	\N	'ben':7 'bibliotec':1 'conserv':5 'cultural':8 'facolt':3 'stud':12 'tusc':14 'univers':10	'ben':7B 'bibliotec':1B 'conserv':5B 'cultural':8B 'facolt':3B 'stud':12B 'tusc':14B 'univers':10B	0101000020E6100000C597E4DB162C284083E5BE8BAD364540
8	1	Casale Putifaro	42.7439961	11.8649880	Putifaro	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	38	\N	'casal':1 'putifar':2	'casal':1B 'putifar':2B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
965	58	Biblioteca della Facoltà di lingue e letterature straniere dell'Università degli studi della Tuscia	42.4271712	12.0861119	Largo dell'Universit?	Biblioteca	+39 0761357655	marling@unitus.it	7200	t	1	13	\N	'bibliotec':1 'facolt':3 'letteratur':7 'lingu':5 'stran':8 'stud':12 'tusc':14 'univers':10	'bibliotec':1B 'facolt':3B 'letteratur':7B 'lingu':5B 'stran':8B 'stud':12B 'tusc':14B 'univers':10B	0101000020E6100000C597E4DB162C284083E5BE8BAD364540
969	59	Palazzo Comunale di Vitorchiano	42.4654270	12.1724620	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	36	\N	'comunal':2 'palazz':1 'vitorc':4	'comunal':2B 'palazz':1B 'vitorc':4B	0101000020E6100000029B73F04C58284073D6A71C933B4540
970	59	Chiesa Santa Maria Assunta in Cielo	42.4654270	12.1724620	Via S. Maria, 11	Chiesa o edificio di culto	NaN	NaN	10800	t	1	84	\N	'assunt':4 'chies':1 'ciel':6 'mar':3 'sant':2	'assunt':4B 'chies':1B 'ciel':6B 'mar':3B 'sant':2B	0101000020E6100000029B73F04C58284073D6A71C933B4540
972	59	Chiesa della Santissima Trinità	42.4654270	12.1724620	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	63	\N	'chies':1 'santissim':3 'trinit':4	'chies':1B 'santissim':3B 'trinit':4B	0101000020E6100000029B73F04C58284073D6A71C933B4540
973	59	Fontana a Fuso	42.4654270	12.1724620	Piazza Roma, 18	Monumento	NaN	NaN	9000	t	1	49	\N	'fontan':1 'fus':3	'fontan':1B 'fus':3B	0101000020E6100000029B73F04C58284073D6A71C933B4540
233	16	Castello di Ischi (o Castel Sant'Elia)	42.2517755	12.3717955	NaN	Architettura fortificata	NaN	NaN	10800	t	1	13	\N	'castel':5 'castell':1 'eli':7 'ischi':3 'sant':6	'castel':5B 'castell':1B 'eli':7B 'ischi':3B 'sant':6B	0101000020E61000009599D2FA5BBE28408F37F92D3A204540
1	1	MUSEO DEL FIORE	42.7477229	11.8630202	PREDIO GIARDINO; 37	Museo, galleria e/o raccolta	763733642	info@museodelfiore.it	9000	t	1	75	Il Museo del Fiore è un piccolo museo interattivo e multimediale immerso nei boschi della Riserva naturale Monte Rufeno, si trova a 10 km dal centro abitato di Acquapendente e a 2 km dal borgo medievale di Torre Alfina. È stato realizzato all'interno del casale Giardino, un vecchio edificio rurale. Con oltre 1.000[1] specie di piante riconosciute nel suo territorio e animali rari, la Riserva naturale di Monte Rufeno, al confine con l'Umbria e la Toscana, è un'area a elevatissima varietà floristica e faunistica. La nascita del museo è da attribuire alle numerose fioriture della Riserva e dal profondo legame che i fiori e le piante hanno con la cultura locale, che si concretizza con i Pugnaloni, grandi mosaici di petali e foglie ispirati al desiderio di libertà dall'oppressione. C'è, inoltre, la possibilità di visitare, proprio dietro il castello di Torre Alfina, il Bosco del Sasseto. Il museo è impostato come un racconto che permette di apprezzare la biodiversità della riserva, i meccanismi che l'hanno determinata, e di condurre nel mondo del fiore, i rapporti con il mondo animale e con il mondo dell'uomo e fa parte del Sistema Regionale Museale del Lago di Bolsena che comprende vari musei archeologici, storici e demo-antropologici.	'1':57 '1.000':56 '10':25 '2':34 'abit':29 'acquapendent':31 'alfin':41,150 'animal':66,188 'antropolog':215 'apprezz':165 'archeolog':210 'are':84 'attribu':97 'biodivers':167 'bolsen':205 'borg':37 'bosc':16,152 'casal':48 'castell':147 'centr':28 'compr':207 'concretizz':120 'condurr':178 'confin':75 'cultur':116 'dem':214 'demo-antropolog':213 'desider':132 'determin':175 'dietr':145 'edific':52 'elevatissim':86 'fa':196 'faunist':90 'fior':6,109,182 'fioreil':3 'fioritur':100 'florist':88 'fogl':129 'giardin':49 'grand':124 'immers':14 'impost':158 'inoltr':139 'interatt':11 'intern':46 'ispir':130 'km':26,35 'lag':203 'legam':106 'libert':134 'local':117 'meccan':171 'medieval':38 'mond':180,187,192 'mont':20,72 'mosaic':125 'multimedial':13 'muse':1,4,10,94,156,209 'museal':201 'nasc':92 'natural':19,70 'numer':99 'oltre':55 'oppression':136 'part':197 'permett':163 'petal':127 'piant':60,112 'piccol':9 'possibil':141 'profond':105 'propr':144 'pugnalon':123 'raccont':161 'rapport':184 'rar':67 'realizz':44 'regional':200 'riconosc':61 'riserv':18,69,102,169 'rufen':21,73 'rural':53 'sasset':154 'sistem':199 'spec':58 'stat':43 'storic':211 'territor':64 'torr':40,149 'toscan':81 'trov':23 'umbri':78 'uom':194 'var':208 'variet':87 'vecc':51 'visit':143	'1':58A '1.000':57A '10':26A '2':35A 'abit':30A 'acquapendent':32A 'alfin':42A,151A 'animal':67A,189A 'antropolog':216A 'apprezz':166A 'archeolog':211A 'are':85A 'attribu':98A 'biodivers':168A 'bolsen':206A 'borg':38A 'bosc':17A,153A 'casal':49A 'castell':148A 'centr':29A 'compr':208A 'concretizz':121A 'condurr':179A 'confin':76A 'cultur':117A 'dem':215A 'demo-antropolog':214A 'desider':133A 'determin':176A 'dietr':146A 'edific':53A 'elevatissim':87A 'fa':197A 'faunist':91A 'fior':3B,7A,110A,183A 'fioritur':101A 'florist':89A 'fogl':130A 'giardin':50A 'grand':125A 'immers':15A 'impost':159A 'inoltr':140A 'interatt':12A 'intern':47A 'ispir':131A 'km':27A,36A 'lag':204A 'legam':107A 'libert':135A 'local':118A 'meccan':172A 'medieval':39A 'mond':181A,188A,193A 'mont':21A,73A 'mosaic':126A 'multimedial':14A 'muse':1B,5A,11A,95A,157A,210A 'museal':202A 'nasc':93A 'natural':20A,71A 'numer':100A 'oltre':56A 'oppression':137A 'part':198A 'permett':164A 'petal':128A 'piant':61A,113A 'piccol':10A 'possibil':142A 'profond':106A 'propr':145A 'pugnalon':124A 'raccont':162A 'rapport':185A 'rar':68A 'realizz':45A 'regional':201A 'riconosc':62A 'riserv':19A,70A,103A,170A 'rufen':22A,74A 'rural':54A 'sasset':155A 'sistem':200A 'spec':59A 'stat':44A 'storic':212A 'territor':65A 'torr':41A,150A 'toscan':82A 'trov':24A 'umbri':79A 'uom':195A 'var':209A 'variet':88A 'vecc':52A 'visit':144A	0101000020E610000023939DC8DDB9274032FC4C62B55F4540
626	48	Chiesa della Misericordia	42.4187606	12.2343075	Vicolo della Misericordia, 161	Chiesa o edificio di culto	NaN	NaN	9000	t	1	25	\N	'chies':1 'misericord':3	'chies':1B 'misericord':3B	0101000020E6100000406A1327F77728403AED84F299354540
696	50	Porta Nuova	42.2532394	11.7591747	NaN	Architettura fortificata	NaN	NaN	10800	t	1	84	\N	'nuov':2 'port':1	'nuov':2B 'port':1B	0101000020E6100000B7E6D88BB284274082870E266A204540
899	58	Fontana dei Mori	42.4260726	12.1553664	Parco Di Villa Lante	Monumento	NaN	NaN	10800	t	1	41	\N	'fontan':1 'mor':3	'fontan':1B 'mor':3B	0101000020E610000065CB4D2F8C4F2840605C058C89364540
59	2	Convento di Sant' Agostino	42.6269800	12.0908718	Piazza Sant'Agostino, 131	Chiesa o edificio di culto	NaN	NaN	10800	t	1	83	La chiesa dell'Annunziata, detta anche erroneamente di Sant'Agostino, è una chiesa di Bagnoregio, nella diocesi di Viterbo.\n\nTrasformata, nel XIV secolo, dalle originarie forme romaniche in gotiche, conserva all'interno dei pregevoli affreschi cinquecenteschi (alcuni attribuiti a Taddeo di Bartolo e a Giovanni di Paolo) e un crocefisso ligneo dell'XI secolo.\n\nIl campanile risale al 1735.\n\nAdiacente all'edificio è presente un chiostro, realizzato interamente in cotto da Ippolito Scalza su progetto di Michele Sanmicheli.\n\nLa chiesa è dedicata a Maria Santissima Annunziata, benché sia comunemente ed erroneamente chiamata di sant'Agostino, per la presenza, nelle adiacenze, dell'antico convento degli agostiniani.\n\nSul lato destro della controfacciata si trova il sepolcro di Vincenzo Bonaventura Medori, vescovo di Calvi e Teano.	'1735':62 'adiacent':63,103 'affresc':38 'agostin':13,98 'agostinian':108 'agostinol':4 'alcun':40 'annunz':7,89 'antic':105 'attribu':41 'bagnoreg':18 'bartol':45 'benc':90 'bonaventur':120 'calv':124 'campanil':59 'chiam':95 'chies':5,16,83 'chiostr':69 'cinquecentesc':39 'comun':92 'conserv':33 'controfacc':113 'convent':1,106 'cott':73 'crocefiss':53 'dedic':85 'destr':111 'dett':8 'dioces':20 'edific':65 'erron':10,94 'form':29 'giovann':48 'gotic':32 'inter':71 'intern':35 'ippol':75 'lat':110 'ligne':54 'mar':87 'medor':121 'michel':80 'originar':28 'paol':50 'pregevol':37 'present':67 'presenz':101 'progett':78 'realizz':70 'risal':60 'roman':30 'sanmichel':81 'sant':3,12,97 'santissim':88 'scalz':76 'secol':26,57 'sepolcr':117 'tadde':43 'tean':126 'trasform':23 'trov':115 'vescov':122 'vincenz':119 'viterb':22 'xi':56 'xiv':25	'1735':63A 'adiacent':64A,104A 'affresc':39A 'agostin':4B,14A,99A 'agostinian':109A 'alcun':41A 'annunz':8A,90A 'antic':106A 'attribu':42A 'bagnoreg':19A 'bartol':46A 'benc':91A 'bonaventur':121A 'calv':125A 'campanil':60A 'chiam':96A 'chies':6A,17A,84A 'chiostr':70A 'cinquecentesc':40A 'comun':93A 'conserv':34A 'controfacc':114A 'convent':1B,107A 'cott':74A 'crocefiss':54A 'dedic':86A 'destr':112A 'dett':9A 'dioces':21A 'edific':66A 'erron':11A,95A 'form':30A 'giovann':49A 'gotic':33A 'inter':72A 'intern':36A 'ippol':76A 'lat':111A 'ligne':55A 'mar':88A 'medor':122A 'michel':81A 'originar':29A 'paol':51A 'pregevol':38A 'present':68A 'presenz':102A 'progett':79A 'realizz':71A 'risal':61A 'roman':31A 'sanmichel':82A 'sant':3B,13A,98A 'santissim':89A 'scalz':77A 'secol':27A,58A 'sepolcr':118A 'tadde':44A 'tean':127A 'trasform':24A 'trov':116A 'vescov':123A 'vincenz':120A 'viterb':23A 'xi':57A 'xiv':26A	0101000020E6100000DF41A2BF862E2840809F71E140504540
83	4	Villa Giustiniani Odescalchi	42.2182424	12.1925906	Piazza Umberto I	Museo, galleria e/o raccolta	0761 636065	-	10800	t	1	50	Il palazzo Giustiniani Odescalchi, ceduto allo Stato italiano dalla famiglia Odescalchi di Bracciano nel 2003, è il risultato delle trasformazioni applicate sull'antico castello degli Anguillara nei primi anni del '600. Risale al tempo degli Anguillara il piano interrato e il piano terra mentre il portale d'ingresso è simile al portale del palazzo Farnese a Roma. Nel 1595 il palazzo divenne di proprietà della famiglia Giustiniani che avvia i lavori di ristrutturazione e trasformazione, aggiungendo il piano nobile (collegandolo con il giardino all'italiana) e finanziando un ampliamento del giardino con fontane, viali e giochi d'acqua.\n\nA loro si debbono anche le decorazioni tardo cinquecentesche e gli affreschi di Antonio Tempesta (1555-1630). Al piano terra è collocato un pregevole teatrino, unico nel suo genere. Al piano nobile, si possono ammirare gli straordinari esempi di pittura Barocca: notevole la sala dipinta da Francesco Albani (1578-1660) con la "Caduta di Fetonte dal carro", la sala del Domenichino (1581-1641) e gli affreschi di Bernardo Castello (1557-1629).	'-1629':171 '-1630':117 '-1641':163 '-1660':150 '1555':116 '1557':170 '1578':149 '1581':162 '1595':61 '2003':17 '600':33 'acqua':100 'affresc':112,166 'aggiung':78 'alban':148 'ammir':135 'ampli':91 'anguillar':28,38 'anni':31 'antic':25 'anton':114 'applic':23 'avvi':71 'barocc':141 'bernard':168 'bracc':15 'cad':153 'carr':157 'castell':26,169 'ced':7 'cinquecentesc':109 'colleg':82 'colloc':122 'd':49,99 'debb':104 'decor':107 'dipint':145 'divenn':64 'domenichin':161 'esemp':138 'famigl':12,68 'farnes':57 'fetont':155 'finanz':89 'fontan':95 'francesc':147 'gen':129 'giardin':85,93 'gioc':98 'giustinian':2,5,69 'ingress':50 'interr':41 'ital':10 'italian':87 'lavor':73 'mentr':46 'nobil':81,132 'notevol':142 'odescalc':6,13 'odescalchiil':3 'palazz':4,56,63 'pian':40,44,80,119,131 'pittur':140 'portal':48,54 'poss':134 'pregevol':124 'prim':30 'propriet':66 'risal':34 'ristruttur':75 'risult':20 'rom':59 'sal':144,159 'simil':52 'stat':9 'straordinar':137 'tard':108 'teatrin':125 'temp':36 'tempest':115 'terr':45,120 'trasform':22,77 'unic':126 'vial':96 'vill':1	'-1629':172A '-1630':118A '-1641':164A '-1660':151A '1555':117A '1557':171A '1578':150A '1581':163A '1595':62A '2003':18A '600':34A 'acqua':101A 'affresc':113A,167A 'aggiung':79A 'alban':149A 'ammir':136A 'ampli':92A 'anguillar':29A,39A 'anni':32A 'antic':26A 'anton':115A 'applic':24A 'avvi':72A 'barocc':142A 'bernard':169A 'bracc':16A 'cad':154A 'carr':158A 'castell':27A,170A 'ced':8A 'cinquecentesc':110A 'colleg':83A 'colloc':123A 'd':50A,100A 'debb':105A 'decor':108A 'dipint':146A 'divenn':65A 'domenichin':162A 'esemp':139A 'famigl':13A,69A 'farnes':58A 'fetont':156A 'finanz':90A 'fontan':96A 'francesc':148A 'gen':130A 'giardin':86A,94A 'gioc':99A 'giustinian':2B,6A,70A 'ingress':51A 'interr':42A 'ital':11A 'italian':88A 'lavor':74A 'mentr':47A 'nobil':82A,133A 'notevol':143A 'odescalc':3B,7A,14A 'palazz':5A,57A,64A 'pian':41A,45A,81A,120A,132A 'pittur':141A 'portal':49A,55A 'poss':135A 'pregevol':125A 'prim':31A 'propriet':67A 'risal':35A 'ristruttur':76A 'risult':21A 'rom':60A 'sal':145A,160A 'simil':53A 'stat':10A 'straordinar':138A 'tard':109A 'teatrin':126A 'temp':37A 'tempest':116A 'terr':46A,121A 'trasform':23A,78A 'unic':127A 'vial':97A 'vill':1B	0101000020E6100000B708313C9B622840DF4CF15DEF1B4540
101	6	Castello di Vico	42.2725220	12.0316620	Vico	Architettura fortificata	NaN	NaN	9000	t	1	47	Castello medievale del XII secolo, attualmente divorato dalla vegetazione e parzialmente crollato. Fondato dai Di Vico, probabilmente è rappresentato in una sezione dell'abside di Santa Maria in Trastevere, da un mosaico del Cavallini. E' situato nei pressi di una necropoli e di resti di abitato etrusco, in una zona di campagna della Tuscia di particolare bellezza.	'abit':48 'absid':26 'attual':8 'bellezz':59 'campagn':54 'castell':1 'cavallin':36 'croll':14 'divor':9 'etrusc':49 'fond':15 'mar':29 'medieval':4 'mosaic':34 'necropol':43 'particol':58 'parzial':13 'press':40 'probabil':19 'rappresent':21 'rest':46 'sant':28 'secol':7 'sezion':24 'situ':38 'trastev':31 'tusc':56 'veget':11 'vic':18 'vicocastell':3 'xii':6 'zon':52	'abit':49A 'absid':27A 'attual':9A 'bellezz':60A 'campagn':55A 'castell':1B,4A 'cavallin':37A 'croll':15A 'divor':10A 'etrusc':50A 'fond':16A 'mar':30A 'medieval':5A 'mosaic':35A 'necropol':44A 'particol':59A 'parzial':14A 'press':41A 'probabil':20A 'rappresent':22A 'rest':47A 'sant':29A 'secol':8A 'sezion':25A 'situ':39A 'trastev':32A 'tusc':57A 'veget':12A 'vic':3B,19A 'xii':7A 'zon':53A	0101000020E61000004A0D6D003610284063B83A00E2224540
200	13	Santuario della Madonna del Piano	42.2564918	12.1776114	Viale Nardini, 17	Chiesa o edificio di culto	NaN	NaN	9000	t	1	16	Il tempio sorge appena fuori il centro abitato di Capranica, in località detta “il Piano” con evidente allusione alla caratteristica morfologica del sito. La chiesa primitiva, la cui presenza è già documentata nel  XIV secolo, ospitava il miracoloso affresco della Vergine che oggi si scorge sulla parete di fondo dell’altare maggiore.	'abit':12 'affresc':43 'allusion':22 'altar':55 'appen':8 'capran':14 'caratterist':24 'centr':11 'chies':29 'dett':17 'document':36 'evident':21 'fond':53 'fuor':9 'già':35 'local':16 'madonn':3 'maggior':56 'miracol':42 'morfolog':25 'oggi':47 'ospit':40 'par':51 'pian':19 'pianoil':5 'presenz':33 'primit':30 'santuar':1 'scorg':49 'secol':39 'sit':27 'sorg':7 'temp':6 'vergin':45 'xiv':38	'abit':13A 'affresc':44A 'allusion':23A 'altar':56A 'appen':9A 'capran':15A 'caratterist':25A 'centr':12A 'chies':30A 'dett':18A 'document':37A 'evident':22A 'fond':54A 'fuor':10A 'già':36A 'local':17A 'madonn':3B 'maggior':57A 'miracol':43A 'morfolog':26A 'oggi':48A 'ospit':41A 'par':52A 'pian':5B,20A 'presenz':34A 'primit':31A 'santuar':1B 'scorg':50A 'secol':40A 'sit':28A 'sorg':8A 'temp':7A 'vergin':46A 'xiv':39A	0101000020E610000026CBA4E1EF5A284099582AB9D4204540
147	8	PARCO DEI MOSTRI; SACRO BOSCO DI BOMARZO	42.4916599	12.2475933	-	Museo, galleria e/o raccolta	761924029	boscosacro@interfree.it	9000	t	1	32	Il Parco dei Mostri, denominato anche Sacro Bosco o Villa delle Meraviglie di Bomarzo, in provincia di Viterbo, è un complesso monumentale italiano. Si tratta di un parco naturale ornato da numerose sculture in basalto risalenti al XVI secolo e ritraenti animali mitologici, divinità e mostri.	'animal':48 'basalt':41 'bomarz':20 'bomarzoil':7 'bosc':5,14 'compless':27 'denomin':11 'divin':50 'ital':29 'meravigl':18 'mitolog':49 'monumental':28 'mostr':3,10,52 'natural':35 'numer':38 'ornat':36 'parc':1,8,34 'provinc':22 'risalent':42 'ritraent':47 'sacr':4,13 'scultur':39 'secol':45 'tratt':31 'vill':16 'viterb':24 'xvi':44	'animal':49A 'basalt':42A 'bomarz':7B,21A 'bosc':5B,15A 'compless':28A 'denomin':12A 'divin':51A 'ital':30A 'meravigl':19A 'mitolog':50A 'monumental':29A 'mostr':3B,11A,53A 'natural':36A 'numer':39A 'ornat':37A 'parc':1B,9A,35A 'provinc':23A 'risalent':43A 'ritraent':48A 'sacr':4B,14A 'scultur':40A 'secol':46A 'tratt':32A 'vill':17A 'viterb':25A 'xvi':45A	0101000020E6100000DD6A8C8CC47E284098A02BB6EE3E4540
183	11	Tomba Francois	42.4241163	11.6310953	Parco archeologico di Vulci	Museo, galleria e/o raccolta	0761 437787	sba-em@beniculturali.it	3600	t	1	7	La tomba François è uno dei più importanti monumenti etruschi (340-330 a.C.[1]), soprattutto per la sua ricchissima decorazione ad affresco che ne fa una delle più straordinarie manifestazioni della pittura etrusca. Si trova nella necropoli di Ponte Rotto a Vulci, provincia di Viterbo, e fu scoperta nell'aprile 1857 dall'archeologo e Commissario regio di Guerra e Marina del Granducato di Toscana Alessandro François a cui fu intitolata. Il ciclo di affreschi, staccato dalle pareti e suddiviso in pannelli su ordine del Principe Alessandro Torlonia, fu trasportato nel 1863 a Roma, presso Villa Albani.[2] Il sepolcro appartenne alla famiglia etrusca dei Saties di Vulci, una delle più grandi famiglie aristocratiche della città. La tomba François, con i suoi affreschi, contrappone temi troiani a temi di storia eroica vulcente all'interno di un contesto volutamente antiromano.[3] Attualmente è visitabile rivolgendosi presso la biglietteria del Parco Naturalistico ed Archeologico di Vulci. Il ciclo pittorico resta invece privato e visibile solo in rarissime occasioni di mostre temporanee.	'-330':13 '1':15 '1857':52 '1863':92 '2':98 '3':140 '340':12 'a.c':14 'affresc':23,75,123 'alban':97 'alessandr':66,87 'antirom':139 'appartenn':101 'april':51 'archeolog':54,152 'aristocrat':114 'attual':141 'biglietter':147 'cicl':73,156 'citt':116 'commissar':56 'contest':137 'contrappon':124 'decor':21 'eroic':131 'etrusc':11,34,104 'fa':26 'famigl':103,113 'francoisl':2 'françois':4,67,119 'grand':112 'granduc':63 'guerr':59 'import':9 'intern':134 'intitol':71 'invec':159 'manifest':31 'marin':61 'monument':10 'mostr':168 'naturalist':150 'necropol':38 'occasion':166 'ordin':84 'pannell':82 'parc':149 'paret':78 'pittor':157 'pittur':33 'pont':40 'press':95,145 'princip':86 'priv':160 'provinc':44 'rarissim':165 'reg':57 'rest':158 'ricchissim':20 'rivolg':144 'rom':94 'rott':41 'saties':106 'scopert':49 'sepolcr':100 'sol':163 'soprattutt':16 'stacc':76 'stor':130 'straordinar':30 'suddivis':80 'tem':125,128 'temporane':169 'tomb':1,3,118 'torlon':88 'toscan':65 'trasport':90 'troian':126 'trov':36 'vill':96 'visibil':162 'visit':143 'viterb':46 'volut':138 'vulc':43,108,154 'vulcent':132	'-330':14A '1':16A '1857':53A '1863':93A '2':99A '3':141A '340':13A 'a.c':15A 'affresc':24A,76A,124A 'alban':98A 'alessandr':67A,88A 'antirom':140A 'appartenn':102A 'april':52A 'archeolog':55A,153A 'aristocrat':115A 'attual':142A 'biglietter':148A 'cicl':74A,157A 'citt':117A 'commissar':57A 'contest':138A 'contrappon':125A 'decor':22A 'eroic':132A 'etrusc':12A,35A,105A 'fa':27A 'famigl':104A,114A 'francois':2B 'françois':5A,68A,120A 'grand':113A 'granduc':64A 'guerr':60A 'import':10A 'intern':135A 'intitol':72A 'invec':160A 'manifest':32A 'marin':62A 'monument':11A 'mostr':169A 'naturalist':151A 'necropol':39A 'occasion':167A 'ordin':85A 'pannell':83A 'parc':150A 'paret':79A 'pittor':158A 'pittur':34A 'pont':41A 'press':96A,146A 'princip':87A 'priv':161A 'provinc':45A 'rarissim':166A 'reg':58A 'rest':159A 'ricchissim':21A 'rivolg':145A 'rom':95A 'rott':42A 'saties':107A 'scopert':50A 'sepolcr':101A 'sol':164A 'soprattutt':17A 'stacc':77A 'stor':131A 'straordinar':31A 'suddivis':81A 'tem':126A,129A 'temporane':170A 'tomb':1B,4A,119A 'torlon':89A 'toscan':66A 'trasport':91A 'troian':127A 'trov':37A 'vill':97A 'visibil':163A 'visit':144A 'viterb':47A 'volut':139A 'vulc':44A,109A,155A 'vulcent':133A	0101000020E6100000915154EC1E432740AB19637149364540
100	6	Ex Chiesa di S. Nicola	42.2725220	12.0316620	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	81	\N	'chies':2 'ex':1 'nicol':5 's':4	'chies':2B 'ex':1B 'nicol':5B 's':4B	0101000020E61000004A0D6D003610284063B83A00E2224540
946	58	Chiesa Della Visitazione (o Della Duchessa)	42.4168441	12.1051148	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	56	\N	'chies':1 'duchess':6 'visit':3	'chies':1B 'duchess':6B 'visit':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
155	9	Giardino Portoghesi-Massobrio	42.2197263	12.4259417	Via Luigi Cadorna, 59	Parco o Giardino di interesse storico o artistico	NaN	NaN	9000	t	1	70	Il Giardino Portoghesi si trova a Calcata (VT), affacciato sul vallone del Treja e sull’omonimo borgo. È stato creato nel 1990 dall’architetto e storico dell’architettura, e in particolare grande studioso del barocco, Paolo Portoghesi assieme alla moglie Giovanna Massobrio.\n\nNominato “il parco più bello” del 2017, si estende per tre ettari. Portoghesi l’ha ideato come un luogo dei ricordi, lasciando che fosse la natura ha suggerire l’architettura. Dopo un grande uovo all’ingresso, simbolo della vita e del suo rinnovamento cosmico, si apre il giardino, ricco di alberi, fra cui ulivi centenari e antichi alberi da frutto, arbusti, perenni da fiore. Un centinaio di leggii distribuiti nei diversi punti, riportano testi letterari e filosofici. Al centro, un tempietto circolare, circondato da un canale e da un piccolo bosco di lecci. Fra i vari elementi architettonici presenti, anche la Biblioteca dell’Angelo, all’interno di una piccola casa caratteristica di Calcata, dove sono custoditi preziosi volumi e souvenir raccolti in giro per il mondo.\n\nPresenza importante del luogo sono gli animali, alcuni salvati da morte certa dai proprietari: moltissimi uccelli acquatici, rare anatre, oche delle Hawaii e persino due pellicani nei pressi del laghetto; fenicotteri, ibis, cicogne, pappagalli e varie specie di gru, ospitati in ampie gabbie, un gufo addomesticato e molti altri uccelli (n totale sono 700) che vivono liberi nel parco; e poi capre, lama ed asini, fra cui gli amiatini e quelli bianchi dell’Asinara: la signora Giovanna ha messo su un allevamento di varie razze in via di estinzione.	'1990':25 '2017':52 '700':225 'acquat':188 'addomestic':217 'affacc':12 'alber':96,103 'alcun':179 'allev':253 'altri':220 'amiatin':240 'ampi':213 'anatr':190 'angel':149 'animal':178 'antic':102 'apre':91 'arbust':106 'architett':27 'architetton':143 'architettur':31,75 'asin':236 'asinar':245 'assiem':41 'barocc':38 'bell':50 'bianc':243 'bibliotec':147 'borg':20 'bosc':136 'calc':10,158 'canal':131 'capr':233 'caratterist':156 'cas':155 'centenar':100 'centinai':111 'centr':124 'cert':183 'cicogn':204 'circol':127 'circond':128 'cosmic':89 'cre':23 'custod':161 'distribu':114 'div':116 'dop':76 'due':196 'element':142 'estend':54 'estinzion':260 'ettar':57 'fenicotter':202 'filosof':122 'fior':109 'fra':97,139,237 'frutt':105 'gabb':214 'giardin':1,5,93 'giovann':44,248 'gir':168 'grand':35,78 'gru':210 'guf':216 'hawai':193 'ibis':203 'ide':61 'import':173 'ingress':81 'intern':151 'laghett':201 'lam':234 'lasc':67 'lecc':138 'legg':113 'letterar':120 'liber':228 'luog':64,175 'massobr':45 'massobrioil':4 'mess':250 'mogl':43 'molt':219 'moltissim':186 'mond':171 'mort':182 'n':222 'natur':71 'nomin':46 'oche':191 'omonim':19 'ospit':211 'paol':39 'pappagall':205 'parc':48,230 'particol':34 'pellican':197 'perenn':107 'persin':195 'piccol':135,154 'poi':232 'portoghes':3,6,40,58 'portoghesi-massobrioil':2 'present':144 'presenz':172 'press':199 'prezios':162 'proprietar':185 'punt':117 'raccolt':166 'rar':189 'razz':256 'ricc':94 'ricord':66 'rinnov':88 'riport':118 'salv':180 'signor':247 'simbol':82 'souven':165 'spec':208 'stat':22 'storic':29 'studios':36 'sugger':73 'tempiett':126 'test':119 'total':223 'tre':56 'trej':16 'trov':8 'uccell':187,221 'uliv':99 'uov':79 'vallon':14 'var':141,207,255 'via':258 'vit':84 'viv':227 'volum':163 'vt':11	'1990':26A '2017':53A '700':226A 'acquat':189A 'addomestic':218A 'affacc':13A 'alber':97A,104A 'alcun':180A 'allev':254A 'altri':221A 'amiatin':241A 'ampi':214A 'anatr':191A 'angel':150A 'animal':179A 'antic':103A 'apre':92A 'arbust':107A 'architett':28A 'architetton':144A 'architettur':32A,76A 'asin':237A 'asinar':246A 'assiem':42A 'barocc':39A 'bell':51A 'bianc':244A 'bibliotec':148A 'borg':21A 'bosc':137A 'calc':11A,159A 'canal':132A 'capr':234A 'caratterist':157A 'cas':156A 'centenar':101A 'centinai':112A 'centr':125A 'cert':184A 'cicogn':205A 'circol':128A 'circond':129A 'cosmic':90A 'cre':24A 'custod':162A 'distribu':115A 'div':117A 'dop':77A 'due':197A 'element':143A 'estend':55A 'estinzion':261A 'ettar':58A 'fenicotter':203A 'filosof':123A 'fior':110A 'fra':98A,140A,238A 'frutt':106A 'gabb':215A 'giardin':1B,6A,94A 'giovann':45A,249A 'gir':169A 'grand':36A,79A 'gru':211A 'guf':217A 'hawai':194A 'ibis':204A 'ide':62A 'import':174A 'ingress':82A 'intern':152A 'laghett':202A 'lam':235A 'lasc':68A 'lecc':139A 'legg':114A 'letterar':121A 'liber':229A 'luog':65A,176A 'massobr':4B,46A 'mess':251A 'mogl':44A 'molt':220A 'moltissim':187A 'mond':172A 'mort':183A 'n':223A 'natur':72A 'nomin':47A 'oche':192A 'omonim':20A 'ospit':212A 'paol':40A 'pappagall':206A 'parc':49A,231A 'particol':35A 'pellican':198A 'perenn':108A 'persin':196A 'piccol':136A,155A 'poi':233A 'portoghes':3B,7A,41A,59A 'portoghesi-massobr':2B 'present':145A 'presenz':173A 'press':200A 'prezios':163A 'proprietar':186A 'punt':118A 'raccolt':167A 'rar':190A 'razz':257A 'ricc':95A 'ricord':67A 'rinnov':89A 'riport':119A 'salv':181A 'signor':248A 'simbol':83A 'souven':166A 'spec':209A 'stat':23A 'storic':30A 'studios':37A 'sugger':74A 'tempiett':127A 'test':120A 'total':224A 'tre':57A 'trej':17A 'trov':9A 'uccell':188A,222A 'uliv':100A 'uov':80A 'vallon':15A 'var':142A,208A,256A 'via':259A 'vit':85A 'viv':228A 'volum':164A 'vt':12A	0101000020E61000005A01CF0715DA28401949CCFD1F1C4540
118	7	Lago di Bolsena	42.5925074	11.9287501	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	10800	t	1	22	Il lago di Bolsena o Volsinio (in latino: Lacus Volsiniensis / Lacus Volsinii) è un lago dell'Italia centrale, posto nell'alto Lazio, nella parte settentrionale della provincia di Viterbo (Alta Tuscia). Formatosi oltre 300 000 anni fa in seguito al collasso calderico di alcuni vulcani del complesso dei monti Volsini che ha accompagnato lo sprofondamento vulcano-tettonico dell'area, è lambito per una parte considerevole dalla strada consolare Cassia, a pochi chilometri dal monte Amiata, ed è il lago di origine vulcanica più grande d'Europa.	'000':37 '300':36 'accompagn':55 'alcun':46 'alta':32 'alto':23 'ami':78 'anni':38 'are':62 'bolsen':6 'bolsenail':3 'calder':44 'cass':72 'central':20 'chilometr':75 'collass':43 'compless':49 'considerevol':68 'consol':71 'd':88 'europ':89 'fa':39 'format':34 'grand':87 'ital':19 'lacus':11,13 'lag':1,4,17,82 'lamb':64 'latin':10 'laz':24 'mont':51,77 'oltre':35 'origin':84 'part':26,67 'poch':74 'post':21 'provinc':29 'segu':41 'settentrional':27 'sprofond':57 'strad':70 'tetton':60 'tusc':33 'viterb':31 'volsin':8,14,52 'volsiniensis':12 'vulc':59 'vulcan':47,85 'vulcano-tetton':58	'000':38A '300':37A 'accompagn':56A 'alcun':47A 'alta':33A 'alto':24A 'ami':79A 'anni':39A 'are':63A 'bolsen':3B,7A 'calder':45A 'cass':73A 'central':21A 'chilometr':76A 'collass':44A 'compless':50A 'considerevol':69A 'consol':72A 'd':89A 'europ':90A 'fa':40A 'format':35A 'grand':88A 'ital':20A 'lacus':12A,14A 'lag':1B,5A,18A,83A 'lamb':65A 'latin':11A 'laz':25A 'mont':52A,78A 'oltre':36A 'origin':85A 'part':27A,68A 'poch':75A 'post':22A 'provinc':30A 'segu':42A 'settentrional':28A 'sprofond':58A 'strad':71A 'tetton':61A 'tusc':34A 'viterb':32A 'volsin':9A,15A,53A 'volsiniensis':13A 'vulc':60A 'vulcan':48A,86A 'vulcano-tetton':59A	0101000020E61000003F50132285DB2740AAD15048D74B4540
117	7	Fontana di San Rocco	42.6441069	11.9849554	Piazza S. Rocco, 61	Monumento	NaN	NaN	10800	t	1	58	La fontana è collocata lungo il cammino della Via Francigena tra le porte San Giovanni (ristrutturata nel 1559) e quella di San Francesco, in quello che era il centro nevralgico della città dove si affacciavano sia il palazzo del Comune (dal 1377) che la residenza di Giovanni de’ Medici che la fece restaurare dotandola di un prospetto rinascimentale nel 1510.\n\nLa leggenda narra che la sua acqua avrebbe guarito una piaga che tormentava San Rocco, in cammino lungo la via Francigena. Conosciamo il suo aspetto rinascimentale grazie a un bassorilievo scolpito sopra una porta lungo via Cavour: era probabilmente composta da una vasca quadrangolare con pilastro centrale a sostegno di una coppa da cui zampillava l’acqua. Dell’epoca rimangono lo stemma del comune di Bolsena e della famiglia Medici.\n\nNei pressi della fontana sorgeva l’Ospizio della Corona, luogo di sosta e di pernottamento per i pellegrini della Via Francigena, inglobato nel XVIII nell’attuale palazzo Cozza Caposavi.	'1377':45 '1510':63 '1559':21 'acqua':70,120 'affacc':38 'aspett':88 'attual':159 'bassoril':93 'bolsen':129 'cammin':10,80 'capos':162 'cavour':100 'centr':32 'central':110 'citt':35 'colloc':7 'compost':103 'comun':43,127 'conosc':85 'copp':115 'coron':142 'cozz':161 'de':51 'dot':57 'epoc':122 'famigl':132 'fontan':1,5,137 'francesc':26 'francigen':13,84,154 'giovann':18,50 'graz':90 'guar':72 'inglob':155 'legg':65 'lung':8,81,98 'luog':143 'medic':52,133 'narr':66 'nevralg':33 'ospiz':140 'palazz':41,160 'pellegrin':151 'pernott':148 'piag':74 'pilastr':109 'port':16,97 'press':135 'probabil':102 'prospett':60 'quadrangol':107 'resident':48 'restaur':56 'rimang':123 'rinascimental':61,89 'ristruttur':19 'rocc':78 'roccol':4 'san':3,17,25,77 'scolp':94 'sopr':95 'sorg':138 'sost':145 'sostegn':112 'stemm':125 'torment':76 'vasc':106 'via':12,83,99,153 'xvii':157 'zampill':118	'1377':46A '1510':64A '1559':22A 'acqua':71A,121A 'affacc':39A 'aspett':89A 'attual':160A 'bassoril':94A 'bolsen':130A 'cammin':11A,81A 'capos':163A 'cavour':101A 'centr':33A 'central':111A 'citt':36A 'colloc':8A 'compost':104A 'comun':44A,128A 'conosc':86A 'copp':116A 'coron':143A 'cozz':162A 'de':52A 'dot':58A 'epoc':123A 'famigl':133A 'fontan':1B,6A,138A 'francesc':27A 'francigen':14A,85A,155A 'giovann':19A,51A 'graz':91A 'guar':73A 'inglob':156A 'legg':66A 'lung':9A,82A,99A 'luog':144A 'medic':53A,134A 'narr':67A 'nevralg':34A 'ospiz':141A 'palazz':42A,161A 'pellegrin':152A 'pernott':149A 'piag':75A 'pilastr':110A 'port':17A,98A 'press':136A 'probabil':103A 'prospett':61A 'quadrangol':108A 'resident':49A 'restaur':57A 'rimang':124A 'rinascimental':62A,90A 'ristruttur':20A 'rocc':4B,79A 'san':3B,18A,26A,78A 'scolp':95A 'sopr':96A 'sorg':139A 'sost':146A 'sostegn':113A 'stemm':126A 'torment':77A 'vasc':107A 'via':13A,84A,100A,154A 'xvii':158A 'zampill':119A	0101000020E61000008609FE124CF8274060504B1872524540
195	12	MUSEO DELLA NAVIGAZIONE NELLE ACQUE INTERNE	42.5560915	11.8882363	VIALE REGINA MARGHERITA;SNC	Museo, galleria e/o raccolta	761870043	comunecapodimonte@itpec.it	9000	t	1	10	Capodimonte, per la sua posizione e la sua struttura urbanistica che si protende sul lago come un grande nave, per la sua storia, per le sue tradizioni e per la sua “vita sulla riva”, è il luogo ideale per ospitare il Museo della navigazione nelle Acque Interne. Il museo permette al visitatore di capire le forme, gli ambienti e le necessità specifiche della navigazione sui laghi e sui fiumi. Un “tuffo”, è proprio il caso di dire, tra galee, galeotte, tartane, feluche, lenunculi, caudicarie, navicelli, scafe, battane... Inoltre, nel museo, si conserva una piroga preistorica ritrovata nei pressi dell’Isola Bisentina. Grazie a questo ritrovamento l’imbarcazione di un nostro antenato è approdata a Capodimonte per raccontarci la sua incredibile storia.	'acque':5,51 'ambient':63 'anten':116 'approd':118 'battan':92 'bisentin':106 'cap':59 'capodimont':120 'cas':80 'caudicar':89 'conserv':97 'dir':82 'feluc':87 'fium':74 'form':61 'gale':84 'galeott':85 'grand':23 'graz':107 'ideal':43 'imbarc':112 'incred':125 'inoltr':93 'intern':52 'internecapodimont':6 'isol':105 'lag':20 'lagh':71 'lenuncul':88 'luog':42 'muse':1,47,54,95 'nav':24 'navicell':90 'navig':3,49,69 'necess':66 'ospit':45 'permett':55 'pirog':99 'posizion':10 'preistor':100 'press':103 'propr':78 'prot':18 'raccont':122 'ritrov':101,110 'riv':39 'scaf':91 'specif':67 'stor':28,126 'struttur':14 'tartan':86 'tradizion':32 'tuff':76 'urbanist':15 'visit':57 'vit':37	'acque':5B,52A 'ambient':64A 'anten':117A 'approd':119A 'battan':93A 'bisentin':107A 'cap':60A 'capodimont':7A,121A 'cas':81A 'caudicar':90A 'conserv':98A 'dir':83A 'feluc':88A 'fium':75A 'form':62A 'gale':85A 'galeott':86A 'grand':24A 'graz':108A 'ideal':44A 'imbarc':113A 'incred':126A 'inoltr':94A 'intern':6B,53A 'isol':106A 'lag':21A 'lagh':72A 'lenuncul':89A 'luog':43A 'muse':1B,48A,55A,96A 'nav':25A 'navicell':91A 'navig':3B,50A,70A 'necess':67A 'ospit':46A 'permett':56A 'pirog':100A 'posizion':11A 'preistor':101A 'press':104A 'propr':79A 'prot':19A 'raccont':123A 'ritrov':102A,111A 'riv':40A 'scaf':92A 'specif':68A 'stor':29A,127A 'struttur':15A 'tartan':87A 'tradizion':33A 'tuff':77A 'urbanist':16A 'visit':58A 'vit':38A	0101000020E6100000773D87E8C6C62740B30A9B012E474540
151	8	Chiesa di S. Vincenzo Liberato	42.4819280	12.2487640	Mugnano in Teverina	Chiesa o edificio di culto	NaN	NaN	7200	t	1	54	\N	'chies':1 'liber':5 's':3 'vincenz':4	'chies':1B 'liber':5B 's':3B 'vincenz':4B	0101000020E610000023D8B8FE5D7F28406B8313D1AF3D4540
152	8	Palazzo Orsini (o Castello Orsini)	42.4819280	12.2487640	Via Borghese, 10	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	62	\N	'castell':4 'orsin':2,5 'palazz':1	'castell':4B 'orsin':2B,5B 'palazz':1B	0101000020E610000023D8B8FE5D7F28406B8313D1AF3D4540
154	9	Casa Weller	42.2197263	12.4259417	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	94	\N	'cas':1 'weller':2	'cas':1B 'weller':2B	0101000020E61000005A01CF0715DA28401949CCFD1F1C4540
150	8	PARCO DEI MOSTRI, SACRO BOSCO DI BOMARZO	42.4920090	12.2451380	LOCALITA' GIARDINO, snc	Monumento o complesso monumentale	NaN	NaN	7200	t	1	7	\N	'bomarz':7 'bosc':5 'mostr':3 'parc':1 'sacr':4	'bomarz':7B 'bosc':5B 'mostr':3B 'parc':1B 'sacr':4B	0101000020E610000082035ABA827D2840392BA226FA3E4540
318	22	Chiesa di S. Antonio	42.3721886	12.8454886	SP73	Chiesa o edificio di culto	NaN	NaN	7200	t	1	49	\N	'anton':4 'chies':1 's':3	'anton':4B 'chies':1B 's':3B	0101000020E61000001A48BCE1E3B02940D67844E0A32F4540
397	30	Biblioteca comunale	42.6745290	11.8722530	Piazza della Rocca 9	Biblioteca	NaN	NaN	7200	t	1	15	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
222	14	Borgo Di Caprarola	42.3251260	12.2363730	NaN	Architettura fortificata	NaN	NaN	5400	t	1	94	Caprarola, posto tra le vie consolari Cassia e Flaminia, rappresenta uno degli esempi urbanistici più significativi del '500. Durante il medioevo il paese fu conteso da diverse famiglie feudatarie e nel XVI secolo raggiunse il suo massimo splendore, quando la famiglia Farnese estese notevolmente il proprio dominio costruendo fastose ville e castelli. Tra questi fu costruita la residenza più rappresentativa sia a livello di ricchezza che di potenza, il Palazzo Farnese	'500':20 'borg':1 'caprarolacaprarol':3 'cass':9 'castell':54 'consolar':8 'contes':27 'costru':50,58 'divers':29 'domin':49 'durant':21 'esemp':15 'estes':45 'famigl':30,43 'farnes':44,73 'fastos':51 'feudatar':31 'flamin':11 'livell':65 'massim':39 'med':23 'notevol':46 'paes':25 'palazz':72 'post':4 'potenz':70 'propr':48 'quand':41 'raggiuns':36 'rappresent':12,62 'resident':60 'ricchezz':67 'secol':35 'signif':18 'splendor':40 'urbanist':16 'vie':7 'vill':52 'xvi':34	'500':21A 'borg':1B 'caprarol':3B,4A 'cass':10A 'castell':55A 'consolar':9A 'contes':28A 'costru':51A,59A 'divers':30A 'domin':50A 'durant':22A 'esemp':16A 'estes':46A 'famigl':31A,44A 'farnes':45A,74A 'fastos':52A 'feudatar':32A 'flamin':12A 'livell':66A 'massim':40A 'med':24A 'notevol':47A 'paes':26A 'palazz':73A 'post':5A 'potenz':71A 'propr':49A 'quand':42A 'raggiuns':37A 'rappresent':13A,63A 'resident':61A 'ricchezz':68A 'secol':36A 'signif':19A 'splendor':41A 'urbanist':17A 'vie':8A 'vill':53A 'xvi':35A	0101000020E61000009850C1E105792840268A90BA9D294540
226	15	Castello di Giulia Farnese (o Rocca Farnese)	42.3316250	12.2643660	Piazza Castello, 131	Architettura fortificata	NaN	NaN	3600	t	1	54	A differenza di altre rocche edificate o ristrutturate dai Farnese, il palazzo di Carbognano, nonostante la sua imponenza, non domina il borgo da una posizione sopraelevata, come avviene invece nella vicina Caprarola.\nLa Rocca risale ai primi decenni del ‘200. Ristrutturata intorno al ‘500, costituisce il perno intorno a cui il borgo è nato e si è sviluppato a livello urbanistico e storico.\n\nA partire dal XIV secolo, il Castello divenne insediamento dei Prefetti Di Vico e fu poi ceduto a Everso II di Anguillara, nel 1432. Nel 1454 subentrò la Camera Apostolica che lo conservò fino al 1494, quando papa Alessandro VI Borgia lo affidò a Orsino Orsini, marito di Giulia Farnese.\nDi notevole importanza storica sono gli affreschi, gli stucchi e i fregi architettonici che si possono ammirare nel salone nobile della Rocca di Carbognano.	'1432':94 '1454':96 '1494':106 '200':47 '500':51 'affid':113 'affresc':127 'alessandr':109 'altre':11 'ammir':137 'anguillar':92 'apostol':100 'architetton':133 'avvien':35 'borg':29,59,111 'camer':99 'caprarol':39 'carbogn':21,144 'castell':1,77 'ced':87 'conserv':103 'costitu':52 'decenn':45 'different':9 'divenn':78 'domin':27 'edific':13 'evers':89 'farnes':4,7,17,120 'fin':104 'freg':132 'giul':3,119 'ii':90 'imponent':25 'import':123 'insed':79 'intorn':49,55 'invec':36 'livell':67 'mar':117 'nat':61 'nobil':140 'nonost':22 'notevol':122 'orsin':115,116 'palazz':19 'pap':108 'part':72 'pern':54 'poi':86 'posizion':32 'poss':136 'prefett':81 'prim':44 'quand':107 'risal':42 'ristruttur':15,48 'rocc':6,12,41,142 'salon':139 'secol':75 'sopraelev':33 'storic':70,124 'stucc':129 'subentr':97 'svilupp':65 'urbanist':68 'vic':83 'vicin':38 'xiv':74	'1432':94A '1454':96A '1494':106A '200':47A '500':51A 'affid':113A 'affresc':127A 'alessandr':109A 'altre':11A 'ammir':137A 'anguillar':92A 'apostol':100A 'architetton':133A 'avvien':35A 'borg':29A,59A,111A 'camer':99A 'caprarol':39A 'carbogn':21A,144A 'castell':1B,77A 'ced':87A 'conserv':103A 'costitu':52A 'decenn':45A 'different':9A 'divenn':78A 'domin':27A 'edific':13A 'evers':89A 'farnes':4B,7B,17A,120A 'fin':104A 'freg':132A 'giul':3B,119A 'ii':90A 'imponent':25A 'import':123A 'insed':79A 'intorn':49A,55A 'invec':36A 'livell':67A 'mar':117A 'nat':61A 'nobil':140A 'nonost':22A 'notevol':122A 'orsin':115A,116A 'palazz':19A 'pap':108A 'part':72A 'pern':54A 'poi':86A 'posizion':32A 'poss':136A 'prefett':81A 'prim':44A 'quand':107A 'risal':42A 'ristruttur':15A,48A 'rocc':6B,12A,41A,142A 'salon':139A 'secol':75A 'sopraelev':33A 'storic':70A,124A 'stucc':129A 'subentr':97A 'svilupp':65A 'urbanist':68A 'vic':83A 'vicin':38A 'xiv':74A	0101000020E61000004359F8FA5A8728409CC420B0722A4540
112	7	Complesso architettonico e paesaggistico: Viale Colesanti	42.6441069	11.9849554	NaN	Area o parco archeologico	NaN	NaN	5400	t	1	64	\N	'architetton':2 'coles':6 'compless':1 'paesaggist':4 'vial':5	'architetton':2B 'coles':6B 'compless':1B 'paesaggist':4B 'vial':5B	0101000020E61000008609FE124CF8274060504B1872524540
13	1	Casale Poggio Gattuccio	42.7439961	11.8649880	Trevinano	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	43	\N	'casal':1 'gattucc':3 'pogg':2	'casal':1B 'gattucc':3B 'pogg':2B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
248	17	Chiesa di S. Maria	42.6449715	12.2038975	Vaiano	Chiesa o edificio di culto	NaN	NaN	7200	t	1	75	\N	'chies':1 'mar':4 's':3	'chies':1B 'mar':4B 's':3B	0101000020E6100000EA78CC406568284010AD156D8E524540
230	16	Basilica di Sant'Elia	42.2496098	12.3730950	Via Sant' Elia	Chiesa o edificio di culto	NaN	NaN	9000	t	1	86	Innalzata per la prima volta nell’VIII secolo, la Basilica di Sant’Elia è un esempio di stile architettonico di stampo romanico-lombardo. Collocata al centro dell’incantevole Valle Suppontonia, ai piedi dell’antico Borgo di Castel Sant’Elia da una parte, e del complesso del Santuario pontiﬁcio di Santa Maria Ad Rupes dall’altra, la splendida basilica si trova dove un tempo sorgeva la dimora di monaci Benedettini e Anacoreti.	'altra':59 'anacoret':75 'antic':38 'architetton':22 'basil':1,13,62 'benedettin':73 'borg':39 'castel':41 'centr':30 'colloc':28 'compless':49 'dimor':70 'eli':16,43 'eliainnalz':4 'esemp':19 'incantevol':32 'lombard':27 'mar':55 'monac':72 'part':46 'pied':36 'pontiﬁc':52 'prim':7 'roman':26 'romanico-lombard':25 'rupes':57 'sant':3,15,42,54 'santuar':51 'secol':11 'sorg':68 'splendid':61 'stamp':24 'stil':21 'supponton':34 'temp':67 'trov':64 'vall':33 'vii':10 'volt':8	'altra':60A 'anacoret':76A 'antic':39A 'architetton':23A 'basil':1B,14A,63A 'benedettin':74A 'borg':40A 'castel':42A 'centr':31A 'colloc':29A 'compless':50A 'dimor':71A 'eli':4B,17A,44A 'esemp':20A 'incantevol':33A 'innalz':5A 'lombard':28A 'mar':56A 'monac':73A 'part':47A 'pied':37A 'pontiﬁc':53A 'prim':8A 'roman':27A 'romanico-lombard':26A 'rupes':58A 'sant':3B,16A,43A,55A 'santuar':52A 'secol':12A 'sorg':69A 'splendid':62A 'stamp':25A 'stil':22A 'supponton':35A 'temp':68A 'trov':65A 'vall':34A 'vii':11A 'volt':9A	0101000020E61000002C9ACE4E06BF28406CE1C336F31F4540
234	16	Biblioteca comunale	42.2517755	12.3717955	Via Umberto I  5	Biblioteca	NaN	NaN	10800	t	1	59	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E61000009599D2FA5BBE28408F37F92D3A204540
414	31	Chiesa di S. Maria Intus Civitatem	42.5446546	11.7540140	Rovine di Castro	Chiesa o edificio di culto	NaN	NaN	3600	t	1	72	\N	'chies':1 'civitatem':6 'intus':5 'mar':4 's':3	'chies':1B 'civitatem':6B 'intus':5B 'mar':4B 's':3B	0101000020E6100000C9737D1F0E822740D84EEF3DB7454540
420	32	Fontana di Canale	42.6290280	11.8274530	NaN	Monumento	NaN	NaN	7200	t	1	39	\N	'canal':3 'fontan':1	'canal':3B 'fontan':1B	0101000020E610000045F46BEBA7A72740572250FD83504540
246	17	MUVIS - Museo del Vino	42.6462856	12.2043483	Piazza del Poggetto, 12	Museo, galleria e/o raccolta	NaN	NaN	9000	t	1	84	Il MUVIS “Museo del Vino e delle Scienze Agroalimentari” è il più grande museo nel suo genere d’Europa con 2000 m² di spazi espositivi, è situato nel cuore del borgo di Castiglione in Teverina. Che fa parte della Associazione Nazionale “Città del Vino”\n\nIl museo è inserito all’interno del vasto ed articolato complesso produttivo dei Conti Vaselli ovvero nella grande cantina distribuita su 5 piani (1° piano, piano terra e 4 piani sotterranei), non più in uso da quasi 20 anni. Il percorso è una discesa nella collina alla scoperta della produzione vinicola “di ieri”.\nSi scende per 27 metri sino a raggiungere la “Cattedrale” (al -4) in cui è possibile ammirare gigantesche botti del diametro di tre metri.\n\nL’allestimento è mirato al pieno coinvolgimento ed “all’immersione”  del visitatore attraverso le foto, video, racconti, strumenti, macchinari e gigantografie nel mondo di vino, dell’agroalimentare, di produzione vinicola e storia locale.\n\nAccanto alle tracce materiali ed immateriali del mondo contadino  e delle vicende storiche ed umane delle Cantine Vaselli  sono stati “messi in scena” con installazioni scenografiche, gli aspetti della produzione e della tradizione vinaria nel territorio della Teverina, accanto ai grandi temi di più ampio respiro culturale che il vino suggerisce.	'-4':112 '1':71 '20':85 '2000':24 '27':104 '4':76 '5':69 'accant':158,196 'agroaliment':151 'agroalimentar':12 'allest':126 'ammir':117 'ampi':202 'anni':86 'articol':57 'aspett':185 'assoc':43 'attravers':137 'borg':34 'bott':119 'cantin':66,174 'castiglion':36 'cattedral':110 'citt':45 'coinvolg':131 'collin':93 'compless':58 'cont':61 'contadin':166 'cultural':204 'cuor':32 'd':21 'diametr':121 'disces':91 'distribu':67 'esposit':28 'europ':22 'fa':40 'fot':139 'gen':20 'gigantesc':118 'gigantograf':145 'grand':16,65,198 'ier':100 'immaterial':163 'immersion':134 'inser':51 'install':182 'intern':53 'local':157 'm':25 'macchinar':143 'material':161 'mess':178 'metr':105,124 'mir':128 'mond':147,165 'muse':2,6,17,49 'muvis':1,5 'nazional':44 'ovver':63 'part':41 'percors':88 'pian':70,72,73,77 'pien':130 'possibil':116 'produtt':59 'produzion':97,153,187 'quas':84 'raccont':141 'raggiung':108 'respir':203 'scen':180 'scend':102 'scenograf':183 'scienz':11 'scopert':95 'sin':106 'situ':30 'sotterrane':78 'spaz':27 'stat':177 'stor':156 'storic':170 'strument':142 'sugger':208 'tem':199 'terr':74 'territor':193 'teverin':38,195 'tracc':160 'tradizion':190 'tre':123 'uman':172 'uso':82 'vasell':62,175 'vast':55 'vic':169 'vide':140 'vin':8,47,149,207 'vinar':191 'vinicol':98,154 'vinoil':4 'visit':136	'-4':113A '1':72A '20':86A '2000':25A '27':105A '4':77A '5':70A 'accant':159A,197A 'agroaliment':152A 'agroalimentar':13A 'allest':127A 'ammir':118A 'ampi':203A 'anni':87A 'articol':58A 'aspett':186A 'assoc':44A 'attravers':138A 'borg':35A 'bott':120A 'cantin':67A,175A 'castiglion':37A 'cattedral':111A 'citt':46A 'coinvolg':132A 'collin':94A 'compless':59A 'cont':62A 'contadin':167A 'cultural':205A 'cuor':33A 'd':22A 'diametr':122A 'disces':92A 'distribu':68A 'esposit':29A 'europ':23A 'fa':41A 'fot':140A 'gen':21A 'gigantesc':119A 'gigantograf':146A 'grand':17A,66A,199A 'ier':101A 'immaterial':164A 'immersion':135A 'inser':52A 'install':183A 'intern':54A 'local':158A 'm':26A 'macchinar':144A 'material':162A 'mess':179A 'metr':106A,125A 'mir':129A 'mond':148A,166A 'muse':2B,7A,18A,50A 'muvis':1B,6A 'nazional':45A 'ovver':64A 'part':42A 'percors':89A 'pian':71A,73A,74A,78A 'pien':131A 'possibil':117A 'produtt':60A 'produzion':98A,154A,188A 'quas':85A 'raccont':142A 'raggiung':109A 'respir':204A 'scen':181A 'scend':103A 'scenograf':184A 'scienz':12A 'scopert':96A 'sin':107A 'situ':31A 'sotterrane':79A 'spaz':28A 'stat':178A 'stor':157A 'storic':171A 'strument':143A 'sugger':209A 'tem':200A 'terr':75A 'territor':194A 'teverin':39A,196A 'tracc':161A 'tradizion':191A 'tre':124A 'uman':173A 'uso':83A 'vasell':63A,176A 'vast':56A 'vic':170A 'vide':141A 'vin':4B,9A,48A,150A,208A 'vinar':192A 'vinicol':99A,155A 'visit':137A	0101000020E610000084FC2257A068284018F08D7CB9524540
277	20	Tempio di Giunone Curite	42.2963220	12.4220905	NaN	Area o parco archeologico	NaN	NaN	5400	t	1	41	A Civita Castellana, lungo il torrente Rio Maggiore, tra l’altopiano di Celle e quello del Vignale sorge quello che è considerato da molti come il più noto dei santuari falisci, ovvero quello dedicato al culto di Giunone Curite. Divinità celeste  e lunare, Dea del calendario, della donna, della vita femminile e della fecondità, Divinità del matrimonio e in quanto Regina, Divinità poliade di alcune città del Lazio e d’Italia. Giunone era la Divinità corrispondente alla Dea greca Era e dunque concepita come sposa di Giove.	'alcun':68 'altop':14 'calendar':49 'castellan':6 'celest':44 'cell':16 'citt':69 'civ':5 'concep':86 'consider':25 'corrispondent':79 'cult':39 'cur':42 'curite':4 'd':73 'dea':47,81 'dedic':37 'divin':43,58,65,78 'donn':51 'dunqu':85 'fal':34 'fecond':57 'femminil':54 'giov':90 'giunon':3,41,75 'grec':82 'ital':74 'laz':71 'lun':46 'lung':7 'maggior':11 'matrimon':60 'molt':27 'not':31 'ovver':35 'poliad':66 'regin':64 'rio':10 'santuar':33 'sorg':21 'spos':88 'temp':1 'torrent':9 'vignal':20 'vit':53	'alcun':69A 'altop':15A 'calendar':50A 'castellan':7A 'celest':45A 'cell':17A 'citt':70A 'civ':6A 'concep':87A 'consider':26A 'corrispondent':80A 'cult':40A 'cur':4B,43A 'd':74A 'dea':48A,82A 'dedic':38A 'divin':44A,59A,66A,79A 'donn':52A 'dunqu':86A 'fal':35A 'fecond':58A 'femminil':55A 'giov':91A 'giunon':3B,42A,76A 'grec':83A 'ital':75A 'laz':72A 'lun':47A 'lung':8A 'maggior':12A 'matrimon':61A 'molt':28A 'not':32A 'ovver':36A 'poliad':67A 'regin':65A 'rio':11A 'santuar':34A 'sorg':22A 'spos':89A 'temp':1B 'torrent':10A 'vignal':21A 'vit':54A	0101000020E610000092E7FA3E1CD82840EC8A19E1ED254540
249	17	Teatro Tevere	42.6584217	12.1738538	NaN	Architettura civile	NaN	NaN	7200	t	1	98	\N	'teatr':1 'tev':2	'teatr':1B 'tev':2B	0101000020E61000001692825D03592840053D8A2947544540
250	17	Rocca Monaldeschi	42.6362760	12.1136320	Piazza Monaldeschi, 61	Architettura fortificata	NaN	NaN	9000	t	1	95	\N	'monaldesc':2 'rocc':1	'monaldesc':2B 'rocc':1B	0101000020E6100000E38E37F92D3A2840679DF17D71514540
126	7	Palazzo Comunale	42.6441069	11.9849554	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	99	\N	'comunal':2 'palazz':1	'comunal':2B 'palazz':1B	0101000020E61000008609FE124CF8274060504B1872524540
127	7	Acquario di bolsena	42.6433430	11.9848430	Piazza Monaldeschi, 1	Parco o Giardino di interesse storico o artistico	NaN	NaN	7200	t	1	76	\N	'acquar':1 'bolsen':3	'acquar':1B 'bolsen':3B	0101000020E6100000996379573DF82740268E3C1059524540
129	7	Palazzo Signorile Cardinale Teodorico o Ranieri	42.6441069	11.9849554	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	6	\N	'cardinal':3 'palazz':1 'ranier':6 'signoril':2 'teodor':4	'cardinal':3B 'palazz':1B 'ranier':6B 'signoril':2B 'teodor':4B	0101000020E61000008609FE124CF8274060504B1872524540
121	7	Parco di Turona	42.6441069	11.9849554	Via strada di turona	Parco o Giardino di interesse storico o artistico	NaN	NaN	10800	t	1	13	\N	'parc':1 'turon':3	'parc':1B 'turon':3B	0101000020E61000008609FE124CF8274060504B1872524540
298	20	Forte Sangallo (o Rocca Borgia)	42.2952260	12.4091700	Via Mazzocchi	Architettura fortificata	NaN	NaN	5400	t	1	31	Benvenuti al Forte Sangallo, l’imponente rocca fortificata di Civita Castellana che è certamente da considerare tra le più importanti e meglio conservate opere militari realizzate dallo Stato pontificio tra la fine del 1400 e l’inizio del 1500.\n\nEdificata sui resti di una preesistente rocca medievale, già strategicamente posta a difesa della parte dell’abitato più vulnerabile date le sue caratteristiche morfologiche, per secoli ha difeso e reso inespugnabile la citta di Civita Castellana e, al tempo stesso, ha testimoniato vistosamente la presenza del potere pontificio sul territorio.\n\nLa sua costruzione prese avvio per volontà di Alessandro VI Borgia nel 1495, qualche anno dopo la sua ascesa al soglio di San Pietro, e rientrava nel più vasto progetto di miglioramento e potenziamento delle rocche difensive che perimetravano lo Stato pontificio, all’epoca in grande espansione.\n\nA progettare e ad avviare la costruzione dell’ambiziosa opera fu il celebre architetto e ingegnere militare Antonio Giamberti da Sangallo, detto il Vecchio (1455-1535).\nLa rocca resterà alla storia come uno dei suoi massimi capolavori.\n\nAlla morte di Alessandro VI il cantiere passò nelle mani del suo successore, Giuliano Della Rovere, divenuto papa il 5 ottobre 1503 col nome di Giulio II, che completò la fabbrica affidandosi ad un altro direttore dei lavori, l’architetto Antonio da Sangallo il Giovane (1484-1546).\n\nDue caratteristiche di fondo fanno della rocca borgiana un modello emblematico del primissimo Rinascimento italiano e la consacrano come un monumento ‘moderno’: i sistemi difensivi innovativi, adeguati alle mutate tecniche di guerra che prevedevano oramai l’uso delle armi da fuoco; la sua contemporanea funzione di solenne residenza papale, poiché ingloba al piano nobile ambienti ad uso abitativo residenziale destinati al papa ed alla sua corte.\n\nResterà dimora papale fino agli inizi del 1800, dopo di che sarà usata come carcere politico e dal 1846 al 1861 come carcere militare; a partire dal 1905 casa circondariale del Regno d’Italia.\nIl lungo periodo di decadenza seguito alla dismissione del carcere (1961) terminerà alla fine degli anni Sessanta del Novecento con il restauro conservativo dell’edificio e la destinazione a sede del Museo Archeologico dell’Agro Falisco (1985).	'-1535':167 '-1546':225 '1400':39 '1455':166 '1484':224 '1495':107 '1500':44 '1503':200 '1800':299 '1846':310 '1861':312 '1905':319 '1961':336 '1985':362 '5':198 'abit':61,283 'adegu':252 'affid':210 'agro':360 'alessandr':103,182 'altro':213 'ambient':280 'ambiz':150 'anni':341 'anno':109 'anton':159,219 'archeolog':358 'architett':155,218 'armi':264 'asces':113 'avvi':99,146 'benven':6 'borg':5,105 'borgian':233 'cant':185 'capolavor':178 'caratterist':67,227 'carc':306,314,335 'cas':320 'castellan':16,80 'celebr':154 'cert':19 'circondarial':321 'citt':77 'civ':15,79 'complet':207 'consacr':243 'conserv':28,348 'consider':21 'contemporane':269 'cort':291 'costruzion':97,148 'd':324 'dat':64 'decadent':330 'destin':285,353 'dett':163 'difens':131,250 'difes':57,72 'dimor':293 'direttor':214 'dismission':333 'diven':195 'dop':110,300 'due':226 'edific':45,350 'emblemat':236 'epoc':138 'espansion':141 'fabbric':209 'fal':361 'fin':37,295,339 'fond':229 'fort':1,8 'fortific':13 'funzion':270 'fuoc':266 'giamb':160 'giovan':223 'giul':192,204 'già':53 'grand':140 'guerr':257 'ii':205 'imponent':11 'import':25 'inespugn':75 'ingegn':157 'inglob':276 'iniz':42,297 'innov':251 'ital':240,325 'lavor':216 'lung':327 'man':188 'massim':177 'medieval':52 'megl':27 'miglior':126 'milit':158,315 'militar':30 'modell':235 'modern':247 'monument':246 'morfolog':68 'mort':180 'muse':357 'mut':254 'nobil':279 'nom':202 'novecent':344 'oper':29,151 'orama':260 'ottobr':199 'pap':196,287 'papal':274,294 'part':59,317 'pass':186 'perimetr':133 'period':328 'pian':278 'pietr':118 'poic':275 'polit':307 'pontific':34,92,136 'post':55 'pot':91 'potenz':128 'preesistent':50 'pres':98 'presenz':89 'preved':259 'primissim':238 'progett':124,143 'qualc':108 'realizz':31 'regn':323 'res':74 'resident':273 'residenzial':284 'rest':47,170,292 'restaur':347 'rientr':120 'rinasc':239 'rocc':4,12,51,130,169,232 'rov':194 'san':117 'sangall':2,9,162,221 'secol':70 'sed':355 'segu':331 'sessant':342 'sistem':249 'sogl':115 'solenn':272 'stat':33,135 'stess':84 'stor':172 'strateg':54 'successor':191 'tecnic':255 'temp':83 'termin':337 'territor':94 'testimon':86 'usat':304 'uso':262,282 'vast':123 'vecc':165 'vistos':87 'volont':101 'vulner':63	'-1535':167A '-1546':225A '1400':39A '1455':166A '1484':224A '1495':107A '1500':44A '1503':200A '1800':299A '1846':310A '1861':312A '1905':319A '1961':336A '1985':362A '5':198A 'abit':61A,283A 'adegu':252A 'affid':210A 'agro':360A 'alessandr':103A,182A 'altro':213A 'ambient':280A 'ambiz':150A 'anni':341A 'anno':109A 'anton':159A,219A 'archeolog':358A 'architett':155A,218A 'armi':264A 'asces':113A 'avvi':99A,146A 'benven':6A 'borg':5B,105A 'borgian':233A 'cant':185A 'capolavor':178A 'caratterist':67A,227A 'carc':306A,314A,335A 'cas':320A 'castellan':16A,80A 'celebr':154A 'cert':19A 'circondarial':321A 'citt':77A 'civ':15A,79A 'complet':207A 'consacr':243A 'conserv':28A,348A 'consider':21A 'contemporane':269A 'cort':291A 'costruzion':97A,148A 'd':324A 'dat':64A 'decadent':330A 'destin':285A,353A 'dett':163A 'difens':131A,250A 'difes':57A,72A 'dimor':293A 'direttor':214A 'dismission':333A 'diven':195A 'dop':110A,300A 'due':226A 'edific':45A,350A 'emblemat':236A 'epoc':138A 'espansion':141A 'fabbric':209A 'fal':361A 'fin':37A,295A,339A 'fond':229A 'fort':1B,8A 'fortific':13A 'funzion':270A 'fuoc':266A 'giamb':160A 'giovan':223A 'giul':192A,204A 'già':53A 'grand':140A 'guerr':257A 'ii':205A 'imponent':11A 'import':25A 'inespugn':75A 'ingegn':157A 'inglob':276A 'iniz':42A,297A 'innov':251A 'ital':240A,325A 'lavor':216A 'lung':327A 'man':188A 'massim':177A 'medieval':52A 'megl':27A 'miglior':126A 'milit':158A,315A 'militar':30A 'modell':235A 'modern':247A 'monument':246A 'morfolog':68A 'mort':180A 'muse':357A 'mut':254A 'nobil':279A 'nom':202A 'novecent':344A 'oper':29A,151A 'orama':260A 'ottobr':199A 'pap':196A,287A 'papal':274A,294A 'part':59A,317A 'pass':186A 'perimetr':133A 'period':328A 'pian':278A 'pietr':118A 'poic':275A 'polit':307A 'pontific':34A,92A,136A 'post':55A 'pot':91A 'potenz':128A 'preesistent':50A 'pres':98A 'presenz':89A 'preved':259A 'primissim':238A 'progett':124A,143A 'qualc':108A 'realizz':31A 'regn':323A 'res':74A 'resident':273A 'residenzial':284A 'rest':47A,170A,292A 'restaur':347A 'rientr':120A 'rinasc':239A 'rocc':4B,12A,51A,130A,169A,232A 'rov':194A 'san':117A 'sangall':2B,9A,162A,221A 'secol':70A 'sed':355A 'segu':331A 'sessant':342A 'sistem':249A 'sogl':115A 'solenn':272A 'stat':33A,135A 'stess':84A 'stor':172A 'strateg':54A 'successor':191A 'tecnic':255A 'temp':83A 'termin':337A 'territor':94A 'testimon':86A 'usat':304A 'uso':262A,282A 'vast':123A 'vecc':165A 'vistos':87A 'volont':101A 'vulner':63A	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
257	19	Chiesa di S. Egidio	42.5597682	12.1257580	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	57	Dedicata al Santo Patrono del borgo, la Chiesa di Sant'Egidio rappresenta una magnifica espressione del Rinascimento, dalle linee armoniose. Un vero e proprio "piccolo gioiello d'arte".\n\nFu edificata tra 1512 e 1520, e a commissionarla fu il cardinale Alessandro Farnese (futuro Papa Paolo III), che per la sua progettazione si rivolse al celebre architetto fiorentino Antonio da Sangallo il Giovane.\n\nAl suo interno presenta un impianto a croce greca, e conserva un incantevole pavimento esagonale, in ottimo stato. Le pareti dell'edificio sono adornate da pregevoli affreschi del Cinquecento, di rilevanza storica e artistica.	'1512':35 '1520':37 'adorn':89 'affresc':92 'alessandr':44 'anton':61 'architett':59 'armon':23 'arte':31 'artist':99 'borg':9 'cardinal':43 'celebr':58 'chies':1,11 'cinquecent':94 'commission':40 'conserv':76 'croc':73 'd':30 'edific':33,87 'egid':14 'egidiodedic':4 'esagonal':80 'espression':18 'farnes':45 'fiorentin':60 'futur':46 'gioiell':29 'giovan':65 'grec':74 'iii':49 'impiant':71 'incantevol':78 'intern':68 'line':22 'magnif':17 'ottim':82 'paol':48 'pap':47 'paret':85 'patr':7 'pav':79 'piccol':28 'pregevol':91 'present':69 'progett':54 'propr':27 'rappresent':15 'rilev':96 'rinasc':20 'rivols':56 's':3 'sangall':63 'sant':6,13 'stat':83 'storic':97 'ver':25	'1512':36A '1520':38A 'adorn':90A 'affresc':93A 'alessandr':45A 'anton':62A 'architett':60A 'armon':24A 'arte':32A 'artist':100A 'borg':10A 'cardinal':44A 'celebr':59A 'chies':1B,12A 'cinquecent':95A 'commission':41A 'conserv':77A 'croc':74A 'd':31A 'dedic':5A 'edific':34A,88A 'egid':4B,15A 'esagonal':81A 'espression':19A 'farnes':46A 'fiorentin':61A 'futur':47A 'gioiell':30A 'giovan':66A 'grec':75A 'iii':50A 'impiant':72A 'incantevol':79A 'intern':69A 'line':23A 'magnif':18A 'ottim':83A 'paol':49A 'pap':48A 'paret':86A 'patr':8A 'pav':80A 'piccol':29A 'pregevol':92A 'present':70A 'progett':55A 'propr':28A 'rappresent':16A 'rilev':97A 'rinasc':21A 'rivols':57A 's':3B 'sangall':64A 'sant':7A,14A 'stat':84A 'storic':98A 'ver':26A	0101000020E6100000B56B425A634028409F2B007CA6474540
417	32	Parco Comunale dei Castagneti	42.6290280	11.8274530	Via Roma, 23	Parco o Giardino di interesse storico o artistico	NaN	NaN	10800	t	1	91	I primi impianti del parco si fanno risalire ai tempi di Matilde di Canossa. Oggi presenta esemplari che portano su di sé il peso del trascorrere dei decenni.\n\nTronchi contorti, cortecce scavate, quasi come volti umani segnati dal passare del tempo e dalle avversità della natura. Si è creato un ambiente di grande serenità e pace, al punto da essere annoverato come uno degli spazi verdi più belli e suggestivi dell’Appennino. Chiuso sullo sfondo da una quinta naturale rappresentata dal Monte Caprile, il Parco racchiude in sé tutta l’essenza antica di Montecreto: il lavoro, la fatica, il trascorrere quasi immutabile dei secoli, ma anche la bellezza e la capacità dell’uomo di forgiare la natura assecondandone le tendenze e migliorandone la qualità.\n\nUn lavoro che oggi si può riscoprire visitando l’antico metato, l’essiccatoio per le castagne e il mulino delle Belle addormentate, riportati a nuova vita, resi di nuovo funzionanti e spesso utilizzati per momenti di incontro e di festa, che contribuiscono a mantenere viva la tradizione e a tramandarla alle nuove generazioni.\n\nE il Parco dei Castagni, testimone del trascorrere del tempo, oggi è anche uno dei migliori amici dei bambini.\nSpazi verdi, giochi, aree attrezzate, sono a disposizione dei più piccoli in un ambiente salubre e suggestivo, guardato a vista dall’imponenza e dalla saggezza antica dei castagni secolari.\nIn autunno inoltre il parco è uno dei luoghi in cui si sviluppa la Festa della Castagna di Montecreto. Nelle settimane autunnali inoltre vedrete molte persone andare a raccogliere le castagne nel parco. È infatti concessa la raccolta a chiunque, con il solo limite del rispetto degli alberi e delle ordinanze comunali.	'addorment':149 'alber':276 'ambient':54,213 'amic':197 'andar':255 'annover':64 'antic':95,137,225 'appennin':75 'are':203 'assecond':121 'attrezz':204 'autunn':230 'autunnal':250 'avvers':47 'bambin':199 'bell':71,148 'bellezz':111 'canoss':17 'capac':114 'capril':86 'castagn':143,185,227,245,259 'castagnet':4 'chiunqu':268 'chius':76 'comunal':2,280 'concess':264 'contort':33 'contribu':169 'cortecc':34 'cre':52 'decenn':31 'disposizion':207 'esemplar':20 'essenz':94 'esser':63 'essiccatoi':140 'fatic':101 'fest':167,243 'forg':118 'funzion':157 'gener':180 'gioc':202 'grand':56 'guard':217 'immut':105 'impiant':6 'imponent':221 'incontr':164 'infatt':263 'inoltr':231,251 'lavor':99,129 'lim':272 'luog':237 'manten':171 'matild':15 'met':138 'miglior':125,196 'molt':253 'moment':162 'mont':85 'montecret':97,247 'mulin':146 'natur':49,120 'natural':82 'nuov':152,156,179 'oggi':18,131,191 'ordin':279 'pac':59 'parc':1,8,88,183,233,261 'pass':42 'person':254 'pes':27 'piccol':210 'port':22 'present':19 'prim':5 'punt':61 'può':133 'qualit':127 'quas':36,104 'quint':81 'racchiud':89 'raccogl':257 'raccolt':266 'rappresent':83 'res':154 'riport':150 'risal':11 'riscopr':134 'rispett':274 'saggezz':224 'salubr':214 'scav':35 'secol':107 'secolar':228 'segn':40 'seren':57 'settiman':249 'sfond':78 'sol':271 'spaz':68,200 'spess':159 'suggest':73,216 'svilupp':241 'sè':25,91 'temp':13,44,190 'tendenz':123 'testimon':186 'tradizion':174 'tramand':177 'trascorr':29,103,188 'tronc':32 'tutt':92 'uman':39 'uom':116 'utilizz':160 'vedr':252 'verd':69,201 'visit':135 'vist':219 'vit':153 'viv':172 'volt':38	'addorment':150A 'alber':277A 'ambient':55A,214A 'amic':198A 'andar':256A 'annover':65A 'antic':96A,138A,226A 'appennin':76A 'are':204A 'assecond':122A 'attrezz':205A 'autunn':231A 'autunnal':251A 'avvers':48A 'bambin':200A 'bell':72A,149A 'bellezz':112A 'canoss':18A 'capac':115A 'capril':87A 'castagn':144A,186A,228A,246A,260A 'castagnet':4B 'chiunqu':269A 'chius':77A 'comunal':2B,281A 'concess':265A 'contort':34A 'contribu':170A 'cortecc':35A 'cre':53A 'decenn':32A 'disposizion':208A 'esemplar':21A 'essenz':95A 'esser':64A 'essiccatoi':141A 'fatic':102A 'fest':168A,244A 'forg':119A 'funzion':158A 'gener':181A 'gioc':203A 'grand':57A 'guard':218A 'immut':106A 'impiant':7A 'imponent':222A 'incontr':165A 'infatt':264A 'inoltr':232A,252A 'lavor':100A,130A 'lim':273A 'luog':238A 'manten':172A 'matild':16A 'met':139A 'miglior':126A,197A 'molt':254A 'moment':163A 'mont':86A 'montecret':98A,248A 'mulin':147A 'natur':50A,121A 'natural':83A 'nuov':153A,157A,180A 'oggi':19A,132A,192A 'ordin':280A 'pac':60A 'parc':1B,9A,89A,184A,234A,262A 'pass':43A 'person':255A 'pes':28A 'piccol':211A 'port':23A 'present':20A 'prim':6A 'punt':62A 'può':134A 'qualit':128A 'quas':37A,105A 'quint':82A 'racchiud':90A 'raccogl':258A 'raccolt':267A 'rappresent':84A 'res':155A 'riport':151A 'risal':12A 'riscopr':135A 'rispett':275A 'saggezz':225A 'salubr':215A 'scav':36A 'secol':108A 'secolar':229A 'segn':41A 'seren':58A 'settiman':250A 'sfond':79A 'sol':272A 'spaz':69A,201A 'spess':160A 'suggest':74A,217A 'svilupp':242A 'sè':26A,92A 'temp':14A,45A,191A 'tendenz':124A 'testimon':187A 'tradizion':175A 'tramand':178A 'trascorr':30A,104A,189A 'tronc':33A 'tutt':93A 'uman':40A 'uom':117A 'utilizz':161A 'vedr':253A 'verd':70A,202A 'visit':136A 'vist':220A 'vit':154A 'viv':173A 'volt':39A	0101000020E610000045F46BEBA7A72740572250FD83504540
343	26	Chiesa di S. Francesco	42.5494260	11.7256520	Cappuccini	Chiesa o edificio di culto	NaN	NaN	3600	t	1	26	\N	'chies':1 'francesc':4 's':3	'chies':1B 'francesc':4B 's':3B	0101000020E6100000D28DB0A8887327403AC9569753464540
17	1	Torre dell' Orologio (o Torre del Barbarossa)	42.7439961	11.8649880	Parco la Pineta, Via Oriolo	Architettura fortificata	NaN	NaN	10800	t	1	37	\N	'barbaross':7 'orolog':3 'torr':1,5	'barbaross':7B 'orolog':3B 'torr':1B,5B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
605	45	Chiesa di Santa Maria del Popolo	42.2902415	12.2138064	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	17	\N	'chies':1 'mar':4 'popol':6 'sant':3	'chies':1B 'mar':4B 'popol':6B 'sant':3B	0101000020E6100000DA594F08786D284093382BA226254540
514	39	Convento dell' ordine dei canonici  di S. Agostino	42.2428240	12.3455700	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	2	\N	'agostin':8 'canon':5 'convent':1 'ordin':3 's':7	'agostin':8B 'canon':5B 'convent':1B 'ordin':3B 's':7B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
515	39	Chiesa di S. Pietro Apostolo	42.2428240	12.3455700	Via di S. Pietro	Chiesa o edificio di culto	NaN	NaN	5400	t	1	10	\N	'apostol':5 'chies':1 'pietr':4 's':3	'apostol':5B 'chies':1B 'pietr':4B 's':3B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
524	39	Porta Nica	42.2428240	12.3455700	NaN	Architettura fortificata	NaN	NaN	3600	t	1	9	\N	'nic':2 'port':1	'nic':2B 'port':1B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
6	1	Casale Campo del Prete	42.7439961	11.8649880	Campo del Prete	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	89	\N	'camp':2 'casal':1 'pret':4	'camp':2B 'casal':1B 'pret':4B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
7	1	Palazzo Viscontini	42.7439961	11.8649880	Via Cesare Battisti, 28	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	73	\N	'palazz':1 'viscontin':2	'palazz':1B 'viscontin':2B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
237	17	Chiesa della Madonna della Neve	42.6449715	12.2038975	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	51	\N	'chies':1 'madonn':3 'nev':5	'chies':1B 'madonn':3B 'nev':5B	0101000020E6100000EA78CC406568284010AD156D8E524540
238	17	Borgo Medievale	42.6449715	12.2038975	NaN	Architettura fortificata	NaN	NaN	9000	t	1	67	\N	'borg':1 'medieval':2	'borg':1B 'medieval':2B	0101000020E6100000EA78CC406568284010AD156D8E524540
60	2	Chiesa di Santa Maria delle Carceri	42.6269800	12.0908718	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	50	\N	'carcer':6 'chies':1 'mar':4 'sant':3	'carcer':6B 'chies':1B 'mar':4B 'sant':3B	0101000020E6100000DF41A2BF862E2840809F71E140504540
239	17	Palazzo Cialfi e Chiesa della Natività	42.6449715	12.2038975	Sermugnano	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	69	\N	'chies':4 'cialf':2 'nativ':6 'palazz':1	'chies':4B 'cialf':2B 'nativ':6B 'palazz':1B	0101000020E6100000EA78CC406568284010AD156D8E524540
241	17	Palazzo Vannicelli	42.6449715	12.2038975	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	24	\N	'palazz':1 'vannicell':2	'palazz':1B 'vannicell':2B	0101000020E6100000EA78CC406568284010AD156D8E524540
9	1	Chiesa di s. Agostino (ex Maria SS.ma delle Grazie)	42.7439961	11.8649880	Largo S. Agostino	Chiesa o edificio di culto	NaN	NaN	9000	t	1	19	\N	'agostin':4 'chies':1 'ex':5 'graz':9 'mar':6 's':3 'ss.ma':7	'agostin':4B 'chies':1B 'ex':5B 'graz':9B 'mar':6B 's':3B 'ss.ma':7B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
627	48	Chiesa di Sant'Antonio	42.4187606	12.2343075	Via Santa Maria, 151	Chiesa o edificio di culto	NaN	NaN	10800	t	1	15	\N	'anton':4 'chies':1 'sant':3	'anton':4B 'chies':1B 'sant':3B	0101000020E6100000406A1327F77728403AED84F299354540
629	48	Chiesa di Sant'Antonio Abate di Chia	42.4187606	12.2343075	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	84	\N	'abat':5 'anton':4 'chi':7 'chies':1 'sant':3	'abat':5B 'anton':4B 'chi':7B 'chies':1B 'sant':3B	0101000020E6100000406A1327F77728403AED84F299354540
630	48	Chiesa di Sant'Eutizio	42.4187606	12.2343075	Via Andrea Splendiano Pennazzi	Chiesa o edificio di culto	NaN	NaN	5400	t	1	39	\N	'chies':1 'eutiz':4 'sant':3	'chies':1B 'eutiz':4B 'sant':3B	0101000020E6100000406A1327F77728403AED84F299354540
631	48	Chiesa di Santa Maria delle Grazie	42.4187606	12.2343075	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	65	\N	'chies':1 'graz':6 'mar':4 'sant':3	'chies':1B 'graz':6B 'mar':4B 'sant':3B	0101000020E6100000406A1327F77728403AED84F299354540
636	48	Biblioteca comunale	42.4187606	12.2343075	Via Roma 12	Biblioteca	NaN	NaN	3600	t	1	66	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E6100000406A1327F77728403AED84F299354540
157	9	Chiesa dei Santi Cornelio e Cipriano	42.2197263	12.4259417	Piazza Risorgimento	Chiesa o edificio di culto	NaN	NaN	3600	t	1	41	\N	'chies':1 'cipr':6 'cornel':4 'sant':3	'chies':1B 'cipr':6B 'cornel':4B 'sant':3B	0101000020E61000005A01CF0715DA28401949CCFD1F1C4540
158	9	MUSEO DELLA CIVILTA' CONTADINA	42.2165023	12.4187122	via San Giovanni	Museo, galleria e/o raccolta	761587989	gisa.federici@libero.it	9000	t	1	33	\N	'civilt':3 'contadin':4 'muse':1	'civilt':3B 'contadin':4B 'muse':1B	0101000020E610000057DF0A7261D628402001ED58B61B4540
159	9	Palazzo dell' Ente Parco del Treia	42.2197263	12.4259417	Piazza Vittorio Emanuele II	Parco o Giardino di interesse storico o artistico	NaN	NaN	10800	t	1	81	\N	'ente':3 'palazz':1 'parc':4 'trei':6	'ente':3B 'palazz':1B 'parc':4B 'trei':6B	0101000020E61000005A01CF0715DA28401949CCFD1F1C4540
160	9	Palazzo del Governo Vecchio	41.8987401	12.4704076	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	29	\N	'govern':3 'palazz':1 'vecc':4	'govern':3B 'palazz':1B 'vecc':4B	0101000020E61000006794D343D9F02840488D64EA09F34440
161	9	Chiesa del SS. Nome di Gesù	41.8063340	12.4954590	Piazza Umberto I	Chiesa o edificio di culto	NaN	NaN	7200	t	1	81	\N	'chies':1 'gesù':6 'nom':4 'ss':3	'chies':1B 'gesù':6B 'nom':4B 'ss':3B	0101000020E61000008A0453CDACFD284091D3D7F335E74440
163	9	Palazzo baronale Anguillara	42.2165828	12.4190685	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	19	\N	'anguillar':3 'baronal':2 'palazz':1	'anguillar':3B 'baronal':2B 'palazz':1B	0101000020E61000004B917C2590D62840247035FCB81B4540
164	9	OPERA BOSCO' MUSEO DI ARTE NELLA NATURA	42.2165600	12.4211497	LOCALITA' COLLE; SNC	Museo, galleria e/o raccolta	761588048	operabosco@operabosco.eu	10800	t	1	67	\N	'arte':5 'bosc':2 'muse':3 'natur':7 'oper':1	'arte':5B 'bosc':2B 'muse':3B 'natur':7B 'oper':1B	0101000020E6100000C070F8EEA0D7284096CFF23CB81B4540
516	39	Necropoli dei Tre Ponti	42.1295380	12.0331730	NaN	Area o parco archeologico	NaN	NaN	3600	t	1	84	\N	'necropol':1 'pont':4 'tre':3	'necropol':1B 'pont':4B 'tre':3B	0101000020E61000006D382C0DFC1028406CCB80B394104540
517	39	Porta Porciana	42.2418927	12.3495192	NaN	Architettura fortificata	NaN	NaN	9000	t	1	0	\N	'porcian':2 'port':1	'porcian':2B 'port':1B	0101000020E6100000EEA53A2EF4B2284011D20957F61E4540
518	39	Palazzo Benincasa	42.2428240	12.3455700	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	12	\N	'benincas':2 'palazz':1	'benincas':2B 'palazz':1B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
519	39	Chiesa di San Silvestro	42.2428240	12.3455700	Via Garibaldi, 51	Chiesa o edificio di culto	NaN	NaN	5400	t	1	19	\N	'chies':1 'san':3 'silvestr':4	'chies':1B 'san':3B 'silvestr':4B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
131	7	Teatro in S. Francesco	42.6352769	11.9607883	Piazza Matteotti	Architettura civile	NaN	NaN	7200	t	1	36	\N	'francesc':4 's':3 'teatr':1	'francesc':4B 's':3B 'teatr':1B	0101000020E610000046C2AD71ECEB2740BFB3E2C050514540
179	11	Cascata del Pellico	42.4639626	11.7495088	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	5400	t	1	54	\N	'casc':1 'pellic':3	'casc':1B 'pellic':3B	0101000020E6100000DF20109EBF7F274098C86020633B4540
180	11	Chiesa degli Apostoli Giovanni e Andrea	42.4639626	11.7495088	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	30	\N	'andre':6 'apostol':3 'chies':1 'giovann':4	'andre':6B 'apostol':3B 'chies':1B 'giovann':4B	0101000020E6100000DF20109EBF7F274098C86020633B4540
181	11	Tomba François	42.4175098	11.6390928	Strada Provinciale 106 - Canino	Area o parco archeologico	NaN	NaN	9000	t	1	7	\N	'françois':2 'tomb':1	'françois':2B 'tomb':1B	0101000020E6100000D837E62B3747274037610CF670354540
198	12	Lungolago di Capodimonte	42.5547757	11.8910522	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	7200	t	1	15	\N	'capodimont':3 'lungolag':1	'capodimont':3B 'lungolag':1B	0101000020E6100000C60E74FE37C82740C90EE0E302474540
405	31	Biblioteca comunale	42.5446546	11.7540140	Via Roma 5	Biblioteca	NaN	NaN	9000	t	1	7	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E6100000C9737D1F0E822740D84EEF3DB7454540
199	12	Palazzo Poniatowsky	42.5465270	11.9047550	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	83	\N	'palazz':1 'poniatowsky':2	'palazz':1B 'poniatowsky':2B	0101000020E6100000F3C81F0C3CCF2740C4B0C398F4454540
115	7	Porta San Giovanni	42.6441069	11.9849554	NaN	Architettura fortificata	NaN	NaN	7200	t	1	90	\N	'giovann':3 'port':1 'san':2	'giovann':3B 'port':1B 'san':2B	0101000020E61000008609FE124CF8274060504B1872524540
253	17	Ex Chiesa di S. Giovanni	42.6449715	12.2038975	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	65	\N	'chies':2 'ex':1 'giovann':5 's':4	'chies':2B 'ex':1B 'giovann':5B 's':4B	0101000020E6100000EA78CC406568284010AD156D8E524540
20	1	Casale Monacaro Vecchio	42.7439961	11.8649880	Monacaro	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	98	\N	'casal':1 'monacar':2 'vecc':3	'casal':1B 'monacar':2B 'vecc':3B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
21	1	Casale Rufeno	42.7439961	11.8649880	Monte Rufeno	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	22	\N	'casal':1 'rufen':2	'casal':1B 'rufen':2B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
273	20	Chiesa Parrocchiale San Francesco	42.2952260	12.4091700	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	98	\N	'chies':1 'francesc':4 'parrocchial':2 'san':3	'chies':1B 'francesc':4B 'parrocchial':2B 'san':3B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
388	30	Palazzo Cordelli	42.6751490	11.8741381	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	29	\N	'cordell':2 'palazz':1	'cordell':2B 'palazz':1B	0101000020E61000000A606F078FBF2740AB764D486B564540
544	41	Chiesa di Sant'Anna	42.1593028	12.1383489	Via Sant Anna, 59	Chiesa o edificio di culto	NaN	NaN	7200	t	1	66	\N	'anna':4 'chies':1 'sant':3	'anna':4B 'chies':1B 'sant':3B	0101000020E61000000AE0C1AAD5462840A314BE0864144540
568	42	Chiesa di San Bernardino	42.4605984	12.3856056	Colle S. Bernardino	Chiesa o edificio di culto	NaN	NaN	7200	t	1	31	\N	'bernardin':4 'chies':1 'san':3	'bernardin':4B 'chies':1B 'san':3B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
38	1	Chiesa della Madonna del S. Amore	42.7439961	11.8649880	Fraz. Torre Alfina	Chiesa o edificio di culto	NaN	NaN	10800	t	1	45	\N	'amor':6 'chies':1 'madonn':3 's':5	'amor':6B 'chies':1B 'madonn':3B 's':5B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
600	45	Complesso Villa Lina (Villa Igliori)	42.2902415	12.2138064	Via Magenta, 65	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	1	\N	'compless':1 'iglior':5 'lin':3 'vill':2,4	'compless':1B 'iglior':5B 'lin':3B 'vill':2B,4B	0101000020E6100000DA594F08786D284093382BA226254540
657	49	Mitreo di Sutri	42.2471680	12.2156030	via Cassia km 50,00 - Sutri	Monumento	NaN	NaN	5400	t	1	33	\N	'mitre':1 'sutr':3	'mitre':1B 'sutr':3B	0101000020E6100000C7D63384636E2840124F7633A31F4540
50	2	Porta Albana	42.6268957	12.0909966	Piazza Trento e Trieste, 31	Architettura fortificata	NaN	NaN	5400	t	1	0	\N	'alban':2 'port':1	'alban':2B 'port':1B	0101000020E61000002A183A1B972E284063C0481E3E504540
680	50	Fontana Nova	42.2532394	11.7591747	Via di Fontana Nuova	Monumento	NaN	NaN	3600	t	1	65	\N	'fontan':1 'nov':2	'fontan':1B 'nov':2B	0101000020E6100000B7E6D88BB284274082870E266A204540
697	50	Porta Tarquinia	42.2543727	11.7591896	NaN	Architettura fortificata	NaN	NaN	9000	t	1	46	\N	'port':1 'tarquin':2	'port':1B 'tarquin':2B	0101000020E610000038EDCE7FB484274063BFDD488F204540
719	50	Torre del Magistrato	42.2543779	11.7575030	Via S. Pancrazio, 9	Architettura fortificata	NaN	NaN	3600	t	1	13	\N	'magistr':3 'torr':1	'magistr':3B 'torr':1B	0101000020E6100000683EE76ED78327409FA97C748F204540
720	50	Chiesa di San Pancrazio	42.2532394	11.7591747	Via delle Torri, 15	Chiesa o edificio di culto	NaN	NaN	7200	t	1	97	\N	'chies':1 'pancraz':4 'san':3	'chies':1B 'pancraz':4B 'san':3B	0101000020E6100000B7E6D88BB284274082870E266A204540
723	51	Ruderi Castello Del Rivellino	42.4202141	11.8702611	NaN	Architettura fortificata	NaN	NaN	7200	t	1	57	\N	'castell':2 'rivellin':4 'ruder':1	'castell':2B 'rivellin':4B 'ruder':1B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
724	51	Arco Di Poggio Fiorentino	42.4202141	11.8702611	NaN	Architettura fortificata	NaN	NaN	9000	t	1	50	\N	'arco':1 'fiorentin':4 'pogg':3	'arco':1B 'fiorentin':4B 'pogg':3B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
725	51	Cattedrale di San Giacomo	42.4202141	11.8702611	Piazza Domenico Bastianini	Chiesa o edificio di culto	NaN	NaN	3600	t	1	72	\N	'cattedral':1 'giacom':4 'san':3	'cattedral':1B 'giacom':4B 'san':3B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
740	51	Chiesa di Sant'Agostino	42.4202141	11.8702611	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	89	\N	'agostin':4 'chies':1 'sant':3	'agostin':4B 'chies':1B 'sant':3B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
741	51	Chiesa di Santa Maria del Riposo	42.4202141	11.8702611	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	19	\N	'chies':1 'mar':4 'ripos':6 'sant':3	'chies':1B 'mar':4B 'ripos':6B 'sant':3B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
742	51	"Necropoli ""Madonna dell'Olivo"""	42.4185731	11.8703089	-	Museo, galleria e/o raccolta	-	sba-em@beniculturali.it	3600	t	1	7	\N	'madonn':2 'necropol':1 'oliv':4	'madonn':2B 'necropol':1B 'oliv':4B	0101000020E6100000E1D5CD2099BD274020BEA7CD93354540
743	51	Ruderi  dell'ex Abbazia di S. Giusto	42.4202141	11.8702611	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	84	\N	'abbaz':4 'ex':3 'giust':7 'ruder':1 's':6	'abbaz':4B 'ex':3B 'giust':7B 'ruder':1B 's':6B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
745	51	RACCOLTA DI MONTEBELLO DEL MAESTRO GIUSEPPE CESETTI	42.3550533	11.8011922	CENTRO STRADA MONTEBELLO; 3	Museo, galleria e/o raccolta	761442695	-	7200	t	1	93	\N	'cesett':7 'giusepp':6 'maestr':5 'montebell':3 'raccolt':1	'cesett':7B 'giusepp':6B 'maestr':5B 'montebell':3B 'raccolt':1B	0101000020E6100000DE9E31DD359A27401FEBF362722D4540
746	51	Terme Romane della Regina (Bagni della Regina)	42.4202141	11.8702611	SP12	Area o parco archeologico	NaN	NaN	7200	t	1	90	\N	'bagn':5 'regin':4,7 'roman':2 'term':1	'bagn':5B 'regin':4B,7B 'roman':2B 'term':1B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
747	51	CHIESA DI SANTA MARIA MAGGIORE	42.4202141	11.8702611	STRADA SANTA MARIA, 	Chiesa o edificio di culto	NaN	NaN	10800	t	1	83	\N	'chies':1 'maggior':5 'mar':4 'sant':3	'chies':1B 'maggior':5B 'mar':4B 'sant':3B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
749	51	Raccolta di Montebello del Maestro Giuseppe Cesetti	42.4202141	11.8702611	Centro strada Montebello - Tuscania	Museo, Galleria e/o raccolta	NaN	NaN	3600	t	1	72	\N	'cesett':7 'giusepp':6 'maestr':5 'montebell':3 'raccolt':1	'cesett':7B 'giusepp':6B 'maestr':5B 'montebell':3B 'raccolt':1B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
750	51	NECROPOLI MADONNA DELL'OLIVO	42.4065088	11.8744394	VIA MADONNA DELL'OLIVO SNC, 1	Area o parco archeologico	NaN	NaN	7200	t	1	77	\N	'madonn':2 'necropol':1 'oliv':4	'madonn':2B 'necropol':1B 'oliv':4B	0101000020E6100000F0AA6285B6BF2740A2C4F87A08344540
751	51	Necropoli della Peschiera e Tomba a Dado	42.4202141	11.8702611	Str. Le Carceri	Area o parco archeologico	NaN	NaN	3600	t	1	6	\N	'dad':7 'necropol':1 'peschier':3 'tomb':5	'dad':7B 'necropol':1B 'peschier':3B 'tomb':5B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
752	51	Parco Torre di Lavello	42.4161568	11.8729145	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	9000	t	1	65	\N	'lavell':4 'parc':1 'torr':2	'lavell':4B 'parc':1B 'torr':2B	0101000020E61000008C683BA6EEBE2740070143A044354540
4	1	Ponte Gregoriano	42.7439961	11.8649880	Via Cassia	Monumento	NaN	NaN	7200	t	1	7	\N	'gregor':2 'pont':1	'gregor':2B 'pont':1B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
14	1	Casale Macchione	42.7439961	11.8649880	Macchione	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	97	\N	'casal':1 'macchion':2	'casal':1B 'macchion':2B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
64	2	Biblioteca della Fondazione Agosti	42.6256397	12.0980438	Piazza L. Cristofori 16	Biblioteca	+39 0761793039	NaN	3600	t	1	54	\N	'agost':4 'bibliotec':1 'fondazion':3	'agost':4B 'bibliotec':1B 'fondazion':3B	0101000020E6100000B02605CC32322840254A31F614504540
776	53	Grotte di San Lorenzo	42.2022300	12.6721370	NaN	Area o parco archeologico	NaN	NaN	5400	t	1	86	\N	'grott':1 'lorenz':4 'san':3	'grott':1B 'lorenz':4B 'san':3B	0101000020E6100000F4DC425722582940922232ACE2194540
66	2	Palazzo Vescovile	42.6269800	12.0908718	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	99	\N	'palazz':1 'vescovil':2	'palazz':1B 'vescovil':2B	0101000020E6100000DF41A2BF862E2840809F71E140504540
67	2	Chiesa di Santa Lucia	42.6269800	12.0908718	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	10	\N	'chies':1 'luc':4 'sant':3	'chies':1B 'luc':4B 'sant':3B	0101000020E6100000DF41A2BF862E2840809F71E140504540
841	58	Torre del Borgognone	42.4156807	12.1041350	NaN	Architettura fortificata	NaN	NaN	9000	t	1	70	\N	'borgognon':3 'torr':1	'borgognon':3B 'torr':1B	0101000020E6100000E8BCC62E51352840090A720635354540
103	6	Palazzo Alberti	42.2725220	12.0316620	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	74	\N	'albert':2 'palazz':1	'albert':2B 'palazz':1B	0101000020E61000004A0D6D003610284063B83A00E2224540
968	59	Borgo di Vitorchiano	42.4667750	12.1715910	NaN	Architettura fortificata	NaN	NaN	5400	t	1	4	\N	'borg':1 'vitorc':3	'borg':1B 'vitorc':3B	0101000020E61000006C938AC6DA57284092CB7F48BF3B4540
971	59	Statua Moai	42.4654270	12.1724620	Strada Provinciale 23 della Vezza, 19	Monumento	NaN	NaN	10800	t	1	43	\N	'moa':2 'statu':1	'moa':2B 'statu':1B	0101000020E6100000029B73F04C58284073D6A71C933B4540
637	48	Palazzo Chigi Albani	42.4193483	12.2323973	Via Papacqua, 471	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	84	\N	'alban':3 'chig':2 'palazz':1	'alban':3B 'chig':2B 'palazz':1B	0101000020E61000007F5B66C7FC7628400D118134AD354540
943	58	Biblioteca comunale degli Ardenti	42.4206915	12.1077763	Piazza Verdi 3	Biblioteca	+39 0761340695	NaN	9000	t	1	15	\N	'ardent':4 'bibliotec':1 'comunal':2	'ardent':4B 'bibliotec':1B 'comunal':2B	0101000020E6100000599187742E372840431A1538D9354540
945	58	Biblioteca padre Lorenzo Cozza	42.4099600	12.1178040	Via S. Maria del paradiso	Biblioteca	+39 0761343182	NaN	10800	t	1	38	\N	'bibliotec':1 'cozz':4 'lorenz':3 'padr':2	'bibliotec':1B 'cozz':4B 'lorenz':3B 'padr':2B	0101000020E61000000CAD4ECE503C28408655BC9179344540
274	20	Via Amerina	42.2824888	12.3564351	NaN	Area o parco archeologico	NaN	NaN	10800	t	1	5	\N	'amerin':2 'via':1	'amerin':2B 'via':1B	0101000020E6100000014B53A97EB628403FBECE9728244540
77	3	MUSEO ETRUSCO	42.2511180	12.0663609	PIAZZA SANT'ANGELO; 2	Museo, galleria e/o raccolta	761414531	-	5400	t	1	52	\N	'etrusc':2 'muse':1	'etrusc':2B 'muse':1B	0101000020E61000005C774E0EFA212840EDB776A224204540
202	13	Area Picnic TRIALART	42.2564918	12.1776114	Antica Str. della Valle dei Santi	Parco o Giardino di interesse storico o artistico	NaN	NaN	10800	t	1	83	\N	'are':1 'picnic':2 'trialart':3	'are':1B 'picnic':2B 'trialart':3B	0101000020E610000026CBA4E1EF5A284099582AB9D4204540
153	8	Castello Orsini	42.4197145	12.2352051	NaN	Architettura fortificata	NaN	NaN	5400	t	1	15	\N	'castell':1 'orsin':2	'castell':1B 'orsin':2B	0101000020E61000006FB488CD6C78284018946934B9354540
235	16	Pontificio Santuario Maria SS. "ad Rupes"	42.2492040	12.3761274	Piazza Cardinal Gasparri, 2	Chiesa o edificio di culto	NaN	NaN	5400	t	1	26	\N	'mar':3 'pontific':1 'rupes':6 'santuar':2 'ss':4	'mar':3B 'pontific':1B 'rupes':6B 'santuar':2B 'ss':4B	0101000020E61000004F4244C593C028402504ABEAE51F4540
236	16	Castello di Pizzo Jella	42.2517755	12.3717955	NaN	Architettura fortificata	NaN	NaN	3600	t	1	44	\N	'castell':1 'jell':4 'pizz':3	'castell':1B 'jell':4B 'pizz':3B	0101000020E61000009599D2FA5BBE28408F37F92D3A204540
604	45	Biblioteca dell'Istituzione Romolo Bellatreccia	42.2911340	12.2160390	Corso Umberto I 26	Biblioteca	+39 0761627537	bibliotecaronciglione@yahoo.it	7200	t	1	98	\N	'bellatrecc':5 'bibliotec':1 'istitu':3 'romol':4	'bellatrecc':5B 'bibliotec':1B 'istitu':3B 'romol':4B	0101000020E61000003352EFA99C6E2840786000E143254540
78	3	Necropoli rupestre di San Giuliano	42.2498341	12.0673735	Parco Suburbano di Marturanum (Comune) - Barbarano Romano	Area o parco archeologico	NaN	NaN	3600	t	1	91	\N	'giul':5 'necropol':1 'rupestr':2 'san':4	'giul':5B 'necropol':1B 'rupestr':2B 'san':4B	0101000020E6100000EF3B86C77E2228407A765490FA1F4540
583	42	Piazza della Libertà	42.4605984	12.3856056	NaN	Monumento	NaN	NaN	5400	t	1	84	\N	'libert':3 'piazz':1	'libert':3B 'piazz':1B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
342	26	Cascata del Salabrone	42.5494260	11.7256520	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	7200	t	1	57	\N	'casc':1 'salabron':3	'casc':1B 'salabron':3B	0101000020E6100000D28DB0A8887327403AC9569753464540
632	48	Chiesa di San Giorgio	42.4187606	12.2343075	Frazione Terracino	Chiesa o edificio di culto	NaN	NaN	9000	t	1	2	\N	'chies':1 'giorg':4 'san':3	'chies':1B 'giorg':4B 'san':3B	0101000020E6100000406A1327F77728403AED84F299354540
633	48	Monumento naturale Corviano	42.4768241	12.1962075	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	5400	t	1	25	\N	'corv':3 'monument':1 'natural':2	'corv':3B 'monument':1B 'natural':2B	0101000020E6100000B875374F75642840EAB87592083D4540
635	48	Biblioteca dei padri passionisti	42.4235631	12.2766627	Via del Convento	Biblioteca	+39 0761759057	NaN	3600	t	1	53	\N	'bibliotec':1 'padr':3 'passion':4	'bibliotec':1B 'padr':3B 'passion':4B	0101000020E6100000CE0BC1BBA68D28406D25CF5037364540
639	48	Centro Storico Rione Rocca	42.4187606	12.2343075	NaN	Architettura fortificata	NaN	NaN	10800	t	1	7	\N	'centr':1 'rion':3 'rocc':4 'storic':2	'centr':1B 'rion':3B 'rocc':4B 'storic':2B	0101000020E6100000406A1327F77728403AED84F299354540
675	50	Archivio Storico	42.2532394	11.7591747	Via dei Granari	Archivio di Stato	NaN	NaN	7200	t	1	21	\N	'archiv':1 'storic':2	'archiv':1B 'storic':2B	0101000020E6100000B7E6D88BB284274082870E266A204540
700	50	Palazzo dei Priori	42.2532394	11.7591747	via delle Torri 29-33	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	45	\N	'palazz':1 'prior':3	'palazz':1B 'prior':3B	0101000020E6100000B7E6D88BB284274082870E266A204540
251	17	Cripta del Paradiso	42.6449715	12.2038975	NaN	Area o parco archeologico	NaN	NaN	9000	t	1	69	\N	'cript':1 'paradis':3	'cript':1B 'paradis':3B	0101000020E6100000EA78CC406568284010AD156D8E524540
944	58	Fontana del Borgo Dentro	42.4168441	12.1051148	NaN	Monumento	NaN	NaN	5400	t	1	14	\N	'borg':3 'dentr':4 'fontan':1	'borg':3B 'dentr':4B 'fontan':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
142	8	Chiesa di S. Maria del Pozzarello	42.4819280	12.2487640	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	96	\N	'chies':1 'mar':4 'pozzarell':6 's':3	'chies':1B 'mar':4B 'pozzarell':6B 's':3B	0101000020E610000023D8B8FE5D7F28406B8313D1AF3D4540
628	48	Monte Cimino	42.4077999	12.2012234	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	10800	t	1	57	\N	'cimin':2 'mont':1	'cimin':2B 'mont':1B	0101000020E61000003E61E4C006672840F2E780C932344540
255	18	Biblioteca del Centro comunitario ex Convento S. Giovanni Battista	42.6855509	11.9065690	Via Roma 5	Biblioteca	+39 0761912275	NaN	7200	t	1	33	\N	'battist':9 'bibliotec':1 'centr':3 'comunitar':4 'convent':6 'ex':5 'giovann':8 's':7	'battist':9B 'bibliotec':1B 'centr':3B 'comunitar':4B 'convent':6B 'ex':5B 'giovann':8B 's':7B	0101000020E61000008522DDCF29D02740279FC321C0574540
56	2	Chiesa dei SS. Andrea e Bonaventura	42.6269800	12.0908718	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	73	\N	'andre':4 'bonaventur':6 'chies':1 'ss':3	'andre':4B 'bonaventur':6B 'chies':1B 'ss':3B	0101000020E6100000DF41A2BF862E2840809F71E140504540
57	2	Porta di sotto (o Porta di Santa Maria)	42.6269800	12.0908718	Via S. Maria del Cassero, 446-481	Architettura fortificata	NaN	NaN	5400	t	1	52	\N	'mar':8 'port':1,5 'sant':7 'sott':3	'mar':8B 'port':1B,5B 'sant':7B 'sott':3B	0101000020E6100000DF41A2BF862E2840809F71E140504540
243	17	Chiesa dei santi Giacomo e Filippo	42.6449715	12.2038975	Piazza Maggiore, 21	Chiesa o edificio di culto	NaN	NaN	5400	t	1	89	\N	'chies':1 'filipp':6 'giacom':4 'sant':3	'chies':1B 'filipp':6B 'giacom':4B 'sant':3B	0101000020E6100000EA78CC406568284010AD156D8E524540
90	5	Fontana Vecchia	42.4660738	12.3130342	NaN	Monumento	NaN	NaN	7200	t	1	1	\N	'fontan':1 'vecc':2	'fontan':1B 'vecc':2B	0101000020E61000001E0FC70446A02840DF42684EA83B4540
278	20	Castel Borghetto	42.2952260	12.4091700	NaN	Architettura fortificata	NaN	NaN	3600	t	1	13	\N	'borghett':2 'castel':1	'borghett':2B 'castel':1B	0101000020E61000003602F1BA7ED12840E6762FF7C9254540
303	21	Chiesa di S. Michele Arcangelo	42.6053622	12.1876584	S. Michele in Teverina	Chiesa o edificio di culto	NaN	NaN	9000	t	1	34	\N	'arcangel':5 'chies':1 'michel':4 's':3	'arcangel':5B 'chies':1B 'michel':4B 's':3B	0101000020E6100000AEA305C314602840089E31827C4D4540
305	21	Palazzo Mottura	42.6053622	12.1876584	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	29	\N	'mottur':2 'palazz':1	'mottur':2B 'palazz':1B	0101000020E6100000AEA305C314602840089E31827C4D4540
335	25	Chiesa di S. Agostino	42.2261788	12.4431811	Piazza della Collegiata	Chiesa o edificio di culto	NaN	NaN	10800	t	1	36	\N	'agostin':4 'chies':1 's':3	'agostin':4B 'chies':1B 's':3B	0101000020E61000001E6915A2E8E2284036864A6DF31C4540
477	36	Palazzo del Cardinale Ludovico Calino	42.2665210	11.8937590	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	25	\N	'calin':5 'cardinal':3 'ludov':4 'palazz':1	'calin':5B 'cardinal':3B 'ludov':4B 'palazz':1B	0101000020E6100000E60297C79AC927403E59315C1D224540
496	37	Chiesa di Sant' Andrea in Campo	42.5379248	12.0309974	Piazza Vittorio Emanuele, 9	Chiesa o edificio di culto	NaN	NaN	5400	t	1	31	\N	'andre':4 'camp':6 'chies':1 'sant':3	'andre':4B 'camp':6B 'chies':1B 'sant':3B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
497	37	Basilica di Santa Margherita	42.5379248	12.0309974	Piazzale Santa Margherita	Chiesa o edificio di culto	NaN	NaN	3600	t	1	85	\N	'basil':1 'margher':4 'sant':3	'basil':1B 'margher':4B 'sant':3B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
498	37	Convento di S. Agostino	42.5379248	12.0309974	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	26	\N	'agostin':4 'convent':1 's':3	'agostin':4B 'convent':1B 's':3B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
499	37	Chiesa di Santa Maria della Neve	42.5379248	12.0309974	Via XXIV Maggio, 4	Chiesa o edificio di culto	NaN	NaN	3600	t	1	26	\N	'chies':1 'mar':4 'nev':6 'sant':3	'chies':1B 'mar':4B 'nev':6B 'sant':3B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
892	58	MUSEO DEL SODALIZIO DEI FACCHINI DI SANTA ROSA	42.4138600	12.1059000	VIA S. PELLEGRINO 60-62	Museo, galleria e/o raccolta	761345157	-	10800	t	1	3	\N	'facchin':5 'muse':1 'ros':8 'sant':7 'sodaliz':3	'facchin':5B 'muse':1B 'ros':8B 'sant':7B 'sodaliz':3B	0101000020E6100000F54A598638362840B08F4E5DF9344540
500	37	Museo dell'architettura di Antonio da Sangallo il Giovane	42.5368520	12.0276249	piazza della Rocca	Museo, galleria e/o raccolta	0761 832060	museosangallo@comune.montefiascone.vt.it	5400	t	1	7	\N	'anton':5 'architettur':3 'giovan':9 'muse':1 'sangall':7	'anton':5B 'architettur':3B 'giovan':9B 'muse':1B 'sangall':7B	0101000020E61000004C1CD4D9240E28406765FB90B7444540
502	38	Antica Fontana Papa Leone	41.7537880	12.2894570	NaN	Monumento	NaN	NaN	9000	t	1	27	\N	'antic':1 'fontan':2 'leon':4 'pap':3	'antic':1B 'fontan':2B 'leon':4B 'pap':3B	0101000020E6100000513239B533942840020F0C207CE04440
503	38	Lago di Monterosi	42.2062426	12.3013347	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	7200	t	1	46	\N	'lag':1 'monter':3	'lag':1B 'monter':3B	0101000020E6100000C94CB38A489A284061055328661A4540
504	38	Chiesa di San Giuseppe	42.1958230	12.3084690	Via Caduti di tutte le guerre, 2/1	Chiesa o edificio di culto	NaN	NaN	7200	t	1	35	\N	'chies':1 'giusepp':4 'san':3	'chies':1B 'giusepp':4B 'san':3B	0101000020E6100000DFA815A6EF9D2840FD6662BA10194540
505	38	Palazzo del Cardinale	42.1958230	12.3084690	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	45	\N	'cardinal':3 'palazz':1	'cardinal':3B 'palazz':1B	0101000020E6100000DFA815A6EF9D2840FD6662BA10194540
506	38	Parrocchia S. Croce	42.1958230	12.3084690	Via Roma, 2	Chiesa o edificio di culto	NaN	NaN	5400	t	1	71	\N	'croc':3 'parrocc':1 's':2	'croc':3B 'parrocc':1B 's':2B	0101000020E6100000DFA815A6EF9D2840FD6662BA10194540
507	39	Isola Conversina	42.2428240	12.3455700	NaN	Architettura fortificata	NaN	NaN	7200	t	1	24	\N	'conversin':2 'isol':1	'conversin':2B 'isol':1B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
508	39	Chiesa Di San Rocco	42.2428240	12.3455700	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	64	\N	'chies':1 'rocc':4 'san':3	'chies':1B 'rocc':4B 'san':3B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
510	39	Palazzo comunale	42.2428240	12.3455700	Piazza del Comune, 20	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	90	\N	'comunal':2 'palazz':1	'comunal':2B 'palazz':1B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
558	42	Palazzo Manni	42.4605984	12.3856056	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	39	\N	'mann':2 'palazz':1	'mann':2B 'palazz':1B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
579	42	Seripola Porto Fluviale sul Tevere	42.4605984	12.3856056	NaN	Architettura fortificata	NaN	NaN	7200	t	1	99	\N	'fluvial':3 'port':2 'seripol':1 'tev':5	'fluvial':3B 'port':2B 'seripol':1B 'tev':5B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
653	49	Biblioteca comunale	42.2470230	12.2150670	Piazza S. Rocco 4	Biblioteca	NaN	NaN	7200	t	1	96	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
874	58	Palazzo Gatti	42.4143336	12.1069160	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	97	\N	'gatt':2 'palazz':1	'gatt':2B 'palazz':1B	0101000020E610000099D6A6B1BD36284025D126E208354540
875	58	Convento dei Cappuccini	42.4168441	12.1051148	Via S. Crispino, 6	Chiesa o edificio di culto	NaN	NaN	5400	t	1	48	\N	'cappuccin':3 'convent':1	'cappuccin':3B 'convent':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
876	58	Area Archeologica Antica Città di Ferento	42.4206766	12.1076690	Strada Provinciale Teverina; Km 8;000	Museo, galleria e/o raccolta	-	-	9000	t	1	73	\N	'antic':3 'archeolog':2 'are':1 'citt':4 'ferent':6	'antic':3B 'archeolog':2B 'are':1B 'citt':4B 'ferent':6B	0101000020E61000000796236420372840A39817BBD8354540
128	7	Anfiteatro Mercatello	42.6502733	11.9880751	NaN	Monumento	NaN	NaN	9000	t	1	20	\N	'anfiteatr':1 'mercatell':2	'anfiteatr':1B 'mercatell':2B	0101000020E6100000DEFBC0FAE4F92740237BCE273C534540
344	26	Palazzo Comunale	42.5494260	11.7256520	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	32	\N	'comunal':2 'palazz':1	'comunal':2B 'palazz':1B	0101000020E6100000D28DB0A8887327403AC9569753464540
345	26	Convento di San Rocco	42.5494260	11.7256520	Via Circonvallazione, 14	Chiesa o edificio di culto	NaN	NaN	10800	t	1	3	\N	'convent':1 'rocc':4 'san':3	'convent':1B 'rocc':4B 'san':3B	0101000020E6100000D28DB0A8887327403AC9569753464540
346	26	Complesso monastero e chiesa delle Clarisse	42.5494260	11.7256520	Corso Vittorio Emanuele, 68	Chiesa o edificio di culto	NaN	NaN	3600	t	1	65	\N	'chies':4 'clariss':6 'compless':1 'monaster':2	'chies':4B 'clariss':6B 'compless':1B 'monaster':2B	0101000020E6100000D28DB0A8887327403AC9569753464540
347	26	MUSEO CIVICO FERRANTE RITTATORE VONWILLER	42.5498000	11.7270600	VIA COLLE SAN MARTINO; 16	Museo, galleria e/o raccolta	761458849	museofarnese@virgilio.it  museofarnese@simulabo.it	9000	t	1	16	\N	'civic':2 'ferrant':3 'muse':1 'rittator':4 'vonwiller':5	'civic':2B 'ferrant':3B 'muse':1B 'rittator':4B 'vonwiller':5B	0101000020E6100000A3755435417427409FABADD85F464540
348	26	Chiesa di S. Maria delle Grazie	42.5494260	11.7256520	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	50	\N	'chies':1 'graz':6 'mar':4 's':3	'chies':1B 'graz':6B 'mar':4B 's':3B	0101000020E6100000D28DB0A8887327403AC9569753464540
349	27	Cinema Teatro	42.3786562	12.4037094	Piazza S.Maria,1	Architettura civile	NaN	NaN	7200	t	1	76	\N	'cinem':1 'teatr':2	'cinem':1B 'teatr':2B	0101000020E6100000F22C9CFFB2CE2840BDB66DCE77304540
350	27	Castello Di Rocchette	42.3947666	12.4718039	NaN	Architettura fortificata	NaN	NaN	7200	t	1	100	\N	'castell':1 'rocchett':3	'castell':1B 'rocchett':3B	0101000020E61000002140E14790F12840CC4642B687324540
351	27	Complesso monastico di S. Benedetto	42.3732869	12.4028042	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	83	\N	'benedett':5 'compless':1 'monast':2 's':4	'benedett':5B 'compless':1B 'monast':2B 's':4B	0101000020E61000000562235A3CCE28403AC379DDC72F4540
352	27	Chiesa di S. Maria Assunta	42.3732869	12.4028042	Piazza Duomo, 1	Chiesa o edificio di culto	NaN	NaN	3600	t	1	49	\N	'assunt':5 'chies':1 'mar':4 's':3	'assunt':5B 'chies':1B 'mar':4B 's':3B	0101000020E61000000562235A3CCE28403AC379DDC72F4540
659	49	La Torre dell'Orologio	42.2470230	12.2150670	Piazza del Comune	Architettura fortificata	NaN	NaN	7200	t	1	16	\N	'orolog':4 'torr':2	'orolog':4B 'torr':2B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
353	27	Castello Palazzo Ducale (o Castello Altemps)	42.4365350	12.7880590	Via degli Altemps, 8	Chiesa o edificio di culto	NaN	NaN	9000	t	1	25	\N	'altemps':6 'castell':1,5 'ducal':3 'palazz':2	'altemps':6B 'castell':1B,5B 'ducal':3B 'palazz':2B	0101000020E61000000EA320787C9329409947FE60E0374540
354	27	Centro Storico	42.3732869	12.4028042	NaN	Architettura fortificata	NaN	NaN	7200	t	1	61	\N	'centr':1 'storic':2	'centr':1B 'storic':2B	0101000020E61000000562235A3CCE28403AC379DDC72F4540
355	27	Biblioteca comunale	42.3732869	12.4028042	Via S. Chiara 3	Biblioteca	NaN	NaN	3600	t	1	64	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E61000000562235A3CCE28403AC379DDC72F4540
356	27	Chiesa di San Famiano	42.3732869	12.4028042	SP34	Chiesa o edificio di culto	NaN	NaN	10800	t	1	21	\N	'chies':1 'fam':4 'san':3	'chies':1B 'fam':4B 'san':3B	0101000020E61000000562235A3CCE28403AC379DDC72F4540
357	27	Chiesa di S. Agostino	42.3732869	12.4028042	Via Maria de Mattias, 1	Chiesa o edificio di culto	NaN	NaN	7200	t	1	60	\N	'agostin':4 'chies':1 's':3	'agostin':4B 'chies':1B 's':3B	0101000020E61000000562235A3CCE28403AC379DDC72F4540
184	11	Terme di Vulci	42.4615398	11.6371173	Via delle Terme	Parco o Giardino di interesse storico o artistico	NaN	NaN	3600	t	1	12	\N	'term':1 'vulc':3	'term':1B 'vulc':3B	0101000020E6100000806E1E3D34462740B46675BC133B4540
338	26	Centro Storico di Farnese	42.5477480	11.7249020	NaN	Architettura fortificata	NaN	NaN	7200	t	1	51	\N	'centr':1 'farnes':4 'storic':2	'centr':1B 'farnes':4B 'storic':2B	0101000020E6100000289CDD5A267327408639419B1C464540
394	30	Necropoli di Centocamere	42.6745290	11.8722530	NaN	Area o parco archeologico	NaN	NaN	7200	t	1	1	\N	'centocam':3 'necropol':1	'centocam':3B 'necropol':1B	0101000020E610000000ADF9F197BE27400F9A5DF756564540
423	32	I Quattro Archi	42.6290280	11.8274530	NaN	Architettura fortificata	NaN	NaN	3600	t	1	74	\N	'archi':3 'quattr':2	'archi':3B 'quattr':2B	0101000020E610000045F46BEBA7A72740572250FD83504540
457	34	Torre dell' Orologio	42.5339112	11.9249120	Via del Castello, 25	Architettura fortificata	NaN	NaN	9000	t	1	26	\N	'orolog':3 'torr':1	'orolog':3B 'torr':1B	0101000020E61000001D5BCF108ED92740EB7BC33357444540
484	37	Chiesa di Santa Maria di Montedoro	42.5379248	12.0309974	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	9	\N	'chies':1 'mar':4 'montedor':6 'sant':3	'chies':1B 'mar':4B 'montedor':6B 'sant':3B	0101000020E6100000A68526E4DE0F28408ADA47B8DA444540
548	41	Biblioteca comunale	42.1593028	12.1383489	Piazza Claudia	Biblioteca	NaN	NaN	5400	t	1	83	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E61000000AE0C1AAD5462840A314BE0864144540
569	42	Palazzo Vescovile 	42.4605984	12.3856056	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	30	\N	'palazz':1 'vescovil':2	'palazz':1B 'vescovil':2B	0101000020E6100000154FE2186EC52840834B6CE3F43A4540
660	49	MUSEO DEL PATRIMONIUM	42.2410805	12.2245358	VIA DI PORTAVECCHIA 79	Museo, galleria e/o raccolta	761600867	biblio@comune.sutri.vt.it	3600	t	1	32	\N	'muse':1 'patrimonium':3	'muse':1B 'patrimonium':3B	0101000020E6100000F98F3B5BF6722840079ACFB9DB1E4540
35	1	Teatro Boni	42.7481852	11.8942006	Piazza della Costituente	Architettura civile	NaN	NaN	5400	t	1	44	\N	'bon':2 'teatr':1	'bon':2B 'teatr':1B	0101000020E61000008D203AA9D4C92740F5AC5A88C45F4540
36	1	Torre Julia de Jacopo	42.7422091	11.8712540	Via Julia De Jacopo, 55	Architettura fortificata	NaN	NaN	7200	t	1	41	\N	'de':3 'jacop':4 'jul':2 'torr':1	'de':3B 'jacop':4B 'jul':2B 'torr':1B	0101000020E6100000B404190115BE274094A531B5005F4540
37	1	Chiesa di S. Stefano	42.7439961	11.8649880	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	65	\N	'chies':1 's':3 'stef':4	'chies':1B 's':3B 'stef':4B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
587	42	MUSEO DELLE CONFRATERNITE	42.4574411	12.3869837	PIAZZA DEL POPOLO; SNC	Museo, Galleria e/o raccolta	3206280189	robertorondelli@confraterniteorte.it	3600	t	1	78	\N	'confratern':3 'muse':1	'confratern':3B 'muse':1B	0101000020E61000008F2B3FBA22C62840522C126E8D3A4540
41	1	Palazzo Caterini	42.7439961	11.8649880	Piazza Girolamo Fabrizio, 8	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	56	\N	'caterin':2 'palazz':1	'caterin':2B 'palazz':1B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
42	1	Museo della città	42.7436932	11.8680157	piazzetta dell'orologio	Museo, galleria e/o raccolta	0761 796914	info@simulabo.it	10800	t	1	43	\N	'citt':3 'muse':1	'citt':3B 'muse':1B	0101000020E610000040D4C78D6CBC2740F920BA56315F4540
43	1	museo della città	42.7436932	11.8680157	piazzetta dell'orologio	Museo, galleria e/o raccolta	0761 796914	info@simulabo.it	5400	t	1	17	\N	'citt':3 'muse':1	'citt':3B 'muse':1B	0101000020E610000040D4C78D6CBC2740F920BA56315F4540
283	20	Fontana dei Draghi	42.2889815	12.4117738	Piazza Giacomo Matteotti, 48	Monumento	NaN	NaN	9000	t	1	40	\N	'drag':3 'fontan':1	'drag':3B 'fontan':1B	0101000020E610000005B3F803D4D2284013D38558FD244540
588	43	Chiesa di San Bernardino da Siena	42.5179320	11.8282734	Piazza Guglielmo Marconi, 11	Chiesa o edificio di culto	NaN	NaN	10800	t	1	43	\N	'bernardin':4 'chies':1 'san':3 'sien':6	'bernardin':4B 'chies':1B 'san':3B 'sien':6B	0101000020E6100000204B7A7313A82740A4C684984B424540
590	43	Portico Del Palazzo Comunale	42.5179320	11.8282734	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	74	\N	'comunal':4 'palazz':3 'portic':1	'comunal':4B 'palazz':3B 'portic':1B	0101000020E6100000204B7A7313A82740A4C684984B424540
591	44	Chiesa di S. Maria del Giglio	42.7571602	11.8302614	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	22	\N	'chies':1 'gigl':6 'mar':4 's':3	'chies':1B 'gigl':6B 'mar':4B 's':3B	0101000020E61000002943B00518A927409A6A1CA0EA604540
592	44	Oratorio di S. Antonio	42.7571602	11.8302614	Via S. Cassiano, 15	Chiesa o edificio di culto	NaN	NaN	7200	t	1	12	\N	'anton':4 'orator':1 's':3	'anton':4B 'orator':1B 's':3B	0101000020E61000002943B00518A927409A6A1CA0EA604540
593	44	Palazzo di Guido Ascanio Sforza	42.7571602	11.8302614	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	54	\N	'ascan':4 'guid':3 'palazz':1 'sforz':5	'ascan':4B 'guid':3B 'palazz':1B 'sforz':5B	0101000020E61000002943B00518A927409A6A1CA0EA604540
594	44	Museo della civiltà contadina di Proceno	42.7571602	11.8302614	Piazza della Libertà - Proceno	Museo, Galleria e/o raccolta	NaN	NaN	10800	t	1	2	\N	'civilt':3 'contadin':4 'muse':1 'procen':6	'civilt':3B 'contadin':4B 'muse':1B 'procen':6B	0101000020E61000002943B00518A927409A6A1CA0EA604540
595	44	Castello di Proceno (o Rocca Medievale-Castello della Contessa Matilde)	42.7571602	11.8302614	Corso Regina Margherita, 155	Architettura fortificata	NaN	NaN	9000	t	1	66	\N	'castell':1,8 'contess':10 'matild':11 'medieval':7 'medievale-castell':6 'procen':3 'rocc':5	'castell':1B,8B 'contess':10B 'matild':11B 'medieval':7B 'medievale-castell':6B 'procen':3B 'rocc':5B	0101000020E61000002943B00518A927409A6A1CA0EA604540
596	44	Chiesa di S. Agnese	42.7571602	11.8302614	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	20	\N	'agnes':4 'chies':1 's':3	'agnes':4B 'chies':1B 's':3B	0101000020E61000002943B00518A927409A6A1CA0EA604540
597	44	Chiesa del SS. Salvatore	42.7571602	11.8302614	Piazza S. Salvatore, 1	Chiesa o edificio di culto	NaN	NaN	5400	t	1	68	\N	'chies':1 'salvator':4 'ss':3	'chies':1B 'salvator':4B 'ss':3B	0101000020E61000002943B00518A927409A6A1CA0EA604540
652	49	Torre San Paolo	42.2470230	12.2150670	SR2	Architettura fortificata	NaN	NaN	10800	t	1	97	\N	'paol':3 'san':2 'torr':1	'paol':3B 'san':2B 'torr':1B	0101000020E6100000CDE506431D6E28400E2E1D739E1F4540
138	7	Porta Romana	42.6441069	11.9849554	NaN	Architettura fortificata	NaN	NaN	5400	t	1	96	\N	'port':1 'roman':2	'port':1B 'roman':2B	0101000020E61000008609FE124CF8274060504B1872524540
28	1	Palazzo Comunale	42.7439961	11.8649880	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	22	\N	'comunal':2 'palazz':1	'comunal':2B 'palazz':1B	0101000020E61000006ADD06B5DFBA2740FFECA2433B5F4540
674	50	Chiesa di San Giacomo	42.2532394	11.7591747	Via S. Giacomo	Chiesa o edificio di culto	NaN	NaN	7200	t	1	16	\N	'chies':1 'giacom':4 'san':3	'chies':1B 'giacom':4B 'san':3B	0101000020E6100000B7E6D88BB284274082870E266A204540
711	50	Chiesa di San Giovanni	42.2532394	11.7591747	Via Roma, 2	Chiesa o edificio di culto	NaN	NaN	10800	t	1	44	\N	'chies':1 'giovann':4 'san':3	'chies':1B 'giovann':4B 'san':3B	0101000020E6100000B7E6D88BB284274082870E266A204540
766	52	Rocca Farnese	42.5509834	11.9128378	NaN	Architettura fortificata	NaN	NaN	3600	t	1	71	\N	'farnes':2 'rocc':1	'farnes':2B 'rocc':1B	0101000020E6100000ED1AE3795FD32740C7D1C19F86464540
851	58	Chiesa di San Silvestro	42.4168441	12.1051148	Via dei Pellegrini, 23	Chiesa o edificio di culto	NaN	NaN	3600	t	1	25	\N	'chies':1 'san':3 'silvestr':4	'chies':1B 'san':3B 'silvestr':4B	0101000020E6100000B3A6689BD1352840E983C0255B354540
916	58	Teatro S.Leonardo	42.4180272	12.0651056	Via Cavour,9	Architettura civile	NaN	NaN	7200	t	1	44	\N	's.leonardo':2 'teatr':1	's.leonardo':2B 'teatr':1B	0101000020E6100000AB926D8555212840526B50EA81354540
939	58	Chiesa di Santa Maria in Gradi	42.4168441	12.1051148	S. Maria in Gradi, Via Santa Maria in Gradi	Chiesa o edificio di culto	NaN	NaN	5400	t	1	54	\N	'chies':1 'grad':6 'mar':4 'sant':3	'chies':1B 'grad':6B 'mar':4B 'sant':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
940	58	Porta Fiorentina	42.4224084	12.1049532	NaN	Architettura fortificata	NaN	NaN	7200	t	1	70	\N	'fiorentin':2 'port':1	'fiorentin':2B 'port':1B	0101000020E61000009A38036DBC35284021C77B7A11364540
941	58	Chiesa di Santa Maria Nuova	42.4168441	12.1051148	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	34	\N	'chies':1 'mar':4 'nuov':5 'sant':3	'chies':1B 'mar':4B 'nuov':5B 'sant':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
942	58	Chiesa di San Sisto	42.4168441	12.1051148	Piazza S. Sisto, 6	Chiesa o edificio di culto	NaN	NaN	7200	t	1	65	\N	'chies':1 'san':3 'sist':4	'chies':1B 'san':3B 'sist':4B	0101000020E6100000B3A6689BD1352840E983C0255B354540
947	58	Domus Dei	42.4168441	12.1051148	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	97	\N	'domus':1	'domus':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
961	58	Biblioteca dell'Istituto tecnico industriale e per geometri Leonardo da Vinci	42.4236529	12.0965347	Via A. Volta 26	Biblioteca	NaN	luigi.graziotti@poste.it	7200	t	1	94	\N	'bibliotec':1 'geometr':8 'industrial':5 'istit':3 'leonard':9 'tecnic':4 'vinc':11	'bibliotec':1B 'geometr':8B 'industrial':5B 'istit':3B 'leonard':9B 'tecnic':4B 'vinc':11B	0101000020E6100000BCDB06FF6C312840832D1B423A364540
890	58	Fontana del Pegaso	42.4168441	12.1051148	Parco Villa Lante	Monumento	NaN	NaN	5400	t	1	96	\N	'fontan':1 'pegas':3	'fontan':1B 'pegas':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
883	58	Chiesa di Santa Maria della Porta	42.4168441	12.1051148	Piazza Castello	Chiesa o edificio di culto	NaN	NaN	3600	t	1	68	\N	'chies':1 'mar':4 'port':6 'sant':3	'chies':1B 'mar':4B 'port':6B 'sant':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
953	58	Palazzo Tignosini	42.4168441	12.1051148	Via S. Lorenzo, 34	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	2	\N	'palazz':1 'tignosin':2	'palazz':1B 'tignosin':2B	0101000020E6100000B3A6689BD1352840E983C0255B354540
54	2	Palazzo Cristofori	42.6269800	12.0908718	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	96	\N	'cristofor':2 'palazz':1	'cristofor':2B 'palazz':1B	0101000020E6100000DF41A2BF862E2840809F71E140504540
55	2	Chiesa di S. Girolamo	42.6269800	12.0908718	Castel Cellesi	Chiesa o edificio di culto	NaN	NaN	10800	t	1	34	\N	'chies':1 'girolam':4 's':3	'chies':1B 'girolam':4B 's':3B	0101000020E6100000DF41A2BF862E2840809F71E140504540
917	58	MUSEO DEL BRIGANTAGGIO	42.4168441	12.1051148	VIA GUGLIELMO MARCONI, 19	Museo, galleria e/o raccolta	NaN	NaN	5400	t	1	57	\N	'brigantagg':3 'muse':1	'brigantagg':3B 'muse':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
169	10	Palazzo Farnese	42.3279900	12.2377600	Piazzale Farnese; 1	Villa o Palazzo di interesse storico o artistico	0761 646052	-	7200	t	1	86	Il Palazzo fu fatto costruire da papa Paolo III, al secolo Alessandro Farnese, per il figlio Pierluigi, come sede di amministrazione dei beni nel vasto territorio canepinese.\n\nAmpliata successivamente nel lato sinistro, la struttura ha nella parte destra un enorme muro di sostegno abbellito da simboli e da una fontana quasi semicircolare.\n\nL’immobile è solido, espressione di quell’architettura del XVI secolo che supera il linguaggio decorativo e si limita alla pura funzione delle forme. È composto da 3 piani fuori terra e da una torre campanaria posta alla sommità del nucleo originario.\nSono pregevoli i soffitti lignei decorati con formelle in ceramica rappresentanti il giglio farnesiano, presenti nella sala consiliare e al piano terra. Il giglio è riproposto sulla chiave dell’arco del Portone principale in blocchi di peperino bugnato e negli edifici circostanti la piazza.	'3':81 'abbell':45 'alessandr':13 'amministr':22 'ampli':29 'architettur':61 'arco':125 'ben':24 'blocc':130 'bugn':133 'campanar':89 'canepines':28 'ceram':105 'chiav':123 'circost':137 'compost':79 'consil':113 'costru':6 'decor':69,101 'destr':39 'edif':136 'enorm':41 'espression':58 'farnes':14,109 'farneseil':2 'fatt':5 'figl':17 'fontan':51 'form':77 'formell':103 'funzion':75 'fuor':83 'gigl':108,119 'iii':10 'immobil':55 'lat':32 'ligne':100 'lim':72 'linguagg':68 'mur':42 'nucle':94 'originar':95 'palazz':1,3 'paol':9 'pap':8 'part':38 'peperin':132 'pian':82,116 'piazz':139 'pierluig':18 'porton':127 'post':90 'pregevol':97 'present':110 'principal':128 'pur':74 'quas':52 'quell':60 'rappresent':106 'ripropost':121 'sal':112 'secol':12,64 'sed':20 'semicircol':53 'simbol':47 'sinistr':33 'soffitt':99 'solid':57 'sommit':92 'sostegn':44 'struttur':35 'success':30 'super':66 'terr':84,117 'territor':27 'torr':88 'vast':26 'xvi':63	'3':82A 'abbell':46A 'alessandr':14A 'amministr':23A 'ampli':30A 'architettur':62A 'arco':126A 'ben':25A 'blocc':131A 'bugn':134A 'campanar':90A 'canepines':29A 'ceram':106A 'chiav':124A 'circost':138A 'compost':80A 'consil':114A 'costru':7A 'decor':70A,102A 'destr':40A 'edif':137A 'enorm':42A 'espression':59A 'farnes':2B,15A,110A 'fatt':6A 'figl':18A 'fontan':52A 'form':78A 'formell':104A 'funzion':76A 'fuor':84A 'gigl':109A,120A 'iii':11A 'immobil':56A 'lat':33A 'ligne':101A 'lim':73A 'linguagg':69A 'mur':43A 'nucle':95A 'originar':96A 'palazz':1B,4A 'paol':10A 'pap':9A 'part':39A 'peperin':133A 'pian':83A,117A 'piazz':140A 'pierluig':19A 'porton':128A 'post':91A 'pregevol':98A 'present':111A 'principal':129A 'pur':75A 'quas':53A 'quell':61A 'rappresent':107A 'ripropost':122A 'sal':113A 'secol':13A,65A 'sed':21A 'semicircol':54A 'simbol':48A 'sinistr':34A 'soffitt':100A 'solid':58A 'sommit':93A 'sostegn':45A 'struttur':36A 'success':31A 'super':67A 'terr':85A,118A 'territor':28A 'torr':89A 'vast':27A 'xvi':64A	0101000020E61000000B98C0ADBB79284020B58993FB294540
962	58	Biblioteca della Facoltà di economia dell'Università degli studi della Tuscia	42.4239971	12.1100455	Via del Paradiso 47	Biblioteca	+39 0761357725	ecobib@unitus.it	5400	t	1	15	\N	'bibliotec':1 'econom':5 'facolt':3 'stud':9 'tusc':11 'univers':7	'bibliotec':1B 'econom':5B 'facolt':3B 'stud':9B 'tusc':11B 'univers':7B	0101000020E6100000D9243FE257382840A70C778945364540
116	7	Pietre Lanciate	42.6325494	11.9972146	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	3600	t	1	93	\N	'lanc':2 'pietr':1	'lanc':2B 'pietr':1B	0101000020E6100000FC2F7CE992FE27405E0DF560F7504540
219	14	Chiesa Santa Lucia	42.3266250	12.2357660	NaN	Chiesa o edificio di culto	NaN	NaN	9000	t	1	67	\N	'chies':1 'luc':3 'sant':2	'chies':1B 'luc':3B 'sant':2B	0101000020E610000079043752B67828402B8716D9CE294540
415	31	Chiesa della Madonna della Neve	42.5446546	11.7540140	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	26	\N	'chies':1 'madonn':3 'nev':5	'chies':1B 'madonn':3B 'nev':5B	0101000020E6100000C9737D1F0E822740D84EEF3DB7454540
475	36	Chiesa dell'Addolorata	42.2665210	11.8937590	Via Vittorio Emanuele, 1091	Chiesa o edificio di culto	NaN	NaN	10800	t	1	31	\N	'addolor':3 'chies':1	'addolor':3B 'chies':1B	0101000020E6100000E60297C79AC927403E59315C1D224540
476	36	Castello di Rocca Respampani	42.2665210	11.8937590	NaN	Architettura fortificata	NaN	NaN	3600	t	1	33	\N	'castell':1 'respampan':4 'rocc':3	'castell':1B 'respampan':4B 'rocc':3B	0101000020E6100000E60297C79AC927403E59315C1D224540
478	36	Biblioteca comunale	42.2665210	11.8937590	Via Vittorio Emanuele 41	Biblioteca	NaN	NaN	9000	t	1	69	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E6100000E60297C79AC927403E59315C1D224540
877	58	Palazzo di Valentino della Pagnotta	42.4168441	12.1051148	Piazza S. Lorenzo, 2	Villa o Palazzo di interesse storico o artistico	NaN	NaN	5400	t	1	18	\N	'pagnott':5 'palazz':1 'valentin':3	'pagnott':5B 'palazz':1B 'valentin':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
896	58	Museo della Casa di Santa Rosa	42.4168441	12.1051148	Via Casa di Santa Rosa - Viterbo	Museo, Galleria e/o raccolta	NaN	NaN	7200	t	1	71	\N	'cas':3 'muse':1 'ros':6 'sant':5	'cas':3B 'muse':1B 'ros':6B 'sant':5B	0101000020E6100000B3A6689BD1352840E983C0255B354540
897	58	Palazzo dei Priori	42.4168441	12.1051148	Piazza del Plebiscito, 14	Villa o Palazzo di interesse storico o artistico	NaN	NaN	9000	t	1	21	\N	'palazz':1 'prior':3	'palazz':1B 'prior':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
918	58	Biblioteca della Facoltà di Scienze Politiche dell'Università degli studi della Tuscia	42.4130769	12.1024294	Via San Carlo, 32	Biblioteca	NaN	bibliosp@unitus.it	9000	t	1	74	\N	'bibliotec':1 'facolt':3 'polit':6 'scienz':5 'stud':10 'tusc':12 'univers':8	'bibliotec':1B 'facolt':3B 'polit':6B 'scienz':5B 'stud':10B 'tusc':12B 'univers':8B	0101000020E61000003D4C56A071342840D51D30B4DF344540
919	58	BIBLIOTECA S. GIUSEPPE	42.4110788	12.1090121	VIALE A. DIAZ; 25	Museo, galleria e/o raccolta	761343134	biblioteca.sangiuseppe@teologicoviterbese.it	10800	t	1	63	\N	'bibliotec':1 'giusepp':3 's':2	'bibliotec':1B 'giusepp':3B 's':2B	0101000020E61000008FBC186FD03728401A0AE93A9E344540
884	58	Anfiteatro di Ferento	42.4693425	12.1065484	strada per Ferento-8km ca. da Viterbo	Monumento	NaN	NaN	9000	t	1	18	\N	'anfiteatr':1 'ferent':3	'anfiteatr':1B 'ferent':3B	0101000020E6100000DBE10A838D362840BB0F406A133C4540
61	2	Teatro Comunale	42.3708512	12.2634142	Piazza della Repubblica	Architettura civile	NaN	NaN	10800	t	1	27	\N	'comunal':2 'teatr':1	'comunal':2B 'teatr':1B	0101000020E6100000A09ADC39DE86284057D7570D782F4540
73	3	MUSEO NATURALISTICO DEL PARCO MARTURANUM FRANCESCO SPALLONE	42.2498341	12.0673735	VIALE QUATTRO NOVEMBRE, 46	Museo, galleria e/o raccolta	NaN	NaN	7200	t	1	14	Il Museo presenta animali, piante e ambienti naturali caratteristici della Tuscia Viterbese in cui è immerso, senza tralasciare accenni agli aspetti geologici e storico-archeologici. Ricostruzioni ambientali, modelli a grandezza naturale e animali preparati, pannelli informativi e materiale divulgativo arricchiscono la vetrina del Parco Marturanum. Il centro visita, associato al museo, mette a disposizione pubblicazioni e depliant sulla fauna e la flora del Parco, su Barbarano Romano e le sue Necropoli etrusche, le cartine dei sentieri turistici ed escursionistici.\nÈ il luogo giusto da visitare per preparare l'escursione al Parco Regionale Marturanum o in attesa che smetta una pioggia improvvisa!	'accenn':25 'ambient':13 'ambiental':34 'animal':10,40 'archeolog':32 'arricc':47 'aspett':27 'assoc':56 'attes':103 'barbar':73 'caratterist':15 'cartin':81 'centr':54 'depliant':64 'disposizion':61 'divulg':46 'escursion':96 'escursionist':86 'etrusc':79 'faun':66 'flor':69 'francesc':6 'geolog':28 'giust':90 'grandezz':37 'immers':22 'improvvis':108 'inform':43 'luog':89 'marturanum':5,52,100 'material':45 'mett':59 'modell':35 'muse':1,8,58 'natural':14,38 'naturalist':2 'necropol':78 'pannell':42 'parc':4,51,71,98 'piant':11 'piogg':107 'prepar':41,94 'present':9 'pubblic':62 'regional':99 'ricostru':33 'rom':74 'sentier':83 'senz':23 'smett':105 'spalloneil':7 'storic':31 'storico-archeolog':30 'tralasc':24 'turist':84 'tusc':17 'vetrin':49 'vis':55 'visit':92 'viterbes':18	'accenn':26A 'ambient':14A 'ambiental':35A 'animal':11A,41A 'archeolog':33A 'arricc':48A 'aspett':28A 'assoc':57A 'attes':104A 'barbar':74A 'caratterist':16A 'cartin':82A 'centr':55A 'depliant':65A 'disposizion':62A 'divulg':47A 'escursion':97A 'escursionist':87A 'etrusc':80A 'faun':67A 'flor':70A 'francesc':6B 'geolog':29A 'giust':91A 'grandezz':38A 'immers':23A 'improvvis':109A 'inform':44A 'luog':90A 'marturanum':5B,53A,101A 'material':46A 'mett':60A 'modell':36A 'muse':1B,9A,59A 'natural':15A,39A 'naturalist':2B 'necropol':79A 'pannell':43A 'parc':4B,52A,72A,99A 'piant':12A 'piogg':108A 'prepar':42A,95A 'present':10A 'pubblic':63A 'regional':100A 'ricostru':34A 'rom':75A 'sentier':84A 'senz':24A 'smett':106A 'spallon':7B 'storic':32A 'storico-archeolog':31A 'tralasc':25A 'turist':85A 'tusc':18A 'vetrin':50A 'vis':56A 'visit':93A 'viterbes':19A	0101000020E6100000EF3B86C77E2228407A765490FA1F4540
256	18	Mura Medievali	42.5597682	12.1257580	NaN	Architettura fortificata	NaN	NaN	10800	t	1	22	\N	'medieval':2 'mur':1	'medieval':2B 'mur':1B	0101000020E6100000B56B425A634028409F2B007CA6474540
143	8	Riserva Naturale Monte Casoli di Bomarzo	42.4954480	12.2318550	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	10800	t	1	97	\N	'bomarz':6 'casol':4 'mont':3 'natural':2 'riserv':1	'bomarz':6B 'casol':4B 'mont':3B 'natural':2B 'riserv':1B	0101000020E610000002D4D4B2B57628402F6F0ED76A3F4540
144	8	Chiesa di S. Maria del Piano	42.4819280	12.2487640	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	3	\N	'chies':1 'mar':4 'pian':6 's':3	'chies':1B 'mar':4B 'pian':6B 's':3B	0101000020E610000023D8B8FE5D7F28406B8313D1AF3D4540
582	42	Orte Sotterranea	42.4603608	12.3860395	Via G. Matteotti, 45	Architettura fortificata	NaN	NaN	5400	t	1	38	\N	'orte':1 'sotterrane':2	'orte':1B 'sotterrane':2B	0101000020E6100000ABED26F8A6C52840212E4A1AED3A4540
885	58	Biblioteca privata Carosi	42.4070193	12.1169792	Strada Roncone 1/A	Biblioteca	+39 0761307945	NaN	10800	t	1	37	\N	'bibliotec':1 'caros':3 'priv':2	'bibliotec':1B 'caros':3B 'priv':2B	0101000020E6100000DE9F9CB2E43B2840A02B5B3519344540
145	8	Cattedrale S. Maria Assunta	42.4819280	12.2487640	Piazza Duomo	Chiesa o edificio di culto	NaN	NaN	7200	t	1	21	\N	'assunt':4 'cattedral':1 'mar':3 's':2	'assunt':4B 'cattedral':1B 'mar':3B 's':2B	0101000020E610000023D8B8FE5D7F28406B8313D1AF3D4540
146	8	Piramide Etrusca Bomarzo o Sasso del Predicatore	42.4813920	12.2641870	NaN	Parco o Giardino di interesse storico o artistico	NaN	NaN	3600	t	1	8	\N	'bomarz':3 'etrusc':2 'piramid':1 'predic':7 'sass':5	'bomarz':3B 'etrusc':2B 'piramid':1B 'predic':7B 'sass':5B	0101000020E6100000840EBA84438728402C47C8409E3D4540
148	8	Chiesa Madonna della Valle	42.4819280	12.2487640	NaN	Chiesa o edificio di culto	NaN	NaN	10800	t	1	9	\N	'chies':1 'madonn':2 'vall':4	'chies':1B 'madonn':2B 'vall':4B	0101000020E610000023D8B8FE5D7F28406B8313D1AF3D4540
149	8	Chiesa di S. Anselmo	42.4819280	12.2487640	NaN	Chiesa o edificio di culto	NaN	NaN	7200	t	1	91	\N	'anselm':4 'chies':1 's':3	'anselm':4B 'chies':1B 's':3B	0101000020E610000023D8B8FE5D7F28406B8313D1AF3D4540
891	58	Chiesa di S. Giovanni Battista del Gonfalone	42.4168441	12.1051148	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	85	\N	'battist':5 'chies':1 'giovann':4 'gonfalon':7 's':3	'battist':5B 'chies':1B 'giovann':4B 'gonfalon':7B 's':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
894	58	Archivio di Stato di Viterbo	42.4168441	12.1051148	Via Vincenzo Cardarelli - Viterbo	Archivio di Stato	NaN	NaN	7200	t	1	20	\N	'archiv':1 'stat':3 'viterb':5	'archiv':1B 'stat':3B 'viterb':5B	0101000020E6100000B3A6689BD1352840E983C0255B354540
58	2	Chiesa del S. Sepolcro	42.6269800	12.0908718	Castel Cellesi	Chiesa o edificio di culto	NaN	NaN	9000	t	1	51	\N	'chies':1 's':3 'sepolcr':4	'chies':1B 's':3B 'sepolcr':4B	0101000020E6100000DF41A2BF862E2840809F71E140504540
92	5	Torre dell'Orologio	42.4660738	12.3130342	Via delle Fonti, 2	Architettura fortificata	NaN	NaN	5400	t	1	46	La torre dell'Orologio di Bassano in Teverina è una costruzione rinascimentale realizzata con l'intento di fortificare l'antico campanile dell'adiacente chiesa di Santa Maria dei Lumi, inglobandolo nella torre stessa.	'adiacent':25 'antic':22 'bass':8 'campanil':23 'chies':26 'costruzion':13 'fortific':20 'inglob':32 'intent':18 'lum':31 'mar':29 'orolog':6 'orologiol':3 'realizz':15 'rinascimental':14 'sant':28 'stess':35 'teverin':10 'torr':1,4,34	'adiacent':26A 'antic':23A 'bass':9A 'campanil':24A 'chies':27A 'costruzion':14A 'fortific':21A 'inglob':33A 'intent':19A 'lum':32A 'mar':30A 'orolog':3B,7A 'realizz':16A 'rinascimental':15A 'sant':29A 'stess':36A 'teverin':11A 'torr':1B,5A,35A	0101000020E61000001E0FC70446A02840DF42684EA83B4540
156	9	Biblioteca Paolo Portoghesi	42.2173359	12.4214867	Via Cadorna 59	Biblioteca	+39 0761596059	paoporto@tin.it	10800	t	1	44	\N	'bibliotec':1 'paol':2 'portoghes':3	'bibliotec':1B 'paol':2B 'portoghes':3B	0101000020E6100000DF65D01ACDD72840955FABA9D11B4540
105	6	Necropoli rupestri di San Giovenale e Terrone	42.2725220	12.0316620	S.S. Cassia, bivio Cura di Vetralla, o lungo la S.S. Braccianense Claudia - Blera	Area o parco archeologico	NaN	NaN	5400	t	1	81	\N	'giovenal':5 'necropol':1 'rupestr':2 'san':4 'terron':7	'giovenal':5B 'necropol':1B 'rupestr':2B 'san':4B 'terron':7B	0101000020E61000004A0D6D003610284063B83A00E2224540
106	6	Chiesa di Santa Maria Assunta in Cielo e San Vivenzio	42.2725220	12.0316620	NaN	Chiesa o edificio di culto	NaN	NaN	3600	t	1	16	\N	'assunt':5 'chies':1 'ciel':7 'mar':4 'san':9 'sant':3 'vivenz':10	'assunt':5B 'chies':1B 'ciel':7B 'mar':4B 'san':9B 'sant':3B 'vivenz':10B	0101000020E61000004A0D6D003610284063B83A00E2224540
107	6	Palazzo Anguillara - Monaci	42.2725220	12.0316620	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	7200	t	1	93	\N	'anguillar':2 'monac':3 'palazz':1	'anguillar':2B 'monac':3B 'palazz':1B	0101000020E61000004A0D6D003610284063B83A00E2224540
108	6	Palazzo Pretoriale	42.2725220	12.0316620	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	10800	t	1	88	\N	'palazz':1 'pretorial':2	'palazz':1B 'pretorial':2B	0101000020E61000004A0D6D003610284063B83A00E2224540
109	7	MUSEO TERRITORIALE DEL LAGO DI BOLSENA	42.6463309	11.9858125	piazza Monaldeschi	Museo, galleria e/o raccolta	761798630	museo@comunebolsena.it	9000	t	1	28	\N	'bolsen':6 'lag':4 'muse':1 'territorial':2	'bolsen':6B 'lag':4B 'muse':1B 'territorial':2B	0101000020E6100000DBF97E6ABCF8274077F28EF8BA524540
110	7	Chiesa di San Francesco	42.6441069	11.9849554	Via S. Giovanni, 21	Chiesa o edificio di culto	NaN	NaN	7200	t	1	83	\N	'chies':1 'francesc':4 'san':3	'chies':1B 'francesc':4B 'san':3B	0101000020E61000008609FE124CF8274060504B1872524540
111	7	Chiesa di S. Salvatore	42.6441069	11.9849554	NaN	Chiesa o edificio di culto	NaN	NaN	5400	t	1	99	\N	'chies':1 's':3 'salvator':4	'chies':1B 's':3B 'salvator':4B	0101000020E61000008609FE124CF8274060504B1872524540
319	22	Palazzo Mozzini	42.3449260	12.3556680	NaN	Villa o Palazzo di interesse storico o artistico	NaN	NaN	3600	t	1	78	\N	'mozzin':2 'palazz':1	'mozzin':2B 'palazz':1B	0101000020E6100000AB77B81D1AB6284022C50089262C4540
537	39	Porta Romana	42.2428240	12.3455700	NaN	Architettura fortificata	NaN	NaN	7200	t	1	95	\N	'port':1 'roman':2	'port':1B 'roman':2B	0101000020E61000001BF5108DEEB028408A5759DB141F4540
661	49	Fontana dei Delfini	41.9133459	12.4782735	NaN	Monumento	NaN	NaN	5400	t	1	36	\N	'delfin':3 'fontan':1	'delfin':3B 'fontan':1B	0101000020E61000004016A243E0F42840C537B984E8F44440
640	48	Fonte Papacqua	42.4187606	12.2343075	NaN	Monumento	NaN	NaN	3600	t	1	48	\N	'font':1 'papacqu':2	'font':1B 'papacqu':2B	0101000020E6100000406A1327F77728403AED84F299354540
744	51	Mura Castellane	42.4202141	11.8702611	NaN	Architettura fortificata	NaN	NaN	10800	t	1	26	\N	'castellan':2 'mur':1	'castellan':2B 'mur':1B	0101000020E610000044F6E6DC92BD2740B7685C93C9354540
785	54	Diga Poligonale	42.0392830	12.7979650	NaN	Area o parco archeologico	NaN	NaN	7200	t	1	5	\N	'dig':1 'poligonal':2	'dig':1B 'poligonal':2B	0101000020E61000008DB454DE8E982940F624B03907054540
634	48	Castello Orsini	42.4197145	12.2352051	Via della Rocca, 461	Architettura fortificata	NaN	NaN	5400	t	1	84	\N	'castell':1 'orsin':2	'castell':1B 'orsin':2B	0101000020E61000006FB488CD6C78284018946934B9354540
963	58	Quartiere San Pellegrino	42.4168441	12.1051148	NaN	Architettura fortificata	NaN	NaN	9000	t	1	42	\N	'pellegrin':3 'quart':1 'san':2	'pellegrin':3B 'quart':1B 'san':2B	0101000020E6100000B3A6689BD1352840E983C0255B354540
966	58	BASILICA DI S. FRANCESCO	42.4168441	12.1051148	PIAZZA SAN FRANCESCO, 4	Chiesa o edificio di culto	NaN	NaN	10800	t	1	4	\N	'basil':1 'francesc':4 's':3	'basil':1B 'francesc':4B 's':3B	0101000020E6100000B3A6689BD1352840E983C0255B354540
967	59	Biblioteca comunale	42.4654270	12.1724620	Piazza S. Agnese 16	Biblioteca	NaN	NaN	7200	t	1	26	\N	'bibliotec':1 'comunal':2	'bibliotec':1B 'comunal':2B	0101000020E6100000029B73F04C58284073D6A71C933B4540
886	58	Torre dell'Orologio	42.4168441	12.1051148	NaN	Architettura fortificata	NaN	NaN	9000	t	1	38	\N	'orolog':3 'torr':1	'orolog':3B 'torr':1B	0101000020E6100000B3A6689BD1352840E983C0255B354540
887	58	Chiesa della Madonna del Rosario	42.4168441	12.1051148	Piazza Castello	Chiesa o edificio di culto	NaN	NaN	9000	t	1	50	\N	'chies':1 'madonn':3 'rosar':5	'chies':1B 'madonn':3B 'rosar':5B	0101000020E6100000B3A6689BD1352840E983C0255B354540
889	58	Teatro Archimimus	42.4427167	12.1279641	Via S.Pietro, 26	Architettura civile	NaN	NaN	10800	t	1	85	\N	'archimimus':2 'teatr':1	'archimimus':2B 'teatr':1B	0101000020E6100000C81FB182844128404FF2D9F0AA384540
895	58	Biblioteca dell'ISIS Tarquinia	42.2333766	11.7269238	Via Porto Clementino	Biblioteca	NaN	NaN	10800	t	1	56	\N	'bibliotec':1 'isis':3 'tarquin':4	'bibliotec':1B 'isis':3B 'tarquin':4B	0101000020E61000003B5E375B2F7427406A53D048DF1D4540
975	59	Centro Botanico Moutan	42.4654270	12.1724620	S.S, Str. Ortana, 46	Museo, Galleria e/o raccolta	NaN	NaN	5400	t	1	4	\N	'botan':2 'centr':1 'moutan':3	'botan':2B 'centr':1B 'moutan':3B	0101000020E6100000029B73F04C58284073D6A71C933B4540
452	34	Grotta delle Apparizioni	42.5354236	11.9235040	Via Verentana, 48	Parco o Giardino di interesse storico o artistico	NaN	NaN	5400	t	1	90	La grotta delle apparizioni è uno dei luoghi più particolari e suggestivi che si trovano a Marta. Questa grotta è passata alla storia per essere stato il luogo in cui sarebbe apparsa a più persone la Santa Vergine Maria, la prima apparizione risale al 19 maggio 1948 e da allora sono tantissime le persone che ogni anno vengono in pellegrinaggio in questo posto. Secondo i racconti locali le prime ad aver visto la Madonna in questo luogo furono tre bambine di nome Maria Antonietta, Ivana e Brunilde; ma l’epiteto più famoso legato a questo mistero della fede è quello inerente alla storia di Mario Prugnoli anche noto con il soprannome di “zio Mario” e riportato sul libro “Apparizioni di Marta”. Dopo la prima apparizione iniziarono numerose indagini per stabilire o meno l’autenticità dell’apparizione finché poco dopo non avvenne il miracolo ed una bambina con il braccio affetto da un male incurabile, dopo la visita alla grotta guarì inspiegabilmente. Ma il frate cappuccino che era stato messo a capo della commissione di controllo, che fino a quel momento non aveva creduto a nessuna delle varie apparizioni, mentre era su un balcone a smentire alla folla il miracolo assistette a una scena che cambiò totalmente la sua visione. Secondo i racconti il frate vide il sole roteare e il cielo divenne di mille colori e così l’uomo grido “Viva Maria”. Secondo i giornali dell’epoca erano circa 40.000 le persone ad aver assistito al miracolo e da lì in poi la Vergine non finì di elargire grazie di ogni specie. Per quanto sia complessa e misteriosa la storia legata a questa grotta dell’apparizione, questo resta uno dei luoghi più curiosi e interessanti da visitare per chi si reca in questo bellissimo paese	'19':47 '1948':49 '40.000':242 'affett':152 'allor':52 'anno':59 'antoniett':86 'apparizion':6,44,121,127,138,190,278 'apparizionil':3 'appars':34 'assist':247 'assistett':202 'autent':136 'aver':73,246 'avvenn':143 'balcon':195 'bambin':82,148 'bellissim':296 'bracc':151 'brunild':89 'camb':207 'cap':173 'cappuccin':167 'ciel':223 'circ':241 'color':227 'commission':175 'compless':268 'controll':177 'cos':229 'cred':185 'curios':285 'divenn':224 'dop':124,141,157 'elarg':260 'epitet':92 'epoc':239 'esser':27 'famos':94 'fed':100 'fin':179,258 'finc':139 'foll':199 'frat':166,216 'giornal':237 'graz':261 'grid':232 'grott':1,4,21,161,276 'guar':162 'incur':156 'indagin':130 'inerent':103 'iniz':128 'inspiegabil':163 'interess':287 'ivan':87 'leg':95,273 'libr':120 'local':69 'luog':10,30,79,283 'lì':252 'madonn':76 'magg':48 'mal':155 'mar':41,85,107,116,234 'mart':19,123 'men':134 'mentr':191 'mess':171 'mill':226 'miracol':145,201,249 'mister':98,270 'moment':182 'nessun':187 'nom':84 'not':110 'numer':129 'ogni':58,263 'paes':297 'particolar':12 'pass':23 'pellegrinagg':62 'person':37,56,244 'poc':140 'poi':254 'post':65 'prim':43,71,126 'prugnol':108 'quel':181 'raccont':68,214 'rec':293 'rest':280 'riport':118 'risal':45 'rot':220 'sant':39 'scen':205 'second':66,212,235 'sment':197 'sol':219 'soprannom':113 'spec':264 'stabil':132 'stat':28,170 'stor':25,105,272 'suggest':14 'tantissim':54 'total':208 'tre':81 'trov':17 'uom':231 'var':189 'veng':60 'vergin':40,256 'vid':217 'vis':159 'vision':211 'visit':289 'vist':74 'viv':233 'zio':115	'19':48A '1948':50A '40.000':243A 'affett':153A 'allor':53A 'anno':60A 'antoniett':87A 'apparizion':3B,7A,45A,122A,128A,139A,191A,279A 'appars':35A 'assist':248A 'assistett':203A 'autent':137A 'aver':74A,247A 'avvenn':144A 'balcon':196A 'bambin':83A,149A 'bellissim':297A 'bracc':152A 'brunild':90A 'camb':208A 'cap':174A 'cappuccin':168A 'ciel':224A 'circ':242A 'color':228A 'commission':176A 'compless':269A 'controll':178A 'cos':230A 'cred':186A 'curios':286A 'divenn':225A 'dop':125A,142A,158A 'elarg':261A 'epitet':93A 'epoc':240A 'esser':28A 'famos':95A 'fed':101A 'fin':180A,259A 'finc':140A 'foll':200A 'frat':167A,217A 'giornal':238A 'graz':262A 'grid':233A 'grott':1B,5A,22A,162A,277A 'guar':163A 'incur':157A 'indagin':131A 'inerent':104A 'iniz':129A 'inspiegabil':164A 'interess':288A 'ivan':88A 'leg':96A,274A 'libr':121A 'local':70A 'luog':11A,31A,80A,284A 'lì':253A 'madonn':77A 'magg':49A 'mal':156A 'mar':42A,86A,108A,117A,235A 'mart':20A,124A 'men':135A 'mentr':192A 'mess':172A 'mill':227A 'miracol':146A,202A,250A 'mister':99A,271A 'moment':183A 'nessun':188A 'nom':85A 'not':111A 'numer':130A 'ogni':59A,264A 'paes':298A 'particolar':13A 'pass':24A 'pellegrinagg':63A 'person':38A,57A,245A 'poc':141A 'poi':255A 'post':66A 'prim':44A,72A,127A 'prugnol':109A 'quel':182A 'raccont':69A,215A 'rec':294A 'rest':281A 'riport':119A 'risal':46A 'rot':221A 'sant':40A 'scen':206A 'second':67A,213A,236A 'sment':198A 'sol':220A 'soprannom':114A 'spec':265A 'stabil':133A 'stat':29A,171A 'stor':26A,106A,273A 'suggest':15A 'tantissim':55A 'total':209A 'tre':82A 'trov':18A 'uom':232A 'var':190A 'veng':61A 'vergin':41A,257A 'vid':218A 'vis':160A 'vision':212A 'visit':290A 'vist':75A 'viv':234A 'zio':116A	0101000020E61000004B732B84D5D82740D8C0B1C288444540
977	1	Ferento	42.4887019	12.1313950	Strada Ferento	Area o parco archeologico	\N	\N	7200	t	1	54	\N	\N	'ferent':1B	0101000020E61000001DFFAAC88D3E454041B7973446432840
978	58	Sito archeologico Acquarossa	42.4833330	12.1333330	NaN	Area o parco archeologico	\N	\N	5400	t	1	41	\N	\N	'acquaross':3B 'archeolog':2B 'sit':1B	0101000020E6100000EE0912DBDD3D454084F4143944442840
997	18	Celleno	42.5597682	12.1257580	\N	Comune	\N	\N	\N	t	\N	81	\N	\N	'cellen':1B	0101000020E61000009F2B007CA6474540B56B425A63402840
1036	57	Vignanello	42.3838260	12.2767660	\N	Comune	\N	\N	\N	t	\N	32	\N	\N	'vignanell':1B	0101000020E610000060ADDA35213145401B4AED45B48D2840
989	10	Canepina	42.3809608	12.2336522	\N	Comune	\N	\N	\N	t	\N	81	\N	\N	'canepin':1B	0101000020E61000006C87D052C3304540E346DB42A1772840
1029	50	Tarquinia	42.2532394	11.7591747	\N	Comune	\N	\N	\N	t	\N	96	\N	\N	'tarquin':1B	0101000020E610000082870E266A204540B7E6D88BB2842740
1037	58	Viterbo	42.4168441	12.1051148	\N	Comune	\N	\N	\N	t	\N	70	\N	\N	'viterb':1B	0101000020E6100000E983C0255B354540B3A6689BD1352840
1035	56	Vetralla	42.3205336	12.0575000	\N	Comune	\N	\N	\N	t	\N	64	\N	\N	'vetrall':1B	0101000020E610000073A2B83E072945403D0AD7A3701D2840
998	19	Cellere	42.5104250	11.7716530	\N	Comune	\N	\N	\N	t	\N	47	\N	\N	'cell':1B	0101000020E6100000C8073D9B5541454078B81D1A168B2740
1022	43	Piansano	42.5179320	11.8282734	\N	Comune	\N	\N	\N	t	\N	16	\N	\N	'pians':1B	0101000020E6100000A4C684984B424540204B7A7313A82740
1023	44	Proceno	42.7571602	11.8302614	\N	Comune	\N	\N	\N	t	\N	62	\N	\N	'procen':1B	0101000020E61000009A6A1CA0EA6045402943B00518A92740
1004	25	Faleria	42.2261788	12.4431811	\N	Comune	\N	\N	\N	t	\N	98	\N	\N	'faler':1B	0101000020E610000036864A6DF31C45401E6915A2E8E22840
982	3	Barbarano Romano	42.2498341	12.0673735	\N	Comune	\N	\N	\N	t	\N	22	\N	\N	'barbar':1B 'rom':2B	0101000020E61000007A765490FA1F4540EF3B86C77E222840
981	2	Bagnoregio	42.6269800	12.0908718	\N	Comune	\N	\N	\N	t	\N	71	\N	\N	'bagnoreg':1B	0101000020E6100000809F71E140504540DF41A2BF862E2840
980	1	Acquapendente	42.7439961	11.8649880	\N	Comune	\N	\N	\N	t	\N	91	\N	\N	'acquapendent':1B	0101000020E6100000FFECA2433B5F45406ADD06B5DFBA2740
996	17	Castiglione in Teverina	42.6449715	12.2038975	\N	Comune	\N	\N	\N	t	\N	72	\N	\N	'castiglion':1B 'teverin':3B	0101000020E610000010AD156D8E524540EA78CC4065682840
1005	26	Farnese	42.5494260	11.7256520	\N	Comune	\N	\N	\N	t	\N	29	\N	\N	'farnes':1B	0101000020E61000003AC9569753464540D28DB0A888732740
1010	31	Ischia di Castro	42.5446546	11.7540140	\N	Comune	\N	\N	\N	t	\N	66	\N	\N	'castr':3B 'ischi':1B	0101000020E6100000D84EEF3DB7454540C9737D1F0E822740
988	9	Calcata	42.2197263	12.4259417	\N	Comune	\N	\N	\N	t	\N	51	\N	\N	'calc':1B	0101000020E61000001949CCFD1F1C45405A01CF0715DA2840
1013	34	Marta	42.5339112	11.9249120	\N	Comune	\N	\N	\N	t	\N	69	\N	\N	'mart':1B	0101000020E6100000EB7BC333574445401D5BCF108ED92740
1011	32	Latera	42.6290280	11.8274530	\N	Comune	\N	\N	\N	t	\N	62	\N	\N	'later':1B	0101000020E6100000572250FD8350454045F46BEBA7A72740
994	15	Carbognano	42.3316250	12.2643660	\N	Comune	\N	\N	\N	t	\N	98	\N	\N	'carbogn':1B	0101000020E61000009CC420B0722A45404359F8FA5A872840
1018	39	Nepi	42.2428240	12.3455700	\N	Comune	\N	\N	\N	t	\N	2	\N	\N	'nep':1B	0101000020E61000008A5759DB141F45401BF5108DEEB02840
1019	40	Onano	42.6928561	11.8163999	\N	Comune	\N	\N	\N	t	\N	7	\N	\N	'onan':1B	0101000020E6100000C42A3982AF58454054EAED2AFFA12740
1020	41	Oriolo Romano	42.1593028	12.1383489	\N	Comune	\N	\N	\N	t	\N	96	\N	\N	'oriol':1B 'rom':2B	0101000020E6100000A314BE08641445400AE0C1AAD5462840
1021	42	Orte	42.4605984	12.3856056	\N	Comune	\N	\N	\N	t	\N	96	\N	\N	'orte':1B	0101000020E6100000834B6CE3F43A4540154FE2186EC52840
1028	49	Sutri	42.2470230	12.2150670	\N	Comune	\N	\N	\N	t	\N	51	\N	\N	'sutr':1B	0101000020E61000000E2E1D739E1F4540CDE506431D6E2840
1031	52	Valentano	42.5684597	11.8187556	\N	Comune	\N	\N	\N	t	\N	51	\N	\N	'valent':1B	0101000020E6100000074C9649C34845406ED51AEF33A32740
1038	59	Vitorchiano	42.4654270	12.1724620	\N	Comune	\N	\N	\N	t	\N	96	\N	\N	'vitorc':1B	0101000020E610000073D6A71C933B4540029B73F04C582840
1016	37	Montefiascone	42.5379248	12.0309974	\N	Comune	\N	\N	\N	t	\N	50	\N	\N	'montefiascon':1B	0101000020E61000008ADA47B8DA444540A68526E4DE0F2840
1034	55	Vejano	42.2167570	12.0952017	\N	Comune	\N	\N	\N	t	\N	90	\N	\N	'vej':1B	0101000020E6100000EC1681B1BE1B4540160CF846BE302840
1012	33	Lubriano	42.6362310	12.1087590	\N	Comune	\N	\N	\N	t	\N	89	\N	\N	'lubr':1B	0101000020E6100000C7D9740470514540944A7842AF372840
1008	29	Graffignano	42.5749030	12.2044306	\N	Comune	\N	\N	\N	t	\N	13	\N	\N	'graffign':1B	0101000020E6100000A7AFE76B96494540739AAA20AB682840
1009	30	Grotte di Castro	42.6745290	11.8722530	\N	Comune	\N	\N	\N	t	\N	74	\N	\N	'castr':3B 'grott':1B	0101000020E61000000F9A5DF75656454000ADF9F197BE2740
1014	35	Montalto di Castro	42.3534605	11.6063117	\N	Comune	\N	\N	\N	t	\N	42	\N	\N	'castr':3B 'montalt':1B	0101000020E6100000C2F693313E2D4540445DB57C6E362740
985	6	Blera	42.2725220	12.0316620	\N	Comune	\N	\N	\N	t	\N	24	\N	\N	'bler':1B	0101000020E610000063B83A00E22245404A0D6D0036102840
1024	45	Ronciglione	42.2902415	12.2138064	\N	Comune	\N	\N	\N	t	\N	50	\N	\N	'ronciglion':1B	0101000020E610000093382BA226254540DA594F08786D2840
1025	46	San Lorenzo Nuovo	42.6867300	11.9066530	\N	Comune	\N	\N	\N	t	\N	10	\N	\N	'lorenz':2B 'nuov':3B 'san':1B	0101000020E61000004E97C5C4E6574540FDA36FD234D02740
1001	22	Corchiano	42.3449260	12.3556680	\N	Comune	\N	\N	\N	t	\N	60	\N	\N	'corc':1B	0101000020E610000022C50089262C4540AB77B81D1AB62840
1017	38	Monterosi	42.1958230	12.3084690	\N	Comune	\N	\N	\N	t	\N	29	\N	\N	'monter':1B	0101000020E6100000FD6662BA10194540DFA815A6EF9D2840
1015	36	Monte Romano	42.2678823	11.8986478	\N	Comune	\N	\N	\N	t	\N	87	\N	\N	'mont':1B 'rom':2B	0101000020E6100000B0D69AF749224540A53E7F901BCC2740
1027	48	Soriano nel Cimino	42.4187606	12.2343075	\N	Comune	\N	\N	\N	t	\N	95	\N	\N	'cimin':3B 'sor':1B	0101000020E61000003AED84F299354540406A1327F7772840
1032	53	Vallerano	41.7907359	12.4696439	\N	Comune	\N	\N	\N	t	\N	53	\N	\N	'valler':1B	0101000020E6100000F6227FD536E5444023884E2A75F02840
992	13	Capranica	42.2564918	12.1776114	\N	Comune	\N	\N	\N	t	\N	62	\N	\N	'capran':1B	0101000020E610000099582AB9D420454026CBA4E1EF5A2840
1030	51	Tuscania	42.4202141	11.8702611	\N	Comune	\N	\N	\N	t	\N	19	\N	\N	'tuscan':1B	0101000020E6100000B7685C93C935454044F6E6DC92BD2740
993	14	Caprarola	42.3266250	12.2357660	\N	Comune	\N	\N	\N	t	\N	66	\N	\N	'caprarol':1B	0101000020E61000002B8716D9CE29454079043752B6782840
1033	54	Vasanello	42.4144251	12.3464168	\N	Comune	\N	\N	\N	t	\N	38	\N	\N	'vasanell':1B	0101000020E61000001E92B5E10B354540E891F58A5DB12840
1003	24	Fabrica di Roma 	42.3351260	12.2997670	\N	Comune	\N	\N	\N	t	\N	94	\N	\N	'fabric':1B 'rom':3B	0101000020E61000000805A568E52A45400ED76A0F7B992840
999	20	Civita Castellana	42.2952260	12.4091700	\N	Comune	\N	\N	\N	t	\N	33	\N	\N	'castellan':2B 'civ':1B	0101000020E6100000E6762FF7C92545403602F1BA7ED12840
995	16	Castel Sant'Elia	42.2517755	12.3717955	\N	Comune	\N	\N	\N	t	\N	73	\N	\N	'castel':1B 'eli':3B 'sant':2B	0101000020E61000008F37F92D3A2045409599D2FA5BBE2840
1026	47	San Martino al Cimino	42.3679225	12.1275715	\N	Comune	\N	\N	\N	t	\N	60	\N	\N	'cimin':4B 'martin':2B 'san':1B	0101000020E6100000357BA015182F4540A7CD380D51412840
1007	28	Gradoli	42.6436919	11.8548880	\N	Comune	\N	\N	\N	t	\N	79	\N	\N	'gradol':1B	0101000020E61000009D99057F64524540577C43E1B3B52740
987	8	Bomarzo	42.4819280	12.2487640	\N	Comune	\N	\N	\N	t	\N	65	\N	\N	'bomarz':1B	0101000020E61000006B8313D1AF3D454023D8B8FE5D7F2840
990	11	Canino	42.4639626	11.7495088	\N	Comune	\N	\N	\N	t	\N	3	\N	\N	'canin':1B	0101000020E610000098C86020633B4540DF20109EBF7F2740
986	7	Bolsena	42.6441069	11.9849554	\N	Comune	\N	\N	\N	t	\N	37	\N	\N	'bolsen':1B	0101000020E610000060504B18725245408609FE124CF82740
1000	21	Civitella d'Agliano	42.6053622	12.1876584	\N	Comune	\N	\N	\N	t	\N	57	\N	\N	'agli':3B 'civitell':1B 'd':2B	0101000020E6100000089E31827C4D4540AEA305C314602840
991	12	Capodimonte	42.5465270	11.9047550	\N	Comune	\N	\N	\N	t	\N	3	\N	\N	'capodimont':1B	0101000020E6100000C4B0C398F4454540F3C81F0C3CCF2740
1002	23	Fabrica di Roma	42.3351260	12.2997670	\N	Comune	\N	\N	\N	t	\N	49	\N	\N	'fabric':1B 'rom':3B	0101000020E61000000805A568E52A45400ED76A0F7B992840
984	5	Bassano in Teverina	42.4660738	12.3130342	\N	Comune	\N	\N	\N	t	\N	66	\N	\N	'bass':1B 'teverin':3B	0101000020E6100000DF42684EA83B45401E0FC70446A02840
1006	27	Gallese	42.3732869	12.4028042	\N	Comune	\N	\N	\N	t	\N	68	\N	\N	'galles':1B	0101000020E61000003AC379DDC72F45400562235A3CCE2840
983	4	Bassano Romano	42.2183916	12.1930062	\N	Comune	\N	\N	\N	t	\N	14	\N	\N	'bass':1B 'rom':2B	0101000020E61000004DDC8541F41B4540B8D969B5D1622840
1039	1	Ferento Teatro	42.4887019	12.1313950	Strada Ferento	Area o parco archeologico	\N	\N	7200	t	1	54	\N	\N	'ferent':1B 'teatr':2B	0101000020E61000001DFFAAC88D3E454041B7973446432840
1040	1	Ferento Terme	42.4887019	12.1313950	Strada Ferento	Area o parco archeologico	\N	\N	7200	t	1	54	\N	\N	'ferent':1B 'term':2B	0101000020E61000001DFFAAC88D3E454041B7973446432840
\.


--
-- Data for Name: poi_opening_hour; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.poi_opening_hour (poh_id, is_active) FROM stdin;
1	t
\.


--
-- Data for Name: province; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.province (province_id, region_id, name, lat, lon, is_active) FROM stdin;
1	1	Viterbo	42.4168441	12.1051148	t
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region (region_id, name, min_lat, min_lon, max_lat, max_lon, is_active) FROM stdin;
1	Lazio	40.7849283	11.4491695	42.8402690	14.0276445	t
\.


--
-- Data for Name: social_interaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.social_interaction (si_id, url, source_type, wos_id, poi_id, is_active) FROM stdin;
\.


--
-- Data for Name: social_media; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.social_media (sm_id, url, source_type, city_id, poi_id, is_active) FROM stdin;
10	https://www.tripadvisor.it/Attraction_Review-g1077975-d3208367-Reviews-Museo_del_Fiore-Acquapendente_Province_of_Viterbo_Lazio.html	tripadvisor	1	1	t
11	Museo_del_fiore	wikipedia	1	1	t
12	Museo del fiore\n@museodelfiore	facebook	1	1	t
13	www.museodelfiore.it	website	1	1	t
14	https://www.tripadvisor.it/Attraction_Review-g2624077-d19565008-Reviews-Chiesa_di_Nativita_di_Maria_Santissima-Trevinano_Acquapendente_Province_of_Vite.html	tripadvisor	1	2	t
15	https://www.tripadvisor.it/Attraction_Review-g2624077-d19565006-Reviews-Chiesa_della_Madonna_della_Quercia-Trevinano_Acquapendente_Province_of_Viterbo_.html	tripadvisor	1	3	t
16	https://www.tripadvisor.it/Attraction_Review-g1077975-d10751519-Reviews-Osservatorio_Astronomico_Nuova_Pegasus-Acquapendente_Province_of_Viterbo_Lazio.html	tripadvisor	1	15	t
17	Nuova Pegasus\n@nuova.pegasus  · Organizzatore di eventi	facebook	1	15	t
18	https://www.nuovapegasus.it/	website	1	15	t
19	Castello Boncompagni Ludovisi\n@VillaFiorano	facebook	1	18	t
20	https://www.castelloboncompagniludovisi.it/	website	1	18	t
21	https://www.monasterodiacquapendente.it/	website	1	23	t
22	https://www.tripadvisor.it/Attraction_Review-g1077975-d7181299-Reviews-Museo_della_Citta-Acquapendente_Province_of_Viterbo_Lazio.html	tripadvisor	1	24	t
23	Museo_della_città_(Acquapendente)	wikipedia	1	24	t
24	Museo della Città - Civico e Diocesano di Acquapendente\n@museodellacittadiacquapedente	facebook	1	24	t
25	museoacquapendente	instagram	1	24	t
26	https://museodellacitta.eu/	website	1	24	t
27	https://www.tripadvisor.it/Attraction_Review-g1077975-d6362879-Reviews-Bosco_del_Sasseto-Acquapendente_Province_of_Viterbo_Lazio.html	tripadvisor	1	25	t
28	Bosco Del Sasseto\n@boscodelsassetoofficial	facebook	1	25	t
29	Biblioteca Comunale di Acquapendente\nBiblioteca	facebook	1	29	t
30	https://www.tripadvisor.it/Attraction_Review-g1077975-d12097021-Reviews-Teatro_Boni-Acquapendente_Province_of_Viterbo_Lazio.html	tripadvisor	1	35	t
31	Teatro Boni	facebook	1	35	t
32	https://www.teatroboni.it/	website	1	35	t
33	https://www.tripadvisor.it/Attraction_Review-g1092780-d20857741-Reviews-Chiesa_della_Madonna_del_Santo_Amore-Torre_Alfina_Acquapendente_Province_of_Vit.html	tripadvisor	1	38	t
34	https://www.tripadvisor.it/Attraction_Review-g1092780-d8442796-Reviews-Castello_di_Torre_Alfina-Torre_Alfina_Acquapendente_Province_of_Viterbo_Lazio.html	tripadvisor	1	39	t
35	Il castello di Torre Alfina\n@castellotorrealfina 	facebook	1	39	t
36	castellotorrealfina	instagram	1	39	t
37	https://www.castellotorrealfina.com/	website	1	39	t
38	https://www.tripadvisor.it/Attraction_Review-g1077975-d7298448-Reviews-Basilica_Concattedrale_del_Santo_Sepolcro-Acquapendente_Province_of_Viterbo_Lazi.html	tripadvisor	1	45	t
39	Concattedrale_di_Acquapendente	wikipedia	1	45	t
40	Castel_Cellesi	wikipedia	2	48	t
41	https://www.tripadvisor.it/Attraction_Review-g1235481-d8826159-Reviews-Porta_Albana-Bagnoregio_Province_of_Viterbo_Lazio.html	tripadvisor	2	50	t
42	https://www.tripadvisor.it/Attraction_Review-g1235481-d8826348-Reviews-Cattedrale_di_San_Nicola_e_San_Donato-Bagnoregio_Province_of_Viterbo_Lazio.html	tripadvisor	2	51	t
43	Chiesa_di_San_Donato_(Bagnoregio)	wikipedia	2	51	t
44	https://www.tripadvisor.it/Attraction_Review-g15273834-d15234694-Reviews-Chiesa_di_San_Girolamo-Castel_Cellesi_Bagnoregio_Province_of_Viterbo_Lazio.html	tripadvisor	2	55	t
45	Chiesa_di_San_Girolamo_(Castel_Cellesi)	wikipedia	2	55	t
46	https://www.tripadvisor.it/Attraction_Review-g1235481-d8826142-Reviews-Chiesa_di_San_Bonaventura-Bagnoregio_Province_of_Viterbo_Lazio.html	tripadvisor	2	56	t
47	Chiesa_di_San_Bonaventura_(Bagnoregio)	wikipedia	2	56	t
48	Porta_di_Santa_Maria	wikipedia	2	57	t
49	Chiesa_del_Santo_Sepolcro_(Castel_Cellesi)	wikipedia	2	58	t
50	https://www.tripadvisor.it/Attraction_Review-g1235481-d8826179-Reviews-Chiesa_di_Sant_Agostino-Bagnoregio_Province_of_Viterbo_Lazio.html	tripadvisor	2	59	t
51	Chiesa_dell'Annunziata_(Bagnoregio)	wikipedia	2	59	t
52	https://www.tripadvisor.it/Attraction_Review-g1931188-d15207721-Reviews-Cappella_Della_Madonna_Del_Carcere-Civita_di_Bagnoregio_Province_of_Viterbo_Laz.html	tripadvisor	2	60	t
53	IPAB Fondazione F.lli Agosti Bagnoregio\n@IpabFondazioneFlliAgostiBagnoregio  · Scuola elementare	facebook	2	64	t
54	www.museotaruffi.it	website	2	65	t
55	https://www.tripadvisor.it/Attraction_Review-g1931188-d3404827-Reviews-Museo_Geologico_e_delle_Frane-Civita_di_Bagnoregio_Province_of_Viterbo_Lazio.html	tripadvisor	2	68	t
56	Museo Geologico e delle Frane, Civita di Bagnoregio\n@MuseoGeologicoEDelleFrane  · Istruzione	facebook	2	68	t
57	https://www.tripadvisor.it/Attraction_Review-g1235481-d8826348-Reviews-Cattedrale_di_San_Nicola_e_San_Donato-Bagnoregio_Province_of_Viterbo_Lazio.html	tripadvisor	2	69	t
58	https://www.tripadvisor.it/Attraction_Review-g1235481-d15624613-Reviews-Museo_Piero_Taruffi-Bagnoregio_Province_of_Viterbo_Lazio.html	tripadvisor	2	65	t
59	www.museotaruffi.it	website	2	65	t
60	https://www.tripadvisor.it/Attraction_Review-g1984039-d11832725-Reviews-Parco_Regionale_Marturanum-Barbarano_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	3	73	t
61	https://www.tripadvisor.it/Attraction_Review-g1984039-d13004426-Reviews-Museo_Archeologico_delle_Necropoli_Rupestri-Barbarano_Romano_Province_of_Viterb.html	tripadvisor	3	74	t
62	Museo_civico_(Viterbo)	wikipedia	3	74	t
63	Museo delle Necropoli Rupestri di Barbarano-Pagina Istituzionale\n@MuseodelleNecropoliRupestri  · Museo d'arte	facebook	3	74	t
64	museodellenecropolirupestri	instagram	3	74	t
65	https://museodellenecropolirupestri.it/	website	3	74	t
341	www.simulabo.it	website	30	392	t
66	https://www.tripadvisor.it/Attraction_Review-g1984039-d12822795-Reviews-Parricchia_di_Santa_Maria_Assunta-Barbarano_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	3	75	t
67	Chiesa_di_Santa_Maria_Assunta_(Barbarano_Romano)	wikipedia	3	75	t
68	https://www.tripadvisor.it/Attraction_Review-g1984039-d12823112-Reviews-Porta_Romana-Barbarano_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	3	76	t
69	https://www.tripadvisor.it/Attraction_Review-g1984039-d5569390-Reviews-Necropoli_di_San_Giuliano-Barbarano_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	3	78	t
70	https://www.tripadvisor.it/Attraction_Review-g1984039-d3357198-Reviews-Museo_della_Tuscia_Rupestre_Francesco_Spallone-Barbarano_Romano_Province_of_Vite.html	tripadvisor	3	79	t
71	https://www.tripadvisor.it/Attraction_Review-g1984039-d21777651-Reviews-Tomba_Margareth-Barbarano_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	3	80	t
72	https://www.tripadvisor.it/Attraction_Review-g1567696-d12556733-Reviews-Monastero_San_Vincenzo_Santuario_del_Santo_Volto-Bassano_Romano_Province_of_Vit.html	tripadvisor	4	81	t
73	Monastero_di_San_Vincenzo_(Bassano_Romano)	wikipedia	4	81	t
74	Monastero San Vincenzo - Ospitalità monastica\n@ospitalitamonastica 	facebook	4	81	t
75	Ospitalita Monastica\n@monasticaINFO	twitter	4	81	t
76	https://www.monastica.info/chiesa	website	4	81	t
77	https://www.tripadvisor.it/Attraction_Review-g1567696-d12556708-Reviews-Parrocchia_Maria_S_S_Assunta_in_Cielo-Bassano_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	4	82	t
78	Chiesa_di_Santa_Maria_Assunta_(Bassano_Romano)	wikipedia	4	82	t
79	https://www.tripadvisor.it/Attraction_Review-g1567696-d12556742-Reviews-Chiesa_di_San_Gratiliano-Bassano_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	4	84	t
80	https://www.tripadvisor.it/Attraction_Review-g1567696-d12556740-Reviews-Chiesa_della_Madonna_della_Pieta-Bassano_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	4	85	t
81	https://www.tripadvisor.it/Attraction_Review-g1567696-d11837710-Reviews-Villa_Giustiniani_Odescalchi-Bassano_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	4	86	t
82	Villa_Giustiniani_Odescalchi	wikipedia	4	86	t
83	https://www.tripadvisor.it/Attraction_Review-g1567696-d12556732-Reviews-Chiesa_di_Santa_Maria_dei_Monti-Bassano_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	4	87	t
84	https://www.tripadvisor.it/Attraction_Review-g1567696-d12556709-Reviews-Biblioteca_Comunale_e_Archivio_Storico_Comunale-Bassano_Romano_Province_of_Vite.html	tripadvisor	4	88	t
85	https://www.tripadvisor.it/Attraction_Review-g2137056-d12823110-Reviews-Chiesa_dell_Immacolata_Concezione-Bassano_in_Teverina_Province_of_Viterbo_Lazio.html	tripadvisor	5	89	t
86	Chiesa_dell%27Immacolata_Concezione_(Bassano_in_Teverina)	wikipedia	5	89	t
87	https://www.tripadvisor.it/Attraction_Review-g2137056-d14088791-Reviews-Fontana_Vecchia-Bassano_in_Teverina_Province_of_Viterbo_Lazio.html	tripadvisor	5	90	t
88	https://www.tripadvisor.it/Attraction_Review-g2137056-d14088810-Reviews-Chiesa_della_Madonna_della_Quercia-Bassano_in_Teverina_Province_of_Viterbo_Lazi.html	tripadvisor	5	3	t
89	https://www.tripadvisor.it/Attraction_Review-g2137056-d7895814-Reviews-Torre_dell_Orologio-Bassano_in_Teverina_Province_of_Viterbo_Lazio.html	tripadvisor	5	92	t
90	Torre_dell'Orologio_(Bassano_in_Teverina)	wikipedia	5	92	t
91	https://www.tripadvisor.it/Attraction_Review-g2137056-d14088805-Reviews-Chiesa_dei_Santi_Fidenzio_e_Terenzio-Bassano_in_Teverina_Province_of_Viterbo_La.html	tripadvisor	5	93	t
92	Chiesa_dei_Santi_Fidenzio_e_Terenzio	wikipedia	5	93	t
93	https://www.tripadvisor.it/Attraction_Review-g2137056-d12309811-Reviews-Chiesa_di_Santa_Maria_dei_Lumi-Bassano_in_Teverina_Province_of_Viterbo_Lazio.html	tripadvisor	5	94	t
94	Chiesa_di_Santa_Maria_dei_Lumi	wikipedia	5	94	t
95	https://www.tripadvisor.it/Attraction_Review-g2140841-d3224150-Reviews-Antiquitates-Blera_Province_of_Viterbo_Lazio.html	tripadvisor	6	95	t
96	Antiquitates Centro di archeologia sperimentale Scuola Museo Turismo Natura\n@CentroAntiquitates 	facebook	6	95	t
97	https://www.antiquitates.it/	website	6	95	t
98	https://www.tripadvisor.it/Attraction_Review-g2140841-d8821429-Reviews-Necropoli_Rupestri_di_San_Giovenale_e_Terrone-Blera_Province_of_Viterbo_Lazio.html	tripadvisor	6	105	t
99	https://www.tripadvisor.it/Attraction_Review-g2140841-d15181313-Reviews-Chiesa_Santa_Maria_Assunta-Blera_Province_of_Viterbo_Lazio.html	tripadvisor	6	106	t
100	Chiesa_di_Santa_Maria_Assunta_in_cielo_e_San_Vivenzio	wikipedia	6	106	t
101	https://www.tripadvisor.it/Attraction_Review-g194693-d8453176-Reviews-Museo_Territoliale_Del_Lago_Di_Bolsena-Bolsena_Province_of_Viterbo_Lazio.html	tripadvisor	7	109	t
102	Museo Territoriale del Lago di Bolsena\n@MuseoBolsena 	facebook	7	109	t
103	www.regione.lazio.it/musei/museo_bolsena/	website	7	109	t
104	https://www.tripadvisor.it/Attraction_Review-g194693-d20360513-Reviews-Chiesa_di_San_Francesco-Bolsena_Province_of_Viterbo_Lazio.html	tripadvisor	7	110	t
105	https://www.tripadvisor.it/Attraction_Review-g194693-d8559599-Reviews-Chiesa_di_San_Salvatore-Bolsena_Province_of_Viterbo_Lazio.html	tripadvisor	7	111	t
106	https://www.tripadvisor.it/Attraction_Review-g194693-d23301387-Reviews-Palazzo_del_Drago-Bolsena_Province_of_Viterbo_Lazio.html	tripadvisor	7	113	t
107	https://www.palazzodeldrago.it/en/homepage/	website	7	113	t
108	https://www.tripadvisor.it/Attraction_Review-g194693-d12827702-Reviews-Convento_di_Santa_Maria_del_Giglio-Bolsena_Province_of_Viterbo_Lazio.html	tripadvisor	7	114	t
109	Convento_di_Santa_Maria_del_Giglio	wikipedia	7	114	t
110	Convento S.Maria del Giglio, Bolsena - ITALY\n@conventobolsena  · Conventi e monasteri	facebook	7	114	t
111	http://conventobolsena.org/	website	7	114	t
112	https://www.tripadvisor.it/Attraction_Review-g194693-d8045974-Reviews-Pietre_Lanciate-Bolsena_Province_of_Viterbo_Lazio.html	tripadvisor	7	116	t
113	Pietre_lanciate	wikipedia	7	116	t
114	https://www.tripadvisor.it/Attraction_Review-g194693-d10843072-Reviews-Fontana_di_San_Rocco-Bolsena_Province_of_Viterbo_Lazio.html	tripadvisor	7	117	t
115	https://www.tripadvisor.it/Attraction_Review-g194693-d3343163-Reviews-Lago_di_Bolsena-Bolsena_Province_of_Viterbo_Lazio.html	tripadvisor	7	118	t
116	Lago_di_Bolsena	wikipedia	7	118	t
117	Museo e Acquario di Bolsena\n@museoeacquariodibolsena	facebook	7	118	t
118	https://bolsena.it/	website	7	118	t
119	https://www.tripadvisor.it/Attraction_Review-g194693-d18940946-Reviews-Parco_di_Turona-Bolsena_Province_of_Viterbo_Lazio.html	tripadvisor	7	121	t
120	Parco_archeologico_naturalistico_di_Turona	wikipedia	7	121	t
662	Museo_archeologico_nazionale_Tuscanese	wikipedia	51	684	t
121	https://www.tripadvisor.it/Attraction_Review-g194693-d21028798-Reviews-Vesconte_Casa_Museo_Palazzo_Cozza_Caposavi-Bolsena_Province_of_Viterbo_Lazio.html	tripadvisor	7	122	t
122	Vesconte - Palazzo Cozza Caposavi\n@Vesconte 	facebook	7	122	t
123	Palazzo_Serafini	wikipedia	7	124	t
124	https://www.tripadvisor.it/Attraction_Review-g194693-d5888214-Reviews-Acquario_di_bolsena-Bolsena_Province_of_Viterbo_Lazio.html	tripadvisor	7	127	t
125	https://www.acquariobolsena.it/	website	7	127	t
126	Miracolo_eucaristico_di_Bolsena	wikipedia	7	130	t
127	https://www.tripadvisor.it/Attraction_Review-g194693-d1928037-Reviews-Castello_Rocca_Monaldeschi-Bolsena_Province_of_Viterbo_Lazio.html	tripadvisor	7	132	t
128	http://www.bibliolabo.it/comuni/bolsena/comuni/bolsena/index_html	website	7	134	t
129	https://www.tripadvisor.it/Attraction_Review-g194693-d8814564-Reviews-Area_Archeologica_di_Poggio_Moscini-Bolsena_Province_of_Viterbo_Lazio.html	tripadvisor	7	136	t
130	https://www.tripadvisor.it/Attraction_Review-g194693-d261417-Reviews-Basilica_of_Saint_Christina-Bolsena_Province_of_Viterbo_Lazio.html	tripadvisor	7	137	t
131	Basilica_di_Santa_Cristina	wikipedia	7	137	t
132	https://www.basilica-bolsena.net/index.php/it/	website	7	137	t
133	https://www.tripadvisor.it/Attraction_Review-g815535-d6592073-Reviews-Riserva_Naturale_Monte_Casoli_di_Bomarzo-Bomarzo_Province_of_Viterbo_Lazio.html	tripadvisor	8	143	t
134	https://www.tripadvisor.it/Attraction_Review-g815535-d12827667-Reviews-Chiesa_di_Santa_Maria_Assunta-Bomarzo_Province_of_Viterbo_Lazio.html	tripadvisor	8	145	t
135	Duomo_di_Bomarzo	wikipedia	8	145	t
136	https://www.tripadvisor.it/Attraction_Review-g815535-d6495583-Reviews-Piramide_Etrusca_Bomarzo_o_Sasso_del_Predicatore-Bomarzo_Province_of_Viterbo_Lazi.html	tripadvisor	8	146	t
137	https://www.piramide-etrusca.it/	website	8	146	t
138	Anselmo_di_BomarzAnselmo_di_Bomarzo	wikipedia	8	149	t
139	https://www.tripadvisor.it/Attraction_Review-g815535-d242598-Reviews-Parco_dei_Mostri-Bomarzo_Province_of_Viterbo_Lazio.html	tripadvisor	8	150	t
140	Parco_dei_Mostri	wikipedia	8	150	t
141	https://www.sacrobosco.eu/	website	8	150	t
142	https://www.tripadvisor.it/Attraction_Review-g7140185-d19635998-Reviews-Palazzo_Orsini-Mugnano_in_Teverina_Bomarzo_Province_of_Viterbo_Lazio.html	tripadvisor	8	152	t
143	Palazzo_Orsini_(Bomarzo)	wikipedia	8	152	t
144	https://www.tripadvisor.it/Attraction_Review-g815535-d4802018-Reviews-Castello_Orsini-Bomarzo_Province_of_Viterbo_Lazio.html	tripadvisor	8	153	t
145	https://www.tripadvisor.it/Attraction_Review-g1933262-d12420222-Reviews-Giardino_Portoghesi_Massobrio-Calcata_Province_of_Viterbo_Lazio.html	tripadvisor	9	155	t
146	http://giardinoportoghesimassobrio.com/	website	9	155	t
147	https://www.tripadvisor.it/Attraction_Review-g1933262-d11869428-Reviews-Chiesa_dei_Santi_Cornelio_e_Cipriano-Calcata_Province_of_Viterbo_Lazio.html	tripadvisor	9	157	t
148	https://www.tripadvisor.it/Attraction_Review-g1933262-d1930454-Reviews-Valle_del_Treja-Calcata_Province_of_Viterbo_Lazio.html	tripadvisor	9	159	t
149	Parco_regionale_Valle_del_Treja	wikipedia	9	159	t
150	http://www.parcotreja.it/	website	9	159	t
151	https://www.tripadvisor.it/Attraction_Review-g1933262-d8861468-Reviews-Chiesa_del_Santissimo_Nome_di_Gesu-Calcata_Province_of_Viterbo_Lazio.html	tripadvisor	9	161	t
152	https://www.tripadvisor.it/Attraction_Review-g1933262-d10807472-Reviews-Il_Borgo_di_Calcata-Calcata_Province_of_Viterbo_Lazio.html	tripadvisor	9	162	t
153	https://www.tripadvisor.it/Attraction_Review-g1933262-d2297213-Reviews-Opera_Bosco_Museo_di_Arte_nella_Natura-Calcata_Province_of_Viterbo_Lazio.html	tripadvisor	9	164	t
154	Opera_Bosco_Museo_di_Arte_nella_Natura	wikipedia	9	164	t
155	Opera Bosco Museo di Arte nella Natura\n@operabosco 	facebook	9	164	t
156	www.operabosco.eu	website	9	164	t
157	https://www.tripadvisor.it/Attraction_Review-g1937585-d5568032-Reviews-Museo_delle_Tradizioni_Popolari_di_Canepina-Canepina_Province_of_Viterbo_Lazio.html	tripadvisor	10	168	t
158	Museo Tradizioni Popolari Canepina	facebook	10	168	t
159	https://www.tripadvisor.it/Attraction_Review-g1937585-d19177781-Reviews-Castello_degli_Anguillara-Canepina_Province_of_Viterbo_Lazio.html	tripadvisor	10	171	t
160	Castello_Anguillara_(Canepina)	wikipedia	10	171	t
161	https://www.tripadvisor.it/Attraction_Review-g1937585-d12827698-Reviews-Chiesa_Collegiata_di_Santa_Maria_Assunta-Canepina_Province_of_Viterbo_Lazio.html	tripadvisor	10	172	t
162	https://www.tripadvisor.it/Attraction_Review-g1937585-d21500314-Reviews-Chiesa_di_San_Michele_Arcangelo-Canepina_Province_of_Viterbo_Lazio.html	tripadvisor	10	173	t
163	https://www.tripadvisor.it/Attraction_Review-g1080451-d19969893-Reviews-Museo_Archeologico_di_Vulci-Canino_Province_of_Viterbo_Lazio.html	tripadvisor	11	175	t
164	http://etruriameridionale.beniculturali.it	website	11	175	t
165	https://www.tripadvisor.it/Attraction_Review-g1080451-d12827682-Reviews-Ex_Convento_di_San_Francesco-Canino_Province_of_Viterbo_Lazio.html	tripadvisor	11	177	t
166	https://www.tripadvisor.it/Attraction_Review-g1080451-d12827660-Reviews-Castello_dell_Abbadia-Canino_Province_of_Viterbo_Lazio.html	tripadvisor	11	178	t
167	Castello_dell%27Abbadia	wikipedia	11	178	t
168	https://www.tripadvisor.it/Attraction_Review-g1080451-d21223161-Reviews-Cascata_del_Pellico-Canino_Province_of_Viterbo_Lazio.html	tripadvisor	11	179	t
169	https://www.tripadvisor.it/Attraction_Review-g1080451-d11729027-Reviews-Tomba_Francois-Canino_Province_of_Viterbo_Lazio.html	tripadvisor	11	181	t
170	Tomba_François	wikipedia	11	181	t
171	http://etruriameridionale.beniculturali.it	website	11	183	t
172	tripadvisor.it/Attraction_Review-g1080451-d11663809-Reviews-Terme_di_Vulci_Glamping_Spa-Canino_Province_of_Viterbo_Lazio.html	tripadvisor	11	184	t
173	https://termedivulci.com/	website	11	184	t
174	https://www.tripadvisor.it/Attraction_Review-g1080451-d12827697-Reviews-Chiesa_Collegiata_dei_SS_Apostoli_Giovanni_e_Andrea-Canino_Province_of_Viterbo_.html	tripadvisor	11	186	t
175	https://vulci.it/	website	11	187	t
176	Chiesa_di_Santa_Maria_del_Soccorso_(Capodimonte)	wikipedia	12	189	t
177	Parrocchia S.Maria del Soccorso - a Capodimonte\nChiesa cattolica	facebook	12	189	t
178	https://www.tripadvisor.it/Attraction_Review-g815533-d12827712-Reviews-Rocca_Farnese-Capodimonte_Province_of_Viterbo_Lazio.html	tripadvisor	12	190	t
179	Parrocchia S. Maria Assunta in Cielo - Capodimonte\n@parrocchiacapodimonte	facebook	12	191	t
180	https://www.tripadvisor.it/Attraction_Review-g815533-d12161627-Reviews-Chiesa_di_San_Rocco-Capodimonte_Province_of_Viterbo_Lazio.html	tripadvisor	12	10	t
384	http://www.madonnadelmonte.it/	website	34	456	t
181	https://www.tripadvisor.it/Attraction_Review-g815533-d12941703-Reviews-Centro_Storico_Di_Capodimonte-Capodimonte_Province_of_Viterbo_Lazio.html	tripadvisor	12	193	t
182	https://www.tripadvisor.it/Attraction_Review-g815533-d15021419-Reviews-Museo_della_Navigazione_nelle_Acque_Interne_MNAI-Capodimonte_Province_of_Viterbo.html	tripadvisor	12	195	t
183	Museo_della_navigazione_nelle_acque_interne	wikipedia	12	195	t
184	www.comune.capodimonte.vt.it	website	12	195	t
185	https://www.tripadvisor.it/Attraction_Review-g815533-d12071053-Reviews-Chiesa_di_San_Carlo-Capodimonte_Province_of_Viterbo_Lazio.html	tripadvisor	12	196	t
398	https://website--6001117807525182256183-library.business.site/	website	35	29	t
186	https://www.tripadvisor.it/Attraction_Review-g815533-d12941702-Reviews-Lungolago_di_Capodimonte-Capodimonte_Province_of_Viterbo_Lazio.html	tripadvisor	12	198	t
187	https://lungolagocapodimonte.it/	website	12	198	t
188	https://www.tripadvisor.it/Attraction_Review-g2223513-d12827700-Reviews-Santuario_della_Madonna_del_Piano-Capranica_Province_of_Viterbo_Lazio.html	tripadvisor	13	200	t
189	Museo Delle Confraternite Capranica	facebook	13	201	t
190	https://www.tripadvisor.it/Attraction_Review-g2223513-d23417275-Reviews-Area_Picnic_TRIALART-Capranica_Province_of_Viterbo_Lazio.html	tripadvisor	13	202	t
191	TRIALART\n@casatrialart 	facebook	13	202	t
192	trialart_art	instagram	13	202	t
193	https://www.trialart.it/	website	13	202	t
194	https://www.tripadvisor.it/Attraction_Review-g2223513-d21120244-Reviews-Chiesa_San_Francesco-Capranica_Province_of_Viterbo_Lazio.html	tripadvisor	13	204	t
195	Biblioteca Comunale "A.Signoretti." Capranica\n@BibliotecaCapranica.it 	facebook	13	205	t
196	biblioteca.capranica	instagram	13	205	t
197	https://www.tripadvisor.it/Attraction_Review-g2223513-d17393128-Reviews-Torri_D_Orlando-Capranica_Province_of_Viterbo_Lazio.html	tripadvisor	13	206	t
198	https://www.tripadvisor.it/Attraction_Review-g2223513-d12827706-Reviews-Castello_degli_Anguillara-Capranica_Province_of_Viterbo_Lazio.html	tripadvisor	13	207	t
199	https://www.tripadvisor.it/Attraction_Review-g1501315-d1551581-Reviews-Palazzo_Farnese-Caprarola_Province_of_Viterbo_Lazio.html	tripadvisor	14	208	t
200	Palazzo_Farnese_(Caprarola)	wikipedia	14	208	t
201	https://www.tripadvisor.it/Attraction_Review-g1501315-d11873393-Reviews-Parrocchia_S_Michele_Arcangelo-Caprarola_Province_of_Viterbo_Lazio.html	tripadvisor	14	209	t
202	https://www.parrocchiacaprarola.it/it	website	14	209	t
203	https://www.tripadvisor.it/Attraction_Review-g1501315-d1551579-Reviews-Chiesa_di_Santa_Teresa-Caprarola_Province_of_Viterbo_Lazio.html	tripadvisor	14	212	t
204	Biblioteca Comunale di Caprarola	facebook	14	29	t
205	https://www.bibliotecadicaprarola.it/	website	14	29	t
206	https://www.tripadvisor.it/Attraction_Review-g1501315-d4475389-Reviews-Museo_multimediale_di_Caprarola-Caprarola_Province_of_Viterbo_Lazio.html	tripadvisor	14	215	t
207	https://www.tripadvisor.it/Attraction_Review-g1501315-d11873433-Reviews-S_Marco_Suore_del_Divino_Amore-Caprarola_Province_of_Viterbo_Lazio.html	tripadvisor	14	217	t
208	https://www.tripadvisor.it/Attraction_Review-g1501315-d11873415-Reviews-Chiesa_della_Madonna_della_Consolazione-Caprarola_Province_of_Viterbo_Lazio.html	tripadvisor	14	218	t
209	https://www.tripadvisor.it/Attraction_Review-g1501315-d21391393-Reviews-Chiesa_Santa_Lucia-Caprarola_Province_of_Viterbo_Lazio.html	tripadvisor	14	219	t
210	https://www.tripadvisor.it/Attraction_Review-g1501315-d12692379-Reviews-Pozzo_del_Diavolo-Caprarola_Province_of_Viterbo_Lazio.html	tripadvisor	14	220	t
211	https://www.tripadvisor.it/Attraction_Review-g1501315-d23384106-Reviews-Borgo_Di_Caprarola-Caprarola_Province_of_Viterbo_Lazio.html	tripadvisor	14	222	t
212	https://www.tripadvisor.it/Attraction_Review-g4859730-d19720135-Reviews-Chiesa_della_Madonna_della_Valle-Carbognano_Province_of_Viterbo_Lazio.html	tripadvisor	15	224	t
213	https://www.tripadvisor.it/Attraction_Review-g4859730-d12827723-Reviews-Parrocchia_di_San_Pietro_Apostolo-Carbognano_Province_of_Viterbo_Lazio.html	tripadvisor	15	225	t
214	https://www.tripadvisor.it/Attraction_Review-g4859730-d12827731-Reviews-Castello_Farnese-Carbognano_Province_of_Viterbo_Lazio.html	tripadvisor	15	226	t
215	https://www.tripadvisor.it/Attraction_Review-g4859730-d11924331-Reviews-Chiesa_di_Santa_Maria_della_Concezione-Carbognano_Province_of_Viterbo_Lazio.html	tripadvisor	15	227	t
216	https://www.tripadvisor.it/Attraction_Review-g1772459-d12822406-Reviews-Castel_Porciano-Castel_Sant_Elia_Province_of_Viterbo_Lazio.html	tripadvisor	16	228	t
217	https://www.tripadvisor.it/Attraction_Review-g1772459-d12218385-Reviews-Ipogeo_di_San_Leonardo-Castel_Sant_Elia_Province_of_Viterbo_Lazio.html	tripadvisor	16	229	t
218	https://www.tripadvisor.it/Attraction_Review-g1772459-d5487383-Reviews-Basilica_di_Sant_Elia-Castel_Sant_Elia_Province_of_Viterbo_Lazio.html	tripadvisor	16	230	t
219	Basilica_di_Sant'Elia	wikipedia	16	230	t
220	Basilica di Sant'Elia\n@basilicasanteliacastelsantelia 	facebook	16	230	t
221	basilica_santelia	instagram	16	230	t
222	https://www.basilicasantelia.it/	website	16	230	t
223	https://www.tripadvisor.it/Attraction_Review-g1772459-d12822421-Reviews-Parrocchia_Sant_Antonio_Abate-Castel_Sant_Elia_Province_of_Viterbo_Lazio.html	tripadvisor	16	231	t
224	Parrocchia Sant'Antonio Abate - Castel Sant'Elia\nOrganizzazione religiosa	facebook	16	231	t
225	https://www.tripadvisor.it/Attraction_Review-g1772459-d12822409-Reviews-Castello_di_Filissano-Castel_Sant_Elia_Province_of_Viterbo_Lazio.html	tripadvisor	16	232	t
226	https://www.tripadvisor.it/Attraction_Review-g1772459-d12822402-Reviews-Castello_di_Ischi-Castel_Sant_Elia_Province_of_Viterbo_Lazio.html	tripadvisor	16	233	t
227	https://www.tripadvisor.it/Attraction_Review-g1772459-d13468822-Reviews-Pontificio_Santuario_Maria_SS_ad_Rupes-Castel_Sant_Elia_Province_of_Viterbo_Laz.html	tripadvisor	16	235	t
228	Santuario Maria Ad Rupes	facebook	16	235	t
229	http://www.mariaadrupes.com/index.php?lang=it	website	16	235	t
230	https://www.tripadvisor.it/Attraction_Review-g1772459-d12822403-Reviews-Castello_di_Pizzo_Jella-Castel_Sant_Elia_Province_of_Viterbo_Lazio.html	tripadvisor	16	236	t
231	Pizzo_Jella	wikipedia	16	236	t
232	https://www.tripadvisor.it/Attraction_Review-g1785342-d14200091-Reviews-Borgo_Medievale-Castiglione_in_Teverina_Province_of_Viterbo_Lazio.html	tripadvisor	17	238	t
333	https://www.tripadvisor.it/Attraction_Review-g2623939-d12827764-Reviews-Castello_Baglioni-Graffignano_Province_of_Viterbo_Lazio.html	tripadvisor	29	378	t
233	https://www.tripadvisor.it/Attraction_Review-g1785342-d18929785-Reviews-Piazza_della_Rocca-Castiglione_in_Teverina_Province_of_Viterbo_Lazio.html	tripadvisor	17	242	t
234	https://www.tripadvisor.it/Attraction_Review-g1785342-d19460273-Reviews-Chiesa_San_Filippo_E_Giacomo-Castiglione_in_Teverina_Province_of_Viterbo_Lazio.html	tripadvisor	17	243	t
235	https://www.tripadvisor.it/Attraction_Review-g1785342-d5279917-Reviews-MUVIS_Museo_del_Vino-Castiglione_in_Teverina_Province_of_Viterbo_Lazio.html	tripadvisor	17	246	t
236	MUVIS Museo del Vino e delle Scienze Agroalimentari\n@museovinocastiglione	facebook	17	246	t
237	https://muvis.it/	website	17	246	t
238	https://www.tripadvisor.it/Attraction_Review-g1785342-d18955343-Reviews-Rocca_Monaldeschi-Castiglione_in_Teverina_Province_of_Viterbo_Lazio.html	tripadvisor	17	250	t
239	https://www.conventocelleno.it/	website	18	254	t
665	Biblioteca Comunale di Tuscania	facebook	51	29	t
240	https://www.tripadvisor.it/Attraction_Review-g2370792-d14039004-Reviews-Chiesa_di_San_Rocco-Cellenohttps://www.tripadvisor.it/Attraction_Review-g2370792-d12827680-Reviews-Chiesa_di_San_Donato-Celleno_Province_of_Viterbo_Lazio.html_Province_of_Viterbo_Lazio.html	tripadvisor	18	240	t
241	https://www.tripadvisor.it/Attraction_Review-g2370792-d10125925-Reviews-Centro_Storico_di_Celleno_Vecchia-Celleno_Province_of_Viterbo_Lazio.html	tripadvisor	18	261	t
242	https://www.tripadvisor.it/Attraction_Review-g2370792-d10715221-Reviews-Castello_Orsini-Celleno_Province_of_Viterbo_Lazio.html	tripadvisor	18	262	t
243	https://www.tripadvisor.it/Attraction_Review-g2370792-d12827680-Reviews-Chiesa_di_San_Donato-Celleno_Province_of_Viterbo_Lazio.html	tripadvisor	18	51	t
244	https://www.tripadvisor.it/Attraction_Review-g2026763-d20305999-Reviews-Torre_dell_Orologio-Cellere_Province_of_Viterbo_Lazio.html	tripadvisor	19	92	t
245	https://www.tripadvisor.it/Attraction_Review-g2026763-d10635421-Reviews-Chiesa_di_Sant_Egidio-Cellere_Province_of_Viterbo_Lazio.html	tripadvisor	19	266	t
246	https://www.tripadvisor.it/Attraction_Review-g2026763-d20306001-Reviews-Fontana_dei_Delfini-Cellere_Province_of_Viterbo_Lazio.html	tripadvisor	19	268	t
247	https://www.tripadvisor.it/Attraction_Review-g2026763-d17767646-Reviews-Museo_del_Brigantaggio-Cellere_Province_of_Viterbo_Lazio.html	tripadvisor	19	269	t
248	Museo del brigantaggio di Cellere	facebook	19	269	t
249	www.museobrigantaggiocellere.it	website	19	269	t
250	https://www.tripadvisor.it/Attraction_Review-g2026763-d20304019-Reviews-Parrocchia_Santa_Maria_Assunta-Cellere_Province_of_Viterbo_Lazio.html	tripadvisor	19	270	t
251	https://www.tripadvisor.it/Attraction_Review-g2026763-d4354377-Reviews-Borgo_di_Pianiano_a_Cellere-Cellere_Province_of_Viterbo_Lazio.html	tripadvisor	19	271	t
252	Pianiano	wikipedia	19	271	t
253	AMICI DI MUSA\n@amicidimusa	facebook	19	271	t
254	amicidimusa	instagram	19	271	t
255	https://www.borgodipianiano.com/	website	19	271	t
256	www.museobrigantaggiocellere.it	website	19	272	t
257	https://www.tripadvisor.it/Attraction_Review-g735237-d8653655-Reviews-Via_Amerina-Civita_Castellana_Province_of_Viterbo_Lazio.html	tripadvisor	20	274	t
258	https://www.tripadvisor.it/Attraction_Review-g735237-d20558548-Reviews-Tempio_di_Giunone_Curite-Civita_Castellana_Province_of_Viterbo_Lazio.html	tripadvisor	20	277	t
259	https://www.tripadvisor.it/Attraction_Review-g735237-d8532478-Reviews-Ponte_Clementino-Civita_Castellana_Province_of_Viterbo_Lazio.html	tripadvisor	20	279	t
260	Ponte_Clementino	wikipedia	20	279	t
261	https://www.tripadvisor.it/Attraction_Review-g735237-d21391381-Reviews-Chiesa_San_Lorenzo-Civita_Castellana_Province_of_Viterbo_Lazio.html	tripadvisor	20	280	t
262	https://www.chiesasanlorenzo.altervista.org/	website	20	280	t
263	https://www.tripadvisor.it/Attraction_Review-g735237-d8796863-Reviews-Museo_Archeologico_dell_Agro_Falisco-Civita_Castellana_Province_of_Viterbo_Lazio.html	tripadvisor	20	281	t
264	Museo_nazionale_dell'Agro_Falisco	wikipedia	20	281	t
265	https://www.tripadvisor.it/Attraction_Review-g735237-d8666807-Reviews-Museo_della_Ceramica_Casimiro_Marcantoni-Civita_Castellana_Province_of_Viterbo_La.html	tripadvisor	20	282	t
266	Museo della Ceramica Marcantoni\n@museomarcantoni	facebook	20	282	t
267	www.comune.civitacastellana.vt.it	website	20	282	t
268	https://www.tripadvisor.it/Attraction_Review-g735237-d6681454-Reviews-Fontana_dei_Draghi-Civita_Castellana_Province_of_Viterbo_Lazio.html	tripadvisor	20	283	t
269	http://bibliotecacivitacastellana.blogspot.com	website	20	284	t
270	https://www.tripadvisor.it/Attraction_Review-g735237-d8646637-Reviews-Chiesa_Santa_Maria_del_Carmine-Civita_Castellana_Province_of_Viterbo_Lazio.html	tripadvisor	20	286	t
271	https://www.tripadvisor.it/Attraction_Review-g735237-d7137828-Reviews-Civita_Castellana_Cathedral-Civita_Castellana_Province_of_Viterbo_Lazio.html	tripadvisor	20	288	t
272	Duomo_di_Civita_Castellana	wikipedia	20	288	t
273	Parrocchia Santa Maria Maggiore Basilica Cattedrale di Civita Castellana	facebook	20	288	t
274	http://www.diocesicivitacastellana.it/cattedrale	website	20	288	t
275	https://www.tripadvisor.it/Attraction_Review-g735237-d8821616-Reviews-Chiesa_della_Madonna_delle_Piagge-Civita_Castellana_Province_of_Viterbo_Lazio.html	tripadvisor	20	291	t
276	https://www.tripadvisor.it/Attraction_Review-g735237-d8821538-Reviews-Auditorium_Santa_Chiara-Civita_Castellana_Province_of_Viterbo_Lazio.html	tripadvisor	20	292	t
277	https://www.tripadvisor.it/Attraction_Review-g735237-d8803129-Reviews-Chiesa_di_San_Gregorio-Civita_Castellana_Province_of_Viterbo_Lazio.html	tripadvisor	20	293	t
278	https://www.tripadvisor.it/Attraction_Review-g735237-d21391382-Reviews-Chiesa_San_Pietro-Civita_Castellana_Province_of_Viterbo_Lazio.html	tripadvisor	20	294	t
279	https://www.tripadvisor.it/Attraction_Review-g735237-d2197931-Reviews-Forte_Sangallo-Civita_Castellana_Province_of_Viterbo_Lazio.html	tripadvisor	20	298	t
280	Forte_Sangallo_(Civita_Castellana)	wikipedia	20	298	t
281	Forte Sangallo e Museo Archeologico dell'Agro Falisco\n@fortesangallomuseoarcheologicoagrofalisco 	facebook	20	298	t
282	https://www.tripadvisor.it/Attraction_Review-g7743215-d23301384-Reviews-Castello_di_San_Michele_in_Teverina-San_Michele_in_Teverina_Civitella_d_Agliano.html	tripadvisor	21	300	t
283	https://www.tripadvisor.it/Attraction_Review-g7743215-d23301386-Reviews-Chiesa_di_San_Michele_Arcangelo-San_Michele_in_Teverina_Civitella_d_Agliano_Pro.html	tripadvisor	21	303	t
334	Castello_di_Sipicciano	wikipedia	29	378	t
284	https://www.tripadvisor.it/Attraction_Review-g1574671-d12361892-Reviews-Castello_e_Torre_Monaldeschi-Civitella_d_Agliano_Province_of_Viterbo_Lazio.html	tripadvisor	21	306	t
285	https://www.tripadvisor.it/Attraction_Review-g1574671-d12827724-Reviews-Parrocchia_Ss_Pietro_e_Callisto-Civitella_d_Agliano_Province_of_Viterbo_Lazio.html	tripadvisor	21	307	t
286	Parrocchia Ss. Pietro e Callisto - Civitella d'Agliano	facebook	21	307	t
287	https://www.tripadvisor.it/Attraction_Review-g3198149-d8800041-Reviews-Chiesa_di_Sant_Egidio-Corchiano_Province_of_Viterbo_Lazio.html	tripadvisor	22	257	t
288	Chiesa_della_Madonna_del_Soccorso_(Corchiano)	wikipedia	22	312	t
289	https://www.tripadvisor.it/Attraction_Review-g3198149-d13447445-Reviews-Chiesa_di_San_Biagio-Corchiano_Province_of_Viterbo_Lazio.html	tripadvisor	22	315	t
290	https://www.tripadvisor.it/Attraction_Review-g3198149-d3215125-Reviews-Forre_e_Borgo_di_Corchiano-Corchiano_Province_of_Viterbo_Lazio.html	tripadvisor	22	316	t
291	Biblioteca comunale di Fabrica di Roma\n@BibliotecaFabricadiRoma	facebook	23	320	t
292	http://www.bibliotecafabricadiroma.it	website	23	320	t
883	Orto Botanico "Angelo Rambelli" - Università degli Studi della Tuscia	facebook	58	925	t
293	https://www.tripadvisor.it/Attraction_Review-g1629255-d7234187-Reviews-Abbazia_di_Santa_Maria_in_Falleri-Fabrica_di_Roma_Province_of_Viterbo_Lazio.html	tripadvisor	24	321	t
294	Abbazia di Santa Maria in Falleri\n@abbaziadisantamariainfalleri  · Chiesa	facebook	24	321	t
295	https://www.tripadvisor.it/Attraction_Review-g1629255-d12827730-Reviews-Chiesa_Collegiata_di_San_Silvestro_Papa-Fabrica_di_Roma_Province_of_Viterbo_Laz.html	tripadvisor	24	322	t
296	Chiesa_di_San_Silvestro_Papa_(Fabrica_di_Roma)	wikipedia	24	322	t
297	https://www.tripadvisor.it/Attraction_Review-g1629255-d12827729-Reviews-Falerii_Novi-Fabrica_di_Roma_Province_of_Viterbo_Lazio.html	tripadvisor	24	323	t
298	https://www.tripadvisor.it/Attraction_Review-g1629255-d12827747-Reviews-Castello_Farnese-Fabrica_di_Roma_Province_of_Viterbo_Lazio.html	tripadvisor	24	190	t
299	https://www.tripadvisor.it/Attraction_Review-g7146867-d23690522-Reviews-Castel_Paterno-Faleria_Province_of_Viterbo_Lazio.html	tripadvisor	25	327	t
300	https://www.tripadvisor.it/Attraction_Review-g7146867-d23858016-Reviews-Eremo_Di_San_Famiano-Faleria_Province_of_Viterbo_Lazio.html	tripadvisor	25	329	t
301	https://www.tripadvisor.it/Attraction_Review-g7146867-d23690528-Reviews-Castel_Fogliano_o_Foiano-Faleria_Province_of_Viterbo_Lazio.html	tripadvisor	25	331	t
302	https://www.tripadvisor.it/Attraction_Review-g7146867-d12827743-Reviews-Chiesa_della_Madonna_Pietrafitta-Faleria_Province_of_Viterbo_Lazio.html	tripadvisor	25	333	t
303	https://www.tripadvisor.it/Attraction_Review-g7146867-d12827752-Reviews-Chiesa_di_San_Giuliano_Martire-Faleria_Province_of_Viterbo_Lazio.html	tripadvisor	25	336	t
304	https://www.tripadvisor.it/Attraction_Review-g1493706-d5042739-Reviews-Riserva_Naturale_Regionale_Selva_del_Lamone-Farnese_Province_of_Viterbo_Lazio.html	tripadvisor	26	337	t
305	Riserva_naturale_parziale_Selva_del_Lamone	wikipedia	26	337	t
306	Riserva Naturale Regionale Selva del Lamone\n@selvalamone.eu 	facebook	26	337	t
307	https://riserva-naturale-regionale-selva-del-lamone.business.site/	website	26	337	t
308	https://www.tripadvisor.it/Attraction_Review-g1493706-d12671973-Reviews-Centro_Storico_di_Farnese-Farnese_Province_of_Viterbo_Lazio.html	tripadvisor	26	338	t
309	https://www.tripadvisor.it/Attraction_Review-g1493706-d12865643-Reviews-Parrocchia_Santissimo_Salvatore-Farnese_Province_of_Viterbo_Lazio.html	tripadvisor	26	339	t
310	https://www.tripadvisor.it/Attraction_Review-g1493706-d7099050-Reviews-Cascata_del_Salabrone-Farnese_Province_of_Viterbo_Lazio.html	tripadvisor	26	342	t
311	https://www.tripadvisor.it/Attraction_Review-g1493706-d12741843-Reviews-Monastero_Clarisse-Farnese_Province_of_Viterbo_Lazio.html	tripadvisor	26	346	t
312	Murv - Museo Civico "F. Rittatore Vonwiller"\n@museocivicofarnese  · Museo di storia	facebook	26	347	t
313	www.simulabo.it	website	26	347	t
314	https://www.tripadvisor.it/Attraction_Review-g3639717-d21233913-Reviews-Castello_Di_Rocchette-Gallese_Province_of_Viterbo_Lazio.html	tripadvisor	27	350	t
315	https://www.tripadvisor.it/Attraction_Review-g3639717-d12827755-Reviews-Concattedrale_di_Santa_Maria_Assunta-Gallese_Province_of_Viterbo_Lazio.html	tripadvisor	27	44	t
316	Concattedrale_di_Santa_Maria_Assunta_(Gallese)	wikipedia	27	44	t
317	https://www.tripadvisor.it/Attraction_Review-g3639717-d21233911-Reviews-Castello_Altemps-Gallese_Province_of_Viterbo_Lazio.html	tripadvisor	27	353	t
318	https://www.tripadvisor.it/Attraction_Review-g3639717-d8754942-Reviews-Chiesa_di_San_Famiano-Gallese_Province_of_Viterbo_Lazio.html	tripadvisor	27	356	t
319	https://www.tripadvisor.it/Attraction_Review-g3639717-d12194247-Reviews-Chiesa_di_Sant_Agostino-Gallese_Province_of_Viterbo_Lazio.html	tripadvisor	27	335	t
320	https://www.tripadvisor.it/Attraction_Review-g3639717-d12221779-Reviews-Museo_e_Centro_Culturale_Marco_Scacchi-Gallese_Province_of_Viterbo_Lazio.html	tripadvisor	27	360	t
321	Museo e Centro Culturale "Marco Scacchi"\n@museoecentroculturalemarcoscacchidigallese	facebook	27	360	t
322	Collegiata_di_Santa_Maria_Maddalena_(Gradoli)	wikipedia	28	363	t
323	Parrocchiasantamariamaddalena.it\n@Parrocchiasantamariamaddalenait  · Organizzazione religiosa	facebook	28	363	t
324	http://www.santamariamaddalena.net/index.php?option=com_content&view=frontpage&Itemid=1	website	28	363	t
325	https://www.tripadvisor.it/Attraction_Review-g1096003-d10803258-Reviews-Palazzo_Farnese-Gradoli_Province_of_Viterbo_Lazio.html	tripadvisor	28	169	t
326	Palazzo_Farnese_(Gradoli)	wikipedia	28	169	t
327	https://www.tripadvisor.it/Attraction_Review-g1096003-d10682544-Reviews-Museo_del_Costume_Farnesiano-Gradoli_Province_of_Viterbo_Lazio.html	tripadvisor	28	367	t
328	Museo_del_costume_farnesiano	wikipedia	28	367	t
329	www.comune.gradoli.vt.it	website	28	367	t
330	https://www.tripadvisor.it/Attraction_Review-g1096003-d10838841-Reviews-Chiesa_Collegiata_di_Santa_Maria_Maddalena-Gradoli_Province_of_Viterbo_Lazio.html	tripadvisor	28	369	t
331	https://www.tripadvisor.it/Attraction_Review-g2623939-d12827750-Reviews-Parrocchia_S_Martino_Vescovo-Graffignano_Province_of_Viterbo_Lazio.html	tripadvisor	29	370	t
332	https://www.tripadvisor.it/Attraction_Review-g2623939-d13908574-Reviews-Chiesa_Parrocchiale_di_Santa_Maria_Assunta-Graffignano_Province_of_Viterbo_Lazi.html	tripadvisor	29	376	t
383	Madonna del Monte\n@MadonnaDelMonte	facebook	34	456	t
335	https://www.tripadvisor.it/Attraction_Review-g1096005-d10842260-Reviews-Monumento_a_Paolo_di_Castro-Grotte_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	30	380	t
336	https://www.tripadvisor.it/Attraction_Review-g1096005-d10842218-Reviews-Fontana_Grande-Grotte_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	30	383	t
337	https://www.tripadvisor.it/Attraction_Review-g1096005-d10842224-Reviews-Chiesa_di_San_Marco-Grotte_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	30	389	t
338	https://www.tripadvisor.it/Attraction_Review-g1096005-d10838826-Reviews-Chiesa_di_San_Pietro_Apostolo-Grotte_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	30	390	t
339	https://www.tripadvisor.it/Attraction_Review-g1096005-d3317077-Reviews-Museo_Civita-Grotte_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	30	391	t
340	Museo Civita\n@museocivita.2020  · Servizio pubblico	facebook	30	391	t
342	https://www.tripadvisor.it/Attraction_Review-g1096005-d15144202-Reviews-Necropoli_di_Centocamere-Grotte_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	30	394	t
343	www.simulabo.it	website	30	395	t
344	https://www.tripadvisor.it/Attraction_Review-g1096005-d7657710-Reviews-Basilica_Santuario_di_Maria_SS_del_Suffragio-Grotte_di_Castro_Province_of_Viterb.html	tripadvisor	30	401	t
884	http://www.ortobotanico.unitus.it/index.php/it/	website	58	925	t
345	https://www.tripadvisor.it/Attraction_Review-g2317368-d4137022-Reviews-Romitori_di_Ischia_di_Castro-Ischia_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	31	402	t
346	http://biblioteche.caspur.it/cgi-bin/BIBLIO_scheda.pl?id_biblioteca=RMSE411	website	31	29	t
347	https://www.tripadvisor.it/Attraction_Review-g2317368-d12827773-Reviews-Palazzo_Farnese-Ischia_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	31	406	t
348	Rocca_di_Ischia_di_Castro	wikipedia	31	406	t
349	Castro_(Lazio)	wikipedia	31	407	t
350	Chiesa_di_Sant%27Ermete_(Ischia_di_Castro)	wikipedia	31	408	t
351	https://www.tripadvisor.it/Attraction_Review-g2317368-d12420384-Reviews-Rovine_DI_Castro-Ischia_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	31	409	t
352	https://www.tripadvisor.it/Attraction_Review-g2317368-d12827765-Reviews-Santuario_della_Madonna_del_Giglio-Ischia_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	31	410	t
353	https://www.tripadvisor.it/Attraction_Review-g2317368-d12827774-Reviews-Chiesa_di_Sant_Ermete_Martire-Ischia_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	31	411	t
354	https://www.tripadvisor.it/Attraction_Review-g2317368-d13955463-Reviews-Museo_Civico_Pietro_e_Turiddo_Lotti-Ischia_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	31	416	t
355	Museo civico archeologico Pietro e Turiddo Lotti di Ischia di Castro	facebook	31	416	t
356	https://www.tripadvisor.it/Attraction_Review-g1501324-d6999116-Reviews-Parco_Comunale_dei_Castagneti-Latera_Province_of_Viterbo_Lazio.html	tripadvisor	32	417	t
357	https://www.tripadvisor.it/Attraction_Review-g1501324-d8342765-Reviews-Madonna_Della_Cava-Latera_Province_of_Viterbo_Lazio.html	tripadvisor	32	418	t
358	https://www.tripadvisor.it/Attraction_Review-g1501324-d8284883-Reviews-Palazzo_Farnese-Latera_Province_of_Viterbo_Lazio.html	tripadvisor	32	169	t
359	Palazzo_Farnese_(Latera)	wikipedia	32	169	t
360	https://www.tripadvisor.it/Attraction_Review-g1501324-d10842851-Reviews-Fontana_di_Canale-Latera_Province_of_Viterbo_Lazio.html	tripadvisor	32	420	t
361	https://www.tripadvisor.it/Attraction_Review-g1501324-d8431383-Reviews-Fontana_del_Piscero-Latera_Province_of_Viterbo_Lazio.html	tripadvisor	32	421	t
362	https://www.tripadvisor.it/Attraction_Review-g1501324-d6999099-Reviews-Ducal_Fountain-Latera_Province_of_Viterbo_Lazio.html	tripadvisor	32	422	t
363	https://www.tripadvisor.it/Attraction_Review-g1501324-d7006969-Reviews-I_Quattro_Archi-Latera_Province_of_Viterbo_Lazio.html	tripadvisor	32	423	t
364	https://www.tripadvisor.it/Attraction_Review-g1501324-d6999111-Reviews-Collegiata_di_San_Clemente-Latera_Province_of_Viterbo_Lazio.html	tripadvisor	32	424	t
365	https://www.tripadvisor.it/Attraction_Review-g1501324-d6999100-Reviews-Piazza_IV_Novembre-Latera_Province_of_Viterbo_Lazio.html	tripadvisor	32	425	t
366	https://www.tripadvisor.it/Attraction_Review-g1501324-d6856016-Reviews-Museo_Della_Terra-Latera_Province_of_Viterbo_Lazio.html	tripadvisor	32	430	t
367	Museo della Terra di Latera\n@MuseoDellaTerraLatera  · Museo di storia	facebook	32	430	t
368	www.simulabo.it; /www.regione.lazio.it/musei/latera/	website	32	430	t
369	https://www.tripadvisor.it/Attraction_Review-g1501324-d7085160-Reviews-Piazza_Della_Rocca-Latera_Province_of_Viterbo_Lazio.html	tripadvisor	32	431	t
370	https://www.tripadvisor.it/Attraction_Review-g1501324-d7001164-Reviews-Chiesa_di_San_Sebastiano-Latera_Province_of_Viterbo_Lazio.html	tripadvisor	32	433	t
371	https://www.tripadvisor.it/Attraction_Review-g1568587-d12827809-Reviews-Fontana_La_Pucciotta-Lubriano_Province_of_Viterbo_Lazio.html	tripadvisor	33	436	t
372	https://www.tripadvisor.it/Attraction_Review-g1568587-d12827806-Reviews-Chiesa_di_San_Giovanni_Battista-Lubriano_Province_of_Viterbo_Lazio.html	tripadvisor	33	437	t
373	https://www.tripadvisor.it/Attraction_Review-g1568587-d14200959-Reviews-Teatro_dei_Calanchi-Lubriano_Province_of_Viterbo_Lazio.html	tripadvisor	33	442	t
374	https://www.tripadvisor.it/Attraction_Review-g1568587-d5565548-Reviews-Museo_Naturalistico_di_Lubriano-Lubriano_Province_of_Viterbo_Lazio.html	tripadvisor	33	443	t
375	Museo Naturalistico Lubriano\n@museonaturalisticodilubriano	facebook	33	443	t
376	https://www.tripadvisor.it/Attraction_Review-g1568587-d14200978-Reviews-Torre_Monaldeschi-Lubriano_Province_of_Viterbo_Lazio.html	tripadvisor	33	445	t
377	https://www.tripadvisor.it/Attraction_Review-g1568587-d12827816-Reviews-Chiesa_della_Madonna_del_Poggio-Lubriano_Province_of_Viterbo_Lazio.html	tripadvisor	33	446	t
378	https://www.tripadvisor.it/Attraction_Review-g1096000-d15266261-Reviews-Grotta_delle_Apparizioni-Marta_Province_of_Viterbo_Lazio.html	tripadvisor	34	452	t
379	https://www.tripadvisor.it/Attraction_Review-g1096000-d20557786-Reviews-Chiesa_del_Santissimo_Crocifisso-Marta_Province_of_Viterbo_Lazio.html	tripadvisor	34	453	t
380	https://www.tripadvisor.it/Attraction_Review-g1096000-d20557828-Reviews-Sito_Templare_di_Castell_Araldo-Marta_Province_of_Viterbo_Lazio.html	tripadvisor	34	454	t
381	https://www.tripadvisor.it/Attraction_Review-g1096000-d10847588-Reviews-Chiesa_di_Santa_Marta_e_San_Biagio_Vescovo_e_Martire-Marta_Province_of_Viterbo_.html	tripadvisor	34	455	t
382	https://www.tripadvisor.it/Attraction_Review-g1096000-d20557822-Reviews-Chiesa_della_Madonna_del_Monte-Marta_Province_of_Viterbo_Lazio.html	tripadvisor	34	456	t
385	https://www.tripadvisor.it/Attraction_Review-g1096000-d7148994-Reviews-Tower_Clock-Marta_Province_of_Viterbo_Lazio.html	tripadvisor	34	457	t
386	Torre dell'orologio di Marta\n@Torredimarta	facebook	34	457	t
387	https://www.tripadvisor.it/Attraction_Review-g1096000-d7234196-Reviews-Lungolago_di_Marta-Marta_Province_of_Viterbo_Lazio.html	tripadvisor	34	458	t
388	https://www.tripadvisor.it/Attraction_Review-g1096000-d20557781-Reviews-Chiesa_della_Madonna_del_Castagno-Marta_Province_of_Viterbo_Lazio.html	tripadvisor	34	459	t
389	Isola_Martana	wikipedia	34	461	t
390	https://www.tripadvisor.it/Attraction_Review-g1079102-d20713136-Reviews-Madonna_dello_Speronello-Montalto_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	35	462	t
391	https://www.tripadvisor.it/Attraction_Review-g1079102-d17630212-Reviews-Parco_Archeologico_Naturalistico_di_Vulci-Montalto_di_Castro_Province_of_Viterb.html	tripadvisor	35	463	t
392	Vulci	wikipedia	35	463	t
393	https://vulci.it/	website	35	463	t
394	https://www.tripadvisor.it/Attraction_Review-g1079102-d12677359-Reviews-Chiesa_di_Santa_Maria_Assunta-Montalto_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	35	376	t
395	https://www.tripadvisor.it/Attraction_Review-g1079102-d246592-Reviews-Vulci-Montalto_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	35	465	t
396	Vulci	wikipedia	35	465	t
397	https://vulci.it/	website	35	465	t
399	https://www.tripadvisor.it/Attraction_Review-g1079102-d12677361-Reviews-Castello_Guglielmi-Montalto_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	35	467	t
400	https://www.tripadvisor.it/Attraction_Review-g1079102-d4196360-Reviews-Centro_Storico-Montalto_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	35	354	t
401	https://www.tripadvisor.it/Attraction_Review-g1079102-d20805746-Reviews-Fontana_del_Mascherone-Montalto_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	35	469	t
402	https://www.tripadvisor.it/Attraction_Review-g1079102-d20797407-Reviews-Ponte_del_Diavolo-Montalto_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	35	470	t
403	https://www.tripadvisor.it/Attraction_Review-g1079102-d13143161-Reviews-Chiesa_di_Santa_Croce-Montalto_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	35	471	t
404	https://www.tripadvisor.it/Attraction_Review-g1079102-d13482464-Reviews-Teatro_Comunale_Lea_Padovani-Montalto_di_Castro_Province_of_Viterbo_Lazio.html	tripadvisor	35	472	t
405	Teatro Comunale "Lea Padovani"	facebook	35	472	t
406	teatroleopadovano	instagram	35	472	t
407	https://www.teatroleapadovani.it/	website	35	472	t
408	https://www.tripadvisor.it/Attraction_Review-g1929590-d12827813-Reviews-Parrocchia_Di_Santo_Spirito-Monte_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	36	473	t
409	Teatro Comunale ''La Rotonda''	facebook	36	473	t
410	https://www.tripadvisor.it/Attraction_Review-g1929590-d12827829-Reviews-Rocca_Respampani-Monte_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	36	476	t
411	Rocca Respampani\n@Rocca.Respampani 	facebook	36	476	t
412	Chiesa_di_Santa_Maria_di_Montedoro	wikipedia	37	484	t
413	https://www.tripadvisor.it/Attraction_Review-g815534-d3227669-Reviews-Chiesa_di_San_Flaviano-Montefiascone_Province_of_Viterbo_Lazio.html	tripadvisor	37	485	t
414	Chiesa_di_San_Flaviano_(Montefiascone)	wikipedia	37	485	t
415	Basilica di San Flaviano Montefiascone	facebook	37	485	t
416	http://www.cittadimontefiascone.it/biblioteca.htm	website	37	29	t
417	https://www.tripadvisor.it/Attraction_Review-g815534-d20326198-Reviews-Santuario_Santa_Maria_delle_Grazie-Montefiascone_Province_of_Viterbo_Lazio.html	tripadvisor	37	487	t
418	anta_Maria_delle_Grazie,_Montefiascone	wikipedia	37	487	t
419	Santuario Madonna delle Grazie\n@santuariomadonnagrazie	facebook	37	487	t
420	https://www.tripadvisor.it/Attraction_Review-g815534-d17390528-Reviews-Monumento_al_Pellegrino-Montefiascone_Province_of_Viterbo_Lazio.html	tripadvisor	37	493	t
421	https://www.tripadvisor.it/Attraction_Review-g815534-d4505037-Reviews-Rocca_dei_Papi-Montefiascone_Province_of_Viterbo_Lazio.html	tripadvisor	37	494	t
422	Rocca_dei_Papi	wikipedia	37	494	t
423	https://www.tripadvisor.it/Attraction_Review-g815534-d20318278-Reviews-Chiesa_Sant_Andrea_in_Campo-Montefiascone_Province_of_Viterbo_Lazio.html	tripadvisor	37	496	t
424	Sant'Andrea,_Montefiascone	wikipedia	37	496	t
425	https://www.tripadvisor.it/Attraction_Review-g815534-d4994806-Reviews-Cattedrale_di_Santa_Margherita-Montefiascone_Province_of_Viterbo_Lazio.html	tripadvisor	37	497	t
426	Cattedrale_di_Santa_Margherita	wikipedia	37	497	t
427	https://www.tripadvisor.it/Attraction_Review-g2140821-d10104535-Reviews-Antica_Fontana_Papa_Leone-Monterosi_Province_of_Viterbo_Lazio.html	tripadvisor	38	502	t
428	https://www.tripadvisor.it/Attraction_Review-g2140821-d11443774-Reviews-Lago_di_Monterosi-Monterosi_Province_of_Viterbo_Lazio.html	tripadvisor	38	503	t
429	Lago_di_Monterosi	wikipedia	38	503	t
430	https://www.tripadvisor.it/Attraction_Review-g2140821-d13530685-Reviews-Chiesa_di_San_Giuseppe-Monterosi_Province_of_Viterbo_Lazio.html	tripadvisor	38	504	t
431	https://www.tripadvisor.it/Attraction_Review-g2140821-d9466274-Reviews-Parrocchia_S_Croce-Monterosi_Province_of_Viterbo_Lazio.html	tripadvisor	38	506	t
432	Parrocchia Santa Croce Monterosi\n@parrocchiasantacrocemonterosi  · Organizzazione religiosa	facebook	38	506	t
433	https://www.tripadvisor.it/Attraction_Review-g2015935-d21506634-Reviews-Isola_Conversina-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	507	t
434	https://www.tripadvisor.it/Attraction_Review-g2015935-d21339423-Reviews-Chiesa_Di_San_Rocco-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	508	t
435	https://www.tripadvisor.it/Attraction_Review-g2015935-d12822384-Reviews-Castello_di_Ponte_Nepesino-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	509	t
436	https://www.tripadvisor.it/Attraction_Review-g2015935-d12822243-Reviews-Palazzo_Comunale-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	510	t
437	Palazzo_Comunale_(Nepi)	wikipedia	39	510	t
438	https://www.tripadvisor.it/Attraction_Review-g2015935-d12822308-Reviews-Chiesa_di_San_Vito-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	511	t
439	Palazzo Celsi\n@palazzocelsi	facebook	39	512	t
440	https://www.tripadvisor.it/Attraction_Review-g2015935-d12822363-Reviews-La_Via_Armerina-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	513	t
441	https://www.tripadvisor.it/Attraction_Review-g2015935-d12822252-Reviews-Chiesa_di_San_Pietro_Apostolo-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	515	t
442	Chiesa_di_San_Pietro_Apostolo_(Nepi)	wikipedia	39	515	t
443	https://www.tripadvisor.it/Attraction_Review-g2015935-d12822381-Reviews-Necropoli_dei_Tre_Ponti-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	516	t
444	https://www.tripadvisor.it/Attraction_Review-g2015935-d12822351-Reviews-Porta_Porciana-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	517	t
445	https://www.tripadvisor.it/Attraction_Review-g2015935-d16966472-Reviews-Chiesa_di_San_Silvestro-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	519	t
446	https://www.tripadvisor.it/Attraction_Review-g2015935-d12815343-Reviews-Biblioteca_Comunale-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	521	t
447	https://www.tripadvisor.it/Attraction_Review-g2015935-d12822358-Reviews-Porta_Nica-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	524	t
448	https://www.tripadvisor.it/Attraction_Review-g2015935-d10261582-Reviews-Catacomba_di_Santa_Savinilla-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	525	t
449	Catacomba_di_Santa_Savinilla	wikipedia	39	525	t
450	https://www.tripadvisor.it/Attraction_Review-g2015935-d16880840-Reviews-Chiesa_di_San_Biagio-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	315	t
451	https://www.tripadvisor.it/Attraction_Review-g2015935-d10261604-Reviews-Museo_Civico_Archeologico-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	527	t
452	MUSEO Civico di NEPI\n@museociviconepi  · Museo d'arte	facebook	39	527	t
453	https://www.tripadvisor.it/Attraction_Review-g2015935-d23452337-Reviews-Chiesa_Di_San_Giovanni_Decollato-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	528	t
454	Chiesa_di_San_Giovanni_Decollato_(Nepi)	wikipedia	39	528	t
455	https://www.tripadvisor.it/Attraction_Review-g2015935-d13460601-Reviews-Cascata_dei_Cavaterra-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	529	t
456	https://www.tripadvisor.it/Attraction_Review-g2015935-d10911027-Reviews-Acquedotto_di_Nepi-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	531	t
457	Acquedotto_di_Nepi	wikipedia	39	531	t
458	https://www.tripadvisor.it/Attraction_Review-g2015935-d12820458-Reviews-Il_Forte_Dei_Borgia-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	532	t
459	Rocca_di_Nepi	wikipedia	39	532	t
460	https://www.tripadvisor.it/Attraction_Review-g2015935-d21327386-Reviews-Chiesa_di_San_Tolomeo-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	533	t
461	https://www.tripadvisor.it/Attraction_Review-g2015935-d13072990-Reviews-Cascata_del_Picchio-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	534	t
462	https://www.tripadvisor.it/Attraction_Review-g2015935-d12429013-Reviews-Basilica_Concattedrale_di_Santa_Maria_Assunta-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	535	t
463	Duomo_di_Nepi	wikipedia	39	535	t
464	https://www.tripadvisor.it/Attraction_Review-g2015935-d12822310-Reviews-Porta_Romana-Nepi_Province_of_Viterbo_Lazio.html	tripadvisor	39	76	t
465	https://www.tripadvisor.it/Attraction_Review-g2314037-d12827825-Reviews-Chiesa_di_Santa_Maria_della_Conciliazione-Onano_Province_of_Viterbo_Lazio.html	tripadvisor	40	538	t
466	https://www.tripadvisor.it/Attraction_Review-g2314037-d8562831-Reviews-Castello_di_Onano-Onano_Province_of_Viterbo_Lazio.html	tripadvisor	40	541	t
467	https://www.tripadvisor.it/Attraction_Review-g2168115-d13569411-Reviews-Convento_di_Sant_Antonio_da_Padova-Oriolo_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	41	542	t
468	https://www.tripadvisor.it/Attraction_Review-g2168115-d4098304-Reviews-Parco_della_Mola-Oriolo_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	41	543	t
469	https://www.tripadvisor.it/Attraction_Review-g2168115-d13569391-Reviews-Chiesa_di_Sant_Anna-Oriolo_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	41	544	t
470	https://www.tripadvisor.it/Attraction_Review-g2168115-d6624194-Reviews-La_Faggeta_Di_Oriolo_Romano-Oriolo_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	41	545	t
471	https://www.tripadvisor.it/Attraction_Review-g2168115-d12827835-Reviews-Parrocchia_San_Giorgio_Martire-Oriolo_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	41	546	t
472	Parrocchia San Giorgio Martire Oriolo Romano\n@ParrocchiaOrioloRomano	facebook	41	546	t
473	https://www.tripadvisor.it/Attraction_Review-g2168115-d3210861-Reviews-Palazzo_Altieri-Oriolo_Romano_Province_of_Viterbo_Lazio.html	tripadvisor	41	547	t
474	Palazzo_Altieri_(Oriolo_Romano)	wikipedia	41	547	t
475	Palazzo Altieri\n@PalazzoAltieriOrioloRomano	facebook	41	547	t
476	https://www.tripadvisor.it/Attraction_Review-g1025341-d11677548-Reviews-Palazzo_Alberti-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	103	t
477	https://www.tripadvisor.it/Attraction_Review-g1025341-d11677703-Reviews-Santuario_della_Santissima_Trinita-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	552	t
478	Santuario della Santissima Trinità - ORTE\n@SantuarioSantissimaTrinitaOrte  · Chiesa	facebook	42	552	t
479	http://www.chiesatrinitaorte.it/	website	42	552	t
480	https://www.tripadvisor.it/Attraction_Review-g1025341-d11677543-Reviews-Palazzo_Roberteschi-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	553	t
481	https://www.tripadvisor.it/Attraction_Review-g1025341-d11674486-Reviews-Chiesa_ed_Ex_convento_di_Sant_Agostino-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	335	t
482	Museo Civico Archeologico Orte\n@MuseoCivicoArcheologicoOrte 	facebook	42	555	t
483	https://www.tripadvisor.it/Attraction_Review-g1025341-d19653091-Reviews-Chiesa_di_San_Pietro-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	556	t
484	Cinema Alberini Orte\n@cinealberiniorte	facebook	42	557	t
485	Biblioteca Ente Ottava Medievale\n@bibliotecaenteottavamedievale  · Biblioteca	facebook	42	560	t
486	www.confraterniteorte.it	website	42	562	t
487	www.comune.orte.vt.it/c056042/zf/index.php/servizi-aggiuntivi/index/index/idtesto/27	website	42	563	t
488	https://www.tripadvisor.it/Attraction_Review-g1025341-d11673123-Reviews-Acquedotto_Rinascimentale-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	564	t
489	https://www.tripadvisor.it/Attraction_Review-g1025341-d11677546-Reviews-Palazzo_dell_Orologio-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	565	t
490	www.diocesicivitacastellana.it	website	42	566	t
491	https://www.tripadvisor.it/Attraction_Review-g1025341-d11677538-Reviews-Santuario_di_Santa_Maria_delle_Grazie-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	487	t
492	https://www.tripadvisor.it/Attraction_Review-g11949728-d11674425-Reviews-Chiesa_di_Sant_Antonio-Orte_Scalo_Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	318	t
493	https://www.tripadvisor.it/Attraction_Review-g1025341-d19746303-Reviews-Chiesa_di_Santa_Maria_di_Loreto-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	573	t
494	www.comune.orte.vt.it/c056042/zf/index.php/servizi-aggiuntivi/index/index/idtesto/27	website	42	576	t
495	https://www.tripadvisor.it/Attraction_Review-g1025341-d11677533-Reviews-Chiesa_ed_ex_Convento_di_San_Francesco-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	110	t
496	https://www.tripadvisor.it/Attraction_Review-g1025341-d11674405-Reviews-Basilica_di_Santa_Maria_Assunta-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	578	t
497	Concattedrale_di_Santa_Maria_Assunta_(Orte)	wikipedia	42	578	t
498	https://www.tripadvisor.it/Attraction_Review-g1025341-d11674503-Reviews-Seripola_Porto_Fluviale_sul_Tevere-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	579	t
499	https://www.tripadvisor.it/Attraction_Review-g1025341-d3825392-Reviews-Orte_Sotterranea-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	582	t
500	Orte_Sotterranea	wikipedia	42	582	t
501	Orte Sotterranea\n@ortesotterranea 	facebook	42	582	t
502	https://www.tripadvisor.it/Attraction_Review-g1025341-d11677542-Reviews-Piazza_della_Liberta-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	583	t
503	https://www.tripadvisor.it/Attraction_Review-g1025341-d11677561-Reviews-Museo_d_Arte_Sacra_di_Orte-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	584	t
504	https://museodartesacradiorte.it/it/home/	website	42	584	t
505	https://www.tripadvisor.it/Attraction_Review-g1025341-d19752376-Reviews-Centro_Storico_di_Orte-Orte_Province_of_Viterbo_Lazio.html	tripadvisor	42	586	t
506	www.confraterniteorte.it	website	42	562	t
507	https://www.tripadvisor.it/Attraction_Review-g1175095-d17837312-Reviews-Chiesa_di_San_Bernardino_da_Siena-Piansano_Province_of_Viterbo_Lazio.html	tripadvisor	43	588	t
885	www.unitus.it  www.sma.unitus.it	website	58	932	t
508	https://www.tripadvisor.it/Attraction_Review-g1175095-d23064103-Reviews-Portico_Del_Palazzo_Comunale-Piansano_Province_of_Viterbo_Lazio.html	tripadvisor	43	590	t
509	https://www.tripadvisor.it/Attraction_Review-g1400633-d19118049-Reviews-Chiesa_della_Madonna_del_Giglio-Proceno_Province_of_Viterbo_Lazio.html	tripadvisor	44	591	t
510	https://www.tripadvisor.it/Attraction_Review-g1400633-d19112730-Reviews-Castello_di_Proceno-Proceno_Province_of_Viterbo_Lazio.html	tripadvisor	44	595	t
511	https://www.castellodiproceno.it/il-castello/la-storia-del-castello/	website	44	595	t
512	https://www.tripadvisor.it/Attraction_Review-g1400633-d12827844-Reviews-Chiesa_di_Sant_Agnese-Proceno_Province_of_Viterbo_Lazio.html	tripadvisor	44	596	t
513	https://www.tripadvisor.it/Attraction_Review-g1400633-d19118055-Reviews-Chiesa_del_Santissimo_Salvatore-Proceno_Province_of_Viterbo_Lazio.html	tripadvisor	44	339	t
514	https://www.tripadvisor.it/Attraction_Review-g1400633-d19117962-Reviews-Chiesa_di_San_Martino-Proceno_Province_of_Viterbo_Lazio.html	tripadvisor	44	71	t
515	https://www.tripadvisor.it/Attraction_Review-g1077056-d20558495-Reviews-Chiesa_di_Santa_Maria_della_Provvidenza-Ronciglione_Province_of_Viterbo_Lazio.html	tripadvisor	45	601	t
516	https://www.tripadvisor.it/Attraction_Review-g1077056-d19588615-Reviews-Fontana_degli_Unicorni-Ronciglione_Province_of_Viterbo_Lazio.html	tripadvisor	45	602	t
517	https://www.tripadvisor.it/Attraction_Review-g1077056-d10818560-Reviews-Chiesa_di_Santa_Maria_della_Pace_e_Sant_Andrea-Ronciglione_Province_of_Viterbo_.html	tripadvisor	45	603	t
518	Istituzione Biblioteca Comunale di Ronciglione "Romolo Bellatreccia"\nBiblioteca	facebook	45	604	t
519	https://www.tripadvisor.it/Attraction_Review-g1077056-d12241796-Reviews-Ponte_Ferroviario_di_Ronciglione-Ronciglione_Province_of_Viterbo_Lazio.html	tripadvisor	45	606	t
520	Ponte_di_Ronciglione	wikipedia	45	606	t
521	Ponte Ferroviario di Ronciglione in stile Torre Eiffel\n@PonteFerroviariodiRonciglione	facebook	45	606	t
522	https://www.tripadvisor.it/Attraction_Review-g1077056-d21393523-Reviews-Church_of_Santa_Maria_Incoronata_and_Santa_Lucia_Vergine_Martire-Ronciglione_Pr.html	tripadvisor	45	607	t
523	https://www.tripadvisor.it/Attraction_Review-g1077056-d8178548-Reviews-Chiesa_Sant_Eusebio-Ronciglione_Province_of_Viterbo_Lazio.html	tripadvisor	45	609	t
524	https://www.tripadvisor.it/Attraction_Review-g1077056-d14157064-Reviews-Casino_di_caccia_dei_Farnese-Ronciglione_Province_of_Viterbo_Lazio.html	tripadvisor	45	610	t
525	https://www.tripadvisor.it/Attraction_Review-g1077056-d12683815-Reviews-Castello_di_Ronciglione-Ronciglione_Province_of_Viterbo_Lazio.html	tripadvisor	45	611	t
526	https://www.tripadvisor.it/Attraction_Review-g1077056-d10801805-Reviews-Duomo_Santi_Pietro_e_Caterina-Ronciglione_Province_of_Viterbo_Lazio.html	tripadvisor	45	613	t
527	Museo_della_vecchia_ferriera	wikipedia	45	614	t
528	https://www.tripadvisor.it/Attraction_Review-g1077056-d246593-Reviews-Lago_di_Vico-Ronciglione_Province_of_Viterbo_Lazio.html	tripadvisor	45	615	t
529	Lago_di_Vico	wikipedia	45	615	t
530	https://www.tripadvisor.it/Attraction_Review-g1096006-d19516576-Reviews-Chiesa_San_Lorenzo_Martire-San_Lorenzo_Nuovo_Province_of_Viterbo_Lazio.html	tripadvisor	46	616	t
531	Parrocchia San Lorenzo Martire\nOrganizzazione religiosa	facebook	46	616	t
532	https://www.tripadvisor.it/Attraction_Review-g1096006-d12258752-Reviews-Piazza_Europa-San_Lorenzo_Nuovo_Province_of_Viterbo_Lazio.html	tripadvisor	46	617	t
533	https://www.tripadvisor.it/Attraction_Review-g1096006-d19516577-Reviews-Chiesa_della_Madonna_di_Torano-San_Lorenzo_Nuovo_Province_of_Viterbo_Lazio.html	tripadvisor	46	618	t
534	https://www.tripadvisor.it/Attraction_Review-g1096006-d14030156-Reviews-Chiesa_di_San_Giovanni-San_Lorenzo_Nuovo_Province_of_Viterbo_Lazio.html	tripadvisor	46	619	t
535	Chiesa_di_San_Giovanni_in_Val_di_Lago	wikipedia	46	619	t
536	https://www.tripadvisor.it/Attraction_Review-g666993-d3211320-Reviews-Palazzo_Doria_Pamphilj-San_Martino_al_Cimino_Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	47	621	t
537	Palazzo Doria Pamphilj - San Martino al Cimino\n@palazzodoriapamphilj 	facebook	47	621	t
538	https://www.tripadvisor.it/Attraction_Review-g666993-d4606347-Reviews-Abbazia_di_San_Martino_al_Cimino-San_Martino_al_Cimino_Viterbo_Province_of_Viterb.html	tripadvisor	47	623	t
539	Abbazia_di_San_Martino_al_Cimino	wikipedia	47	623	t
540	Abbazia di San Martino al Cimino - Parrocchia “S. Martino Vescovo”\n@abbaziasanmartinoalcimino  	facebook	47	623	t
541	https://www.tripadvisor.it/Attraction_Review-g1200600-d23183704-Reviews-Torre_Di_Santa_Maria_Di_Luco-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	624	t
542	https://www.tripadvisor.it/Attraction_Review-g1200600-d20558378-Reviews-Chiesa_di_Sant_Agostino-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	625	t
543	Chiesa_di_Sant'Agostino_(Soriano_nel_Cimino)	wikipedia	48	625	t
544	Parrocchia S. Pietro - Chiesa di S. Agostino - Soriano nel Cimino\nOrganizzazione religiosa	facebook	48	625	t
545	https://www.tripadvisor.it/Attraction_Review-g1200600-d20558089-Reviews-Chiesa_della_Misericordia-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	140	t
546	https://www.tripadvisor.it/Attraction_Review-g1200600-d20557900-Reviews-Chiesa_di_Sant_Antonio-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	627	t
547	https://www.tripadvisor.it/Attraction_Review-g1200600-d20558492-Reviews-Monte_Cimino-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	628	t
548	Monte_Cimino	wikipedia	48	628	t
549	https://www.tripadvisor.it/Attraction_Review-g1200600-d20557988-Reviews-Chiesa_di_Sant_Antonio_Abate_di_Chia-Soriano_nel_Cimino_Province_of_Viterbo_Laz.html	tripadvisor	48	629	t
550	https://www.tripadvisor.it/Attraction_Review-g1200600-d20557893-Reviews-Chiesa_di_Sant_Eutizio-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	630	t
551	Chiesa_di_Sant'Eutizio	wikipedia	48	630	t
552	https://www.tripadvisor.it/Attraction_Review-g1200600-d20557885-Reviews-Chiesa_di_Santa_Maria_delle_Grazie-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	487	t
553	https://www.tripadvisor.it/Attraction_Review-g1200600-d12677350-Reviews-Chiesa_di_San_Giorgio-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	632	t
554	Chiesa_di_San_Giorgio_(Soriano_nel_Cimino)	wikipedia	48	632	t
880	http://www.biblioteche.unitus.it	website	58	918	t
555	https://www.tripadvisor.it/Attraction_Review-g1200600-d7596097-Reviews-Monumento_naturale_Corviano-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	633	t
556	https://www.tripadvisor.it/Attraction_Review-g1200600-d7189396-Reviews-Castello_Orsini-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	153	t
557	Castello_Orsini_(Soriano_nel_Cimino)	wikipedia	48	153	t
558	https://www.tripadvisor.it/Attraction_Review-g1200600-d20531851-Reviews-Biblioteca_di_Soriano_nel_Cimino-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	29	t
559	Biblioteca Comunale di Soriano nel Cimino\n@BibliotecaComunaleSorianonelCimino  · Biblioteca	facebook	48	29	t
560	http://www.bibliotecasorianonelcimino.org/	website	48	29	t
561	https://www.tripadvisor.it/Attraction_Review-g1200600-d20557870-Reviews-Torre_di_Chia-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	638	t
562	https://www.tripadvisor.it/Attraction_Review-g1200600-d19604740-Reviews-Centro_Storico_Rione_Rocca-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	639	t
563	https://www.tripadvisor.it/Attraction_Review-g1200600-d4701244-Reviews-Fonte_Papacqua-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	640	t
564	https://www.tripadvisor.it/Attraction_Review-g1200600-d12677371-Reviews-Chiesa_di_San_Nicola_di_Bari-Soriano_nel_Cimino_Province_of_Viterbo_Lazio.html	tripadvisor	48	641	t
565	Chiesa_di_San_Nicola_di_Bari_(Soriano_nel_Cimino)	wikipedia	48	641	t
566	https://www.tripadvisor.it/Attraction_Review-g1064663-d11919437-Reviews-Chiesa_di_San_Francesco-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	110	t
567	Chiesa_di_San_Francesco_(Sutri)	wikipedia	49	110	t
568	https://www.tripadvisor.it/Attraction_Review-g1064663-d11919407-Reviews-Chiesa_di_Santa_Maria_del_Monte-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	643	t
569	https://www.tripadvisor.it/Attraction_Review-g1064663-d11919425-Reviews-Porta_Morone-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	644	t
570	https://www.tripadvisor.it/Attraction_Review-g1064663-d12005967-Reviews-Chiesa_Madonna_del_Parto-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	645	t
571	Chiesa_della_Madonna_del_Parto_(Sutri)	wikipedia	49	645	t
572	https://www.tripadvisor.it/Attraction_Review-g1064663-d15287271-Reviews-Chiesa_di_Santa_Croce-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	471	t
573	https://www.tripadvisor.it/Attraction_Review-g1064663-d17519030-Reviews-Piazza_Del_Comune-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	647	t
574	https://www.tripadvisor.it/Attraction_Review-g1064663-d11918807-Reviews-Saturno_a_Cavallo-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	648	t
575	https://www.tripadvisor.it/Attraction_Review-g1064663-d11919547-Reviews-Sentiero_Natura_Il_Grande_Leccio-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	649	t
576	https://www.tripadvisor.it/Attraction_Review-g1064663-d10820173-Reviews-Museo_del_Patrimonium-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	650	t
577	www.comune.sutri.vt.it/	website	49	650	t
578	https://www.tripadvisor.it/Attraction_Review-g1064663-d15287272-Reviews-Chiesa_di_San_Rocco-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	10	t
579	Chiesa_di_San_Rocco_(Sutri)	wikipedia	49	10	t
580	https://www.tripadvisor.it/Attraction_Review-g1064663-d11919558-Reviews-Torre_San_Paolo-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	652	t
581	https://www.tripadvisor.it/Attraction_Review-g1064663-d11919414-Reviews-Cappella_di_Santa_Maria_del_Tempio_o_Cappella_dei_Cavalieri_di_Malta-Sutri_Prov.html	tripadvisor	49	654	t
582	Chiesa_di_Santa_Maria_del_Tempio_(Sutri)	wikipedia	49	654	t
583	https://www.tripadvisor.it/Attraction_Review-g1064663-d9552862-Reviews-Chiesa_della_Santissima_Concezione-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	655	t
584	Chiesa_della_Santissima_Concezione_(Sutri)	wikipedia	49	655	t
585	https://www.tripadvisor.it/Attraction_Review-g1064663-d10823177-Reviews-Il_Mitreo-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	657	t
586	https://www.tripadvisor.it/Attraction_Review-g1064663-d15137273-Reviews-Museo_Palazzo_Doebbing-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	658	t
587	Museo_di_Palazzo_Doebbing	wikipedia	49	658	t
588	Museo di Palazzo Doebbing\n@palazzodoebbingsutri	facebook	49	658	t
589	museopalazzodoebbing	instagram	49	658	t
590	https://museopalazzodoebbing.it/	website	49	658	t
591	https://www.tripadvisor.it/Attraction_Review-g1064663-d11919426-Reviews-La_Torre_dell_Orologio-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	659	t
592	www.comune.sutri.vt.it/	website	49	660	t
593	https://www.tripadvisor.it/Attraction_Review-g1064663-d15287273-Reviews-Fontana_dei_Delfini-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	268	t
594	https://www.tripadvisor.it/Attraction_Review-g1064663-d11919419-Reviews-L_Anfiteatro-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	662	t
595	Anfiteatro_romano_di_Sutri	wikipedia	49	662	t
596	https://www.tripadvisor.it/Attraction_Review-g1064663-d1065654-Reviews-Parco_naturale_regionale_dell_antichissima_citta_di_Sutri-Sutri_Province_of_Vite.html	tripadvisor	49	663	t
597	Parco_dell'antichissima_città_di_Sutri	wikipedia	49	663	t
598	https://www.tripadvisor.it/Attraction_Review-g1064663-d11919597-Reviews-Atrio_Comunale-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	664	t
599	https://www.tripadvisor.it/Attraction_Review-g1064663-d11919447-Reviews-Porta_Franceta-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	665	t
600	https://www.tripadvisor.it/Attraction_Review-g1064663-d10491565-Reviews-Villa_Savorelli-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	666	t
601	https://www.tripadvisor.it/Attraction_Review-g1064663-d11918463-Reviews-Antico_Lavatoio-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	668	t
602	https://www.tripadvisor.it/Attraction_Review-g1064663-d11919456-Reviews-Chiesa_di_San_Silvestro_Papa-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	669	t
603	Chiesa_di_San_Silvestro_(Sutri)	wikipedia	49	669	t
604	https://www.tripadvisor.it/Attraction_Review-g1064663-d4156580-Reviews-Co_Cathedral_of_the_Assumption_of_Mary-Sutri_Province_of_Viterbo_Lazio.html	tripadvisor	49	671	t
605	Concattedrale_di_Santa_Maria_Assunta_(Sutri)	wikipedia	49	671	t
606	https://www.tripadvisor.it/Attraction_Review-g1056428-d12727745-Reviews-Biblioteca_Comunale_Vincenzo_Cardarelli-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	672	t
607	https://www.tripadvisor.it/Attraction_Review-g1056428-d9564591-Reviews-Chiesa_e_Convento_di_San_Francesco-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	673	t
608	https://www.tripadvisor.it/Attraction_Review-g1056428-d10244129-Reviews-Chiesa_di_San_Giacomo-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	674	t
609	https://www.tripadvisor.it/Attraction_Review-g1056428-d12550328-Reviews-Archivio_Storico-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	675	t
610	https://www.tripadvisor.it/Attraction_Review-g1056428-d11865866-Reviews-Saline_di_Tarquinia-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	676	t
611	https://www.tripadvisor.it/Attraction_Review-g1056428-d12550276-Reviews-Porto_Clementino-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	677	t
612	https://www.tripadvisor.it/Attraction_Review-g1056428-d14200066-Reviews-Fontana_monumentale-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	678	t
613	https://www.tripadvisor.it/Attraction_Review-g1056428-d13198591-Reviews-Fontana_Nova-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	680	t
614	https://www.tripadvisor.it/Attraction_Review-g1056428-d12815186-Reviews-Museo_della_Ceramica_d_uso_a_Corneto-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	682	t
615	https://artestoriatarquinia.it/	website	50	682	t
616	https://www.tripadvisor.it/Attraction_Review-g1056428-d2283985-Reviews-Museo_Nazionale_Tarquiniense-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	684	t
617	Museo_archeologico_nazionale_di_Tarquinia	wikipedia	50	684	t
618	htpp//:etruriameridionale.beniculturali.it	website	50	684	t
619	https://www.tripadvisor.it/Attraction_Review-g1056428-d7087951-Reviews-Santa_Maria_di_Castello-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	685	t
620	Chiesa_di_Santa_Maria_in_Castello_(Tarquinia)	wikipedia	50	685	t
621	https://www.tripadvisor.it/Attraction_Review-g1056428-d12556638-Reviews-Parrocchia_Ss_Margherita_E_Martino-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	687	t
622	Duomo_di_Tarquinia	wikipedia	50	687	t
623	Duomo di Tarquinia\n@duomoditarquinia	facebook	50	687	t
624	https://www.tripadvisor.it/Attraction_Review-g1056428-d10239509-Reviews-Chiesa_del_Salvatore-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	688	t
625	https://www.tripadvisor.it/Attraction_Review-g1056428-d14200040-Reviews-Chiesa_del_Suffragio-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	689	t
626	https://www.tripadvisor.it/Attraction_Review-g1056428-d12926881-Reviews-Ara_della_Regina-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	691	t
627	Ara_della_Regina	wikipedia	50	691	t
628	https://www.tripadvisor.it/Attraction_Review-g1056428-d12732438-Reviews-Necropoli_dei_Monterozzi-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	694	t
629	Necropoli_dei_Monterozzi	wikipedia	50	694	t
630	https://www.tripadvisor.it/Attraction_Review-g1056428-d9820498-Reviews-Chiesa_di_San_Martino-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	695	t
631	https://www.tripadvisor.it/Attraction_Review-g1056428-d12568123-Reviews-Porta_Nuova-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	696	t
632	https://www.tripadvisor.it/Attraction_Review-g1056428-d12568116-Reviews-Porta_Tarquinia-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	697	t
633	https://www.tripadvisor.it/Attraction_Review-g1056428-d12556597-Reviews-Torre_Barucci-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	698	t
634	https://www.tripadvisor.it/Attraction_Review-g1056428-d12556603-Reviews-Palazzo_dei_Priori-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	700	t
635	htpp//:etruriameridionale.beniculturali.it/index.php?it/201/descrizione	website	50	701	t
636	https://www.tripadvisor.it/Attraction_Review-g1056428-d8780921-Reviews-Etruscopolis-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	703	t
637	Etruscopolis\n@etruscopolis  · Museo di storia	facebook	50	703	t
638	https://www.etruscopolis.com/	website	50	703	t
639	https://www.tripadvisor.it/Attraction_Review-g1056428-d20297765-Reviews-Palazzo_Comunale-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	28	t
640	https://www.tripadvisor.it/Attraction_Review-g1056428-d21505510-Reviews-Centro_Storico_Di_Tarquinia-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	708	t
641	https://www.tripadvisor.it/Attraction_Review-g1056428-d12568125-Reviews-Palazzo_Vitelleschi-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	709	t
642	Palazzo_Vitelleschi	wikipedia	50	709	t
643	https://www.tripadvisor.it/Attraction_Review-g1056428-d11815767-Reviews-Porta_di_Castello_e_Torrione_detto_di_Matilde_di_Canossa-Tarquinia_Province_of_.html	tripadvisor	50	710	t
644	https://www.tripadvisor.it/Attraction_Review-g1056428-d20300714-Reviews-Chiesa_di_San_Giovanni-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	528	t
645	https://www.tripadvisor.it/Attraction_Review-g1056428-d14200063-Reviews-Chiesa_di_San_Leonardo-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	712	t
646	https://www.tripadvisor.it/Attraction_Review-g1056428-d14209964-Reviews-Chiesa_della_Santissima_Trinita-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	714	t
647	https://www.tripadvisor.it/Attraction_Review-g1056428-d246608-Reviews-Chiesa_di_San_Pancrazio-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	720	t
648	https://www.tripadvisor.it/Attraction_Review-g1056428-d12848752-Reviews-Cencelle-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	721	t
649	Cencelle	wikipedia	50	721	t
650	https://www.tripadvisor.it/Attraction_Review-g1056428-d246587-Reviews-Necropoli_di_Tarquinia-Tarquinia_Province_of_Viterbo_Lazio.html	tripadvisor	50	722	t
651	Necropoli_di_Tarquinia	wikipedia	50	722	t
652	https://necropoliditarquinia.it/	website	50	722	t
653	https://www.tripadvisor.it/Attraction_Review-g661243-d23391723-Reviews-Ruderi_Castello_Del_Rivellino-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	723	t
654	https://www.tripadvisor.it/Attraction_Review-g661243-d23395753-Reviews-Arco_Di_Poggio_Fiorentino-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	724	t
655	https://www.tripadvisor.it/Attraction_Review-g661243-d2688823-Reviews-Cattedrale_di_San_Giacomo-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	725	t
656	Duomo_di_Tuscania	wikipedia	51	725	t
657	https://www.tripadvisor.it/Attraction_Review-g661243-d23391721-Reviews-Chiesa_Di_San_Giuseppe-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	726	t
658	https://www.tripadvisor.it/Attraction_Review-g661243-d23406828-Reviews-Area_Archeologica_Colle_Di_San_Pietro-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	728	t
659	https://www.tripadvisor.it/Attraction_Review-g661243-d23380536-Reviews-Teatro_Comunale_Veriano_Luchetti_Il_Rivellino-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	729	t
660	Stagione Teatro Rivellino - Tuscania\n@stagionerivellino  · Spettacolo teatrale	facebook	51	729	t
661	https://www.tripadvisor.it/Attraction_Review-g661243-d4196358-Reviews-Museo_Archeologico_di_Tuscania-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	684	t
663	https://www.tripadvisor.it/Attraction_Review-g661243-d23372759-Reviews-Necropoli_Pian_Di_Mola-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	731	t
664	https://www.tripadvisor.it/Attraction_Review-g661243-d6639118-Reviews-Casa_Museo_Pietro_Moschini-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	732	t
666	https://www.tripadvisor.it/Attraction_Review-g661243-d10584277-Reviews-Fontana_delle_sette_cannelle-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	734	t
667	https://www.tripadvisor.it/Attraction_Review-g661243-d23391722-Reviews-Chiesa_Di_San_Giovanni_Decollato-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	735	t
668	https://www.tripadvisor.it/Attraction_Review-g661243-d15075847-Reviews-Chiesa_Santi_Marco_e_Silvestro-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	389	t
669	https://www.tripadvisor.it/Attraction_Review-g661243-d23379440-Reviews-Antica_Via_Clodia-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	737	t
670	Antica Via Clodia	facebook	51	737	t
671	anticaviaclodia	instagram	51	737	t
672	http://www.anticaviaclodia.it/	website	51	737	t
673	https://www.tripadvisor.it/Attraction_Review-g661243-d246603-Reviews-Church_of_San_Pietro-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	739	t
674	Chiesa_di_San_Pietro_(Tuscania)	wikipedia	51	739	t
675	https://www.tripadvisor.it/Attraction_Review-g661243-d20438714-Reviews-Chiesa_di_Sant_Agostino-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	625	t
676	https://www.tripadvisor.it/Attraction_Review-g661243-d12622519-Reviews-Santa_Maria_del_Riposo-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	741	t
677	htpp//:etruriameridionale.beniculturali.it	website	51	742	t
678	Abbazia_di_San_Giusto_a_Tuscania	wikipedia	51	743	t
679	Mura_di_Tuscania	wikipedia	51	744	t
680	https://www.tripadvisor.it/Attraction_Review-g661243-d23380517-Reviews-Terme_Romane_della_Regina_Bagni_della_Regina-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	746	t
681	https://www.tripadvisor.it/Attraction_Review-g661243-d246604-Reviews-Basilica_di_Santa_Maria_Maggiore-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	747	t
682	Chiesa_di_Santa_Maria_Maggiore_(Tuscania)	wikipedia	51	747	t
683	https://www.tripadvisor.it/Attraction_Review-g661243-d7001128-Reviews-Area_archeologica_Madonna_dell_Olivo-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	750	t
684	Necropoli_Madonna_dell'Olivo	wikipedia	51	750	t
685	https://www.tripadvisor.it/Attraction_Review-g661243-d21170335-Reviews-Necropoli_della_Peschiera_e_Tomba_a_Dado-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	751	t
686	Necropoli_di_Peschiera	wikipedia	51	751	t
687	Gruppo Archeologico Città di Tuscania\n@gruppoarcheologicotuscania	facebook	51	751	t
688	https://www.tripadvisor.it/Attraction_Review-g661243-d10636996-Reviews-Parco_Torre_di_Lavello-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	752	t
689	https://www.tripadvisor.it/Attraction_Review-g661243-d12622523-Reviews-Chiesa_di_Santa_Maria_della_Rosa-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	753	t
690	https://www.tripadvisor.it/Attraction_Review-g661243-d20349889-Reviews-Fontana_di_Montascide-Tuscania_Province_of_Viterbo_Lazio.html	tripadvisor	51	754	t
691	https://www.tripadvisor.it/Attraction_Review-g1096002-d3731604-Reviews-Museo_della_Preistoria_della_Tuscia_e_della_Rocca_Farnese-Valentano_Province_of_.html	tripadvisor	52	757	t
692	Museo_della_preistoria_della_Tuscia_e_della_Rocca_Farnese	wikipedia	52	757	t
693	Museo della preistoria della Tuscia e della Rocca Farnese\n@MuseoDellaPreistoriaDellaTusciaEDellaRoccaFarnese 	facebook	52	757	t
694	museodellapreisotriavalentano	instagram	52	757	t
695	www.simulabo.it	website	52	757	t
696	https://www.tripadvisor.it/Attraction_Review-g1096002-d12219908-Reviews-Lago_di_Mezzano-Valentano_Province_of_Viterbo_Lazio.html	tripadvisor	52	758	t
697	Lago_di_Mezzano	wikipedia	52	758	t
698	https://www.tripadvisor.it/Attraction_Review-g1096002-d12219953-Reviews-Ex_Chiesa_dell_Eschio-Valentano_Province_of_Viterbo_Lazio.html	tripadvisor	52	760	t
699	https://www.tripadvisor.it/Attraction_Review-g1096002-d15117282-Reviews-Centro_Storico_di_Valentano-Valentano_Province_of_Viterbo_Lazio.html	tripadvisor	52	762	t
700	https://www.tripadvisor.it/Attraction_Review-g1096002-d20325685-Reviews-Porta_di_San_Martino-Valentano_Province_of_Viterbo_Lazio.html	tripadvisor	52	763	t
701	https://www.tripadvisor.it/Attraction_Review-g1096002-d12987646-Reviews-Chiesa_di_Santa_Maria-Valentano_Province_of_Viterbo_Lazio.html	tripadvisor	52	248	t
702	https://www.tripadvisor.it/Attraction_Review-g1096002-d20316731-Reviews-Porta_Magenta-Valentano_Province_of_Viterbo_Lazio.html	tripadvisor	52	765	t
703	https://www.tripadvisor.it/Attraction_Review-g1096002-d12987643-Reviews-Chiesa_di_San_Giovanni_Evangelista-Valentano_Province_of_Viterbo_Lazio.html	tripadvisor	52	769	t
704	Parrocchia S. Giovanni Apostolo ed Evangelista - Valentano\n@parrsangiovanni  · Chiesa cattolica	facebook	52	769	t
705	https://www.tripadvisor.it/Attraction_Review-g1096002-d20386552-Reviews-Santuario_della_Madonna_della_Salute-Valentano_Province_of_Viterbo_Lazio.html	tripadvisor	52	770	t
706	Santuario Madonna della Salute - Valentano\n@santsalutevalentano  · Chiesa cattolica	facebook	52	770	t
707	https://www.tripadvisor.it/Attraction_Review-g3247595-d19342919-Reviews-Chiesa_SS_Crocefisso-Vallerano_Province_of_Viterbo_Lazio.html	tripadvisor	53	771	t
708	https://www.tripadvisor.it/Attraction_Review-g3247595-d13981031-Reviews-Grotte_dei_Quadratini_e_dei_Finestroni-Vallerano_Province_of_Viterbo_Lazio.html	tripadvisor	53	772	t
709	https://www.tripadvisor.it/Attraction_Review-g3247595-d12176288-Reviews-Eremo_di_San_Salvatore-Vallerano_Province_of_Viterbo_Lazio.html	tripadvisor	53	773	t
710	https://www.tripadvisor.it/Attraction_Review-g3247595-d19356446-Reviews-Chiesa_Madonna_della_Pieve-Vallerano_Province_of_Viterbo_Lazio.html	tripadvisor	53	774	t
711	https://www.tripadvisor.it/Attraction_Review-g3247595-d10802931-Reviews-Santuario_della_Madonna_del_Ruscello-Vallerano_Province_of_Viterbo_Lazio.html	tripadvisor	53	775	t
712	Chiesa_della_Madonna_del_Ruscello	wikipedia	53	775	t
713	https://www.tripadvisor.it/Attraction_Review-g3247595-d13981029-Reviews-Grotte_di_San_Lorenzo-Vallerano_Province_of_Viterbo_Lazio.html	tripadvisor	53	776	t
714	https://www.tripadvisor.it/Attraction_Review-g3247595-d12172290-Reviews-Grotte_di_San_Leonardo-Vallerano_Province_of_Viterbo_Lazio.html	tripadvisor	53	779	t
715	https://www.tripadvisor.it/Attraction_Review-g3247595-d19356432-Reviews-Chiesa_San_Vittore-Vallerano_Province_of_Viterbo_Lazio.html	tripadvisor	53	780	t
716	https://www.tripadvisor.it/Attraction_Review-g2205532-d12187618-Reviews-Lago_Vadimone-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	781	t
717	https://www.tripadvisor.it/Attraction_Review-g2205532-d12214839-Reviews-Chiesa_di_San_Silvestro-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	519	t
718	https://www.tripadvisor.it/Attraction_Review-g2205532-d12214892-Reviews-Cunicolo_Tra_i_Fossi_Canale_e_Tre_Fontane-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	783	t
719	https://www.tripadvisor.it/Attraction_Review-g2205532-d12188541-Reviews-Zona_Archeologica_di_Palazzolo-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	784	t
720	https://www.tripadvisor.it/Attraction_Review-g2205532-d12211276-Reviews-Diga_Poligonale-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	785	t
721	https://www.tripadvisor.it/Attraction_Review-g2205532-d12234190-Reviews-Palazzo_Celestini-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	786	t
722	https://www.tripadvisor.it/Attraction_Review-g2205532-d6688028-Reviews-Castello_di_Vasanello-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	787	t
723	Castello di Vasanello\n@castellodivasanello	facebook	54	787	t
724	http://www.castellodivasanello.it	website	54	787	t
725	https://www.tripadvisor.it/Attraction_Review-g2205532-d8779197-Reviews-Chiesa_di_San_Salvatore-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	788	t
726	https://www.tripadvisor.it/Attraction_Review-g2205532-d12206835-Reviews-Cella_di_Santa_Rosa-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	789	t
727	https://www.tripadvisor.it/Attraction_Review-g2205532-d12187621-Reviews-Necropoli_dei_Morticelli-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	791	t
728	https://www.tripadvisor.it/Attraction_Review-g2205532-d12255297-Reviews-Chiesa_della_Madonna_della_Stella-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	792	t
729	https://www.tripadvisor.it/Attraction_Review-g2205532-d12187637-Reviews-La_Torricella-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	793	t
730	https://www.tripadvisor.it/Attraction_Review-g2205532-d12246170-Reviews-Cappella_di_San_Lanno-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	796	t
731	https://www.tripadvisor.it/Attraction_Review-g2205532-d12219974-Reviews-Museo_della_Ceramica-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	797	t
732	https://www.tripadvisor.it/Attraction_Review-g2205532-d12215991-Reviews-Madonna_delle_Grazie-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	799	t
733	https://www.tripadvisor.it/Attraction_Review-g2205532-d7062200-Reviews-Chiesa_di_Santa_Maria_Assunta-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	804	t
734	https://www.tripadvisor.it/Attraction_Review-g2205532-d12187521-Reviews-Fornace_Aretina-Vasanello_Province_of_Viterbo_Lazio.html	tripadvisor	54	805	t
735	https://www.tripadvisor.it/Attraction_Review-g2153932-d15011165-Reviews-Chiesa_Santa_Maria_Assunta-Vejano_Province_of_Viterbo_Lazio.html	tripadvisor	55	807	t
736	Biblioteca comunale di Vejano	facebook	55	29	t
737	https://www.tripadvisor.it/Attraction_Review-g2153932-d10746722-Reviews-Castello_di_Vejano-Vejano_Province_of_Viterbo_Lazio.html	tripadvisor	55	810	t
738	La Rocca - Vejano - Viterbo	facebook	55	810	t
739	https://www.tripadvisor.it/Attraction_Review-g673503-d10805156-Reviews-Chiesa_di_San_Francesco-Vetralla_Province_of_Viterbo_Lazio.html	tripadvisor	56	110	t
740	https://5d557c7adaed7.site123.me/	website	56	110	t
741	https://www.tripadvisor.it/Attraction_Review-g673503-d3212788-Reviews-Necropoli_di_Norchia-Vetralla_Province_of_Viterbo_Lazio.html	tripadvisor	56	812	t
742	Biblioteca Comunale Vetralla "Alessandro Pistella"\n@BibliotecaComunaleVetralla  	facebook	56	813	t
743	http://www.vetrallaonline.com/vetralla/biblioteca.htm	website	56	813	t
744	https://www.tripadvisor.it/Attraction_Review-g673503-d23506186-Reviews-Museo_Della_Citta_e_Del_Territorio-Vetralla_Province_of_Viterbo_Lazio.html	tripadvisor	56	814	t
745	Museo_della_città_e_del_territorio_(Vetralla)	wikipedia	56	814	t
746	Museo della Città e del Territorio di Vetralla\n@museodellacittaedelterritoriovetralla  · Museo	facebook	56	814	t
747	museodellacittaedelterritorio	instagram	56	814	t
748	http://www.ghaleb.it/Museo.htm	website	56	814	t
749	https://www.tripadvisor.it/Attraction_Review-g673503-d23817963-Reviews-Chiesa_Parrocchiale_di_S_Maria_del_Soccorso-Vetralla_Province_of_Viterbo_Lazio.html	tripadvisor	56	815	t
750	https://www.tripadvisor.it/Attraction_Review-g673503-d10805183-Reviews-Palazzo_Comunale_di_Vetralla-Vetralla_Province_of_Viterbo_Lazio.html	tripadvisor	56	816	t
751	https://www.tripadvisor.it/Attraction_Review-g673503-d11899147-Reviews-Tempio_di_Demetra-Vetralla_Province_of_Viterbo_Lazio.html	tripadvisor	56	817	t
752	https://www.tripadvisor.it/Attraction_Review-g673503-d6995898-Reviews-Grotte_Porcine-Vetralla_Province_of_Viterbo_Lazio.html	tripadvisor	56	821	t
753	https://www.tripadvisor.it/Attraction_Review-g673503-d10805179-Reviews-Palazzo_Franciosoni-Vetralla_Province_of_Viterbo_Lazio.html	tripadvisor	56	823	t
754	https://www.castellovinci.it/	website	56	824	t
755	https://www.tripadvisor.it/Attraction_Review-g673503-d10910925-Reviews-Duomo_di_Vetralla-Vetralla_Province_of_Viterbo_Lazio.html	tripadvisor	56	826	t
756	https://www.tripadvisor.it/Attraction_Review-g1483661-d12914851-Reviews-Biblioteca_Comunale-Vignanello_Province_of_Viterbo_Lazio.html	tripadvisor	57	29	t
757	Biblioteca Comunale Di Vignanello\n@bibliotecacomunale.divignanello  · Istruzione	facebook	57	29	t
758	https://www.tripadvisor.it/Attraction_Review-g1483661-d12914874-Reviews-I_Connutti-Vignanello_Province_of_Viterbo_Lazio.html	tripadvisor	57	828	t
759	http://www.iconnutti.org/	website	57	828	t
760	https://www.tripadvisor.it/Attraction_Review-g1483661-d12914844-Reviews-Chiesa_di_San_Sebastiano_Martire_di_Vignanello-Vignanello_Province_of_Viterbo_L.html	tripadvisor	57	829	t
761	https://www.tripadvisor.it/Attraction_Review-g1483661-d12914690-Reviews-Chiesa_della_Madonna_del_Pianto-Vignanello_Province_of_Viterbo_Lazio.html	tripadvisor	57	830	t
762	https://www.tripadvisor.it/Attraction_Review-g1483661-d12914873-Reviews-Porta_del_Vignola-Vignanello_Province_of_Viterbo_Lazio.html	tripadvisor	57	831	t
763	https://www.tripadvisor.it/Attraction_Review-g1483661-d4949402-Reviews-Castello_Ruspoli-Vignanello_Province_of_Viterbo_Lazio.html	tripadvisor	57	832	t
764	Castello_Ruspoli	wikipedia	57	832	t
765	Castello Ruspoli\n@castelloruspoli 	facebook	57	832	t
766	castelloruspoli	instagram	57	832	t
767	https://castelloruspoli.com/	website	57	832	t
768	https://www.tripadvisor.it/Attraction_Review-g1483661-d12914849-Reviews-Chiesa_di_San_Giovanni_Decollato-Vignanello_Province_of_Viterbo_Lazio.html	tripadvisor	57	833	t
769	https://www.tripadvisor.it/Attraction_Review-g1483661-d12914847-Reviews-Chiesa_Collegiata_Santa_Maria_della_Presentazione-Vignanello_Province_of_Viterb.html	tripadvisor	57	834	t
770	Parrocchia di Vignanello - S.Maria della Presentazione\n@parrocchiadivignanello	facebook	57	834	t
771	https://www.tripadvisor.it/Attraction_Review-g1483661-d12914832-Reviews-Fontana_Barocca-Vignanello_Province_of_Viterbo_Lazio.html	tripadvisor	57	835	t
772	https://www.tripadvisor.it/Attraction_Review-g194950-d6367213-Reviews-Necropoli_Etrusca_di_Castel_d_Asso-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	837	t
773	https://www.tripadvisor.it/Attraction_Review-g194950-d14197667-Reviews-Fontana_al_Paracadutista_d_Italia-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	838	t
774	https://www.tripadvisor.it/Attraction_Review-g194950-d23172077-Reviews-Chiesa_Di_S_pellegrino-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	839	t
775	https://www.tripadvisor.it/Attraction_Review-g194950-d14197268-Reviews-Prato_Giardino-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	840	t
776	Parco giochi Pratogiardino	facebook	58	840	t
777	https://www.tripadvisor.it/Attraction_Review-g194950-d14197257-Reviews-Torre_del_Borgognone-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	841	t
778	https://www.tripadvisor.it/Attraction_Review-g194950-d16959078-Reviews-Mura_medievali-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	842	t
779	https://www.tripadvisor.it/Attraction_Review-g194950-d10068140-Reviews-Fontana_Grande-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	383	t
780	https://www.tripadvisor.it/Attraction_Review-g194950-d8861446-Reviews-Chiesa_della_Santissima_Trinita-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	714	t
781	Parrocchia SS. Trinità, Viterbo, Santuario Maria Santissima Liberatrice	facebook	58	714	t
782	https://www.tripadvisor.it/Attraction_Review-g194950-d14197815-Reviews-Piazza_della_Morte-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	845	t
783	www.museotaruffi.it	website	58	846	t
784	https://www.tripadvisor.it/Attraction_Review-g194950-d14197254-Reviews-Piazza_del_Gesu-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	847	t
785	https://www.tripadvisor.it/Attraction_Review-g194950-d7597839-Reviews-Castello_di_Montecalvello-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	848	t
786	https://www.tripadvisor.it/Attraction_Review-g194950-d13218366-Reviews-Porta_San_Marco-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	849	t
787	https://www.tripadvisor.it/Attraction_Review-g194950-d12035860-Reviews-Chiesa_di_Santa_Maria_della_Verita-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	850	t
788	Chiesa_di_Santa_Maria_della_Verità_(Viterbo)	wikipedia	58	850	t
789	https://www.tripadvisor.it/Attraction_Review-g194950-d14197252-Reviews-Chiesa_di_San_Silvestro-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	519	t
790	Chiesa_di_San_Silvestro_(Viterbo)	wikipedia	58	519	t
791	https://www.tripadvisor.it/Attraction_Review-g194950-d19746295-Reviews-Mura_Etrusche-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	852	t
792	https://www.tripadvisor.it/Attraction_Review-g194950-d14197235-Reviews-Piazza_dell_Erbe-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	853	t
793	https://www.tripadvisor.it/Attraction_Review-g194950-d12843632-Reviews-Cascate_Dell_Acquarossa-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	854	t
794	https://www.tripadvisor.it/Attraction_Review-g194950-d14197260-Reviews-Casa_Poscia-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	855	t
795	https://www.tripadvisor.it/Attraction_Review-g194950-d13218356-Reviews-Porta_della_Verita-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	856	t
796	https://www.tripadvisor.it/Attraction_Review-g194950-d10154850-Reviews-Chiesa_di_Sant_Angelo_in_Spatha-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	857	t
797	Chiesa_di_Sant'Angelo_in_Spatha	wikipedia	58	857	t
798	https://www.tripadvisor.it/Attraction_Review-g194950-d1654065-Reviews-Via_Francigena_della_Tuscia-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	859	t
799	https://www.tripadvisor.it/Attraction_Review-g194950-d6966034-Reviews-Museo_Roberto_Joppolo-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	860	t
800	http://www.robertojoppolo.com/	website	58	860	t
801	https://www.tripadvisor.it/Attraction_Review-g194950-d10154838-Reviews-Piazza_del_Plebiscito-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	861	t
802	https://www.tripadvisor.it/Attraction_Review-g194950-d11899129-Reviews-Chiesa_di_Sant_Andrea-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	862	t
803	https://www.tripadvisor.it/Attraction_Review-g194950-d4453172-Reviews-Cascate_della_Mola-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	863	t
804	https://www.tripadvisor.it/Attraction_Review-g194950-d3838075-Reviews-Basilica_Santuario_Santa_Maria_della_Quercia-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	864	t
805	Basilica_of_Santa_Maria_della_Quercia,_Viterbo	wikipedia	58	864	t
806	Parrocchia Basilica Santuario Santa Maria della Quercia - Viterbo\n@madonnadellaquercia	facebook	58	864	t
807	http://www.madonnadellaquercia.it/	website	58	864	t
808	https://www.tripadvisor.it/Attraction_Review-g194950-d7179533-Reviews-Chiesa_di_Santa_Maria_della_Salute-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	865	t
809	https://www.tripadvisor.it/Attraction_Review-g194950-d23172096-Reviews-Piazza_S_Pellegrino-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	866	t
810	https://www.tripadvisor.it/Attraction_Review-g194950-d8566732-Reviews-Area_Archeologica_di_Ferento-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	867	t
811	https://www.archeotuscia.com/	website	58	867	t
812	https://www.tripadvisor.it/Attraction_Review-g194950-d18963799-Reviews-Chiesa_di_Santa_Maria_del_Paradiso-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	868	t
813	Parrocchia di Santa Maria del Paradiso e Santa Maria dell'Edera	facebook	58	868	t
814	https://www.santamariadelparadiso.it/	website	58	868	t
815	https://www.tripadvisor.it/Attraction_Review-g194950-d14197671-Reviews-Chiesa_San_Giovanni_Battista_degli_Almadiani-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	869	t
816	https://www.tripadvisor.it/Attraction_Review-g194950-d19610309-Reviews-Chiesa_di_Santa_Giacinta_Marescotti-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	871	t
817	https://www.tripadvisor.it/Attraction_Review-g1472371-d14197922-Reviews-Piazza_XX_Settembre-Bagnaia_Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	872	t
818	https://www.tripadvisor.it/Attraction_Review-g194950-d14214324-Reviews-Palazzo_di_Donna_Olimpia-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	873	t
819	https://www.tripadvisor.it/Attraction_Review-g194950-d19588603-Reviews-Palazzo_Gatti-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	874	t
820	https://www.tripadvisor.it/Attraction_Review-g194950-d13218351-Reviews-Convento_dei_Cappuccini-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	875	t
821	Frati Cappuccini Viterbo - Capuchins of Viterbo\n@fraticappucciniviterbo	facebook	58	875	t
822	https://www.tripadvisor.it/Attraction_Review-g194950-d11826678-Reviews-Palazzo_di_Valentino_della_Pagnotta-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	877	t
823	https://www.tripadvisor.it/Attraction_Review-g194950-d14197748-Reviews-Fontana_del_Piano-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	878	t
824	www.unitus.it  www.sma.unitus.it	website	58	879	t
825	https://www.tripadvisor.it/Attraction_Review-g194950-d8037556-Reviews-Cattedrale_di_San_Lorenzo-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	881	t
826	Duomo_di_Viterbo	wikipedia	58	881	t
827	https://www.tripadvisor.it/Attraction_Review-g1472371-d16800570-Reviews-Chiesa_di_Santa_Maria_della_Porta-Bagnaia_Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	883	t
828	Ferento	wikipedia	58	884	t
829	Ferento Teatro Romano\n@teatroferento	facebook	58	884	t
830	https://www.tripadvisor.it/Attraction_Review-g1472371-d16800563-Reviews-Torre_dell_Orologio-Bagnaia_Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	92	t
831	https://www.tripadvisor.it/Attraction_Review-g1472371-d13804096-Reviews-Chiesa_della_Madonna_del_Rosario-Bagnaia_Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	887	t
832	https://www.tripadvisor.it/Attraction_Review-g1472371-d17415932-Reviews-Fontana_Dei_Fiumi-Bagnaia_Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	888	t
833	https://www.tripadvisor.it/Attraction_Review-g1472371-d16800823-Reviews-Fontana_del_Pegaso-Bagnaia_Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	890	t
834	https://www.tripadvisor.it/Attraction_Review-g194950-d8869796-Reviews-Chiesa_di_S_Giovanni_Battista_del_Gonfalone-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	891	t
835	Chiesa San Giovanni Battista del Gonfalone\n@gonfaloneviterbo 	facebook	58	891	t
836	https://www.tripadvisor.it/Attraction_Review-g194950-d2385548-Reviews-Museo_del_Sodalizio-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	892	t
837	Museo_del_sodalizio_dei_facchini_di_santa_Rosa	wikipedia	58	892	t
838	Sodalizio dei Facchini di Santa Rosa\n@facchinidisantarosa	facebook	58	892	t
839	https://www.tripadvisor.it/Attraction_Review-g194950-d8810414-Reviews-Tenuta_La_Pazzaglia-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	893	t
840	https://www.tripadvisor.it/Attraction_Review-g194950-d11912095-Reviews-Archivio_di_Stato-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	894	t
841	Archivio di Stato di Viterbo\n@ASViterbo  · Servizi pubblici e governativi	facebook	58	894	t
842	https://www.tripadvisor.it/Attraction_Review-g194950-d10631675-Reviews-Monastero_Di_Santa_Rosa-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	896	t
843	https://www.tripadvisor.it/Attraction_Review-g194950-d7697211-Reviews-Palazzo_dei_Priori-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	700	t
844	https://www.tripadvisor.it/Attraction_Review-g194950-d13385560-Reviews-Teatro_dell_Unione-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	898	t
845	Teatro_Unione	wikipedia	58	898	t
846	Teatro dell'Unione\n@teatrounioneviterbo  · Teatro di performance d'arte	facebook	58	898	t
847	http://www.teatrounioneviterbo.it/	website	58	898	t
848	https://www.tripadvisor.it/Attraction_Review-g1472371-d16800797-Reviews-Fontana_dei_Mori-Bagnaia_Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	899	t
849	https://www.tripadvisor.it/Attraction_Review-g194950-d14203320-Reviews-Cascata_dell_Infernaccio-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	900	t
850	Cascata_dell%27Infernaccio	wikipedia	58	900	t
851	https://www.tripadvisor.it/Attraction_Review-g194950-d10895124-Reviews-Porta_Romana-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	76	t
852	https://www.tripadvisor.it/Attraction_Review-g194950-d21176596-Reviews-Museo_Storico_Didattico_Cavalieri_Templari_di_Viterbo-Viterbo_Province_of_Viterb.html	tripadvisor	58	902	t
853	Museo Storico Didattico dei “Cavalieri Templari” di Viterbo\n@museotemplariviterbo  · Sito web relativo al settore dell'istruzione	facebook	58	902	t
854	museotemplariviterbo	instagram	58	902	t
855	http://www.museotemplareviterbo.it/	website	58	902	t
856	Centro Diocesano di Documentazione Viterbo\n@CentroDiocesanodiDocumentazioneViterbo	facebook	58	903	t
857	https://www.tripadvisor.it/Attraction_Review-g1486825-d13908573-Reviews-Chiesa_Parrocchiale_di_Santo_Stefano-Grotte_Santo_Stefano_Viterbo_Province_of_V.html	tripadvisor	58	904	t
858	Relais Villa Rossi Danielli	facebook	58	905	t
859	relaisvillarossidanielli	instagram	58	905	t
860	https://www.relaisdivillarossidanielli.com/	website	58	905	t
861	https://www.tripadvisor.it/Attraction_Review-g194950-d4091723-Reviews-Viterbo_Historic_Centre-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	906	t
862	https://www.tripadvisor.it/Attraction_Review-g194950-d9709921-Reviews-Galleria_Chigi-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	907	t
863	https://www.tripadvisor.it/Attraction_Review-g194950-d3398032-Reviews-Museo_Nazionale_Etrusco_di_Viterbo-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	909	t
864	Museo_nazionale_etrusco_Rocca_Albornoz	wikipedia	58	909	t
865	Museo Archeologico Nazionale Etrusco Rocca Albornoz\n@museoetruscoviterbo	facebook	58	909	t
866	www.etruriameridionale.beniculturali.it	website	58	909	t
867	https://www.tripadvisor.it/Attraction_Review-g194950-d7596096-Reviews-Museo_Civico_di_Viterbo-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	911	t
868	Museo_civico_(Viterbo)	wikipedia	58	911	t
869	www.comuneviterbo.it link museocivico	website	58	911	t
870	https://www.tripadvisor.it/Attraction_Review-g194950-d3845914-Reviews-Museo_Colle_del_Duomo-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	912	t
871	Museo_del_Colle_del_Duomo	wikipedia	58	912	t
872	Polo monumentale Colle del Duomo\n@colledelduomoviterbo	facebook	58	912	t
873	www.museocolledelduomo.it	website	58	912	t
874	https://www.tripadvisor.it/Attraction_Review-g194950-d4817220-Reviews-Museo_della_Ceramica_della_Tuscia-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	913	t
875	Museo della Ceramica della Tuscia	wikipedia	58	913	t
876	www.museodellaceramicadellatuscia.com	website	58	913	t
877	https://www.tripadvisor.it/Attraction_Review-g1472371-d246595-Reviews-Villa_Lante-Bagnaia_Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	914	t
878	Villa_Lante_(Bagnaia)	wikipedia	58	914	t
879	Villa Lante a Bagnaia\n@VillaLante	facebook	58	914	t
881	https://www.tripadvisor.it/Attraction_Review-g194950-d6652852-Reviews-Orto_Botanico_dell_Universita_della_Tuscia-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	925	t
882	Orto_botanico_dell'Università_della_Tuscia	wikipedia	58	925	t
886	https://www.tripadvisor.it/Attraction_Review-g194950-d3483180-Reviews-Terme_Libere_Piscine_Carletti-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	933	t
887	https://www.tripadvisor.it/Attraction_Review-g194950-d19637624-Reviews-Chiesa_di_Santa_Maria_del_Suffragio-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	936	t
888	Chiesa_di_Santa_Maria_del_Suffragio_(Viterbo)	wikipedia	58	936	t
889	https://www.tripadvisor.it/Attraction_Review-g194950-d10067976-Reviews-Chiesa_dei_Santi_Faustino_e_Giovita-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	937	t
890	https://www.tripadvisor.it/Attraction_Review-g194950-d10825866-Reviews-Chiesa_di_San_Giovanni_in_Zoccoli-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	938	t
891	https://www.tripadvisor.it/Attraction_Review-g194950-d10182656-Reviews-Chiesa_di_Santa_Maria_in_Gradi-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	939	t
892	https://www.tripadvisor.it/Attraction_Review-g194950-d10067708-Reviews-Porta_Fiorentina-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	940	t
893	https://www.tripadvisor.it/Attraction_Review-g194950-d9454019-Reviews-Chiesa_di_Santa_Maria_Nuova-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	941	t
894	Chiesa_di_Santa_Maria_Nuova_(Viterbo)	wikipedia	58	941	t
895	Parrocchia Santa Maria Nuova viterbo\n@santamarianuovaviterbo	facebook	58	941	t
896	http://www.santamarianuova-viterbo.it/	website	58	941	t
897	https://www.tripadvisor.it/Attraction_Review-g194950-d8866434-Reviews-Chiesa_di_San_Sisto-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	942	t
898	Chiesa_di_San_Sisto_(Viterbo)	wikipedia	58	942	t
899	Biblioteca Consorziale Di Viterbo\n@biblioteca.viterbo 	facebook	58	943	t
900	Biblioteca Viterbo\n@BibliotecaVT	twitter	58	943	t
901	https://www.tripadvisor.it/Attraction_Review-g1472371-d16800575-Reviews-Fontana_del_Borgo_Dentro-Bagnaia_Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	944	t
902	https://www.tripadvisor.it/Attraction_Review-g194950-d21388858-Reviews-Chiesa_Della_Visitazione_o_Della_Duchessa-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	946	t
903	https://www.tripadvisor.it/Attraction_Review-g194950-d3875332-Reviews-Palazzo_dei_Papi-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	948	t
904	Palazzo_dei_Papi_(Viterbo)	wikipedia	58	948	t
905	www.abbaziasanmartinoalcimino.it	website	58	949	t
906	https://www.tripadvisor.it/Attraction_Review-g194950-d3616883-Reviews-Viterbo_Underground-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	950	t
907	Viterbo Sotterranea Tesori d'Etruria\n@TesoridiEtruria  	facebook	58	950	t
908	https://tesoridietruria.it/	website	58	950	t
909	http://www.biblioteche.unitus.it	website	58	956	t
910	ABAV Accademia di Belle Arti Lorenzo da Viterbo\n@ABAV.Viterbo	facebook	58	957	t
911	abav_viterbo	instagram	58	957	t
912	Abav Viterbo\n@AbavAccademia	twitter	58	957	t
913	http://www.biblioteche.unitus.it/	website	58	962	t
914	https://www.tripadvisor.it/Attraction_Review-g194950-d10068199-Reviews-Quartiere_San_Pellegrino-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	963	t
915	Quartiere_San_Pellegrino	wikipedia	58	963	t
916	http://www.biblioteche.unitus.it/	website	58	964	t
917	http://www.biblioteche.unitus.it/	website	58	965	t
918	https://www.tripadvisor.it/Attraction_Review-g194950-d18920701-Reviews-Basilica_di_San_Francesco_alla_Rocca-Viterbo_Province_of_Viterbo_Lazio.html	tripadvisor	58	966	t
919	Basilica_di_San_Francesco_alla_Rocca	wikipedia	58	966	t
920	https://www.tripadvisor.it/Attraction_Review-g1024146-d6276849-Reviews-Borgo_di_Vitorchiano-Vitorchiano_Province_of_Viterbo_Lazio.html	tripadvisor	59	968	t
921	https://www.tripadvisor.it/Attraction_Review-g1024146-d12987640-Reviews-Palazzo_Comunale_di_Vitorchiano-Vitorchiano_Province_of_Viterbo_Lazio.html	tripadvisor	59	969	t
922	https://www.tripadvisor.it/Attraction_Review-g1024146-d8004621-Reviews-Chiesa_Santa_Maria_Assunta_in_Cielo-Vitorchiano_Province_of_Viterbo_Lazio.html	tripadvisor	59	970	t
923	Santa_Maria_Assunta_in_Cielo,_Vitorchiano	wikipedia	59	970	t
924	Parrocchia S. Maria Assunta in cielo, Vitorchiano VT\n@ParrocchiaS.MariaAssuntaVitorchiano  · Organizzazione religiosa	facebook	59	970	t
925	https://www.parrocchiavitorchiano.it/	website	59	970	t
926	https://www.tripadvisor.it/Attraction_Review-g1024146-d5485096-Reviews-Statua_Moai-Vitorchiano_Province_of_Viterbo_Lazio.html	tripadvisor	59	971	t
927	https://www.tripadvisor.it/Attraction_Review-g1024146-d8004767-Reviews-Chiesa_della_Santissima_Trinita-Vitorchiano_Province_of_Viterbo_Lazio.html	tripadvisor	59	714	t
928	https://www.tripadvisor.it/Attraction_Review-g1024146-d21230855-Reviews-Fontana_a_Fuso-Vitorchiano_Province_of_Viterbo_Lazio.html	tripadvisor	59	973	t
929	https://www.tripadvisor.it/Attraction_Review-g1024146-d21228351-Reviews-Piazzale_Umberto_I-Vitorchiano_Province_of_Viterbo_Lazio.html	tripadvisor	59	974	t
930	https://www.tripadvisor.it/Attraction_Review-g1024146-d3225953-Reviews-Moutan_Botanical_Center-Vitorchiano_Province_of_Viterbo_Lazio.html	tripadvisor	59	975	t
931	Centro Botanico Moutan\n@centrobotanicomouta	facebook	59	975	t
932	centrobotanicomoutan	instagram	59	975	t
933	https://www.centrobotanicomoutan.it/#	website	59	975	t
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tag (tag_id, tag, si_id, is_active) FROM stdin;
\.


--
-- Data for Name: user_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_account (user_id, email, password, age, gender, disability, is_active) FROM stdin;
1	admin	admin	25	M	1	t
\.


--
-- Data for Name: user_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_tag (ut_id, user_id, tag_id, is_active) FROM stdin;
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 84, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, false);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: cities_city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cities_city_id_seq', 59, true);


--
-- Name: day_and_hours_dan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.day_and_hours_dan_id_seq', 7, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 21, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 25, true);


--
-- Name: images_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.images_image_id_seq', 1, false);


--
-- Name: poi_opening_hour_poh_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.poi_opening_hour_poh_id_seq', 1, false);


--
-- Name: poi_poi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.poi_poi_id_seq', 1040, true);


--
-- Name: provinces_province_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.provinces_province_id_seq', 1, true);


--
-- Name: regions_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.regions_region_id_seq', 1, true);


--
-- Name: social_interactions_si_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.social_interactions_si_id_seq', 1, false);


--
-- Name: tags_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tags_tag_id_seq', 1, false);


--
-- Name: user_tags_ut_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_tags_ut_id_seq', 1, false);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, true);


--
-- Name: webpage_or_social_wos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.webpage_or_social_wos_id_seq', 933, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: city cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city
    ADD CONSTRAINT cities_pkey PRIMARY KEY (city_id);


--
-- Name: day_and_hour day_and_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.day_and_hour
    ADD CONSTRAINT day_and_hours_pkey PRIMARY KEY (dah_id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: image images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT images_pkey PRIMARY KEY (image_id);


--
-- Name: place place_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place
    ADD CONSTRAINT place_pkey PRIMARY KEY (place_id);


--
-- Name: poi_opening_hour poi_opening_hour_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poi_opening_hour
    ADD CONSTRAINT poi_opening_hour_pkey PRIMARY KEY (poh_id);


--
-- Name: poi poi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poi
    ADD CONSTRAINT poi_pkey PRIMARY KEY (poi_id);


--
-- Name: province provinces_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.province
    ADD CONSTRAINT provinces_name_key UNIQUE (name);


--
-- Name: province provinces_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.province
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (province_id);


--
-- Name: region regions_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT regions_name_key UNIQUE (name);


--
-- Name: region regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT regions_pkey PRIMARY KEY (region_id);


--
-- Name: social_interaction social_interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.social_interaction
    ADD CONSTRAINT social_interactions_pkey PRIMARY KEY (si_id);


--
-- Name: tag tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tags_pkey PRIMARY KEY (tag_id);


--
-- Name: day_and_hour uniqueness; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.day_and_hour
    ADD CONSTRAINT uniqueness UNIQUE (poh_id, weekday, opening_hour, closing_hour);


--
-- Name: user_tag user_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tag
    ADD CONSTRAINT user_tags_pkey PRIMARY KEY (ut_id);


--
-- Name: user_account users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_account
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: user_account users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_account
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: social_media webpage_or_social_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.social_media
    ADD CONSTRAINT webpage_or_social_pkey PRIMARY KEY (sm_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: document_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX document_idx ON public.poi USING gin (document_with_idx);


--
-- Name: document_weights_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX document_weights_idx ON public.poi USING gin (document_with_weights);


--
-- Name: poi locationupdate; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER locationupdate BEFORE INSERT OR UPDATE ON public.poi FOR EACH ROW EXECUTE FUNCTION public.location_trigger();


--
-- Name: poi tsvectorupdate; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.poi FOR EACH ROW EXECUTE FUNCTION public.poi_tsvector_trigger();


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: poi fk_city; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poi
    ADD CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES public.city(city_id);


--
-- Name: social_media fk_city; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.social_media
    ADD CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES public.city(city_id);


--
-- Name: poi fk_poh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poi
    ADD CONSTRAINT fk_poh FOREIGN KEY (poh_id) REFERENCES public.poi_opening_hour(poh_id);


--
-- Name: day_and_hour fk_poh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.day_and_hour
    ADD CONSTRAINT fk_poh FOREIGN KEY (poh_id) REFERENCES public.poi_opening_hour(poh_id);


--
-- Name: social_media fk_poi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.social_media
    ADD CONSTRAINT fk_poi FOREIGN KEY (poi_id) REFERENCES public.poi(poi_id);


--
-- Name: social_interaction fk_poi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.social_interaction
    ADD CONSTRAINT fk_poi FOREIGN KEY (poi_id) REFERENCES public.poi(poi_id);


--
-- Name: image fk_poi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT fk_poi FOREIGN KEY (poi_id) REFERENCES public.poi(poi_id);


--
-- Name: city fk_province; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city
    ADD CONSTRAINT fk_province FOREIGN KEY (province_id) REFERENCES public.province(province_id);


--
-- Name: province fk_region; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.province
    ADD CONSTRAINT fk_region FOREIGN KEY (region_id) REFERENCES public.region(region_id);


--
-- Name: tag fk_si; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT fk_si FOREIGN KEY (si_id) REFERENCES public.social_interaction(si_id);


--
-- Name: user_tag fk_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tag
    ADD CONSTRAINT fk_tag_id FOREIGN KEY (tag_id) REFERENCES public.tag(tag_id);


--
-- Name: user_tag fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tag
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.user_account(user_id);


--
-- Name: social_interaction fk_wos; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.social_interaction
    ADD CONSTRAINT fk_wos FOREIGN KEY (wos_id) REFERENCES public.social_media(sm_id);


--
-- PostgreSQL database dump complete
--

