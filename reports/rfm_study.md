Let’s define the methodology and the labeling format for assigning users to groups.

Recency (how recently a customer made a purchase). Since we are working with a limited dataset, we will treat the last day in the dataset as the zero point for recency. For each customer, we will determine the minimum number of days between their purchases and this date. We use a smaller group number for more recent activity (any customer from Group 1 made his/her most recent purchase after any customer from Group 3). See the [recency study](recency_study.md).

Frequency (how often they buy). As we observed during data preparation, multiple receipts on the same day are very rare (for regular customers). Therefore, we will measure purchase frequency based on the number of receipts rather than the number of calendar days. We use a smaller group number for higher frequency (Group 1 uses the store more often than Group 3). See the [frequency study](frequency_study.md).

Monetary (how much they spend). We will review publicly available research from the analytical company RNC Pharma to determine which monetary values should be considered “average” and use them to define the boundaries between the groups. We use a smaller group number for users with larger purchases (Group 1 spends more than Group 3). See the [monetary study](monetary_study.md).

As a result, we obtained 36 groups. 


