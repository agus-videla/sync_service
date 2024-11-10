create table algal_condition
(
    id                  serial
        primary key,
    macrophytes         varchar,
    water_color_algal   varchar,
    non_algal_turbidity varchar,
    appearence          varchar,
    blooming            varchar,
    odor                varchar
);

alter table algal_condition
    owner to postgres;

create table equivalences
(
    id        serial
        primary key,
    acsa_name varchar,
    ina_name  varchar
);

alter table equivalences
    owner to postgres;

create table monitoring
(
    id                serial
        primary key,
    number            serial,
    date              date,
    season            varchar,
    hydrological_year varchar
);

alter table monitoring
    owner to postgres;

create table parameter
(
    id         serial
        primary key,
    name       varchar,
    created_at timestamp
);

alter table parameter
    owner to postgres;

create table technique
(
    id         serial
        primary key,
    name       varchar,
    created_at timestamp
);

alter table technique
    owner to postgres;

create table sentence
(
    id           serial
        primary key,
    parameter_id integer
        references parameter,
    min_limit    double precision,
    equivalence  double precision,
    created_at   timestamp,
    technique_id integer
        references technique
);

alter table sentence
    owner to postgres;

create table weather
(
    id            serial
        primary key,
    env_temp      double precision,
    cloudiness    varchar,
    wind_status   varchar,
    wind_velocity double precision,
    precipitation varchar
);

alter table weather
    owner to postgres;

create table device
(
    id           serial
        primary key,
    make         varchar not null,
    model        varchar not null,
    belonging    varchar,
    technique_id integer
        references technique
);

alter table device
    owner to postgres;

create table persona
(
    id         serial
        primary key,
    first_name varchar,
    last_name  varchar,
    dni        varchar,
    filiation  varchar,
    rol        varchar
);

alter table persona
    owner to postgres;

create table river_gauge
(
    id            serial
        primary key,
    gauge         double precision,
    area          double precision,
    average_speed double precision,
    width         double precision,
    hm            double precision,
    observations  varchar,
    persona_id    integer
        references persona,
    device_id     integer
        references device
);

alter table river_gauge
    owner to postgres;

create table shore_vegetation
(
    id   serial
        primary key,
    name varchar
        constraint unique_shore_vegetation_name
            unique
);

alter table shore_vegetation
    owner to postgres;

create table water_vegetation
(
    id   serial
        primary key,
    name varchar
        constraint unique_water_vegetation_name
            unique
);

alter table water_vegetation
    owner to postgres;

create table water_body
(
    id              serial
        primary key,
    water_body_name varchar(255) not null
);

alter table water_body
    owner to postgres;

create table site
(
    id            serial
        primary key,
    site          varchar
        constraint site_key
            unique,
    water_body_id integer
        references water_body
);

alter table site
    owner to postgres;

create table profile
(
    id                         serial
        primary key,
    site_id                    integer
        references site,
    code                       varchar
        constraint profile_key
            unique,
    mix_criteria               varchar,
    mix_description            varchar,
    stratification_criteria    varchar,
    stratification_description varchar
);

alter table profile
    owner to postgres;

create table subregion
(
    id      serial
        primary key,
    code    varchar
        constraint unique_subregion_code
            unique,
    site_id integer not null
        references site
            on delete cascade
);

alter table subregion
    owner to postgres;

create table record
(
    id         serial
        primary key,
    depth      double precision,
    number     integer,
    time       time,
    profile_id integer
        references profile
);

alter table record
    owner to postgres;

create table record_metadata
(
    id                 serial
        primary key,
    record_id          integer
        references record,
    monitoring_id      integer
        references monitoring,
    thermal_condition  varchar,
    weather_id         integer
        references weather,
    algal_condition_id integer
        references algal_condition,
    observations       varchar,
    laboratory         varchar,
    arrival_time       time,
    departure_time     time,
    latitude           double precision,
    longitude          double precision,
    subregion_id       integer
        references subregion
);

alter table record_metadata
    owner to postgres;

create table river_record_metadata
(
    id             serial
        primary key,
    record_id      integer
        references record,
    weather_id     integer
        references weather,
    water_color    varchar,
    river_status   varchar,
    monitoring_id  integer
        references monitoring,
    river_gauge_id integer
        references river_gauge,
    observations   varchar,
    laboratory     varchar,
    arrival_time   time,
    departure_time time,
    latitude       double precision,
    longitude      double precision,
    subregion_id   integer
        references subregion
);

alter table river_record_metadata
    owner to postgres;

create table measurement
(
    id             serial
        primary key,
    record_id      integer
        references record,
    parameter_id   integer
        references parameter,
    is_cuant_limit boolean,
    value          double precision
);

alter table measurement
    owner to postgres;

create table record_shore_vegetation
(
    id                  serial
        primary key,
    record_id           integer
        references record,
    shore_vegetation_id integer
        references shore_vegetation
);

alter table record_shore_vegetation
    owner to postgres;

create table record_water_vegetation
(
    id                  serial
        primary key,
    record_id           integer
        references record,
    water_vegetation_id integer
        references water_vegetation
);

alter table record_water_vegetation
    owner to postgres;

create table device_record
(
    id              serial
        primary key,
    record_id       integer
        references record,
    device_id       integer
        references device,
    device_category varchar
);

alter table device_record
    owner to postgres;

create table persona_record
(
    id         serial
        primary key,
    record_id  integer
        references record,
    persona_id integer
        references persona
);

alter table persona_record
    owner to postgres;

