# Acculturation/Nativity Measures

## Overview
Code to create acculturation/nativity measures for KHANDLE particpants, parents, and grandparents

## Date created:
October 17, 2019

## Decision history:
Created second generation category as "any" parent foreign-born as decided by C.W. Eng, O.L. Meyer, and M.J. Ko.

## Source variables: 
1. `W1_COUNTRY_BORN`
2. `W1_FATHER_BORN`
3. `W1_MOTHER_BORN`
4. `W1_FATHERS_FATHER_BORN`
5. `W1_FATHERS_MOTHER_BORN`
6. `W1_MOTHERS_FATHER_BORN`
7. `W1_MOTHERS_MOTHER_BORN` 

 ## Coding language available:
| Derived Variable Name | SAS  | STATA  | R  |
| :---:   | :-: | :-: | :-: |
| foreignborn | x |  | |
| foreignborn_father | x |  | |
| foreignborn_mother | x |  | |
| foreignborn_fathers_father | x |  | |
| foreignborn_fathers_mother | x |  | |
| foreignborn_mothers_father | x |  | |
| foreignborn_mothers_mother | x |  | |
| secondgen | x |  | | 
| immigration_gen | x |  | |
| Version (Date) | V4 (01/24/20) | | |

## Output variables: 
1. `foreignborn` - whether particpant foreign born (1=yes, 0=no)
2. `foreignborn_father` - whether father foreign born (1=yes, 0=no)
3. `foreignborn_mother` - whether mother foreign born (1=yes, 0=no)
4. `foreignborn_fathers_father` - whether whether father's father foreign born (1=yes, 0=no)
5. `foreignborn_fathers_mother` - whether whether father's mother foreign born (1=yes, 0=no)
6. `foreignborn_mothers_father` - whether whether mother's father foreign born (1=yes, 0=no) 
7. `foreignborn_mothers_mother` - whether whether mother's mother foreign born (1=yes, 0=no) 
8. `secondgen` - full categorical variable of whether participant is second generation (separated by parent)
9. `immigration_gen` - numeric generation (1=first generation, 2=second generation (any parent), 3=third or higher generation

## Created by

Chloe W. Eng, UCSF 

chloe.eng@ucsf.edu / chloeeng208@gmail.com
