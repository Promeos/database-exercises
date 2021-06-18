/*
Chapter 3. Transactions
In this chapter, you will be introduced to the concept of transactions.
You will discover how to commit and rollback them. You will finish by learning
how to return the number of transactions and their state.

-------------------------------- NOTES ------------------------------------------

TRANSACTIONS

$ What is a transaction?
    A transaction is the execution of one or more statements, such that either all or none
    of the statements are executed.

    Example:
    Transfer $100 from account A to account B
    - First subtract $100 from account A
    - Second add the $100 to account B

    These two operations must behave as an atomic operation.
    Both steps are executed or none of them.

$ Transaction statements  - BEGIN a transaction

    BEGIN { TRAN | TRANSACTION }
        [ { transaction_name | @tran_name_variable}
            [ WITH MARK ['description'] ]
        ]
[ ; ]

$ Transaction statements - COMMIT a transaction

    COMMIT [ { TRAN | TRANSACTION } [ transaction_name | tran_name_variable] ]
    [ WITH ( DELAYED_DURABILITY = { OFF | ON } ) ][ ; ]

    When executed, the effect of the transactoin cannot be reversed.

$ Transaction statements - ROLLBACK a transaction

    ROLLBACK { TRAN | TRANSACTION }
        [ transaction_name | @tran_name_variable |
          savepoint_name | @savepoint_variable ] [ ; ]
    
$ Transaction - example

    Account 1 = $24,400
    Account 2 = $35,300

    BEGIN TRAN;
        UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
        INSERT INTO transactions VALUES (1, -100, GETDATE());

        UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
        INSERT INTO transactions VALUES (5, 100, GETDATE());
    COMMIT TRAN;


    Account 1 = $24,400
    Account 2 = $35,300

    BEGIN TRAN;
        UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
        INSERT INTO transactions VALUES (1, -100, GETDATE());

        UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
        INSERT INTO transactions VALUES (5, 100, GETDATE());
    COMMIT ROLLBACK;

$ Transaction - example with TRY...CATCH

    Account 1 = $24,400
    Account 2 = $35,300

    BEGIN TRY
        BEGIN TRAN;
            UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
            INSERT INTO transactions VALUES (1, -100, GETDATE());

            UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
            INSERT INTO transactions VALUES (1, 100, GETDATE());
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
    END CATCH


@@TRANCOUNT and SAVEPOINTS

    @@TRANCOUNT counts the number of BEGIN TRAN statements that are active in your current connection.
    Returns:
        - Greater than 0 represents an open transaction
        - No open transaction

    The value of @@TRANCOUNT is modified when
        - BEGIN TRAN increases @@TRANCOUNT by 1
        - COMMIT TRAN decreases @@TRANCOUNT by 1
        - ROLLBACK TRAN is 0

$ @@TRANCOUNT in a TRY...CATCH construct

    Check for open transactions by placing the @@TRANCOUNT is the CATCH block

    BEGIN TRY
        BEGIN TRAN;
            UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
            INSERT INTO transactions VALUES (1, -100, GETDATE());

            UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
            INSERT INTO transactions VALUES (5, 100, GETDATE());
        COMMIT TRAN;
END TRAN
BEGIN CATCH
    -- If open transactions exist in the session, Rollback all changes.
    IF (@@TRANCOUNT > 0)
        ROLLBACK TRAN;
END CATCH


$ Savepoints
    - Markers within a transaction
    - Allow to rollback to the savepoints

    SAVE { TRAN | TRANSACTION } { savepoint_name | @savepoint_variable }
    [ ; ]


XACT_ABORT & XACT_STATE

$ XACT_ABORT
    Specifies whether the current transaction will be automatically rolled back when an error occurs.

    SET XACT_ABORT { ON | OFF }
    SET XACT_ABORT OFF
        - Default setting
        - If there is an error: There may be open transactions.

    SET XACT_ABORT ON
        - If there is an error: Rollbacks the transaction and aborts the execution.
    

$ XACT_ABORT examples
    SET XACT_ABORT ON;

    BEGIN TRAN;
        INSERT INTO customers VALUES ('Mark', 'Davis', 'markdavis@mail.com', '555909090');
        INSERT INTO customers VALUES ('Dylan', 'Smith', 'dylansmith@mail.com', '55588899');
    COMMIT TRAN;

$ XACT_ABORT WITH RAISERROR

    SET XACT_ABORT ON;

    BEGIN TRAN;
        INSERT INTO customers VALUES ('Mark', 'Davis', 'markdavis@mail.com', '555909090');
        RAISERROR('Raising an error!', 16, 1);
        INSERT INTO customers VALUES ('Zack', 'Roberts', zackroberts@mail.com', '555919191');
    COMMIT TRAN;
    
    - RAISERROR does not stop the transaction from commiting the inserts even though there is an error.


$ XACT_ABORT with THROW

    SET XACT_ABORT ON;

    BEGIN TRAN;
        INSERT INTO customers VALUES ('Mark', 'Davis', 'markdavis@mail.com', '555909090');
        THROW 55000, 'Raising an error!', 1;
        INSERT INTO customers VALUES ('Zack', 'Roberts', 'zackroberts@gmail.com', '555919191')
    COMMIT TRAN;

    - THROW ROLLS BACK both transactions because an error is raised.

$ XACT_STATE

    XACT_STATE()

        0 -> no open transaction
        1 -> open and committable transaction
        -1 -> open and uncommittable transaction
            - can't commit
            - can't rollback to a savepoint
            - can rollback the full transaction
            - can't make any changes but can read data

        
    



*/
------------------------------ EXERCISES -----------------------------------------
/*
1. Transaction statements

Question: Which of the following is not correct about transaction statements?
Answer: The COMMIT TRAN|TRANSACTION statement reverts a transaction to the beginning or a savepoint inside the transaction.
*/

