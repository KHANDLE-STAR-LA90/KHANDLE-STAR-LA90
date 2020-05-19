data khandle_0;
set  khandle_ORIGINAL;
*	GRIP STRENGTH ------------------------------------------------------------------------------- ;
	* 1 = right dominant hand, 2 = left dominant hand ;
	if W1_PHYS_GRIPDOM=1 then do;
		grip_dominant=sum(W1_PHYS_GRIPR1,W1_PHYS_GRIPR2,W1_PHYS_GRIPR3)/3; if cmiss(W1_PHYS_GRIPR1,W1_PHYS_GRIPR2,W1_PHYS_GRIPR3) then grip_dominant=.;
		grip_nondominant=sum(W1_PHYS_GRIPL1,W1_PHYS_GRIPL2,W1_PHYS_GRIPL3)/3; if cmiss(W1_PHYS_GRIPL1,W1_PHYS_GRIPL2,W1_PHYS_GRIPL3) then grip_nondominant=.;
	end;
	if W1_PHYS_GRIPDOM=2 then do;
		grip_dominant=sum(W1_PHYS_GRIPL1,W1_PHYS_GRIPL2,W1_PHYS_GRIPL3)/3; if cmiss(W1_PHYS_GRIPL1,W1_PHYS_GRIPL2,W1_PHYS_GRIPL3) then grip_dominant=.;
		grip_nondominant=sum(W1_PHYS_GRIPR1,W1_PHYS_GRIPR2,W1_PHYS_GRIPR3)/3; if cmiss(W1_PHYS_GRIPR1,W1_PHYS_GRIPR2,W1_PHYS_GRIPR3) then grip_nondominant=.;
	end;
 *	WALK SPEED ---------------------------------------------------------------------------------- ;
	/* CHECK: proc freq; table WLKTIME_AVG*W1_PHYS_WLKTIME1*W1_PHYS_WLKTIME2 / list missing; run; */
	if W1_PHYS_WLKTIME1>0 and W1_PHYS_WLKTIME2>0 then do;
		WLKTIME_AVG=sum(W1_PHYS_WLKTIME1,W1_PHYS_WLKTIME2)/2;
	end;
run;

	%macro meansz (var);
	proc means data=khandle_0 noprint; 
	var &var.; 
	output out=&var. mean=&var._mean std=&var._std / NOINHERIT; 
	run;
	%mend;
	%meansz (grip_dominant);
	%meansz (wlktime_avg); 
	
	data khandle;
	if _N_=1 then set grip_dominant 	(drop=_FREQ_ _TYPE_);
	if _N_=1 then set wlktime_avg		(drop=_FREQ_ _TYPE_); 
	set khandle_0; 
	%macro zscore (var);
	&var._z=(&var.-&var._mean)/&var._std;
	%mend;
	%zscore(grip_dominant);
	%zscore(wlktime_avg); 
	run;
