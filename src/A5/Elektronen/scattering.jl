using PhysicalConstants, Unitful, NaturallyUnitful, Plots
using PhysicalConstants.CODATA2018
# e in natural units

e = 1.0 * ElementaryCharge |> natural |> ustrip
c = 1.0 * SpeedOfLightInVacuum |> natural |> ustrip
α = 1.0 * FineStructureConstant |> ustrip
ϵ0 = 1.0 * VacuumElectricPermittivity |> natural |> ustrip
m_e = 1.0 * ElectronMass |> natural |> ustrip

# dσdΩ_ruth(θ, Z1, Z2) = (Z1*Z2*α^2)/(4*E^2*sin(θ/2)^4)
function dσdΩ_mott(θ, E=1.0, Z1=1, Z2=20)
	γ = E / (m_e*c^2)
	β2 = 1 - 1/γ^2
	A = 2*Z1*Z2*e^2*c^4 / (4pi*ϵ0*c^4*2^4*m_e^2*γ^2*β2^2)
	A*(1 + sin(θ/2)^2)/(sin(θ/2)^4)
end


function rand_θ_mott(n::Int, E::Float64, Z1=1, Z2=20)
	γ = E / (m_e*c^2)
	β2 = 1 - 1/γ^2

	# E = sqrt(v^2 + 2*v*Z2*e^2/(4pi*ϵ0*r))
	A = 2*Z1*Z2*e^2*c^4 / (4pi*ϵ0*c^4*2^4*m_e^2*γ^2*β2^2)
	println(A)
	θ(d) = acsc((d/(A* (1-β2)))^(1//4))
	θ.(rand(n)) .* (180/pi)
end


function rand_θ_moe()
	acot(1/4 *sqrt(-6* sqrt(x) + sqrt(4* x + 12* sqrt(x) + 1) - 17))
end

# histogram(rand_θ_mott(1000, 100000.0, 100), bins=200, normalized=true, label="θ")
# vline!([0.2])
# x = 0.05:0.001:pi/10
# integ = quadgk(dσdΩ_mott, 0.001, pi)[1]
# plot!(x, dσdΩ_mott.(x, 1.0) ./ integ, label="dσdΩ_mott")
# plot(x, dσdΩ_mott.(x, 1.0) ./ integ, label="dσdΩ_mott")
function start()
	
	xs = 0.01:0.00001:0.02
	y = similar(xs)
	for i in eachindex(xs)
		x = xs[i]
		try 
			y[i] = acot(1/4 *sqrt(6* sqrt(x) - sqrt(4* x - 12* sqrt(x) + 1) - 17))
		catch
			y[i] = 0
		end
	end
	# y = [acot(1/4 *sqrt(-6* sqrt(x) + sqrt(4* x + 12* sqrt(x) + 1) - 17)) for x in Complex.(xs)]
	# plot(xs, y)
	plot(xs, (x -> (3+cos(x))^2/(sin(x)^4)).(xs))
end
start()
