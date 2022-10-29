-- Borrar índices creados
 DROP INDEX employees_idx_names on employees;
 DROP INDEX employees_idx_names on last_title;
 DROP INDEX employees_idx_names on last_salary;
-- Borrar tablas creadas 
 DROP TABLE last_salary;
 DROP TABLE last_title;
 DROP TABLE same_dept;
 DROP TABLE other_salary;
 DROP TABLE current_dept_emp;

-- Materializar vistas con tablas
-- Crear tabla last_salary
CREATE TABLE last_salary
( 
   emp_no INT(11) PRIMARY KEY,
   first_name VARCHAR(29),
   last_name VARCHAR(20),
   gender ENUM ('M','F'), 
   hire_date DATE, 
   salary INT,
   from_date DATE,
   to_date DATE
);
-- Inserción de datos
INSERT INTO last_salary
SELECT * FROM last_salary;

-- Procedure
/*CREATE PROCEDURE last_salary_refresh ( 
    OUT result INT
)
BEGIN
     -- borrar la tabla last_salary 
     truncate last_salary ;
   
     -- insertar los datos de la Vista en la tabla 
     INSERT INTO last_salary
          SELECT * FROM last_salary ;
       
	 SET result = 0;
END;
$$$
DELIMITER ;
CALL last_salary_refresh(@result);*/

-- Vista materializada de el último carggo de los empleados
CREATE TABLE last_title
( 
   emp_no INT(11),
   first_name VARCHAR(20),
   last_name VARCHAR(20),
   gender ENUM ('M','F'), 
   hire_date DATE, 
   title VARCHAR(45),
   from_date DATE,
   to_date DATE
);
-- Inserción de datos
INSERT INTO last_title
SELECT * FROM last_title;
-- Procedure
/*CREATE PROCEDURE last_title_refresh ( 
    OUT result INT
)
BEGIN
     -- borrar la tabla last_title 
     truncate last_title ;
   
     -- insertar los datos de la vista
     INSERT INTO last_title
          SELECT * FROM last_title ;
       
	 SET result = 0;
END;
$$$
DELIMITER ;
CALL last_salary_refresh(@result);*/

-- View materializada de personas que pertenecen a el mismo departamento de las personas que ganan 
CREATE TABLE same_dept
( 
   emp_no INT(11) PRIMARY KEY,
   first_name VARCHAR(20),
   last_name VARCHAR(20),
   dept_no CHAR(4)
);
-- Inserción de datos 
INSERT INTO same_dept
SELECT * FROM same_dept;
-- Procedure
/*CREATE PROCEDURE same_dept_refresh ( 
    OUT result INT
)
BEGIN
     -- borrar la tabla
     truncate same_dept ;
   
     -- insertar los datos de la vista
     INSERT INTO same_dept
          SELECT * FROM same_dept ;
       
	 SET result = 0;
END;
$$$
DELIMITER ;
CALL last_salary_refresh(@result);*/
-- Vista materializada de personas que ganarón más que x persona
CREATE TABLE other_salary
( 
   emp_no INT(10) PRIMARY KEY,
   first_name VARCHAR(20),
   last_name VARCHAR(20),
   salary INT
);
-- Inserción de datos
INSERT INTO other_salary
SELECT * FROM more_salary;
-- Procedure
/*CREATE PROCEDURE other_salary_refresh ( 
    OUT result INT
)
BEGIN
     -- borrar la tabla
     truncate other_salary ;
   
     -- insertar los datos de la vista
     INSERT INTO other_salary
          SELECT * FROM more_salary ;
       
	 SET result = 0;
END;
$$$
DELIMITER ;
CALL last_salary_refresh(@result);*/
-- Vista materializada de último departamento por persona
CREATE TABLE current_dept_emp
( 
   emp_no INT(10) PRIMARY KEY,
   dept_no CHAR (4),
   from_date date,
   to_date date
);
-- Insertar datos
INSERT INTO current_dept_emp
SELECT * FROM current_dept_emp;
-- Procedure
/*CREATE PROCEDURE current_dept_emp_refresh ( 
    OUT result INT
)
BEGIN
     -- borrar la tabla
     truncate current_dept_emp ;
   
     -- insertar los datos de la vista
     INSERT INTO current_dept_emp
          SELECT * FROM current_dept_emp ;
       
	 SET result = 0;
END;
$$$
DELIMITER ;
CALL last_salary_refresh(@result);*/
-- Creación de índices
CREATE INDEX employees_idx_names ON employees(first_name, last_name);
CREATE INDEX employees_idx_names ON last_title (first_name, last_name);
CREATE INDEX employees_idx_names ON last_salary (first_name, last_name);