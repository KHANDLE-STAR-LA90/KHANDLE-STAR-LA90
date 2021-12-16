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

#---- Filepaths for datasets
path_to_box<-'C:/Users/j_fong/'

#---- Loading in datasets ----
khandle_mri <- readxl::read_xlsx(paste0(path_to_box, 
                         'Box/KANDLE_coded_data/Raw_data_tables/MRI_PET/',
                         'KHANDLE_MRI_PET_2021Nov12/',
                         'khandle_T1_analysis_111221.xlsx'), 
                  col_names = TRUE)

#---- Total Brain Volume ----
#---- **Total Brain Volume Residuals ----
tbv_model <- lm(Cerebrum_tcb ~ Cerebrum_tcv, 
                data = khandle_mri)

khandle_mri$tbv_residual <- khandle_mri$Cerebrum_tcb - predict(tbv_model)

#---- **Z-scoring total brain volume residuals ----
khandle_mri$tbv_adj_zscored <- (khandle_mri$tbv_residual - 
                                   mean(khandle_mri$tbv_residual))/sd(khandle_mri$tbv_residual)

#---- **Blom-standardizing residuals ----
khandle_mri$tbv_blom_std <- blom(khandle_mri$tbv_residual,
                                 method = "blom",
                                 alpha = 3/8)

#---- WMH ----
#---- **subsetting to complete WMH cases ----
wmh_clean <- khandle_mri[complete.cases(khandle_mri$Total_wmh),]
#1 observation removed (ID = K005881)

#---- **getting WMH residuals ----
wmh_model <- lm(Total_wmh ~ Cerebrum_tcv, 
                data = wmh_clean)

wmh_clean$wmh_residual <- wmh_clean$Total_wmh - predict(wmh_model)

#---- **Z-scoring WMH residuals ----
wmh_clean$wmh_adj_zscored <- (wmh_clean$wmh_residual - 
                                  mean(wmh_clean$wmh_residual))/sd(wmh_clean$wmh_residual)

#---- **Blom-standardizing WMH residuals ----
wmh_clean$wmh_blom_std <- blom(wmh_clean$wmh_residual,
                                 method = "blom",
                                 alpha = 3/8)

#----Total Hippocampal Volume ----
#---- **subsetting to complete Hippocampal volume cases ----
hippo_clean <- khandle_mri[complete.cases(khandle_mri$Total_hippo),]
#1 observation removed

#---- **getting hippo residuals ----
hippo_model <- lm(Total_hippo ~ Cerebrum_tcv, 
                data = hippo_clean)

hippo_clean$hippo_residual <- hippo_clean$Total_hippo - predict(hippo_model)

#---- **Z-scoring hippo residuals ----
hippo_clean$hippo_adj_zscored <- (hippo_clean$hippo_residual - 
                                mean(hippo_clean$hippo_residual))/sd(hippo_clean$hippo_residual)

#---- **Blom-standardizing hippo residuals ----
hippo_clean$hippo_blom_std <- blom(hippo_clean$hippo_residual,
                               method = "blom",
                               alpha = 3/8)

#----Frontal Lobar Region ----
#----**subset to complete frontal lobe volume ----
frontal_clean <- khandle_mri[complete.cases(khandle_mri$Frontal_Cortical),]

#---- **getting frontal lobar residuals ----
frontal_model <- lm(Frontal_Cortical ~ Cerebrum_tcv, 
                  data = frontal_clean)

frontal_clean$frontal_residual <- frontal_clean$Frontal_Cortical - predict(frontal_model)

#---- **Z-scoring frontal residuals ----
frontal_clean$frontal_adj_zscored <- (frontal_clean$frontal_residual - 
                                    mean(frontal_clean$frontal_residual))/sd(frontal_clean$frontal_residual)

#---- **Blom-standardizing frontal residuals ----
frontal_clean$frontal_blom_std <- blom(frontal_clean$frontal_residual,
                                   method = "blom",
                                   alpha = 3/8)

#----Occipital Lobar Region ----
#----**subset to complete occipital lobe volume ----
occipital_clean <- khandle_mri[complete.cases(khandle_mri$Occipital_Cortical),]

#---- **getting occipital lobar residuals ----
occipital_model <- lm(Occipital_Cortical ~ Cerebrum_tcv, 
                    data = occipital_clean)

occipital_clean$occipital_residual <- occipital_clean$Occipital_Cortical - predict(occipital_model)

#---- **Z-scoring occipital residuals ----
occipital_clean$occipital_adj_zscored <- (occipital_clean$occipital_residual - 
                                        mean(occipital_clean$occipital_residual))/sd(occipital_clean$occipital_residual)

