#' Generate simulated fatalities and their orthogonal projections.
#'
#' Places regularly spaced "simulated" cases across the face of the map. These cases are then orthogonally projected onto the road network, which are used to generate "expected" cases, paths and neighborhoods. The function relies on sp::spsample() and sp::Polygon().
#' @param compute Logical. TRUE computes data. FALSE uses pre-computed data. For replication of data used in the package, FALSE is the default.
#' @param multi.core Logical or Numeric. TRUE uses parallel::detectCores(). FALSE uses one, single core. With Numeric, you specify the number logical cores (rounds with as.integer()). On Windows, only "multi.core = FALSE" is available.
#' @param simulated.obs Numeric. Number of sample cases. Default is 5000.
#' @return An R list with two elements: \code{\link[cholera]{ortho.proj.sp}} and \code{\link[cholera]{regular.cases}}
#' @section Notes: This function is computationally intensive. On a 2.3 GHz Intel Core i7, it takes approximately 31 minutes on one core and approximately 7 minutes with eight logical (four physical) cores. This function documents the code that generates \code{\link[cholera]{ortho.proj.sp}} and \code{\link[cholera]{regular.cases}}.
#' @export

simulateFatalities <- function(compute = FALSE, multi.core = FALSE,
  simulated.obs = 5000L) {

  if (compute == FALSE) {
    ortho.proj.sp <- cholera::ortho.proj.sp
    regular.cases <- cholera::regular.cases
    list(ortho.proj.sp = ortho.proj.sp, regular.cases = regular.cases)
  } else {
    if (is.logical(multi.core)) {
      if (multi.core == TRUE) {
        cores <- parallel::detectCores()
      } else {
        if (is.numeric(multi.core)) {
          if (is.integer(multi.core)) {
            cores <- multi.core
          } else {
            cores <- as.integer(multi.core)
          }
        } else {
          cores <- 1L
        }
      }
    } else if (is.numeric(multi.core)) {
      if (is.integer(multi.core)) {
        cores <- multi.core
      } else {
        cores <- as.integer(multi.core)
      }
    }

    ## road segment data ##

    rd <- cholera::roads[cholera::roads$street %in% cholera::border == FALSE, ]
    map.frame <- cholera::roads[cholera::roads$street %in% cholera::border, ]
    roads.list <- split(rd[, c("x", "y")], rd$street)
    border.list <- split(map.frame[, c("x", "y")], map.frame$street)

    road.segments <- parallel::mclapply(unique(rd$street), function(i) {
      dat <- rd[rd$street == i, ]
      names(dat)[names(dat) %in% c("x", "y")] <- c("x1", "y1")
      seg.data <- dat[-1, c("x1", "y1")]
      names(seg.data) <- c("x2", "y2")
      dat <- cbind(dat[-nrow(dat), ], seg.data)
      dat$id <- paste0(dat$street, "-", seq_len(nrow(dat)))
      dat
    }, mc.cores = cores)

    road.segments <- do.call(rbind, road.segments)

    ## regularly-spaced simulated cases ##

    sp.frame <- sp::spsample(sp::Polygon(map.frame[, c("x", "y")]),
      n = simulated.obs, type = "regular")
    regular.cases <- data.frame(sp.frame@coords)
    names(regular.cases) <- c("x", "y")
    regular.cases <- split(regular.cases, rownames(regular.cases))

    orthogonal.projection <- parallel::mclapply(regular.cases, function(case) {
      within.radius <- lapply(road.segments$id, function(x) {
        dat <- road.segments[road.segments$id == x, ]
        test1 <- withinRadius(case, dat[, c("x1", "y1")])
        test2 <- withinRadius(case, dat[, c("x2", "y2")])
        if (any(test1, test2)) unique(dat$id)
      })

      within.radius <- unlist(within.radius)

      ortho.proj.test <- lapply(within.radius, function(x) {
        seg.data <- road.segments[road.segments$id == x,
          c("x1", "y1", "x2", "y2")]

        seg.df <- data.frame(x = c(seg.data$x1, seg.data$x2),
                             y = c(seg.data$y1, seg.data$y2))

        ols <- stats::lm(y ~ x, data = seg.df)
        segment.slope <- stats::coef(ols)[2]
        segment.intercept <- stats::coef(ols)[1]
        orthogonal.slope <- -1 / segment.slope
        orthogonal.intercept <- case$y - orthogonal.slope * case$x

        x.proj <- (orthogonal.intercept - segment.intercept) /
                  (segment.slope - orthogonal.slope)

        y.proj <- segment.slope * x.proj + segment.intercept

        # segment bisection/intersection test

        distB <- stats::dist(rbind(seg.df[1, ], c(x.proj, y.proj))) +
          stats::dist(rbind(seg.df[2, ], c(x.proj, y.proj)))

        bisect.test <- signif(stats::dist(seg.df)) == signif(distB)

        if (bisect.test) {
          ortho.dist <- c(stats::dist(rbind(c(case$x, case$y),
            c(x.proj, y.proj))))
          ortho.pts <- data.frame(x.proj, y.proj)
          data.frame(road.segment = x, ortho.pts, ortho.dist,
            stringsAsFactors = FALSE)
        } else {
          null.out <- data.frame(matrix(NA, ncol = 4))
          names(null.out) <- c("road.segment", "x.proj", "y.proj", "ortho.dist")
          null.out
        }
      })

      out <- do.call(rbind, ortho.proj.test)

      if (all(is.na(out)) == FALSE) {
        sel <- which.min(out$ortho.dist)
        out[sel, ]
      } else {
        out[1, ] # all candidate roads are NA so arbitrarily choose first obs.
      }
    }, mc.cores = cores)

    ortho.proj.sp <- do.call(rbind, orthogonal.projection)
    ortho.proj.sp$case <- 1:nrow(ortho.proj.sp)
    row.names(ortho.proj.sp) <- NULL

    # removes cases that don't find a road
    if (any(is.na(ortho.proj.sp))) {
      ortho.proj.sp <- stats::na.omit(ortho.proj.sp)
    }

    list(ortho.proj.sp = ortho.proj.sp,
         regular.cases = do.call(rbind, regular.cases))
  }
}

withinRadius <- function(a, b, radius = 2) {
  (a$x - b$x)^2 + (a$y - b$y)^2 <= radius^2
}