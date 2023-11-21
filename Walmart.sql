							  # [  Walmart Sales Data Analysis ]

# --------Feature Engineering (this will help us to generate some new columns from existing ones)----------------------
 ---------------------------------------------------------------------------------------------------------------------
 
# a. Adding a new column named [ time_of_day ] ( morning , afternoon , evening )

    select time,
          ( case 
               when time between "00:00:00" and "12:00:00" then "Morning"
               when time between "12:01:00" and "16:00:00" then "Afternoon"
               else "Evening"
		   end ) as time_of_day
	from saleswalmart;
    
alter table saleswalmart add column time_of_day varchar (20) ;
update saleswalmart
set time_of_day = ( case 
               when time between "00:00:00" and "12:00:00" then "Morning"
               when time between "12:01:00" and "16:00:00" then "Afternoon"
               else "Evening"
		   end ) ;
    
# b. Adding a new column named [ day_name ]
              
              select 
                    date,
                    dayname(date) as day_name
			from saleswalmart;

alter table saleswalmart add column day_name varchar (20);
update saleswalmart
set day_name = dayname(date);

# c. Adding a new column named [ month_name ]

                   select 
                    date,
                    monthname(date) as month_name
			from saleswalmart;
            
alter table saleswalmart add column month_name varchar (20);
update saleswalmart
set month_name = monthname(date);

-------------------------------------------------------------------------------------------------------------------------------
 ----------------------------------------------- Generic -----------------------------------------------------------------------

# 1. How many unique cities does the data have ?
          
          select distinct city from saleswalmart;
          
# 2. In which city is each branch ?
         
         select distinct city,
                branch 
		from saleswalmart;
        
 --------------------------------------------------------------------------------------------------------------------       
 ---------------------------------------------- Product--------------------------------------------------------------
 
 # 1. How many unique product lines does the data have ?
 
              select distinct product_line
              from saleswalmart;
              
# 2.  what is the  Most common payment method ?
             
             select count(payment_method) as count,
                    payment_method 
			 from saleswalmart
             group by payment_method
             order by count desc;
             
# 3. what is the most selling product line ?
              
              select count(product_line) as count,
					product_line
              from saleswalmart
              group by product_line
              order by count desc;
              
# 4.  what is the total revenue by month ?
             
             select month_name as month ,
				    SUM(total) as total_revenue
	        from saleswalmart
            group by month_name
            order by total_revenue desc;
            
# 5. what month had the largest cogs (cost of goods sold ) ?
              
               select month_name as month ,
				    SUM(cogs) as cost_of_goods_sold
	        from saleswalmart
            group by month_name
            order by cost_of_goods_sold  desc;
            
# 6. what product line had the largest renvenue ?

            select product_line,
                   SUM(total) as total_revenue
                   
			from saleswalmart
            group by product_line
            order by total_revenue desc;
            
# 7.  what is the city with the largest revenue ?
             
             select city,
                    sum(total) as total_revenue
                    
		    from saleswalmart
            group by city
            order by total_revenue desc;
            
# 8. what product line had he largest VAT( value added tax )?
 
			select product_line,
                   avg(vat) as avg_Vat
                   
			from saleswalmart
            group by product_line
            order by avg_vat desc;
	
# 9. Which branch sold more products than average product sold ?	
            
            select branch,
		           sum(quantity) 
                   
			from saleswalmart
            group by branch
            having sum(quantity) > (select avg(quantity) from saleswalmart);
		
# 10. What is the most common product line by gender?

                     select count(gender) as count,
							gender,
                            product_line                  
                            
					from saleswalmart
                    group by gender , product_line
                    order by count desc;
             
# 11.  What is the average rating of each product line ?
                    
                    select  round(avg(rating) , 2) as ratings,
                           product_line
                           
				    from saleswalmart
                    group by product_line
                    order by ratings desc;
                    
-----------------------------------------------------------------------------------------------------------------                    
------------------------------------------- Sale-----------------------------------------------------------------


# 1.  Number of sale made in each time of the day per weekday 

		        SELECT
	                   time_of_day,
	                   COUNT(*) AS total_sales
				FROM saleswalmart
				WHERE day_name = "Sunday"
				GROUP BY time_of_day 
				ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

# 2. Which of the customer types brings the most revenue?
                  
                  SELECT
	                   customer_type,
	                   SUM(total) AS total_revenue
                  FROM saleswalmart
                  GROUP BY customer_type
                  ORDER BY total_revenue;

# 3. Which city has the largest tax/VAT percent?
                    
                    SELECT
						  city,
                          ROUND(AVG(vat), 2) AS avg_tax_pct
                    FROM saleswalmart 
                    GROUP BY city 
                    ORDER BY avg_tax_pct DESC;

# 4. Which customer type pays the most in VAT?
					
                    SELECT
               	            customer_type,
	                        AVG(tax_pct) AS total_tax
                    FROM saleswalmart
                    GROUP BY customer_type
					ORDER BY total_tax;
----------------------------------------------------------------------------------------------------------------------------  -                  
--------------------------------------- Customer-------------------------------------------------------------------------------

# 1. How many unique customer types does the data have ?
      
			  SELECT
					DISTINCT customer_type
              FROM saleswalmart;
               
# 2. How many unique payment methods does the data have?

			SELECT
					DISTINCT payment_method
             FROM saleswalmart;
             
# 3. What is the most common customer type?

			SELECT
					customer_type,
	                count(*) as count
            FROM saleswalmart
            GROUP BY customer_type
            ORDER BY count DESC;

# 4. Which customer type buys the most?

			SELECT
	                customer_type,
					COUNT(*)
            FROM saleswalmart
            GROUP BY customer_type;
            
# 5. What is the gender of most of the customers?

                     SELECT
	                      gender,
	                      COUNT(*) as gender_cnt
                     FROM saleswalmart
                     GROUP BY gender
                     ORDER BY gender_cnt DESC;
                     
# 6. What is the gender distribution per branch ?

                   select
                           gender,
                           branch,
                           count(*) as gender_count
				  from saleswalmart
                  where branch = "C"
				  group by gender
                  ORDER BY gender_count;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

# 7.  Which time of the day do customers give most ratings ?

                        select time_of_day,
                               avg(rating) as ratings
						from saleswalmart
                        group by time_of_day
                        order by ratings desc;
			#[ In Afternoon customers give more ratings]

# 8.  Which time of the day do customers give most ratings per branch ?
                             
						select time_of_day,
                                branch,
                               avg(rating) as ratings
						from saleswalmart
                        where branch = "A"
                        group by time_of_day
                        order by ratings desc;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.
                      
# 9. Which day fo the week has the best avg ratings ?
                  
                  Select day_name,
                         avg(rating) as ratings
                         
				  from saleswalmart
                  group by day_name
                  order by ratings desc;
-- Mon, Tue and Friday are the top best days for good ratings

# 10. Which day of the week has the best average ratings per branch ?

                     select day_name,
                             branch ,
                            avg(rating) as ratings
                            
					 from saleswalmart
                     where branch = "c"
                     group by day_name
                     order by ratings desc;
 -- Branch C has the best average ratings among all.