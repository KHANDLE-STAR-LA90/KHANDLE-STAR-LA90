## Education_own_continuous.R
Author: Fabian Corlier <br>
Lagnguage: R <br>
Date created: February, 6 2020 <br>
Questions can be sent to: fcorlier@ucla.edu <br>

## Decision history:
I convert educational attainment in a continuous variable that accounts for years until highschool (already continuous in the dataset) and complete with the ordinal variable W1_EDU_EDUCATION coded 0 to 5 into corresponding numbers of years (see bellow)


## Source variables:
W1_EDU_EDUCATION 
W1_EDU_EDUCATION_TEXT 
W1_EDU_TRNCERT 
W1_EDU_LONGCERT

 ## Coding language available:

| Derived Variable Name | SAS  | STATA  | R  |
| :---:   | :-: | :-: | :-: |
| maternal_primary_education |  |  | X |
| maternal_categorical_education |  |  | X |
| maternal_education_level_NA |  |  | X |
| paternal_primary_education |  |  |X|
| paternal_categorical_education |  |  |X|
| paternal_education_level_NA |  |  |X|

## Output variables:
TRUECERT has the respondent a vocational degree yes/no (used to construct the yrEDCUATION variable)
yrEDUCATION number of years of education 

## Pseudo code:
W1_EDU_EDUCATION contains the categorical advanced education (0 = none to 5=PhD and equivalent)
W1_EDU_EDUCATION_TEXT contains years of educ. for those who have <= 12 years of education
W1_EDU_TRNCERT has the respondent any additional training no: 0, self-taught: 1, or formally trained: 2)
W1_EDU_LONGCERT indicates how long it took to train (1-4, with 4 meaning duration >= 6months; that's the only one we consider long enougth)
 
 ### TRUE CERTIFICATE (vocational degree)
   We create a variable TRUECERT to indicate if respondent has a vocational degree not accounted for, in the years of education:  
   W1_EDU_TRNCERT indicates if participant has additional training and W1_EDU_LONGCERT indicated how long.
   if W1_EDU_TRNCERT=2 and W1_EDU_LONGCERT=4, then TRUECERT=1 (otherwise 0)
   
 ### One more year for vocational degrees  
   when TRUECERT=1, then W1_EDU_EDUCATION_TEXT gets +1
yrEDUCATION is the continuous education in years created by combining W1_EDU_EDUCATION_TEXT and W1_EDU_EDUCATION converted as follows:
 ### conversion to continuous years of education
    W1_EDU_EDUCATION   | equivalent years of education
    _____________________________________________________________
                  0   | W1_EDU_EDUCATION_TEXT (+1 if TRUECERT=1)
                  1   | 13 
                  2   | 14
                  3   | 16
                  4   | 18
                  5   | 20

### CUSTOM NAMING:
Make sure to create the data frame with the raw imported kHANDLE data (and change "W1_" to whichever wave number you use in the future)
DF <- ORGINIAL_DATA_IMPORTED_TO_R
