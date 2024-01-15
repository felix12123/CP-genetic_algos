include("A1_src.jl")
function A1()
	println("A1 ====================================")
	# χ(transform_uncertainties("./data/A1.csv")) |> println
	
	print("internal uncertainty = ")
	println(internal_uncertainty(transform_uncertainties("./data/A1.csv")))
	
	print("external uncertainty = ")
	println(external_uncertainty(transform_uncertainties("./data/A1.csv")))	
end
