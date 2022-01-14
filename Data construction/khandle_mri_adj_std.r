#---- Script Info----
#Author: Joey F.
#Date Updated: Dec/16/2021
#Basic info: This script regresses KHANDLE MRI ROI's against total intracranial volume 
#(adjusts for head size), outputs the residuals, and standardizes the residuals. 
#This script standardizes residuals using the Blom method (what DM suggested) 
#and z-scores. 

#---- Setting up necessary packages ----
if (!require("pacman")) 
  install.packages("pacman", repos='http://cran.us.r-project.org')

p_load("tidyverse",  "dplyr", "tidyr", "rcompanion", "readxl", "ggplot", "fitdistrplus")

#---- Filepaths for datasets ----
path_to_box<-'C:/Users/j_fong/'

#---- Loading in datasets ----
khandle_mri <- readxl::read_xlsx(paste0(path_to_box, 
                         'Box/KANDLE_coded_data/Raw_data_tables/MRI_PET/',
                         'KHANDLE_MRI_PET_2021Nov12/',
                         'khandle_T1_analysis_111221.xlsx'), 
                  col_names = TRUE)

#---- Loop for regressing brain area against intracranial volume and Blom-transforming residuals ----
#Note: Feed goes through each individual variable from the list of MRI variables, regresses them 
#against total intracranial volume, pulls the residuals, then Blom-transforms these residuals.
#Untransformed regression residuals and Blom-transformed residuals are added to the existing dataset

mri_var_list <- c('Cerebrum_tcb', 'Total_hippo', 
                  'Frontal_Cortical', 'Occipital_Cortical', 'Parietal_Cortical', 
                  'Temporal_Cortical', 'Cerebrum_gray', 'Total_wmh')

for (i in 1:length(mri_var_list)){
  assign(paste0(mri_var_list[i], '_model'), value = 
           lm(eval(rlang::parse_expr(mri_var_list[i])) ~ Cerebrum_tcv,
              data = khandle_mri,
              na.action=na.exclude))
  
  khandle_mri <- khandle_mri %>% 
    add_column(
      "{mri_var_list[i]}_predict_val" := 
            predict(
              eval(rlang::parse_expr(paste0(mri_var_list[i], '_model')))))

  khandle_mri <- khandle_mri %>%
    add_column(
      "{mri_var_list[i]}_residual" :=
        eval(rlang::parse_expr(paste0('khandle_mri$', mri_var_list[i]))) -
        predict(eval(rlang::parse_expr(paste0(
          mri_var_list[i], '_model')))))
  
  khandle_mri <- khandle_mri %>%
    add_column(
      "{mri_var_list[i]}_blom_std" :=
        blom(eval(rlang::parse_expr(paste0('khandle_mri$', mri_var_list[i],
                                           '_residual'))),
             method = "blom",
             alpha = 3/8))
               
 }
