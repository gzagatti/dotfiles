# hard code the US repo fro CRAN
local({
r <- getOption("repos")
r["CRAN"] <- "http://cran.rstudio.com/"
r["INLA"] <- "https://inla.r-inla-download.org/R/stable"
options(repos = r)
})

# custom prompt
options(prompt="R > ", digits=4, show.signif.start=FALSE)

# do not prompt to save workspace when quitting
utils::assignInNamespace(
  "q", function(save = "no", status = 0, runLast = TRUE) {
    .Internal(quit(save, status, runLast))
  },
  "base"
)

# only load in interactive sessions
if (interactive()) {
  suppressMessages(require(devtools))
  suppressMessages(require(usethis))
  suppressMessages(require(testthat))
}
