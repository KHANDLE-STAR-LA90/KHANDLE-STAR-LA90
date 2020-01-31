#Parental Education

##Date created:
January 31, 2020

##Decision history:

I use three variables for both maternal and paternal education, years 0-12 coded as continuous, education beyond high school coded as ordinal, and an indicator for missingness (since this is a significant % of the sample). 

This was decision made my Audra Gold, Maria Glymour, and Sarah Ackley. 

##Source variables:

Maternal Variables:
1. W1_MATERNAL_EDUCATION
2. W1_MATERNAL_EDUCATION_TEXT

Paternal Variables:
1. W1_PATERNAL_EDUCATION
2. W1_PATERNAL_EDUCATION_TEXT

##Coding language available:

| Derived Variable Name | SAS  | STATA  | R  |
| :---:   | :-: | :-: | :-: |
| Derived Variable #1 |  | X |  |
| Derived Variable #2 |  | X |  |
| Derived Variable #3 |  | X |  |
| Derived Variable #4 |  | X |  |
| Derived Variable #5 |  | X |  |
| Derived Variable #6 |  | X |  |



##Output variables:
1.	maternal_primary_education – maternal continuous education years 0-12
2.	maternal_categorical_education – maternal ordinal education indicating level beyond HS 
3.	maternal_education_level_NA – maternal indicator variable for whether education is missing
4.	paternal_primary_education -- paternal continuous education years 0-12
5.	paternal_categorical_education – paternal ordinal education indicating level beyond HS
6.	paternal_education_level_NA – paternal indicator variable for whether education is
