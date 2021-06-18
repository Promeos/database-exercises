/*
Chapter 2
In this chapter, you will deepen your knowledge of handling errors.
You will learn how to raise errors using RAISERROR and THROW.
Additionally, you will discover how to customize errors.

-------------------------------- NOTES ------------------------------------------

RAISERROR

$ Raise errors statements
    - RAISEERROR
    - THROW
        - Microsoft suggests to use throw in new sql queries

$ RAISERROR syntax
    RAISEERROR ({msg_str | msg_id | @local_variable_message },
    severity,
    state,
    [ argument [ ,...n] ])
    [ WITH option [ ,...n]]

$ RAISERROR with message string
    IF NOT EXISTS (SELECT * FROM staff WHERE staff_id = 15)
        RAISERROR('No %s with id %d.' 16, 1, 'staff member', 15);

$ RAISEERROR with error number


THROW

$ THROW syntax
    - Recommended by Microsoft over the RAISEERROR statement

    THROW [ error_number, message, state ][ ; ]

$ THROW - without parameters
    BEGIN TRY
        SELECT price/0 from orders;
    END TRY
    BEGIN CATCH
        THROW;
        SELECT 'This line is executed!' as message;
    END CATCH

$ THROW - ambiguity
    BEGIN TRY
        SELECT price/0 from orders;
    END TRY
    BEGIN CATCH
        SELECT 'This line is executed!'
        THROW;
    END CATCH


$ THROW - with parameters
    THROW error_number, message, state [ ; ]


CUSTOMIZING ERROR MESSAGES IN THE THROW STATEMENT

$ Parameter placeholders in RAISERROR and THROW
    RAISERROR('No %s with id %d.', 16, 1, 'staff member', 15);
    THROW 52000, 'No staff member with id 15', 1;

    - THROW does not allow parameter placeholders like %s or %d


$ Ways of customizing error messages
    - Variable by concatenating strings
    - FORMATMESSAGE function


$ Using a variable and the CONCAT function
    DECLARE @staff_id AS INT = 500;
    DECLARE @my_message NVARCHAR(500) =
        CONCAT('There is no staff member for id ', @staff_id, '. Try with another one.');

    IF NOT EXISTS (SELECT * FROM staff WHERE staff_id = @staff_id)
        THROW 50000, @my_message, 1;


$ The FORMATMESSAGE function

    FORMATMESSAGE ( { ' msg_string ' | msg_number },
                    [ param_value [ ,...n ] ] )


$ FORMATMESSAGE with message string

    DECLARE @staff_id AS INT = 500;
    DECLARE @my_message NVARCHAR(500) =
        FORMATMESSAGE('There is no staff member for id %d. %s ', @staff_id, 'Try with another one.')

    IF NOT EXISTS (SELECT * FROM STAFF WHERE staff_id = @staff_id)
        THROW 50000, @my_message, 1;

$ FORMATMESSAGE with message number
    SELECT * FROM sys.messages

    sp_addmessage
        msg_id, severity, msgtext,
        [ language ],
        [ with_log {'TRUE' | 'FALSE'}]

    exec sp_addmessage
        @msgnum = 55000, @severity = 16, @msgtext = "There is no staff member for id  %d. %s"


    Once the custom error message is added to the system error messages, the error is THROWn successfully.
    DECLARE @staff_id AS INT = 500;
    DECLARE @my_message NVARCHAR(500) = FORMATMESSAGE(55000, @staff_id, 'Try with another one.');

    IF NOT EXISTS (SELECT * FROM staff WHERE staff_id = @staff_id)
        THROW 50000, @my_message, 1;

*/
------------------------------ EXERCISES -----------------------------------------

-- 1. RAISERROR syntax
RAISERROR('You cannot apply a 50%% discount on %s number %d', 6, 1, 'product', 5);

-- "You cannot apply a 50% discount on product number 5"


-- 2. CATCHING the RAISERROR
DECLARE @product_id INT = 5;

IF NOT EXISTS (SELECT * FROM products WHERE product_id = @product_id)
	-- Invoke RAISERROR with parameters
	RAISERROR('No product with id %d.', 11, 1, @product_id);
ELSE 
	SELECT * FROM products WHERE product_id = @product_id;


