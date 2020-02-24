## KHANDLE/STAR Coding Style Guide
To facilitate collaboration among KHANDLE/STAR researchers, we have created this coding style guide based on the aggregation of best practices from many sources. We have taken each coding language used by collaborators (SAS, STATA, and R) into consideration when putting together these guidelines with the goal of creating consistent and transportable code (with respect to variable and function names) across coding languages. Feel free to offer suggestions for improving this guide.

#### Variable Naming
1.	Keep your variable names short but descriptive. We will limit ours to 32 characters based on SAS limits. Ex: EDU_parental or EDU_parent is preferred over EDU2.

2.	Variable names containing multiple words (or abbreviations) should contain _ [underscore] to separate them. Ex: EDU_parent is preferred over EDUparent, EDUParent, or EDU.parent


3.	Do not use the following characters in your variable names: . [period], - [dash], [space], special characters such as $ / \ + | {} [] ! @ # % & * ( ) < >

4.	Do not begin variable names with a number. 

5.	Do not rely on capitalization to distinguish between your variables. Ex: BP and bp for different blood pressure measures.  SAS will not recognize these as different variables.

6.	Prefixes

    a.	 All non-baseline dataset variables should be prefixed with wave number, “D” for derived, and main category (e.g., MHC) if                  possible. Ex: W#_D_race_summary_v2 or W#_D_SENAS_exec_mean

    b.	The complete list of KHANDLE study prefixes is provided [here](prefix_list.md)


7.	Suffixes

    a.	Re-centered variables should include the suffix c[centering value]. Ex: age at wave 2, centered at 70 should be named W2_D_age_c70

    b.	Rescaled variables should include a suffix specifying the scale.  Ex: household income at wave 2 in dollars rescaled to thousands         of dollars should be named W2_D_INCOME_HH_thousands

    c.	Transformed variables should include a suffix specifying the transformation. Ex: taking the natural log of the ECOG scores at Wave         2 should be named W2_D_ECOG_ln. Z-scoring the ECOG scores at Wave 2 should be named W2_D_ECOG_z.

    d.	N-chotomized variables should include a suffix specifying the number of categories. Ex: D_EDU_2cat for dichotomized education and         D_EDU_3cat for trichotomized education, etc.  

    e.	Summary scores that dropped observations that were missing should include the suffix CC (for complete case). Ex: a participant’s           average blood pressure over the course of the study when we do not impute missing values should be named D_bp_mean_CC.

    f.	Summary scores that use imputed values should include the suffix IM (imputed).  Ex: a participant’s average blood pressure over           the course of the study when missing values are imputed should be named something like D_bp_mean_IM

    Note: e and f are examples of cross-wave summaries so there is no need to put a wave indicator in the prefix.

    g.	Use suffixes consistent with those already coded in KHANDLE when available: 
    |**Suffix**| **Description**|
    |:---- |:----|
    mean | Mean
    stdev | Standard deviation
    Z | Z-scored

#### Missing values for derived variables
For some variables, missingness types are specified in the raw KHANDLE data.  When creating a derived variable, specify how you decided to handle missingness (carried forward the raw KHANDLE coding for some or all missingness categories). Values intended to be blank in the derived variable should be empty, not coded as “NA”. 

#### File Naming
1.	Filenames should reflect the variables that they produce.  Ex: a script that produces derived parental education variables should be named EDU_parental with the appropriate file extension for the coding language: .R for R, .do for STATA, .sas for SAS

2.	Use only the characters A-Z, a-z, 0-9, @, #, $ in your filenames 

3.	Code translated from one language another should preserve the original filename but have the appropriate file extension (see above). 

#### Output Types
To help facilitate resource sharing, please make sure that any output from your script is in a filetype that can be read by other users, whether they have the software for your programming language or not. 
Examples: <br>
•	Graphics: (SAS default is HTML) consider .PNG or .JPEG<br>
•	Tables: consider .TXT, .XLSX, .CSV<br>
•	Text: consider .RTF, .PDF, .HTML<br>

