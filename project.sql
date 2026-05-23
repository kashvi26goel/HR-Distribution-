create database pro;
use pro ;
select * from hr1;
alter table hr1
change column ï»¿id emp_id varchar(20) null;
select * from hr1;
describe hr1 ;
select birthdate from hr1;
set sql_safe_updates=0;
UPDATE hr1
SET birthdate = CASE
	WHEN birthdate LIKE '%/%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
select birthdate from hr1 ;
alter table hr1
modify column birthdate date ;
select birthdate from hr1;
update hr1
SET hire_date= CASE
	WHEN hire_date LIKE '%/%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
alter table hr1 
modify column hire_date DATE;
select termdate from hr1 ;
UPDATE hr1
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT termdate from hr1;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr1
MODIFY COLUMN termdate DATE;
alter table hr1
add column age int ;
select * from hr1 ;
update hr1 
set age = timestampdiff(YEAR,birthdate,curdate());
select
 min(age) as youngest,
 max(age) as eldest 
 from hr1;
 
 select count(*) from hr1 where age<18;
select gender , count(*) as count from hr1  
where age>=18 and termdate='0000-00-00'
group by gender ;

select race , count(*) as count from hr1  
where age>=18 and termdate='0000-00-00'
group by race
order by count(*) desc ;

select 
min(age) as youngest ,
max(age) as eldest
from hr1
 where age>=18 and termdate='0000-00-00';
 
 select 
 case 
 when age>=18 and age<=24 then '18-24'
 when age>=25 and age<=34 then '25-34'
 when age>=35 and age<=44 then '35-44'
 when age>=45 and age<=54 then '44-54'
 else '65+'
 END AS age_group,gender,
 count(*) as count
 from hr1
GROUP BY age_group , gender 
order by age_group,gender;

select location , count(*) as count from hr1
where age>=18 and termdate='0000-00-00'
group by location ;

select 
round(avg(datediff(termdate,hire_date))/365,0) as avg_employemnt 
from hr1
where termdate<=curdate() and termdate<>'0000-00-00'and age>=18;

select department , gender , count(*) as count
from hr1 
where  age>=18 and termdate='0000-00-00'
group by department , gender ;

select jobtitle ,count(*) as count 
from hr1 
where age>=18 and termdate='0000-00-00' 
group by jobtitle
order by jobtitle desc ;

select department ,
 total_count , 
 terminated_count,
terminated_count/ total_count as termin_rate
from ( select department , count(*) as total_count, 
sum(case when termdate<>'0000-00-00' and termdate<=curdate() then 1 else 0 end) as terminated_count
from hr1
where age>=18 
group by department) as subquery
order by termin_rate desc;

select location_state , count(*) as count 
from hr1 
where age>=18 and termdate='0000-00-00'
group by location_state 
order by location_state desc ;

select year , hires , termins , 
hires - termins as net_change,
round((hires-termins)/hires*100,2) as net_change_percent
from( select year(hire_date) as year , 
count(*) as hires ,
sum(case when termdate<>'0000-00-00' and termdate<=curdate() then 1 else 0 end) as termins
from hr1 
where age>=18
group by year(hire_date)) as subquery
order by year asc ;



