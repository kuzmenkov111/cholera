#' Add 2D kernel density contours.
#'
#' Uses KernSmooth::bkde2D().
#' @param pump.subset Character or Numeric: "pooled", "individual", or numeric vector of observed pump neighborhoods (3 through 12 or [3, 12]). The vector of pumps to select (subset) from neighborhoods defined by "pump.select". Negative selection possible.
#' @param pump.select Numeric. Vector of pumps to consider. This creates a scenario where the only pumps are those in the vector (negative selection possible).
#' @param neighborhood.type Character. "voronoi" or "walking"
#' @param bandwidth Numeric. Bandwidth for kernel density estimation.
#' @param color Character. Color of contour lines.
#' @param line.type Character. Line type for contour lines.
#' @param obs.unit Character. Unit of observation. "unstacked" uses \code{fatalities.unstacked}. "address" uses \code{fatalities.address}. "fatality" uses \code{fatalities}.
#' @param multi.core Logical or Numeric. TRUE uses parallel::detectCores(). FALSE uses one, single core. You can also specify the number logical cores. On Window, only "multi.core = FALSE" is available.
#' @param ... Additional plotting parameters.
#' @return Add contours to a graphics plot.
#' @seealso \code{\link{snowMap}},
#' \code{\link{addIndexCase}},
#' \code{\link{addLandmarks}},
#' \code{\link{addPlaguePit}},
#' \code{\link{addSnow}},
#' \code{\link{addVoronoi}},
#' \code{\link{addWhitehead}}
#' @import graphics
#' @export
#' @examples
#' # snowMap()
#' # addKernelDensity()
#'
#' # snowMap()
#' # addKernelDensity("individual")
#'
#' # snowMap()
#' # addKernelDensity(c(6, 8))
#'
#' # snowMap()
#' # addKernelDensity(pump.select = c(6, 8))

addKernelDensity <- function(pump.subset = "pooled", pump.select = NULL,
  neighborhood.type = "walking", obs.unit = "unstacked", bandwidth = 0.5,
  color = "black", line.type = "solid", multi.core = FALSE, ...) {

  if (!is.null(obs.unit) & !all(obs.unit %in%
      c("unstacked", "address", "fatality"))) {
    stop('"obs.unit" must be "unstacked", "address" or "fatality".')
  }

  if (!all(neighborhood.type %in% c("voronoi", "walking"))) {
    stop('"neighborhood.type" must either be "voronoi" or "walking".')
  }

  cores <- multiCore(multi.core)

  bw <- rep(bandwidth, 2)

  if (is.null(pump.select)) {
    if (all(is.character(pump.subset))) {
      if (pump.subset == "pooled") {
        if (obs.unit == "unstacked") {
          kde <- KernSmooth::bkde2D(cholera::fatalities.unstacked[,
            c("x", "y")], bandwidth = bw)

        } else if (obs.unit == "address") {
          kde <- KernSmooth::bkde2D(cholera::fatalities.address[, c("x", "y")],
            bandwidth = bw)

        } else if (obs.unit == "fatality") {
          kde <- KernSmooth::bkde2D(cholera::fatalities[, c("x", "y")],
            bandwidth = bw)
        }

        contour(x = kde$x1, y = kde$x2, z = kde$fhat, col = color,
          lty = line.type, add = TRUE)

      } else if (pump.subset == "individual") {
        if (neighborhood.type == "walking") {
          n.data <- cholera::neighborhoodWalking(multi.core = cores)
          cases <- cholera::pumpCase(n.data)

        } else if (neighborhood.type == "voronoi") {
          n.data <- cholera::neighborhoodVoronoi()
          cases <- cholera::pumpCase(n.data)
          empty.cell <- vapply(cases, length, numeric(1L))
          cases <- cases[empty.cell != 0]
        }

        kde <- lapply(cases, function(id) {
          sel <- cholera::fatalities.address$anchor.case %in% id
          dat <- cholera::fatalities.address[sel, c("x", "y")]
          KernSmooth::bkde2D(dat, bandwidth = bw)
        })

        invisible(lapply(names(kde), function(nm) {
          dat <- kde[[nm]]
          contour(x = dat$x1, y = dat$x2, z = dat$fhat, col = snowColors()[nm],
            lty = line.type, add = TRUE)
        }))
      }

    } else if (all(is.numeric(pump.subset))) {
      if (neighborhood.type == "walking") {
        n.data <- cholera::neighborhoodWalking(multi.core = cores)
        obs.neighborhood <- as.numeric(names(n.data$paths))

        if (any(abs(pump.subset) %in% obs.neighborhood == FALSE)) {
          stop('For walking neighborhoods, only 3 through 12 are valid.')
        }

        cases.list <- cholera::pumpCase(n.data)

        if (all(pump.subset > 0)) {
          cases <- cases.list[paste0("p", pump.subset)]
        } else if (all(pump.subset < 0)) {
          sel <- names(cases.list) %in% paste0("p", abs(pump.subset)) == FALSE
          cases <- cases.list[sel]
        }

      } else if (neighborhood.type == "voronoi") {
        n.data <- cholera::neighborhoodVoronoi()
        cases <- cholera::pumpCase(n.data)
        empty.cell <- vapply(cases, length, numeric(1L))
        cases <- cases[empty.cell != 0]
      }

      kde <- lapply(cases, function(id) {
        sel <- cholera::fatalities.address$anchor.case %in% id
        dat <- cholera::fatalities.address[sel, c("x", "y")]
        KernSmooth::bkde2D(dat, bandwidth = bw)
      })

      invisible(lapply(names(kde), function(nm) {
        dat <- kde[[nm]]
        contour(x = dat$x1, y = dat$x2, z = dat$fhat, col = snowColors()[nm],
          lty = line.type, add = TRUE)
      }))
    }

  } else {
    n.data <- cholera::neighborhoodWalking(pump.select, multi.core = cores)
    cases <- cholera::pumpCase(n.data)

    kde <- lapply(cases, function(id) {
      sel <- cholera::fatalities.address$anchor.case %in% id
      dat <- cholera::fatalities.address[sel, c("x", "y")]
      KernSmooth::bkde2D(dat, bandwidth = bw)
    })

    invisible(lapply(names(kde), function(nm) {
      dat <- kde[[nm]]
      contour(x = dat$x1, y = dat$x2, z = dat$fhat, col = snowColors()[nm],
        lty = line.type, add = TRUE)
    }))
  }
}
