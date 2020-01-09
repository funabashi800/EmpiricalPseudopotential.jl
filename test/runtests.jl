using EmpiricalPseudopotential
using Test

const p = EmpiricalPseudopotential

@testset "Bulk InSb" begin
    InSb = p.Material("InSb", "fcc")
    band = p.EigenEnergy(InSb, 500)

    p.BandPlot(band, title="InSb")

    gap = p.BandGap(band)
    mass = p.EffectiveMass(band, 200, 300)
end

@testset "Strain InSb" begin
    InSb = p.Material("InSb", "fcc")
    p.strain(InSb, percent=0.5)
    band = p.EigenEnergy(InSb, 500)

    p.BandPlot(band, title="Strained InSb")

    gap = p.BandGap(band)
    mass = p.EffectiveMass(band, 200, 300)
end

@testset "GaP" begin
    GaP = p.Material("GaP", "fcc")
    band = p.EigenEnergy(GaP, 500)

    p.BandPlot(band, title="GaP")

    gap = p.BandGap(band)
    mass = p.EffectiveMass(band, 200, 300)
end

@testset "GaAs" begin
    GaAs = p.Material("GaAs", "fcc")

    band = p.EigenEnergy(GaAs, 500)

    p.BandPlot(band, title="GaAs")

    gap = p.BandGap(band)
    mass = p.EffectiveMass(band, 200, 300)
end

@testset "Strain Ratio" begin
    InSb = p.Material("InSb", "fcc")
    emassies = Array{Float64, 1}()
    ratio = Array{Float64, 1}()
    for rate in -3.0:0.5:3.0
        p.strain(InSb, percent=rate)
        band = p.EigenEnergy(InSb, 500)
        gap = p.BandGap(band)
        push!(emassies, p.EffectiveMass(band, 200, 300))
        push!(ratio, rate)
    end
    p.Plot(ratio, emassies)
end

@testset "Ternary Material" begin
    InSb = p.Material("InSb", "fcc")
    GaSb = p.Material("GaSb", "fcc")

    InGaSb = p.mix("InGaSb", InSb, 0.4, GaSb, 0.6)

    band = p.EigenEnergy(InGaSb, 500)

    p.BandPlot(band, title="InGaSb")

    gap = p.BandGap(band)
    mass = p.EffectiveMass(band, 200, 300)
end


