# Adventurework-Comprehensive-Analytics

**Please download the HTML version of the Jupiter Notebook to interact with the Chart**

# General Overview
This analytics project aims to boost AdventureWorks Cycles' revenue by analyzing company data. The process includes accessing the data warehouse, data cleaning, and transformation, followed by a detailed examination to extract valuable insights for strategic decision-making.

**Goal**: 
* **Interactive:** Discover trends and make informed decisions in their respective roles.
* **Dynamic, Real-time Update:**  Our charts and dashboards dynamically update in real-time as data

## About AdventureWorks Cycles
AdventureWorks Cycles, headquartered in Bothell, Washington, is a major multinational manufacturer of metal and composite bicycles. With a strong presence in North America, Europe, and Asia, the company employs 500 individuals and strategically deploys regional sales teams to serve its diverse market base.

![image](https://github.com/MarkPhamm/Adventureworks-Analytics/assets/99457952/677fbdee-9968-4ad1-b424-100208ade77e)


## Tools
**Tools used:** 
* SQL Server
* Python notebook
* Azure Data Studio
* PowerBI
## Appendix
![image](https://github.com/MarkPhamm/Adventureworks-Analytics/assets/99457952/f51e16de-879d-4317-9ba5-f6cb0101cd85)
* **a. Data Cleaning and Transformation:** (SQL Server)
  * Assumptions
  * Transformation
  * New Star Schema

   
* **b. Descriptive Analysis:** (Python, Azure, and SQL)
  * Step 1: Key Metrics Analysis
  * Step 2: Time Series Analysis
  * Step 3: Product Analysis
  * Step 4: Customer Analysis
 
* **c. Diagnostics Analysis:** (Dashboard with PowerBI)
  * Step 5: Time Series Dashboard
  * Step 6: Geographical Dashboard
  * Step 7: Demographic Dashboard
  * Step 8: Product Selection Dashboard
  
* **d. Predictive Analysis:** (Machine Learning/Deep Learning using Python)
  * Step 9: Trendline
  * Step 10: ARIMA Model
  * Step 11: LSTM Model
  
* **e. Prescriptive Analysis:** (Recommendation for the next year)
  * Step 12: To-be Business model with Actionable Insight

# Analysis
## a. Data Cleaning and Transformation:
  * **Transformation:** Given that we don't require all the columns from the table, it is advisable to cherry-pick only the essential ones. Additionally, we plan to:
    * Data cleaning by standardized datetime values for improved consistency.
    * Eliminate unnecessary columns
    * Apply more reader-friendly names.
    * Introduce new calculated columns, including Profit, Profit Margin, ShipStatus, TimeToArrive, TimeToShip, Model Name, and Customer Age for enhanced analytical insights.
     
  * **New Star Schema:**
     ![image](https://github.com/MarkPhamm/Adventureworks-Analytics/assets/99457952/ea06b28f-57af-4e2f-8ca8-ea94243f9495) 

## b. Descriptive Analysis
### 1. Key Metrics
 - Total Revenue: $29M
 - Total Profit: $9M
 - Total Tax Amount: $2.4M
 - Total Freight Cost: $734K
 - Profit Margin: 42.84%

### 2. Time Series Analysis (Only 2011, 2012, 2013, Exclude Dec 2010 and Jan 2014)
* **Yearly**

![image](https://github.com/MarkPhamm/Adventureworks-Analytics/assets/99457952/ea6be652-d5bf-4c36-aebe-c8fb8c1c5147)

    - 2011: 7 Millions
    - 2012: 6 Millions
    - 2013: 14 Millions
    - 2014 and 2010: 2 Millions (December 2010 and January 2011
  
* **Monthly**

![image](https://github.com/MarkPhamm/Adventureworks-Analytics/assets/99457952/7d7a5735-85c7-4e03-8e73-9160c59b46b1)

    - Best: June, October, November, December
    - Worst: January, February, April

### 3. Product Analysis
![image](https://github.com/MarkPhamm/Adventureworks-Analytics/assets/99457952/66a535a2-e9bf-4911-b4be-287b10ce355a)

*  **Overview**
   - **Bikes:** 95% Profits
   - **Clothing:** 4% Profits
   - **Accessories:** 1% Profits
* **Best and worst Selling**
  - **Best Selling:** Mountain Model 200 (high revenue, high profit)
  - **Worst selling** Road 650, Road 750, Clothing Caps (low Revenue, low profit Margin)


### 4. Customer Analysis
![image](https://github.com/MarkPhamm/Adventureworks-Analytics/assets/99457952/b7a44326-7ec2-47e6-adaa-62aec3a8b220)

* **Education:** Bachelors, Graduate and Partial College
* **Occupation:** Professional, Management, and Skill Manual
* **Sex:** Both M and F
* **Income:** $70000
* **Age:** From 40 to 60

## c. Diagnostics Analysis
### 5. Time Series Dashboard (Why was 2013 Revenue so high?)
- Mountain Bikes Sales increase (Especially model 200)
- Accessories and Clothing were introduced
- Touring Bikes was introduced (Generating 3.7 million dollars).

### 6. Geographical Dashboard
![image](https://github.com/MarkPhamm/Adventureworks-Analytics/assets/99457952/82375fb2-1279-4c0f-8b11-8914918599ae)

Here are the best current markets for the Model 200
- Top Country: USA, Australia, United Kingdom
- Top States: California, England (General), New Southwale, Washington, British Columbia, Queensland (All coast state)
- Top City: London, Paris, Bendigo, Wollongong, Berlin

### 7. Demographic Dashboard
![image](https://github.com/MarkPhamm/Adventureworks-Analytics/assets/99457952/13c3baae-47fd-400e-a3a4-ee689acf097e)

Here are the current demographic needs for the Model 200
- Education: Bachelors, Graduate and Partial College
- Occupation: Professional, Management, and Skill Manual
- Sex: Both M and F
- Income: $70000
- Age: From 40 to 60

### 8. Product Selection Dashboard
  - Best Selling: Mountain Model 200 (high revenue, high profit)
  - Worst selling: Road 650, Road 750, Clothing Caps (low Revenue, low-profit Margin)


## d. Predictive Analysis:
### 9. Trendline
![image](https://github.com/MarkPhamm/Adventureworks-Analytics/assets/99457952/75555e76-62dc-40f4-b5f3-366fe8d7502a)

### 10. ARIMA Model
![image](https://github.com/MarkPhamm/Adventureworks-Analytics/assets/99457952/91b0cb94-0d52-4291-bf04-baeb1c312e7d)

### 11. LSTM model
![image](https://github.com/MarkPhamm/Adventureworks-Analytics/assets/99457952/9dd736d6-5894-432c-91cb-5d211d450192)



## e. Prescriptive Analysis:
### 12. Business Proposal (To-be​) Actionable Insight: Increase Model-200 Sales
1. **Cut product**
   * Cut Road 650, Road 750, Clothing Caps
    
3. **Using that budget to create a marketing campaign to tap into a new market for Model 200**
   * **Location:** Appalachian Mountains
   * **Criteria:**
   ![image](https://github.com/MarkPhamm/Adventureworks-Analytics/assets/99457952/eb253e0f-59e6-4612-b662-d1c0ba24612d)
   * **Suggestions**
     - Virginia (Roanoke)
     - West Virginia (Morgantown)
     - North Carolina (Asheville)
   * **Demographic:**
     - Education: Bachelors, Graduate and Partial College
     - Occupation: Professional, Management, and Skill Manual
     - Sex: Both M and F
     - Income: $70000
     - Age: From 40 to 60
   * **Time seasonality:**
     - June
     - October
     - November
     - December
    
4. **Create bundles with the Marketing campaign**
   * Create bundles when selling Mountain Bikes with Clothing/Accessories to increase purchasing initiative 
     
5. **Marketing channel:**
   * Local Bike Festivals - heart of Virginia bike festival, youth  cross-country bicycle rodeo
   * Partnership with local communities
   * Sponsorships, influencers, competitive bikers
     
6. **Forecast potential result**
   * Model-200 Revenue will increase by 50%
   * Clothing and Accessories will increase by 30%
