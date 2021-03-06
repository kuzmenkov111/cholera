% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/streetLength.R
\name{streetLength}
\alias{streetLength}
\title{Compute length of selected street.}
\usage{
streetLength(road = "Oxford Street", unit = NULL)
}
\arguments{
\item{road}{Character or Numeric. Road name or number. For names, the function tries to correct for case and to remove extra spaces.}

\item{unit}{Character. Unit of measurement: "meter" or "yard". Default is NULL, which returns the map's native scale.}
}
\value{
An R vector of length one.
}
\description{
Compute length of selected street.
}
\examples{
streetLength("Oxford Street")
streetLength("oxford street")
streetLength("oxford street", unit = "meter")
}
\seealso{
\code{\link{roads}}, code{\link{road.segments}}, \code{\link{streetNameLocator}}, \code{\link{streetNumberLocator}}, \code{vignette("road.names")}
}
