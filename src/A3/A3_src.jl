function my_polynomial_fit(xs, ys, n)
	p0 = zeros(n + 1)
	poly_mod(x, p) = sum([p[i] .* x .^ (i - 1) for i in 1:length(p)])
	loss(p) = sum(abs2, Measurements.value.(ys) .- poly_mod(xs, p))
	result = optimize(loss, p0, GradientDescent())
	return Optim.minimizer(result), Optim.minimum(result)
end
