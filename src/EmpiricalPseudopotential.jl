module EmpiricalPseudopotential

include("Database.jl")
using .Database
const db = Database

# Constant value
const HBAR = 1.054571800e-34
const M = 9.10938356e-31
const Q = 1.60217662e-19

using DataStructures: DefaultDict
using LinearAlgebra
using PlotlyJS
using ORCA

const specialpaths = Dict(
    "sc" => "GXMGRX",
    "fcc" => "GXWKGLUWLK",
    "bcc" => "GHNGPH",
)

const specialpoints = Dict(
    "sc" => Dict(
        "G" => [0 0 0],
        "M" => [1/2 1/2 0],
        "R" => [1/2 1/2 1/2],
        "X" => [0 1/2 0],
    ),
    "fcc" => Dict(
        "G" => [0 0 0],
        "K" => [3/8 3/8 3/4],
        "L" => [1/2 1/2 1/2],
        "U" => [5/8 1/4 5/8],
        "W" => [1/2 1/4 3/4],
        "X" => [1/2 0 1/2],
    ),
    "bcc" => Dict(
        "G" => [0 0 0],
        "H" => [1/2 -1/2 1/2],
        "P" => [1/4 1/4 1/4],
        "N" => [0 0 1/2],
    ),
)

struct Magnitude
    m1::Int
    m2::Int
    m3::Int
    function Magnitude(i, j, t)
        new(i, j, t)
    end
end

const magnitude = [ Magnitude(i, j, t) for i in -3:3 for j in -3:3 for t in -3:3 ]

# Crystal Lattice Structure
struct BasicLatticeVector
    b1::Matrix{Float64}
    b2::Matrix{Float64}
    b3::Matrix{Float64}
    function BasicLatticeVector(latticetype="fcc")
        if latticetype == "fcc"
            return new(
                [-1 1 1],
                [1 -1 1],
                [1 1 -1]
            )
        elseif latticetype == "bcc"
            return new(
                [0 1 1],
                [1 0 1],
                [1 1 0]
            )
        elseif latticetype == "sc"
            return new(
                [1 0 0],
                [0 1 0],
                [0 0 1]
            )
        else
            println("Invalid crystalstructure")
            exit()
        end
    end
end

const latticetypes = ["fcc", "bcc", "sc"]

# Reciprocal lattice vector
struct Gm
    magnitude::Int
    vector::Matrix{Float64}
    function Gm(b::BasicLatticeVector, m::Magnitude)
        gm = b.b1 * m.m1 + b.b2 * m.m2 + b.b3 * m.m3
        n = gm[1]^2 + gm[2]^2 + gm[3]^2
        new(n, gm)
    end
end

mutable struct Strain
    vertical::Float64
    parallel::Float64
end

mutable struct Material
    name::String
    Fs::Dict{Int, Float64}
    Fa::Dict{Int, Float64}
    elasticconstant::Dict{String, Float64}
    latticetype::String
    latticeconstant::Float64
    strainedlatticeconstant::Strain
    vector::BasicLatticeVector
    reciprocalvector::DefaultDict{Int, Vector{Matrix{Int}}}
    function Material(name, latticetype)
        if !(latticetype in latticetypes)
            println("Lattice Type is invalid")
        elseif !(name in keys(db.Material))
            println("Invalid material name")
        end
        obj = new(
            name,
            db.Material[name]["pseudopotential"]["Fs"],
            db.Material[name]["pseudopotential"]["Fa"],
            db.Material[name]["elasticconstant"],
            latticetype,
            db.Material[name]["latticeconstant"],
            Strain(
                db.Material[name]["latticeconstant"],
                db.Material[name]["latticeconstant"]
            ),
            BasicLatticeVector(latticetype),
            DefaultDict{Int, Vector{Matrix{Int}}}(Vector{Matrix{Int}})
        )
        reciprocalvector(obj)
        return obj
    end
end

function mix(name::String, material1::Material, alloy1::Float64,  material2::Material, alloy2::Float64)::Material
    if material1.latticetype !== material2.latticetype
        println("Crystal Lattice type is unmutched between given tow materials")
        exit()
    end
    if alloy1 + alloy2 !== 1.0
        println("Total alloy composition should be 1.0")
        exit()
    end
    material = Material(material1.name, material1.latticetype)
    material.latticeconstant = material1.latticeconstant * alloy1 + material2.latticeconstant * alloy2
    material.strainedlatticeconstant.parallel = material.latticeconstant
    material.strainedlatticeconstant.vertical = material.latticeconstant
    for k in keys(material.Fs)
        material.Fs[k] = material1.Fs[k] * alloy1 + material2.Fs[k] * alloy2
        material.Fa[k] = material1.Fa[k] * alloy1 + material2.Fs[k] * alloy2
    end
    for k in keys(material.elasticconstant)
        material.elasticconstant[k] = material1.elasticconstant[k] * alloy1 + material2.elasticconstant[k] * alloy2
    end
    return material
end

