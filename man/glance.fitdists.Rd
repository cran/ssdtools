% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/glance.R
\name{glance.fitdists}
\alias{glance.fitdists}
\title{Get a tibble summarizing each distribution}
\usage{
\method{glance}{fitdists}(x, ...)
}
\arguments{
\item{x}{The object.}

\item{...}{Unused.}
}
\value{
A tidy tibble of the distributions.
}
\description{
Gets a tibble with a single row for each distribution.
}
\examples{
fits <- ssd_fit_dists(ssddata::ccme_boron)
glance(fits)
}
\seealso{
\code{\link[=ssd_gof]{ssd_gof()}}

Other generics: 
\code{\link{augment.fitdists}()},
\code{\link{tidy.fitdists}()}
}
\concept{generics}
