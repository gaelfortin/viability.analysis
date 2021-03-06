% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/viability_graph.R
\name{viability_graph}
\alias{viability_graph}
\title{Generate viability graph}
\usage{
viability_graph(template, viability_data)
}
\arguments{
\item{template}{Path to template file}

\item{viability_data}{Path to viability plate results .xlsx file}
}
\description{
Import the template and links each viability score in each well with precise conditions.
Stats are calculated from the corresponding data and used to plot the viability of each condition.
}
