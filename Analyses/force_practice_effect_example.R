#******************************
#* Example code for forcing 
#* practice effects
#******************************

# To force a coefficient to a specific value, use the offset argument

# Example - running a linear mixed effects model with practice effect = -0.07,
# years since baseline as the timescale, adjusted for baseline age and phone 
# indicator. The practice effect is coded as an indicator variable (=1 if wave = 1)

m1 <- lmer(score_z ~ years_since_base + base_age_c + phone_ind2 + (1|STUDYID),
           offset = -0.07*first_assess,
           data = dat, REML = F)