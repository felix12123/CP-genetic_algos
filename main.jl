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
Packages = ["Measurements", "Plots", "Optim", "DelimitedFiles", "DataFrames", "CSV"]
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

dirs = ["media", "data", "media/A1", "media/A2", "media/A3", "media/A4"]
for dir in dirs
  if !(isdir(dir))
    mkdir(dir)
  end
end


include("src/A1/A1_main.jl")
include("src/A2/A2_main.jl")
include("src/A4/A4_main.jl")


A1()
A2()
# A4()
