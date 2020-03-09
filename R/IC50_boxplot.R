#' Compute the IC50 of each replicate of each condition and outputs a boxplot graph for each condition
#'
#' @param template Path to template file
#' @param viability_data Path to viability plate results .xlsx file
#' 
#' @import tidyverse
#' @import magrittr
#' @export
#' 
#' 

IC50_boxplot <- function(template, viability_data){
  relative_viability <- viability_data %>% 
    group_by(condition, row) %>% 
    mutate(relative_row_viability = (viability/viability[1]*100))
  
  IC50_table <- viability_data %>% 
    select(condition, row) %>% 
    distinct() %>%  
    ungroup() %>% 
    mutate(row_IC50 = as.numeric(map2_chr(.x = condition, .y = row, .f = viability_row_IC50, relative_viability)))
  
  IC50_table %>% 
    mutate(condition = as.factor(condition)) %>% 
    ggplot(aes(x = condition, y = row_IC50)) + 
    geom_boxplot() +
    stat_compare_means(method = "kruskal.test", label.x = 0.7)
  
  
}

.viability_row_IC50 <- function(cond, r, viability_data){
  p <- viability_data %>%  
    filter(condition == cond & row == r) %>% 
    ggplot(aes(x = concentration, y = relative_row_viability))+
    geom_point() +
    stat_smooth(method = loess, se = FALSE)
  tryCatch({ #tryCatch used to deal with NA values that prevent from getting any fitting curve
    fit_curve <- ggplot_build(p)$data[[2]] %>% #extract loess fit curve
      select(x,y)
    
    
    IC50 <- fit_curve[which(abs(fit_curve$y - 50) == min(abs(fit_curve$y - 50))),1] #identify closest value from 50 and the corresponding          concentration
    IC50 <- round(IC50, digits = 3)
  }, error = function(c){IC50 <- NA})
  
  return(IC50)
}
