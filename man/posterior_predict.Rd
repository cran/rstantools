% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/posterior_predict.R
\name{posterior_predict}
\alias{posterior_predict}
\title{Generic function for drawing from the posterior predictive distribution}
\usage{
posterior_predict(object, ...)
}
\arguments{
\item{object}{The object to use.}

\item{...}{Arguments passed to methods. See the methods in the \pkg{rstanarm}
package for examples.}
}
\value{
\code{posterior_predict()} methods should return a \eqn{D} by \eqn{N}
matrix, where \eqn{D} is the number of draws from the posterior predictive
distribution and \eqn{N} is the number of data points being predicted per
draw.
}
\description{
Draw from the posterior predictive distribution of the outcome. See
\href{https://mc-stan.org/rstanarm/reference/posterior_predict.stanreg.html}{posterior_predict.stanreg()}
in the \pkg{rstanarm} package for an example.
}
\examples{
# See help("posterior_predict", package = "rstanarm")

}
\seealso{
\itemize{
\item The \pkg{rstanarm} package (\href{https://mc-stan.org/rstanarm/}{mc-stan.org/rstanarm})
for example methods
(\href{https://CRAN.R-project.org/package=rstanarm}{CRAN},
\href{https://github.com/stan-dev/rstanarm}{GitHub}).
}

\itemize{
\item Guidelines and recommendations for developers of \R packages
interfacing with Stan and a demonstration getting a simple package working
can be found in the vignettes included with \pkg{rstantools} and at
\href{https://mc-stan.org/rstantools/articles/}{mc-stan.org/rstantools/articles}.
}
}
