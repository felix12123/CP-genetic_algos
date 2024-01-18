using Statistics
using Plots
using DelimitedFiles
using Optim
include("A2_src.jl")



function A2()
  println("\nA2 ============================")

  data = readdlm("./data/A2.csv", ';', header=true)[1]
  Us = data[:, 1]
  Is = data[:, 2] .± data[:, 3]
  plt = scatter(Us, Is, label="Data", markersize=4, color=:black, alpha=0.5, dpi=300, xlabel="U [V]", ylabel="I [A]", title="Fit")

  println("internal uncertainty: ", internal_uncertainty(Is))

  a, b = my_lin_reg(Us, Is)
  fitdata = a .+ b .* Us .|> Measurements.value
  println("coefficients a = $a, b = $b")
  println("R = ", 1/b, "\tI_0 = ", a)
  println("χ/(N-2) = ", fit_goodnes(Us, Is, (a.val, b.val)))

  lin_mod(x, p) = p[1] .* x .+ p[2]
  p0 = [0.1, mean(Is[1:3]).val]
  res = optimize((p) -> sum(abs2, Measurements.value.(Is) .- lin_mod(Us, p)), p0, NelderMead())
  Optim_fitdata = lin_mod(Us, Optim.minimizer(res))

  plot!(plt, Us, [fitdata, Optim_fitdata], label=["Fit" "Optim fit"], color=[:red :blue], linestyle=[:dash :dot], dpi=300)
  savefig(plt, "./media/A2/A2.png")
end
