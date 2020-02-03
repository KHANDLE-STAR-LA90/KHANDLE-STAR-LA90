
			** recoding maternal education to be continuous **
			
			/* 0 = Years (0-12) || 1 = Some college but no degree || 2 = Associate's degree || 3 = Bachelor's degree || 4 = Master's degree & Doctoral or higher level degree (JD, MD, PhD, ScD, DO, DVM) ||  5 == (66 = NA/due to no mother figure || 88 = Refused || 99 = Don't Know / Not Ascertained)
			
			** Note, the W1_MATERNAL/PATERNAL_EDUCATION_D is only for higher education categories
			
			*/
			
			gen W1_MATERNAL_EDUCATION_D= 0 if W1_MATERNAL_EDUCATION == 0  //I am using W1_MATERNAL_EDUCATION_D as my derived education variable
			replace W1_MATERNAL_EDUCATION_D=1 if W1_MATERNAL_EDUCATION == 1  
			replace W1_MATERNAL_EDUCATION_D=2 if W1_MATERNAL_EDUCATION == 2  
			replace W1_MATERNAL_EDUCATION_D=3 if W1_MATERNAL_EDUCATION == 3	 
			replace W1_MATERNAL_EDUCATION_D=4 if W1_MATERNAL_EDUCATION == 4 | W1_MATERNAL_EDUCATION == 5  // Note that Masters & Doctoral were combined 
			replace W1_MATERNAL_EDUCATION_D=5 if W1_MATERNAL_EDUCATION == 66 |W1_MATERNAL_EDUCATION == 88 | W1_MATERNAL_EDUCATION == 99
			
			/* strategy to keep as continuous */
		
			gen maternal_primary_education=W1_MATERNAL_EDUCATION_TEXT // continuous education years 0-12
			gen maternal_categorical_education=W1_MATERNAL_EDUCATION_D // ordinal education indicating level beyond HS (0 for HS--see above)
			gen maternal_education_level_NA=0 // indicator variable for whether eduction is missing // assign values/fix these 
			
			
			replace maternal_education_level_NA=1 if W1_MATERNAL_EDUCATION_D==5 //assign NA indicator 1 if education level missing
			replace maternal_categorical_education=0 if maternal_categorical_education==5 // replace missing categorical education with zeros
			replace maternal_primary_education=12 if maternal_categorical_education>=1 // assign 12 years of primary if has advanced degree
			replace maternal_education_level_NA=1 if maternal_primary_education==. // assign NA indicator 1  if primary education not listed (and no advanced degree)
			replace maternal_primary_education=0 if maternal_primary_education==. // assign primary education 0 if missing 

			** recoding paternal education to be continuous **
			
			gen W1_PATERNAL_EDUCATION_D= 0 if W1_PATERNAL_EDUCATION== 0   //I am using W1_PATERNAL_EDUCATION_D as my derived education variable
			replace W1_PATERNAL_EDUCATION_D=1 if W1_PATERNAL_EDUCATION == 1 
			replace W1_PATERNAL_EDUCATION_D=2 if W1_PATERNAL_EDUCATION == 2  
			replace W1_PATERNAL_EDUCATION_D=3 if W1_PATERNAL_EDUCATION == 3	 
			replace W1_PATERNAL_EDUCATION_D=4 if W1_PATERNAL_EDUCATION == 4 | W1_PATERNAL_EDUCATION == 5  
			replace W1_PATERNAL_EDUCATION_D=5 if W1_PATERNAL_EDUCATION == 66| W1_PATERNAL_EDUCATION == 88 | W1_PATERNAL_EDUCATION == 99  
			
			/* strategy to keep as continuous */
			
			gen paternal_primary_education=W1_PATERNAL_EDUCATION_TEXT
			gen paternal_categorical_education=W1_PATERNAL_EDUCATION_D
			gen paternal_education_level_NA=0
			replace paternal_education_level_NA=1 if W1_PATERNAL_EDUCATION_D==5
			replace paternal_categorical_education=0 if paternal_categorical_education==5
			replace paternal_primary_education=12 if paternal_categorical_education>=1 
			replace paternal_education_level_NA=1 if paternal_primary_education==.
			replace paternal_primary_education=0 if paternal_primary_education==.
