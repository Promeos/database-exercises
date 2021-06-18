/*
Chapter 1. Starting with Error Handling
To begin the course, you will learn how to handle errors using the
TRY...CATCH construct that provides T-SQL. You will study the anatomy of errors,
and you will learn how to use some functions that can give you information about errors.

-------------------------------- NOTES -------------------------------------------

TRANSACTIONS AND ERROR HANDLING IN SQL SERVER

$ Getting an Error
- Inserting duplicate data in a table that has a UNIQUE CONSTRAINT will
  raise an error.

$ The TRY CATCH syntax
    BEGIN TRY
        { sql_statement | statement_block }
    END TRY
    BEGIN CATCH
        { sql_statement | statement_block }
    END CATCH

    - Enclose the sql statements in the TRY block
    - Error handling code is placed in the CATCH block

$ Example with TRY...CATCH

    BEGIN TRY
        INSERT INTO products (product_name, stock, price)
            VALUES ('Trek Powerfly 5 - 2018, 10, 3499.99);
        SELECT 'Product inserted correctly!' AS message;
    END TRY
    BEGIN CATCH
        SELECT 'An error occurred! You are in the CATCH block' AS message;
    END CATCH

$ Nesting TRY...CATCH

    BEGIN TRY
        INSERT INTO products (product_name, stock, price)
            VALUES ('Trek Powerfly 5 - 2018, 10, 3499.99);
        SELECT 'Product inserted correctly!' AS message;
    END CATCH
    BEGIN CATCH
        SELECT 'An error occurred inserting the product. You are in the first CATCH block AS message;
        BEGIN TRY
            INSERT INTO myErrors
                VALUES ('ERROR!);
            SELECT 'Error inserted correctly!' AS message
        END TRY
        BEGIN CATCH
            SELECT 'An error occurred inserting the error. You are in the second CATCH block' AS message
        END CATCH
    END CATCH


ERROR ANATOMY AND UNCATCHABLE ERRORS

$ Error anatomy

    Msg 2627, Level 14, State 1, Line 1
    - The first value is the error number. SQL errors range from 1 to 49999
    - You can create your own errors with an error number 500001 and up.
    
    - The second value is the severity level.
        - 0-10 informational messages
        - 11-16 errors that can be correctde by the user (constraint violation)
        - 17-24 other errors (software problems, fatal errors)

    - The third value is the state
        - 1 if SQL Server displays error
        - Own errors 2 - 255

$ Uncatchable errors
    - Severity lower than 11 (11-19 are catchable by the user)
    - Severity of 20 or higher that stop the connection
    - Compilation errors: errors raised on objects or columns that don't exist

$ Uncatchable errors - Compliation error example


GIVING INFORMATION ABOUT ERRORS

$ Error Functions

    - ERROR_NUMBER() Returns the number of the error.
    - ERROR_SEVERITY() Returns the error severity (11-19)
    - ERROR_STATE() Returns the state of the error
    - ERROR_LIN() Returns the number of the line of the error.
    - ERROR_PROCEDURE() Returns the name of stored procedure/trigger
      NULL if there is not stored procedure/trigger.
    - ERROR_MESSAGE() Returns the text of the error message.

    - These functions can only be used in a CATCH block.

$ Error Functions - examples

    BEGIN TRY
        INSERT INTO products (product_name, stock, price)
            VALUES ('Trek Powerfly 5 - 2018', 10, 3499.990)
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER() AS Error_number,
            ERROR_SEVERITY() AS Error_severity,
            ERROR_STATE() AS Error_state,
            ERROR_PROCEDURE() AS Error_procedure,
            ERROR_LINE() AS Error_line,
            ERROR_MESSAGE() AS Error_message;
    END CATCH


*/
------------------------------- EXERCISES -----------------------------------------

-- 1. Your first error-handling script
-- Set up the TRY block
BEGIN TRY
	-- Add the constraint
	ALTER TABLE products
		ADD CONSTRAINT CHK_Stock CHECK (stock >= 0);
END TRY
-- Set up the CATCH block
BEGIN CATCH
	SELECT 'An error occurred!';
END CATCH


-- 2. Nesting TRY...CATCH constructs
-- Set up the first TRY block
BEGIN TRY
	INSERT INTO buyers (first_name, last_name, email, phone)
		VALUES ('Peter', 'Thompson', 'peterthomson@mail.com', '555000100');
END TRY
-- Set up the first CATCH block
BEGIN CATCH
	SELECT 'An error occurred inserting the buyer! You are in the first CATCH block';
    -- Set up the nested TRY block
    BEGIN TRY
    	INSERT INTO errors 
        	VALUES ('Error inserting a buyer');
        SELECT 'Error inserted correctly!';
	END TRY
    -- Set up the nested CATCH block
    BEGIN CATCH
    	SELECT 'An error occurred inserting the error! You are in the nested CATCH block';
    END CATCH
END CATCH


-- 3. Correcting compliation errors
BEGIN TRY
	INSERT INTO products (product_name, stock, price)
		VALUES ('Sun Bicycles ElectroLite - 2017', 10, 1559.99);
END TRY
BEGIN CATCH
	SELECT 'An error occurred inserting the product!';
    BEGIN TRY
    	INSERT INTO errors
        	VALUES ('Error inserting a product');
    END TRY    
    BEGIN CATCH
    	SELECT 'An error occurred inserting the error!';
    END CATCH    
END CATCH


-- 4. Using error functions
-- Set up the TRY block
BEGIN TRY  	
	SELECT 'Total: ' + SUM(price * quantity) AS total
	FROM orders  
END TRY
-- Set up the CATCH block
BEGIN CATCH  
	-- Show error information.
	SELECT  ERROR_NUMBER() AS number,  
        	ERROR_SEVERITY() AS severity_level,  
        	ERROR_STATE() AS state,
        	ERROR_LINE() AS line,  
        	ERROR_MESSAGE() AS message; 	
END CATCH


-- 5. Using error functions in a nested TRY ... CATCH
BEGIN TRY
    INSERT INTO products (product_name, stock, price) 
    VALUES	('Trek Powerfly 5 - 2018', 2, 3499.99),   		
    		('New Power K- 2018', 3, 1999.99)		
END TRY
-- Set up the outer CATCH block
BEGIN CATCH
	SELECT 'An error occurred inserting the product!';
    -- Set up the inner TRY block
    BEGIN TRY
    	-- Insert the error
    	INSERT INTO errors 
        	VALUES ('Error inserting a product');
    END TRY    
    -- Set up the inner CATCH block
    BEGIN CATCH
    	-- Show number and message error
    	SELECT 
        	ERROR_LINE() AS line,	   
			ERROR_MESSAGE() AS message; 
    END CATCH    
END CATCH