CREATE USER app_user password 'password';
CREATE DATABASE app_db WITH OWNER app_user  ENCODING 'UTF8'  LC_COLLATE = 'ru_RU.UTF-8'  LC_CTYPE = 'ru_RU.UTF-8' TEMPLATE = template0;
CREATE DATABASE app_db_test WITH OWNER app_user  ENCODING 'UTF8'  LC_COLLATE = 'ru_RU.UTF-8'  LC_CTYPE = 'ru_RU.UTF-8' TEMPLATE = template0;
