create database clampacm;
CREATE USER 'policy'@'%' IDENTIFIED BY 'P01icY';
GRANT ALL PRIVILEGES ON clampacm.* TO 'policy'@'%';
