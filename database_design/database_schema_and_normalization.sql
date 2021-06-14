/*
Chapter 2 Database Schemas and Normalization
In this chapter, you will take your data modeling skills to the next level.
You'll learn to implement star and snowflake schemas, recognize the importance of normalization
and see how to normalize databases to different extents.

-------------------------------- NOTES ------------------------------------------

STAR AND SNOWFLAKE SCHEMA

$ Star Schema
• The star schema is the simplest form of the dimensional model
• The star schema is used interchangably with the term dimensional model.
• The star schema is composed of two tables: Fact and Dimension tables.

    Fact tables
    • Hold records of a metric
    • Changes regularly
    • Connects to dimension tables via foreign keys

    Dimension tables
    • Holds descriptions of attributes
    • Does not change as often

    • The star schema is named as such because of it's extension points.
    • The Fact table is the main table and the dimension tables are the points of a star.


$ Snowflake schema
• The snowflake schema is an extension of the star schema.
• The snowflake schema has more extensions from it's dimension tables and can be multi-level.
• Star schemas have one dimension level while snowflake schemas can be more than one level.
• The snowflake schema has more dimension levels because the data has been normalized.


$ What is normalization?
• Database design technique
• Divides tables into smaller tables and connects them via relationships.
• The main goal of normalization is to reduce redundancy and increase data integrity.
• To normalize data, identify repeating groups of data and create new tables for them.


$ Book dimension of the star schema: Example Book Wholeseller
• Which fields are most likely to have repeating values?
    • author
    • publisher
    • genre
    - book_id: i.e. ISBN Is the primary key of the book dimension table.
• Author, publisher, and genre would have their own unique table.

Heirarchical dimension tables are created for nested dimensions
• Time
• State, city, county

*/
------------------------------ EXERCISES -----------------------------------------

-- 1. Adding foreign keys
-- Add the book_id foreign key
ALTER TABLE fact_booksales ADD CONSTRAINT sales_book
    FOREIGN KEY (book_id) REFERENCES dim_book_star (book_id);
    
-- Add the time_id foreign key
ALTER TABLE fact_booksales ADD CONSTRAINT sales_time
    FOREIGN KEY (time_id) REFERENCES dim_time_star (time_id);
    
-- Add the store_id foreign key
ALTER TABLE fact_booksales ADD CONSTRAINT sales_store
    FOREIGN KEY (store_id) REFERENCES dim_store_star (store_id);



-- 2. Extending the book dimension


