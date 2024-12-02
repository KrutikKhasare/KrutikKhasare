create database manufacturing;
use manufacturing;

select *from manufacturing;

select count(*) from manufacturing;
desc manufacturing;

alter table manufacturing change `Manufactured Qty` manufactured_Qyt int;
alter table manufacturing change `Processed Qty` processed_Qyt int;
alter table manufacturing change `Produced Qty` produced_Qyt int;
alter table manufacturing change `Rejected Qty` Rejected_Qyt int;
alter table manufacturing change `Emp Name` Emp_Name text(20);
alter table manufacturing change `Machine Name` Machine_Name text(20);
alter table manufacturing change `Department Name` Department_Name text(20);
alter table manufacturing change `SO Delivery Date` SO_Delivery_Date text(30);
alter table manufacturing change `Delivery Period` Delivery_Period text(30);
ALTER TABLE manufacturing MODIFY SO_Delivery_Date DATE;
set sql_safe_updates=0;
update manufacturing set SO_Delivery_Date=str_to_date(SO_Delivery_Date,'%d/%m/%Y');

# Calculate Total Manufactired_Qyt
select sum(manufactured_Qyt) as Manufactured_Qyt from manufacturing;

# Calculate Total Rejected_Qyt
select sum(Rejected_Qyt) as Rejected_Qyt from manufacturing;

#Calculate Total Processed_Qyt
select sum(processed_Qyt) as Processed_Qyt from manufacturing;

# Calculate Wastage %
select concat(format(sum(Rejected_Qyt)/sum(Processed_Qyt),2),'%') from manufacturing;

# calculate Employees wise Rejected_Qyt
select Emp_Name, sum(Rejected_Qyt) as Rejected from manufacturing
group by Emp_Name
order by Rejected desc;

# calculate Machine wise Rejected_Qyt
select Machine_Name, sum(Rejected_Qyt) As Rejected from manufacturing
group by Machine_Name
order by Rejected desc;

# calculate Manufactured vs Rejected Qyt
select sum(Manufactured_Qyt) as Manufactured,
 sum(Rejected_Qyt) as Rejected from manufacturing;
 
 # calculate Dept Wise Manufactured vs Rejected Qyt
 select Department_Name,sum(Manufactured_Qyt) as Manufactured,
 sum(Rejected_Qyt) as Rejected from manufacturing
 group by Department_Name;
 
 # calculate Totalvalue
 select sum(totalvalue) as Total_Value from manufacturing;
 
 # calculate dept wise total values
 select Department_Name, sum(totalvalue) as Total_value
 from manufacturing
 group by Department_Name
 order by Total_value desc;
 
 # calculate month  wise total value where dept=Woven Lables
  select Department_Name,monthname(SO_Delivery_Date) as month, sum(totalvalue) as Total_value
 from manufacturing
 where department_Name='Woven Lables'
 group by Department_Name, month
 order by Total_value desc;
 
 # calculate mom_growth_%
 select monthname(SO_Delivery_Date) as month, sum(totalvalue) as total_value,
 concat(format(((sum(totalvalue)-lag(sum(totalvalue)) over(order by monthname(SO_Delivery_Date)))/
 lag(sum(totalvalue)) over(order by monthname(SO_Delivery_Date))*100),2),'%') as MOM_Growth from manufacturing
 group by month
 order by month asc;