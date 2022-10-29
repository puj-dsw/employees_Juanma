DROP VIEW last_salary;
DROP VIEW last_title;
DROP VIEW more_salary;
DROP VIEW same_dept;


-- 1) Consulta con el último cargo de una persona específica
--   P.ej. El último cargo de "Elvis Demeyer"
-- _____________________________________________________________________________________________________________
-- crea vistas materializadas para optimizar la Consulta
CREATE OR REPLACE VIEW a_salaries AS
SELECT emp_no , from_date, to_date
FROM salaries
ORDER BY emp_no, to_date DESC;

-- CREATE INDEX idx_a_salaries_emp_no
-- ON salaries (emp_no);
-- _____________________________________________________________________________________________________________
select s.emp_no, s.from_date, s.to_date, elvis.first_name, elvis.last_name
from salaries s
join (select emp_no,max(from_date) from_date ,max(to_date) to_date from salaries group by emp_no) ult_fecha
on s.emp_no = ult_fecha.emp_no and s.from_date = ult_fecha.from_date and s.to_date = ult_fecha.to_date 
join (select emp_no, first_name, last_name from employees where first_name = "Elvis" and last_name = "Demeyer") elvis
on elvis.emp_no = s.emp_no;


-- 2) Consulta con el último salario de una persona específica
-- _____________________________________________________________________________________________________________
-- crear vistas para mostrar el último cargo y salario de cada personas junto con su nombre y apellido
--crear indices para las vistas creadas en el punto anterior para mejorar el rendimiento de las consultas
-- _____________________________________________________________________________________________________________
CREATE OR REPLACE VIEW b_salaries AS
SELECT emp_no, salary, from_date, to_date
FROM salaries
ORDER BY emp_no, to_date DESC;

-- CREATE INDEX idx_b_salaries_emp_no
-- ON salaries (emp_no);
-- _____________________________________________________________________________________________________________
select s.emp_no, s.salary, s.from_date, s.to_date, elvis.first_name, elvis.last_name
from salaries s
join (select emp_no,max(from_date) from_date ,max(to_date) to_date from salaries group by emp_no) ult_fecha
on s.emp_no = ult_fecha.emp_no and s.from_date = ult_fecha.from_date and s.to_date = ult_fecha.to_date 
join (select emp_no, first_name, last_name from employees where first_name = "Elvis" and last_name = "Demeyer") elvis
on elvis.emp_no = s.emp_no;


-- 3) Consulta con todas las personas, mostrando su último cargo y salario
-- crear vistas para mostrar el último cargo y salario de cada personas junto con su nombre y apellido
-- crear indices para las vistas creadas en el punto anterior para mejorar el rendimiento de las consultas
-- _____________________________________________________________________________________________________________
CREATE OR REPLACE VIEW c_salaries_date AS
SELECT emp_no , from_date, to_date
FROM salaries
ORDER BY emp_no, to_date DESC;



CREATE OR REPLACE VIEW c_salaries_salary AS
SELECT emp_no , salary
FROM salaries
ORDER BY emp_no, to_date DESC;

-- _____________________________________________________________________________________________________________
-- CREATE INDEX idx_c_salaries_emp_no
-- ON salaries (emp_no);

-- CREATE INDEX idx_c_salaries_date
-- ON salaries (from_date, to_date);

-- _____________________________________________________________________________________________________________
select s.emp_no, s.salary, s.from_date, s.to_date, employees.first_name,  employees.last_name
from salaries s
join (select emp_no,max(from_date) from_date ,max(to_date) to_date from salaries group by emp_no) ult_fecha
on s.emp_no = ult_fecha.emp_no and s.from_date = ult_fecha.from_date and s.to_date = ult_fecha.to_date 
join (select emp_no, first_name, last_name from employees ) employees
on employees.emp_no = s.emp_no;

-- _____________________________________________________________________________________________________________
-- 4) Consulta con todas las personas que hoy ganan más salario que una persona específica
--  p.ej, todas las personas que ganan más que "Elvis Demeyer"

CREATE OR REPLACE VIEW  c_salaries_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM salaries
    GROUP BY emp_no;

CREATE OR REPLACE VIEW c_current_salaries AS
    SELECT l.emp_no, salary, l.from_date, l.to_date
    FROM salaries s
        INNER JOIN c_salaries_latest_date l
        ON s.emp_no=l.emp_no AND s.from_date=l.from_date AND l.to_date = s.to_date;

CREATE OR REPLACE VIEW c_current_salaries_elvis AS
    SELECT s.emp_no, s.salary, s.from_date, s.to_date
    FROM c_current_salaries s
        INNER JOIN employees e
        ON s.emp_no=e.emp_no AND e.first_name = "Elvis" AND e.last_name = "Demeyer";
-- _____________________________________________________________________________________________________________

