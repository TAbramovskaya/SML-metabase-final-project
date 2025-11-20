Our goal is to divide the 2,285 customers into groups according to the RFM methodology, and then consolidate them into larger segments based on behavioral patterns. As a result of our work, we will obtain 6 major segments. The methods for working with the recency, frequency, and monetary metrics are presented below.

![](images/customer_segments.png)

Let’s define the methodology and the labeling format for assigning users to groups.

## Recency

How recently did a customer make a purchase? Since we are working with a limited dataset, we will treat the last day in the dataset as the zero point for recency. For each customer, we will determine the minimum number of days between their purchases and this date. We use a smaller group number for more recent activity (any customer from Group 1 made his/her most recent purchase after any customer from Group 3). Analysis and grouping in the [Recency](recency_study.md) section.

## Frequency

How often does a customer buy? Multiple receipts on the same day are very rare (among regular customers, only 91 made two or more purchases in a single day). Therefore, we will measure purchase frequency based on the number of receipts rather than the number of calendar days. We use a smaller group number for higher frequency (Group 1 uses the store more often than Group 3). See the [Frequency](frequency_study.md).

## Monetary

How much does a customer spend? We will review publicly available research from the analytical company RNC Pharma to determine which monetary values should be considered "average" and use them to define the boundaries between the groups. We use a smaller group number for users with larger purchases (Group 1 spends more than Group 3). Continued in the [Monetary](monetary_study.md) section.

## Grouping

Now we’re ready to analyze the [Behavior](rfm_behavior.md) of the resulting groups. 
