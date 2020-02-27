######################################################################3
#converting W1_EDU_EDUCATION to "years of EDUCATION" 
######################################################################
Author: Fabian Corlier
Questions can be sent to: fcorlier@ucla.edu

#W1_EDU_EDUCATION_TEXT contains years of educ. for those who have <= 12 years of education 
# we create a variable TRUECERT to indicate if respondent has a vocational degree not accounted for, in the years of education:
  # W1_EDU_TRNCERT indicates if participant has additional training 
  #(self-taught: W1_EDU_TRNCERT=1, or formally trained: W1_EDU_TRNCERT=2)
  # LONGCERT indicates how long it took to train (1-4, with 4 meaning duration >= 6months; that's the only one we consider long enougth)
  # if W1_EDU_TRNCERT=2 and W1_EDU_LONGCERT=4, then TRUECERT=1 (otherwise 0)
  # when TRUECERT=1, then W1_EDU_EDUCATION_TEXT gets +1
#yrEDUCATION is the continuous education in years created by combining W1_EDU_EDUCATION_TEXT and W1_EDU_EDUCATION converted as follows:
    #W1_EDU_EDUCATION   | equivalent years of education
    #_____________________________________________________________
    #               0   | W1_EDU_EDUCATION_TEXT (+1 if TRUECERT=1)
    #               1   | 13 
    #               2   | 14
    #               3   | 16
    #               4   | 18
    #               5   | 20

#CUSTOM NAMING:
#Make sure to create the data frame with the raw imported kHANDLE data
# DF <- ORGINIAL_DATA_IMPORTED_TO_R

#creating the column (here I just duplicate )
DF$yrEDUCATION <- DF$W1_EDU_EDUCATION

#creating TRUECERT 
DF$TRUECERT <- factor(
  ifelse(
          DF[ ,
               "W1_EDU_TRNCERT"]==2 & DF[,"W1_EDU_LONGCERT"]==4,
         1,0))


# number of years of education = EDUCATION_TEXT 
# when respondent did not attend college (EDUCATION=0)
DF[which(
DF[,"W1_EDU_EDUCATION"]==0),"yrEDUCATION"] <-
    as.numeric(
                DF[
                    which(DF[ ,"W1_EDU_EDUCATION"]==0),
                    "W1_EDU_EDUCATION_TEXT"]
               )

#for those without college, if TRUECERT=1 they get an extra year of education
DF[which(DF$W1_EDU_EDUCATION==0 & DF$TRUECERT==1),"yrEDUCATION"] <-
  as.numeric(
    DF[
      which(DF$W1_EDU_EDUCATION==0 & DF$TRUECERT==1),
      "yrEDUCATION"]
      )+1

DF[
  which(DF[,"W1_EDU_EDUCATION"]==1),
  "yrEDUCATION"] <- 13

DF[
  which(DF[,"W1_EDU_EDUCATION"]==2),
  "yrEDUCATION"] <- 14

DF[
  which(DF[,"W1_EDU_EDUCATION"]==3),
  "yrEDUCATION"] <- 16

DF[
  which(DF[,"W1_EDU_EDUCATION"]==4),
  "yrEDUCATION"] <- 18

DF[
  which(DF[,"W1_EDU_EDUCATION"]==5),
  "yrEDUCATION"] <- 20

DF$yrEDUCATION <- as.numeric(DF$yrEDUCATION)

# checking the output
table(DF$W1_EDU_EDUCATION,DF$yrEDUCATION,useNA = "ifany")
