include("Elektronen/electron_struct.jl")
include("Elektronen/scattering.jl")
# using PlotlyJS
# import PlotlyJS: plot
println("==================================== A5b ====================================")


el = Electron()
println("E = ", el.E, "MeV")
xs = [0, el.vel[1]]
ys = [0, el.vel[2]]
zs = [0, el.vel[3]]
plt = plot(xs, ys, zs, label="el1", xlims=(-1,1), ylims=(-1,1), zlims=(0,1))

for i in 1:100 el_scatter!(el); el.E = el.E*0.99 end
xs = [0, el.vel[1]]
ys = [0, el.vel[2]]
zs = [0, el.vel[3]]
plot!(xs, ys, zs, label="el2", linestyle=:dash)

display(plt)

println("E = ", el.E, "MeV")