SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Ubuntu 15.1-1.pgdg20.04+1)
-- Dumped by pg_dump version 15.6 (Ubuntu 15.6-1.pgdg20.04+1)

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
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."audit_log_entries" ("instance_id", "id", "payload", "created_at", "ip_address") VALUES
	('00000000-0000-0000-0000-000000000000', '727b7cac-931b-40e8-90ca-2e865f50a05c', '{"action":"user_signedup","actor_id":"17d97dc9-d482-429e-985b-87d0ea7ec509","actor_username":"bob@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2024-05-30 20:31:42.268707+00', ''),
	('00000000-0000-0000-0000-000000000000', '37280232-3eea-4c9e-9b3b-36b8fab325bf', '{"action":"login","actor_id":"17d97dc9-d482-429e-985b-87d0ea7ec509","actor_username":"bob@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-30 20:31:42.272987+00', ''),
	('00000000-0000-0000-0000-000000000000', '271d82b9-1739-46ec-86c3-f0340a92d501', '{"action":"logout","actor_id":"17d97dc9-d482-429e-985b-87d0ea7ec509","actor_username":"bob@gmail.com","actor_via_sso":false,"log_type":"account"}', '2024-05-30 20:31:44.235012+00', ''),
	('00000000-0000-0000-0000-000000000000', '8f4fd8e2-6657-4f8c-8a6a-623a3b3ccabe', '{"action":"user_signedup","actor_id":"e587f4b6-31d4-46ae-9091-205d227813ee","actor_username":"karen@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2024-05-30 20:32:02.982476+00', ''),
	('00000000-0000-0000-0000-000000000000', '9239eeb5-6bc6-4f83-86bc-a0208173e929', '{"action":"login","actor_id":"e587f4b6-31d4-46ae-9091-205d227813ee","actor_username":"karen@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-30 20:32:02.985409+00', ''),
	('00000000-0000-0000-0000-000000000000', '3eec0523-3bbf-4de0-bf7b-a18bfcf91374', '{"action":"logout","actor_id":"e587f4b6-31d4-46ae-9091-205d227813ee","actor_username":"karen@gmail.com","actor_via_sso":false,"log_type":"account"}', '2024-05-30 20:32:08.290495+00', ''),
	('00000000-0000-0000-0000-000000000000', 'be7f49ea-36fe-43ae-adbc-394db2cb392c', '{"action":"user_signedup","actor_id":"3bdbb665-84b5-4d32-8135-7ed80548a059","actor_username":"alan@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2024-05-30 20:32:19.183911+00', ''),
	('00000000-0000-0000-0000-000000000000', '98e30fb5-074f-4ad8-8f90-059fb77d71ab', '{"action":"login","actor_id":"3bdbb665-84b5-4d32-8135-7ed80548a059","actor_username":"alan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-30 20:32:19.186685+00', ''),
	('00000000-0000-0000-0000-000000000000', '942820dc-396a-4bbb-9d9f-c49246c16e84', '{"action":"logout","actor_id":"3bdbb665-84b5-4d32-8135-7ed80548a059","actor_username":"alan@gmail.com","actor_via_sso":false,"log_type":"account"}', '2024-05-30 20:32:21.845325+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd7393aa2-15e9-46e3-b71f-1651cf9db94d', '{"action":"user_signedup","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2024-05-30 20:32:33.156724+00', ''),
	('00000000-0000-0000-0000-000000000000', '3096eeed-33af-4fce-83cd-18eef2033da8', '{"action":"login","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-30 20:32:33.159797+00', ''),
	('00000000-0000-0000-0000-000000000000', '24626086-a0d0-45e8-8e2e-7cf7beb2e93a', '{"action":"logout","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"account"}', '2024-05-30 20:32:36.298394+00', ''),
	('00000000-0000-0000-0000-000000000000', '001883a4-63af-450a-bbc5-652aeb6bd7d7', '{"action":"user_signedup","actor_id":"ef7bc947-fc26-47a9-b17a-5cf20ac1eb6b","actor_username":"kepler@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2024-05-30 20:32:46.654926+00', ''),
	('00000000-0000-0000-0000-000000000000', '131ee124-fdbe-4497-98d2-1f7ed15556e3', '{"action":"login","actor_id":"ef7bc947-fc26-47a9-b17a-5cf20ac1eb6b","actor_username":"kepler@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-30 20:32:46.657549+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a51fc523-3499-4042-aec3-294f8209a866', '{"action":"logout","actor_id":"ef7bc947-fc26-47a9-b17a-5cf20ac1eb6b","actor_username":"kepler@gmail.com","actor_via_sso":false,"log_type":"account"}', '2024-05-30 20:32:48.093063+00', ''),
	('00000000-0000-0000-0000-000000000000', '5481d2d1-74f2-4c06-b8d0-80d74e4bfec7', '{"action":"user_signedup","actor_id":"bb55a5f6-4541-48e6-96ac-27d79f36dda4","actor_username":"taylor@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2024-05-30 20:33:04.993162+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c3e357aa-9c6e-43fc-aef5-51561f9cadb5', '{"action":"login","actor_id":"bb55a5f6-4541-48e6-96ac-27d79f36dda4","actor_username":"taylor@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-30 20:33:04.99632+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a7c0de3b-a865-44e4-a143-c61c5ff25bac', '{"action":"logout","actor_id":"bb55a5f6-4541-48e6-96ac-27d79f36dda4","actor_username":"taylor@gmail.com","actor_via_sso":false,"log_type":"account"}', '2024-05-30 20:33:06.450474+00', ''),
	('00000000-0000-0000-0000-000000000000', '6a328994-7ecc-4566-989b-3d7d5244f73b', '{"action":"user_signedup","actor_id":"c3f43634-0da2-43c7-baa7-ed2fef81e85e","actor_username":"casey@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2024-05-30 20:33:16.942016+00', ''),
	('00000000-0000-0000-0000-000000000000', '9a2c79d5-e5d3-4a6a-834c-4bd766e6820a', '{"action":"login","actor_id":"c3f43634-0da2-43c7-baa7-ed2fef81e85e","actor_username":"casey@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-30 20:33:16.944978+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e21226fe-e971-48f1-b2b3-df684dc0f8f0', '{"action":"logout","actor_id":"c3f43634-0da2-43c7-baa7-ed2fef81e85e","actor_username":"casey@gmail.com","actor_via_sso":false,"log_type":"account"}', '2024-05-30 20:33:18.386314+00', ''),
	('00000000-0000-0000-0000-000000000000', '28d40cac-7b8f-44c8-bf2e-2a170e48b27a', '{"action":"user_signedup","actor_id":"0748d39e-6d05-451d-9ff1-6125e6dfaf87","actor_username":"katie@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2024-05-30 20:33:32.339759+00', ''),
	('00000000-0000-0000-0000-000000000000', '483e94d7-4f48-441d-aa0f-7631bd7c31e2', '{"action":"login","actor_id":"0748d39e-6d05-451d-9ff1-6125e6dfaf87","actor_username":"katie@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-30 20:33:32.34307+00', ''),
	('00000000-0000-0000-0000-000000000000', '33dc82c2-72ce-449d-b374-f6e2469243f7', '{"action":"logout","actor_id":"0748d39e-6d05-451d-9ff1-6125e6dfaf87","actor_username":"katie@gmail.com","actor_via_sso":false,"log_type":"account"}', '2024-05-30 20:33:34.315314+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c4cd217b-904b-4a75-958d-3025661e3c4c', '{"action":"user_signedup","actor_id":"98faf97b-6e9e-49db-89bf-3388a3b7b098","actor_username":"mittens@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2024-05-30 20:34:03.552718+00', ''),
	('00000000-0000-0000-0000-000000000000', '2f505ed3-07e2-49c8-a908-18f73c2d9256', '{"action":"login","actor_id":"98faf97b-6e9e-49db-89bf-3388a3b7b098","actor_username":"mittens@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-30 20:34:03.555533+00', ''),
	('00000000-0000-0000-0000-000000000000', '221541d0-e662-4e42-89f1-b9a7f5dc22f0', '{"action":"logout","actor_id":"98faf97b-6e9e-49db-89bf-3388a3b7b098","actor_username":"mittens@gmail.com","actor_via_sso":false,"log_type":"account"}', '2024-05-30 20:34:05.349026+00', ''),
	('00000000-0000-0000-0000-000000000000', '5c0b6276-b238-4757-bdcc-548b8639e82d', '{"action":"user_signedup","actor_id":"226e0026-bb1c-442e-8237-a5c328c0a9bc","actor_username":"whiskers@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2024-05-30 20:34:30.26434+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dde81813-eec9-4aef-b285-f28396e53a9f', '{"action":"login","actor_id":"226e0026-bb1c-442e-8237-a5c328c0a9bc","actor_username":"whiskers@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-30 20:34:30.267133+00', ''),
	('00000000-0000-0000-0000-000000000000', '0534f595-cb54-4802-849d-1992dc044808', '{"action":"logout","actor_id":"226e0026-bb1c-442e-8237-a5c328c0a9bc","actor_username":"whiskers@gmail.com","actor_via_sso":false,"log_type":"account"}', '2024-05-30 20:34:37.123586+00', ''),
	('00000000-0000-0000-0000-000000000000', '4ccbd7dd-5975-4566-974d-dffaa49df526', '{"action":"login","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-30 20:35:16.585323+00', ''),
	('00000000-0000-0000-0000-000000000000', '019e2204-3a79-4256-af9c-4554864d019d', '{"action":"logout","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"account"}', '2024-05-30 21:28:36.374145+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c83478a1-2d49-4eb7-9307-759818d6f3c4', '{"action":"login","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-30 21:28:47.582106+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f3bd7ce5-832e-4443-895e-0d5504be0bf5', '{"action":"token_refreshed","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-05-30 22:26:50.894218+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f84dc89e-b51f-4408-9aa0-f3ae4112d8ba', '{"action":"token_revoked","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-05-30 22:26:50.895918+00', ''),
	('00000000-0000-0000-0000-000000000000', '9d9226d8-a381-4a94-9719-02fbf06ae879', '{"action":"login","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-06-04 16:58:03.794121+00', ''),
	('00000000-0000-0000-0000-000000000000', 'acd363fa-934d-4c6a-a89c-609dc3ae1fe6', '{"action":"token_refreshed","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-04 17:56:26.654849+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ec018c88-1992-4432-8b1f-b1f60e2c3131', '{"action":"token_revoked","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-04 17:56:26.656298+00', ''),
	('00000000-0000-0000-0000-000000000000', '87434000-18c1-481f-b9cc-86f2df7f2d3c', '{"action":"token_refreshed","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-04 18:55:38.244947+00', ''),
	('00000000-0000-0000-0000-000000000000', '9233ac13-e640-493b-aa67-111ca754ec1e', '{"action":"token_revoked","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-04 18:55:38.246291+00', ''),
	('00000000-0000-0000-0000-000000000000', '209855e7-e08a-4fee-b1e7-4f69dc7c4ec6', '{"action":"token_refreshed","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-04 19:54:00.162711+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a559541e-9155-4618-a958-ea283e89e4e6', '{"action":"token_revoked","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-04 19:54:00.163862+00', ''),
	('00000000-0000-0000-0000-000000000000', '745a5360-2078-445c-be76-abcd250018b3', '{"action":"token_refreshed","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-04 20:52:27.903314+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c729a189-bba0-4fe6-9a73-d8072aa50f77', '{"action":"token_revoked","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-04 20:52:27.905011+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b465cf36-2d58-4c2b-8008-bdf1bdacf25c', '{"action":"token_refreshed","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-04 23:46:09.859194+00', ''),
	('00000000-0000-0000-0000-000000000000', '8cb0a9ba-dd17-40ba-8a83-a5c54703b7ea', '{"action":"token_revoked","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-04 23:46:09.860336+00', ''),
	('00000000-0000-0000-0000-000000000000', 'bf263c55-6354-420a-ae71-77c818e8bd18', '{"action":"logout","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"account"}', '2024-06-04 23:46:24.925722+00', ''),
	('00000000-0000-0000-0000-000000000000', '3a52ffb1-6d28-48f5-b722-e57c855746c8', '{"action":"login","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-06-04 23:46:33.940794+00', ''),
	('00000000-0000-0000-0000-000000000000', '358cf758-d3f2-441d-b232-a75f04cf7721', '{"action":"token_refreshed","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-05 04:13:18.868127+00', ''),
	('00000000-0000-0000-0000-000000000000', '0a892d2a-9c78-4549-9b3b-67f572d4f852', '{"action":"token_revoked","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-05 04:13:18.869114+00', ''),
	('00000000-0000-0000-0000-000000000000', '6f6851af-b651-44ea-936f-490cbbf371ac', '{"action":"token_refreshed","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-05 13:13:21.092947+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e63539c5-d4d9-4998-92ff-61e3a68114f9', '{"action":"token_revoked","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-05 13:13:21.093975+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e1c3194e-70a5-49d5-99ad-cf01dafc64b1', '{"action":"logout","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"account"}', '2024-06-05 13:13:26.784717+00', ''),
	('00000000-0000-0000-0000-000000000000', 'eeaf7925-92da-4e58-9dfa-c96bef985955', '{"action":"login","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-06-05 13:13:34.375874+00', ''),
	('00000000-0000-0000-0000-000000000000', '5bb5ef93-a2ed-443c-81b6-8de9e13ccff8', '{"action":"token_refreshed","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-05 14:12:11.466414+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd73cac25-abc9-4c30-a62a-75c1e687e6a6', '{"action":"token_revoked","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-05 14:12:11.467688+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f51b2e05-cc75-495f-a126-60178602b274', '{"action":"token_refreshed","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-05 15:15:17.054124+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dd7403cb-bfa4-4899-967a-b93075f60e2b', '{"action":"token_revoked","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-05 15:15:17.056624+00', ''),
	('00000000-0000-0000-0000-000000000000', '9be96d53-1b44-450c-be91-1dd3982f5099', '{"action":"token_refreshed","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-05 16:31:22.532306+00', ''),
	('00000000-0000-0000-0000-000000000000', '9a02e878-d34f-469d-a6db-1d8ee93980d3', '{"action":"token_revoked","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-05 16:31:22.533796+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b6b605ca-a13c-4323-b491-eb2a9237370f', '{"action":"token_refreshed","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-05 20:30:35.92563+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ce360954-65d6-47be-be6f-03813c78ce24', '{"action":"token_revoked","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-05 20:30:35.926993+00', ''),
	('00000000-0000-0000-0000-000000000000', '693b0d53-2629-42ec-85f1-962a5a08ff88', '{"action":"token_refreshed","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-08 02:27:29.518091+00', ''),
	('00000000-0000-0000-0000-000000000000', '5c3f533c-1f84-444d-8df5-1d9f99d4262f', '{"action":"token_revoked","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-06-08 02:27:29.531899+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ddacec77-cc3f-402b-bc00-bce7314fd6f7', '{"action":"login","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-06-08 02:32:31.689084+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e333a599-e861-4607-a56e-395a805925cf', '{"action":"login","actor_id":"c58deed9-5778-4d6a-b2b1-516dd1f9325b","actor_username":"louis@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-06-08 02:57:31.370465+00', '');


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', 'bb55a5f6-4541-48e6-96ac-27d79f36dda4', 'authenticated', 'authenticated', 'taylor@gmail.com', '$2a$10$JdrV4gwf0AM9B.ahY8GPDuakhHS2XEqyUfnWB/sDDKM/Cbo0fGi2q', '2024-05-30 20:33:04.993929+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-05-30 20:33:04.997013+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "bb55a5f6-4541-48e6-96ac-27d79f36dda4", "email": "taylor@gmail.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-30 20:33:04.986132+00', '2024-05-30 20:33:04.999067+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '17d97dc9-d482-429e-985b-87d0ea7ec509', 'authenticated', 'authenticated', 'bob@gmail.com', '$2a$10$HweOQHQvZl/i8ePyLovx/O7bkF9tjBT/yiEIqz8HCfpqo6eqXXRsm', '2024-05-30 20:31:42.269859+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-05-30 20:31:42.273682+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "17d97dc9-d482-429e-985b-87d0ea7ec509", "email": "bob@gmail.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-30 20:31:42.259582+00', '2024-05-30 20:31:42.276917+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '226e0026-bb1c-442e-8237-a5c328c0a9bc', 'authenticated', 'authenticated', 'whiskers@gmail.com', '$2a$10$v4vq/y0D2G2YwOjuIp6xtOAJt0ujWxWhLSbr3tgwPbdczn/i7Tere', '2024-05-30 20:34:30.264971+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-05-30 20:34:30.267819+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "226e0026-bb1c-442e-8237-a5c328c0a9bc", "email": "whiskers@gmail.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-30 20:34:30.258588+00', '2024-05-30 20:34:30.26983+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', 'e587f4b6-31d4-46ae-9091-205d227813ee', 'authenticated', 'authenticated', 'karen@gmail.com', '$2a$10$Aul6LBanD4I5JDBQWJ.ZOO6K7pXGHU9u1G198.LzwcOr3G5ENtv/q', '2024-05-30 20:32:02.983161+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-05-30 20:32:02.986058+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "e587f4b6-31d4-46ae-9091-205d227813ee", "email": "karen@gmail.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-30 20:32:02.975657+00', '2024-05-30 20:32:02.987783+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', 'ef7bc947-fc26-47a9-b17a-5cf20ac1eb6b', 'authenticated', 'authenticated', 'kepler@gmail.com', '$2a$10$ITUJKekdkuCY9zkugMqxWObTFQGDMo6s9YGvTVuFNPfL7iMyI5beK', '2024-05-30 20:32:46.655507+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-05-30 20:32:46.658134+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "ef7bc947-fc26-47a9-b17a-5cf20ac1eb6b", "email": "kepler@gmail.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-30 20:32:46.649983+00', '2024-05-30 20:32:46.659711+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', 'c3f43634-0da2-43c7-baa7-ed2fef81e85e', 'authenticated', 'authenticated', 'casey@gmail.com', '$2a$10$inhSeZAxEoFDyNsNNYJeIOT3MSU/bfECIED/T3T1PiGcRDDIkMoIW', '2024-05-30 20:33:16.942634+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-05-30 20:33:16.945712+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "c3f43634-0da2-43c7-baa7-ed2fef81e85e", "email": "casey@gmail.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-30 20:33:16.937532+00', '2024-05-30 20:33:16.947507+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '3bdbb665-84b5-4d32-8135-7ed80548a059', 'authenticated', 'authenticated', 'alan@gmail.com', '$2a$10$m.HJ8jg1tn11dn0vOrUuR.zFdDxEY7wJwIbjK5hGMxYF4P8vyfxZi', '2024-05-30 20:32:19.184544+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-05-30 20:32:19.187446+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "3bdbb665-84b5-4d32-8135-7ed80548a059", "email": "alan@gmail.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-30 20:32:19.179135+00', '2024-05-30 20:32:19.189235+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '98faf97b-6e9e-49db-89bf-3388a3b7b098', 'authenticated', 'authenticated', 'mittens@gmail.com', '$2a$10$THdVAZMZaGRSSRyGLW8KbeUM54ESOw/oDWexriY0QmQOUxABvTq6O', '2024-05-30 20:34:03.553308+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-05-30 20:34:03.556168+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "98faf97b-6e9e-49db-89bf-3388a3b7b098", "email": "mittens@gmail.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-30 20:34:03.546611+00', '2024-05-30 20:34:03.558028+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '0748d39e-6d05-451d-9ff1-6125e6dfaf87', 'authenticated', 'authenticated', 'katie@gmail.com', '$2a$10$gja4ItUkb2Arbp3DEeit.OFD1CsruWFbSAfVJgW/nyPeD2JnU6WYS', '2024-05-30 20:33:32.340527+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-05-30 20:33:32.344304+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "0748d39e-6d05-451d-9ff1-6125e6dfaf87", "email": "katie@gmail.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-30 20:33:32.334203+00', '2024-05-30 20:33:32.346959+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 'authenticated', 'authenticated', 'louis@gmail.com', '$2a$10$U2un/5Nn8aGh5keXWbe3lujRaBj0ltmIB6XgqdK9gYWw3T3qOCUFW', '2024-05-30 20:32:33.157523+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-06-08 02:57:31.37415+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "c58deed9-5778-4d6a-b2b1-516dd1f9325b", "email": "louis@gmail.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-30 20:32:33.148298+00', '2024-06-08 02:57:31.381194+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('17d97dc9-d482-429e-985b-87d0ea7ec509', '17d97dc9-d482-429e-985b-87d0ea7ec509', '{"sub": "17d97dc9-d482-429e-985b-87d0ea7ec509", "email": "bob@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2024-05-30 20:31:42.265132+00', '2024-05-30 20:31:42.26516+00', '2024-05-30 20:31:42.26516+00', '0e0af308-80cc-46e6-8c9e-16d076faa48d'),
	('e587f4b6-31d4-46ae-9091-205d227813ee', 'e587f4b6-31d4-46ae-9091-205d227813ee', '{"sub": "e587f4b6-31d4-46ae-9091-205d227813ee", "email": "karen@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2024-05-30 20:32:02.980138+00', '2024-05-30 20:32:02.980166+00', '2024-05-30 20:32:02.980166+00', 'a7a4c934-9aa3-4596-92a0-1d3ee6419b1c'),
	('3bdbb665-84b5-4d32-8135-7ed80548a059', '3bdbb665-84b5-4d32-8135-7ed80548a059', '{"sub": "3bdbb665-84b5-4d32-8135-7ed80548a059", "email": "alan@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2024-05-30 20:32:19.18168+00', '2024-05-30 20:32:19.181946+00', '2024-05-30 20:32:19.181946+00', '07f78eed-e58d-467d-b012-106cebeb9076'),
	('c58deed9-5778-4d6a-b2b1-516dd1f9325b', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', '{"sub": "c58deed9-5778-4d6a-b2b1-516dd1f9325b", "email": "louis@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2024-05-30 20:32:33.152121+00', '2024-05-30 20:32:33.152168+00', '2024-05-30 20:32:33.152168+00', '68f17603-6f18-4add-9ef1-8ee728f080e5'),
	('ef7bc947-fc26-47a9-b17a-5cf20ac1eb6b', 'ef7bc947-fc26-47a9-b17a-5cf20ac1eb6b', '{"sub": "ef7bc947-fc26-47a9-b17a-5cf20ac1eb6b", "email": "kepler@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2024-05-30 20:32:46.65274+00', '2024-05-30 20:32:46.652767+00', '2024-05-30 20:32:46.652767+00', 'da927988-d80a-4a61-bf28-8be30118ad87'),
	('bb55a5f6-4541-48e6-96ac-27d79f36dda4', 'bb55a5f6-4541-48e6-96ac-27d79f36dda4', '{"sub": "bb55a5f6-4541-48e6-96ac-27d79f36dda4", "email": "taylor@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2024-05-30 20:33:04.990649+00', '2024-05-30 20:33:04.990707+00', '2024-05-30 20:33:04.990707+00', '38caede4-6d0c-46df-b755-e026374642dd'),
	('c3f43634-0da2-43c7-baa7-ed2fef81e85e', 'c3f43634-0da2-43c7-baa7-ed2fef81e85e', '{"sub": "c3f43634-0da2-43c7-baa7-ed2fef81e85e", "email": "casey@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2024-05-30 20:33:16.939902+00', '2024-05-30 20:33:16.93993+00', '2024-05-30 20:33:16.93993+00', 'd2f1639a-18f5-4475-85d2-60321dc55a6e'),
	('0748d39e-6d05-451d-9ff1-6125e6dfaf87', '0748d39e-6d05-451d-9ff1-6125e6dfaf87', '{"sub": "0748d39e-6d05-451d-9ff1-6125e6dfaf87", "email": "katie@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2024-05-30 20:33:32.337439+00', '2024-05-30 20:33:32.337488+00', '2024-05-30 20:33:32.337488+00', '92cb1f0c-c3d4-446f-8019-ff18b7544afa'),
	('98faf97b-6e9e-49db-89bf-3388a3b7b098', '98faf97b-6e9e-49db-89bf-3388a3b7b098', '{"sub": "98faf97b-6e9e-49db-89bf-3388a3b7b098", "email": "mittens@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2024-05-30 20:34:03.550593+00', '2024-05-30 20:34:03.550624+00', '2024-05-30 20:34:03.550624+00', '591e1c9d-4c7b-4da5-9e9f-9b1548000d70'),
	('226e0026-bb1c-442e-8237-a5c328c0a9bc', '226e0026-bb1c-442e-8237-a5c328c0a9bc', '{"sub": "226e0026-bb1c-442e-8237-a5c328c0a9bc", "email": "whiskers@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2024-05-30 20:34:30.262038+00', '2024-05-30 20:34:30.262092+00', '2024-05-30 20:34:30.262092+00', '84c127bf-18e1-4255-b40b-528eae125caf');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag") VALUES
	('6d558919-c323-4870-90e8-c82dcb5e4c36', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', '2024-06-05 13:13:34.377036+00', '2024-06-08 02:27:29.541602+00', NULL, 'aal1', NULL, '2024-06-08 02:27:29.541573', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', '192.168.65.1', NULL),
	('0700dd16-9375-4651-adb4-873744a714be', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', '2024-06-08 02:32:31.690409+00', '2024-06-08 02:32:31.690409+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', '192.168.65.1', NULL),
	('3f0e8e46-5133-4dc2-8a8a-3497044ac5ed', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', '2024-06-08 02:57:31.374191+00', '2024-06-08 02:57:31.374191+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', '192.168.65.1', NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") VALUES
	('6d558919-c323-4870-90e8-c82dcb5e4c36', '2024-06-05 13:13:34.379063+00', '2024-06-05 13:13:34.379063+00', 'password', 'ccee2367-9091-4c07-9fce-da3889551d4d'),
	('0700dd16-9375-4651-adb4-873744a714be', '2024-06-08 02:32:31.693145+00', '2024-06-08 02:32:31.693145+00', 'password', '6477b934-8249-46b5-a9d9-386afeff6241'),
	('3f0e8e46-5133-4dc2-8a8a-3497044ac5ed', '2024-06-08 02:57:31.381592+00', '2024-06-08 02:57:31.381592+00', 'password', '204a3c3c-ec0b-4bb3-884f-cd1e4fb50985');


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") VALUES
	('00000000-0000-0000-0000-000000000000', 23, 'DQiaoj0fRBiD-erdMzgIog', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', true, '2024-06-05 13:13:34.377945+00', '2024-06-05 14:12:11.467915+00', NULL, '6d558919-c323-4870-90e8-c82dcb5e4c36'),
	('00000000-0000-0000-0000-000000000000', 24, 'znIeLLV49M3x6m2vuHoOLg', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', true, '2024-06-05 14:12:11.468277+00', '2024-06-05 15:15:17.057616+00', 'DQiaoj0fRBiD-erdMzgIog', '6d558919-c323-4870-90e8-c82dcb5e4c36'),
	('00000000-0000-0000-0000-000000000000', 25, 'U2iygxWF5rIs-r3EdwUeFQ', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', true, '2024-06-05 15:15:17.060688+00', '2024-06-05 16:31:22.534103+00', 'znIeLLV49M3x6m2vuHoOLg', '6d558919-c323-4870-90e8-c82dcb5e4c36'),
	('00000000-0000-0000-0000-000000000000', 26, 'u9aWy5HVuOO3FM9eQujL1A', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', true, '2024-06-05 16:31:22.536073+00', '2024-06-05 20:30:35.927366+00', 'U2iygxWF5rIs-r3EdwUeFQ', '6d558919-c323-4870-90e8-c82dcb5e4c36'),
	('00000000-0000-0000-0000-000000000000', 27, '2V9I-1tJCmSgV50iD0MI_Q', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', true, '2024-06-05 20:30:35.928327+00', '2024-06-08 02:27:29.532239+00', 'u9aWy5HVuOO3FM9eQujL1A', '6d558919-c323-4870-90e8-c82dcb5e4c36'),
	('00000000-0000-0000-0000-000000000000', 28, '-LkKbKhu4I-GlZM86TrG0w', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false, '2024-06-08 02:27:29.536581+00', '2024-06-08 02:27:29.536581+00', '2V9I-1tJCmSgV50iD0MI_Q', '6d558919-c323-4870-90e8-c82dcb5e4c36'),
	('00000000-0000-0000-0000-000000000000', 29, 'qov3s-Uvs3gUnTMkSB1vcg', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false, '2024-06-08 02:32:31.691882+00', '2024-06-08 02:32:31.691882+00', NULL, '0700dd16-9375-4651-adb4-873744a714be'),
	('00000000-0000-0000-0000-000000000000', 30, 'gV51kGbMySb9sI46LHMKXw', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false, '2024-06-08 02:57:31.377573+00', '2024-06-08 02:57:31.377573+00', NULL, '3f0e8e46-5133-4dc2-8a8a-3497044ac5ed');


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."users" ("id", "created_at") VALUES
	('17d97dc9-d482-429e-985b-87d0ea7ec509', '2024-05-30 20:31:42.258873+00'),
	('e587f4b6-31d4-46ae-9091-205d227813ee', '2024-05-30 20:32:02.975203+00'),
	('3bdbb665-84b5-4d32-8135-7ed80548a059', '2024-05-30 20:32:19.178658+00'),
	('c58deed9-5778-4d6a-b2b1-516dd1f9325b', '2024-05-30 20:32:33.147821+00'),
	('ef7bc947-fc26-47a9-b17a-5cf20ac1eb6b', '2024-05-30 20:32:46.649457+00'),
	('bb55a5f6-4541-48e6-96ac-27d79f36dda4', '2024-05-30 20:33:04.985639+00'),
	('c3f43634-0da2-43c7-baa7-ed2fef81e85e', '2024-05-30 20:33:16.937247+00'),
	('0748d39e-6d05-451d-9ff1-6125e6dfaf87', '2024-05-30 20:33:32.333476+00'),
	('98faf97b-6e9e-49db-89bf-3388a3b7b098', '2024-05-30 20:34:03.546106+00'),
	('226e0026-bb1c-442e-8237-a5c328c0a9bc', '2024-05-30 20:34:30.258131+00');


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."projects" ("id", "created_by", "created_at", "name", "description", "members", "tags", "parent") VALUES
	(1, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', '2024-05-30 20:35:29.886276+00', 'Test', 'This is a test', '{c58deed9-5778-4d6a-b2b1-516dd1f9325b}', '{one}', NULL),
	(2, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', '2024-05-30 20:42:24.871821+00', 'Another Test', 'This is another test', '{c58deed9-5778-4d6a-b2b1-516dd1f9325b}', '{two,another}', NULL),
	(3, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', '2024-05-30 20:42:40.637715+00', 'Third', 'This is the third', '{c58deed9-5778-4d6a-b2b1-516dd1f9325b}', '{three}', NULL),
	(4, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', '2024-05-30 20:43:00.352302+00', 'Four for More', 'Test', '{c58deed9-5778-4d6a-b2b1-516dd1f9325b}', '{four,tags,for,all,"another one"}', NULL);


--
-- Data for Name: codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."codes" ("id", "created_at", "project_id", "code", "color", "parent", "created_by", "group") VALUES
	(9, '2024-05-30 22:16:43.945411+00', 1, 'Background', NULL, NULL, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', true),
	(1, '2024-05-30 22:13:34.376688+00', 1, 'software engineer', '#1bd6a5', 9, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(10, '2024-05-30 22:16:53.946147+00', 1, 'Overall impressions', NULL, NULL, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', true),
	(2, '2024-05-30 22:13:45.284668+00', 1, 'design is clean', '#296696', 10, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(3, '2024-05-30 22:13:56.987548+00', 1, 'experienced no trouble', '#989abd', 10, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(4, '2024-05-30 22:14:16.853795+00', 1, 'overall ui feedback', '#d17f99', 10, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(11, '2024-05-30 22:17:05.635871+00', 1, 'Use cases', NULL, NULL, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', true),
	(5, '2024-05-30 22:14:55.398414+00', 1, 'primary use case', '#a50f54', 11, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(12, '2024-05-30 22:17:13.227746+00', 1, 'Difficulties', NULL, NULL, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', true),
	(6, '2024-05-30 22:15:14.876279+00', 1, 'difficulties', '#b52820', 12, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(13, '2024-05-30 22:17:31.339843+00', 1, 'Likes', NULL, NULL, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', true),
	(7, '2024-05-30 22:15:58.663851+00', 1, 'liked task assignment feature', '#88705a', 13, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(14, '2024-05-30 22:18:18.125346+00', 1, 'Comparison with other tools', NULL, NULL, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', true),
	(8, '2024-05-30 22:16:25.715912+00', 1, 'tool is better than others experienced', '#6efdd0', 14, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(16, '2024-05-30 22:18:56.659652+00', 1, 'Improvements', NULL, NULL, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', true),
	(15, '2024-05-30 22:18:50.310694+00', 1, 'Color customization', '#adf661', 16, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(17, '2024-05-30 22:19:10.545762+00', 1, 'Offline mode', '#a36416', 16, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(20, '2024-05-30 22:26:15.644571+00', 1, 'graphic designer', '#b2284a', 9, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(21, '2024-05-30 22:26:37.024671+00', 1, 'positive overall impression', '#8d98b2', 10, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(22, '2024-05-30 22:26:53.673881+00', 1, 'intuitive layout', '#8d87b4', 10, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(23, '2024-05-30 22:27:21.729107+00', 1, 'used the design collaboration tools', '#ed636c', 11, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(24, '2024-05-30 22:27:39.185789+00', 1, 'feedback and annotation features most useful', '#a7ab00', 13, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(25, '2024-05-30 22:28:01.520772+00', 1, 'upload size limit', '#a068ed', 12, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(26, '2024-05-30 22:28:30.032983+00', 1, 'live collaboration feature', '#8f05da', 13, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(27, '2024-05-30 22:28:52.490436+00', 1, 'feels more integrated and less fragmented', '#228fdd', 14, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(28, '2024-05-30 22:30:10.40486+00', 1, 'wants more robust version control', '#b35491', 16, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(29, '2024-05-30 22:30:20.863774+00', 1, 'in-app chat feature', '#7c6191', 16, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(19, '2024-05-30 22:19:38.45208+00', 1, 'would recommend', '#81ace2', 18, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', false),
	(18, '2024-05-30 22:19:26.852143+00', 1, 'Recommendation', NULL, 9, 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', true);


--
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."files" ("id", "created_at", "created_by", "project_id", "parent", "name", "type", "folder", "notes") VALUES
	(11, '2024-05-30 22:31:32.870713+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 1, NULL, 'user study', NULL, true, NULL),
	(13, '2024-06-04 17:04:51.820105+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 1, 12, 'new folder', NULL, true, NULL),
	(12, '2024-06-04 17:04:50.287591+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 1, 11, 'new folder', NULL, true, NULL),
	(6, '2024-05-30 21:14:02.048708+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 1, 12, 'P5.txt', 'text/plain', false, NULL),
	(7, '2024-05-30 21:14:02.166394+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 1, 13, 'P4.txt', 'text/plain', false, NULL),
	(8, '2024-05-30 21:14:02.248224+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 1, 11, 'P3.txt', 'text/plain', false, NULL),
	(10, '2024-05-30 21:14:02.412917+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 1, 11, 'P1.txt', 'text/plain', false, '- This is a test
- This is another test

'),
	(9, '2024-05-30 21:14:02.337449+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 1, 11, 'P2.txt', 'text/plain', false, '- More notes exist here');


--
-- Data for Name: code_instances; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."code_instances" ("id", "created_at", "created_by", "code_id", "data", "start_offset", "end_offset", "file_id") VALUES
	(1, '2024-05-30 22:13:34.376688+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 1, 'Hi, I''m Alex. I''m a software engineer with about five years of experience in web development. I enjoy exploring new technologies and applications that can enhance productivity and user experience.', 152, 348, 10),
	(2, '2024-05-30 22:13:45.284668+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 2, 'The overall design is clean and intuitive', 574, 615, 10),
	(3, '2024-05-30 22:13:56.987548+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 3, ' I didn''t have any trouble navigating through the main sections.', 692, 756, 10),
	(4, '2024-05-30 22:14:16.853795+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 4, ' The overall design is clean and intuitive. The layout is well-organized, and the color scheme is pleasant to the eyes. I didn''t have any trouble navigating through the main sections.', 573, 756, 10),
	(5, '2024-05-30 22:14:55.398414+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 5, 'I primarily used the project management feature', 899, 946, 10),
	(6, '2024-05-30 22:15:14.876279+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 6, 'One thing I noticed was that the loading time for some of the more data-intensive pages was a bit slow. It wasn''t a major issue, but it could be improved to enhance the overall user experience.', 1281, 1474, 10),
	(7, '2024-05-30 22:15:58.663851+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 7, 'I really liked the automated task assignment feature based on team members’ skills and availability', 1600, 1699, 10),
	(8, '2024-05-30 22:16:25.715912+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 8, 'Compared to other tools, this application feels more cohesive and user-friendly.', 2006, 2086, 10),
	(9, '2024-05-30 22:18:50.310694+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 15, 'I would like to see more customization options for the user interface. For example, the ability to change the layout or color scheme to suit personal preferences or company branding would be nice.', 2385, 2581, 10),
	(10, '2024-05-30 22:19:10.545762+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 17, 'Also, an offline mode could be beneficial for times when internet access is limited.', 2582, 2666, 10),
	(11, '2024-05-30 22:19:38.45208+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 19, 'Yes, I would. The application offers a lot of useful features that can streamline project management and enhance team collaboration. The user-friendly design and efficient functionality make it a strong contender in the market.', 2861, 3088, 10),
	(12, '2024-05-30 22:26:15.644571+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 20, 'I''m a graphic designer with over eight years of experience. I specialize in UI/UX design and have a keen interest in testing new applications to see how they can improve workflow and design processes.', 160, 360, 9),
	(13, '2024-05-30 22:26:37.024671+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 21, 'My first impression was quite positive.', 590, 629, 9),
	(14, '2024-05-30 22:26:53.673881+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 22, 'The layout is intuitive, and I could easily find my way around without much effort', 695, 777, 9),
	(15, '2024-05-30 22:27:21.729107+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 23, 'I mainly used the design collaboration tools. I found it very easy to upload my designs and share them with my team. The feedback and annotation features were particularly useful. It allowed us to have clear and concise discussions directly on the designs.', 929, 1185, 9),
	(16, '2024-05-30 22:27:39.185789+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 24, 'The feedback and annotation features were particularly useful. It allowed us to have clear and concise discussions directly on the designs.', 1046, 1185, 9),
	(17, '2024-05-30 22:28:01.520772+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 25, 'The only challenge I encountered was with the file upload size limit. Some of my larger design files took a bit longer to upload, and occasionally, I had to compress them, which reduced the quality. Increasing the file size limit would be helpful.', 1275, 1522, 9),
	(18, '2024-05-30 22:28:30.032983+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 26, 'The live collaboration feature was fantastic. Being able to see my team''s feedback in real-time and make instant changes was incredibly efficient. It felt almost like working together in the same room, which is crucial for remote teams.', 1656, 1892, 9),
	(19, '2024-05-30 22:28:52.490436+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 27, 'Compared to other tools, this application feels more integrated and less fragmented.', 2012, 2096, 9),
	(20, '2024-05-30 22:30:10.40486+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 28, ' I would love to see more robust version control features. Being able to track changes more granularly and revert to previous versions without losing any data would be extremely useful', 2384, 2568, 9),
	(21, '2024-05-30 22:30:20.863774+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 29, 'Also, an in-app chat feature could enhance communication further.', 2570, 2635, 9),
	(22, '2024-05-30 22:30:58.736915+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 19, 'Yes, I would recommend it. The application offers a lot of powerful features that can significantly improve collaboration and productivity. Its user-friendly design and seamless integration make it a great tool for any design team.', 2821, 3052, 9);


--
-- Data for Name: configs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."configs" ("id", "updated_at", "user_id", "display_name", "theme", "favorite_themes", "editor_theme", "code_font_size", "code_line_numbers", "code_font_family", "code_line_height", "random_theme", "editor_file_panel_width", "editor_code_panel_width", "new_code_random_color", "code_text_color", "dynamic_code_text_color", "code_box_shadow", "code_group_children_circles", "code_group_children_stats") VALUES
	(1, '2024-05-30 20:31:42.258873+00', '17d97dc9-d482-429e-985b-87d0ea7ec509', NULL, 'camping', NULL, 'theme', 16, false, 'Roboto Mono', 16, false, 275, 275, true, NULL, true, true, true, false),
	(2, '2024-05-30 20:32:02.975203+00', 'e587f4b6-31d4-46ae-9091-205d227813ee', NULL, 'camping', NULL, 'theme', 16, false, 'Roboto Mono', 16, false, 275, 275, true, NULL, true, true, true, false),
	(3, '2024-05-30 20:32:19.178658+00', '3bdbb665-84b5-4d32-8135-7ed80548a059', NULL, 'camping', NULL, 'theme', 16, false, 'Roboto Mono', 16, false, 275, 275, true, NULL, true, true, true, false),
	(5, '2024-05-30 20:32:46.649457+00', 'ef7bc947-fc26-47a9-b17a-5cf20ac1eb6b', NULL, 'camping', NULL, 'theme', 16, false, 'Roboto Mono', 16, false, 275, 275, true, NULL, true, true, true, false),
	(6, '2024-05-30 20:33:04.985639+00', 'bb55a5f6-4541-48e6-96ac-27d79f36dda4', NULL, 'camping', NULL, 'theme', 16, false, 'Roboto Mono', 16, false, 275, 275, true, NULL, true, true, true, false),
	(7, '2024-05-30 20:33:16.937247+00', 'c3f43634-0da2-43c7-baa7-ed2fef81e85e', NULL, 'camping', NULL, 'theme', 16, false, 'Roboto Mono', 16, false, 275, 275, true, NULL, true, true, true, false),
	(8, '2024-05-30 20:33:32.333476+00', '0748d39e-6d05-451d-9ff1-6125e6dfaf87', NULL, 'camping', NULL, 'theme', 16, false, 'Roboto Mono', 16, false, 275, 275, true, NULL, true, true, true, false),
	(9, '2024-05-30 20:34:03.546106+00', '98faf97b-6e9e-49db-89bf-3388a3b7b098', NULL, 'camping', NULL, 'theme', 16, false, 'Roboto Mono', 16, false, 275, 275, true, NULL, true, true, true, false),
	(10, '2024-05-30 20:34:30.258131+00', '226e0026-bb1c-442e-8237-a5c328c0a9bc', NULL, 'camping', NULL, 'theme', 16, false, 'Roboto Mono', 16, false, 275, 275, true, NULL, true, true, true, false),
	(4, '2024-05-30 20:32:33.147821+00', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', 'louis', 'bouquet', '{camping,dino}', 'light', 16, true, 'Roboto Mono', 16, false, 166, 0, true, NULL, true, true, true, true);


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."buckets" ("id", "name", "owner", "created_at", "updated_at", "public", "avif_autodetection", "file_size_limit", "allowed_mime_types", "owner_id") VALUES
	('files', 'files', NULL, '2024-05-30 21:12:46.010144+00', '2024-05-30 21:12:46.010144+00', false, false, NULL, NULL, NULL);


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."objects" ("id", "bucket_id", "name", "owner", "created_at", "updated_at", "last_accessed_at", "metadata", "version", "owner_id") VALUES
	('4fd091ed-781b-40d1-b89b-0a37be39c8dd', 'files', '6', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', '2024-05-30 21:14:02.12957+00', '2024-05-30 21:14:02.12957+00', '2024-05-30 21:14:02.12957+00', '{"eTag": "\"3362326e30d4209daf873a1df7185f50\"", "size": 3484, "mimetype": "text/plain", "cacheControl": "max-age=3600", "lastModified": "2024-05-30T21:14:02.103Z", "contentLength": 3484, "httpStatusCode": 200}', '0f083348-9c71-427e-9285-fde8aaf39154', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b'),
	('eb4b9189-5ed0-47cc-9e02-204d5dfd7712', 'files', '7', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', '2024-05-30 21:14:02.212671+00', '2024-05-30 21:14:02.212671+00', '2024-05-30 21:14:02.212671+00', '{"eTag": "\"025c7ee6f0a21fcd59adf838509a88f0\"", "size": 3264, "mimetype": "text/plain", "cacheControl": "max-age=3600", "lastModified": "2024-05-30T21:14:02.193Z", "contentLength": 3264, "httpStatusCode": 200}', 'a64e0d11-6781-4bd2-8c13-241a6b0f840d', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b'),
	('38acbac6-cd92-482a-a6c7-f2a82e2e0a14', 'files', '8', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', '2024-05-30 21:14:02.299876+00', '2024-05-30 21:14:02.299876+00', '2024-05-30 21:14:02.299876+00', '{"eTag": "\"97d8c534d1426fe68ee61ebc40bcc8ff\"", "size": 3307, "mimetype": "text/plain", "cacheControl": "max-age=3600", "lastModified": "2024-05-30T21:14:02.283Z", "contentLength": 3307, "httpStatusCode": 200}', '86a10a06-6573-4e37-bb4e-18ee61679306', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b'),
	('ad115a66-06e6-4abb-bafb-1e23bd03844c', 'files', '9', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', '2024-05-30 21:14:02.388742+00', '2024-05-30 21:14:02.388742+00', '2024-05-30 21:14:02.388742+00', '{"eTag": "\"2431c042fe4b1fdff6d49f963407cd20\"", "size": 3272, "mimetype": "text/plain", "cacheControl": "max-age=3600", "lastModified": "2024-05-30T21:14:02.373Z", "contentLength": 3272, "httpStatusCode": 200}', '096d4f0d-6082-45b6-ab5d-c8b5f5cd8a89', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b'),
	('6a936849-a287-443c-adcc-fc81910e8135', 'files', '10', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b', '2024-05-30 21:14:02.447089+00', '2024-05-30 21:14:02.447089+00', '2024-05-30 21:14:02.447089+00', '{"eTag": "\"da5527924b8f376a2e2b0f66bbc6014f\"", "size": 3313, "mimetype": "text/plain", "cacheControl": "max-age=3600", "lastModified": "2024-05-30T21:14:02.433Z", "contentLength": 3313, "httpStatusCode": 200}', '1d423ce7-089a-4827-b854-e3bf32af69da', 'c58deed9-5778-4d6a-b2b1-516dd1f9325b');


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--



--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 30, true);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('"pgsodium"."key_key_id_seq"', 1, false);


--
-- Name: code_instances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."code_instances_id_seq"', 25, true);


--
-- Name: codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."codes_id_seq"', 30, true);


--
-- Name: configs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."configs_id_seq"', 10, true);


--
-- Name: files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."files_id_seq"', 13, true);


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."projects_id_seq"', 5, true);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('"supabase_functions"."hooks_id_seq"', 1, false);


--
-- PostgreSQL database dump complete
--

RESET ALL;
