#***PROJECT ON MACHINE_FAILURE***

#Business Problem: Predict machine failures in vehicles based on temperature, torque, and tool wear data to reduce unplanned maintenance 
#and improve operational efficiency.

#Objective: Develop a predictive model that can forecast machine failures in vehicles, allowing for timely maintenance and cost savings.

#Constraints: Limited historical data, potential data quality issues, and the need for a real-time prediction system may impose time and 
#resource constraints on model development.

#Data: This file contains the information of the 10000 samples of vehicles with the Torque , Tool Wear, Temperature, Air temperature 

#Project Artefacts:
#1 Data Description (Variable name , unit , range & description)
#2 .sql code 
#3 Inference  documents

create database vehicles;
use vehicles;
drop database vehicles;
show tables;

select * from `machine failure`;

#Duplicate row finding in total 
select `Product ID`, count(*) as DuplicateCount
from vehicles.`machine failure`
group by `Product ID`
having count(*)>1;

#Top 5 
select * from vehicles.`machine failure` limit 5;

#Distinct
select distinct(`Product ID`) from `machine failure`;

#Order by
select distinct(`Product ID`) from `machine failure` order by `Product ID`;

#Descriptive
select
	avg(`Air temperature [K]`) as avg_Air_temperature,
	min(`Air temperature [K]`) as min_Air_temperature,
	max(`Air temperature [K]`) as max_Air_temperature
from vehicles.`machine failure`;

#Between
select * from `machine failure`
where `Air temperature [K]` between 301 and 302;

# mean    
select avg(AirTemperature) as mean_AirTemperature,
avg(ProcessTemperature) as mean_ProcessTemperature,
avg(RotationalSpeed) as mean_RotationalSpeed,
avg(Torque) as mean_Torque,
avg(ToolWear) as mean_ToolWear from machine;

# median
#for AirTemperature
 
select AirTemperature as median_experience 
from (
    select AirTemperature, row_number() over (order by AirTemperature) as row_num,
           count(*) over () as total_count
    from machine
) as subquery
where row_num = (total_count + 1) / 2 or row_num = (total_count + 2) / 2; 
  
#for ProcessTemperature

select ProcessTemperature as median_experience 
from (
    select ProcessTemperature, row_number() over (order by ProcessTemperature) as row_num,
           count(*) over () as total_count
    from machine
) as subquery
where row_num = (total_count + 1) / 2 or row_num = (total_count + 2) / 2;  

#for RotationalSpeed

select RotationalSpeed as median_experience 
from (
    select RotationalSpeed, row_number() over (order by RotationalSpeed) as row_num,
           count(*) over () as total_count
    from machine
) as subquery
where row_num = (total_count + 1) / 2 or row_num = (total_count + 2) / 2;  

#for Torque

select Torque as median_experience 
from (
    select Torque, row_number() over (order by Torque) as row_num,
           count(*) over () as total_count
    from machine
) as subquery
where row_num = (total_count + 1) / 2 or row_num = (total_count + 2) / 2;  

#for ToolWear
select ToolWear as median_experience 
from (
    select ToolWear, row_number() over (order by ToolWear) as row_num,
           count(*) over () as total_count
    from machine
) as subquery
where row_num = (total_count + 1) / 2 or row_num = (total_count + 2) / 2; 

 
# mode
 select MachineFailure as mode_MachineFailure
from (
    select MachineFailure, COUNT(*) as frequency
    from machine
    group by MachineFailure
    order by frequency desc
    limit 1
) as subquery;

# Second Moment Business Decision/Measures of Dispersion
# Variance

select variance(AirTemperature) as AirTemperature_variance,
variance(ProcessTemperature) as ProcessTemperature_variance,
variance(RotationalSpeed) as RotationalSpeed_variance,
variance(Torque) as Torque_variance,
variance(ToolWear) as ToolWear_variance
from machine;

# Standard Deviation 

select stddev(AirTemperature) as AirTemperature_stddev,
stddev(ProcessTemperature) as ProcessTemperature_stddev,
stddev(RotationalSpeed) as RotationalSpeed_stddev,
stddev(Torque) as Torque_stddev,
stddev(ToolWear) as ToolWear_stddev
from machine;

# Range
select max(AirTemperature) - MIN(AirTemperature) as AirTemperature_range,
max(ProcessTemperature) - MIN(ProcessTemperature) as ProcessTemperature_range,
max(RotationalSpeed) - MIN(RotationalSpeed) as RotationalSpeed_range,
max(torque) - MIN(torque) as torque_range,
max(ToolWear) - MIN(ToolWear) as ToolWear_range
from machine;

# Third and Fourth Moment Business Decision
-- skewness and kurkosis 
select
    (
        sum(power(AirTemperature - (select avg(AirTemperature) from machine), 3)) / 
        (count(*) * power((select stddev(AirTemperature) from machine), 3))
    ) as skewness,
    (
        (sum(power(AirTemperature - (select avg(AirTemperature) from machine), 4)) / 
        (count(*) * power((select stddev(AirTemperature) from machine), 4))) - 3
    ) as kurtosis
from machine;

