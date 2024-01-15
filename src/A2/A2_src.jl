using Measurements

function S(xs::Vector{Float64}, ys::Vector{Measurement{Float64}})::Float64
  σs = Measurements.uncertainty.(ys)
  sum(1 ./ σs .^ 2)
end

function Sx(xs::Vector{Float64}, ys::Vector{Measurement{Float64}})::Float64
  σs = Measurements.uncertainty.(ys)
  sum(xs ./ σs .^ 2)
end

function Sy(xs::Vector{Float64}, ys::Vector{Measurement{Float64}})::Float64
  σs = Measurements.uncertainty.(ys)
  sum(Measurements.value.(ys) ./ σs .^ 2)
end

function Sxx(xs::Vector{Float64}, ys::Vector{Measurement{Float64}})::Float64
  σs = Measurements.uncertainty.(ys)
  sum((xs ./ σs) .^ 2)
end

function Sxy(xs::Vector{Float64}, ys::Vector{Measurement{Float64}})::Float64
  σs = Measurements.uncertainty.(ys)
  sum(xs .* Measurements.value.(ys) ./ σs .^ 2)
end

function D(xs::Vector{Float64}, ys::Vector{Measurement{Float64}})::Float64
  S(xs, ys) * Sxx(xs, ys) - Sx(xs, ys)^2
end

function my_lin_reg(xs::Vector{Float64}, ys::Vector{Measurement{Float64}})::Tuple{Measurement{Float64}, Measurement{Float64}}
  a = (Sxx(xs, ys) * Sy(xs, ys) - Sx(xs, ys) * Sxy(xs, ys)) / D(xs, ys)
  b = (S(xs, ys) * Sxy(xs, ys) - Sx(xs, ys) * Sy(xs, ys)) / D(xs, ys)

  da = sqrt(abs(Sxx(xs, ys) / D(xs, ys)))
  db = sqrt(abs(S(xs, ys) / D(xs, ys)))
  return (a ± da, b ± db)
end

function χ2(xs, ys, ab)
  a = ab[1]
  b = ab[2]
  σs = Measurements.uncertainty.(ys)
  sum(((Measurements.value.(ys) .- (a .+ b .* xs)) ./ σs) .^ 2)
end

function fit_goodnes(xs, ys, ab)
  χ2(xs, ys, ab) / (length(xs) - 2)
end
