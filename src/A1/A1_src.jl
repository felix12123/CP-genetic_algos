using Measurements
using Statistics

function transform_uncertainties(file_path::AbstractString)
	# check if file exists
	if !isfile(file_path)
		error("File does not exist")
	end

	# Read CSV file into a DataFrame
	data = readdlm(file_path, ';', header=true)[1]

	# Convert uncertainties to standard deviation errors
	transformed_measurements = [data[i, 1] ± data[i, 2] / 1.96 for i in 1:size(data)[2]]
	
	return transformed_measurements
end

function internal_uncertainty(ms::Vector{Measurement{T}}) where T <: Real
	sqrt(1/sum(1 ./ Measurements.uncertainty.(ms) .^ 2))
end

function χ(ms::Vector{Measurement{T}}) where T <: Real
	mean_val = mean(ms).val
	sqrt(sum(((Measurements.value.(ms) .- mean_val) ./ Measurements.uncertainty.(ms)) .^ 2))
end

function external_uncertainty(ms::Vector{Measurement{T}}) where T <: Real
	sqrt(χ(ms)^2 / 2 * internal_uncertainty(ms)^2)
end

