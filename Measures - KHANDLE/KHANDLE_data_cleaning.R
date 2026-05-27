# KHANDLE data cleaning
# Code from social isolation paper
# Adapted by: Ami Sheth

## ---- Package loading + options ----
# rm(list = ls())
# 
# if (!require("pacman")){
#   install.packages("pacman", repos = 'http://cran.us.r-project.org')
# }
# p_load("readr", "tidyverse", "janitor", "haven")
# 
# ##---- Read in pathnames ----
# source(here::here("scripts", "0.0_paths.R"))

##---- Read in KHANDLE & EHR data ----
# Only read in cycle 1 data
khandle_cycle1 <- read_sas(path_khandle_all) %>%
  # lower the case of column names
  clean_names() %>%
  filter(cohort == 1) %>%
  mutate(studyid = as.numeric(studyid))

ehr_data <- read_sas(path_khandle_ehr_data) %>%
  # lower the case of column names
  clean_names() %>%
  mutate(studyid = as.numeric(studyid)) %>% 
  select("studyid", "dm_registry_age", "first_htn_dx_age")

#---- UCLA only: top coded age ----
##---- Top-coded ages for Dx of diabetes and hypertension ----
ehr_data <- ehr_data %>% 
  rename(dm_registry_age_final = dm_registry_age,
         first_htn_dx_age_final = first_htn_dx_age)

##---- Interview Age ----
# for participants who aged 90+ for interview age in follow-up waves,
# age was imputed using the most recent available age value + median follow-up time
# NA in age remains NA
age_mat_fu <- khandle_cycle1 %>%
  select(studyid, contains("_interview_age")) %>%
  # Recode the masked age (age 90+) to missing
  mutate(across(contains("_interview_age"), ~ case_when(
    .x < 89.99 ~ .x, TRUE ~ NA_real_), .names = "{col}_na90")
  ) %>%
  mutate(
    # Obtain median of follow up time
    w1_w2_fu = w2_interview_age_na90 - w1_interview_age_na90,
    w1_w3_fu = w3_interview_age_na90 - w1_interview_age_na90,
    w1_w4_fu = w4_interview_age_na90 - w1_interview_age_na90,
    w1_w5_fu = w5_interview_age_na90 - w1_interview_age_na90,
    w2_w3_fu = w3_interview_age_na90 - w2_interview_age_na90,
    w2_w4_fu = w4_interview_age_na90 - w2_interview_age_na90,
    w2_w5_fu = w5_interview_age_na90 - w2_interview_age_na90,
    w3_w4_fu = w4_interview_age_na90 - w3_interview_age_na90,
    w3_w5_fu = w5_interview_age_na90 - w3_interview_age_na90,
    w4_w5_fu = w5_interview_age_na90 - w4_interview_age_na90,
    across(contains("_fu"),
           list(median = ~ median(.x, na.rm = T)), .names = "{col}_median"),
    # At wave 1, top code age at 90
    # At follow up waves, when age 90+, 
    # use most recent available age value + median follow up time
    w1_interview_age_final = case_when(
      w1_interview_age < 89.99 ~
        w1_interview_age,
      w1_interview_age >= 89.99 ~ 90),
    
    w2_interview_age_final = case_when(
      w2_interview_age >= 89.99 ~
        w1_interview_age_final + w1_w2_fu_median,
      TRUE ~ w2_interview_age),
    
    w3_interview_age_final = case_when(
      w3_interview_age >= 89.99 &
        !is.na(w2_interview_age_final) ~
        w2_interview_age_final + w2_w3_fu_median,
      w3_interview_age >= 89.99 &
        is.na(w2_interview_age_final) ~
        w1_interview_age_final + w1_w3_fu_median,
      TRUE ~ w3_interview_age),
    
    w4_interview_age_final = case_when(
      w4_interview_age >= 89.99 &
        !is.na(w3_interview_age_final) ~
        w3_interview_age_final + w3_w4_fu_median,
      w4_interview_age >= 89.99 &
        is.na(w3_interview_age_final) &
        !is.na(w2_interview_age_final) ~
        w2_interview_age_final + w2_w4_fu_median,
      w4_interview_age >= 89.99 &
        is.na(w3_interview_age_final) &
        is.na(w2_interview_age_final) ~
        w1_interview_age_final + w1_w4_fu_median,
      TRUE ~ w4_interview_age),
    
    w5_interview_age_final = case_when(
      w5_interview_age >= 89.99 & 
        !is.na(w4_interview_age_final) ~ 
        w4_interview_age_final + w4_w5_fu_median,
      w5_interview_age >= 89.99 & 
        is.na(w4_interview_age_final) & 
        !is.na(w3_interview_age_final) ~ 
        w3_interview_age_final + w3_w5_fu_median,
      w5_interview_age >= 89.99 & 
        is.na(w4_interview_age_final) & 
        is.na(w3_interview_age_final) & 
        !is.na(w2_interview_age_final) ~ 
        w2_interview_age_final + w2_w5_fu_median,
      w5_interview_age >= 89.99 & 
        is.na(w4_interview_age_final) & 
        is.na(w3_interview_age_final) & 
        is.na(w2_interview_age_final) ~
        w1_interview_age_final + w1_w5_fu_median,
      TRUE ~ w5_interview_age)
  )

