 *	IADLS/ADLS ---------------------------------------------------------------------------------- ;
 	* Coding ADLS ; 
	if 1<=W1_DAILY_LIVING_ADL1<=4 then ADL1=W1_DAILY_LIVING_ADL1;
	if 1<=W1_DAILY_LIVING_ADL2<=4 then ADL2=W1_DAILY_LIVING_ADL2;
	if 1<=W1_DAILY_LIVING_ADL3<=4 then ADL3=W1_DAILY_LIVING_ADL3;
	if 1<=W1_DAILY_LIVING_ADL4<=4 then ADL4=W1_DAILY_LIVING_ADL4;
	if 1<=W1_DAILY_LIVING_ADL5<=4 then ADL5=W1_DAILY_LIVING_ADL5;
	if 1<=W1_DAILY_LIVING_ADL6<=4 then ADL6=W1_DAILY_LIVING_ADL6;
	if 1<=W1_DAILY_LIVING_ADL7<=4 then ADL7=W1_DAILY_LIVING_ADL7;
	if 1<=W1_DAILY_LIVING_ADL8<=4 then ADL8=W1_DAILY_LIVING_ADL8;
	if 1<=W1_DAILY_LIVING_ADL9<=4 then ADL9=W1_DAILY_LIVING_ADL9; 
	ADL=sum(ADL1, ADL2, ADL3, ADL4, ADL5, ADL6, ADL7, ADL8, ADL9)/9;
		if cmiss(ADL1, ADL2, ADL3, ADL4, ADL5, ADL6, ADL7, ADL8, ADL9) then ADL=.;
	label ADL='Average ADL measure score, treating [5. Do not do] as missing';
 	* Coding IADLS ;
	if 1<=W1_DAILY_LIVING_IADL1<=4 then IADL1=W1_DAILY_LIVING_IADL1;
	if 1<=W1_DAILY_LIVING_IADL2<=4 then IADL2=W1_DAILY_LIVING_IADL2;
	if 1<=W1_DAILY_LIVING_IADL3<=4 then IADL3=W1_DAILY_LIVING_IADL3;
	IADL=sum(IADL1, IADL2, IADL3)/3;
		if cmiss(IADL1, IADL2, IADL3) then IADL=.;
	label IADL='Average IADL measure score, treating [5. Do not do] as missing';
	* Combined ADL/IADL measure ; 
	ADL_IADL=sum(ADL1,ADL2,ADL3,ADL4,ADL5,ADL6,ADL7,ADL8,ADL9,IADL1,IADL2,IADL3)/12;
		if cmiss(ADL1,ADL2,ADL3,ADL4,ADL5,ADL6,ADL7,ADL8,ADL9,IADL1,IADL2,IADL3)then ADL_IADL=.;
	label ADL_IADL='Average ADL/IADL combined measure score, treating [5. Do not do] as missing'; 
