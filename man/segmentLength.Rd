% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/segmentLength.R
\name{segmentLength}
\alias{segmentLength}
\title{Compute length of road segment.}
\usage{
segmentLength(id, unit = NULL)
}
\arguments{
\item{id}{Character. A concatenation of a street's numeric ID, a whole number between 1 and 528, and a second number to identify the segment.}

\item{unit}{Character. Unit of measurement: "meter" or "yard". Default is NULL, which returns the map's native scale.}
}
\value{
An R vector of length one.
}
\description{
Compute length of road segment.
}
\examples{
segmentLength("242-1")
segmentLength("242-1", unit = "meter")
}
\seealso{
\code{\link{roads}}, code{\link{road.segments}}, \code{\link{streetNameLocator}}, \code{\link{streetNumberLocator}}, \code{vignette("road.names")}
}