khandle_cycle1 <- age_mat_fu %>% 
  select(studyid, contains("_interview_age_final")) %>% 
  right_join(khandle_cycle1, by = "studyid")

rm(age_mat_fu)

##---- Top-coded ages for death and refusal to participate ----
# khandle_cycle1 <- khandle_cycle1 %>% 
#   rename(age_at_death_final = age_at_death,
#          age_at_refuse_final = age_at_refuse)

age_mat_death_refuse <- khandle_cycle1 %>%
  select(studyid, contains("_interview_age_final"), censor_death, age_at_death, 
         censor_refuse, age_at_refuse) %>%
  mutate(
    # Recode the masked age (age 90+) to missing
    across(c(age_at_death, age_at_refuse), ~ case_when(
      .x < 89.99 ~ .x,
      TRUE ~ NA_real_), .names = "{col}_na90"),
    # Get last available interview age
    last_interview_age = pmax(w1_interview_age_final,
                              w2_interview_age_final,
                              w3_interview_age_final,
                              w4_interview_age_final, 
                              w5_interview_age_final, 
                              na.rm = TRUE)
    ) %>%
  mutate(# Obtain median time between last interview and death/refusal
    lastinw_death_fu = age_at_death_na90 - last_interview_age,
    lastinw_refuse_fu = age_at_refuse_na90 - last_interview_age,
    across(contains("_fu"),
           list(median = ~ median(.x, na.rm = T)), .names = "{col}_median"),
    # If top coded at 90 for death and refuse, use last_interview_age + median f/u time
    age_at_death_final = case_when(
      age_at_death >= 89.99 &
        !is.na(last_interview_age) ~
        last_interview_age + lastinw_death_fu_median,
      TRUE ~ age_at_death),
    age_at_refuse_final = case_when(
      age_at_refuse >= 89.99 &
        !is.na(last_interview_age) ~
        last_interview_age + lastinw_refuse_fu_median,
      TRUE ~ age_at_refuse))

khandle_cycle1 <- age_mat_death_refuse %>% 
  select(studyid, c("age_at_death_final", "age_at_refuse_final")) %>% 
  right_join(khandle_cycle1, by = "studyid") %>% 
  select(-c("age_at_death", "age_at_refuse"))

rm(age_mat_death_refuse)

# #---- KP only: identified data (age) ----
# # Change the name of variables to be the same as UCLA top coded constructed data
# khandle_cycle1 <- khandle_cycle1 %>%
#   select(-paste0("w", 1:4, "_interview_age"),
#          -c("age_at_death", "age_at_refuse")) %>%
#   dplyr::rename(
#     # Interview age
#     w1_interview_age_final = w1_interview_age_phi,
#     w2_interview_age_final = w2_interview_age_phi,
#     w3_interview_age_final = w3_interview_age_phi,
#     w4_interview_age_final = w4_interview_age_phi,
#     w5_interview_age_final = w5_interview_age_phi,
#     # Age at attrition
#     age_at_death_final = age_at_death_phi, # based on data dictionary 20250110
#     age_at_refuse_final = age_at_refuse_phi) # KP: Var name to be confirmed
# 
# ehr_data <- ehr_data %>%
#   select(-c("dm_registry_age", "first_htn_dx_age")) %>%
#   dplyr::rename(
#     # Age at Dx of diabetes and hypertension
#     dm_registry_age_final = dm_registry_age_phi, # KP: var name to be confirmed
#     first_htn_dx_age_final = first_htn_dx_age_phi) # KP: Var name to be confirmed

