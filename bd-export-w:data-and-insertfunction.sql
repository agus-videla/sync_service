--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1 (Debian 14.1-1.pgdg110+1)
-- Dumped by pg_dump version 14.12 (Homebrew)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: get_or_create_device(integer, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_or_create_device(device_id integer, make text, model text, belonging text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO device (id, make, model, belonging)
    VALUES (device_id, make, model, belonging)
    ON CONFLICT (id) DO UPDATE SET
        make = EXCLUDED.make,
        model = EXCLUDED.model,
        belonging = EXCLUDED.belonging;
END;
$$;


ALTER FUNCTION public.get_or_create_device(device_id integer, make text, model text, belonging text) OWNER TO postgres;

--
-- Name: get_or_create_device(integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_or_create_device(p_id integer, p_make character varying, p_model character varying, p_belonging character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    device_id INTEGER;
BEGIN
    SELECT id INTO device_id FROM device WHERE id = p_id;
    IF NOT FOUND THEN
        INSERT INTO device (id, make, model, belonging) VALUES (p_id, p_make, p_model, p_belonging) RETURNING id INTO device_id;
    END IF;
    RETURN device_id;
END;
$$;


ALTER FUNCTION public.get_or_create_device(p_id integer, p_make character varying, p_model character varying, p_belonging character varying) OWNER TO postgres;

--
-- Name: get_or_create_parameter(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_or_create_parameter(param_name text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    param_id INTEGER;
BEGIN
    SELECT id INTO param_id FROM parameter WHERE name = param_name;
    IF NOT FOUND THEN
        INSERT INTO parameter (name) VALUES (param_name) RETURNING id INTO param_id;
    END IF;
    RETURN param_id;
END;
$$;


ALTER FUNCTION public.get_or_create_parameter(param_name text) OWNER TO postgres;

--
-- Name: get_or_create_parameter(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_or_create_parameter(p_name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    param_id INTEGER;
BEGIN
    SELECT id INTO param_id FROM parameter WHERE name = p_name;
    IF NOT FOUND THEN
        INSERT INTO parameter (name, created_at) VALUES (p_name, NOW()) RETURNING id INTO param_id;
    END IF;
    RETURN param_id;
END;
$$;


ALTER FUNCTION public.get_or_create_parameter(p_name character varying) OWNER TO postgres;

--
-- Name: get_or_create_persona(integer, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_or_create_persona(persona_id integer, first_name text, last_name text, dni text, affiliation text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO persona (id, first_name, last_name, dni, affiliation)
    VALUES (persona_id, first_name, last_name, dni, affiliation)
    ON CONFLICT (id) DO UPDATE SET
        first_name = EXCLUDED.first_name,
        last_name = EXCLUDED.last_name,
        dni = EXCLUDED.dni,
        affiliation = EXCLUDED.affiliation;
END;
$$;


ALTER FUNCTION public.get_or_create_persona(persona_id integer, first_name text, last_name text, dni text, affiliation text) OWNER TO postgres;

--
-- Name: get_or_create_persona(integer, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_or_create_persona(p_id integer, p_first_name character varying, p_last_name character varying, p_dni character varying, p_filiation character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    persona_id INTEGER;
BEGIN
    SELECT id INTO persona_id FROM persona WHERE id = p_id;
    IF NOT FOUND THEN
        INSERT INTO persona (id, first_name, last_name, dni, filiation) VALUES (p_id, p_first_name, p_last_name, p_dni, p_filiation) RETURNING id INTO persona_id;
    END IF;
    RETURN persona_id;
END;
$$;


ALTER FUNCTION public.get_or_create_persona(p_id integer, p_first_name character varying, p_last_name character varying, p_dni character varying, p_filiation character varying) OWNER TO postgres;

--
-- Name: get_or_create_shore_vegetation(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_or_create_shore_vegetation(p_name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    veg_id INTEGER;
BEGIN
    SELECT id INTO veg_id FROM shore_vegetation WHERE name = p_name;
    IF NOT FOUND THEN
        INSERT INTO shore_vegetation (name) VALUES (p_name) RETURNING id INTO veg_id;
    END IF;
    RETURN veg_id;
END;
$$;


ALTER FUNCTION public.get_or_create_shore_vegetation(p_name character varying) OWNER TO postgres;

--
-- Name: get_or_create_technique(character varying, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_or_create_technique(p_name character varying, p_created_at timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    tech_id INTEGER;
BEGIN
    SELECT id INTO tech_id FROM technique WHERE name = p_name;
    IF NOT FOUND THEN
        INSERT INTO technique (name, created_at) VALUES (p_name, p_created_at) RETURNING id INTO tech_id;
    END IF;
    RETURN tech_id;
END;
$$;


ALTER FUNCTION public.get_or_create_technique(p_name character varying, p_created_at timestamp without time zone) OWNER TO postgres;

--
-- Name: get_or_create_water_vegetation(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_or_create_water_vegetation(p_name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    veg_id INTEGER;
BEGIN
    SELECT id INTO veg_id FROM water_vegetation WHERE name = p_name;
    IF NOT FOUND THEN
        INSERT INTO water_vegetation (name) VALUES (p_name) RETURNING id INTO veg_id;
    END IF;
    RETURN veg_id;
END;
$$;


ALTER FUNCTION public.get_or_create_water_vegetation(p_name character varying) OWNER TO postgres;

--
-- Name: insert_data_from_json(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_data_from_json(data jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Variables for river_register
    river_reg JSONB := data->'river_register';
    register_meta JSONB := data->'register_metadata';
    devices JSONB := data->'devices';
    device_refs JSONB := data->'device_register_cross_refs';
    personas JSONB := data->'personas';
    persona_refs JSONB := data->'persona_register_cross_refs';
    profiles JSONB := data->'profiles';
    samples JSONB := data->'samples';
    sites JSONB := data->'sites';
    vegetations JSONB := data->'vegetations';
    vegetation_refs JSONB := data->'vegetation_register_cross_refs';

    -- Variables for inserting records
    new_record_id INTEGER;
    new_weather_id INTEGER;
    new_algal_condition_id INTEGER;
    new_river_gauge_id INTEGER;
    new_record_metadata_id INTEGER;

    -- Loop counters
    device_item JSONB;
    device_ref_item JSONB;
    persona_item JSONB;
    persona_ref_item JSONB;
    profile_item JSONB;
    sample_item JSONB;
    site_item JSONB;
    vegetation_item JSONB;
    vegetation_ref_item JSONB;

    -- Variables for parameters
    param_id INTEGER;
BEGIN
    -- Start Transaction
    BEGIN
        -- 1. Insert into site table
        FOR site_item IN SELECT * FROM jsonb_array_elements(sites) LOOP
            INSERT INTO site (id, site)
            VALUES (
                (site_item->>'id')::INTEGER,
                site_item->>'site'
            )
            ON CONFLICT (id) DO NOTHING; -- Assuming 'id' is unique
        END LOOP;

        -- 2. Insert into profile table
        FOR profile_item IN SELECT * FROM jsonb_array_elements(profiles) LOOP
            INSERT INTO profile (id, site_id, code, mix_criteria, mix_description, stratification_criteria, stratification_description)
            VALUES (
                (profile_item->>'id')::INTEGER,
                (profile_item->>'site_id')::INTEGER,
                profile_item->>'code',
                profile_item->>'mix_criteria',
                profile_item->>'mix_description',
                profile_item->>'stratification_criteria',
                profile_item->>'stratification_description'
            )
            ON CONFLICT (id) DO NOTHING; -- Assuming 'id' is unique
        END LOOP;

        -- 3. Insert into device table
        FOR device_item IN SELECT * FROM jsonb_array_elements(devices) LOOP
            PERFORM get_or_create_device(
                (device_item->>'id')::INTEGER,
                device_item->>'make',
                device_item->>'model',
                device_item->>'belonging'
            );
        END LOOP;

        -- 4. Insert into persona table
        FOR persona_item IN SELECT * FROM jsonb_array_elements(personas) LOOP
            PERFORM get_or_create_persona(
                (persona_item->>'id')::INTEGER,
                persona_item->>'first_name',
                persona_item->>'last_name',
                persona_item->>'dni',
                persona_item->>'affiliation'
            );
        END LOOP;

        -- 5. Insert into vegetation tables
        FOR vegetation_item IN SELECT * FROM jsonb_array_elements(vegetations) LOOP
            IF (LOWER(vegetation_item->>'context') = 'shore') THEN
                PERFORM get_or_create_shore_vegetation(vegetation_item->>'name');
            ELSIF (LOWER(vegetation_item->>'context') = 'water') THEN
                PERFORM get_or_create_water_vegetation(vegetation_item->>'name');
            END IF;
        END LOOP;

        -- 6. Insert into monitoring table
        -- Since monitoring data isn't explicitly in the JSON, this step is skipped unless required

        -- 7. Insert into weather table
        INSERT INTO weather (env_temp, cloudiness, wind_status, wind_velocity, precipitation)
        VALUES (
            (river_reg->>'env_temp')::DOUBLE PRECISION,
            river_reg->>'cloudiness',
            river_reg->>'wind_status',
            (river_reg->>'wind_velocity')::DOUBLE PRECISION,
            river_reg->>'precipitation'
        )
        RETURNING id INTO new_weather_id;

        -- 8. Insert into algal_condition table
        INSERT INTO algal_condition (water_color_algal, odor)
        VALUES (
            river_reg->>'water_color',
            river_reg->>'water_odor'
        )
        RETURNING id INTO new_algal_condition_id;

        -- 9. Insert into river_gauge table
        INSERT INTO river_gauge (gauge, area, average_speed, width, hm, observations)
        VALUES (
            (river_reg->>'gauge')::DOUBLE PRECISION,
            (river_reg->>'area')::DOUBLE PRECISION,
            (river_reg->>'average_speed')::DOUBLE PRECISION,
            (river_reg->>'width')::DOUBLE PRECISION,
            (river_reg->>'hm')::DOUBLE PRECISION,
            river_reg->>'observations'
        )
        RETURNING id INTO new_river_gauge_id;

        -- 10. Insert into record table
        INSERT INTO record (depth, number, time, profile_id)
        VALUES (
            (river_reg->>'z')::DOUBLE PRECISION, -- 'z' is mapped to 'depth'
            (river_reg->>'id')::INTEGER, -- Assuming 'id' corresponds to 'number'
            (register_meta->>'arrival_time')::TIMESTAMP, -- Using arrival_time as 'time'
            (river_reg->>'site_id')::INTEGER -- Assuming 'profile_id' corresponds to 'site_id'
        )
        RETURNING id INTO new_record_id;

        -- 11. Insert into record_metadata table
        INSERT INTO record_metadata (record_id, arrival_time, departure_time, latitude, longitude, observations)
        VALUES (
            new_record_id,
            (register_meta->>'arrival_time')::TIMESTAMP,
            (register_meta->>'departure_time')::TIMESTAMP,
            (register_meta->>'latitude')::DOUBLE PRECISION,
            (register_meta->>'longitude')::DOUBLE PRECISION,
            register_meta->>'observations'
        )
        RETURNING id INTO new_record_metadata_id;

        -- 12. Insert into river_record_metadata table
        INSERT INTO river_record_metadata (
            record_id,
            weather_id,
            river_status,
            monitoring_id, -- Assuming monitoring_id is handled elsewhere or set to NULL
            river_gauge_id,
            observations,
            laboratory, -- Not provided in JSON, set to NULL or handle accordingly
            arrival_time,
            departure_time,
            latitude,
            longitude,
            subregion_id -- Not provided in JSON, set to NULL or handle accordingly
        )
        VALUES (
            new_record_id,
            new_weather_id,
            river_reg->>'river_status',
            NULL, -- Adjust if monitoring_id is available
            new_river_gauge_id,
            river_reg->>'observations',
            NULL, -- Adjust if laboratory data is available
            (register_meta->>'arrival_time')::TIMESTAMP,
            (register_meta->>'departure_time')::TIMESTAMP,
            (register_meta->>'latitude')::DOUBLE PRECISION,
            (register_meta->>'longitude')::DOUBLE PRECISION,
            NULL -- Adjust if subregion_id is available
        );

        -- 13. Insert measurements
        -- ph
        param_id := get_or_create_parameter('ph');
        INSERT INTO measurement (record_id, parameter_id, is_cuant_limit, value)
        VALUES (
            new_record_id,
            param_id,
            FALSE, -- Adjust based on actual data
            (river_reg->>'ph')::DOUBLE PRECISION
        );

        -- conductivity
        param_id := get_or_create_parameter('conductivity');
        INSERT INTO measurement (record_id, parameter_id, is_cuant_limit, value)
        VALUES (
            new_record_id,
            param_id,
            FALSE,
            (river_reg->>'conductivity')::DOUBLE PRECISION
        );

        -- od
        param_id := get_or_create_parameter('od');
        INSERT INTO measurement (record_id, parameter_id, is_cuant_limit, value)
        VALUES (
            new_record_id,
            param_id,
            FALSE,
            (river_reg->>'od')::DOUBLE PRECISION
        );

        -- od_percentage
        param_id := get_or_create_parameter('od_percentage');
        INSERT INTO measurement (record_id, parameter_id, is_cuant_limit, value)
        VALUES (
            new_record_id,
            param_id,
            FALSE,
            (river_reg->>'od_percentage')::DOUBLE PRECISION
        );

        -- tds
        param_id := get_or_create_parameter('tds');
        INSERT INTO measurement (record_id, parameter_id, is_cuant_limit, value)
        VALUES (
            new_record_id,
            param_id,
            FALSE,
            (river_reg->>'tds')::DOUBLE PRECISION
        );

        -- water_temperature
        param_id := get_or_create_parameter('water_temperature');
        INSERT INTO measurement (record_id, parameter_id, is_cuant_limit, value)
        VALUES (
            new_record_id,
            param_id,
            FALSE,
            (river_reg->>'water_temperature')::DOUBLE PRECISION
        );

        -- turbidity
        param_id := get_or_create_parameter('turbidity');
        INSERT INTO measurement (record_id, parameter_id, is_cuant_limit, value)
        VALUES (
            new_record_id,
            param_id,
            FALSE,
            (river_reg->>'turbidity')::DOUBLE PRECISION
        );

        -- temperature
        param_id := get_or_create_parameter('temperature');
        INSERT INTO measurement (record_id, parameter_id, is_cuant_limit, value)
        VALUES (
            new_record_id,
            param_id,
            FALSE,
            (river_reg->>'temperature')::DOUBLE PRECISION
        );

        -- 14. Insert into device_record table
        FOR device_ref_item IN SELECT * FROM jsonb_array_elements(device_refs) LOOP
            INSERT INTO device_record (record_id, device_id, device_category)
            VALUES (
                new_record_id,
                (device_ref_item->>'device_id')::INTEGER,
                device_ref_item->>'device_category'
            )
            ON CONFLICT DO NOTHING;
        END LOOP;

        -- 15. Insert into persona_record table
        FOR persona_ref_item IN SELECT * FROM jsonb_array_elements(persona_refs) LOOP
            INSERT INTO persona_record (record_id, persona_id)
            VALUES (
                new_record_id,
                (persona_ref_item->>'persona_id')::INTEGER
            )
            ON CONFLICT DO NOTHING;
        END LOOP;

        -- 16. Insert into record_shore_vegetation and record_water_vegetation tables
        FOR vegetation_ref_item IN SELECT * FROM jsonb_array_elements(vegetation_refs) LOOP
            -- Determine the context of the vegetation
            DECLARE
                veg_context VARCHAR;
            BEGIN
                SELECT context INTO veg_context FROM vegetations WHERE id = (vegetation_ref_item->>'vegetation_id')::INTEGER;
                IF LOWER(veg_context) = 'shore' THEN
                    INSERT INTO record_shore_vegetation (record_id, shore_vegetation_id)
                    VALUES (
                        new_record_id,
                        (vegetation_ref_item->>'vegetation_id')::INTEGER
                    )
                    ON CONFLICT DO NOTHING;
                ELSIF LOWER(veg_context) = 'water' THEN
                    INSERT INTO record_water_vegetation (record_id, water_vegetation_id)
                    VALUES (
                        new_record_id,
                        (vegetation_ref_item->>'vegetation_id')::INTEGER
                    )
                    ON CONFLICT DO NOTHING;
                END IF;
            END;
        END LOOP;

        -- Commit Transaction
        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            -- Rollback in case of error
            ROLLBACK;
            RAISE;
    END;

END;
$$;


ALTER FUNCTION public.insert_data_from_json(data jsonb) OWNER TO postgres;

--
-- Name: insert_data_from_json_proc(jsonb); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.insert_data_from_json_proc(IN data jsonb)
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Variables for river_register and related data
    river_reg JSONB := data->'river_register';
    register_meta JSONB := data->'register_metadata';
    devices JSONB := data->'devices';
    device_refs JSONB := data->'device_register_cross_refs';
    personas JSONB := data->'personas';
    persona_refs JSONB := data->'persona_register_cross_refs';
    profiles JSONB := data->'profiles';
    samples JSONB := data->'samples';
    sites JSONB := data->'sites';
    vegetations JSONB := data->'vegetations';
    vegetation_refs JSONB := data->'vegetation_register_cross_refs';

    -- Variables for inserting records
    new_record_id INTEGER;
    new_weather_id INTEGER;
    new_algal_condition_id INTEGER;
    new_river_gauge_id INTEGER;
    new_record_metadata_id INTEGER;

    -- Loop counters
    site_item JSONB;
    profile_item JSONB;
    device_item JSONB;
    device_ref_item JSONB;
    persona_item JSONB;
    persona_ref_item JSONB;
    vegetation_item JSONB;
    vegetation_ref_item JSONB;

    -- Variable for parameters
    param_id INTEGER;

    -- Variable to hold the correct profile_id
    actual_profile_id INTEGER;
BEGIN
    -- 1. Insert into 'site' table
    FOR site_item IN SELECT * FROM jsonb_array_elements(sites) LOOP
        INSERT INTO site (id, site)
        VALUES (
            (site_item->>'id')::INTEGER,
            site_item->>'site'
        )
        ON CONFLICT (id) DO NOTHING; -- Assuming 'id' is unique
    END LOOP;

    -- 2. Insert into 'profile' table
    FOR profile_item IN SELECT * FROM jsonb_array_elements(profiles) LOOP
        INSERT INTO profile (
            id, site_id, code, mix_criteria, mix_description, stratification_criteria, stratification_description
        )
        VALUES (
            (profile_item->>'id')::INTEGER,
            (profile_item->>'site_id')::INTEGER,
            profile_item->>'code',
            profile_item->>'mix_criteria',
            profile_item->>'mix_description',
            profile_item->>'stratification_criteria',
            profile_item->>'stratification_description'
        )
        ON CONFLICT (id) DO UPDATE SET
            site_id = EXCLUDED.site_id,
            code = EXCLUDED.code,
            mix_criteria = EXCLUDED.mix_criteria,
            mix_description = EXCLUDED.mix_description,
            stratification_criteria = EXCLUDED.stratification_criteria,
            stratification_description = EXCLUDED.stratification_description;
    END LOOP;

    -- 3. Insert into 'device' table using helper function
    FOR device_item IN SELECT * FROM jsonb_array_elements(devices) LOOP
        PERFORM get_or_create_device(
            (device_item->>'id')::INTEGER,
            device_item->>'make',
            device_item->>'model',
            device_item->>'belonging'
        );
    END LOOP;

    -- 4. Insert into 'persona' table using helper function
    FOR persona_item IN SELECT * FROM jsonb_array_elements(personas) LOOP
        PERFORM get_or_create_persona(
            (persona_item->>'id')::INTEGER,
            persona_item->>'first_name',
            persona_item->>'last_name',
            persona_item->>'dni',
            persona_item->>'affiliation'
        );
    END LOOP;

    -- 5. Insert into 'vegetations' tables based on context using helper functions
    FOR vegetation_item IN SELECT * FROM jsonb_array_elements(vegetations) LOOP
        IF LOWER(vegetation_item->>'context') = 'shore' THEN
            PERFORM get_or_create_shore_vegetation(vegetation_item->>'name');
        ELSIF LOWER(vegetation_item->>'context') = 'water' THEN
            PERFORM get_or_create_water_vegetation(vegetation_item->>'name');
        END IF;
    END LOOP;

    -- 6. Insert into 'weather' table and capture the new ID
    INSERT INTO weather (
        env_temp, cloudiness, wind_status, wind_velocity, precipitation
    )
    VALUES (
        (river_reg->>'env_temp')::DOUBLE PRECISION,
        river_reg->>'cloudiness',
        river_reg->>'wind_status',
        (river_reg->>'wind_velocity')::DOUBLE PRECISION,
        river_reg->>'precipitation'
    )
    RETURNING id INTO new_weather_id;

    -- 7. Insert into 'algal_condition' table and capture the new ID
    INSERT INTO algal_condition (
        water_color_algal, odor
    )
    VALUES (
        river_reg->>'water_color',
        river_reg->>'water_odor'
    )
    RETURNING id INTO new_algal_condition_id;

    -- 8. Insert into 'river_gauge' table and capture the new ID
    INSERT INTO river_gauge (
        gauge, area, average_speed, width, hm, observations
    )
    VALUES (
        (river_reg->>'gauge')::DOUBLE PRECISION,
        (river_reg->>'area')::DOUBLE PRECISION,
        (river_reg->>'average_speed')::DOUBLE PRECISION,
        (river_reg->>'width')::DOUBLE PRECISION,
        (river_reg->>'hm')::DOUBLE PRECISION,
        river_reg->>'observations'
    )
    RETURNING id INTO new_river_gauge_id;

    -- 9. Retrieve the correct profile_id based on site_id
    SELECT id INTO actual_profile_id
    FROM profile
    WHERE site_id = (river_reg->>'site_id')::INTEGER
    LIMIT 1;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Profile with site_id=% not found in profile table', (river_reg->>'site_id')::INTEGER;
    END IF;

    -- 10. Insert into 'record' table and capture the new ID
    INSERT INTO record (
        depth, number, time, profile_id
    )
    VALUES (
        (river_reg->>'z')::DOUBLE PRECISION, -- 'z' mapped to 'depth'
        (river_reg->>'id')::INTEGER,         -- 'id' mapped to 'number'
        (register_meta->>'arrival_time')::TIMESTAMP,
        actual_profile_id                     -- Correct profile_id
    )
    RETURNING id INTO new_record_id;

    -- 11. Insert into 'record_metadata' table and capture the new ID
    INSERT INTO record_metadata (
        record_id, arrival_time, departure_time, latitude, longitude, observations
    )
    VALUES (
        new_record_id,
        (register_meta->>'arrival_time')::TIMESTAMP,
        (register_meta->>'departure_time')::TIMESTAMP,
        (register_meta->>'latitude')::DOUBLE PRECISION,
        (register_meta->>'longitude')::DOUBLE PRECISION,
        register_meta->>'observations'
    )
    RETURNING id INTO new_record_metadata_id;

    -- 12. Insert into 'river_record_metadata' table
    INSERT INTO river_record_metadata (
        record_id, weather_id, river_status, monitoring_id,
        river_gauge_id, observations, laboratory,
        arrival_time, departure_time, latitude, longitude, subregion_id
    )
    VALUES (
        new_record_id,
        new_weather_id,
        river_reg->>'river_status',
        NULL, -- Assuming 'monitoring_id' is handled elsewhere or set to NULL
        new_river_gauge_id,
        river_reg->>'observations',
        NULL, -- Assuming 'laboratory' data is not provided
        (register_meta->>'arrival_time')::TIMESTAMP,
        (register_meta->>'departure_time')::TIMESTAMP,
        (register_meta->>'latitude')::DOUBLE PRECISION,
        (register_meta->>'longitude')::DOUBLE PRECISION,
        NULL  -- Assuming 'subregion_id' is handled elsewhere or set to NULL
    );

    -- 13. Insert measurements using helper function
    -- Example for 'ph' parameter
    param_id := get_or_create_parameter('ph');
    INSERT INTO measurement (
        record_id, parameter_id, is_cuant_limit, value
    )
    VALUES (
        new_record_id,
        param_id,
        FALSE, -- Adjust based on actual data
        (river_reg->>'ph')::DOUBLE PRECISION
    );

    -- Repeat similar blocks for other parameters like 'conductivity', 'od', etc.
    -- Example for 'conductivity'
    param_id := get_or_create_parameter('conductivity');
    INSERT INTO measurement (
        record_id, parameter_id, is_cuant_limit, value
    )
    VALUES (
        new_record_id,
        param_id,
        FALSE,
        (river_reg->>'conductivity')::DOUBLE PRECISION
    );

    -- Continue for 'od', 'od_percentage', 'tds', 'water_temperature', 'turbidity', 'temperature'
    -- Example for 'od'
    param_id := get_or_create_parameter('od');
    INSERT INTO measurement (
        record_id, parameter_id, is_cuant_limit, value
    )
    VALUES (
        new_record_id,
        param_id,
        FALSE,
        (river_reg->>'od')::DOUBLE PRECISION
    );

    -- Example for 'od_percentage'
    param_id := get_or_create_parameter('od_percentage');
    INSERT INTO measurement (
        record_id, parameter_id, is_cuant_limit, value
    )
    VALUES (
        new_record_id,
        param_id,
        FALSE,
        (river_reg->>'od_percentage')::DOUBLE PRECISION
    );

    -- Example for 'tds'
    param_id := get_or_create_parameter('tds');
    INSERT INTO measurement (
        record_id, parameter_id, is_cuant_limit, value
    )
    VALUES (
        new_record_id,
        param_id,
        FALSE,
        (river_reg->>'tds')::DOUBLE PRECISION
    );

    -- Example for 'water_temperature'
    param_id := get_or_create_parameter('water_temperature');
    INSERT INTO measurement (
        record_id, parameter_id, is_cuant_limit, value
    )
    VALUES (
        new_record_id,
        param_id,
        FALSE,
        (river_reg->>'water_temperature')::DOUBLE PRECISION
    );

    -- Example for 'turbidity'
    param_id := get_or_create_parameter('turbidity');
    INSERT INTO measurement (
        record_id, parameter_id, is_cuant_limit, value
    )
    VALUES (
        new_record_id,
        param_id,
        FALSE,
        (river_reg->>'turbidity')::DOUBLE PRECISION
    );

    -- Example for 'temperature'
    param_id := get_or_create_parameter('temperature');
    INSERT INTO measurement (
        record_id, parameter_id, is_cuant_limit, value
    )
    VALUES (
        new_record_id,
        param_id,
        FALSE,
        (river_reg->>'temperature')::DOUBLE PRECISION
    );

    -- 14. Insert into 'device_record' table
    FOR device_ref_item IN SELECT * FROM jsonb_array_elements(device_refs) LOOP
        INSERT INTO device_record (
            record_id, device_id, device_category
        )
        VALUES (
            new_record_id,
            (device_ref_item->>'device_id')::INTEGER,
            device_ref_item->>'device_category'
        )
        ON CONFLICT DO NOTHING;
    END LOOP;

    -- 15. Insert into 'persona_record' table
    FOR persona_ref_item IN SELECT * FROM jsonb_array_elements(persona_refs) LOOP
        INSERT INTO persona_record (
            record_id, persona_id
        )
        VALUES (
            new_record_id,
            (persona_ref_item->>'persona_id')::INTEGER
        )
        ON CONFLICT DO NOTHING;
    END LOOP;

    -- 16. Insert into 'record_shore_vegetation' and 'record_water_vegetation' tables
    FOR vegetation_ref_item IN SELECT * FROM jsonb_array_elements(vegetation_refs) LOOP
        DECLARE
            veg_context VARCHAR;
        BEGIN
            SELECT context INTO veg_context
            FROM vegetations
            WHERE id = (vegetation_ref_item->>'vegetation_id')::INTEGER
            LIMIT 1;

            IF LOWER(veg_context) = 'shore' THEN
                INSERT INTO record_shore_vegetation (
                    record_id, shore_vegetation_id
                )
                VALUES (
                    new_record_id,
                    (vegetation_ref_item->>'vegetation_id')::INTEGER
                )
                ON CONFLICT DO NOTHING;
            ELSIF LOWER(veg_context) = 'water' THEN
                INSERT INTO record_water_vegetation (
                    record_id, water_vegetation_id
                )
                VALUES (
                    new_record_id,
                    (vegetation_ref_item->>'vegetation_id')::INTEGER
                )
                ON CONFLICT DO NOTHING;
            END IF;
        END;
    END LOOP;

END;
$$;


ALTER PROCEDURE public.insert_data_from_json_proc(IN data jsonb) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: algal_condition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.algal_condition (
    id integer NOT NULL,
    macrophytes character varying,
    water_color_algal character varying,
    non_algal_turbidity character varying,
    appearence character varying,
    blooming character varying,
    odor character varying
);


ALTER TABLE public.algal_condition OWNER TO postgres;

--
-- Name: algal_condition_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.algal_condition_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.algal_condition_id_seq OWNER TO postgres;

--
-- Name: algal_condition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.algal_condition_id_seq OWNED BY public.algal_condition.id;


--
-- Name: device; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device (
    id integer NOT NULL,
    make character varying NOT NULL,
    model character varying NOT NULL,
    belonging character varying,
    technique_id integer
);


ALTER TABLE public.device OWNER TO postgres;

--
-- Name: device_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.device_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.device_id_seq OWNER TO postgres;

--
-- Name: device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.device_id_seq OWNED BY public.device.id;


--
-- Name: device_record; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device_record (
    id integer NOT NULL,
    record_id integer,
    device_id integer,
    device_category character varying
);


ALTER TABLE public.device_record OWNER TO postgres;

--
-- Name: device_record_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.device_record_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.device_record_id_seq OWNER TO postgres;

--
-- Name: device_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.device_record_id_seq OWNED BY public.device_record.id;


--
-- Name: equivalences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equivalences (
    id integer NOT NULL,
    acsa_name character varying,
    ina_name character varying
);


ALTER TABLE public.equivalences OWNER TO postgres;

--
-- Name: equivalences_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equivalences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.equivalences_id_seq OWNER TO postgres;

--
-- Name: equivalences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equivalences_id_seq OWNED BY public.equivalences.id;


--
-- Name: measurement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.measurement (
    id integer NOT NULL,
    record_id integer,
    parameter_id integer,
    is_cuant_limit boolean,
    value double precision
);


ALTER TABLE public.measurement OWNER TO postgres;

--
-- Name: measurement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.measurement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.measurement_id_seq OWNER TO postgres;

--
-- Name: measurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.measurement_id_seq OWNED BY public.measurement.id;


--
-- Name: monitoring; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monitoring (
    id integer NOT NULL,
    number integer NOT NULL,
    date date,
    season character varying,
    hydrological_year character varying
);


ALTER TABLE public.monitoring OWNER TO postgres;

--
-- Name: monitoring_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monitoring_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.monitoring_id_seq OWNER TO postgres;

--
-- Name: monitoring_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monitoring_id_seq OWNED BY public.monitoring.id;


--
-- Name: monitoring_number_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monitoring_number_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.monitoring_number_seq OWNER TO postgres;

--
-- Name: monitoring_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monitoring_number_seq OWNED BY public.monitoring.number;


--
-- Name: parameter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parameter (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone
);


ALTER TABLE public.parameter OWNER TO postgres;

--
-- Name: parameter_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parameter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.parameter_id_seq OWNER TO postgres;

--
-- Name: parameter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.parameter_id_seq OWNED BY public.parameter.id;


--
-- Name: persona; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persona (
    id integer NOT NULL,
    first_name character varying,
    last_name character varying,
    dni character varying,
    affiliation character varying,
    rol character varying
);


ALTER TABLE public.persona OWNER TO postgres;

--
-- Name: persona_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.persona_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.persona_id_seq OWNER TO postgres;

--
-- Name: persona_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.persona_id_seq OWNED BY public.persona.id;


--
-- Name: persona_record; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persona_record (
    id integer NOT NULL,
    record_id integer,
    persona_id integer
);


ALTER TABLE public.persona_record OWNER TO postgres;

--
-- Name: persona_record_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.persona_record_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.persona_record_id_seq OWNER TO postgres;

--
-- Name: persona_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.persona_record_id_seq OWNED BY public.persona_record.id;


--
-- Name: profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profile (
    id integer NOT NULL,
    site_id integer,
    code character varying,
    mix_criteria character varying,
    mix_description character varying,
    stratification_criteria character varying,
    stratification_description character varying
);


ALTER TABLE public.profile OWNER TO postgres;

--
-- Name: profile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.profile_id_seq OWNER TO postgres;

--
-- Name: profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.profile_id_seq OWNED BY public.profile.id;


--
-- Name: record; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.record (
    id integer NOT NULL,
    depth double precision,
    number integer,
    "time" timestamp without time zone,
    profile_id integer
);


ALTER TABLE public.record OWNER TO postgres;

--
-- Name: record_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.record_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.record_id_seq OWNER TO postgres;

--
-- Name: record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.record_id_seq OWNED BY public.record.id;


--
-- Name: record_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.record_metadata (
    id integer NOT NULL,
    record_id integer,
    monitoring_id integer,
    thermal_condition character varying,
    weather_id integer,
    algal_condition_id integer,
    observations character varying,
    laboratory character varying,
    arrival_time timestamp without time zone,
    departure_time timestamp without time zone,
    latitude double precision,
    longitude double precision,
    subregion_id integer
);


ALTER TABLE public.record_metadata OWNER TO postgres;

--
-- Name: record_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.record_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.record_metadata_id_seq OWNER TO postgres;

--
-- Name: record_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.record_metadata_id_seq OWNED BY public.record_metadata.id;


--
-- Name: record_shore_vegetation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.record_shore_vegetation (
    id integer NOT NULL,
    record_id integer,
    shore_vegetation_id integer
);


ALTER TABLE public.record_shore_vegetation OWNER TO postgres;

--
-- Name: record_shore_vegetation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.record_shore_vegetation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.record_shore_vegetation_id_seq OWNER TO postgres;

--
-- Name: record_shore_vegetation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.record_shore_vegetation_id_seq OWNED BY public.record_shore_vegetation.id;


--
-- Name: record_water_vegetation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.record_water_vegetation (
    id integer NOT NULL,
    record_id integer,
    water_vegetation_id integer
);


ALTER TABLE public.record_water_vegetation OWNER TO postgres;

--
-- Name: record_water_vegetation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.record_water_vegetation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.record_water_vegetation_id_seq OWNER TO postgres;

--
-- Name: record_water_vegetation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.record_water_vegetation_id_seq OWNED BY public.record_water_vegetation.id;


--
-- Name: river_gauge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.river_gauge (
    id integer NOT NULL,
    gauge double precision,
    area double precision,
    average_speed double precision,
    width double precision,
    hm double precision,
    observations character varying,
    persona_id integer,
    device_id integer
);


ALTER TABLE public.river_gauge OWNER TO postgres;

--
-- Name: river_gauge_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.river_gauge_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.river_gauge_id_seq OWNER TO postgres;

--
-- Name: river_gauge_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.river_gauge_id_seq OWNED BY public.river_gauge.id;


--
-- Name: river_record_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.river_record_metadata (
    id integer NOT NULL,
    record_id integer,
    weather_id integer,
    water_color character varying,
    river_status character varying,
    monitoring_id integer,
    river_gauge_id integer,
    observations character varying,
    laboratory character varying,
    arrival_time timestamp without time zone,
    departure_time timestamp without time zone,
    latitude double precision,
    longitude double precision,
    subregion_id integer
);


ALTER TABLE public.river_record_metadata OWNER TO postgres;

--
-- Name: river_record_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.river_record_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.river_record_metadata_id_seq OWNER TO postgres;

--
-- Name: river_record_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.river_record_metadata_id_seq OWNED BY public.river_record_metadata.id;


--
-- Name: sentence; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sentence (
    id integer NOT NULL,
    parameter_id integer,
    min_limit double precision,
    equivalence double precision,
    created_at timestamp without time zone,
    technique_id integer
);


ALTER TABLE public.sentence OWNER TO postgres;

--
-- Name: sentence_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sentence_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sentence_id_seq OWNER TO postgres;

--
-- Name: sentence_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sentence_id_seq OWNED BY public.sentence.id;


--
-- Name: shore_vegetation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shore_vegetation (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.shore_vegetation OWNER TO postgres;

--
-- Name: shore_vegetation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shore_vegetation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shore_vegetation_id_seq OWNER TO postgres;

--
-- Name: shore_vegetation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shore_vegetation_id_seq OWNED BY public.shore_vegetation.id;


--
-- Name: site; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.site (
    id integer NOT NULL,
    site character varying,
    water_body_id integer
);


ALTER TABLE public.site OWNER TO postgres;

--
-- Name: site_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.site_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.site_id_seq OWNER TO postgres;

--
-- Name: site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.site_id_seq OWNED BY public.site.id;


--
-- Name: subregion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subregion (
    id integer NOT NULL,
    code character varying,
    site_id integer NOT NULL
);


ALTER TABLE public.subregion OWNER TO postgres;

--
-- Name: subregion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subregion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subregion_id_seq OWNER TO postgres;

--
-- Name: subregion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subregion_id_seq OWNED BY public.subregion.id;


--
-- Name: technique; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.technique (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone
);


ALTER TABLE public.technique OWNER TO postgres;

--
-- Name: technique_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.technique_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.technique_id_seq OWNER TO postgres;

--
-- Name: technique_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.technique_id_seq OWNED BY public.technique.id;


--
-- Name: vegetations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vegetations (
    id integer NOT NULL,
    name text NOT NULL,
    context text NOT NULL
);


ALTER TABLE public.vegetations OWNER TO postgres;

--
-- Name: water_body; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.water_body (
    id integer NOT NULL,
    water_body_name character varying(255) NOT NULL
);


ALTER TABLE public.water_body OWNER TO postgres;

--
-- Name: water_body_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.water_body_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.water_body_id_seq OWNER TO postgres;

--
-- Name: water_body_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.water_body_id_seq OWNED BY public.water_body.id;


--
-- Name: water_vegetation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.water_vegetation (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.water_vegetation OWNER TO postgres;

--
-- Name: water_vegetation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.water_vegetation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.water_vegetation_id_seq OWNER TO postgres;

--
-- Name: water_vegetation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.water_vegetation_id_seq OWNED BY public.water_vegetation.id;


--
-- Name: weather; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weather (
    id integer NOT NULL,
    env_temp double precision,
    cloudiness character varying,
    wind_status character varying,
    wind_velocity double precision,
    precipitation character varying
);


ALTER TABLE public.weather OWNER TO postgres;

--
-- Name: weather_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.weather_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.weather_id_seq OWNER TO postgres;

--
-- Name: weather_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.weather_id_seq OWNED BY public.weather.id;


--
-- Name: algal_condition id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.algal_condition ALTER COLUMN id SET DEFAULT nextval('public.algal_condition_id_seq'::regclass);


--
-- Name: device id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device ALTER COLUMN id SET DEFAULT nextval('public.device_id_seq'::regclass);


--
-- Name: device_record id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_record ALTER COLUMN id SET DEFAULT nextval('public.device_record_id_seq'::regclass);


--
-- Name: equivalences id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equivalences ALTER COLUMN id SET DEFAULT nextval('public.equivalences_id_seq'::regclass);


--
-- Name: measurement id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.measurement ALTER COLUMN id SET DEFAULT nextval('public.measurement_id_seq'::regclass);


--
-- Name: monitoring id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitoring ALTER COLUMN id SET DEFAULT nextval('public.monitoring_id_seq'::regclass);


--
-- Name: monitoring number; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitoring ALTER COLUMN number SET DEFAULT nextval('public.monitoring_number_seq'::regclass);


--
-- Name: parameter id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter ALTER COLUMN id SET DEFAULT nextval('public.parameter_id_seq'::regclass);


--
-- Name: persona id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona ALTER COLUMN id SET DEFAULT nextval('public.persona_id_seq'::regclass);


--
-- Name: persona_record id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_record ALTER COLUMN id SET DEFAULT nextval('public.persona_record_id_seq'::regclass);


--
-- Name: profile id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile ALTER COLUMN id SET DEFAULT nextval('public.profile_id_seq'::regclass);


--
-- Name: record id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record ALTER COLUMN id SET DEFAULT nextval('public.record_id_seq'::regclass);


--
-- Name: record_metadata id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_metadata ALTER COLUMN id SET DEFAULT nextval('public.record_metadata_id_seq'::regclass);


--
-- Name: record_shore_vegetation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_shore_vegetation ALTER COLUMN id SET DEFAULT nextval('public.record_shore_vegetation_id_seq'::regclass);


--
-- Name: record_water_vegetation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_water_vegetation ALTER COLUMN id SET DEFAULT nextval('public.record_water_vegetation_id_seq'::regclass);


--
-- Name: river_gauge id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.river_gauge ALTER COLUMN id SET DEFAULT nextval('public.river_gauge_id_seq'::regclass);


--
-- Name: river_record_metadata id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.river_record_metadata ALTER COLUMN id SET DEFAULT nextval('public.river_record_metadata_id_seq'::regclass);


--
-- Name: sentence id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sentence ALTER COLUMN id SET DEFAULT nextval('public.sentence_id_seq'::regclass);


--
-- Name: shore_vegetation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shore_vegetation ALTER COLUMN id SET DEFAULT nextval('public.shore_vegetation_id_seq'::regclass);


--
-- Name: site id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site ALTER COLUMN id SET DEFAULT nextval('public.site_id_seq'::regclass);


--
-- Name: subregion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subregion ALTER COLUMN id SET DEFAULT nextval('public.subregion_id_seq'::regclass);


--
-- Name: technique id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technique ALTER COLUMN id SET DEFAULT nextval('public.technique_id_seq'::regclass);


--
-- Name: water_body id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.water_body ALTER COLUMN id SET DEFAULT nextval('public.water_body_id_seq'::regclass);


--
-- Name: water_vegetation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.water_vegetation ALTER COLUMN id SET DEFAULT nextval('public.water_vegetation_id_seq'::regclass);


--
-- Name: weather id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weather ALTER COLUMN id SET DEFAULT nextval('public.weather_id_seq'::regclass);


--
-- Data for Name: algal_condition; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.algal_condition (id, macrophytes, water_color_algal, non_algal_turbidity, appearence, blooming, odor) VALUES (9, NULL, 'Clear', NULL, NULL, NULL, 'None');


--
-- Data for Name: device; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.device (id, make, model, belonging, technique_id) VALUES (1, 'BrandX', 'X1000', 'Institute', NULL);


--
-- Data for Name: device_record; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.device_record (id, record_id, device_id, device_category) VALUES (4, 8, 1, 'Sensor');


--
-- Data for Name: equivalences; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.equivalences (id, acsa_name, ina_name) VALUES (1, 'Acsaname1', 'Inaname1');
INSERT INTO public.equivalences (id, acsa_name, ina_name) VALUES (2, 'Acsaname2', 'Inaname2');
INSERT INTO public.equivalences (id, acsa_name, ina_name) VALUES (3, 'Acsaname3', 'Inaname3');
INSERT INTO public.equivalences (id, acsa_name, ina_name) VALUES (4, 'Acsaname4', 'Inaname4');


--
-- Data for Name: measurement; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.measurement (id, record_id, parameter_id, is_cuant_limit, value) VALUES (11, 8, 1, false, 7.1);
INSERT INTO public.measurement (id, record_id, parameter_id, is_cuant_limit, value) VALUES (12, 8, 2, false, 300);
INSERT INTO public.measurement (id, record_id, parameter_id, is_cuant_limit, value) VALUES (13, 8, 3, false, 8.5);
INSERT INTO public.measurement (id, record_id, parameter_id, is_cuant_limit, value) VALUES (14, 8, 4, false, 85);
INSERT INTO public.measurement (id, record_id, parameter_id, is_cuant_limit, value) VALUES (15, 8, 5, false, 500);
INSERT INTO public.measurement (id, record_id, parameter_id, is_cuant_limit, value) VALUES (16, 8, 6, false, 18.5);
INSERT INTO public.measurement (id, record_id, parameter_id, is_cuant_limit, value) VALUES (17, 8, 7, false, 4);
INSERT INTO public.measurement (id, record_id, parameter_id, is_cuant_limit, value) VALUES (18, 8, 8, false, 20.3);


--
-- Data for Name: monitoring; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.monitoring (id, number, date, season, hydrological_year) VALUES (1, 1001, '2024-01-15', 'Winter', '2023');
INSERT INTO public.monitoring (id, number, date, season, hydrological_year) VALUES (2, 1002, '2024-07-20', 'Summer', '2024');
INSERT INTO public.monitoring (id, number, date, season, hydrological_year) VALUES (3, 1003, '2024-03-10', 'Spring', '2024');
INSERT INTO public.monitoring (id, number, date, season, hydrological_year) VALUES (4, 1004, '2024-10-05', 'Autumn', '2024');


--
-- Data for Name: parameter; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.parameter (id, name, created_at) VALUES (1, 'ph', '2024-11-11 19:46:58.971831');
INSERT INTO public.parameter (id, name, created_at) VALUES (2, 'conductivity', '2024-11-11 19:46:58.971831');
INSERT INTO public.parameter (id, name, created_at) VALUES (3, 'od', '2024-11-11 19:46:58.971831');
INSERT INTO public.parameter (id, name, created_at) VALUES (4, 'od_percentage', '2024-11-11 19:46:58.971831');
INSERT INTO public.parameter (id, name, created_at) VALUES (5, 'tds', '2024-11-11 19:46:58.971831');
INSERT INTO public.parameter (id, name, created_at) VALUES (6, 'water_temperature', '2024-11-11 19:46:58.971831');
INSERT INTO public.parameter (id, name, created_at) VALUES (7, 'turbidity', '2024-11-11 19:46:58.971831');
INSERT INTO public.parameter (id, name, created_at) VALUES (8, 'temperature', '2024-11-11 19:46:58.971831');


--
-- Data for Name: persona; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.persona (id, first_name, last_name, dni, affiliation, rol) VALUES (1, 'John', 'Doe', '12345678', 'University', NULL);


--
-- Data for Name: persona_record; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.persona_record (id, record_id, persona_id) VALUES (4, 8, 1);


--
-- Data for Name: profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.profile (id, site_id, code, mix_criteria, mix_description, stratification_criteria, stratification_description) VALUES (1, 50, 'PRF-001', 'Mixed', 'Based on sample proportions', 'None', 'Uniform water column');


--
-- Data for Name: record; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.record (id, depth, number, "time", profile_id) VALUES (8, 5, 1, '2024-11-04 09:30:00', 1);


--
-- Data for Name: record_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.record_metadata (id, record_id, monitoring_id, thermal_condition, weather_id, algal_condition_id, observations, laboratory, arrival_time, departure_time, latitude, longitude, subregion_id) VALUES (4, 8, NULL, NULL, NULL, NULL, 'Field notes about water conditions', NULL, '2024-11-04 09:30:00', '2024-11-04 10:30:00', -34.6037, -58.3816, NULL);


--
-- Data for Name: record_shore_vegetation; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: record_water_vegetation; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: river_gauge; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.river_gauge (id, gauge, area, average_speed, width, hm, observations, persona_id, device_id) VALUES (9, 2.8, 150, 1.2, 30, 10, 'Sampled near bridge', NULL, NULL);


--
-- Data for Name: river_record_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.river_record_metadata (id, record_id, weather_id, water_color, river_status, monitoring_id, river_gauge_id, observations, laboratory, arrival_time, departure_time, latitude, longitude, subregion_id) VALUES (4, 8, 9, NULL, 'Flowing', NULL, 9, 'Sampled near bridge', NULL, '2024-11-04 09:30:00', '2024-11-04 10:30:00', -34.6037, -58.3816, NULL);


--
-- Data for Name: sentence; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sentence (id, parameter_id, min_limit, equivalence, created_at, technique_id) VALUES (1, 1, 0, 14, '2024-11-11 19:47:34.930267', 1);
INSERT INTO public.sentence (id, parameter_id, min_limit, equivalence, created_at, technique_id) VALUES (2, 2, 100, 500, '2024-11-11 19:47:34.930267', 2);
INSERT INTO public.sentence (id, parameter_id, min_limit, equivalence, created_at, technique_id) VALUES (3, 3, 0, 10, '2024-11-11 19:47:34.930267', 1);
INSERT INTO public.sentence (id, parameter_id, min_limit, equivalence, created_at, technique_id) VALUES (4, 4, 0, 100, '2024-11-11 19:47:34.930267', 2);
INSERT INTO public.sentence (id, parameter_id, min_limit, equivalence, created_at, technique_id) VALUES (5, 5, 0, 1000, '2024-11-11 19:47:34.930267', 3);
INSERT INTO public.sentence (id, parameter_id, min_limit, equivalence, created_at, technique_id) VALUES (6, 6, 0, 30, '2024-11-11 19:47:34.930267', 4);
INSERT INTO public.sentence (id, parameter_id, min_limit, equivalence, created_at, technique_id) VALUES (7, 7, 0, 10, '2024-11-11 19:47:34.930267', 3);
INSERT INTO public.sentence (id, parameter_id, min_limit, equivalence, created_at, technique_id) VALUES (8, 8, 0, 25, '2024-11-11 19:47:34.930267', 4);


--
-- Data for Name: shore_vegetation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shore_vegetation (id, name) VALUES (1, 'Willow');
INSERT INTO public.shore_vegetation (id, name) VALUES (2, 'Poplar');
INSERT INTO public.shore_vegetation (id, name) VALUES (3, 'Birch');


--
-- Data for Name: site; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.site (id, site, water_body_id) VALUES (1, 'RSA', 1);
INSERT INTO public.site (id, site, water_body_id) VALUES (2, 'LSR', 2);
INSERT INTO public.site (id, site, water_body_id) VALUES (50, 'River Delta', NULL);


--
-- Data for Name: subregion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.subregion (id, code, site_id) VALUES (1, 'RSAA', 1);


--
-- Data for Name: technique; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.technique (id, name, created_at) VALUES (1, 'Sensor Calibration A', '2024-11-11 19:47:07.818422');
INSERT INTO public.technique (id, name, created_at) VALUES (2, 'Sensor Calibration B', '2024-11-11 19:47:07.818422');
INSERT INTO public.technique (id, name, created_at) VALUES (3, 'Data Logging Technique A', '2024-11-11 19:47:07.818422');
INSERT INTO public.technique (id, name, created_at) VALUES (4, 'Data Logging Technique B', '2024-11-11 19:47:07.818422');


--
-- Data for Name: vegetations; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: water_body; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.water_body (id, water_body_name) VALUES (1, 'RIO');
INSERT INTO public.water_body (id, water_body_name) VALUES (3, 'USINA');
INSERT INTO public.water_body (id, water_body_name) VALUES (2, 'LAGO');


--
-- Data for Name: water_vegetation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.water_vegetation (id, name) VALUES (1, 'Algae');
INSERT INTO public.water_vegetation (id, name) VALUES (2, 'Duckweed');
INSERT INTO public.water_vegetation (id, name) VALUES (3, 'Eelgrass');


--
-- Data for Name: weather; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.weather (id, env_temp, cloudiness, wind_status, wind_velocity, precipitation) VALUES (9, 22.5, 'Partly cloudy', 'Moderate', 5.3, 'Light rain');


--
-- Name: algal_condition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.algal_condition_id_seq', 9, true);


--
-- Name: device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.device_id_seq', 1, false);


--
-- Name: device_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.device_record_id_seq', 4, true);


--
-- Name: equivalences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equivalences_id_seq', 1, false);


--
-- Name: measurement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.measurement_id_seq', 18, true);


--
-- Name: monitoring_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monitoring_id_seq', 1, false);


--
-- Name: monitoring_number_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monitoring_number_seq', 1, false);


--
-- Name: parameter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.parameter_id_seq', 1, false);


--
-- Name: persona_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.persona_id_seq', 1, false);


--
-- Name: persona_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.persona_record_id_seq', 4, true);


--
-- Name: profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profile_id_seq', 1, true);


--
-- Name: record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.record_id_seq', 8, true);


--
-- Name: record_metadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.record_metadata_id_seq', 4, true);


--
-- Name: record_shore_vegetation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.record_shore_vegetation_id_seq', 1, false);


--
-- Name: record_water_vegetation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.record_water_vegetation_id_seq', 1, false);


--
-- Name: river_gauge_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.river_gauge_id_seq', 9, true);


--
-- Name: river_record_metadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.river_record_metadata_id_seq', 4, true);


--
-- Name: sentence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sentence_id_seq', 1, false);


--
-- Name: shore_vegetation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shore_vegetation_id_seq', 1, false);


--
-- Name: site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.site_id_seq', 2, true);


--
-- Name: subregion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subregion_id_seq', 1, true);


--
-- Name: technique_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.technique_id_seq', 1, false);


--
-- Name: water_body_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.water_body_id_seq', 1, false);


--
-- Name: water_vegetation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.water_vegetation_id_seq', 1, false);


--
-- Name: weather_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weather_id_seq', 9, true);


--
-- Name: algal_condition algal_condition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.algal_condition
    ADD CONSTRAINT algal_condition_pkey PRIMARY KEY (id);


--
-- Name: device device_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_pkey PRIMARY KEY (id);


--
-- Name: device_record device_record_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_record
    ADD CONSTRAINT device_record_pkey PRIMARY KEY (id);


--
-- Name: equivalences equivalences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equivalences
    ADD CONSTRAINT equivalences_pkey PRIMARY KEY (id);


--
-- Name: measurement measurement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.measurement
    ADD CONSTRAINT measurement_pkey PRIMARY KEY (id);


--
-- Name: monitoring monitoring_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitoring
    ADD CONSTRAINT monitoring_pkey PRIMARY KEY (id);


--
-- Name: parameter parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter
    ADD CONSTRAINT parameter_pkey PRIMARY KEY (id);


--
-- Name: persona persona_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona
    ADD CONSTRAINT persona_pkey PRIMARY KEY (id);


--
-- Name: persona_record persona_record_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_record
    ADD CONSTRAINT persona_record_pkey PRIMARY KEY (id);


--
-- Name: profile profile_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile
    ADD CONSTRAINT profile_key UNIQUE (code);


--
-- Name: profile profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile
    ADD CONSTRAINT profile_pkey PRIMARY KEY (id);


--
-- Name: record_metadata record_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_metadata
    ADD CONSTRAINT record_metadata_pkey PRIMARY KEY (id);


--
-- Name: record record_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record
    ADD CONSTRAINT record_pkey PRIMARY KEY (id);


--
-- Name: record_shore_vegetation record_shore_vegetation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_shore_vegetation
    ADD CONSTRAINT record_shore_vegetation_pkey PRIMARY KEY (id);


--
-- Name: record_water_vegetation record_water_vegetation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_water_vegetation
    ADD CONSTRAINT record_water_vegetation_pkey PRIMARY KEY (id);


--
-- Name: river_gauge river_gauge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.river_gauge
    ADD CONSTRAINT river_gauge_pkey PRIMARY KEY (id);


--
-- Name: river_record_metadata river_record_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.river_record_metadata
    ADD CONSTRAINT river_record_metadata_pkey PRIMARY KEY (id);


--
-- Name: sentence sentence_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sentence
    ADD CONSTRAINT sentence_pkey PRIMARY KEY (id);


--
-- Name: shore_vegetation shore_vegetation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shore_vegetation
    ADD CONSTRAINT shore_vegetation_pkey PRIMARY KEY (id);


--
-- Name: site site_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_key UNIQUE (site);


--
-- Name: site site_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_pkey PRIMARY KEY (id);


--
-- Name: subregion subregion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subregion
    ADD CONSTRAINT subregion_pkey PRIMARY KEY (id);


--
-- Name: technique technique_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technique
    ADD CONSTRAINT technique_pkey PRIMARY KEY (id);


--
-- Name: shore_vegetation unique_shore_vegetation_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shore_vegetation
    ADD CONSTRAINT unique_shore_vegetation_name UNIQUE (name);


--
-- Name: subregion unique_subregion_code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subregion
    ADD CONSTRAINT unique_subregion_code UNIQUE (code);


--
-- Name: water_vegetation unique_water_vegetation_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.water_vegetation
    ADD CONSTRAINT unique_water_vegetation_name UNIQUE (name);


--
-- Name: vegetations vegetations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vegetations
    ADD CONSTRAINT vegetations_pkey PRIMARY KEY (id);


--
-- Name: water_body water_body_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.water_body
    ADD CONSTRAINT water_body_pkey PRIMARY KEY (id);


--
-- Name: water_vegetation water_vegetation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.water_vegetation
    ADD CONSTRAINT water_vegetation_pkey PRIMARY KEY (id);


--
-- Name: weather weather_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weather
    ADD CONSTRAINT weather_pkey PRIMARY KEY (id);


--
-- Name: device_record device_record_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_record
    ADD CONSTRAINT device_record_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.device(id);


--
-- Name: device_record device_record_record_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_record
    ADD CONSTRAINT device_record_record_id_fkey FOREIGN KEY (record_id) REFERENCES public.record(id);


--
-- Name: device device_technique_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_technique_id_fkey FOREIGN KEY (technique_id) REFERENCES public.technique(id);


--
-- Name: measurement measurement_parameter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.measurement
    ADD CONSTRAINT measurement_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES public.parameter(id);


--
-- Name: measurement measurement_record_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.measurement
    ADD CONSTRAINT measurement_record_id_fkey FOREIGN KEY (record_id) REFERENCES public.record(id);


--
-- Name: persona_record persona_record_persona_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_record
    ADD CONSTRAINT persona_record_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.persona(id);


--
-- Name: persona_record persona_record_record_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_record
    ADD CONSTRAINT persona_record_record_id_fkey FOREIGN KEY (record_id) REFERENCES public.record(id);


--
-- Name: profile profile_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile
    ADD CONSTRAINT profile_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.site(id);


--
-- Name: record_metadata record_metadata_algal_condition_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_metadata
    ADD CONSTRAINT record_metadata_algal_condition_id_fkey FOREIGN KEY (algal_condition_id) REFERENCES public.algal_condition(id);


--
-- Name: record_metadata record_metadata_monitoring_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_metadata
    ADD CONSTRAINT record_metadata_monitoring_id_fkey FOREIGN KEY (monitoring_id) REFERENCES public.monitoring(id);


--
-- Name: record_metadata record_metadata_record_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_metadata
    ADD CONSTRAINT record_metadata_record_id_fkey FOREIGN KEY (record_id) REFERENCES public.record(id);


--
-- Name: record_metadata record_metadata_subregion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_metadata
    ADD CONSTRAINT record_metadata_subregion_id_fkey FOREIGN KEY (subregion_id) REFERENCES public.subregion(id);


--
-- Name: record_metadata record_metadata_weather_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_metadata
    ADD CONSTRAINT record_metadata_weather_id_fkey FOREIGN KEY (weather_id) REFERENCES public.weather(id);


--
-- Name: record record_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record
    ADD CONSTRAINT record_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profile(id);


--
-- Name: record_shore_vegetation record_shore_vegetation_record_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_shore_vegetation
    ADD CONSTRAINT record_shore_vegetation_record_id_fkey FOREIGN KEY (record_id) REFERENCES public.record(id);


--
-- Name: record_shore_vegetation record_shore_vegetation_shore_vegetation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_shore_vegetation
    ADD CONSTRAINT record_shore_vegetation_shore_vegetation_id_fkey FOREIGN KEY (shore_vegetation_id) REFERENCES public.shore_vegetation(id);


--
-- Name: record_water_vegetation record_water_vegetation_record_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_water_vegetation
    ADD CONSTRAINT record_water_vegetation_record_id_fkey FOREIGN KEY (record_id) REFERENCES public.record(id);


--
-- Name: record_water_vegetation record_water_vegetation_water_vegetation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_water_vegetation
    ADD CONSTRAINT record_water_vegetation_water_vegetation_id_fkey FOREIGN KEY (water_vegetation_id) REFERENCES public.water_vegetation(id);


--
-- Name: river_gauge river_gauge_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.river_gauge
    ADD CONSTRAINT river_gauge_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.device(id);


--
-- Name: river_gauge river_gauge_persona_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.river_gauge
    ADD CONSTRAINT river_gauge_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.persona(id);


--
-- Name: river_record_metadata river_record_metadata_monitoring_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.river_record_metadata
    ADD CONSTRAINT river_record_metadata_monitoring_id_fkey FOREIGN KEY (monitoring_id) REFERENCES public.monitoring(id);


--
-- Name: river_record_metadata river_record_metadata_record_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.river_record_metadata
    ADD CONSTRAINT river_record_metadata_record_id_fkey FOREIGN KEY (record_id) REFERENCES public.record(id);


--
-- Name: river_record_metadata river_record_metadata_river_gauge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.river_record_metadata
    ADD CONSTRAINT river_record_metadata_river_gauge_id_fkey FOREIGN KEY (river_gauge_id) REFERENCES public.river_gauge(id);


--
-- Name: river_record_metadata river_record_metadata_subregion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.river_record_metadata
    ADD CONSTRAINT river_record_metadata_subregion_id_fkey FOREIGN KEY (subregion_id) REFERENCES public.subregion(id);


--
-- Name: river_record_metadata river_record_metadata_weather_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.river_record_metadata
    ADD CONSTRAINT river_record_metadata_weather_id_fkey FOREIGN KEY (weather_id) REFERENCES public.weather(id);


--
-- Name: sentence sentence_parameter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sentence
    ADD CONSTRAINT sentence_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES public.parameter(id);


--
-- Name: sentence sentence_technique_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sentence
    ADD CONSTRAINT sentence_technique_id_fkey FOREIGN KEY (technique_id) REFERENCES public.technique(id);


--
-- Name: site site_water_body_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_water_body_id_fkey FOREIGN KEY (water_body_id) REFERENCES public.water_body(id);


--
-- Name: subregion subregion_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subregion
    ADD CONSTRAINT subregion_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.site(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

