using StaticArrays

mutable struct Electron
    pos::MVector{3, Float64}
    vel::MVector{3, Float64}
    E::Float64

    function Electron(;pos::MVector{3, Float64}=MVector(0.0, 0.0, 1.0), vel::MVector{3, Float64}=MVector(0.0, 0.0, 1.0), E::Float64=20.511)
		new(pos, vel, E)
    end
end