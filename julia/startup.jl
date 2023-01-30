import Pkg
# activate project at current path or at repo root
if isfile("Project.toml") &&
  isfile("Manifest.toml")
    Pkg.activate(".")
else
  here = splitpath(abspath("."))
  for level in length(here):-1:1
    parent = here[1:level]
    if isdir(joinpath([parent; ".git"]))
      if isfile(joinpath([parent; "Project.toml"])) &&
        isfile(joinpath([parent; "Manifest.toml"]))
        Pkg.activate(joinpath(parent))
        break
      end
    end
    if level == 1 Pkg.activate() end
  end
end

let theme = get(ENV, "THEME", "")
  if theme == "leuven"
    # colors are sourced from Base.text_colors
    # see: https://github.com/JuliaLang/julia/blob/master/base/client.jl
    ENV["JULIA_ERROR_COLOR"] = 1
    ENV["JULIA_WARN_COLOR"] = 3
    function leuven_colors(repl)
      repl.shell_color = Base.text_colors[5]
    end
    atreplinit(leuven_colors)
  end
end