-- 2. Correcting a transaction
BEGIN TRY  
	BEGIN TRAN;
		UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
		INSERT INTO transactions VALUES (1, -100, GETDATE());
        
		UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
		INSERT INTO transactions VALUES (5, 100, GETDATE());
	COMMIT TRAN;
END TRY
BEGIN CATCH  
	ROLLBACK TRAN;
END CATCH


-- 3. Rolling backk a transaction if there is an error
BEGIN TRY  
	-- Begin the transaction
	BEGIN TRAN;
		UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
		INSERT INTO transactions VALUES (1, -100, GETDATE());
        
		UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
        -- Correct it
		INSERT INTO transactions VALUES (500, 100, GETDATE());
    -- Commit the transaction
	COMMIT TRAN;    
END TRY
BEGIN CATCH  
	SELECT 'Rolling back the transaction';
    -- Rollback the transaction
	ROLLBACK TRAN;
END CATCH


-- 4. Choosing when to commit or rollback a transaction
-- Begin the transaction
BEGIN TRAN; 
	UPDATE accounts set current_balance = current_balance + 100
		WHERE current_balance < 5000;
	-- Check number of affected rows
	IF @@ROWCOUNT > 200
		BEGIN 
        	-- Rollback the transaction
			ROLLBACK TRAN; 
			SELECT 'More accounts than expected. Rolling back'; 
		END
	ELSE
		BEGIN 
        	-- Commit the transaction
			COMMIT TRAN; 
			SELECT 'Updates commited'; 
		END


/*
5. Modifiers of the @@TRANCOUNT value

Question: Which of the following is false  about @@TRANCOUNT?
Answer: The COMMIT TRAN|TRANSACTION statement decrements the value of @@TRANCOUNT to 0, except if there is a savepoint.
*/


-- 6. Checking @@TRANCOUNT in a TRY...COUNT construct
BEGIN TRY
	-- Begin the transaction
	BEGIN TRAN;
    	-- Correct the mistake
		UPDATE accounts SET current_balance = current_balance + 200
			WHERE account_id = 10;
    	-- Check if there is a transaction
		IF @@TRANCOUNT > 0     
    		-- Commit the transaction
			COMMIT TRAN;
     
	SELECT * FROM accounts
    	WHERE account_id = 10;      
END TRY
BEGIN CATCH  
    SELECT 'Rolling back the transaction'; 
    -- Check if there is a transaction
    IF @@TRANCOUNT > 0   	
    	-- Rollback the transaction
        ROLLBACK TRAN;
END CATCH


-- 7. Using savepoints
BEGIN TRAN;
	-- Mark savepoint1
	SAVE TRAN savepoint1;
	INSERT INTO customers VALUES ('Mark', 'Davis', 'markdavis@mail.com', '555909090');

	-- Mark savepoint2
    SAVE TRAN savepoint2;
	INSERT INTO customers VALUES ('Zack', 'Roberts', 'zackroberts@mail.com', '555919191');

	-- Rollback savepoint2
	ROLLBACK TRAN savepoint2;
    -- Rollback savepoint1
	ROLLBACK TRAN savepoint1;

	-- Mark savepoint3
	SAVE TRAN savepoint3;
	INSERT INTO customers VALUES ('Jeremy', 'Johnsson', 'jeremyjohnsson@mail.com', '555929292');
-- Commit the transaction
COMMIT TRAN;


-- 8. XACT_ABORT and THROW
-- Use the appropriate setting
SET XACT_ABORT ON;
-- Begin the transaction
BEGIN TRAN; 
	UPDATE accounts set current_balance = current_balance - current_balance * 0.01 / 100
		WHERE current_balance > 5000000;
	IF @@ROWCOUNT <= 10	
    	-- Throw the error
		THROW 55000, 'Not enough wealthy customers!', 1;
	ELSE		
    	-- Commit the transaction
		COMMIT TRAN; 


-- 9. Doomed transactions
-- Use the appropriate setting
SET XACT_ABORT OFF;
BEGIN TRY
	BEGIN TRAN;
		INSERT INTO customers VALUES ('Mark', 'Davis', 'markdavis@mail.com', '555909090');
		INSERT INTO customers VALUES ('Dylan', 'Smith', 'dylansmith@mail.com', '555888999');
	COMMIT TRAN;
END TRY
BEGIN CATCH
	-- Check if there is an open transaction
	IF XACT_STATE() <> 0
    	-- Rollback the transaction
		ROLLBACK TRAN;
    -- Select the message of the error
    SELECT ERROR_MESSAGE() AS Error_message;
END CATCH