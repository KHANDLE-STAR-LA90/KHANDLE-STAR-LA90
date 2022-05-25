#******************************
#* Example code for forcing 
#* practice effects
#******************************

#KHANDLE
#For KHANDLE, the practice effect for the first wave is large and it may help to fit the models to force the value of the practice effect to our best estimate of those values; this will allow you to estimate the mode effect and give more precision on other coefficients.Using pre-pandemic (2 waves) and balanced data, we identified that the PEs for the first wave are -0.06 for EF and -0.09 for VM.    Therefore, our current recommendation is to use the following code to force PE in your analyses with the full study sample. Once we have more waves of data, we anticipate the recommended PE specification will change, but we plan to keep this document up to date so all KHANDLE investigators are on the same page about best practices for modeling PE and mode effects. 
#Executive Function
#R example code:
khandle$off <- ifelse(khandle$first_assess == 1, -0.06, 0)
lmer(score_z ~ x1 + x2 + (1|STUDYID), offset=off, data = KHANDLE, REML = F)

#Stata example code (Created by Kevin Zhou from the Kaiser team):
constraint 1 first_assess = -0.06
meglm score_z x1 x2 || studyid:, constraints(1)

#SAS example code
#SAS example code (Created by Kevin Zhou from the Kaiser team):
DATA KHANDLE_A; SET KHANDLE;
IF VISIT=1 THEN EXEC_OFF=-0.06;
ELSE EXEC_OFF=0;
IF VISIT=1 THEN VRMEM_OFF=-0.09;
ELSE VRMEM_OFF=0;
RUN;

#Then code similar to the following can be used to create models:
#KHANDLE executive:
proc glimmix data=KHANDLE_A;
class EXP_A STUDYID;
model EXEC = x1 x2/ dist=N link=IDENTITY offset=EXEC_OFF cl ;
random intercept / sub=STUDYID;
Run;

#Verbal Memory
#R example code:
# create an indicator for first assessment: first_assess = 1 if wave = 1, and 0 otherwise
khandle$off <- ifelse(khandle$first_assess == 1, -0.09, 0)
lmer(score_z ~ x1 + x2 + (1|STUDYID), offset=off, data = KHANDLE, REML = F)

#Stata example code:
constraint 1 first_assess = -0.09
meglm score_z x1 x2 || studyid:, constraints(1)

#SAS example code (Created by Kevin Zhou from the Kaiser team):
DATA KHANDLE_A; SET KHANDLE;
IF VISIT=1 THEN EXEC_OFF=-0.06;
ELSE EXEC_OFF=0;
IF VISIT=1 THEN VRMEM_OFF=-0.09;
ELSE VRMEM_OFF=0;
RUN;

#Then code similar to the following can be used to create models:
#KHANDLE verbal memory:
proc glimmix data=KHANDLE_A;
class EXP_A STUDYID;
model VRMEM = x1 x2 / dist=N link=IDENTITY offset=VRMEM_OFF cl;
random intercept / sub=STUDYID;
run;



LA90
#LA90 seems to have practice effects that are large for both the first and second waves, so for LA90:
#Model 3, age as timescale: Yit=b0i+b1*current_ageit+b2*first_assessmentit+b3*second_assessmentit +b4*phone_assessmentit+b5*exposurei+b6*exposurei*current_ageit +eit [covariates can also be included]
#Model 4, with time since baseline as timescale, adjusted for baseline age: Yit=g0i+g1*base_agei+ g2*time_since_baselineit +g3*first_assessmentit +g4*second_assessmentit +g5*phone_assessmentit+g6*exposurei+g7*exposurei*baseline_agei +g8*exposurei*time_since_baselineit +eit [covariates can also be included]
#We used pre-pandemic, balanced data (3 waves) to estimate PEs. Estimates for the first and second assessment coefficients (b2 and b3 or g3 and g4) are provided below and in final models, you may prefer to force them to a specific value so you can more accurately estimate the phone effect. Please note that since PEs for LA90 were modified by gender, you will need to force different estimates for men and women.
#Executive Function
#R example code:
# create an indicator for first assessment (different PEs for males and females):
LA90$off <- with(LA90, ifelse(wave == "W2" & gender=="Male", 0.27,
                       ifelse((wave != “W2" & wave != “W1")  & gender=="Male", 0.43,
                       ifelse(wave == "W2" & gender=="Female", 0.06,
                       ifelse((wave != “W2"& wave != “W1") & gender=="Female", 0.19,0 )))))
