% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/addWhitehead.R
\name{addWhitehead}
\alias{addWhitehead}
\title{Add Rev. Henry Whitehead's Broad Street pump neighborhood.}
\usage{
addWhitehead(pump = "Broad Street", radius = 210, color = "black",
  line.type = "solid", vestry = FALSE, ...)
}
\arguments{
\item{pump}{Character. Name of selected pump (road name). See \code{pumps} or \code{pumps.vestry}.}

\item{radius}{Numeric. Distance from a pump in yards}

\item{color}{Character. Color of circle.}

\item{line.type}{Character. Circle line type.}

\item{vestry}{Logical. TRUE uses the 14 pumps and locations from Vestry report. FALSE uses original 13 pumps.}

\item{...}{Additional plotting parameters.}
}
\value{
Adds a circle (polygon) to a graphics plot.
}
\description{
A circle (polygon), centered around a desired pump with a radius of 210 yards. The Broad Street pump is the default.
}
\examples{
snowMap(add.landmarks = FALSE)
addWhitehead()
}
\seealso{
\code{\link{snowMap}},
\code{\link{addIndexCase}},
\code{\link{addKernelDensity}},
\code{\link{addLandmarks}},
\code{\link{addPlaguePit}},
\code{\link{addSnow}},
\code{\link{addVoronoi}}

\code{\link{addLandmarks}}
}
