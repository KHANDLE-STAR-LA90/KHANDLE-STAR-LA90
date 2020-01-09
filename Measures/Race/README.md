# Derived Race Variables

## Date Created
October 11, 2019

## Decision History
Standard language for manuscripts:

		1. Asian
		2. Black (not African American)
		3. Latino (not Hispanic)
		4. White (not Caucasian)
		
* Based primarily on `racen` from tracking (self-reported Kaiser race) and modified based on race/ethnicity responses (`ethnicity1`-`ethnicity22`) in W1 baseline survey

## Source Variables
1. `racen`
2. `ethnicity_c1`-`ethnicity_c22`
3. `ethnicity_c22_text`

## Coding Language Available
Not applicable; will be exported and distributed with all datasets

## Output Variables
1. `W1_d_race_summary` - categorical summary variable with primary enrollment race categories (Latinx->Black->Asian->White). 
	*Each participant is assigned to 1 race including multiracial individuals*.
2. `W1_d_race_dummy_x` - 0/1 dummy variables (4 total: Asian, Black, Latinx, White) for each racial/ethnic category; 
	*mixed-race individuals will have values for multiple (e.g. someone who is black and white will have values of 1 for both `W1_race_dummy_black` and `W1_race_dummy_white`)*
3. `W1_d_race_mixed` - 0/1 indicator variable for whether mixed-race individual, for use in conjunction with other output variables. 
	*Note: Calculated using overall dummy race categories and not sum of ethnicities because we don't want to count someone who's Mexican and Nicaraguan as being multirace, but we would want to count someone who's Mexican and Chinese.*

## Created by

Chloe W. Eng, UCSF PhD Student

chloe.eng@ucsf.edu / chloeeng208@gmail.com
