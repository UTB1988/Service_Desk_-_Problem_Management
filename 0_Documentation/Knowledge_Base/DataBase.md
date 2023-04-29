
`SERIAL` - BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE

### application

field|data type|null|unique|default|PK|FK|check|comment
-|-|-|-|-|-|-|-|-
id|BIGINT<br>UNSIGNED<br>AUTO_INCREMENT|NOT NULL|YES|-|YES|-|-|-
applicant_name|VARCHAR(25)|NOT NULL|-|'Аноним'|-|-|-|-
applicant_phone|VARCHAR(25)|NULL|-|-|-|-|-|-
applicant_email|VARCHAR(50)|NULL|-|-|-|-|-|-
description|VARCHAR(250)|NOT NULL|-|-|-|-|-|-
dt_create|TIMESTAMP|NOT NULL|-|-|-|-|-|-
dt_update|TIMESTAMP|NOT NULL|-|-|-|-|-|-

### issue_application_relation

field|data type|null|unique|default|PK|FK|check|comment
-|-|-|-|-|-|-|-|-
issue_id|BIGINT<br>UNSIGNED|NOT NULL|YES|-|-|issue_header.id|-|-
related_application_id|BIGINT<br>UNSIGNED|NOT NULL|YES|-|-|application.id|-|-

### application_person_relation

field|data type|null|unique|default|PK|FK|check|comment
-|-|-|-|-|-|-|-|-
application_id|BIGINT<br>UNSIGNED|NOT NULL|YES|-|-|application.id|-|-
related_person_id|BIGINT<br>UNSIGNED|NOT NULL|YES|-|-|person.id|-|-
role_id|BIGINT<br>UNSIGNED|NOT NULL|YES|-|-|role_dict.id|-|-

### department

field|data type|null|unique|default|PK|FK|check|comment
-|-|-|-|-|-|-|-|-
id|BIGINT<br>UNSIGNED<br>AUTO_INCREMENT|NOT NULL|YES|-|YES|-|-|-
name|VARCHAR(100)|NOT NULL|YES|-|-|-|-|-
status|TINYINT(1)<br>UNSIGNED|NOT NULL|-|-|-|-|status IN (0, 1)|0 - Действует;<br>1 - Упразднён;
dt_create|TIMESTAMP|NOT NULL|-|-|-|-|-|-
dt_update|TIMESTAMP|NOT NULL|-|-|-|-|-|-

### department_structure

field|data type|null|unique|default|PK|FK|check|comment
-|-|-|-|-|-|-|-|-
parent_department_id|BIGINT<br>UNSIGNED|NOT NULL|YES|-|-|department.id|parent_department_id != child_department_id|-
child_department_id|BIGINT<br>UNSIGNED|NOT NULL|YES|-|-|department.id|-|-

### employee

field|data type|null|unique|default|PK|FK|check|comment
-|-|-|-|-|-|-|-|-
person_id|BIGINT<br>UNSIGNED|NOT NULL|YES|-|-|person.id|-|-
phone|VARCHAR(25)|NOT NULL|-|-|-|-|-|-
email|VARCHAR(50)|NOT NULL|-|-|-|-|-|-
department_id|BIGINT<br>UNSIGNED|NOT NULL|YES|-|-|department.id|-|-
position|VARCHAR(50)|NOT NULL|-|-|-|-|-|-
status|TINYINT<br>UNSIGNED|NOT NULL|-|-|-|-|status IN (1, 2, 3)|1 - Работает;<br>2 - Отпуск;<br>3 - Уволен;
dt_create|TIMESTAMP|NOT NULL|-|-|-|-|-|-
dt_update|TIMESTAMP|NOT NULL|-|-|-|-|-|-

### issue_details

field|data type|null|unique|default|PK|FK|check|comment
-|-|-|-|-|-|-|-|-
issue_id|BIGINT<br>UNSIGNED|NOT NULL|YES|-|-|issue_header.id|-|-
description|TEXT|NOT NULL|-|-|-|-|-|-

### issue_header

field|data type|null|unique|default|PK|FK|check|comment
-|-|-|-|-|-|-|-|-
id|BIGINT<br>UNSIGNED<br>AUTO_INCREMENT|NOT NULL|YES|-|YES|-|-|-
issue_type|TINYINT<br>UNSIGNED|NOT NULL|-|-|-|-|issue_type IN (1, 2, 3)|1 - Вопрос;<br>2 - Проблема;<br>3 - Предложение изменения;
dt_create|TIMESTAMP|NOT NULL|-|-|-|-|-|-
dt_update|TIMESTAMP|NOT NULL|-|-|-|-|-|-

### issue_person_relation

field|data type|null|unique|default|PK|FK|check|comment
-|-|-|-|-|-|-|-|-
issue_id|BIGINT<br>UNSIGNED|NOT NULL|YES|-|-|issue_header.id|-|-
related_person_id|BIGINT<br>UNSIGNED|NOT NULL|YES|-|-|person.id|-|-
role_id|BIGINT<br>UNSIGNED|NOT NULL|YES|-|-|role_dict.id|-|-

### person

field|data type|null|unique|default|PK|FK|check|comment
-|-|-|-|-|-|-|-|-
id|BIGINT<br>UNSIGNED<br>AUTO_INCREMENT|NOT NULL|YES|-|YES|-|-|-
first_name|VARCHAR(25)|NOT NULL|YES|-|-|-|-|-
middle_name|VARCHAR(25)|NULL|YES|-|-|-|-|-
last_name|VARCHAR(25)|NOT NULL|-|-|-|-|-|-
patronymic_name|VARCHAR(25)|NULL|-|-|-|-|-|-
birth_date|DATE|NULL|YES|-|-|-|-|-
dt_create|TIMESTAMP|NOT NULL|-|-|-|-|-|-
dt_update|TIMESTAMP|NOT NULL|-|-|-|-|-|-

### person_email

field|data type|null|unique|default|PK|FK|check|comment
-|-|-|-|-|-|-|-|-
person_id|BIGINT<br>UNSIGNED|NOT NULL|-|-|-|person.id|-|-
email|VARCHAR(50)|NOT NULL|-|-|-|-|-|-

### person_phone

field|data type|null|unique|default|PK|FK|check|comment
-|-|-|-|-|-|-|-|-
person_id|BIGINT<br>UNSIGNED|NOT NULL|-|-|-|person.id|-|-
country_code|VARCHAR(5)|NOT NULL|-|-|-|-|-|-
area_code|VARCHAR(10)|NOT NULL|-|-|-|-|-|-
phone_number|VARCHAR(15)|NOT NULL|-|-|-|-|-|-

### role_dict

field|data type|null|unique|default|PK|FK|check|comment
-|-|-|-|-|-|-|-|-
id|BIGINT<br>UNSIGNED<br>AUTO_INCREMENT|NOT NULL|YES|-|YES|-|-|-
role|VARCHAR(50)|NOT NULL|-|-|-|-|-|-
description|VARCHAR(250)|NULL|-|-|-|-|-|-







