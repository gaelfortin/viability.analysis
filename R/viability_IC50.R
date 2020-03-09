#' Calculate IC50 of conditions tested in the viability assay
#'
#' @param template Path to template file
#' @param viability_data Path to viability plate results .xlsx file
#' 
#' @import tidyverse
#' @import magrittr
#' @export
#' 


viability_IC50 <- function(template, viability_data){
  
  viability_stats <- .viability_stats(template, viability_data)
  
  IC50s <- tibble(
    condition = viability_stats %>% pull(condition) %>% unique(.))
  
  IC50s %<>%
    mutate(IC50 = as.numeric(map(.x = condition, .f = .viability_single_IC50, viability_stats)))
  
  return(IC50s)
  
  
  
  
}


.viability_single_IC50 <- function(cond, viability_stats){
  
  p <- viability_stats %>% 
    filter(condition == cond) %>% 
    ggplot(aes(x = concentration, y = relative_viability))+
      geom_point() +
      stat_smooth(method = loess, se = FALSE)
  
  fit_curve <- ggplot_build(p)$data[[2]] %>% #extract loess fit curve
    select(x,y)
  
  
  IC50 <- fit_curve[which(abs(fit_curve$y - 50) == min(abs(fit_curve$y - 50))),1] #identify closest value from 70 and the corresponding          concentration
  IC50 <- round(IC50, digits = 3)
  return(IC50)
 
}




