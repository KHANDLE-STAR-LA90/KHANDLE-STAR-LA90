# KHANDLE covariate cleaning
# Code from social isolation paper and edu occupational complexity paper 
# Adapted by: Ami Sheth

## ---- Package loading + options ----
# rm(list = ls())

if (!require("pacman")){
  install.packages("pacman", repos = 'http://cran.us.r-project.org')
}
p_load("readr", "tidyverse", "janitor", "haven")

##---- Read in pathnames ----
# source(here::here("scripts", "0.0_paths.R"))

##---- Read in cleaned KHANDLE & EHR data ----
# source(here::here("scripts", "KHANDLE_data_cleaning.R"))

##---- Universal covariate cleaning ----
# Cleaning health, hearing/vision, and disability measures
# Health: 1 Excellent, 2 Very good, 3 Good, 4 Fair, 5 Poor
# ADL and IADL : 1 No Difficulty, 2 Some Difficulty, 3 Much Difficulty, 4 Unable to Do
# Hearing and vision: 1 Excellent, 2 Very Good, 3 Good, 4 Fair, 5 Poor
# Pain: 0 No, 1 Yes, 77 Not administered, 88 = Refused, 99 = Dont know
# Definition based on:
# https://github.com/KHANDLE-STAR-LA90/KHANDLE-STAR-LA90/tree/master/Measures%20-%20KHANDLE/DAILY_LIVING

health_dt <- khandle_cycle1 %>%
  mutate(
    across(ends_with(c("_health", "sensimp_hearing", "sensimp_vision")),
           ~case_when(.x %in% 1:5 ~ .x,
                      TRUE ~ NA_real_), .names = "{col}_v2"),
    across(contains("daily_living"),
           ~case_when(.x %in% 1:4 ~ .x,
                      TRUE ~ NA_real_), .names = "{col}_v2"),
    across(ends_with("_pain"),
           ~case_when(.x %in% c(77, 88, 99) ~ NA_real_,
                      TRUE ~ .x), .names = "{col}_v2")
    ) %>%
  # Select only cleaned variables and rename them
  select(studyid, 
         matches(c("health_v2", "daily_living_\\w*_v2", 
                   "sensimp_\\w*_v2", "pain_v2")
                 )
         ) %>%
  rename_at(vars(matches("daily_living_\\w*\\d_v2")), 
            ~str_remove_all(.x, "daily_living_|_v2")) %>%
  rename_at(vars(contains("health_v2")),
            ~str_replace(.x, "health_v2", "srhealth")) %>%
  rename_at(vars(contains("pain_v2")),
            ~str_replace(.x, "pain_v2", "gpain")) %>%
  rename_at(vars(matches("sensimp_\\w*_v2")), 
            ~str_remove_all(.x, "sensimp_|_v2"))

khandle_cycle1_cleaned <- khandle_cycle1 %>% 
  left_join(health_dt, by = "studyid")

rm(health_dt)

