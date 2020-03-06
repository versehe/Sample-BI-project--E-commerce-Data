
/* 

project owner: Verse He
project start date: 2/1/2020


*/


----------------------------------------------------------------------
--                            sales by day                          --           
----------------------------------------------------------------------


SELECT dateadd(day,datediff(day,0,[created_on]),0) as date
,sum([amount]) as dailysale
FROM [Earnin].[dbo].[sale]
where created_on >= '2017/1/1'
group by  dateadd(day,datediff(day,0,[created_on]),0)
order by  dateadd(day,datediff(day,0,[created_on]),0)



----------------------------------------------------------------------
--                          sales by weekday                        --           
----------------------------------------------------------------------
SELECT weekday
,avg([amount]) as dailysale
FROM [Earnin].[dbo].[sale]
where [created_on] >= '2017/1/1'
group by   weekday
order by   weekday


----------------------------------------------------------------------
--               sold item amount and avg price by week             --           
----------------------------------------------------------------------

/* Create temp table for sold item amount per sale */
IF OBJECT_ID('tempdb..#item_amount_per_sale') IS NOT NULL 
DROP TABLE #item_amount_per_sale

SELECT count([item_id]) as item_amount
      ,[sale_id]
into #item_amount_per_sale
FROM [Earnin].[dbo].[item]
group by [sale_id]



select dateadd(week,datediff(week,0,[created_on]),0) as week
      , sum(i.item_amount) as item_amount
	  , sum(s.amount)/sum(i.item_amount)  as avg_price
from [Earnin].[dbo].[sale] s
inner join  #item_amount_per_sale i on s.id = i.sale_id
where
-- look back 3 years data 
[created_on] >= '2015/2/23' 
-- 2/27 is the begining of a new week, it's unfair to compare with entire weekly sale
and [created_on] <='2017/2/26'
group by dateadd(week,datediff(week,0,[created_on]),0) 
order by dateadd(week,datediff(week,0,[created_on]),0) 



----------------------------------------------------------------------
--              top 5 and bottom 5 most popular items               --           
----------------------------------------------------------------------

select top 5 item_id 
, count(item_id) as item_count
from [Earnin].[dbo].[item]
group by item_id 
order by  count(item_id) desc


select top 5 item_id 
, count(item_id)  as item_count
from [Earnin].[dbo].[item]
group by item_id 
order by  count(item_id) 