#---- Below code chunks can be run for both UCLA and Kaiser team ----
##---- Redefine participation for KHANDLE ----
xtabs(~is.na(w1_interview_age_final), data = khandle_cycle1, addNA = T) #none
xtabs(~is.na(w2_interview_age_final), data = khandle_cycle1, addNA = T) #299
xtabs(~is.na(w3_interview_age_final), data = khandle_cycle1, addNA = T) #370
xtabs(~is.na(w4_interview_age_final), data = khandle_cycle1, addNA = T) #754
xtabs(~is.na(w5_interview_age_final), data = khandle_cycle1, addNA = T) #1226

# if interview age is missing, considered not having completed interview 
khandle_cycle1 <- khandle_cycle1 %>% 
  mutate(w1_participation = ifelse(is.na(w1_interview_age_final), 0, 1),
         w2_participation = ifelse(is.na(w2_interview_age_final), 0, 1),
         w3_participation = ifelse(is.na(w3_interview_age_final), 0, 1),
         w4_participation = ifelse(is.na(w4_interview_age_final), 0, 1),
         w5_participation = ifelse(is.na(w5_interview_age_final), 0, 1)
  ) 

# Sanity check
# xtabs(~w1_participation, data = khandle_cycle1, addNA = T) #none
# xtabs(~w2_participation, data = khandle_cycle1, addNA = T) #none
# xtabs(~w3_participation, data = khandle_cycle1, addNA = T) #none
# xtabs(~w4_participation, data = khandle_cycle1, addNA = T) #none
# xtabs(~w5_participation, data = khandle_cycle1, addNA = T) #none

##---- Identify for each subject their final save and age at final wave ----
khandle_wave_max <- khandle_cycle1 %>% 
  pivot_longer(cols = ends_with("interview_age_final"),
               names_to = "wave",
               values_to = "age_at_wave") %>% 
  filter(!is.na(age_at_wave)) %>% 
  group_by(studyid) %>% 
  slice_max(age_at_wave) %>% 
  ungroup() %>% 
  mutate(final_wave = parse_number(wave)) %>% 
  rename(age_at_final_wave = age_at_wave) 

khandle_cycle1 <- khandle_wave_max %>% 
  select(studyid, age_at_final_wave, final_wave) %>% 
  right_join(khandle_cycle1, by = "studyid")

rm(khandle_wave_max)

##---- Redefine death & dropout variables ----
# 1. participated in w5 --> ltfu_outcome = 0
# age_at_death >= age at wave 5 except for top coded cases
# no age at refusal
fu_time_mat <- khandle_cycle1 %>%
  select(studyid, contains("_interview_age_final"), final_wave, 
         age_at_final_wave, age_at_death_final, 
         age_at_refuse_final, contains("participation"),
         dstatus_visit, dstatus_survey) %>%
  mutate(
    # Obtain median and max difference in follow up time
    w1_w2_fu_final = w2_interview_age_final - w1_interview_age_final,
    w2_w3_fu_final = w3_interview_age_final - w2_interview_age_final,
    w3_w4_fu_final = w4_interview_age_final - w3_interview_age_final,
    w4_w5_fu_final = w5_interview_age_final - w4_interview_age_final,
    across(contains("_fu"),
           list(median = ~ median(.x, na.rm = T)), .names = "{col}_median"), 
    across(ends_with("_fu_final"), 
           list(max = ~ max(.x, na.rm = T)), .names = "{col}_max"), 
    add_time = case_when(
      final_wave == 5 ~ NA,
      final_wave == 4 ~ w4_w5_fu_final_max,
      final_wave == 3 ~ w3_w4_fu_final_max,
      final_wave == 2 ~ w2_w3_fu_final_max,
      final_wave == 1 ~ w1_w2_fu_final_max
    ),
    # Inferred time is age at final + max time based on those who participated
    inferred_time = age_at_final_wave + add_time, 
    end_age = case_when(
      w5_participation == 1 ~ w5_interview_age_final, TRUE ~ NA),
    ltfu_outcome = case_when(
      w5_participation == 1 ~ 0, TRUE ~ NA)
  )