function strain(material::Material, by::Float64=material.latticeconstant; percent=1000)
    if percent !== 1000
        if 100.0 < abs(percent)
            println("Strain rate should be in range of -100 ~ 100")
            exit()
        end
        material.strainedlatticeconstant.parallel = material.latticeconstant * (100 + percent)/100
    else
        material.strainedlatticeconstant.parallel = by
    end

    material.strainedlatticeconstant.vertical =
        material.latticeconstant * (
            1 - 2 * ( material.elasticconstant["C12"]/material.elasticconstant["C11"] * 
            (material.strainedlatticeconstant.parallel - material.latticeconstant) / material.latticeconstant
            )
        )
end

# Reciprocal lattice vector
function reciprocalvector(material::Material)
    for m in magnitude
        gm = Gm(material.vector, m)
        if gm.magnitude <= 11
            push!(material.reciprocalvector[gm.magnitude], gm.vector)
        end
    end
end

# tau
function tau(material::Material)::Matrix{Float64}
    return material.latticeconstant * [1/8 1/8 1/8]
end

# Ss(Km-Kn)
function Ss(Km::Matrix{Int}, Kn::Matrix{Int}, material::Material)
    return cos((Km - Kn) * tau(material)' * 2pi/material.latticeconstant)
end

# Sa(Km-Kn)
function Sa(Km::Matrix{Int}, Kn::Matrix{Int}, material::Material)
    return sin((Km - Kn) * tau(material)' * 2pi/material.latticeconstant)
end

# V(Km-Kn)
function V(Km::Matrix{Int}, Kn::Matrix{Int}, material::Material)
    K = Km - Kn
    m = K[1]^2 + K[2]^2 + K[3]^2
    strained = material.latticeconstant^3 / (
        material.strainedlatticeconstant.parallel^2 * material.strainedlatticeconstant.vertical
    )
    if m in [0,3,4,8,11]
        return (Ss(Km, Kn, material) * material.Fs[m] - im * Sa(Km, Kn, material) * material.Fa[m])[1, 1] * strained
    else
        return Complex(0.0)
    end
end

# Hamiltonian matrix
function Hamiltonian(material::Material)::Matrix{ComplexF64}
    N = 51
    hamiltonian = zeros(Complex{Float64}, N, N)
    column = 1
    for i in [0,3,4,8,11]
        for k in material.reciprocalvector[i]
            row  = 1
            for j in [0,3,4,8,11]
                for kk in material.reciprocalvector[j]
                    if column !== row
                        hamiltonian[row, column] =  V(kk, k, material)
                    end
                    row += 1
                end
            end
            column += 1
        end
    end
    return hamiltonian
end

function EigenEnergy(material::Material, kpoints=40)::Matrix{Float64}
    sorted = sort(collect(material.reciprocalvector), by=x->x[1])
    diagonal = Vector{Matrix{Float64}}()

    strained = material.latticeconstant^3 / (
        material.strainedlatticeconstant.parallel^2 * material.strainedlatticeconstant.vertical
    )

    # Hamiltonian's diagnonal factor
    for K in sorted
        for KK in K[2]
            push!(diagonal, KK * 2pi/material.latticeconstant)
        end
    end

    # setup Hamiltonian
    H = Hamiltonian(material)

    E = zeros(Float64, 51, kpoints)

    G = trunc(Int, kpoints/2)
    for k in 1:kpoints
        # L -> G
        if k < G+1
            dk = strained * (pi/material.latticeconstant) / G
            ddk = dk * (k - 1)
            for i in 1:51
                H[i, i] = (HBAR^2/2M * ( [(pi/material.strainedlatticeconstant.parallel)-ddk (pi/material.strainedlatticeconstant.parallel)-ddk (pi/material.strainedlatticeconstant.vertical)-ddk] + diagonal[i] ) * ( [(pi/material.strainedlatticeconstant.parallel)-ddk (pi/material.strainedlatticeconstant.parallel)-ddk (pi/material.strainedlatticeconstant.vertical)-ddk] + diagonal[i] )')[1,1]
            end
            ε , ψ = LinearAlgebra.eigen(H)
            E[:, k] = sort((ε/Q))
        # G -> X
        else
            dk = strained * (2pi/material.latticeconstant) / (kpoints - G)
            ddk = dk * (k - G - 1)
            for i in 1:51
                H[i, i] = (HBAR^2/2M * ( [ddk 0 0] + diagonal[i] ) * ( [ddk 0 0] + diagonal[i] )')[1,1]
            end
            ε , ψ = LinearAlgebra.eigen(H)
            E[:, k] = sort((ε/Q))
        end
    end

    e0 = E[4, G]
    f(x) = real(x - e0)
    E = f.(E)

    return E
end

function BandStructure(E::Matrix{Float64}; fielname="pseudopotential", show=false)
    plots = Array{PlotlyBase.AbstractTrace,1}()
    for ii in 1:9
        push!(plots, scatter(;x=[iknum for iknum in 1:length(E[ii, :])], y=E[ii, :], mode="lines"))
    end
    layout = Layout(title="GaAs Bulk Emprical Psuedo Potential", autosize=true, showlegend=false)
    if show == true
        plot(plots, layout)
    else
        p = Plot(plots, layout)
        savefig(p, "$fielname.png")
    end	
end

function BandGap(E::Matrix{Float64})
    valenceband = E[4, :]
    conductionband = E[5, :]
    G = trunc(Int, length(conductionband)/2)
    println(conductionband[G] - valenceband[G], " [eV]")
end

end