	data vrmem; set khandle; cogz=w1_D_senas_vrmem_z; 	cogtypen=1; cogtype="VRMEM"; 
	data sem;	set khandle; cogz=w1_D_senas_sem_z; 	cogtypen=2; cogtype="SEM";
	data exec;	set khandle; cogz=w1_D_senas_exec_z;	cogtypen=3; cogtype="EXEC";
	data long; set vrmem sem exec; proc sort; by studyid; run; 
	
/*------------------------------------------------------------------------------*/ 
/*																				*/
/*	Regression Analyses															*/
/*																				*/
/*------------------------------------------------------------------------------*/ 

	%macro mixed (covs=,class=,where=,title=,betas=,FS=,CovParms=); 
	proc mixed data=long noclprint covtest method=ml;
	class studyid cogtype &class.; 
	model cogz = cogtype &covs. / solution s DDFM=BW cl; 
	random intercept / subject=studyid type=un;
	where elig=1 &where.; * WHERE ELIG=1 IS ELIGIBLE FOR ANALYTIC SAMPLE ;
	title &title.;
	&betas.;
	&FS.;
	&CovParms.;
	run;
	quit;
	%mend;
	%macro betas(b); 		ods output SolutionF=params_&b.; %mend;
	%macro FS(fs); 			ods output Fitstatistics=FS_&fs. SolutionF=SF_&fs.; %mend;
	%macro CovParms(cp); 	ods output CovParms=CovModel_&cp.; %mend;

	%let covs0=age_c70 W1_D_GENDER W1_D_RACE_SUMMARY W1_D_RACE_MIXED;

/*	Intercept Model	*/
	%mixed(covs=,class=,where=,title=,betas=,FS=,CovParms=);  
  
/*	Example Model	*/
	%mixed(covs=|W1_D_RACE_SUMMARY &covs0,class=W1_D_RACE_SUMMARY,where=,title=,betas=%betas(example),FS=%FS(example),CovParms=%CovParms(example));  
