using Optim
using Plots
using DelimitedFiles
using Statistics
using BenchmarkTools
using DataFrames


function A4()
	path = "./data/A4.csv"
	data = readdlm(path, ';', header=true)[1]
	interv = data[:, 1]
	events = data[:, 2]

	# model for fit is composed of background radiation, and 2 decay curves:
	act_mod(x, p) = p[1] .+ p[2] .* exp.(p[3] .* x) .+ p[4] .* exp.(p[5] .* x)

	# first guess for parameters:
	p0 = [mean(events[div(9*end, 10):end]), 650, -1.5e-1, 200, -0.035]
	p0 = convert.(Float64, p0)

	# lower = [0.1*p0[1], 50, -10, 50, -1]; upper = [5*p0[1], 1000, 0, 500, 0]
	loss(p) = sum(abs2, events - act_mod(interv, p))


	# Calculations for both methods:
	Nresult = optimize(loss, p0, NelderMead())
	Nfitdata = act_mod(interv, Optim.minimizer(Nresult))

	Cresult = optimize(loss, p0, ConjugateGradient())
	Cfitdata = act_mod(interv, Optim.minimizer(Cresult))

	# Display loss and time for both methods:
	println("loss NelderMead: ", Optim.minimizer(Nresult) |> loss)
	println("loss Conjugate: ", Optim.minimizer(Cresult) |> loss)
	
	plt = plot(interv, [Nfitdata, Cfitdata],
		label=["Nelder Mead" "Conjugate Gradient"],
		title="Fits for decay of silver isotopes",
		linestyle=[:solid :dash],
		dpi=300)
	scatter!(plt, interv, events, label="data", markersize=2, color=:black, alpha=0.5)
	savefig(plt, "./media/A4/A4.png")
end





