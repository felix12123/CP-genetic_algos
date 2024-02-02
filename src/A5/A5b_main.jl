include("a5b_simulation.jl")

prefactor_moe  = 5.0
prefactor_mott = 5.0
prefactor_freepath = 0.0001
prefactor_CSDA = 8.0
prefactor_moe_energy_change = 2.5


function A5b()
	println("==================================== A5b ====================================")
	
	
	
	
	simulate_electrons(50, 20.0, 2.0)
end
