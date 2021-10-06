#*******************************
#* This script converts KHANDLE
#* from wide to long format
#*******************************

library(haven)
library(tidyverse)

# read dataset
dat <- read_sas("/Users/ccalmasini/Dropbox/KHANDLE/Raw KHANDLE Data/Most Recent Raw Data Sets/all waves and MHC/khandle_all_waves_20210818.sas7bdat")

# selecting variables
dat2 <- dat %>%
  select(STUDYID,
         W1_SENAS_vrmem, W2_SENAS_vrmem, W3_SENAS_vrmem,
         W1_SENAS_exec, W2_SENAS_exec, W3_SENAS_exec,
         W1_INTERVIEW_AGE, W2_INTERVIEW_AGE, W3_INTERVIEW_AGE,
         W2_SENAS_telephone, W3_SENAS_telephone,
         W1_EDU_EDUCATION, W1_EDU_EDUCATION_TEXT, W1_EDU_LONGCERT,
         W1_D_GENDER, W1_D_RACE_SUMMARY)

# long format cognitive scores (executive function and verbal memory)
scores_long <- dat2 %>%
  select(STUDYID, W1_SENAS_vrmem, W2_SENAS_vrmem, W3_SENAS_vrmem,
         W1_SENAS_exec, W2_SENAS_exec, W3_SENAS_exec) %>%
  pivot_longer(cols = W1_SENAS_vrmem:W3_SENAS_exec, 
               names_to = "wave", 
               values_to = "score") %>%
  mutate(wave = str_replace(wave, "SENAS_", "")) %>%
  separate(wave, into = c("wave", "test"), sep = "_")

# long format age 
age_long <- dat2 %>%
  select(STUDYID, W1_INTERVIEW_AGE, W2_INTERVIEW_AGE, W3_INTERVIEW_AGE) %>%
  pivot_longer(cols = W1_INTERVIEW_AGE:W3_INTERVIEW_AGE, 
               names_to = "wave", 
               values_to = "age") %>%
  mutate(wave = str_replace(wave, "_INTERVIEW_AGE", ""))

# baseline age
base_age <- dat2 %>% select(STUDYID, "base_age" = W1_INTERVIEW_AGE)

# long format phone indicator
phone_long <- dat2 %>%
  select(STUDYID, W2_SENAS_telephone, W3_SENAS_telephone) %>%
  pivot_longer(cols = W2_SENAS_telephone:W3_SENAS_telephone, 
               names_to = "wave", 
               values_to = "phone_ind") %>%
  mutate(wave = str_replace(wave, "_SENAS_telephone", ""),
         phone_ind2 = case_when(phone_ind == "" ~ NA_real_,
                                phone_ind == "N" ~ 0, 
                                phone_ind == "Y" ~ 1))

# recode covariates
covars <- dat2 %>%
  select(STUDYID, starts_with("W1_EDU"), W1_D_GENDER, W1_D_RACE_SUMMARY) %>%
  mutate(
    educ_cat = case_when(
      W1_EDU_EDUCATION == 1 ~ "Some college but no degree",
      W1_EDU_EDUCATION == 2 ~ "Associate's degree",
      W1_EDU_EDUCATION == 3 ~ "Bachelor's degree",
      W1_EDU_EDUCATION == 4 ~ "Master's degree",
      W1_EDU_EDUCATION == 5 ~ "Doctoral or higher level",
      W1_EDU_EDUCATION == 88 ~ NA_character_,
      W1_EDU_EDUCATION == 99 ~ NA_character_,
      W1_EDU_EDUCATION == 0 ~ "High school or lower"
    ),
    W1_D_GENDER = ifelse(W1_D_GENDER == 1, "Male", "Female")) %>%
  filter(W1_D_RACE_SUMMARY != "Native American") %>%
  select(STUDYID, 
         'edu' = educ_cat,
         'gender' = W1_D_GENDER, 
         'race' = W1_D_RACE_SUMMARY)

# calculate mean age at baseline to center
mean_base_age <- round(mean(base_age$base_age, na.rm = T),0)

# join all long datasets on ID and wave
# center age and baseline age
# make years since baseline variable
# make first assessment indicator = 1 if wave 1
dat2_long <- scores_long %>%
  left_join(age_long) %>%
  left_join(base_age) %>%
  left_join(phone_long) %>%
  left_join(covars) %>%
  select(-phone_ind) %>%
  mutate(age_c = age - mean_base_age,
         base_age_c = base_age - mean_base_age,
         years_since_base = age_c - base_age_c,
         first_assess = ifelse(wave == "W1", 1, 0),
         phone_ind2 = ifelse(wave == "W1", 0, phone_ind2))

#---- verbal memory df----
d_vm <- dat2_long %>% filter(test == "vrmem") 

# z-score verbal memory score
mean_vm <- mean(dat$W1_SENAS_vrmem, na.rm = T)
sd_vm <- sd(dat$W1_SENAS_vrmem, na.rm = T)
d_vm$score_z <- (d_vm$score - mean_vm)/(sd_vm)

# d_vm is the final dataframe for verbal memory

#---- executive function df -----
d_e <- dat2_long %>% filter(test == "exec")

# z-score executive function score
mean_exec <- mean(dat$W1_SENAS_exec, na.rm = T)
sd_exec <- sd(dat$W1_SENAS_exec, na.rm = T)
d_e$score_z <- (d_e$score - mean_exec)/(sd_exec)

# d_e is the final dataframe for executive function