library(dplyr)

raw_data <- data.frame(
  date_impression = c(
    "2024-02-01",
    "2024-02-02",
    "2024-02-02"
  ),
  category = c(
    "web",
    "sales:john",
    "sales:peter"
  )
)
cleaned_data <-
  raw_data |>
  mutate(
    days_before_today = as.integer(as.Date("2024-03-01") - as.Date(date_impression)),
    web_sale = case_when(
      category == "web" ~ 1,
      TRUE ~ 0
    )
  ) |>
  select(days_before_today, web_sale)
cleaned_data
