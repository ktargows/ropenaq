ropenaq
=======

[![Build Status](https://travis-ci.org/ropenscilabs/ropenaq.svg?branch=master)](https://travis-ci.org/ropenscilabs/ropenaq) [![Build status](https://ci.appveyor.com/api/projects/status/nlv73gmhnhw5r1h2?svg=true)](https://ci.appveyor.com/project/ropenscilabs/ropenaq-4ryob) [![codecov.io](https://codecov.io/github/ropenscilabs/ropenaq/coverage.svg?branch=master)](https://codecov.io/github/ropenscilabs/Ropenaq?branch=master)

Installation
============

To install the package, you will need the devtools package.

``` r
library("devtools")
install_github("ropenscilabs/ropenaq")
```

If you experience trouble using the package on a Linux machine, please run

``` r
url::curl_version()$ssl_version
```

If it answers `GnuTLS`, run

``` r
apt-get install libcurl4-openssl-dev
```

And desinstall then re-install `curl`.

``` r
install.packages("curl")
```

If it still doesn't work, please open a new issue!

Introduction
============

This R package is aimed at accessing the openaq API. OpenAQ is a community of scientists, software developers, and lovers of open environmental data who are building an open, real-time database that provides programmatic and historical access to air quality data. See their website at <https://openaq.org/> and see the API documentation at <https://docs.openaq.org/>. The package contains 5 functions that correspond to the 5 different types of query offered by the openaq API: cities, countries, latest, locations and measurements. The package uses the `dplyr` package: all output tables are data.frame (dplyr "tbl\_df") objects, that can be further processed and analysed.

Finding data availability
=========================

Three functions of the package allow to get lists of available information. Measurements are obtained from *locations* that are in *cities* that are in *countries*.

The `aq_countries` function
---------------------------

The `aq_countries` function allows to see for which countries information is available within the platform. It is the easiest function because it does not have any argument. The code for each country is its ISO 3166-1 alpha-2 code.

``` r
library("ropenaq")
countriesTable <- aq_countries()
library("knitr")
kable(countriesTable$results)
```

| name           | code |  cities|  locations|    count|
|:---------------|:-----|-------:|----------:|--------:|
| Australia      | AU   |      11|         28|   454706|
| Bangladesh     | BD   |       1|          1|     1096|
| Brazil         | BR   |      71|         95|   712355|
| Canada         | CA   |      10|        153|   143115|
| Chile          | CL   |      79|         99|  1039449|
| China          | CN   |       5|          5|    22573|
| Colombia       | CO   |       1|          1|      937|
| United Kingdom | GB   |     105|        151|   566538|
| Indonesia      | ID   |       1|          2|     5756|
| India          | IN   |      25|         51|   354519|
| Mongolia       | MN   |       1|         11|   628853|
| Mexico         | MX   |       5|         47|    96013|
| Netherlands    | NL   |      63|         93|  1254722|
| Peru           | PE   |       1|         11|    54190|
| Poland         | PL   |       9|         14|   260481|
| Thailand       | TH   |      29|         57|   616939|
| United States  | US   |     653|       1627|  2145735|
| Viet Nam       | VN   |       2|          2|     4439|
| Kosovo         | XK   |       1|          1|      403|

``` r
kable(countriesTable$meta)
```

| name       | license   | website                    |  page|  limit|  found|
|:-----------|:----------|:---------------------------|-----:|------:|------:|
| openaq-api | CC BY 4.0 | <https://docs.openaq.org/> |     1|    100|     19|

``` r
kable(countriesTable$timestamp)
```

| lastModif           | queriedAt           |
|:--------------------|:--------------------|
| 2016-04-25 14:51:58 | 2016-04-25 14:58:14 |

The `aq_cities` function
------------------------

Using the `aq_cities` functions one can get all cities for which information is available within the platform. For each city, one gets the number of locations and the count of measures for the city, the URL encoded string, and the country it is in.

``` r
citiesTable <- aq_cities()
kable(head(citiesTable$results))
```

| city      | country |  locations|  count| cityURL   |
|:----------|:--------|----------:|------:|:----------|
| ABBEVILLE | US      |          1|    665| ABBEVILLE |
| Aberdeen  | GB      |          3|   7471| Aberdeen  |
| Aberdeen  | US      |          2|   1049| Aberdeen  |
| ADA       | US      |          1|   1995| ADA       |
| ADAIR     | US      |          1|   3239| ADAIR     |
| ADAMS     | US      |          2|   2675| ADAMS     |

The optional `country` argument allows to do this for a given country instead of the whole world.

``` r
citiesTableIndia <- aq_cities(country="IN")
kable(citiesTableIndia$results)
```

| city        | country |  locations|   count| cityURL     |
|:------------|:--------|----------:|-------:|:------------|
| Agra        | IN      |          1|    4414| Agra        |
| Bengaluru   | IN      |          5|   16791| Bengaluru   |
| Chandrapur  | IN      |          1|    7850| Chandrapur  |
| Chennai     | IN      |          4|    8198| Chennai     |
| Delhi       | IN      |         11|  172747| Delhi       |
| Faridabad   | IN      |          1|    8033| Faridabad   |
| Gaya        | IN      |          1|    6803| Gaya        |
| Gurgaon     | IN      |          1|    3461| Gurgaon     |
| Haldia      | IN      |          1|    7004| Haldia      |
| Hyderabad   | IN      |          3|   19181| Hyderabad   |
| Jaipur      | IN      |          1|   12907| Jaipur      |
| Jodhpur     | IN      |          1|   14903| Jodhpur     |
| Kanpur      | IN      |          1|    7112| Kanpur      |
| Kolkata     | IN      |          1|    3083| Kolkata     |
| Lucknow     | IN      |          3|     439| Lucknow     |
| Mumbai      | IN      |          3|   16452| Mumbai      |
| Muzaffarpur | IN      |          1|    9852| Muzaffarpur |
| Nagpur      | IN      |          4|    1718| Nagpur      |
| Nashik      | IN      |          1|     705| Nashik      |
| Panchkula   | IN      |          1|    8171| Panchkula   |
| Patna       | IN      |          1|    4439| Patna       |
| Pune        | IN      |          1|     125| Pune        |
| Rohtak      | IN      |          1|    2147| Rohtak      |
| Solapur     | IN      |          1|    8092| Solapur     |
| Varanasi    | IN      |          1|    9892| Varanasi    |

If one inputs a country that is not in the platform (or misspells a code), then an error message is thrown.

``` r
#aq_cities(country="PANEM")
```

The `locations` function
------------------------

The `aq_locations` function has far more arguments than the first two functions. On can filter locations in a given country, city, location, for a given parameter (valid values are "pm25", "pm10", "so2", "no2", "o3", "co" and "bc"), from a given date and/or up to a given date, for values between a minimum and a maximum. In the output table one also gets URL encoded strings for the city and the location. Below are several examples.

Here we only look for locations with PM2.5 information in India.

``` r
locationsIndia <- aq_locations(country="IN", parameter="pm25")
kable(locationsIndia$results)
```

| location                                      | city        | country | sourceName          |  count| lastUpdated         | firstUpdated        |  latitude|  longitude| pm25 | pm10  | no2   | o3    | co    | bc    | cityURL     | locationURL                                   |
|:----------------------------------------------|:------------|:--------|:--------------------|------:|:--------------------|:--------------------|---------:|----------:|:-----|:------|:------|:------|:------|:------|:------------|:----------------------------------------------|
| AAQMS Karve Road Pune                         | Pune        | IN      | CPCB                |     31| 2016-04-25 09:45:00 | 2016-03-21 08:00:00 |  18.49748|   73.81349| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Pune        | AAQMS+Karve+Road+Pune                         |
| Anand Vihar                                   | Delhi       | IN      | CPCB                |   4503| 2016-04-25 14:30:00 | 2015-06-29 14:30:00 |  28.65080|   77.31520| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | Anand+Vihar                                   |
| Ardhali Bazar                                 | Varanasi    | IN      | CPCB                |   1978| 2016-04-25 08:25:00 | 2016-03-22 00:05:00 |  25.35056|   82.97833| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Varanasi    | Ardhali+Bazar                                 |
| Central School                                | Lucknow     | IN      | CPCB                |     52| 2016-04-25 10:30:00 | 2016-03-22 10:00:00 |  26.85273|   80.99633| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Lucknow     | Central+School                                |
| Chandrapur                                    | Chandrapur  | IN      | CPCB                |   1287| 2016-04-25 14:35:00 | 2016-03-22 00:25:00 |  19.95000|   79.30000| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Chandrapur  | Chandrapur                                    |
| Collectorate - Gaya - BSPCB                   | Gaya        | IN      | CPCB                |   1609| 2016-04-25 14:35:00 | 2016-03-21 16:35:00 |  24.74897|   84.94384| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Gaya        | Collectorate+-+Gaya+-+BSPCB                   |
| Collectorate Jodhpur - RSPCB                  | Jodhpur     | IN      | CPCB                |   2467| 2016-04-25 14:45:00 | 2016-03-21 18:30:00 |  26.29206|   73.03791| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Jodhpur     | Collectorate+Jodhpur+-+RSPCB                  |
| Collectorate - Muzaffarpur - BSPCB            | Muzaffarpur | IN      | CPCB                |   1944| 2016-04-25 05:20:00 | 2016-03-19 09:20:00 |  26.07620|   85.41150| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Muzaffarpur | Collectorate+-+Muzaffarpur+-+BSPCB            |
| IGSC Planetarium Complex - Patna - BSPCB      | Patna       | IN      | CPCB                |   1089| 2016-04-25 14:40:00 | 2016-03-21 19:30:00 |  25.36360|   85.07550| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Patna       | IGSC+Planetarium+Complex+-+Patna+-+BSPCB      |
| Maharashtra Pollution Control Board Bandra    | Mumbai      | IN      | CPCB                |   1580| 2016-04-25 12:30:00 | 2016-03-21 16:15:00 |  19.04185|   72.86551| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai      | Maharashtra+Pollution+Control+Board+Bandra    |
| Maharashtra Pollution Control Board - Solapur | Solapur     | IN      | CPCB                |   1345| 2016-04-09 12:15:00 | 2016-03-21 18:30:00 |  17.65992|   75.90639| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Solapur     | Maharashtra+Pollution+Control+Board+-+Solapur |
| Mandir Marg                                   | Delhi       | IN      | CPCB                |   8547| 2016-04-25 14:00:00 | 2015-06-29 14:30:00 |  28.63410|   77.20050| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | Mandir+Marg                                   |
| Navi Mumbai Municipal Corporation Airoli      | Mumbai      | IN      | CPCB                |   1769| 2016-04-25 14:45:00 | 2016-03-21 18:30:00 |  19.14940|   72.99860| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai      | Navi+Mumbai+Municipal+Corporation+Airoli      |
| Nehru Nagar                                   | Kanpur      | IN      | CPCB                |   1411| 2016-04-25 04:55:00 | 2016-03-21 22:45:00 |  26.47031|   80.32517| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Kanpur      | Nehru+Nagar                                   |
| Punjabi Bagh                                  | Delhi       | IN      | CPCB                |   9387| 2016-04-25 14:30:00 | 2015-06-29 00:30:00 |  28.66830|   77.11670| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | Punjabi+Bagh                                  |
| R K Puram                                     | Delhi       | IN      | CPCB                |    845| 2016-04-25 14:00:00 | 2016-03-21 23:55:00 |  28.56480|   77.17440| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | R+K+Puram                                     |
| RK Puram                                      | Delhi       | IN      | RK Puram            |   8593| 2016-03-22 00:10:00 | 2015-06-29 14:30:00 |        NA|         NA| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | RK+Puram                                      |
| Sanjay Palace                                 | Agra        | IN      | CPCB                |   1467| 2016-04-23 13:05:00 | 2016-03-22 00:20:00 |  27.19866|   78.00598| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Agra        | Sanjay+Palace                                 |
| Sector 6 Panchkula - HSPCB                    | Panchkula   | IN      | CPCB                |   1674| 2016-04-25 14:45:00 | 2016-03-21 18:30:00 |  30.70578|   76.85318| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Panchkula   | Sector+6+Panchkula+-+HSPCB                    |
| US Diplomatic Post: Chennai                   | Chennai     | IN      | StateAir\_Chennai   |   3083| 2016-04-25 14:30:00 | 2015-12-11 21:30:00 |  13.05237|   80.25193| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Chennai     | US+Diplomatic+Post%3A+Chennai                 |
| US Diplomatic Post: Hyderabad                 | Hyderabad   | IN      | StateAir\_Hyderabad |   3083| 2016-04-25 14:30:00 | 2015-12-11 21:30:00 |  17.44346|   78.47489| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Hyderabad   | US+Diplomatic+Post%3A+Hyderabad               |
| US Diplomatic Post: Kolkata                   | Kolkata     | IN      | StateAir\_Kolkata   |   3083| 2016-04-25 14:30:00 | 2015-12-11 21:30:00 |  22.54714|   88.35105| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Kolkata     | US+Diplomatic+Post%3A+Kolkata                 |
| US Diplomatic Post: Mumbai                    | Mumbai      | IN      | StateAir\_Mumbai    |   3083| 2016-04-25 14:30:00 | 2015-12-11 21:30:00 |  19.06602|   72.86870| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Mumbai      | US+Diplomatic+Post%3A+Mumbai                  |
| US Diplomatic Post: New Delhi                 | Delhi       | IN      | StateAir\_NewDelhi  |   3133| 2016-04-25 14:30:00 | 2015-12-11 21:30:00 |  28.59810|   77.18907| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Delhi       | US+Diplomatic+Post%3A+New+Delhi               |
| Vikas Sadan Gurgaon - HSPCB                   | Gurgaon     | IN      | CPCB                |    673| 2016-04-25 14:45:00 | 2016-03-25 07:15:00 |  28.45013|   77.02631| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Gurgaon     | Vikas+Sadan+Gurgaon+-+HSPCB                   |
| VK Industrial Area Jaipur - RSPCB             | Jaipur      | IN      | CPCB                |   2232| 2016-04-25 14:30:00 | 2016-03-21 18:30:00 |  26.97388|   75.77388| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Jaipur      | VK+Industrial+Area+Jaipur+-+RSPCB             |
| ZooPark                                       | Hyderabad   | IN      | CPCB                |   2240| 2016-04-25 14:30:00 | 2016-03-21 18:30:00 |  17.34969|   78.45144| TRUE | FALSE | FALSE | FALSE | FALSE | FALSE | Hyderabad   | ZooPark                                       |

Getting data
============

Two functions allow to get data: `aq_measurement` and `aq_latest`. In both of them the arguments city and location needs to be given as URL encoded strings.

The `aq_measurements` function
------------------------------

The `aq_measurements` function has many arguments for getting a query specific to, say, a given parameter in a given location. Below we get the PM2.5 measures for Anand Vihar in Delhi in India.

``` r
tableResults <- aq_measurements(country="IN", city="Delhi", location="Anand+Vihar", parameter="pm25")
kable(head(tableResults$results))
```

| location    | parameter |  value| unit  | country | city  | dateUTC             | dateLocal           |  latitude|  longitude| cityURL | locationURL |
|:------------|:----------|------:|:------|:--------|:------|:--------------------|:--------------------|---------:|----------:|:--------|:------------|
| Anand Vihar | pm25      |    137| µg/m³ | IN      | Delhi | 2016-04-25 14:30:00 | 2016-04-25 14:30:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     60| µg/m³ | IN      | Delhi | 2016-04-25 14:00:00 | 2016-04-25 14:00:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     60| µg/m³ | IN      | Delhi | 2016-04-25 13:30:00 | 2016-04-25 13:30:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     47| µg/m³ | IN      | Delhi | 2016-04-25 13:00:00 | 2016-04-25 13:00:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     54| µg/m³ | IN      | Delhi | 2016-04-25 09:00:00 | 2016-04-25 09:00:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |
| Anand Vihar | pm25      |     44| µg/m³ | IN      | Delhi | 2016-04-24 11:30:00 | 2016-04-24 11:30:00 |   28.6508|    77.3152| Delhi   | Anand+Vihar |

``` r
kable(tableResults$timestamp)
```

| lastModif           | queriedAt           |
|:--------------------|:--------------------|
| 2016-04-25 14:51:58 | 2016-04-25 14:58:16 |

``` r
kable(tableResults$meta)
```

| name       | license   | website                    |  page|  limit|  found|
|:-----------|:----------|:---------------------------|-----:|------:|------:|
| openaq-api | CC BY 4.0 | <https://docs.openaq.org/> |     1|    100|   4503|

One could also get all possible parameters in the same table.

The `aq_latest` function
------------------------

This function gives a table with all newest measures for the locations that are chosen by the arguments. If all arguments are `NULL`, it gives all the newest measures for all locations.

``` r
tableLatest <- aq_latest()
kable(head(tableLatest$results))
```

| location          | city                 | country |  longitude|   latitude| parameter |    value| lastUpdated         | unit  | cityURL              | locationURL       |
|:------------------|:---------------------|:--------|----------:|----------:|:----------|--------:|:--------------------|:------|:---------------------|:------------------|
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| co        |  -25.000| 2016-04-25 14:45:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| no2       |   17.000| 2016-04-25 14:45:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| o3        |   41.000| 2016-04-25 14:45:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| pm10      |  123.000| 2016-04-25 14:45:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 100 ail           | Ulaanbaatar          | MN      |   47.93291|  106.92138| so2       |   21.000| 2016-04-25 14:45:00 | µg/m³ | Ulaanbaatar          | 100+ail           |
| 16th and Whitmore | Omaha-Council Bluffs | US      |   41.32247|  -95.93799| o3        |    0.018| 2016-04-25 13:00:00 | ppm   | Omaha-Council+Bluffs | 16th+and+Whitmore |

Below are the latest values for Anand Vihar at the time this vignette was compiled (cache=FALSE).

``` r
tableLatest <- aq_latest(country="IN", city="Delhi", location="Anand+Vihar")
kable(head(tableLatest$results))
```

| location    | city  | country | longitude |  latitude| lastUpdated         | unit  | cityURL | locationURL |
|:------------|:------|:--------|:----------|---------:|:--------------------|:------|:--------|:------------|
| Anand Vihar | Delhi | IN      | co        |    1300.0| 2016-03-21 14:45:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | no2       |     171.1| 2016-04-25 14:30:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | o3        |      23.4| 2016-04-25 14:30:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | pm10      |     556.0| 2016-04-25 14:30:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | pm25      |     137.0| 2016-04-25 14:30:00 | µg/m³ | Delhi   | Anand+Vihar |
| Anand Vihar | Delhi | IN      | so2       |      18.0| 2016-03-21 14:45:00 | µg/m³ | Delhi   | Anand+Vihar |

Meta
----

-   Please [report any issues or bugs](https://github.com/ropenscilabs/ropenaq/issues).
-   License: GPL
-   Get citation information for `ropenaq` in R doing `citation(package = 'ropenaq')`
-   Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci\_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
