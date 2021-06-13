/*
DATABASE DESIGN
Chapter 1: Processing, Storing, and Organizing Data

Start your journey into database design by learning about the two approaches to data processing,
OLTP and OLAP. In this first chapter, you'll also get familiar with the different forms data
can be stored in and learn the basics of data modeling.
-------------------------------- NOTES ------------------------------------------

OLTP and OLAP

Motivating question of db design: How should we organize and manage data?

• SCHEMAS: How should my data be logically organized?
• Normalization: Should my data have minimal dependency and redundancy?
• Views: What joins will be done most often?
• Access control: Should all users of the data have the same level of access?
• DBMS: How do I pick between all the SQL and noSQL options?


$ Approaches to processing data OLTP and OLAP

OLTP
• OLTP stands for Online Transaction Processing
• Oriented around transactions: Purchases, events, time series data.
• Focus on day to day operations.
• Traditional databases

OLAP
• OLAP stands for Online Analytical Processing
• Focus on decision making.
• Report and analyze data.
• Typically only used by analysts and data scientists at a company.


$ Some concrete examples of OLTP and OLAP

OLTP tasks
• Find the price of a book at a book store.
• Update latest customer transaction.
• Keep track of employee hours

OLAP tasks
• Calculate books with best profit margin.
• Find the most loyal customers, i.e. customers who have the most transactions (volume, sales)
• Decide employee of the month.


$ OLAP vs. OLAP

OLTP: Online transaction processing
• Purpose: Support daily transactions 
• Design: Application-oriented
• Data: up-to-date, operational
• Size: Snapshot, gigabytes
• Queries: Simple transactions & frequent updates
• Users: Thousands


OLAP: Online Analytics Processing
• Purpose: Report and analyze data
• Design: Subject-oriented
• Data: Consolidated, historical
• Size: Archive terabytes
• Queries: Complex aggregate queries & limited updates
• Users: Hundreds


$ Working together
• OLTP is stored in a "Operational Database"
• OLAP is stored in a "Data Warehouse"
• OLTP data is stored in an operational database that is pulled and cleaned to create an
  Online Analytics Processing Data Warehouse.
• Without transactional data, analysis cannot be performed.
• Analyses from OLAP systems are used to inform business practices.


STORING DATA
• Data can be stored a 3 different levels: Structured, Unstructured, Semi-structured.

1. Structured data
• Follows a schema
• Defined data types & relationships
• SQL, tables in a relational database
• Because structured data follows a schema, it is less scalable.

2. Unstructured data
• Schemaless
• Makes up most of data in the world
• Photos, chat logs, MP3
• Uncleaned data

3. Semi-structured data
• Does not follow larger schema
• Self-describing structure
• NoSQL, XML, JSON


$ Storing data beyond traditional databases
• Traditional databases
    - For storing real-time relational structured data: Online Transaction Processing
• Data warehouses
    - For analyzing archived structured data: Online Analytics Processing
• Data lakes
    - For storing data of all structures = flexibility and scalability
    - For analyzing big data


$ Data warehouses
• Optimized for analytics
    - Organized for reading/aggregating data.
    - Optimized for READ-ONLY analytics.
• Contains data from multiple sources.
• Massively Parallel Processing (MPP)
• Typically uses a denormalized schema and dimensional modeling.
• Examples of data warehouses include: Amazon Redshift, Azure SQL Data Warehouse, Google Big Query

Data marts
• Subset of data warehouses
• Dedicated to a specific topic
• Allows departments to have easier access to the data that matters to them.


$ Data Lakes
• Technically, traditional databases and warehouses can store unstructured data.
  The caveat being it's NOT cost-effective.
• Uses object storage vs the traditional file or block storage.  
• Store all types of data at a lower cost
    - Raw data, operational data, IoT device logs, real-time, relational and non-relational
• Retains all data and can take up petabytes.
• Schema-on-read as opposed to schema-on-write.
    - Traditional databases are classified as schema-on-write because the schema is PREDEFINED.
• Unstructured data is the most scalable
• Data needs to be catalog, otherwise it becomes a data swamp.
• Run Big data analytics using services such as Apache Spark and Hadoop
    - Useful for deep learning and data discovery because activites require a lot of data.


ETL: Extract Transform Load
• Traditional approach to data warehousing and small scale analytics.

Data Sources ---Extract---> Staging [Transform] ---Load---> Data Warehouse ---> Use

ELT: Extract Load Transform
                           [     Data Lake     ]
Data Sources ---Extract---> Load  ---> Tansform ---> Use


DATABASE DESIGN

$ What is database design?
• Determines how data is logically stored
    - How is data going to be read and updated?
• Uses database models: high-level specifications for database structure
    - Most popular database model: Relational Model.
        - It defines rows as records and columns as attributes.
        - Unique keys, constraints
    - Other database models: NoSQL, object-oriented model, network model
• Uses schemas: blueprint of the database
    - Defines tables, fields, relationships, indexes, and views.
    - When inserting data in relational databases, schemas provided data integrity.
        - Specifies tables, fields, relationships, indexes, and view a database will have.


$ Data modeling
• Process of creating a data model for the data to be stored.

There are 3 levels to a data model: Conceptual, Logical, Physical
1. Conceptual data model
    - Describes entities, relationships, and attributes.
    - Tools: Data structure diagrams, entity-relational diagrams and UML diagrams

2. Logical data model
    - Defines tables, columns, relationships
    - Tools: Database models and schemas, relational model and star schema are some examples.

3. Physical data model
    - Describes physical storage
    - Tools: Partitions, CPU's, indexes, backup systems and tablespaces.


$ Beyond relational modeling

Dimensional Modeling
• Adaptation of the relational model for data warehouse design.
• Optimized for OLAP queries: aggregate data, not updating (OLAP)
• Built using the star schema.
• Easy to interpret and extend schema.


*/
------------------------------ EXERCISES -----------------------------------------