SELECT e.first_name, e.last_name, s.salary
FROM c_current_salaries s
    INNER JOIN employees e
    ON s.emp_no=e.emp_no AND s.salary > (SELECT salary FROM c_current_salaries_elvis);
-- _____________________________________________________________________________________________________________
-- 5) Consulta con el último departamento donde trabaja una persona específica
--  p.ej. el último departamento donde trabajo "Elvis Demeyer"
-- _____________________________________________________________________________________________________________
CREATE OR REPLACE VIEW dept_emp_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp
    GROUP BY emp_no;

CREATE OR REPLACE VIEW current_dept_emp AS
    SELECT l.emp_no, dept_no, l.from_date, l.to_date
    FROM dept_emp d
        INNER JOIN dept_emp_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;

     -- _____________________________________________________________________________________________________________   

-- crear indices para mejorar la consulta anterior

-- CREATE INDEX e_idx_emp_no ON dept_emp (emp_no);
-- CREATE INDEX e_idx_dept_no ON dept_emp (dept_no);
-- CREATE INDEX e_idx_from_date ON dept_emp (from_date);
-- CREATE INDEX e_idx_to_date ON dept_emp (to_date);

-- _____________________________________________________________________________________________________________
SELECT e.emp_no, e.first_name, e.last_name, d.dept_name, de.from_date, de.to_date
FROM employees e
INNER JOIN current_dept_emp de
ON e.emp_no = de.emp_no
INNER JOIN departments d
ON de.dept_no = d.dept_no
where first_name = "Elvis" and last_name = "Demeyer";

-- _____________________________________________________________________________________________________________
--6) Consulta con todas las personas que trabajan en el mismo departamento de una persona específica
--  p.ej, todas las personas que trabajan en el mismo departamento que "Elvis Demeyer"
-- _____________________________________________________________________________________________________________

CREATE OR REPLACE VIEW salary_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM salaries
    GROUP BY emp_no;

CREATE OR REPLACE VIEW title_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM titles
    GROUP BY emp_no;

CREATE OR REPLACE VIEW dept_emp_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp
    GROUP BY emp_no;


CREATE OR REPLACE VIEW current_title AS
    SELECT l.emp_no , title, l.from_date, l.to_date
    FROM titles d
        INNER JOIN title_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;

CREATE OR REPLACE VIEW current_salary AS
    SELECT l.emp_no, salary, l.from_date, l.to_date
    FROM salaries s
        INNER JOIN salary_latest_date l
        ON s.emp_no=l.emp_no 
        AND s.from_date=l.from_date 
        AND l.to_date = s.to_date ;

-- _____________________________________________________________________________________________________________

SELECT dept_others.*
    FROM (
        SELECT emp.first_name, emp.last_name, dept.dept_no
            FROM current_dept_emp AS dept
            JOIN employees AS emp
               ON dept.emp_no = emp.emp_no
            WHERE emp.first_name="Elvis" and emp.last_name="Demeyer"
    ) as dept_elvis,
     (
        SELECT emp.first_name, emp.last_name, dept.dept_no
            FROM current_dept_emp AS dept
            JOIN employees AS emp
               ON dept.emp_no = emp.emp_no
    ) as dept_others
    WHERE dept_others.dept_no = dept_elvis.dept_no
limit 10;

-- _____________________________________________________________________________________________________________

-- Consulta 7
-- Crear vistas de las consultas 4 y 6
CREATE OR REPLACE VIEW more_salary AS
SELECT salary_others.*
    FROM (
        SELECT sal.emp_no, sal.first_name, sal.last_name, sal.salary
            FROM last_salary AS sal 
		WHERE sal.first_name="Elvis" AND sal.last_name="Demeyer"
    ) AS salary_elvis,
    (
        SELECT sal.emp_no, sal.first_name, sal.last_name, sal.salary
            FROM last_salary AS sal 
    ) AS salary_others
WHERE salary_others.salary > salary_elvis.salary
;

CREATE OR REPLACE VIEW same_dept AS
SELECT dept_others.*
    FROM (
        SELECT emp.emp_no, emp.first_name, emp.last_name, dept.dept_no
            FROM current_dept_emp AS dept
            JOIN employees AS emp
               ON dept.emp_no = emp.emp_no
            WHERE emp.first_name="Elvis" AND emp.last_name="Demeyer"
    ) AS dept_elvis,
     (
        SELECT emp.emp_no, emp.first_name, emp.last_name, dept.dept_no
            FROM current_dept_emp AS dept
            JOIN employees AS emp
                ON dept.emp_no = emp.emp_no
    ) AS dept_others
WHERE dept_others.dept_no = dept_elvis.dept_no
;
-- _____________________________________________________________________________________________________________
-- Consulta 7
SELECT same.emp_no, same.first_name, same.last_name, same.dept_no, msal.salary
    FROM same_dept_tb AS same  JOIN more_salary_tb AS msal ON same.emp_no = msal.emp_no
;

-- _____________________________________________________________________________________________________________