% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/addIndexCase.R
\name{addIndexCase}
\alias{addIndexCase}
\title{Highlight index case at 40 Broad Street.}
\usage{
addIndexCase(cex = 2, col = "red", pch = 1, add.label = FALSE,
  text.size = 0.5, ...)
}
\arguments{
\item{cex}{Numeric. Size of point.}

\item{col}{Character. Color of point.}

\item{pch}{Numeric. Type of of point.}

\item{add.label}{Logical. Add text annotation: "40 Broad Street"}

\item{text.size}{Numeric. Sine of text label.}

\item{...}{Additional plotting parameters.}
}
\value{
Add base R point and (optionally) text to a graphics plot.
}
\description{
Highlight index case at 40 Broad Street.
}
\examples{
segmentLocator("216-1")
addIndexCase()
}
\seealso{
\code{\link{snowMap}},
\code{\link{addKernelDensity}},
\code{\link{addLandmarks}},
\code{\link{addPlaguePit}},
\code{\link{addSnow}},
\code{\link{addVoronoi}},
\code{\link{addWhitehead}}
}
