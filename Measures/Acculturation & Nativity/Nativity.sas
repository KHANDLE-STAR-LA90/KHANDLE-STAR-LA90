/*	Categorizing nativity -------------------------------------------------------------------------------------------- */
 *	Participant nativity ;
	if W1_COUNTRY_BORN=1 then foreignborn=0; else if W1_COUNTRY_BORN ne 1 and W1_COUNTRY_BORN ne . then foreignborn=1;
 *	Parental and Grandparental nativity ;
	array parent {6} W1_FATHER_BORN W1_MOTHER_BORN W1_FATHERS_FATHER_BORN W1_FATHERS_MOTHER_BORN W1_MOTHERS_FATHER_BORN W1_MOTHERS_MOTHER_BORN;
	array parentnew {6} foreignborn_father foreignborn_mother foreignborn_fathers_father foreignborn_fathers_mother foreignborn_mothers_father foreignborn_mothers_mother;
	do i=1 to 6;
		if parent{i}=1 then parentnew{i}=0;
		else if parent{i}>1 and parent{i} ne 88 and parent{i} ne 99 then parentnew{i}=1;
		else if parent{i}=88 or parent{i}=99 then parentnew{i}=99;
	end;
	length secondgen $ 26;
	immigration_gen=.;
	if foreignborn=0 then do;
		if nativity_father=0 and nativity_mother=0 then do; secondgen='Both parents born in US'; immigration_gen=3; end;
		 *	October 31, 2019: setting the 20 US born people missing one parent's place of birth to also be US because other parent was US born ;
			if 88<=nativity_father<=99 and nativity_mother=0 then do; secondgen='mom US born (dad unknown)'; immigration_gen=3; end;
			if nativity_father=0 and 88<=nativity_mother<=99 then do; secondgen='dad US born (mom unknown)'; immigration_gen=3; end;
		if nativity_father=0 and nativity_mother=1 then do; secondgen='Yes, mom only foreign born'; immigration_gen=2; end;
		if nativity_father=1 and nativity_mother=0 then do; secondgen='Yes, dad only foreign born'; immigration_gen=2; end;
		if nativity_father=1 and nativity_mother=1 then do; secondgen='Yes, both parents foreign born'; immigration_gen=2; end;
		 *	October 31, 2019: setting the 1 person missing one parent's place of birth to second gen, since other parent foreign born ;
			if 88<=nativity_father<=99 and nativity_mother=1 then do; secondgen='Yes, mom foreign born (dad unknown)'; immigration_gen=2; end;
			if nativity_father=1 and 88<=nativity_mother<=99 then do; secondgen='Yes, dad foreign born (mom unknown)'; immigration_gen=2; end;
	end;
	if foreignborn=1 then do; secondgen="Participant Foreign Born"; immigration_gen=1; end;
	/* CHECKS: 
	proc freq data=khandle; table w1_d_race_summary*usborn*secondgen*w1_father_born*nativity_father*w1_mother_born*nativity_mother / list missing norow nopercent; where elig=1; run; */
	label 	foreignborn="Whether participant born in US (0=US, 1=Foreign Born, missing if refused or unknown)"
			foreignborn_father="Whether father born in US  (0=US, 1=Foreign Born, 99 if refused or unknown)"
			foreignborn_mother="Whether mother born in US  (0=US, 1=Foreign Born, 99 if refused or unknown)"
			foreignborn_fathers_father="Whether father's father born in US (0=US, 1=Foreign Born, 99 if refused or unknown)"
			foreignborn_fathers_mother="Whether father's mother born in US (0=US, 1=Foreign Born, 99 if refused or unknown)"
			foreignborn_mothers_father="Whether mother's father born in US (0=US, 1=Foreign Born, 99 if refused or unknown)"
			foreignborn_mothers_mother="Whether mother's mother born in US (0=US, 1=Foreign Born, 99 if refused or unknown)"
			secondgen="Participant was born in US but parents were not";
			immigration_gen="1=participant foreign born; 2=participant second generation (at least 1 parent foreign born); 3=both parents born in US";
