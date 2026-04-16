# Total expected amount
SELECT 
    SUM(CAST(REPLACE(REPLACE(REPLACE(`Expected Amount`, ',', ''), '$', ''), ' ', '') AS DECIMAL(18,2))) 
    AS Total_Expected_Amount
FROM `oppertuninty table`
WHERE `Stage` NOT IN ('Closed Lost', 'Closed Won');
------------------------------------------------------------------------------------------------------------------------
# Active opportunities 
SELECT 
    COUNT(*) AS Active_Opportunities
FROM `oppertuninty table`
WHERE `Stage` NOT IN ('Closed Lost', 'Closed Won');
------------------------------------------------------------------------------------------------------------------------
# Opportunity Conversion Rate (%)
SELECT 
    ROUND(
        (COUNT(CASE WHEN `Stage` = 'Closed Won' THEN 1 END) / COUNT(*)) * 100,
        2
    ) AS Conversion_Rate_Percent
FROM `oppertuninty table`;
------------------------------------------------------------------------------------------------------------------------
# 👉 Win Rate (%)
SELECT 
    ROUND(
        (COUNT(CASE WHEN `Stage` = 'Closed Won' THEN 1 END) / 
         COUNT(CASE WHEN `Stage` IN ('Closed Won','Closed Lost') THEN 1 END)) * 100,
        2
    ) AS Win_Rate_Percent
FROM `oppertuninty table`;
------------------------------------------------------------------------------------------------------------------------
# Loss Rate (%)
SELECT 
    ROUND(
        (COUNT(CASE WHEN `Stage` = 'Closed Lost' THEN 1 END) / COUNT(*)) * 100,
        2
    ) AS Loss_Rate_Percent
FROM `oppertuninty table`;
------------------------------------------------------------------------------------------------------------------------
# Expected Revenue by Opportunity Stage
SELECT 
    TRIM(`Stage`) AS Stage,
    SUM(
        CAST(REPLACE(REPLACE(REPLACE(`Expected Amount`, ',', ''), '$', ''), ' ', '') 
        AS DECIMAL(18,2))
    ) AS Total_Expected_Amount
FROM `oppertuninty table`
GROUP BY TRIM(`Stage`)
ORDER BY Total_Expected_Amount DESC;
------------------------------------------------------------------------------------------------------------------------
# Expected Revenue by Lead Source
SELECT 
    `Lead Source`,
    SUM(
        CAST(REPLACE(REPLACE(REPLACE(`Expected Amount`, ',', ''), '$', ''), ' ', '') 
        AS DECIMAL(18,2))
    ) AS Total_Expected_Amount
FROM `oppertuninty table`
GROUP BY `Lead Source`
ORDER BY Total_Expected_Amount DESC;
------------------------------------------------------------------------------------------------------------------------
# Opportunities & Revenue by Industry
SELECT 
    TRIM(a.`Industry`) AS Industry,
    
    COUNT(o.`Opportunity ID`) AS Total_Opportunities,
    
    SUM(
        CAST(
            REPLACE(REPLACE(REPLACE(o.`Expected Amount`, ',', ''), '$', ''), ' ', '') 
        AS DECIMAL(18,2))
    ) AS Total_Expected_Amount

FROM `oppertuninty table` o
LEFT JOIN `account` a 
    ON o.`Account ID` = a.`Account ID`

WHERE a.`Industry` IS NOT NULL
  AND TRIM(a.`Industry`) != ''
  AND TRIM(a.`Industry`) != 'FALSE'

GROUP BY TRIM(a.`Industry`)
ORDER BY Total_Expected_Amount DESC;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Total Leads
SELECT COUNT(*) AS Total_Leads
FROM `lead`;
------------------------------------------------------------------------------------------------------------------------
#Expected Revenue from Converted Leads
SELECT 
    SUM(
        CAST(REPLACE(REPLACE(REPLACE(o.`Expected Amount`, ',', ''), '$', ''), ' ', '') 
        AS DECIMAL(18,2))
    ) AS Expected_From_Converted_Leads
FROM `lead` l
LEFT JOIN `oppertuninty table` o
    ON l.`Converted Opportunity ID` = o.`Opportunity ID`
WHERE l.`Converted` = 'TRUE';
------------------------------------------------------------------------------------------------------------------------
#Converted Opportunities (Leads to Opportunities)
SELECT 
    SUM(`# Converted Opportunities`) AS Converted_Opportunities
FROM `lead`;
------------------------------------------------------------------------------------------------------------------------
#Converted Accounts (Leads to Customers)
SELECT 
    SUM(`# Converted Accounts`) AS Converted_Accounts
FROM `lead`;
------------------------------------------------------------------------------------------------------------------------
#Lead Conversion Rate (%)
SELECT 
    ROUND(
        (SUM(`# Converted Opportunities`) / COUNT(*)) * 100,
        2
    ) AS Conversion_Rate_Percent
FROM `lead`;
------------------------------------------------------------------------------------------------------------------------
#Leads by Stage (Grouped)
SELECT 
    CASE 
        WHEN TRIM(`Status`) = 'Open' THEN 'Open Leads'
        WHEN TRIM(`Status`) = 'Converted' THEN 'Converted Leads'
        WHEN TRIM(`Status`) = 'Nurturing' THEN 'Nurturing Leads'
        ELSE 'Other'
    END AS Stage_Group,
    COUNT(*) AS Total_Leads
FROM `lead`
WHERE `Status` IS NOT NULL
  AND TRIM(`Status`) != ''
  AND TRIM(`Status`) != 'FALSE'
GROUP BY Stage_Group
ORDER BY Total_Leads DESC;
