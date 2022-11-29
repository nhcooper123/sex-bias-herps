# Sex biases and the scarcity of sex metadata in global herpetology collections 

Author(s): [Natalie Cooper](mailto:natalie.cooper.@nhm.ac.uk)

This repository contains all the code and some data used in the [paper](XXX). 

To cite the paper: 
>  Tara Wainwright, Morwenna Trevena, Sarah R. Alewijnse, Patrick D. Campbell, Marc E.H. Jones, Jeffrey W. Streicher and Natalie Cooper. Sex biases and the scarcity of sex metadata in global herpetology collections. TBC

To cite this repo: 
>  Cooper, N., 2022. Code for the paper v1.0. GitHub: nhcooper123/sex-bias-herps. Zenodo. DOI: TBC.

![alt text](https://github.com/nhcooper123/sex-bias-herps/raw/master/manuscript/figures/class-order-density.png)

## Data
All cleaned data are available from the [NHM Data Portal](https://doi.org/10.5519/8o9v9349).
For reproducibility purposes download this and place it into a `raw-data/` or `data/` folder as appropriate to rerun our analyses. 
We were unable to upload this to GitHub because the files are too large.

* `data/` should include `all-specimen-data-2021-07.csv` , `extra-data-sexed-2022-04.csv`, `all-specimen-data-unsexed-2021-07.csv` and `extra-data-unsexed-2022-07.csv`. These are the datasets required to run the main analyses. The file `wild-sex-ratios.csv` should also be in the `data/` folder for one of the supplemental analyses.
* `raw-data/` should contain all other data. Note that we did not upload raw data that can be accessed from the original data sources due to copyright issues, but these can be downloaded from GBIF (references and links below). The raw data are only necessary if you want to repeat the data wrangling steps.

If you use the cleaned data please cite as follows: 
>  Wainwright, T., Trevena, M., Alewijnse, S.R., Campbell, P.D., Jones, M.E.H., Streicher, J.W. & Cooper, N. 2022. Sex bias and sex recording in global herpetology collections [Data set]. Natural History Museum. https://doi.org/10.5519/8o9v9349.

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
* `/manuscript` contains the manuscript materials in LaTeX format.

-------
## Session Info
For reproducibility purposes, here is the output of `devtools::session_info()` used to perform the analyses in the publication.

TBC
   
## Checkpoint for reproducibility
To rerun all the code with packages as they existed on CRAN at time of our analyses we recommend using the `checkpoint` package, and running this code prior to the analysis:

```{r}
checkpoint("2022-11-28")
```
