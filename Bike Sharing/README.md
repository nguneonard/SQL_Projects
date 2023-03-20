# Bike Sharing Data Analysis with SQL Server
<p align="center">
  <img src="https://github.com/nguneonard/SQL_Projects/blob/main/Bike%20Sharing/Bicycle-sharing_systems.jpg"  title="hover text", width="1000" height="600">
</p>

In this project, we will analyze data from a bike-sharing program using SQL server. The data contains information on bike rentals, such as the date, time, and location of the rental, as well as the duration and distance of the ride. The goal of the analysis is to gain insights into bike usage patterns and help the bike-sharing program improve its operations.

This repository contains a SQL script used for cleaning and checking the quality of data from the Divvy bikeshare service in Chicago. The script loads the data from various trip data tables into a single table called CYCLIST_TRIP_DATA. The data is then explored, checked for quality issues, and cleaned.

## Getting Started
To run this script, you need access to a SQL server and the trip data tables from the Divvy bikeshare service in Chicago https://www.divvybikes.com/system-data. The script expects the tables to be named in the format YYYYMM-divvy-tripdata, where YYYY is the year and MM is the month of the data. The script should be run in the following order:

- Create a new database and set it as the current database.
- Create a new schema called dbo.
- Run the script.

## CYCLIST_TRIP_DATA Table
The script creates a new table called CYCLIST_TRIP_DATA by combining the data from the trip data tables. This table is then used for data exploration, quality checks, and cleaning.

## Data Exploration
The script includes various queries that explore the data and provide insights into the usage of the Divvy bikeshare service. These queries count the number of records, find the number of rides by casual-members and rides by annual-members, count the number of rideable types, and count the number of rides starting and ending at each docking station.

## Data Quality Check
The script also includes queries that check for data quality issues such as null values, duplicates, and anomalies. These queries ensure that the data is reliable and accurate.

## Data Cleaning
After identifying quality issues, the script cleans the data by deleting all rows where any field is null and identifying and excluding data with anomalies.

## Conclusion
This script provides a comprehensive solution for cleaning and checking the quality of data from the Divvy bikeshare service in Chicago. The queries in the script provide insights into the usage of the service, while the quality checks and data cleaning ensure the data is reliable and accurate.






