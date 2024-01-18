using Optim
using Plots
using DelimitedFiles
using Statistics


function A4()
	println("\nA4 ============================")
	
	path = "./data/A4.csv"
	data = readdlm(path, ';', header=true)[1]
	interv = data[:, 1]
	events = data[:, 2]

	# model for fit is composed of background radiation, and 2 decay curves:
	act_mod(x, p) = p[1] .+ p[2] .* exp.(p[3] .* x) .+ p[4] .* exp.(p[5] .* x)
	
	# first guess for parameters:
	p0  = [mean(events[div(9*end, 10):end]), 650, -1.5e-1, 200, -0.035]
	p0  = convert.(Float64, p0)
	
	# lower = [0, 50, -10, 50, -1]*1.0; upper = [0.01, 1000, 0, 500, 0] * 1.0
	lower = [0, 50, -10, 50, -1]; upper = [5*p0[1], 1000, 0, 500, 0]
	loss(p) = sum(abs2, events - act_mod(interv, p))
	
	# act_mod3(x, p) = p[1] .+ p[2] .* exp.(p[3] .* x) .+ p[4] .* exp.(p[5] .* x) .+ p[6] .* exp.(p[7] .* x)
	# p03 = vcat(p0, [20, -0.035])
	# loss3(p) = sum(abs2, events - act_mod3(interv, p))
	# display(plot(interv, [events, act_mod3(interv, p03)], label=["data" "3 exp fit"], title="Guess for decay of silver isotopes", dpi=300))
	# fit3 = optimize(loss3, p03, NelderMead()) |> Optim.minimizer
	# println(fit3)
	# println(5log(2)/fit3[3])
	# println(5log(2)/fit3[5])
	# println(5log(2)/fit3[7])
	# display(plot(interv, [events, act_mod3(interv, fit3)], label=["data" "3 exp fit"], title="Guess for decay of silver isotopes", dpi=300))

	# Calculations for both methods:
	Nresult = optimize(loss, lower, upper, p0, Fminbox(NelderMead()))
	Nfitdata = act_mod(interv, Optim.minimizer(Nresult))

	Cresult = optimize(loss, lower, upper, p0, Fminbox(ConjugateGradient()))
	Cfitdata = act_mod(interv, Optim.minimizer(Cresult))

	# Display loss and time for both methods:
	println("loss NelderMead: ", Optim.minimizer(Nresult) |> loss)
	println("params NelderMead: ", Optim.minimizer(Nresult))
	println("loss Conjugate: ", Optim.minimizer(Cresult) |> loss)
	println("params Conjugate: ", Optim.minimizer(Cresult))
	plt = plot(interv, [Nfitdata, Cfitdata],
		label=["Nelder Mead" "Conjugate Gradient"],
		title="Fits for decay of silver isotopes",
		linestyle=[:solid :dash],
		dpi=300)
	scatter!(plt, interv, events, label="data", markersize=2, color=:black, alpha=0.5)
	savefig(plt, "./media/A4/A4.png")

	Nλ1 = -Optim.minimizer(Nresult)[3]/5
	Nλ2 = -Optim.minimizer(Nresult)[5]/5
	Cλ1 = -Optim.minimizer(Cresult)[3]/5
	Cλ2 = -Optim.minimizer(Cresult)[5]/5
	println("literary values:    T1/2_1 = $(2.382*60), T1/2_2 = ", 24.56)
	println("Nelder Mead:        λ1 = ", Nλ1, ", λ2 = ", Nλ2)
	println("Nelder Mead:        T1/2_1 = ", log(2)/Nλ1, ", T1/2_2 = ", log(2)/Nλ2)
	println("Conjugate Gradient: λ1 = ", Cλ1, ", λ2 = ", Cλ2)
	println("Conjugate Gradient: T1/2_1 = ", log(2)/Cλ1, ", T1/2_2 = ", log(2)/Cλ2)
end





