using Pkg
function installed()
  deps = Pkg.dependencies()
  installs = Dict{String, VersionNumber}()
  for (uuid, dep) in deps
    dep.is_direct_dep || continue
    dep.version === nothing && continue
    installs[dep.name] = dep.version
  end
  return installs
end
# Check if packages are installed, else install them
Packages = ["Plots", "Optim", "DelimitedFiles", "Measurements", "Statistics", "CircularArrays"]
installed_Packages = keys(installed())
for Package in Packages
  if !(Package in installed_Packages)
    try
      eval(Meta.parse("using $Package"))
    catch
      println("Package $Package was not found. Installation started")
      Pkg.add(Package)
      eval(Meta.parse("using $Package"))
    end
  else
    eval(Meta.parse("using $Package"))
  end
end

dirs = ["media", "data", "media/A1", "media/A2", "media/A3", "media/A4", "media/A5"]
for dir in dirs
  if !(isdir(dir))
    mkdir(dir)
  end
end


global const plot_params = (dpi=300, fontfamily="Computer Modern", fg_legend=:transparent)
global const data_color = :black
global const fit_color  = :red
global const fit_colors = [:red :blue :green :orange :purple :cyan :magenta :yellow :black :white] |> CircularArray

include("src/A1/A1_main.jl")
include("src/A2/A2_main.jl")
include("src/A3/A3_main.jl")
include("src/A4/A4_main.jl")

println("\n========================== Project 5 ==========================\n")

A1()
A2()
A3()
A4()


nothing