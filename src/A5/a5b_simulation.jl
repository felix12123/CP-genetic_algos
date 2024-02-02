include("Elektronen/electron_struct.jl")
include("Elektronen/scattering.jl")
include("Elektronen/electron_utils.jl")
using Plots

function simulate_electrons(n::Int, E::Float64, T_min::Float64)
	plotlyjs()
	e_positions = []
	e_energys   = []
	for i in 1:n
		
		el = Electron(E=E)
		poss = []
		energs = []
		while kin_E(el) > T_min
			append!(poss, [copy(el.pos)])
			append!(energs, el.E)
			move_forward!(el, free_path(el))
			el_scatter!(el)
		end
		append!(poss, [el.pos])
		append!(energs, el.E)

		append!(e_energys, [energs])
		append!(e_positions, [poss])
	end
	plt = plot(xlims=(-1,1), ylims=(-1,1), zlims=(0,:auto), xlabel="x", ylabel="y", zlabel="z", size=(400, 400))
	for j in 1:n
		xs = [e_positions[j][i][1] for i in 1:size(e_positions[j], 1)]
		ys = [e_positions[j][i][2] for i in 1:size(e_positions[j], 1)]
		zs = [e_positions[j][i][3] for i in 1:size(e_positions[j], 1)]
		plot!(plt, xs, ys, zs, label="")
		# scatter!(plt, xs, ys, zs, markersize=0.5, label="")
	end
	display(plt)

	plt = plot(title="Energie", xlabel="z", ylabel="E", dpi=300)
	for i in 1:n
		zs = map(x -> x[3], e_positions[i])
		plot!(plt, zs, e_energys[i], label="")
	end
	# display(plt)
	return nothing
end