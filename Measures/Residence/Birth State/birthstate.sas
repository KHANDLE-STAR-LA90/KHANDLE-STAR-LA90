
/*	Frequency Check Macro */
	%macro freq_K1STATE (vars); proc freq data=khandle_1_state; var &vars. / list missing; run; %mend;

	%let mylist = 	AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD MI MN MO MS MT
		 			NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY;
	data khandle_1_state;
	set khandle_0_covs; 
 *	0. Coding Nativity - This is being done separately to import birth date for those missing age at immigration but reporting year ;
	*	Check: %freq_K1STATE(W1_COUNTRY_BORN*USBORN);
	*	Check: %freq_K1STATE(age_immigration*W1_AGE_MOVED_US_AGE; 
	if W1_COUNTRY_BORN=1 then USBORN=1; else if W1_COUNTRY_BORN ne 1 and W1_COUNTRY_BORN ne . then USBORN=0; 
 *	1. Changing to state abbreviations ;
	%macro loopit(mylist);
	%let n = %sysfunc(countw(&mylist,%STR( )));
	%do  i=1 %to &n;
	%let val = %scan(&mylist,&i); 
	if W1_US_STATE="US-&val." then W1_US_STATE_abbr="&val.";  
	%end;
	%mend;
	%let list=	AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD MI MN MO MS MT
		 		NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY;
	%loopit(&list); 
 *	2. Filling in missings ;
	length W1_US_STATE_abbr_full $ 12;
	if W1_US_STATE_abbr^=' ' and usborn=1 then W1_US_STATE_abbr_full=W1_US_STATE_abbr;
	if W1_US_STATE_abbr =' ' and usborn=1 then W1_US_STATE_abbr_full=W1_RES_1_4_STATE_1;
	if usborn=0 then W1_US_STATE_abbr_full="Foreign Born";
	*	%freq_K1STATE(W1_US_STATE W1_US_STATE_abbr*W1_US_STATE_abbr_full*W1_RES_1_4_STATE_1);
 *	3. Coding Census Region ; 
	length W1_US_REGION_BORN $ 12; 
	if usborn=0 then W1_US_REGION_BORN="Foreign Born";
	if 	W1_US_STATE_abbr_full in ('HI','AZ','CA','NV','NM','UT','CO','WY','ID','MT','WA','OR') then do; 
		W1_US_REGION_BORN='West'; W1_US_REGION_BORN_WEST=1; end; else W1_US_REGION_BORN_WEST=0;
	if 	W1_US_STATE_abbr_full in ('TX','OK','AR','LA','MS','AL','TN','KY','WV','MD','DE','DC','VA','NC','SC','GA','FL')then do; 
		W1_US_REGION_BORN='South'; W1_US_REGION_BORN_SOUTH=1; end; else W1_US_REGION_BORN_SOUTH=0;
	if 	W1_US_STATE_abbr_full in ('NY','PA','NJ','CT','RI','MA','VT','NH','ME')then do; 
		W1_US_REGION_BORN='Northeast'; W1_US_REGION_BORN_NORTHEAST=1; end; else W1_US_REGION_BORN_NORTHEAST=0;
	if 	W1_US_STATE_abbr_full in ('ND','SD','NE','KS','MN','IA','MO','WI','IL','IN','OH','MI')then do; 
		W1_US_REGION_BORN='Midwest'; W1_US_REGION_BORN_MIDWEST=1; end; else W1_US_REGION_BORN_MIDWEST=0;
	* %freq_K1STATE(W1_US_STATE_abbr_full*W1_US_REGION_BORN;
	* %freq_K1STATE(W1_US_REGION_BORN*W1_US_REGION_BORN_WEST*W1_US_REGION_BORN_SOUTH*W1_US_REGION_BORN_NORTHEAST*W1_US_REGION_BORN_MIDWEST;
	run; 