#---- **Blom-standardizing occipital residuals ----
occipital_clean$occipital_blom_std <- blom(occipital_clean$occipital_residual,
                                     method = "blom",
                                     alpha = 3/8)

#----Parietal Lobar Region ----
#----**subset to complete parietal lobe volume ----
parietal_clean <- khandle_mri[complete.cases(khandle_mri$Parietal_Cortical),]

#---- **getting parietal lobar residuals ----
parietal_model <- lm(Parietal_Cortical ~ Cerebrum_tcv, 
                      data = parietal_clean)

parietal_clean$parietal_residual <- parietal_clean$Parietal_Cortical - predict(parietal_model)

#---- **Z-scoring parietal residuals ----
parietal_clean$parietal_adj_zscored <- (parietal_clean$parietal_residual - 
                                            mean(parietal_clean$parietal_residual))/sd(parietal_clean$parietal_residual)

#---- **Blom-standardizing parietal residuals ----
parietal_clean$parietal_blom_std <- blom(parietal_clean$parietal_residual,
                                           method = "blom",
                                           alpha = 3/8)

#----Temporal Lobar Region ----
#----**subset to complete temporal lobe volume ----
temporal_clean <- khandle_mri[complete.cases(khandle_mri$Temporal_Cortical),]

#---- **getting temporal lobar residuals ----
temporal_model <- lm(Temporal_Cortical ~ Cerebrum_tcv, 
                     data = temporal_clean)

temporal_clean$temporal_residual <- temporal_clean$Temporal_Cortical - predict(temporal_model)

#---- **Z-scoring temporal residuals ----
temporal_clean$temporal_adj_zscored <- (temporal_clean$temporal_residual - 
                                          mean(temporal_clean$temporal_residual))/sd(temporal_clean$temporal_residual)

#---- **Blom-standardizing temporal residuals ----
temporal_clean$temporal_blom_std <- blom(temporal_clean$temporal_residual,
                                         method = "blom",
                                         alpha = 3/8)

#----All Density Plots (ignore if don't want ggplot output) ----
#---- **total brain volume histograms ----
ggplot(khandle_mri, aes(x = Cerebrum_tcb)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(khandle_mri$Cerebrum_tcb), 
                            sd = sd(khandle_mri$Cerebrum_tcb)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Raw Total Brain Volume",
       caption = paste0("Red is density function, blue is normal density function (using brain volume mean and SD)",
                        "\nMean = 892.4819\nSD = 91.59494"),
       x = 'Total Brain Volume, cm^3',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0)) 

