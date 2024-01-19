include("a5b_simulation.jl")

println("==================================== A5b ====================================")

global prefactor_mott = 0.000001
global prefactor_moe = 0.000001
global prefactor_freepath = 0.001
# el = Electron()
# println("E = ", el.E, "MeV")
# xs = [0, el.vel[1]]
# ys = [0, el.vel[2]]
# zs = [0, el.vel[3]]
# plt = plot(xs, ys, zs, label="el1", xlims=(-1,1), ylims=(-1,1), zlims=(0,1))

# for i in 1:100 el_scatter!(el); el.E = el.E*0.99 end
# xs = [0, el.vel[1]]
# ys = [0, el.vel[2]]
# zs = [0, el.vel[3]]
# plot!(xs, ys, zs, label="el2", linestyle=:dash)

# display(plt)

# println("E = ", el.E, "MeV")

simulate_electrons(10, 20.0, 5.0)