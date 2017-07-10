# hard code the US repo fro CRAN
local({
r <- getOption("repos")
r["CRAN"] <- "http://cran.rstudio.com/"
r["INLA"] <- "https://inla.r-inla-download.org/R/testing"
options(repos = r)
})

# custom prompt
options(prompt="R > ", digits=4, show.signif.start=FALSE)

# check if .Rprofile was succesfully loaded.
.First <- function() {
    cat("\nSuccessfully loaded .Rprofile at", date(), "\n")
}

# do not prompt to save workspace when quitting
utils::assignInNamespace(
  "q", function(save = "no", status = 0, runLast = TRUE) {
    .Internal(quit(save, status, runLast))
  },
  "base"
)
