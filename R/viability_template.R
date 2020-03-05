#'Generate a template of the plate used for a viability assay
#'
#' Uses given maximum drug concentration and conditions to generate a dataframe 
#' which links each well to a drug concentration, a condition, and a replicate number.
#'
#'
#'
#'
#' @param drug_max Maximum drug concentration used for the assay (in M)
#' @param conditions `<vector>` Conditions used in the assay. 
#' Usually different cell lines or cells with different treatments. 
#' 4 conditions are expected. If less than 4 conditions were used, complete with `<NA>`
#' @param save_to `<string>` Path to file in which to save the template
#' @import dplyr
#' @import tibble
#' @export
#' 
viability_template <- function(drug_max, conditions, save_to){
  drug_concentrations <- drug_max*(0.5^(10:0))
  
  ID_dataframe <- tibble(
    condition = rep(conditions, each = 7*11),
    concentration = rep(drug_concentrations, 7*length(conditions)),
    replicate = rep(1:7, 11*length(conditions))
  ) %>% 
    arrange(condition, concentration, replicate)
  
  ID_dataframe %<>% 
    mutate(
      row = c(rep_len(1:7, length.out = 77*2), rep_len(8:14, length.out = 77*2)), 
      column = rep(c(rep(1:11, each = 7), rep(22:12, each = 7)), 2)
    )
  
  write_csv(ID_dataframe, path = save_to)
    
}