# khandle_cycle1 %>% filter(w5_participation == 1) %>% # n = 3
#   count(dstatus_visit, censor_death)
# khandle_cycle1 %>% filter(w5_participation == 1) %>% # n = 0
#   count(dstatus_visit, censor_refuse)
# fu_time_mat %>% filter(w5_participation == 1,
#                        !is.na(age_at_death_final)) %>% View()

# 94 people with interview completed & acquired abut missing wave 5 age
# n = 5 final wave = 3, n = 89 final wave = 4
# considered part of study so ltfu_outcome = 0, infer age at w5
# fu_time_mat %>% filter(dstatus_visit == "interview completed",
#                        is.na(w4_interview_age_final)) %>% View()

fu_time_mat <- fu_time_mat %>% 
  mutate(
    ltfu_outcome = case_when(
      !is.na(ltfu_outcome) ~ ltfu_outcome, 
      dstatus_visit %in% "interview completed" ~ 0,
      TRUE ~ NA
    ), 
    end_age = case_when(
      !is.na(end_age) ~ end_age,
      dstatus_visit %in% "interview completed" ~ inferred_time,
      TRUE ~ NA
    )
  )

# 2. all others have ltfu_outcome = 1 (not death) or 2 (death)
# a. dstatus_visit = firm refusal
# 1 who refused before inferred time, all censor_death = 0
# fu_time_mat %>% filter(dstatus_visit == "firm refusal") %>%
#   mutate(last_to_refuse = age_at_refuse_final - age_at_final_wave) %>%
#   mutate(compare = inferred_time < age_at_refuse_final) %>%
#   view() ## there are true cases beyond the NA

fu_time_mat <- fu_time_mat %>% 
  mutate(
    ltfu_outcome = case_when(
      !is.na(ltfu_outcome) ~ ltfu_outcome,
      dstatus_visit == "firm refusal" ~ 1,
      TRUE ~ NA
    ), 
    end_age = case_when(
      !is.na(end_age) ~ end_age,
      dstatus_visit == "firm refusal" ~ pmin(age_at_refuse_final, inferred_time, 
                                             na.rm = T), # inferred w5 time
      TRUE ~ NA
    )
  )

# b. dstatus_visit = deceased, ltfu_outcome = 2
# two censor_death = 0, all censor_refused = 0
# fu_time_mat %>% filter(dstatus_visit == "deceased") %>%
#   mutate(last_to_death = age_at_death_final - age_at_final_wave) %>%
#   mutate(compare = inferred_time < age_at_death_final) %>%
#   View()

fu_time_mat <- fu_time_mat %>% 
  mutate(
    ltfu_outcome = case_when(
      !is.na(ltfu_outcome) ~ ltfu_outcome, 
      # died after study--considered refusal to participate? 
      # dstatus_visit %in% "deceased" & inferred_time < age_at_death_final ~ 1, 
      dstatus_visit %in% "deceased" ~ 2, # check: 2 NA case IS considered dead
      TRUE ~ NA
    ), 
    end_age = case_when(
      !is.na(end_age) ~ end_age,
      dstatus_visit %in% "deceased" ~ pmin(inferred_time, age_at_death_final, 
                                           na.rm = T),
      TRUE ~ NA
    )
  )

# c. dstatus_visit = available for interview 
# no refusal or death censoring but lots of missing participation - still consider part of study? 
# fu_time_mat %>% filter(dstatus_visit == "available for interview") %>% view()

