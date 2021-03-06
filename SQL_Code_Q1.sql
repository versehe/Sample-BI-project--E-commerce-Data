
/* 

project owner: Verse He
project start date: 1/31/2020

The overall logic for this code is to devide and conquer,
I firstly dealed with users with unique IDs. Then, for those
users with duplicated IDs, I use their user registration time 
and device registration time to find the right match. 

*/


----------------------------------------------------------------------
--                           single ID users                        --           
----------------------------------------------------------------------

/* Create temp table to contain all users with unique ID */
IF OBJECT_ID('tempdb..#unique_id_user') IS NOT NULL 
DROP TABLE #unique_id_user

SELECT  [id]    
into #unique_id_user
FROM [Earnin].[dbo].[user]
group by [id]
having count(id) = 1



/* 
--This query is to  check if any user have multiple devices
select u.id as userID
      , count(d.device_id) 
from #unique_id_user u
left join [Earmin].[dbo].[user_device] d on u.id = d.user_id
group by u.id
having count(d.device_id)  > 1
 */


/* 
each user only has 1 device, but this device could align with multiple campaign.
In this case, find the campaign closest to device create date 
*/
IF OBJECT_ID('tempdb..#unique_user_campaign') IS NOT NULL 
DROP TABLE #unique_user_campaign

select *
into #unique_user_campaign
from 
(
select u.id as userID
      , us.name
      , ud.device_id
	  , us.created_on as user_create_time
	  , d.created_on as device_create_time
	  ,a.campaign
	  ,a.created_on as campaign_create_time
	  , max(a.created_on) over (partition by u.id  )  as last_campaign_date
from #unique_id_user u
inner join [Earnin].[dbo].[user] us on u.id = us.id
left join [Earnin].[dbo].[user_device] ud on u.id = ud.user_id
left join [Earnin].[dbo].[device] d on ud.device_id = d.id  
left join [Earnin].[dbo].[attribution] a on d.id = a.device_id  
and a.created_on <= us.created_on  and a.created_on <= d.created_on -- compaign should create prior to user and device registation date
) tblA
where last_campaign_date  = campaign_create_time 
-- in case there is no eligible campaign for this user 
or  last_campaign_date  is null
order by userID




----------------------------------------------------------------------
--                    users with duplicated ID                      --           
----------------------------------------------------------------------

/* Create temp table to contain all users with duplicated ID */
IF OBJECT_ID('tempdb..#duplicate_id_user') IS NOT NULL 
DROP TABLE #duplicate_id_user

SELECT  [id]    
into #duplicate_id_user
FROM [Earnin].[dbo].[user]
group by [id]
having count(id) > 1



/* 
each user only has 1 device, but this device could align with multiple campaign.
In this case, find the campaign closest to device create date 
*/
IF OBJECT_ID('tempdb..#dup_user_campaign') IS NOT NULL 
DROP TABLE #dup_user_campaign

select *
into  #dup_user_campaign
from 
(
select u.id as userID
	  , us.name
      , ud.device_id
	  , us.created_on as user_create_time
	  , d.created_on as device_create_time
	  ,a.campaign
	  ,a.created_on as campaign_create_time
	  , max(a.created_on) over (partition by  us.name )  as last_campaign_date
--into #dup_user_device
from  #duplicate_id_user u
inner join [Earnin].[dbo].[user] us on u.id = us.id
left join [Earnin].[dbo].[user_device] ud on u.id = ud.user_id
left join [Earnin].[dbo].[device] d on ud.device_id = d.id 
left join [Earnin].[dbo].[attribution] a on d.id = a.device_id  and a.created_on <= us.created_on  and a.created_on <= d.created_on -- compaign should create prior to user and device registation date
where abs(DATEDIFF(hour,us.created_on ,d.created_on )) < 19
/* why threhold is 19 hours?
after limited time different into 2 days, I was able to find most device id with single user id
however, there is a corner case:  user_id = '2807'
so I looked at this special case detail and figured out 19 hours is the threhold to fix it

***please be aware that this 19 hour threhold could only apply to duplicated users, it's not work properly with unique users
*/
) tblA
where last_campaign_date  = campaign_create_time 
-- in case there is no eligible campaign for this user 
or  last_campaign_date  is null
order by userID



----------------------------------------------------------------------
--                           final result                           --           
----------------------------------------------------------------------

IF OBJECT_ID('tempdb..#result') IS NOT NULL 
DROP TABLE #result

select userid, name, 
      case when DATEDIFF(day,campaign_create_time,user_create_time ) <= 1 then campaign else null end as campaign , user_create_time ,campaign_create_time
into #result
from #unique_user_campaign
union 
select userid, name,
	 case when DATEDIFF(day,campaign_create_time,user_create_time ) <= 1 then campaign else null end as campaign ,user_create_time,campaign_create_time
from #dup_user_campaign


-- display campaign attribution 
select campaign, count(userid) as attribution
from #result
group by  campaign
order by count(userid) desc


-- display attribution by week
select  dateadd(week,datediff(week, 0,user_create_time),0) as Weeks
, count(userid) as attribution
from #result
group by   dateadd(week,datediff(week, 0,user_create_time),0)
order by  dateadd(week,datediff(week, 0,user_create_time),0)