import Pkg
# activate project at current path or at repo root
if isfile("Project.toml") && 
  isfile("Manifest.toml")
    Pkg.activate(".")
else
  here = splitpath(abspath("."))
  for i in length(here):-1:1
    parent = here[1:i]
    if isdir(joinpath([parent; ".git"]))
      if isfile(joinpath([parent; "Project.toml"])) && 
        isfile(joinpath([parent; "Manifest.toml"]))
        Pkg.activate(joinpath(parent))
        break
      end
    end
    if i == 1 Pkg.activate() end
  end
end
