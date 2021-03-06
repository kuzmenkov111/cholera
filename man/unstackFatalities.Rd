% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/unstack.R
\name{unstackFatalities}
\alias{unstackFatalities}
\title{Unstack "stacks" in Snow's cholera map.}
\usage{
unstackFatalities(multi.core = FALSE, compute = FALSE,
  fatalities = cholera::fixFatalities())
}
\arguments{
\item{multi.core}{Logical or Numeric. TRUE uses parallel::detectCores(). FALSE uses one, single core. With Numeric, you specify the number logical cores. On Windows, only "multi.core = FALSE" is available.}

\item{compute}{Logical. TRUE computes data. FALSE uses pre-computed data.}

\item{fatalities}{Corrected fatalities data from cholera::fixFatalities(). For original data, use HistData::Snow.deaths.}
}
\value{
An R list that includes anchor.case, fatalities.address, fatalities.unstacked and ortho.proj.
}
\description{
Unstacks fatalities data by 1) assigning the coordinates of the base case to all cases in a stack and 2) setting the base case as an "address" and making the number of fatalities an attribute.
}
\section{Notes}{
 This function is computationally intensive. On a 2.3 GHz Intel Core i7, it takes approximately 5 minutes to run on one core and approximately 70 seconds to run on eight logical (four physical) cores. These functions document the code that generates \code{\link{anchor.case}}, \code{\link{fatalities.address}}, \code{\link{fatalities.unstacked}} and \code{\link{ortho.proj}}.
}

\seealso{
\code{vignette("unstacking.fatalities")}
}
