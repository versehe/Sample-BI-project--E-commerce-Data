# Sample-BI-project--E-commerce-Data
This is a mimic BI project I did at February 2020 for a startup company interview. I shared it in my Github profile show off my BI skills and experience. This data was all generated by a script rather than actual users, but with some degree of thought to distributions and how it all fits together. 

## Questions
 
### 1. Marketing Attribution
* What campaign was responsible for each user's finding our app? 

 
    Tips:       
    * Think about assumptions or data cleanup steps related to data inconsistencies, many to many mappings, or broken database schemas in the data. These may cause SQL joins to return incorrect results. Thinking about timestamps is useful here       
    * Please describe how you decided what attribution logic to use. How much time would you allow between the attribution and the user creation, and why ? For example, you can compare simple vs complex methods and discuss the pros and cons


 
### 2. Low Sales
* It looks like sales have been a bit low the last couple of days of the sales data set. Is this something we should be worried about? 

 
    Tips:  
    * From a statistical perspective two things to lookout for are:                   
      * Historical trends and seasonality
      * Distribution of sales, statistical tests, time series techniques, conditional probabilities

    * From a business perspective: 
      * The link between sales, users, device and attribution data - can you find a potential root cause ? 
      * Comparison with the recent past and recent trends



## Dataset
* ERD: Database_ERD.png
* Dataset: Dataset Folder

## Project Deliverables

* Slides for submission: Slides_for_Submission.pptx
* Slides for presentation: Slides_for_Presentation.pptx
* A copy of database: Database_Local.bak
* SQL code for Question 1: SQL_Code_Q1.sql
* Result in Excel format (Question 1): Q1_Result.xlsx
* SQL code for Question 2: SQL_Code_Q2.sql
* Python code for T test (Question 2): Python_Code.py
