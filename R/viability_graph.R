#'Generate viability graph
#'
#' Import the template and links each viability score in each well with precise conditions.
#' Stats are calculated from the corresponding data and used to plot the viability of each condition.
#'
#' @param template Path to template file
#' @param viability_data Path to viability plate results .xlsx file
#' 
#' @import tidyverse
#' @import magrittr
#' @export
#'
#'

viability_graph <- function(template, viability_data){

  template <- read_csv(template, col_types = cols())
  
  viability_data <- readxl::read_excel(viability_data, col_names = FALSE)
  colnames(viability_data) <- 1:22
 
  
  viability_data %<>% 
    mutate(row=row_number()) %>% 
    pivot_longer(-row, names_to = "column", values_to = "viability") %>% 
    mutate(column = as.numeric(column)) %>% 
    left_join(template, ., by = c("row","column")) %>% 
    filter(is.na(condition) == FALSE)
  
  
  viability_stats <- 
    viability_data %>% 
    group_by(condition, concentration) %>% 
    summarise(
      mean = mean(viability),
      sd = sd(viability)
    )
  
  conditions_max_mean <- viability_stats %>% #extract viability at the lowest concentration
    group_by(condition) %>% 
    slice(1) %>% #slice outputs the first value of each group after a group_by
    select(condition, "mean_0" = mean)
  
  viability_stats %<>% 
    left_join(conditions_max_mean, by = "condition") %>% 
    mutate(relative_viability = mean/mean_0*100)

  
  p <- viability_stats %>% 
    ggplot(aes(x = log(concentration), y = relative_viability, col = condition))+
    geom_point() +
    stat_smooth(method = loess, se = FALSE)
  
  return(p)
  
}






