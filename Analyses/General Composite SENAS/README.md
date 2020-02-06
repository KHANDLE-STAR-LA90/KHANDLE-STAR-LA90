# Composite z-score SENAS models

## Overview
Code to run mixed models for clustered measures (treating each SENAS domain as a clustered measure within an individual) to test for differences across domains (using SENAS score x exposure interaction).

## What this code does
* Uses datastep to create long dataset (where each participant has 3 cognitive scores, each representing separate domain)
* Defines macro for mixed model with options to include title/output predicted values, fit statistics, and parameter information using random intercepts for each participant

## Date created:
February 5, 2020

## Decision history:

## Source variables:
SENAS Outcome Variables:
1. `W1_SENAS_VRMEM`
2. `W1_SENAS_SEM`
3. `W1_SENAS_EXEC`

 ## Coding language available:
| Derived Variable Name | SAS  | STATA  | R  |
| :---:   | :-: | :-: | :-: |
| Model | x |  | |
| Version (Date) | V1 (02/05/20) | | |

## Output variables:
N/A

## Created by

Chloe W. Eng, UCSF 

chloe.eng@ucsf.edu / chloeeng208@gmail.com