-- 1. Which is better?
/*
The city of Chicago receives many 311 service requests throughout the day.
311 service requests are non-urgent community requests, ranging from graffiti removal
to street light outages. Chicago maintains a data repository of all these services organized
by type of requests. In this exercise, Potholes has been loaded as an example of a table in
this repository. It contains pothole reports made by Chicago residents from the past week.

Explore the dataset. What data processing approach is this larger repository most likely using?

OLTP because the table's structure appears to require frequent updates.
*/

-- 2. Ordering ETL Tasks
/*
Ordering ETL Tasks

You have been hired to manage data at a small online clothing store.
Their system is quite outdated because their only data repository is a traditional
database to record transactions.

You decide to upgrade their system to a data warehouse after hearing
that different departments would like to run their own business analytics.
You reason that an ELT approach is unnecessary because there is relatively little data (< 50 GB).

In the ETL flow you design, different steps will take place.
Place the steps in the most appropriate order.

1. eCommerce API outputs real time data of transactions.
2. Python script drops null rows and clean data into pre-determined columns.
3. Resulting dataframe is written into an AWS Redshift Warehouse.

*/


-- 3. Recommend a storage solution
/*
When should you choose a data warehouse over a data lake?

To create accessible and isolated data repositories for other analysts
*/


-- 4. Deciding fact and dimension tables
-- Create a route dimension table
CREATE TABLE route (
	route_id INTEGER PRIMARY KEY,
    park_name VARCHAR(160) NOT NULL,
    city_name VARCHAR(160) NOT NULL,
    distance_km FLOAT NOT NULL,
    route_name VARCHAR(160) NOT NULL
)
-- Create a week dimension table
CREATE TABLE week(
	week_id INTEGER PRIMARY KEY,
    week INTEGER NOT NULL,
    month VARCHAR(160) NOT NULL,
    year INTEGER NOT NULL
);


-- 5. Querying the dimensional model
SELECT 
	-- Get the total duration of all runs
	SUM(duration_mins)
FROM 
	runs_fact;

SELECT 
	-- Get the total duration of all runs
	SUM(duration_mins)
FROM 
	runs_fact
-- Get all the week_id's that are from July, 2019
INNER JOIN week_dim ON week_dim.week_id = runs_fact.week_id
WHERE month = 'July' and year = '2019';


-- 7. Name that data type!
/*
Unstructured:
- Images in your photo library
- Zip file of all text messages ever received
- To-do notes in a text editor

Semi-Structured:
- JSON object of tweets outputted in real-time by the Twitter API
- CSVs of open data downloaded from your local government websites
- html

Structured:
- A relational database with latest withdrawals and deposits made by clients.

*/