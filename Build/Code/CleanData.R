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

#add region label
Confucian <- c("China", "Taiwan", "Hong Kong", "South Korea", "Japan", "Singapore")
Europe <- c("Netherlands", "Spain", "Germany", "Poland", "Slovenia", "Sweden")
Latin_am <- c("Haiti", "Trinidad & Tobago", "Mexico", "Colombia", "Ecuador",
              "Peru", "Brazil", "Chile", "Argentina", "Uruguay")
Africa <- c("Ghana", "Nigeria", "Rwanda", "Zimbabwe", "South Africa", "Morocco",
            "Algeria", "Tunisia", "Libya", "Egypt")
Ortho <- c("Cyprus", "Romania", "Russia", "Estonia", "Ukraine", "Belarus", 
           "Armenia", "Georgia")
S_asia <- c("Azerbaijan", "Turkey", "Iraq", "Lebanon", "Jordan", "Palestine",
            "Yemen", "Kuwait", "Bahrain", "Qatar", "Kyrgyzstan", "Uzbekistan",
            "Kazakhstan", "India", "Pakistan", "Thailand", "Malaysia", "Philippines")
English <- c("United States", "Australia", "New Zealand")

country_mean <- country_mean %>% 
  mutate(region = case_when(
    cow %in% Europe ~ "Europe",
    cow %in% Confucian ~ "Confucian",
    cow %in% Ortho ~ "Orthodox",
    cow %in% S_asia ~ "South Asia",
    cow %in% Africa ~ "Africa",
    cow %in% English ~ "English Speaking",
    cow %in% Latin_am ~ "Latin America"
  ), .after = cow)
colnames(country_mean)[1] <- "country"

#normalization
n_country <- nrow(country_mean) # number of country
n_var <- ncol(country_mean)  - 2# number of useful questions
country_mean_norm <- country_mean %>% 
  mutate_if(is.numeric, scale) #normalize only columns in numeric forms


