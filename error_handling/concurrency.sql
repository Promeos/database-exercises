/*
Chapter 4 Controlling the concurrency: Transaction isolation levels

This chapter defines what concurrency is and how it can affect transactions.
You will learn exciting concepts like dirty reads, repeatable reads, and phantom reads.
To avoid or allow these reads, you will explore, one by one, the different transaction isolation levels.

-------------------------------- NOTES ------------------------------------------

TRANSCATION ISOLATION LEVELS

$ What is concurrency?

Concurrency: Two or more transactions that read/change shared data at the same time.

$ Transaction isolation levels
    - READ COMMITTED (default)
    - READ UNCOMMITTED
    - REPEATABLE READ
    - SERIALIZABLE
    - SNAPSHOT

    SET TRANSACTION ISOLATION LEVEL
        {READ UNCOMMITTED | READ COMMITTED | REPEATABLE READ | SERIALIZABLE | SNAPSHOT}

$ Knowing the current isolation level
    SELECT CASE transaction_isolation_level
        WHEN 0 THEN 'UNSPECIFIED'
        WHEN 1 THEN 'READ UNCOMMITTED'
        WHEN 2 THEN 'READ COMMITTED'
        WHEN 3 THEN 'REPEATABLE READ'
        WHEN 4 THEN 'SERIALIZABLE'
        WHEN 5 THEN 'SNAPSHOT'
    END AS transaction_isolation_level
    FROM sys.dm_exec_sessions
    WHERE session_id = @@SPID;

$ READ UNCOMMITTED
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    - Least restrictive isolation level
    - Read rows modified by other transactions without being committed/rolled back.

|                |Dirty reads|Non-repeatable reads|Phantom reads|
|----------------|-----------|--------------------|-------------|
|READ UNCOMMITTED| YES       | YES                | YES         |

$ Dirty reads

    Original balance of account 123 = $35,000

    BEGIN TRAN
        UPDATE accounts
        SET current_balance = 30000
        WHERE account_id = 5;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SELECT current_balance
    FROM accounts WHERE account_id = 5;

    ROLLBACK TRAN;

$ Non-repeatable reads

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    BEGIN TRAN
        SELECT * FROM accounts WHERE account_id = 5;

    BEGIN TRAN
        UPDATE accounts
        SET current_balance = 30000 WHERE account_id = 5
    COMMIT TRAN
-- Once the transaction is committed the balance in the account is reduced to 30000.
    
    SELECT * FROM accounts WHERE account_id = 5;

$ Phantom reads

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    BEGIN TRAN
    SELECT * FROM accounts
        WHERE current_balance BETWEEN 45000 AND 50000;

    BEGIN TRAN
    INSERT INTO accounts
        VALUES('5555393939' 1, 45000)
    COMMIT TRAN

    SELECT * FROM accounts
        WHERE current_balance BETWEEN 45000 AND 50000;

$ READ UNCOMMITTED - Summary
    Pros: Can be faster, doesn't block other transactions.
    Cons: Allows dirty reads, non-repeatable reads, and phantom reads.

    When to use READ UNCOMMITTED?
    - Don't want to be blocked by other transactions but don't mind concurrency phenomena.
    - You explicitly want to watch uncommitted data.


READ COMMITTED & REPEATABLE READ

$ READ COMMITTED
    - Default isolation level in SQL Server
    - Can't read data modified by other transaction that hasn't been committed or rolled back.

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


$ READ UNCOMMITTED - isolation level comparison

|                | Dirty reads | Non-repeatable reads | Phantom reads |
|----------------|-------------|----------------------|---------------|
|READ UNCOMMITTED| YES         | YES                  | YES           |
|READ COMMITTED  | NO          | YES                  | YES           |


$ READ COMMITTED - preventing dirty reads

    Original balance = $35,000

    -- Transaction 1
    BEGIN TRAN
        UPDATE accounts
        SET current_balance = 30000
        WHERE account_id = 5;

    -- Transaction 2: Has to wait until Transaction 1 is committed
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SELECT current_balance
    FROM accounts WHERE account_id = 5;

    -- Transaction 1.1
    COMMIT TRAN;


$ READ COMMITTED - Selecting without waiting

    - If a transaction does not modify the data, then it CAN be read using
    - the TRANSACTION ISOLATION LEVEL -> READ COMMITTED.

    -- Transaction 1
    BEGIN TRAN
        SELECT current_balance
        FROM accounts WHERE account_id = 5;

    -- Transaction 2
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SELECT current_balance
    FROM accounts WHERE account_id = 5;


$ READ COMMITTED - Summary
    Pros: Prevents dirty reads
    Cons: Allows non-repeatable and phantom reads

    When to use READ COMMITTED?
    - You want to sensure that you only read committed data, not non-repeatable and phantom reads.


$  REPEATABLE READ

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
    
    - Can't read uncommitted data from other transactions.
    - If some data is read, other transactions cannot modify that data until REPEATABLE READ transaction finishes.

$ REPEATABLE READ - Isolation Level Comparison

|                  | Dirty reads | Non-repeatable reads | Phantom reads |
|------------------|-------------|----------------------|---------------|
| READ UNCOMMITTED | YES         | YES                  | YES           |
| READ COMMITTED   | NO          | YES                  | YES           |
| REPEATABLE READ  | NO          | NO                   | YES           |

$ REPEATABLE READ - Precenting non-repeatable reads

    -- Transaction 1
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
    BEGIN TRAN
        SELECT current_balance FROM accounts
        WHERE account_id = 5;

        SELECT current_balance FROM accounts
        WHERE account_id = 5;
    COMMIT TRAN;

    -- Transaction 2: Has to wait until transaction 1 is commited.
    UPDATE accounts
    SET current_balance = 30000
    WHERE account_id = 5';

$ REPEATABLE READ - Summary
    Pros: Prevents other transactions from modifying the data you are reading, non-repeatable reads
          Prevents dirty reads
    Cons: Allos phantom reads. You can be blocked by a REPEATABLE READ transaction.

    When to use REPEATABLE READ?
    - Only want to read committed data and don't want other transactions to modify what you are reading.
      You don't care if phantom reads occur.


SERIALIZABLE isolation level

$ SERIALIZABLE

    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

    - Most restrictive transaction isolation level.


$ Isolation Level Comparison

|                  | Dirty reads | Non-repeatable reads | Phantom reads |
|------------------|-------------|----------------------|---------------|
| READ UNCOMMITTED | YES         | YES                  | YES           |
| READ COMMITTED   | NO          | YES                  | YES           |
| REPEATABLE READ  | NO          | NO                   | YES           |
| SERIALIZABLE     | NO          | NO                   | NO            |


$ Locking records with SERIALIZABLE

    - Query with WHERE clause based on an index range -> Locks only that records.
    - Query not based on an index range -> Locks the complete table.

$ SERIALIZABLE - query based on an index range

    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

    -- Transaction 1: Locks the record
    BEGIN TRAN
        SELECT * FROM customers
        WHERE customer_id BETWEEN 1 AND 3;

    COMMIT TRAN;

    -- Transaction 2: Wait until transaction 1 is committed.
    INSERT INTO customers (customer_id, first_name, last_name, email)
    VALUES (200, 'Phantom', 'Ph', 'phantom@mail.com')

    -- Transaction 2: New
    INSERT INTO customers (customer_id, first_name, last_name, email)
    VALUES (200, 'Phantom', 'Ph', 'phantom@mail.com')


$ SERIALIZABLE - Query not based on an index range

    -- Transaction 1: Locks the entire table
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
    BEGIN TRAN
        SELECT * FROM customers;
    COMMIT TRAN;

    -- Transaction 2: Has to wait until transaction 1 is committed.
    INSERT INTO customers
    VALUES (100, "Phantom", "ph", "phantom@mail.com")


$ SERIALIZABLE - Summary

    Pros: Data consistency: Prevents dirty, non-repeatable, and phantom reads.
    Cons: You can be blocked by a SERIALIZABLE transaction

    When to use SERIALIZABLE?
    - When data consistency is a must.


SNAPSHOT

$ SNAPSHOT

    - Every modification is stored in the tempDB database
    - Only see committed changes that occurred before he start of the SNAPSHOT transaction.
    - Can't see any changes made by other transactions after the start of the SNAPSHOT
    - Readings don't block writings and writings don't block readings.
    - Can have update conflicts.

    ALTER DATABASE myDatabaseName SET ALLOW_SNAPSHOT_ISOLATION ON;

    SET TRANSACTION ISOLATION LEVEL SNAPSHOT



$ SNAPSHOT - Isolation Level Comparison
|                  | Dirty reads | Non-repeatable reads | Phantom reads |
|------------------|-------------|----------------------|---------------|
| READ UNCOMMITTED | YES         | YES                  | YES           |
| READ COMMITTED   | NO          | YES                  | YES           |
| REPEATABLE READ  | NO          | NO                   | YES           |
| SERIALIZABLE     | NO          | NO                   | NO            |
| SNAPSHOT         | NO          | NO                   | NO            |


$ SNAPSHOT

    -- Transaction 1
    SET TRANSACTION ISOLATION LEVEL SNAPSHOT

    BEGIN TRAN
        SELECT * FROM accounts;
        SELECT * FROM accounts;
    COMMIT TRAN;

    -- Transaction 2: This transaction is not blocked by transaction 1
    BEGIN TRAN
        INSERT INTO accounts
        VALUES (1111111, 1, 25000);

        UPDATE accounts
        SET current_balance = 30000 WHERE account_id

        SELECT * FROM accounts;
    COMMIT TRAN

$ SNAPSHOT - Summary
    Pros: Good data consistency: Prevents dirty, non-repeatable and phantom reads without blocking
    Cons: tempDB increases


$ READ COMMITTED SNAPSHOT
    - Changes the behavior of READ COMMITTED

        ALTER DATABASE myDatabaseName SET READ_COMMITTED_SNAPSHOT {ON|OFF}
    - OFF by default
    - To use ON:

        ALTER DATABASE myDatabaseName SET ALLOW_SNAPSHOT_ISOLATION ON;

    - Set to ON, makes every READ COMMITTED statement can only see committed changes that occurred
      before the start of the statement.
    - Can't have update conflicts

$ READ COMMITTED SNAPSHOT - Example
    
    -- Transaction 1
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    BEGIN TRAN
        UPDATE accounts
        SET current_balance = 30000
        WHERE account_id = 1;

    COMMIT TRAN;


    -- Transaction 2: Allows another User to modify the account balance.
    SET TRANSACTION ISOLAITON LEVEL READ COMMITTED
    BEGIN TRAN

        SELECT current_balance FROM accounts
        WHERE account_id = 1;

        SELECT current_balance FROM accounts
        WHERE account_id = 1;
    COMMIT TRAN;


$ WITH (NOLOCK)
    - Used to read uncommitted data
    - READ UNCOMMITTED applies to the entire connection / WITH (NOLOCK) applies to a specific table.
    - Use under any isolation level when you just want to read uncommitted data frmo specific table.


$ WITH (NOLOCK) - Example

    -- Transaction 1
    BEGIN TRAN
        UPDATE accounts
        SET current_balance = 30000
        WHERE account_id = 5;

    -- Transaction 2
    SELECT current_balance
    FROM accounts WITH (NOLOCK)
    WHERE account_id = 5;

*/
------------------------------ EXERCISES -----------------------------------------