lmer(score_z ~ x1 + x2 + (1|STUDYID), offset=off, data = LA90, REML = F)

#Stata example code:
#Step 1. Create assess_m: assessment indicator for males. assess_m = 0 if wave = 1, = 1 if wave = 2 and = 2 otherwise.
gen assess_m = 0 if wave == "W1" & gender == "Male"
replace assess_m = 1 if wave == "W2" & gender == "Male"
replace assess_m = 2 if (wave == "W3" | wave == "W4" | wave == "W5" | wave == "W6")  & gender == "Male"
replace assess_m = 0 if first_assess_m == .
Step 2. Create assess_f: assessment indicator for females. assess_m = 0 if wave = 1, = 1 if wave = 2 and = 2 otherwise.
gen assess_f = 0 if wave == "W1" & gender == "Female"
replace assess_f = 1 if wave == "W2" & gender == "Female"
replace assess_f = 2 if (wave == "W3" | wave == "W4" | wave == "W5" | wave == "W6")  & gender == "Female"
replace assess_f = 0 if first_assess_f == .
Step 3. Force coefficients
constraint 1 1.assess_f = 0.06
constraint 2 2.assess_f = 0.19
constraint 3 1.assess_m = 0.27
constraint 4 2.assess_m = 0.43
Step 4. Run models with constraints
meglm score x1 x2 i.first_assess_m i.first_assess_f || studyid:, constraints(1, 2, 3, 4)     

#SAS example code:
    
DATA LA90_A; SET LA90;
IF VISIT=1 THEN EXEC_OFF=0;
ELSE IF VISIT=2 AND GENDER=”M” THEN EXEC_OFF=0.27;
ELSE IF VISIT=2 AND GENDER=”F” THEN EXEC_OFF=0.06;
ELSE IF VISIT NOT IN (1,2) AND GENDER=”M” THEN EXEC_OFF=0.43;
ELSE IF VISIT NOT IN (1,2) AND GENDER=”F” THEN EXEC_OFF=0.19;
ELSE EXEC_OFF = 0;
RUN;


#Then code similar to the following can be used to create models:
#LA90 executive function:
proc glimmix data=LA90_A;
model EXEC = X1 X2 / dist=N link=IDENTITY offset=EXEC_OFF cl;
random intercept / sub=STUDYID;
run;



#Verbal Memory
#In LA90, we administered the visual presentation version alongside the traditional auditory only version to 300 randomly selected persons for each right before COVID19. Dan found no differences in the distribution of the scores between the visual stimuli and no visual stimuli group (300 randomly assigned to each condition). We also found no significant differences in practice effect between the visual stimuli and the no visual stimuli groups. Therefore, recommended the following approach to account for practice effects in verbal memory in LA90: 
#R example code:
# create an indicator for first assessment (different PEs for males and females):
LA90$off <- with(LA90, ifelse(wave == "W2", 0.21
                       ifelse((wave != “W2" & wave != “W1") , 0.48, NA))
lmer(score_z ~ x1 + x2 + (1|STUDYID), offset=off, data = LA90, REML = F)
#SAS example code 
DATA LA90_A; SET LA90;
IF VISIT=1 THEN VRMEM_OFF=0;
ELSE IF VISIT=2 THEN VRMEM_OFF=0.21;
ELSE IF VISIT NOT IN (1,2) THEN VRMEM_OFF=0.48;
ELSE VRMEM_OFF = 0;
RUN;
                     
                     
#Then code similar to the following can be used to create models:
#LA90 executive function:
proc glimmix data=LA90_A;
class EXP_A;
model EXEC = EXP_A TIME_VAR EXP_A*TIME_VAR / dist=N link=IDENTITY offset=EXEC_OFF cl;
random intercept / sub=STUDYID;
run;               
                 
                 
                
#LA90 verbal memory:
proc glimmix data=LA90_A;
model VRMEM =X1 X2 / dist=N link=IDENTITY offset=VRMEM_OFF cl;
random intercept / sub=STUDYID;
run;
                     
                     
