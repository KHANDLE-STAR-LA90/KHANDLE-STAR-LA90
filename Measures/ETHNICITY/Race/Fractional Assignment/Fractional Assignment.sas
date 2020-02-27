/*	RACE: FRACTIONAL ASSIGNMENT ------------------------------------------------------------------------------- */
/*	This code creates the dummy observations and weights for people who report being >1 race					*/
/* ------------------------------------------------------------------------------------------------------------ */ 

 *	Setting weight for single-race ;
	data nonmixed; 
	set khandle;
	where sum(W1_D_RACE_DUMMY_WHITE, W1_D_RACE_DUMMY_BLACK, W1_D_RACE_DUMMY_LATINX, W1_D_RACE_DUMMY_ASIAN)=1;
	weight_race=1;
	run;
	/* TEST: proc freq data=nonmixed; table mixed_race*weight_race / list missing; run; */ 

 *	Setting weight for mixed race (two category) --------------------------------------------- ;
	data mixed2;
	set khandle(in=a) khandle(in=b);
	weight_race=0.5;
	where sum(W1_D_RACE_DUMMY_WHITE, W1_D_RACE_DUMMY_BLACK, W1_D_RACE_DUMMY_LATINX, W1_D_RACE_DUMMY_ASIAN)=2;
 *	Creating temporary dummies (otherwise values get written over);
	race_white2=W1_D_RACE_DUMMY_WHITE;
	race_black2=W1_D_RACE_DUMMY_BLACK;
	race_asian2=W1_D_RACE_DUMMY_ASIAN;
	race_latino2=W1_D_RACE_DUMMY_LATINX;
 *	Individual recodes ----------------------------------------------------------------------- ;
 *	Latino and Black/White/Asian ;
	if race_latino2=1 then do;
		if a then do; 	W1_D_RACE_DUMMY_LATINX=1; W1_D_RACE_DUMMY_BLACK=0; W1_D_RACE_DUMMY_ASIAN=0; W1_D_RACE_DUMMY_WHITE=0; end;
		if b then do; 	W1_D_RACE_DUMMY_LATINX=0; 
								if race_black2=1 and race_asian2 ne 1 then W1_D_RACE_DUMMY_BLACK=1;  
								if race_asian2=1 and race_black2 ne 1 then W1_D_RACE_DUMMY_ASIAN=1; 
								if race_white2=1 then W1_D_RACE_DUMMY_WHITE=1;  end;
		end;
 *	Black and White/Asian ;
	if race_latino2=0 and race_black2=1 then do;
		if a then do; W1_D_RACE_DUMMY_BLACK=1; W1_D_RACE_DUMMY_ASIAN=0; W1_D_RACE_DUMMY_WHITE=0; end;
		if b then do; W1_D_RACE_DUMMY_BLACK=0; if race_asian2=1 then W1_D_RACE_DUMMY_ASIAN=1; if race_white2=1 then W1_D_RACE_DUMMY_WHITE=1; end;
	end;
 *	Asian and White ;
	if race_latino2=0 and race_black2=0 and race_asian2=1 then do;
		if a then do; if race_asian2=1 then W1_D_RACE_DUMMY_ASIAN=1; W1_D_RACE_DUMMY_WHITE=0; end;
		if b then do; W1_D_RACE_DUMMY_ASIAN=0; end;
	end;
	drop race_latino2 race_white2 race_black2 race_asian2;
	proc sort; by studyid;
	run;
	
	/*	Checks: 
		proc freq data=mixed2; table studyid*mixed_race*race_enrollment*W1_D_RACE_DUMMY_WHITE*W1_D_RACE_DUMMY_BLACK*W1_D_RACE_DUMMY_LATINX*W1_D_RACE_DUMMY_ASIAN*race_nativeam / missing list; run;
		proc print data=mixed2; var studyid last_name race: ethnicity:; where sum(W1_D_RACE_DUMMY_WHITE, W1_D_RACE_DUMMY_BLACK, W1_D_RACE_DUMMY_LATINX, W1_D_RACE_DUMMY_ASIAN)=0; run;
		proc print data=mixed2; var studyid last_name race: ethnicity:; run;
		proc print data=mixed2; var studyid last_name race: ethnicity:; where studyid=201; run;	*/

 *	Setting weight for mixed race (three category) ------------------------------------------- ;
	data mixed3;
	set khandle(in=a) khandle(in=b) khandle(in=c);
	weight_race=(1/3);
	where sum(W1_D_RACE_DUMMY_WHITE, W1_D_RACE_DUMMY_BLACK, W1_D_RACE_DUMMY_LATINX, W1_D_RACE_DUMMY_ASIAN)=3;
 *	Creating temporary dummies (otherwise values get written over);
	race_white2=W1_D_RACE_DUMMY_WHITE;
	race_black2=W1_D_RACE_DUMMY_BLACK;
	race_asian2=W1_D_RACE_DUMMY_ASIAN;
	race_latino2=W1_D_RACE_DUMMY_LATINX; 
 *	Individual recodes ----------------------------------------------------------------------- ;
 *	If Latino, White, and Black/Asian (since no one is Latino/Black/Asian, B represents black/Asian difference ;
	if race_latino2=1 then do;
		if a then do; 	W1_D_RACE_DUMMY_LATINX=1; W1_D_RACE_DUMMY_BLACK=0; W1_D_RACE_DUMMY_ASIAN=0; W1_D_RACE_DUMMY_WHITE=0; end;
		if b then do; 	W1_D_RACE_DUMMY_LATINX=0; 
						if race_black2=1 and race_asian2 ne 1 then W1_D_RACE_DUMMY_BLACK=1; 
						if race_asian2=1 and race_black2 ne 1 then W1_D_RACE_DUMMY_ASIAN=1; 
						W1_D_RACE_DUMMY_WHITE=0; end;
		if c then do; 	W1_D_RACE_DUMMY_LATINX=0; W1_D_RACE_DUMMY_BLACK=0; W1_D_RACE_DUMMY_ASIAN=0; if race_white2=1 then W1_D_RACE_DUMMY_WHITE=1; end;
	end;
 *	If Black, Asian, and White (none should be Latino);
	if race_latino2=0 and race_black2=1 then do;
		*test="BLWHAS";
		if a then do; W1_D_RACE_DUMMY_BLACK=1; W1_D_RACE_DUMMY_ASIAN=0; W1_D_RACE_DUMMY_WHITE=0; end;
		if b then do; W1_D_RACE_DUMMY_BLACK=0; if race_asian2=1 then W1_D_RACE_DUMMY_ASIAN=1; W1_D_RACE_DUMMY_WHITE=0; end;
		if c then do; W1_D_RACE_DUMMY_BLACK=0; W1_D_RACE_DUMMY_ASIAN=0; if race_white2=1 then W1_D_RACE_DUMMY_WHITE=1; end;
	end; 
	drop race_latino2 race_white2 race_black2 race_asian2;
	proc sort; by studyid;
	run;
	
	/* 	Checks: 
		proc freq data=mixed3; table W1_D_RACE_SUMMARY*W1_D_RACE_DUMMY_WHITE*W1_D_RACE_DUMMY_BLACK*W1_D_RACE_DUMMY_LATINX*W1_D_RACE_DUMMY_ASIAN*weight_race / missing list; run;
		proc freq data=khandlerace; table W1_D_RACE_SUMMARY*race_pooled / missing list; run;
		proc print data=mixed3; var studyid last_name race: ethnicity:; run;	
		proc print data=mixed3 (obs=3); var studyid last_name race: ethnicity:; run;	*/

	data khandlerace;
	set nonmixed mixed2 mixed3;  
	length race_pooled $ 10;
	if W1_D_RACE_DUMMY_WHITE=1 and W1_D_RACE_DUMMY_ASIAN=0  and W1_D_RACE_DUMMY_BLACK=0  and W1_D_RACE_DUMMY_LATINX=0 then race_pooled='White';
	if W1_D_RACE_DUMMY_ASIAN=1 and W1_D_RACE_DUMMY_BLACK=0  and W1_D_RACE_DUMMY_LATINX=0 then race_pooled='Asian';
	if W1_D_RACE_DUMMY_BLACK=1 and W1_D_RACE_DUMMY_LATINX=0 then race_pooled='Black';
	if W1_D_RACE_DUMMY_LATINX=1 then race_pooled='LatinX';
	run;  
