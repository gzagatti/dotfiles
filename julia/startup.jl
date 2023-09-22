# tweak LD_LIBRARY_PATH to avoid raising error when plotting
# if isfile("/home/linuxbrew/.linuxbrew/lib/libtiff.so.6")
#   libtiff = dirname(realpath("/home/linuxbrew/.linuxbrew/lib/libtiff.so.6"))
#   ld_library_path = get(ENV, "LD_LIBRARY_PATH", "")
#   ld_library_path = length(ld_library_path) > 0 ? ":$ld_library_path" : ""
#   ENV["LD_LIBRARY_PATH"] = "$libtiff$ld_library_path"
# end

atreplinit() do repl

    @eval import Pkg

    # pre-load some useful packages
    packages_loaded = false
    if !isnothing(Base.find_package("Revise"))
        @eval using Revise
        @info "Revise loaded."
        packages_loaded = true
    end
    if !isnothing(Base.find_package("KittyTerminalImages")) && get(ENV, "TERM", "") == "xterm-kitty"
        @eval using KittyTerminalImages
        @info "KittyTerminalImages loaded."
        # avoids display issues https://github.com/JuliaPlots/Plots.jl/issues/1905#issuecomment-458778817
        ENV["GKSwstype"]="nul";
        packages_loaded = true
    end

    if packages_loaded
      println()
    end

    # prefer magenta in the shell prompt
    repl.shell_color = Base.text_colors[5]

    # numbered prompt
    # https://docs.julialang.org/en/v1/stdlib/REPL/#Numbered-prompt
    @eval using REPL
    if isdefined(REPL, :numbered_prompt!)
      if !isdefined(repl, :interface)
        repl.interface = REPL.setup_interface(repl)
      end
      REPL.numbered_prompt!(repl)
    end

    # activate project at current path or at repo root
    if isfile("Project.toml") && isfile("Manifest.toml")
        Pkg.activate(".")
    else
        here = splitpath(abspath("."))
        for level = length(here):-1:1
            parent = here[1:level]
            if isdir(joinpath([parent; ".git"]))
                if isfile(joinpath([parent; "Project.toml"])) &&
                  isfile(joinpath([parent; "Manifest.toml"]))
                    Pkg.activate(joinpath(parent))
                    break
                end
            end
            if level == 1
                Pkg.activate(temp=true)
                Pkg.offline(true)
            end
        end
    end

    # margin between welcome message and first prompt
    println()

end

let theme = get(ENV, "THEME", "")
    if theme == "leuven"
        # colors in the REPL are sourced from Base.text_colors
        # see: https://github.com/JuliaLang/julia/blob/master/base/client.jl
        ENV["JULIA_ERROR_COLOR"] = 1
        ENV["JULIA_WARN_COLOR"] = 3

        # no point in printing light colors if you cannot see
        # the leuven way is to add a light background when printing light colors
        # to test colors use `printstyled("string", color=:light_green)`
        Base.text_colors[:light_red] = "\e[38:5:1m\e[48:5:9m"
        Base.text_colors[:light_green] = "\e[38:5:2m\e[48:5:10m"
        Base.text_colors[:light_yellow] = "\e[38:5:3m\e[48:5:11m"
        Base.text_colors[:light_blue] = "\e[38:5:4m\e[48:5:12m"
        Base.text_colors[:light_magenta] = "\e[38:5:5m\e[48:5:13m"
        Base.text_colors[:light_cyan] = "\e[38:5:6m\e[48:5:14m"

        for light_color in [
            :light_red,
            :light_green,
            :light_yellow,
            :light_blue,
            :light_magenta,
            :light_cyan,
        ]
            Base.disable_text_style[light_color] = "\e[49m" * Base.text_colors[:default]
        end

    end
end
