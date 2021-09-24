#Task 5 - Applied Empirical Economics I
#Qinglin Ouyang
#qinglin.ouyang@sbs.su.se
#Sep 22, 2021

library(haven)
library(dplyr)
library(tidyverse)
library(AER)
library(stargazer)
library(ggplot2)
library(miceadds)
library(psych)
library(sjlabelled)
rm(list = ls())

rootdir <- "/Users/qiou3954/Library/Mobile Documents/com~apple~CloudDocs/Year 2/Applied Empirical Economics I/Qinglin_Ouyang/Task_5"
setwd(rootdir)

# Prepare for building
system('rmdir ./Build/Input')
dir.create("./Build/Input")
file.copy("./Raw/WV6_Data_R_v20201117.rdata", "./Build/Input/WV6_R.rdata")
file.copy("./Raw/WV6_Data_stata_v20201117.dta", "./Build/Input/WV6_stata.dta")
# Rename variables
dir.create("./Analysis/Input")
dir.create("./Analysis/Output")
source("./Build/Code/CleanData.R") #data clean process

# Table reproduction
source("./Analysis/Code/Table_rep.R")

# Figure V reproduction
source("./Analysis/Code/FigureV_rep.R")
print("Mission completed")
