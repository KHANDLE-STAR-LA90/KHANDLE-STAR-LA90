Education_own_continuous
Date created:
February, 6 2020

Decision history:
I convert educational attainment in a continuous variable that accounts for years until highschool (already continuous in the dataset) and complete with the ordinal variable W1_EDU_EDUCATION coded 0 to 5 into corresponding numbers of years (see bellow)


Source variables:
W1_EDU_EDUCATION
W1_EDU_EDUCATION_TEXT
W1_EDU_TRNCERT
W1_EDU_LONGCERT

Coding language available:
Derived Variable Name	SAS	|STATA	|R
maternal_primary_education		| |X	
maternal_categorical_education	| |	X	
maternal_education_level_NA	|	|X	
paternal_primary_education	|	|X	
paternal_categorical_education	|	|X	
paternal_education_level_NA	|	|X	
Output variables:
TRUECERT has the respondent a vocational degree yes/no
yrEDUCATION number of years of education 
