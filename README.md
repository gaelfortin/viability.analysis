# Viability analysis, the package to analyze viability experiment results
This package analyzes results of a viability assay stored in a .xlsx file. Results correspond to a 384-well plate.

## Build a viability template
A template is required to link each well of the plate to a precise set of conditions (drug treatment, knock-down, replicate...).
To do so, use the `viability_template()`function like:

```
viability_template(drug_max = 10, conditions = c('CT','sh1','sh2', 'sh3'), save_to = "template.csv")
```
__Remark:__ Up to 4 conditions can be used __AND__ 4 conditions need to be in the input.
Complete with NA if less than 4 conditions were used.


## Generate viability graph
A graph with the viability curve of each condition is produced using the results
of the assay and its corresponding template with `viability_graph()` used as followed:

```
viability_graph(template = "template.csv", viability_data = "raw_viability_data.xlsx")
```

## Calculate IC50s
IC50s of each condition can be measured and outputed in a single dataframe with `viability_IC50()`. Use it with:

```
viability_IC50(template = "template.csv", viability_data = "raw_viability_data.xlsx")
```


## Future updates will include...
- function for generating plate template
precise number of replicates and concentrations used to be more general

autocomplete conditions to 4 if less than 4 conditions are given


- wiki of plate templates (rows excluded, condition order...)

- function to output viability graph
change SD for SEM
add SEM for each dot
add choice of drug for X axis title

- function to output IC50s
