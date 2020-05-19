# Physical Function Measures

## Overview
Code to create summary measures of grip strength and walk speed

## Date created:
January 14, 2020

## Decision history:
Created grip strength as average of 3 trials for those who completed all 3 trials and walk speed as average of 2 trials for those who completed both trials as decided by C.W. Eng, M.L. Chan, S.F. Farias

April 2020 - changed to include z-standardization of final measures

## Source variables: 
1. `W1_PHYS_GRIPDOM`
2. `W1_PHYS_GRIPR1`
3. `W1_PHYS_GRIPR2`
4. `W1_PHYS_GRIPR3`
5. `W1_PHYS_WLKTIME1`
6. `W1_PHYS_WLKTIME2` 

 ## Coding language available:
| Derived Variable Name | SAS  | STATA  | R  |
| :---:   | :-: | :-: | :-: |
| grip_dominant | x |  | |
| grip_nondominant | x |  | |
| WLKTIME_AVG | x |  | | 
| Version (Date) | V1 (01/14/20) | | |

## Output variables: 
1. `grip_dominant` - average of 3 grip strength trials for the participant's self-reported dominant hand
2. `grip_nondominant` - average of 3 grip strength trials for the participant's self-reported non dominant hand
3. `WLKTIME_AVG` - average of 2 walk speed trials for those who completed both trials

## Created by

Chloe W. Eng, UCSF 

chloe.eng@ucsf.edu / chloeeng208@gmail.com