fu_time_mat <- fu_time_mat %>% 
  mutate(
    ltfu_outcome = case_when(
      !is.na(ltfu_outcome) ~ ltfu_outcome,
      dstatus_visit %in% "available for interview" & final_wave < 3 ~ 1, # added rule
      dstatus_visit %in% "available for interview" ~ 0,
      TRUE ~ NA
    ),
    end_age = case_when(
      !is.na(end_age) ~ end_age,
      dstatus_visit %in% "available for interview" ~ inferred_time,
      TRUE ~ NA
    )
  )

# d. dstatus_visit = on hold
# no death censor, 1 censor_refuse = 1, 2 no w4 participation 
# fu_time_mat %>% filter(dstatus_visit == "on hold") %>% view()

fu_time_mat <- fu_time_mat %>% 
  mutate(
    ltfu_outcome = case_when(
      !is.na(ltfu_outcome) ~ ltfu_outcome,
      # w4 age and no refusal/death, part of study
      dstatus_visit %in% "on hold" & final_wave < 3 ~ 1, # changed rule
      dstatus_visit %in% "on hold" & inferred_time > age_at_death_final ~ 2,
      dstatus_visit %in% "on hold" & inferred_time > age_at_refuse_final ~ 1,
      dstatus_visit %in% "on hold" ~ 0, 
      TRUE ~ NA
    ),
    end_age = case_when(
      !is.na(end_age) ~ end_age,
      dstatus_visit %in% "on hold" ~ pmin(inferred_time, age_at_death_final, 
                                          age_at_refuse_final, na.rm = T),
      TRUE ~ NA
    )
  )

# e. dstatus_visit = unavailable 
# mix of participation, all have censor_death = 1 or censor_refuse = 1
# some cases of inferred time > age_at_death_final or age_at_refuse_final
# fu_time_mat %>% filter(dstatus_visit == "unavailable") %>% view()
fu_time_mat <- fu_time_mat %>% 
  mutate(
    ltfu_outcome = case_when(
      !is.na(ltfu_outcome) ~ ltfu_outcome,
      dstatus_visit %in% "unavailable" & inferred_time > age_at_death_final ~ 2, # highly correlated
      dstatus_visit %in% "unavailable" ~ 1,
      # dstatus_visit %in% "unavailable" & inferred_time <= age_at_death_final ~ 1,
      # dstatus_visit %in% "unavailable" & inferred_time > age_at_refuse_final ~ 1,
      # dstatus_visit %in% "unavailable" & inferred_time <= age_at_refuse_final ~ 1,
      TRUE ~ NA
    ),
    end_age = case_when(
      !is.na(end_age) ~ end_age,
      dstatus_visit %in% "unavailable" ~ pmin(inferred_time, 
                                              age_at_refuse_final, 
                                              age_at_death_final, na.rm = T),
      TRUE ~ NA
    )
  )

# f. dstatus_visit = passive refusal
# 1 censor_death = 1, all censor_refuse = 0
# include in study if censor_refuse = 0 and participated in wave 3
# fu_time_mat %>% filter(dstatus_visit == "passive refusal") %>% view()

fu_time_mat <- fu_time_mat %>% 
  mutate(
    ltfu_outcome = case_when(
      !is.na(ltfu_outcome) ~ ltfu_outcome,
      dstatus_visit %in% "passive refusal" & inferred_time > age_at_death_final ~ 2,
      dstatus_visit %in% "passive refusal" & final_wave < 3 ~ 1, # changed rule
      dstatus_visit %in% "passive refusal" ~ 0,
      TRUE ~ NA
    ),
    end_age = case_when(
      !is.na(end_age) ~ end_age,
      dstatus_visit %in% "passive refusal" ~ pmin(inferred_time, 
                                                  age_at_death_final, na.rm = T),
      TRUE ~ NA
    )
  )

# g. dstatus = interview cancelled; dstatus = interview scheduled; dstatus = interview pending reschedule 
# fu_time_mat %>% 
#   filter(dstatus_visit %in% c("interview cancelled", 
#                               "interview pending reschedule", 
#                               "interview scheduled")) %>% view()

