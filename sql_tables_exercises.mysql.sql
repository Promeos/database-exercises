# mysql tables exerises

# 3. select the employees database from available databases
use employees;

# 4. list all of the (accessible) tables in the database
show tables;

# 5. explore the employees table from the employees database. list its different datatypes.
describe employees;

# 6. which tables do you think contain a numeric string column?
# Tables that contain a numeric type column(s):
# dept_emp
# dept_manager
# employees
# employees_with_departments
# salaries
# titles

# 7. which table(s) do you think contain a string type column?
# tables that contain a string type column(s):
# departments
# dept_emp
# dept_manager
# employees
# employees_with_departments
# titles

# 8. which table(s) do you think contain a date type column?
# tables that contain a date type column(s):
# dept_emp
# dept_manager
# employees
# salaries
# titles

# 9. what is the relationship between the employees and the departments tables?
# There are no direct relationships between the two tables. The following tables have a relationship with both employees and departments tables:
# dept_emp
# dept_manager

# 10. show the SQL that create the 'dept_manager' table
show create table dept_manager;
