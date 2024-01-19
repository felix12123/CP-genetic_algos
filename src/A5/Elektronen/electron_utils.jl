using PhysicalConstants, Unitful, NaturallyUnitful, Plots, Rotations
using PhysicalConstants.CODATA2018
# e in natural units

e = 1.0 * ElementaryCharge |> natural |> ustrip
c = 1.0 * SpeedOfLightInVacuum |> natural |> ustrip
α = 1.0 * FineStructureConstant |> ustrip
ϵ0 = 1.0 * VacuumElectricPermittivity |> natural |> ustrip
m_e = uconvert(u"MeV", 1.0 * ElectronMass |> natural) |> ustrip

function free_path(el::Electron, a::Float64=100.0)
	-log(rand()) * a * el.E * prefactor_freepath
end

function kin_E(el::Electron)
	el.E - m_e
end



function move_forward!(el, d)
	el.pos .+= el.vel .* d
	el.E = (1 - 0.1*d) * kin_E(el) + m_e
end
	
function CSDA(el::Electron, x::Float64)
	
end