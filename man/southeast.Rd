\name{southeast}
\alias{southeast}
\docType{data}
\title{Coronavirus cases dataset in South East Asia
}
\description{Data from `coronavirus` CRAN package which contain date, country, lat, lon, type and cases. The data start from 2020-01-22 until 2020-09-25
}
\usage{data("southeast")}
\format{A data frame with 7440 observations on the following 6 variables.
  \describe{
    \item{\code{date}}{a Date vector : date of cases}
    \item{\code{country}}{a character : vector country in south east asia}
    \item{\code{lat}}{a numeric vector : latitude}
    \item{\code{long}}{a numeric vector : longitude}
    \item{\code{type}}{a character vector : type of cases consist of confirmed, death, and recovered}
    \item{\code{cases}}{a numeric vector : number of cases}
  }
}
\details{This dataset used to create the shiny app
}
\source{https://github.com/RamiKrispin/coronavirus}
\references{Rami Krispin and Jarrett Byrnes (2020). coronavirus: The 2019 Novel Coronavirus COVID-19 (2019-nCoV) Dataset. R package version 0.3.0.9000.}
\examples{
data(southeast)
## southeast$country
}
\keyword{datasets}