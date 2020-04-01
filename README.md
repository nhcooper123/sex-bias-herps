# Sex biases in herpetology natural history collections 

![alt text](XXX)

Author(s): [Natalie Cooper](mailto:natalie.cooper.@nhm.ac.uk)

This repository contains all the code and some data used in the [paper](XXX). 

To cite the paper: 
> 

To cite this repo: 
> 


## Data
All cleaned data are available from the [NHM Data Portal](XXX).
For reproducibility purposes download this and place it into a `raw-data/` or `data/` folder as appropriate to rerun our analyses. 
We were unable to upload this to GitHub because the files are too large.

* `data/` should include `all-specimen-data.csv` and `all-extra-data.csv`. These are the datasets required to run the analyses.
* `raw-data/` should contain all other data. Note that we did not upload raw data that can be accessed from the original data sources due to copyright issues, but these can be downloaded from GBIF (references and links below). The raw data are only necessary if you want to repeat the data wrangling steps.

If you use the cleaned data please cite as follows: 
> 

Please also cite the original sources of the data as follows:

Specimen data
> GBIF: The Global Biodiversity Information Facility. https://www.gbif.org/ (2020).

> AMNH: Dickey D (2016). AMNH Herpetology Collections. American Museum of Natural History. Occurrence dataset https://doi.org/10.15468/jfkgyh accessed via GBIF.org on 2020-04-01.

> FMNH: Grant S, Resetar A (2019). Field Museum of Natural History (Zoology) Amphibian and Reptile Collection. Version 12.7. Field Museum. Occurrence dataset https://doi.org/10.15468/u2pzhj accessed via GBIF.org on 2020-04-01.

> MNHN: MNHN - Museum national d'Histoire naturelle (2020). The reptiles and amphibians collection (RA) of the Muséum national d'Histoire Naturelle (MNHN - Paris). Version 55.160. Occurrence dataset https://doi.org/10.15468/whdzq3 accessed via GBIF.org on 2020-04-01.

> NMNH: Orrell T (2020). NMNH Extant Specimen Records. Version 1.30. National Museum of Natural History, Smithsonian Institution. Occurrence dataset https://doi.org/10.15468/hnhrg3 accessed via GBIF.org on 2020-04-01.

> NHMUK: Natural History Museum (2020). Natural History Museum (London) Collection Specimens. Occurrence dataset https://doi.org/10.5519/0002965 accessed via GBIF.org on 2020-04-01.

XXX mass data
> 

-------
## Data wrangling
Prior to analyses some intense data wrangling occurred. 
To get from raw specimen data to `specimen-data-all.csv` you need:

* 01A-wrangling-museum-data.R
* 01B-taxonomy-check.R
* 01C-taxonomy-corrections.R

In reality, I ran script **01A** to the taxonomy check stage, then ran script **01B** to identify specimens with taxonomy that needed to be updated.
I then created script **01C** which corrects the taxonomy. To repeat the analyses you only need script **01A** because the taxonomy corrections of **01C** are sourced from that script.

To combine body size datasets into `extra-data-all.csv` you need:

* 02A-extract-extra-data.R
* 02B-taxonomy-corrections-mass-birds.R
* 02C-taxonomy-corrections-plumage-birds.R

Similarly to the specimen data, scripts **02B** and **02C** are called from script **02A**

There is also a `03-revision-extract-genus-level-data.R` script which extracts the data at the genus-level, rather than species-level, for sensitivity analyses.

-------
## Analyses
The analysis code is divided into `.Rmd` files that run the analyses and plot the figures for each section of the paper/supplementary materials, and more detailed scripts for the figures found in the paper and called by the `.Rmd` files.

Note that throughout I've commented out `ggsave` commands so you don't clog your machine up with excess plots you don't need.

1. **01-summary-stats.Rmd** calculates summary statistics and tables.
1. **02-specimens-per-species.Rmd** investigates % female specimens for each species.
1. **03-orders.Rmd** looks at % females across orders.
1. **04-time.Rmd** looks at how % females changes through time.
1. **05-ssd.Rmd** investigates how sexual size dimorphism is related to % female specimens.
1. **06-ornaments.Rmd**	investigates how plumage colouration and ornamentation (horns, antlers, tusks, manes etc.) are related to % female specimens.
1. **07-revision-unsexed.Rmd** investigates the unsexed specimens.
2. **08-revision-apodiformes.Rmd** looks at % females across families of Apodiformes.
3. **09-revision-gaudy-females.Rmd** looks at % females across orders where the females are larger or more showy.
4. **10-revision-wild-sex-ratios.Rmd** compares sex ratios in wild birds to those in the museum collections where we have data on both.
5. **11-revision-genus-level-summary-stats.Rmd** looks at % females using the genus-level data.

### Code for figures
* **figure-bodymass.R**
* **figure-orders.R**
* **figure-plumage-ornaments.R**
* **figure-specimens-all.R**
* **figure-ssd-all.R**
* **figure-types-all.R**
* **figure-years-all.R**

### Code for tables in LaTeX format
* **make-tables.R**

-------
## Other folders

* `/figures` contains the figures
* `/img` contains the silhouettes from from `PhyloPic.org` needed for plotting. Contributed by: Ferran Sayol (parrot, hummingbird, tit), Steven Traver (woodpecker), Alexandre Vong (shorebird), Daniel Jaron (mouse), Yan Wong (bat), Becky Barnes (shrew), Lukasiniho (tiger), Sarah Werning (monkey), and Oscar Sanisidro (deer).
* `/manuscript` contains the manuscript materials in LaTeX format

-------
## Session Info
For reproducibility purposes, here is the output of `devtools::session_info()` used to perform the analyses in the publication.

   
## Checkpoint for reproducibility
To rerun all the code with packages as they existed on CRAN at time of our analyses we recommend using the `checkpoint` package, and running this code prior to the analysis:

```{r}
checkpoint("XXX")
```