BEGIN TRY
	-- Change the value
    DECLARE @product_id INT = 5;	
    IF NOT EXISTS (SELECT * FROM products WHERE product_id = @product_id)
        RAISERROR('No product with id %d.', 11, 1, @product_id);
    ELSE 
        SELECT * FROM products WHERE product_id = @product_id;
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE();
END CATCH


/*
3. THROW with or without parameters
Question: Which of the following is true about the THROW statement?
Answer: The THROW statement without parameters should be placed within a CATCH block.
*/


-- 4. THROW without parameters
CREATE PROCEDURE insert_product
  @product_name VARCHAR(50),
  @stock INT,
  @price DECIMAL

AS

BEGIN TRY
	INSERT INTO products (product_name, stock, price)
		VALUES (@product_name, @stock, @price);
END TRY
-- Set up the CATCH block
BEGIN CATCH
	-- Insert the error and end the statement with a semicolon
    INSERT INTO errors VALUES ('Error inserting a product');
    -- Re-throw the error
	THROW; 
END CATCH


-- 5. Executing a stored procedure that throws an error.
BEGIN TRY
	-- Execute the stored procedure
	EXEC insert_product
    	-- Set the values for the parameters
    	@product_name = 'Trek Conduit+',
        @stock = 3,
        @price = 499.99;
END TRY
-- Set up the CATCH block
BEGIN CATCH
	-- Select the error message
	SELECT ERROR_MESSAGE();
END CATCH

/*
Awesome! You know how to handle an error thrown by a stored procedure. Even if the THROW statement is
executed within a stored procedure, you can catch it outside the stored procedure and get the error message.
*/


-- 6. THROW with parameters
DECLARE @staff_id INT = 4;

IF NOT EXISTS (SELECT * FROM staff WHERE staff_id = @staff_id)
   	-- Invoke the THROW statement with parameters
	THROW 50001, 'No staff member with such id', 1;
ELSE
   	SELECT * FROM staff WHERE staff_id = @staff_id

/*
Congratulations! You have learned how to use the
THROW statement with parameters. Remember that the THROW statement with parameters can be
used both inside or outside a CATCH block.
*/

/*
7. Ways of customizing error messages
    Question: You want to use the THROW statement to throw an error with a custom message.
              Which of the following is a possible option to do so?

    Answer: You use the FORMATMESSAGE function and save the result
            into a variable that you pass to the THROW statement.
*/

-- 8. Concatenating the message
DECLARE @first_name NVARCHAR(20) = 'Pedro';

-- Concat the message
DECLARE @my_message NVARCHAR(500) =
	CONCAT('There is no staff member with ', @first_name, ' as the first name.');

IF NOT EXISTS (SELECT * FROM staff WHERE first_name = @first_name)
	-- Throw the error
	THROW 50000, @my_message, 1;


-- 9. FORMATMESSAGE with message string
DECLARE @product_name AS NVARCHAR(50) = 'Trek CrossRip+ - 2018';
-- Set the number of sold bikes
DECLARE @sold_bikes AS INT = 10;
DECLARE @current_stock INT;

SELECT @current_stock = stock FROM products WHERE product_name = @product_name;

DECLARE @my_message NVARCHAR(500) =
	-- Customize the error message
	FORMATMESSAGE('There are not enough %s bikes. You have %d in stock.', @product_name, @current_stock);

IF (@current_stock - @sold_bikes < 0)
	-- Throw the error
	THROW 50000, @my_message, 1;


-- 10. FORMATMESSAGE with message number
EXEC sp_addmessage @msgnum = 50002, @severity = 16, @msgtext = 'There are not enough %s bikes. You only have %d in stock.', @lang = N'us_english';

DECLARE @product_name AS NVARCHAR(50) = 'Trek CrossRip+ - 2018';
--Change the value
DECLARE @sold_bikes AS INT = 10;
DECLARE @current_stock INT;

SELECT @current_stock = stock FROM products WHERE product_name = @product_name;

DECLARE @my_message NVARCHAR(500) =
	FORMATMESSAGE(50002, @product_name, @current_stock);

IF (@current_stock - @sold_bikes < 0)
	THROW 50000, @my_message, 1;
