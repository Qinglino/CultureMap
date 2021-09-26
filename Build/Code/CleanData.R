input <- read_dta('./Build/Input/WV6_stata.dta', encoding = "latin1")
df <- input[, "cow"] # use country code to initialize df

# Selecting proper questions
key_words <- c("Very", "Strongly", "Completely", "Extremely", "very", 
               "essential", "Never", "often") %>% 
  paste(collapse = "|") # use key words to identify target questions

N_var <- ncol(input)
for (i in 1:N_var) {
  # Idea: if any question's choice text includes any of the key words, it 
  # is an one-dimensional ordered value for measuring values 
  ans <- paste(get_labels(input[, i]), collapse = "")
  if (grepl(key_words, ans)) {
    df <- cbind(df, input[, i])
  }
}

# generating country mean
country_mean <- df %>% 
  replace(which(df < 0), NA) %>% #turn missing value into NA
  group_by(cow) %>% 
  summarise(across(everything(), ~mean(., na.rm = TRUE))) %>% 
  select_if(~ !any(is.na(.))) %>% 
  mutate(cow = countrycode(cow, origin = "cown", destination = "country.name"))
country_mean[41, 1] <- "Palestine"
country_mean[50, 1] <- "Hong Kong" # add missing country names manually

n_country <- nrow(country_mean) # number of country
n_var <- ncol(country_mean)  - 1# number of useful questions
country_mean_norm <- country_mean %>% 
  mutate_if(is.numeric, scale) #normalize only columns in numeric forms

