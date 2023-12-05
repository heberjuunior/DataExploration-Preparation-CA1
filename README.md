# DataExploration-Preparation-CA1
In this project developed by Heber Mota and Caroline De Sá, we manipulate a dataset in order to better analyse its data and learning outcomes. Lecturer: Muhammad  Iqbal.
The dataset chosen to carry out  Data Exploration & Preparation was a official dataset published by the FBI’s Uniform Crime Reporting (UCR) containing United States Hate Crimes Statistics (kaggle.com) between 1991-2018. These criminal offenses are cathegorized by the offender’s bias against gender, religion, sexual orientation ethnicity and against persons, properties or societies.
Given the Problem Domain above, we found that this dataset could be interesting to work with in order to better understand the motivations, offenses and victims figures by exploring this rich file. To extract thee most relevant insights we manipulated the dataset doing the following necessary changes:
Dimensionality Reduction: The dataset contained over 20.000 rows and 28 columns which were filtered down to 10.000 rows and 10 columns that allowed us to operate Dimensionality Reduction; 

Principal Component Analysis (PCA): By using techniques such as Information Compression and Exploratory Data Analysis (explained in the section Dimensionality Reduction) we ruled out variables such as “Unknown”, “NA” and columns that did not reflect onto significant information for this work such as “incident_ID” and redundant columns such as “Year” and “Date” where Year only presents the year and Date, the exact day, month, year of the incident.

Exploratory Data Analysis (EDA): By exploring the data we came up with filtered and straightforward information clearly presented in the several tables – presenting data comparison, contrast, statistical parameters such as mean, median, minimum, maximum, and standard deviation,  and  operating Min-Max Normalization, Z-score Standardization and Robust scalar on the numerical data variables, Dummy Encoding – as well as charts – charts depicting which variables are categorical, discrete and continuous, comparisons between offenders, vitms and locations or heatmaps.

![image](https://github.com/heberjuunior/DataExploration-Preparation-CA1/assets/72036949/9cd60294-3013-41d2-a4e6-428bf9d804be)
![image](https://github.com/heberjuunior/DataExploration-Preparation-CA1/assets/72036949/2a9a2bae-c1d3-4d42-b042-da3baf6a1a70)
![image](https://github.com/heberjuunior/DataExploration-Preparation-CA1/assets/72036949/d66897b8-59df-433b-8b4e-e1a485a0bdf0)
