## What is World-Covid-Status CLI App?

World-Covid-Staus CLI App is programmed by Ruby and is to show current status of Covid-19 by country.
It is to scrape data from "https://www.worldometers.info/coronavirus/"

## Scraping HTML Using Nokogiri and Open-URI
It searches the corresponding table from the end point and scrapes table id `main_table_countries_today`

## World-Covid-Status CLI Structure
```
├── bin
│   └── world-covid-status
├── config
│   └── environment.rb
├── db
│   └── countries.db
├── lib
│   ├── world_covid_status
│   │   ├── cli.rb
│   │   ├── country_ar.rb
│   │   ├── country_raw_sql.rb
│   │   ├── scraper.rb
│   │   ├── world-covid-status
│   │   └── util.rb
│   └── world_covid_status.rb
├── Gemfile
└── README.md
```

## How to execute the CLI
Type `ruby bin/world-covid-status` on bash terminal.
There are 2 versions. In `environment.rb`, you can select AR version and non-AR version on line 7 and 8.

## Features
When the app is running, you can see 10 rows of offset, order by Population, Total cases and Active Cases.
The ranking range is between 1 to 100.
By entering Country Code(the last column), you can see more information of the country.
You can quit the app at anytime by Q/q input.

## Breif Summary of Execution Flow
`ruby bin/world-covid-status` initiates Command Line Interface, `cli.rb`.
`cli.rb` calls `scraper.rb`, which scrapes HTML and extracts data we want.
Then `scraper.rb` initializes `country.rb` that saves data into database and manipulates.

## Error Handling
In `cli.rb`, it handles exception by user's input.

## Areas to be improved
1. Even the Worldometer site does not show vaccination data and death status, it will be more useful if the app shows data that previously mentioned.
Gathering the data will be the main hurdles.
2. Selecting Versions(AR or Raw SQL) should have been adopted by Command line option.

## Other Useful Information
### Change font color in bash CLI
You can find `def font_color in util.rb`, which sets font color to yellow, red and blue.

### Check caller function
When you need to check caller method, you can compare caller name with caller[0][/`([^']*)'/, 1]

### Escape line break in long string
By putting \(back slash) in the end of line, you can escape from line break.
But you have to make sure no whitespace after \.






