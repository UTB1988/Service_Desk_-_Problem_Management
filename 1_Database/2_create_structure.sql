USE ServiceDesk;

DROP TABLE IF EXISTS application;
CREATE TABLE IF NOT EXISTS application (
	id SERIAL PRIMARY KEY
	, applicant_name VARCHAR(25) NOT NULL DEFAULT 'Аноним'
	, applicant_phone VARCHAR(25) NULL
	, applicant_email VARCHAR(50) NULL
	, description VARCHAR(250) NOT NULL
	, dt_create TIMESTAMP NOT NULL
	, dt_update TIMESTAMP NOT NULL);

DROP TABLE IF EXISTS issue_header;
CREATE TABLE IF NOT EXISTS issue_header (
	id SERIAL PRIMARY KEY
	, issue_type TINYINT UNSIGNED NOT NULL CHECK (issue_type IN (1, 2, 3)) COMMENT '1 - Вопрос; 2 - Проблема; 3 - Предложение изменения'
	, dt_create TIMESTAMP NOT NULL
	, dt_update TIMESTAMP NOT NULL);

DROP TABLE IF EXISTS issue_details;
CREATE TABLE IF NOT EXISTS issue_details (
	issue_id BIGINT UNSIGNED NOT NULL UNIQUE
	, description TEXT NOT NULL
    , FOREIGN KEY (issue_id) REFERENCES issue_header(id));

DROP TABLE IF EXISTS issue_application_relation;
CREATE TABLE IF NOT EXISTS issue_application_relation (
	issue_id BIGINT UNSIGNED NOT NULL
    , related_application_id BIGINT UNSIGNED NOT NULL
    , CONSTRAINT UC_AIR UNIQUE (issue_id, related_application_id)
    , FOREIGN KEY (issue_id) REFERENCES issue_header(id)
    , FOREIGN KEY (related_application_id) REFERENCES application(id));

DROP TABLE IF EXISTS person;
CREATE TABLE IF NOT EXISTS person (
	id SERIAL PRIMARY KEY
	, first_name VARCHAR(25) NOT NULL
	, middle_name VARCHAR(25) NULL
	, last_name VARCHAR(25) NOT NULL
	, patronymic_name VARCHAR(25) NULL
    , birth_date DATE NULL
	, dt_create TIMESTAMP NOT NULL
	, dt_update TIMESTAMP NOT NULL
    , CONSTRAINT UC_FLD UNIQUE (first_name, last_name, birth_date));

DROP TABLE IF EXISTS person_phone;
CREATE TABLE IF NOT EXISTS person_phone (
	person_id BIGINT UNSIGNED NOT NULL
	, country_code VARCHAR(5) NOT NULL
	, area_code VARCHAR(10) NOT NULL
	, phone_number VARCHAR(15) NOT NULL
    , FOREIGN KEY (person_id) REFERENCES person(id));

DROP TABLE IF EXISTS person_email;
CREATE TABLE IF NOT EXISTS person_email (
	person_id BIGINT UNSIGNED NOT NULL
	, email VARCHAR(50) NOT NULL
    , FOREIGN KEY (person_id) REFERENCES person(id));

DROP TABLE IF EXISTS department;
CREATE TABLE IF NOT EXISTS department (
	id SERIAL PRIMARY KEY
	, name VARCHAR(100) NOT NULL UNIQUE
    , status TINYINT(1) UNSIGNED NOT NULL CHECK (status IN (0, 1)) COMMENT '0 - Действует; 1 - Упразднён;'
    , dt_create TIMESTAMP NOT NULL
	, dt_update TIMESTAMP NOT NULL);

DROP TABLE IF EXISTS department_structure;
CREATE TABLE IF NOT EXISTS department_structure (
	parent_department_id BIGINT UNSIGNED NOT NULL
	, child_department_id BIGINT UNSIGNED NOT NULL
    , CONSTRAINT UC_DS UNIQUE (parent_department_id, child_department_id)
    , CHECK (parent_department_id != child_department_id)
    , FOREIGN KEY (parent_department_id) REFERENCES department(id)
    , FOREIGN KEY (child_department_id) REFERENCES department(id));

DROP TABLE IF EXISTS employee;
CREATE TABLE IF NOT EXISTS employee (
	person_id BIGINT UNSIGNED NOT NULL
	, phone VARCHAR(25) NOT NULL
	, email VARCHAR(50) NOT NULL
	, department_id BIGINT UNSIGNED NOT NULL
    , position VARCHAR(50) NOT NULL
	, status TINYINT UNSIGNED NOT NULL CHECK (status IN (1, 2, 3)) COMMENT '1 - Работает; 2 - Отпуск; 3 - Уволен'
    , dt_create TIMESTAMP NOT NULL
	, dt_update TIMESTAMP NOT NULL
    , CONSTRAINT UC_PD UNIQUE (person_id, department_id)
    , FOREIGN KEY (person_id) REFERENCES person(id)
    , FOREIGN KEY (department_id) REFERENCES department(id));

DROP TABLE IF EXISTS role_dict;
CREATE TABLE IF NOT EXISTS role_dict (
	id SERIAL PRIMARY KEY
    , role VARCHAR(50) NOT NULL
    , description VARCHAR(250) NULL);

DROP TABLE IF EXISTS application_person_relation;
CREATE TABLE IF NOT EXISTS application_person_relation (
	application_id BIGINT UNSIGNED NOT NULL
    , related_person_id BIGINT UNSIGNED NOT NULL
    , role_id BIGINT UNSIGNED NOT NULL
    , CONSTRAINT UC_APR UNIQUE (application_id, related_person_id, role_id)
    , FOREIGN KEY (application_id) REFERENCES application(id)
    , FOREIGN KEY (related_person_id) REFERENCES person(id)
    , FOREIGN KEY (role_id) REFERENCES role_dict(id));

DROP TABLE IF EXISTS issue_person_relation;
CREATE TABLE IF NOT EXISTS issue_person_relation (
	issue_id BIGINT UNSIGNED NOT NULL
	, related_person_id BIGINT UNSIGNED NOT NULL
    , role_id BIGINT UNSIGNED NOT NULL
	, CONSTRAINT UC_IPR UNIQUE (issue_id, related_person_id, role_id)
	, FOREIGN KEY (issue_id) REFERENCES issue_header(id)
	, FOREIGN KEY (related_person_id) REFERENCES person(id)
	, FOREIGN KEY (role_id) REFERENCES role_dict(id));