# Cleaning baseline covariates
# 66/77 = Not administered, 88 = Refused, 99 = Dont know (DK)
khandle_cycle1_cleaned <- khandle_cycle1_cleaned %>%
  mutate(
    # Marital status
    across(contains("marital_status"),
           ~case_when(.x %in% c(77, 88, 99) ~ NA_real_,
                      TRUE ~ .x), .names = "{col}"),
    # Derived gender: 1 = Male, 2 = Female
    female = case_when(
      w1_d_gender == 2 ~ 1, w1_d_gender == 1 ~ 0
    ),
    # Derived race
    race_cat = w1_d_race_summary,
    # Derived education: 8 = Other, 9 = DK, 10 = Refused
    edu_cat = case_when(
      w1_d_education %in% c(8, 9, 10) ~ NA_real_, TRUE ~ w1_d_education 
    ), 
    # Derive years of education: two versions
    ## Version 1: excludes yrs of education from certification
    edu_yrs = case_when(
      !is.na(w1_edu_education_text) ~ w1_edu_education_text, # 0 - 12 yrs
      w1_edu_education == 1 ~ 13, # some college
      w1_edu_education == 2 ~ 14, # associates
      w1_edu_education == 3 ~ 16, # bachelors
      w1_edu_education == 4 ~ 18, # masters
      w1_edu_education == 5 ~ 20, # doctoral degree
      TRUE ~ NA_integer_
    ),
    # create a flag for education for certification with an instructor 
    # that lasted 6 months or more (counts as 1 year)
    cert.flag = ifelse(w1_edu_trncert == 2 & w1_edu_longcert == 4, 1, 0), 
    ## Version 2: includes yrs of education from certification
    edu_yrs_cert = ifelse(
      edu_yrs <= 12 & !is.na(cert.flag), 
      edu_yrs + cert.flag, 
      edu_yrs
    )
    # Parental education
    maternal_edu = case_when(
      w1_maternal_education %in% c(66, 88, 99) ~ NA_real_, 
      TRUE ~ w1_maternal_education
    ), 
    maternal_edu_text = w1_maternal_education_text,
    paternal_edu = case_when(
      w1_paternal_education %in% c(66, 88, 99) ~ NA_real_, 
      TRUE ~ w1_paternal_education
    ), 
    paternal_edu_text = w1_paternal_education_text,
    maternal_edu_gteq8yrs = case_when(
      maternal_edu_text < 8 & maternal_edu == 0 ~ 0, 
      maternal_edu_text >= 8 | maternal_edu %in% 1:5 ~ 1,
      TRUE ~ NA_real_
    ), 
    paternal_edu_gteq8yrs = case_when(
      paternal_edu_text < 8 & paternal_edu == 0 ~ 0, 
      paternal_edu_text >= 8 | paternal_edu %in% 1:5 ~ 1, 
      TRUE ~ NA_real_),
    # All source annual household income using the upper bound 
    # The highest category, $125,000 and over, was recoded as $150,000)
    # and log-transformed.
    across(
      contains("_incmrange_hmnzd"), ~ case_when(
        .x == 1 ~ log(10000), 
        .x == 2 ~ log(15000),
        .x == 3 ~ log(20000), 
        .x == 4 ~ log(25000), 
        .x == 5 ~ log(35000), 
        .x == 6 ~ log(75000), 
        .x == 7 ~ log(100000), 
        .x == 8 ~ log(125000), 
        .x == 9 ~ log(150000), 
        TRUE ~ NA_real_
      ), 
      .names = "{col}_logupper"), 
    # US born: non-US country of birth -> set to 0 immediately 
    usborn = case_when(
      w1_country_born != 1 & !is.na(w1_country_born) ~ 0,
      w1_country_born == 1 ~ 1, 
      w1_res_1_4_state_rgn %in% 
        c('Midwest', 'Northeast', 'Pacific', 'South', 'West') & 
        (is.na(w1_country_born)) ~ 1,
      is.na(w1_country_born) ~ as.numeric(NA), # should 77, 88, 99 be NA?
      TRUE ~ 0),
    # Census region 
    census_region = case_when(
      w1_res_1_4_state_rgn == '' ~ NA_character_, 
      TRUE ~ w1_res_1_4_state_rgn), 
    # Southern birth
    southern_birth = case_when(
      !is.na(w1_country_born) & w1_country_born != 1 ~ 0, 
      census_region == 'South' ~ 1, 
      census_region == 'Midwest' ~ 0, 
      census_region == 'Northeast' ~ 0, 
      census_region == 'Pacific' ~ 0, 
      census_region == 'West' ~ 0, 
      census_region == 'Foreign-born' ~ 0, 
      is.na(usborn) & is.na(census_region) ~ as.numeric(NA)
    )
  ) %>% 
  # rename log transformed household income variables
  rename_at(vars(contains("_incmrange_hmnzd_logupper")), 
            ~ str_replace(.x, "_incmrange_hmnzd_logupper", "_hhincome_log")) %>%
  select(-c(w1_maternal_education_text, 
            w1_paternal_education_text, 
            w1_d_race_summary,
            w1_res_1_4_state_rgn))
