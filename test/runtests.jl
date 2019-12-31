using EmpiricalPseudopotential
using Test

const p = EmpiricalPseudopotential

@testset "EmpiricalPseudopotential.jl" begin
    # Write your own tests here.
    GaAs = p.Material("GaAs", "fcc")

    E = p.EigenEnergy(GaAs)

    p.bandstructure(E)

    p.bandgap(E)

end
