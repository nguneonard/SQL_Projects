
# PortfolioProject - COVID-19 Data Analysis
<p align="center">
  <img src="https://github.com/nguneonard/SQL_Projects/blob/main/Covid_Data_Analysis/corona2.jpg"  title="hover text", width=1000, height=600>
</p>

Welcome to the PortfolioProject on COVID-19 data analysis, where we explore different metrics to understand the impact of COVID-19 worldwide.

In this project, we analyze data related to COVID-19 deaths and vaccinations worldwide. We use SQL to extract data from our datasets,
<a href="https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/cases_deaths/full_data.csv"> full_data </a> and
<a href="https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.csv"> CovidVaccinations </a> join them and analyze them to extract meaningful insights. We perform different types of analysis on this data, such as comparing total deaths and cases per country, percentage of the population infected, percentage of the population vaccinated, and more.

## Getting Started
To use the SQL code in this repository, you will need to have access to SQL Server or another SQL environment. After that, clone the repository and open the .sql files in your preferred SQL environment.

We have provided detailed comments within the code that explain each step of the analysis process. Please read through the comments carefully to understand how the code works and how to interpret the results.

## Understanding the SQL Code
The SQL code in this repository performs several types of analysis on COVID-19 data, including:

- selecting data we are going to use
- looking at total cases Vs total deaths, which shows the likelihood of dying if you contract COVID-19 in your country
- total cases vs population, which shows what percentage of the population got COVID-19
- looking at countries with the highest infection rate compared to population
- showing countries with the highest death count
- breaking things down by continent
- looking at the continent with the highest death count
- a global overview of COVID-19 cases and deaths
- looking at total population vs vaccinations

In addition to these analyses, we also create a temporary table and a view to store the data for later visualizations.

## Conclusion
We hope you find this COVID-19 data analysis project useful and informative. Our goal was to provide meaningful insights into the impact of COVID-19 worldwide, and we believe that the SQL code we have provided can help you gain a deeper understanding of the pandemic's effects on different countries and populations.

Please feel free to use this code as a starting point for your own analysis and to adapt it to your own specific needs. Good luck, and stay safe!
