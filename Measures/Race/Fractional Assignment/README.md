# Fractional Assignment of Racial Categories

## Date Created
April 18, 2019

## Overview
This code is for fractional assignment of race, where the individual’s response is assigned to multiple categories based on deterministic rules. Analyses using this code must account for clustering and incorporate generated weights, as multirace individuals have multiple observations (rows) for each of their assigned races, and should include the multirace indicator.

Description of fractional assignment: https://texas-air.org/assets/pdf/TAIR%20DAC%20Race%20Mapping-Bridging.pdf

## What this code does
*	Duplicates multirace observations so that each line represents each of the different self-identified race/ethnicities
* 	Assigns weights to each observation
	*	Equals 1 for single race individuals as they're contribution only to 1 race
	*	Equals 1/(# of racial/ethnic groups) for multirace people, so they contribute a fraction of a person to each racial group

## Source Variables
1. `W1_race_dummy_x` (x=asian, black, latino, white)

## Coding Language Available

| Derived Variable Name | SAS  | STATA  | R  |
| :---: | :-: | :-: | :-: |
| race_asian | X |  |  |
| race_black | X |  |  |
| race_latino | X |  |  |
| race_white | X |  |  |
| weight_race | X |  |  |
| Version (Date) | V1 (04/18/2019) | | |

## Output Variables
1. `race_x` - dummy variable for race represented here
2. `weight_race` - assigned weight; equals 1 for single race individuals, because they only contribute to 1 racial category. For multiracial people, equal to 1 divided by the number of race categories (so for a biracial individual, each of their rows has a weight of 0.5).


## Created by

Chloe W. Eng, UCSF PhD Student

chloe.eng@ucsf.edu / chloeeng208@gmail.com
