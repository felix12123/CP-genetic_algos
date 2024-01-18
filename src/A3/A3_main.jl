using Plots
using DelimitedFiles
include("A3_src.jl")

function A3()
	println("\nA3 ============================")

	path = "./data/A3.csv"
	data = readdlm(path, ';', header=true)[1]
	cosθ = data[:, 1]
	y = data[:, 2] .± sqrt.(data[:, 2])

	poly_fits = []
	χs = []
	poly_mod(x, p) = sum([p[i] .* x .^ (i - 1) for i in eachindex(p)])
	χ(x, y, p) = sum(((y .- poly_mod(x, p)) ./ Measurements.uncertainty.(y)) .^ 2)
	plt = scatter(cosθ, y, label="Data", markersize=3, color=:black, alpha=0.5, dpi=300, xlabel="cosθ", ylabel="y", title="Fit")

	for n in 1:size(y, 1)-1
		res = my_polynomial_fit(cosθ, Measurements.value.(y), n-1)
		push!(poly_fits, res[1])
		push!(χs, χ(cosθ, y, res[1]).val)
	end
	fitdatas = [poly_mod(cosθ, poly_fits[n]) for n in eachindex(poly_fits)]
	colors = permutedims(palette([:red, :blue, :green], length(poly_fits)) |> collect)
	plot!(plt, cosθ, fitdatas, color=colors, label="n = " .* permutedims(string.(0:length(poly_fits)-1)), linestyle=:dash, dpi=300)
	display(plt)
	minχ_ind = findmin(χs)[2]
	println("Best fit for n = ", minχ_ind - 1)
	display(plot(eachindex(poly_fits)[5:end] .- 1, χs[5:end], dpi=300, xlabel="n", ylabel="χ", title="χ for different n"))
	println("χ = ", χs[minχ_ind])
end
