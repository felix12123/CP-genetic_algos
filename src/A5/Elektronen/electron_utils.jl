function free_path(el::Electron, a::Float64=0.0, b::Float64=100.0)
	(-log(rand()) * (b-a) + a) * el.T / 10
end

el = Electron()
histogram([free_path(el) for i in 1:10_000])