ggplot(khandle_mri, aes(x = tbv_adj_zscored)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(khandle_mri$tbv_adj_zscored), 
                            sd = sd(khandle_mri$tbv_adj_zscored)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Total Brain Volume ~ Total Cranial Volume Residuals, Z-scored",
       caption = "Red is density function, blue is normal density function (using z-scored brain volume mean and SD)\nMean = 0\nSD = 1",
       x = 'Total Brain Volume Residuals, Z-scored',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

ggplot(khandle_mri, aes(x = tbv_blom_std)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(khandle_mri$tbv_blom_std), 
                            sd = sd(khandle_mri$tbv_blom_std)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Total Brain Volume ~ Total Cranial Volume Residuals, Blom-standardized",
       caption = "Red is density function, blue is normal density function (using Blom-standardized brain volume mean and SD)\nMean = 0\nSD = 0.99549",
       x = 'Total Brain Volume residuals, Blom-standardized',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

#----**WMH histograms----
ggplot(wmh_clean, aes(x = Total_wmh)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(wmh_clean$Total_wmh), 
                            sd = sd(wmh_clean$Total_wmh)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Raw WMH Volume",
       caption = paste0("Red is density function, blue is normal density function (using WMH mean and SD)",
                        "\nMean = 6.099017\nSD = 8.994846"),
       x = 'WMH, cm^3',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0)) 

ggplot(wmh_clean, aes(x = wmh_adj_zscored)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(wmh_clean$wmh_adj_zscored), 
                            sd = sd(wmh_clean$wmh_adj_zscored)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "WMH ~ Total Cranial Volume Residuals, Z-scored",
       caption = "Red is density function, blue is normal density function (using z-scored brain volume mean and SD)\nMean = 0\nSD = 1",
       x = 'WMH Residuals, Z-Scored',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

ggplot(wmh_clean, aes(x = wmh_blom_std)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(wmh_clean$wmh_blom_std), 
                            sd = sd(wmh_clean$wmh_blom_std)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "WMH ~ Total Cranial Volume Residuals, Blom-standardized",
       caption = "Red is density function, blue is normal density function (using Blom-standardized brain volume mean and SD)\nMean = 0\nSD = 0.9954773",
       x = 'WMH Residuals, Blom-standardized',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

#----**hippo histograms----
ggplot(hippo_clean, aes(x = Total_hippo)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(hippo_clean$Total_hippo), 
                            sd = sd(hippo_clean$Total_hippo)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Raw hippocampal Volume",
       caption = paste0("Red is density function, blue is normal density function (using hippocampal volume mean and SD)",
                        "\nMean = 6.228884\nSD = 0.7392186"),
       x = 'Hippocampal Volume, cm^3',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0)) 

ggplot(hippo_clean, aes(x = hippo_adj_zscored)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(hippo_clean$hippo_adj_zscored), 
                            sd = sd(hippo_clean$hippo_adj_zscored)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Hippocampal Volume ~ Total Cranial Volume Residuals, Z-scored",
       caption = "Red is density function, blue is normal density function (using z-scored hippocampal volume mean and SD)\nMean = 0\nSD = 1",
       x = 'Hippocampal Volume Residuals, Z-Scored',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

ggplot(hippo_clean, aes(x = hippo_blom_std)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(hippo_clean$hippo_blom_std), 
                            sd = sd(hippo_clean$hippo_blom_std)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Hippocampal Volume ~ Total Cranial Volume Residuals, Blom-standardized",
       caption = "Red is density function, blue is normal density function (using Blom-standardized hippocampal volume mean and SD)\nMean = 0\nSD = 0.9954773",
       x = 'Hippocampal Volume Residuals, Blom-standardized',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

#----**frontal lobe histograms----
ggplot(frontal_clean, aes(x = Frontal_Cortical)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(frontal_clean$Frontal_Cortical), 
                            sd = sd(frontal_clean$Frontal_Cortical)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Raw Frontal Lobe Volume",
       caption = paste0("Red is density function, blue is normal density function (using frontal lobe volume mean and SD)",
                        "\nMean = ", eval(mean(frontal_clean$Frontal_Cortical)),
                        "\nSD = ", eval(sd(frontal_clean$Frontal_Cortical))),
       x = 'Frontal Lobe Volume, cm^3',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0)) 

ggplot(frontal_clean, aes(x = frontal_adj_zscored)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(frontal_clean$frontal_adj_zscored), 
                            sd = sd(frontal_clean$frontal_adj_zscored)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Frontal Lobe Volume ~ Total Cranial Volume Residuals, Z-scored",
       caption = "Red is density function, blue is normal density function (using z-scored frontal lobe volume mean and SD)",
       "\nMean = ", eval(mean(frontal_clean$frontal_adj_zscored)),
       "\nSD = ", eval(sd(frontal_clean$frontal_adj_zscored)),
       x = 'Frontal Lobe Volume Residuals, Z-Scored',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

ggplot(frontal_clean, aes(x = hippo_blom_std)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(frontal_clean$frontal_blom_std), 
                            sd = sd(frontal_clean$frontal_blom_std)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Frontal Lobe Volume ~ Total Cranial Volume Residuals, Blom-standardized",
       caption = "Red is density function, blue is normal density function (using Blom-standardized frontal lobe volume mean and SD)\nMean = 0\nSD = 0.9954773",
       x = 'Frontal Lobe Residuals, Blom-standardized',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

#----**occipital lobe histograms----
ggplot(occipital_clean, aes(x = Occipital_Cortical)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(occipital_clean$Occipital_Cortical), 
                            sd = sd(occipital_clean$Occipital_Cortical)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Raw Occipital Lobe Volume",
       caption = paste0("Red is density function, blue is normal density function (using occipital lobe volume mean and SD)",
                        "\nMean = ", eval(mean(occipital_clean$Occipital_Cortical)),
                        "\nSD = ", eval(sd(occipital_clean$Occipital_Cortical))),
       x = 'Occipital Lobe Volume, cm^3',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

ggplot(occipital_clean, aes(x = occipital_adj_zscored)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(occipital_clean$occipital_adj_zscored), 
                            sd = sd(occipital_clean$occipital_adj_zscored)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Occipital Lobe Volume ~ Total Cranial Volume Residuals, Z-scored",
       caption = "Red is density function, blue is normal density function (using z-scored occipital lobe volume mean and SD)",
       "\nMean = ", eval(mean(occipital_clean$occipital_adj_zscored)),
       "\nSD = ", eval(sd(occipital_clean$occipital_adj_zscored)),
       x = 'Occipital Lobe Volume Residuals, Z-Scored',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

ggplot(occipital_clean, aes(x = occipital_blom_std)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(occipital_clean$occipital_blom_std), 
                            sd = sd(occipital_clean$occipital_blom_std)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Occipital Lobe Volume ~ Total Cranial Volume Residuals, Blom-standardized",
       caption = "Red is density function, blue is normal density function (using Blom-standardized occipital lobe volume mean and SD)\nMean = 0\nSD = 0.9954773",
       x = 'Occipital Lobe Residuals, Blom-standardized',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

#----**parietal lobe histograms----
ggplot(parietal_clean, aes(x = Parietal_Cortical)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(parietal_clean$Parietal_Cortical), 
                            sd = sd(parietal_clean$Parietal_Cortical)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Raw Parietal Lobe Volume",
       caption = paste0("Red is density function, blue is normal density function (using parietal lobe volume mean and SD)",
                        "\nMean = ", eval(mean(parietal_clean$Parietal_Cortical)),
                        "\nSD = ", eval(sd(parietal_clean$Parietal_Cortical))),
       x = 'Parietal Lobe Volume, cm^3',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

ggplot(parietal_clean, aes(x = parietal_adj_zscored)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(parietal_clean$parietal_adj_zscored), 
                            sd = sd(parietal_clean$parietal_adj_zscored)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Parietal Lobe Volume ~ Total Cranial Volume Residuals, Z-scored",
       caption = "Red is density function, blue is normal density function (using z-scored parietal lobe volume mean and SD)",
       "\nMean = ", eval(mean(parietal_clean$parietal_adj_zscored)),
       "\nSD = ", eval(sd(parietal_clean$parietal_adj_zscored)),
       x = 'Parietal Lobe Volume Residuals, Z-Scored',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

ggplot(parietal_clean, aes(x = parietal_blom_std)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(parietal_clean$parietal_blom_std), 
                            sd = sd(parietal_clean$parietal_blom_std)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Parietal Lobe Volume ~ Total Cranial Volume Residuals, Blom-standardized",
       caption = "Red is density function, blue is normal density function (using Blom-standardized parietal lobe volume mean and SD)\nMean = 0\nSD = 0.9954773",
       x = 'Parietal Lobe Residuals, Blom-standardized',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

#----**temporal lobe histograms----
ggplot(temporal_clean, aes(x = Temporal_Cortical)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(temporal_clean$Temporal_Cortical), 
                            sd = sd(temporal_clean$Temporal_Cortical)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Raw Temporal Lobe Volume",
       caption = paste0("Red is density function, blue is normal density function (using temporal lobe volume mean and SD)",
                        "\nMean = ", eval(mean(temporal_clean$Temporal_Cortical)),
                        "\nSD = ", eval(sd(temporal_clean$Temporal_Cortical))),
       x = 'Temporal Lobe Volume, cm^3',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0)) 

ggplot(temporal_clean, aes(x = temporal_adj_zscored)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(temporal_clean$temporal_adj_zscored), 
                            sd = sd(temporal_clean$temporal_adj_zscored)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Temporal Lobe Volume ~ Total Cranial Volume Residuals, Z-scored",
       caption = "Red is density function, blue is normal density function (using z-scored temporal lobe volume mean and SD)",
       "\nMean = ", eval(mean(temporal_clean$temporal_adj_zscored)),
       "\nSD = ", eval(sd(temporal_clean$temporal_adj_zscored)),
       x = 'Temporal Lobe Volume Residuals, Z-Scored',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))

ggplot(temporal_clean, aes(x = temporal_blom_std)) + 
  geom_histogram(
    aes(y = stat(density)),
    bins = 30,
    colour = "black",
    fill = "white") +
  geom_density(col = "red",
               lwd = 2) +
  stat_function(fun = dnorm,
                args = list(mean = mean(temporal_clean$temporal_blom_std), 
                            sd = sd(temporal_clean$temporal_blom_std)),
                lwd = 2,
                col = "blue") +
  theme_bw() +
  labs(title = "Temporal Lobe Volume ~ Total Cranial Volume Residuals, Blom-standardized",
       caption = "Red is density function, blue is normal density function (using Blom-standardized temporal lobe volume mean and SD)\nMean = 0\nSD = 0.9954773",
       x = 'Temporal Lobe Residuals, Blom-standardized',
       y = 'Relative Density') +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0))
