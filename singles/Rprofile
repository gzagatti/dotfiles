# hard code the US repo from CRAN
local({
r <- getOption("repos")
r["CRAN"] <- "http://cran.rstudio.com/"
r["INLA"] <- "https://inla.r-inla-download.org/R/stable"
options(repos = r)
})

# custom prompt
options(prompt="R > ", digits=7, show.signif.start=TRUE)

# show menu in text mode
options(menu.graphics = FALSE)

# store packages in user space
if (!dir.exists("~/.local/lib/R/library")) {
  dir.create("~/.local/lib/R/library", recursive=TRUE)
}
.libPaths(c("~/.local/lib/R/library", .libPaths()))

# do not prompt to save workspace when quitting
utils::assignInNamespace(
  "q", function(save = "no", status = 0, runLast = TRUE) {
    .Internal(quit(save, status, runLast))
  },
  "base"
)
utils::assignInNamespace(
  "quit", function(save = "no", status = 0, runLast = TRUE) {
    .Internal(quit(save, status, runLast))
  },
  "base"
)

# only load in interactive sessions
if (interactive()) {
  # adjust width automatically
  wideScreen <- function(howWide=as.numeric(strsplit(system('stty size', intern=T), ' ')[[1]])[2]) {
     options(width=as.integer(howWide))
  }
  wideScreen()
  # load useful tools
  suppressMessages(requireNamespace("devtools"))
  suppressMessages(requireNamespace("usethis"))
  suppressMessages(requireNamespace("testthat"))
  suppressMessages(requireNamespace("colorout"))
  # adjust colorout
  colorout::setOutputColors(
    normal     = 12,
    negnum     = 6,
    zero       = 6,
    number     = 6,
    date       = 13,
    string     = 4,
    const      = 2,
    false      = 3,
    true       = 3,
    infinite   = 6,
    index      = 1,
    stderror   = 5,
    warn       = c(1, 8, 9),
    error      = c(1, 1, 15),
    zero.limit = NA,
    verbose=FALSE
  )
}

