using EmpiricalPseudopotential
using Test

const p = EmpiricalPseudopotential

    @testset "Bulk InSb" begin
        InSb = p.Material("InSb", "fcc")
        E = p.EigenEnergy(InSb)

        p.BandStructure(E, fielname="InSb")

        p.BandGap(E)
    end

    @testset "Strain InSb" begin
        InSb = p.Material("InSb", "fcc")
        p.strain(InSb, percent=0.5)
        E = p.EigenEnergy(InSb)

        p.BandStructure(E, fielname="InSb")

        p.BandGap(E)
    end

    @testset "GaP" begin
        GaP = p.Material("GaP", "fcc")
        E = p.EigenEnergy(GaP)

        p.BandStructure(E, fielname="GaP")

        p.BandGap(E)
    end

    @testset "GaAs" begin
        GaAs = p.Material("GaAs", "fcc")

        E = p.EigenEnergy(GaAs)

        p.BandStructure(E, fielname="GaAs")

        p.BandGap(E)
    end

    @testset "Ternary Material" begin
        InSb = p.Material("InSb", "fcc")
        GaSb = p.Material("GaSb", "fcc")

        InGaSb = p.mix("InGaSb", InSb, 0.4, GaSb, 0.6)

        E = p.EigenEnergy(InGaSb)

        p.BandStructure(E, fielname="InGaSb")

        p.BandGap(E)
    end