-- 1. Using the READ UNCOMMITTED isolation level

-- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- Select first_name, last_name, email and phone
	SELECT
    	first_name, 
        last_name, 
        email,
        phone
    FROM customers;


-- 2. Prevent dirty reads
-- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- Count the accounts
SELECT COUNT(*) AS number_of_accounts
FROM accounts
WHERE current_balance >= 50000;


-- 3. Preventing non-repeatable reads
-- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

-- Begin a transaction
BEGIN TRAN

SELECT * FROM customers;

-- some mathematical operations, don't care about them...

SELECT * FROM customers;

-- Commit the transaction
COMMIT TRAN;


-- 3. Prevent phantom reads in a table
-- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

-- Begin a transaction
BEGIN TRAN

SELECT * FROM customers;

-- After some mathematical operations, we selected information from the customers table.
SELECT * FROM customers;

-- Commit the transaction
COMMIT TRAN;


-- 4. Prevent phantom reads just in some rows
-- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

-- Begin a transaction
BEGIN TRAN

-- Select customer_id between 1 and 10
SELECT * 
FROM customers
WHERE customer_id BETWEEN 1 AND 10;

-- After completing some mathematical operation, select customer_id between 1 and 10
SELECT * 
FROM customers
WHERE customer_id BETWEEN 1 AND 10;

-- Commit the transaction
COMMIT TRAN;

-- 5. Avoid being blocked
SELECT *
	-- Avoid being blocked
	FROM transactions WITH (NOLOCK)
WHERE account_id = 1