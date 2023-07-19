# Sex biases and the scarcity of sex metadata in global herpetology collections 

Author(s): [Natalie Cooper](mailto:natalie.cooper.@nhm.ac.uk)

This repository contains all the code and some data used in the [paper](XXX). 

To cite the paper: 
>  Tara Wainwright, Morwenna Trevena, Sarah R. Alewijnse, Patrick D. Campbell, Marc E.H. Jones, Jeffrey W. Streicher and Natalie Cooper. Sex biases and the scarcity of sex metadata in global herpetology collections. Biological Journal of the Linnean Society. In press.

To cite this repo: 
>  Cooper, N., 2022. Code for the paper v1.0. GitHub: nhcooper123/sex-bias-herps. Zenodo. DOI: TBC.

![alt text](https://github.com/nhcooper123/sex-bias-herps/raw/master/figures/class-order-density.png)

## Data
All cleaned data are available from the [NHM Data Portal](https://doi.org/10.5519/8o9v9349).
For reproducibility purposes download this and place it into a `raw-data/` or `data/` folder as appropriate to rerun our analyses. 
We were unable to upload this to GitHub because the files are too large.

* `data/` should include `all-specimen-data-2021-07.csv` , `extra-data-sexed-2022-04.csv`, `all-specimen-data-unsexed-2021-07.csv` and `extra-data-unsexed-2022-07.csv`. These are the datasets required to run the main analyses. The file `wild-sex-ratios.csv` should also be in the `data/` folder for one of the supplemental analyses.
* `raw-data/` should contain all other data. Note that we did not upload raw data that can be accessed from the original data sources due to copyright issues, but these can be downloaded from GBIF (references and links below). The raw data are only necessary if you want to repeat the data wrangling steps.

If you use the cleaned data please cite as follows: 
>  Wainwright, T., Trevena, M., Alewijnse, S.R., Campbell, P.D., Jones, M.E.H., Streicher, J.W. & Cooper, N. 2022. Sex biases and the scarcity of sex metadata in global herpetology collections [Data set]. Natural History Museum. https://doi.org/10.5519/8o9v9349.

Please also cite the original sources of the raw specimen data as follows:

> GBIF, GBIF Occurrence Download https://doi.org/10.15468/dl.vnu6bk. Accessed 21st April 2021.  (2021).

> GBIF, GBIF Occurrence Download https://doi.org/10.15468/dl.ub7yfv. Accessed 21st April 2021.  (2021).
 
-------
## Data wrangling
Prior to analyses some intense data wrangling occurred. 
To get from raw specimen data to `all-specimen-data-2021-07.csv` and  `all-specimen-data-unsexed-2021-07.csv` you need:

* 01A-wrangling-museum-data-all.R
* 01B-taxonomy-check.R

In reality, I ran script **01A** to the taxonomy check stage (creating `halfwaydone.csv` found in the `raw-data/` folder), then ran script **01B** to identify specimens with taxonomy that needed to be updated, then went back to **01A** to complete the wrangling.

To combine body size datasets into  `extra-data-sexed-2022-04.csv` and `extra-data-unsexed-2022-07.csv` you need:

* 02-extract-extra-data.R

-------
## Analyses
The analysis code is divided into `.Rmd` files that run the analyses and plot the figures for each section of the paper/supplementary materials, and more detailed scripts for the figures found in the paper and called by the `.Rmd` files.

Note that throughout I've commented out `ggsave` commands so you don't clog your machine up with excess plots you don't need.

1. **01-summary-stats.Rmd** calculates summary statistics and tables.
1. **02-specimens-per-species.Rmd** investigates % female specimens, and % sexed specimens for each species.
1. **03-orders.Rmd** looks at % female specimens across orders.
1. **03A-orders-unsexed.Rmd** looks at % sexed specimens across orders.
1. **04-time.Rmd** looks at how % females specimens changes through time.
1. **04A-time-unsexed.Rmd** looks at how % sexed specimens changes through time.
1. **05-ssd.Rmd** investigates how sexual size dimorphism is related to % female specimens.
1. **05A-ssd-unsexed.Rmd** investigates how sexual size dimorphism is related to % sexed specimens.
1. **06-wild-sex-ratios.Rmd** compares sex ratios in wild amphibians and reptiles to those in the museum collections where we have data on both.

### Code for figures
* **figure-data-coverage.R**
* **figure-specimens-all.R**
* **figure-class-orders.R**
* **figure-unsexed-class-orders.R**
* **figure-families.R**
* **figure-types-all.R**
* **figure-ssd.R**
* **figure-years-all.R**
* **figure-wild-sex-ratios.R**

### Code for tables in LaTeX format
* **table-worst-best-taxa.R**
* **table-orders.R**
* **table-sexed-orders.R**
* **make-tables-supplementary.R**
                          
-------
## Other folders

* `/figures` contains the figures.
* `/outputs` contains the tables.
* `/img` contains the silhouettes from from `PhyloPic.org` needed for plotting. Contributed by: Steven Traver (frog), C. Camilo Julián-Caballero (salamander), B Kimmel (crocodile), Ghedo and T. Michael Keesey (lizard), and James R. Spotila and Ray Chatterji (turtle).
* `/manuscript` contains the manuscript materials.

-------
## Session Info
For reproducibility purposes, here is the output of `devtools::session_info()` used to perform the analyses in the publication.

    ─ Session info ────────────────────────────────────────────────────────────────────
     setting  value
     version  R version 4.2.0 (2022-04-22)
     os       macOS Big Sur 11.4
     system   x86_64, darwin17.0
     ui       RStudio
     language (EN)
     collate  en_US.UTF-8
     ctype    en_US.UTF-8
     tz       Europe/Dublin
     date     2023-07-19
     rstudio  2023.06.1+524 Mountain Hydrangea (desktop)
     pandoc   3.1.1 @ /Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/ (via rmarkdown)
    
    ─ Packages ────────────────────────────────────────────────────────────────────────
    package     * version date (UTC) lib source
    abind         1.4-5   2016-07-21 [1] CRAN (R 4.2.0)
    backports     1.4.1   2021-12-13 [1] CRAN (R 4.2.0)
    bit           4.0.5   2022-11-15 [1] CRAN (R 4.2.0)
    bit64         4.0.5   2020-08-30 [1] CRAN (R 4.2.0)
    broom       * 1.0.3   2023-01-25 [1] CRAN (R 4.2.0)
    cachem        1.0.6   2021-08-19 [1] CRAN (R 4.2.0)
    callr         3.7.3   2022-11-02 [1] CRAN (R 4.2.0)
    car         * 3.1-0   2022-06-15 [1] CRAN (R 4.2.0)
    carData     * 3.0-5   2022-01-06 [1] CRAN (R 4.2.0)
    cli           3.6.1   2023-03-23 [1] CRAN (R 4.2.0)
    colorspace    2.1-0   2023-01-23 [1] CRAN (R 4.2.0)
    crayon        1.5.2   2022-09-29 [1] CRAN (R 4.2.0)
    crul          1.2.0   2021-11-22 [1] CRAN (R 4.2.0)
    curl          5.0.0   2023-01-12 [1] CRAN (R 4.2.0)
    DBI           1.1.3   2022-06-18 [1] CRAN (R 4.2.0)
    devtools      2.4.5   2022-10-11 [1] CRAN (R 4.2.0)
    digest        0.6.31  2022-12-11 [1] CRAN (R 4.2.0)
 dplyr       * 1.1.0   2023-01-29 [1] CRAN (R 4.2.0)
 ellipsis      0.3.2   2021-04-29 [1] CRAN (R 4.2.0)
 evaluate      0.20    2023-01-17 [1] CRAN (R 4.2.0)
 fansi         1.0.4   2023-01-22 [1] CRAN (R 4.2.0)
 farver        2.1.1   2022-07-06 [1] CRAN (R 4.2.0)
 fastmap       1.1.0   2021-01-25 [1] CRAN (R 4.2.0)
 forcats     * 1.0.0   2023-01-29 [1] CRAN (R 4.2.0)
 fs            1.6.1   2023-02-06 [1] CRAN (R 4.2.0)
 generics      0.1.3   2022-07-05 [1] CRAN (R 4.2.0)
 ggfortify   * 0.4.14  2022-01-03 [1] CRAN (R 4.2.0)
 ggplot2     * 3.4.2   2023-04-03 [1] CRAN (R 4.2.0)
 glue          1.6.2   2022-02-24 [1] CRAN (R 4.2.0)
 gridBase      0.4-7   2014-02-24 [1] CRAN (R 4.2.0)
 gridExtra     2.3     2017-09-09 [1] CRAN (R 4.2.0)
 gtable        0.3.3   2023-03-21 [1] CRAN (R 4.2.0)
 here        * 1.0.1   2020-12-13 [1] CRAN (R 4.2.0)
 hms           1.1.2   2022-08-19 [1] CRAN (R 4.2.0)
 htmltools     0.5.4   2022-12-07 [1] CRAN (R 4.2.0)
 htmlwidgets   1.5.4   2021-09-08 [1] CRAN (R 4.2.0)
 httpcode      0.3.0   2020-04-10 [1] CRAN (R 4.2.0)
 httpuv        1.6.6   2022-09-08 [1] CRAN (R 4.2.0)
 jsonlite      1.8.4   2022-12-06 [1] CRAN (R 4.2.0)
 knitr       * 1.42    2023-01-25 [1] CRAN (R 4.2.0)
 labeling      0.4.2   2020-10-20 [1] CRAN (R 4.2.0)
 later         1.3.0   2021-08-18 [1] CRAN (R 4.2.0)
 lattice       0.20-45 2021-09-22 [1] CRAN (R 4.2.0)
 lifecycle     1.0.3   2022-10-07 [1] CRAN (R 4.2.0)
 lubridate   * 1.9.2   2023-02-10 [1] CRAN (R 4.2.0)
 magrittr      2.0.3   2022-03-30 [1] CRAN (R 4.2.0)
 Matrix        1.4-1   2022-03-23 [1] CRAN (R 4.2.0)
 memoise       2.0.1   2021-11-26 [1] CRAN (R 4.2.0)
 mgcv          1.8-40  2022-03-29 [1] CRAN (R 4.2.0)
 mime          0.12    2021-09-28 [1] CRAN (R 4.2.0)
 miniUI        0.1.1.1 2018-05-18 [1] CRAN (R 4.2.0)
 munsell       0.5.0   2018-06-12 [1] CRAN (R 4.2.0)
 nlme          3.1-157 2022-03-25 [1] CRAN (R 4.2.0)
 patchwork   * 1.1.2   2022-08-19 [1] CRAN (R 4.2.0)
 pillar        1.9.0   2023-03-22 [1] CRAN (R 4.2.0)
 pkgbuild      1.4.0   2022-11-27 [1] CRAN (R 4.2.0)
 pkgconfig     2.0.3   2019-09-22 [1] CRAN (R 4.2.0)
 pkgload       1.3.2   2022-11-16 [1] CRAN (R 4.2.0)
 png         * 0.1-8   2022-11-29 [1] CRAN (R 4.2.0)
 prettyunits   1.1.1   2020-01-24 [1] CRAN (R 4.2.0)
 processx      3.8.0   2022-10-26 [1] CRAN (R 4.2.0)
 profvis       0.3.7   2020-11-02 [1] CRAN (R 4.2.0)
 promises      1.2.0.1 2021-02-11 [1] CRAN (R 4.2.0)
 ps            1.7.2   2022-10-26 [1] CRAN (R 4.2.0)
 purrr       * 1.0.1   2023-01-10 [1] CRAN (R 4.2.0)
 R6            2.5.1   2021-08-19 [1] CRAN (R 4.2.0)
 ragg          1.2.5   2023-01-12 [1] CRAN (R 4.2.0)
 Rcpp          1.0.10  2023-01-22 [1] CRAN (R 4.2.0)
 readr       * 2.1.4   2023-02-10 [1] CRAN (R 4.2.0)
 remotes       2.4.2   2021-11-30 [1] CRAN (R 4.2.0)
 rlang         1.1.1   2023-04-28 [1] CRAN (R 4.2.0)
 rmarkdown     2.20    2023-01-19 [1] CRAN (R 4.2.0)
 rphylopic   * 0.3.0   2020-06-04 [1] CRAN (R 4.2.0)
 rprojroot     2.0.3   2022-04-02 [1] CRAN (R 4.2.0)
 rstudioapi    0.14    2022-08-22 [1] CRAN (R 4.2.0)
 scales        1.2.1   2022-08-20 [1] CRAN (R 4.2.0)
 sessioninfo   1.2.2   2021-12-06 [1] CRAN (R 4.2.0)
 shiny         1.7.3   2022-10-25 [1] CRAN (R 4.2.0)
 stringi       1.7.12  2023-01-11 [1] CRAN (R 4.2.0)
 stringr     * 1.5.0   2022-12-02 [1] CRAN (R 4.2.0)
 systemfonts   1.0.4   2022-02-11 [1] CRAN (R 4.2.0)
 textshaping   0.3.6   2021-10-13 [1] CRAN (R 4.2.0)
 tibble      * 3.2.1   2023-03-20 [1] CRAN (R 4.2.0)
 tidyr       * 1.3.0   2023-01-24 [1] CRAN (R 4.2.0)
 tidyselect    1.2.0   2022-10-10 [1] CRAN (R 4.2.0)
 tidyverse   * 2.0.0   2023-02-22 [1] CRAN (R 4.2.0)
 timechange    0.2.0   2023-01-11 [1] CRAN (R 4.2.0)
 tzdb          0.3.0   2022-03-28 [1] CRAN (R 4.2.0)
 urlchecker    1.0.1   2021-11-30 [1] CRAN (R 4.2.0)
 usethis       2.1.6   2022-05-25 [1] CRAN (R 4.2.0)
 utf8          1.2.3   2023-01-31 [1] CRAN (R 4.2.0)
 vctrs         0.6.3   2023-06-14 [1] CRAN (R 4.2.0)
 viridis     * 0.6.2   2021-10-13 [1] CRAN (R 4.2.0)
 viridisLite * 0.4.2   2023-05-02 [1] CRAN (R 4.2.0)
 vroom         1.6.1   2023-01-22 [1] CRAN (R 4.2.0)
 withr         2.5.0   2022-03-03 [1] CRAN (R 4.2.0)
 xfun          0.37    2023-01-31 [1] CRAN (R 4.2.0)
 xtable      * 1.8-4   2019-04-21 [1] CRAN (R 4.2.0)
 yaml          2.3.7   2023-01-23 [1] CRAN (R 4.2.0)

 [1] /Library/Frameworks/R.framework/Versions/4.2/Resources/library
   
## Checkpoint for reproducibility
To rerun all the code with packages as they existed on CRAN at time of our analyses we recommend using the `checkpoint` package, and running this code prior to the analysis:

```{r}
checkpoint("2023-07-19")
```
