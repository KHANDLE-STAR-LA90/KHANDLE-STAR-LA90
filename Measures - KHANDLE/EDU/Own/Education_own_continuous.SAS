/*	CORRECTING OWN EDUCATION ---------------------------------------------------------------------------------- */
/*	Check: proc freq data=khandle; table W1_EDU_EDUCATION*W1_EDU_GED /missing; where elig=1 and dummy^=1; run;	*/
/*	Check: proc freq data=khandle; table W1_D_EDUCATION*educ_new / missing; where elig=1 and dummy ne 1; run;	*/
/*	Check: proc freq data=khandle; table educ_new*W1_D_RACE_SUMMARY / missing; where elig=1; run;				*/
/*	Check: proc freq data=khandle; table educ_new*educ_yrs / missing; where elig=1; run;						*/ 
/*	This code translate's Fabian's code for continuous education from R to SAS									*/
/* ------------------------------------------------------------------------------------------------------------ */
	length educ_new $ 25;
	if 0<=W1_EDU_EDUCATION_TEXT<=12 then educ_yrs=W1_EDU_EDUCATION_TEXT; 
	else if W1_EDU_EDUCATION=1 then educ_yrs=13; 
	else if W1_EDU_EDUCATION=2 then educ_yrs=14; 
	else if W1_EDU_EDUCATION=3 then educ_yrs=16; 
	else if W1_EDU_EDUCATION=4 then educ_yrs=18; 
	else if W1_EDU_EDUCATION=5 then educ_yrs=20;  
 *	Catching missings from self-report by filling in with new education variable ;
	if (w1_edu_education=99 or w1_edu_education=88)  and W1_EDU_GED=2 then educ_yrs=12; 
	if W1_EDU_EDUCATION=0 and W1_EDU_TRNCERT=2 and W1_EDU_LONGCERT=4 then educ_yrs=educ_yrs+1;
