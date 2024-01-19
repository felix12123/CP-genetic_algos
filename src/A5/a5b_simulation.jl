include("Elektronen/electron_struct.jl")
include("Elektronen/scattering.jl")
include("Elektronen/electron_utils.jl")


function simulate_electrons(n::Int, E::Float64, T_min::Float64)
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
	plt = plot()
	for j in 1:n
		xs = [e_positions[j][i][1] for i in 1:size(e_positions[j], 1)]
		ys = [e_positions[j][i][2] for i in 1:size(e_positions[j], 1)]
		zs = [e_positions[j][i][3] for i in 1:size(e_positions[j], 1)]
		plot!(plt, xs, ys, zs, label="")
	end
	display(plt)

end