# no refusal or death censoring; all participated in wave 4 but 1
fu_time_mat <- fu_time_mat %>% 
  mutate(
    ltfu_outcome = case_when(
      !is.na(ltfu_outcome) ~ ltfu_outcome,
      dstatus_visit %in% c("interview cancelled", 
                           "interview pending reschedule", 
                           "interview scheduled") & final_wave < 3 ~ 1,
      dstatus_visit %in% c("interview cancelled", 
                           "interview pending reschedule", 
                           "interview scheduled") ~ 0,
      TRUE ~ NA
    ),
    end_age = case_when(
      !is.na(end_age) ~ end_age,
      dstatus_visit %in% c("interview cancelled", 
                           "interview pending reschedule", 
                           "interview scheduled") ~ inferred_time,
      TRUE ~ NA
    )
  )

# Add these variables to the main dataset
khandle_cycle1 <- fu_time_mat %>% 
  select(studyid, end_age, ltfu_outcome) %>% 
  right_join(khandle_cycle1, by = "studyid")

rm(fu_time_mat)

# Add time variables
# if age_at_death and age_at_refusal are not top coded, then end up with
# some neg time bc end age = 89.99, w1_interview_age_final = 90 for 89.99
khandle_cycle1 <- khandle_cycle1 %>% 
  mutate(end_time = end_age - w1_interview_age_final) 

##### CLEANING SPECIFIC TO SENAS SCORES #####
##---- Code to fix the participants with senas score but no age ---- 
# NOTE: Kaiser team has been contacted and will be fixed in the next data release
# khandle_cycle1 %>% count(is.na(w1_interview_age_final), is.na(w1_d_senas_exec_z))
# khandle_cycle1 %>% count(is.na(w2_interview_age_final), is.na(w2_d_senas_exec_z))
# khandle_cycle1 %>% count(is.na(w3_interview_age_final), is.na(w3_d_senas_exec_z))
# khandle_cycle1 %>% count(is.na(w4_interview_age_final), is.na(w4_d_senas_exec_z))
# khandle_cycle1 %>% count(is.na(w1_interview_age_final), is.na(w1_d_senas_vrmem_z))
# khandle_cycle1 %>% count(is.na(w2_interview_age_final), is.na(w2_d_senas_vrmem_z))
# khandle_cycle1 %>% count(is.na(w3_interview_age_final), is.na(w3_d_senas_vrmem_z))
# khandle_cycle1 %>% count(is.na(w4_interview_age_final), is.na(w4_d_senas_vrmem_z))
# # issue at wave 2 (exec: n = 60, vrmem: n = 58); wave 4 (exec: n = 3, vrmem: n = 3)
# 
# # wave 4 has senas scores but should be for wave 5 --> force to NA
# # same people for exec and vrmem 
# khandle_cycle1 <- khandle_cycle1 %>% 
#   mutate(w4_d_senas_exec_z = ifelse(is.na(w4_interview_age_final) & 
#                                       !is.na(w4_d_senas_exec_z), 
#                                     NA_real_, 
#                                     w4_d_senas_exec_z),
#          w4_d_senas_vrmem_z = ifelse(is.na(w4_interview_age_final) & 
#                                       !is.na(w4_d_senas_vrmem_z), 
#                                     NA_real_, 
#                                     w4_d_senas_vrmem_z)
#          )
# 
# # backlogged so wave 2 has senas score but should have been for wave 3 
# khandle_cycle1 <- khandle_cycle1 %>%
#   mutate(
#     w3_d_senas_exec_z = ifelse(is.na(w2_interview_age_final) &
#                                   !is.na(w2_d_senas_exec_z),
#                                 w2_d_senas_exec_z,
#                                 w3_d_senas_exec_z),
#     w2_d_senas_exec_z = ifelse(is.na(w2_interview_age_final) & 
#                                   !is.na(w2_d_senas_exec_z),
#                                 NA_real_,
#                                 w2_d_senas_exec_z),
#     w3_d_senas_vrmem_z = ifelse(is.na(w2_interview_age_final) &
#                                    !is.na(w2_d_senas_vrmem_z),
#                                  w2_d_senas_vrmem_z,
#                                  w3_d_senas_vrmem_z),
#     w2_d_senas_vrmem_z = ifelse(is.na(w2_interview_age_final) & 
#                                    !is.na(w2_d_senas_vrmem_z), 
#                                  NA_real_, 
#                                  w2_d_senas_vrmem_z)
#   )
