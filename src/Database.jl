module Database

const Q = 1.60217662e-19

const Rydberg = 13.6

const Material = Dict(
    "Si" => Dict(
        "C11" => 10,
        "C12" => 10,
        "Fs" => Dict(
            3 => -0.21 * Q * Rydberg,
            4 => 0 * Q *  Rydberg,
            8 => 0.04 * Q * Rydberg,
            11 => 0.08 * Q * Rydberg,
        ),
        "Fa" => Dict(
            3 => 0.00 * Rydberg,
            4 => 0.00 * Rydberg,
            8 => 0.00 * Rydberg,
            11 => 0.00 * Rydberg,
        )
    ),
    "Ge" => Dict(
        "C11" => 10,
        "C12" => 10,
        "Fs" => Dict(
            3 => -0.230 * Q * Rydberg,
            4 => 0 * Q * Rydberg,
            8 => 0.01 * Q * Rydberg,
            11 => 0.06 * Q * Rydberg,
        ),
        "Fa" => Dict(
            3 => 0.00 * Rydberg,
            4 => 0.00 * Rydberg,
            8 => 0.00 * Rydberg,
            11 => 0.00 * Rydberg,
        )
    ),
    "GaAs" => Dict(
        "latticeconstant" => 5.65325e-10,
        "elasticconstant" => Dict(
            "C11" => 1221,
            "C12" => 566,
            "C44" => 600,
        ),
        "pseudopotential" => Dict(
            "Fs" => Dict(
                3 => -0.23 * Q * Rydberg,
                4 => 0.00 * Q * Rydberg,
                8 => 0.01 * Q * Rydberg,
                11 => 0.06 * Q * Rydberg,
            ),
            "Fa" => Dict(
                3 => 0.07 * Q * Rydberg,
                4 => 0.05 * Q * Rydberg,
                8 => 0.00 * Q * Rydberg,
                11 => 0.01 * Q * Rydberg,
            )
        ),

    ),
    "GaP" => Dict(
        "latticeconstant" => 5.4505e-10,
        "elasticconstant" => Dict(
            "C11" => 1405,
            "C12" => 620.3,
            "C44" => 703.3,
        ),
        "pseudopotential" => Dict(
            "Fs" => Dict(
                3 => -0.22 * Q * Rydberg,
                4 => 0 * Q * Rydberg,
                8 => 0.03 * Q * Rydberg,
                11 => 0.07 * Q * Rydberg,
            ),
            "Fa" => Dict(
                3 => 0.12 * Q * Rydberg,
                4 => 0.07 * Q * Rydberg,
                8 => 0 * Q * Rydberg,
                11 => 0.02 * Q * Rydberg,
            )
        ),
    ),
    "InP" => Dict(
        "latticeconstant" => 5.8697e-10,
        "elasticconstant" => Dict(
            "C11" => 1011,
            "C12" => 561,
            "C44" => 456,
        ),
        "pseudopotential" => Dict(
            "Fs" => Dict(
                3 => -0.23 * Q * Rydberg,
                4 => 0.00 * Q * Rydberg,
                8 => 0.01 * Q * Rydberg,
                11 => 0.06 * Q * Rydberg,
            ),
            "Fa" => Dict(
                3 => 0.07 * Q * Rydberg,
                4 => 0.05 * Q * Rydberg,
                8 => 0 * Q * Rydberg,
                11 => 0.01 * Q * Rydberg,
            )
        ),
    ),
    "InAs" => Dict(
        "latticeconstant" => 6.0583e-10,
        "elasticconstant" => Dict(
            "C11" => 832.9,
            "C12" => 452.6,
            "C44" => 395.9,
        ),
        "pseudopotential" => Dict(
            "Fs" => Dict(
                3 => -0.22 * Q * Rydberg,
                4 => 0.00 * Q * Rydberg,
                8 => 0.00 * Q * Rydberg,
                11 => 0.05 * Q * Rydberg,
            ),
            "Fa" => Dict(
                3 => 0.08 * Q * Rydberg,
                4 => 0.05 * Q * Rydberg,
                8 => 0 * Q * Rydberg,
                11 => 0.03 * Q * Rydberg,
            )
        ),
    ),
    "InSb" => Dict(
        "latticeconstant" => 6.4794e-10,
        "elasticconstant" => Dict(
            "C11" => 684.7,
            "C12" => 373.5,
            "C44" => 311.1,
        ),
        "pseudopotential" => Dict(
            "Fs" => Dict(
                3 => -0.20 * Q * Rydberg,
                4 => 0.00 * Q * Rydberg,
                8 => 0.00 * Q * Rydberg,
                11 => 0.04 * Q * Rydberg,
            ),
            "Fa" => Dict(
                3 => 0.06 * Q * Rydberg,
                4 => 0.05 * Q * Rydberg,
                8 => 0 * Q * Rydberg,
                11 => 0.01 * Q * Rydberg,
            )
        ),
    ),
    "AlSb" => Dict(
        "latticeconstant" => 6.1355e-10,
        "elasticconstant" => Dict(
            "C11" => 876.9,
            "C12" => 434.1,
            "C44" => 407.6,
        ),
        "pseudopotential" => Dict(
            "Fs" => Dict(
                3 => -0.21 * Q * Rydberg,
                4 => 0 * Q * Rydberg,
                8 => 0.02 * Q * Rydberg,
                11 => 0.06 * Q * Rydberg,
            ),
            "Fa" => Dict(
                3 => 0.06 * Q * Rydberg,
                4 => 0.04 * Q * Rydberg,
                8 => 0 * Q * Rydberg,
                11 => 0.02 * Q * Rydberg,
            )
        ),
    ),
    "GaSb" => Dict(
        "latticeconstant" => 6.0959e-10,
        "elasticconstant" => Dict(
            "C11" => 884.2,
            "C12" => 402.6,
            "C44" => 432.2,
        ),
        "pseudopotential" => Dict(
            "Fs" => Dict(
                3 => -0.22 * Q * Rydberg,
                4 => 0.00 * Q * Rydberg,
                8 => 0.00 * Q * Rydberg,
                11 => 0.05 * Q * Rydberg,
            ),
            "Fa" => Dict(
                3 => 0.06 * Q * Rydberg,
                4 => 0.05 * Q * Rydberg,
                8 => 0 * Q * Rydberg,
                11 => 0.01 * Q * Rydberg,
            )
        ),
    ),
    "ZnS" => Dict(
        "latticeconstant" => 0.0,
        "elasticconstant" => Dict(
            "C11" => 10,
            "C12" => 10,
            "C44" => 10,
        ),
        "pseudopotential" => Dict(
            "Fs" => Dict(
                3 => -0.22 * Q * Rydberg,
                4 => 0 * Q * Rydberg,
                8 => 0.03 * Q * Rydberg,
                11 => 0.07 * Q * Rydberg,
            ),
            "Fa" => Dict(
                3 => 0.24 * Q * Rydberg,
                4 => 0.14 * Q * Rydberg,
                8 => 0 * Q * Rydberg,
                11 => 0.04 * Q * Rydberg,
            )
        ),
    ),
    "ZnSe" => Dict(
        "latticeconstant" => 0.0,
        "elasticconstant" => Dict(
            "C11" => 10,
            "C12" => 10,
            "C44" => 10,
        ),
        "pseudopotential" => Dict(
            "Fs" => Dict(
                3 => -0.23 * Q * Rydberg,
                4 => 0 * Q * Rydberg,
                8 => 0.03 * Q * Rydberg,
                11 => 0.06 * Q * Rydberg,
            ),
            "Fa" => Dict(
                3 => 0.24 * Q * Rydberg,
                4 => 0.14 * Q * Rydberg,
                8 => 0 * Q * Rydberg,
                11 => 0.04 * Q * Rydberg,
            )
        ),
    ),
    "ZnTe" => Dict(
        "latticeconstant" => 0.0,
        "elasticconstant" => Dict(
            "C11" => 10,
            "C12" => 10,
            "C44" => 10,
        ),
        "pseudopotential" => Dict(
            "Fs" => Dict(
                3 => -0.22 * Q * Rydberg,
                4 => 0 * Q * Rydberg,
                8 => 0.00 * Q * Rydberg,
                11 => 0.05 * Q * Rydberg,
            ),
            "Fa" => Dict(
                3 => 0.13 * Q * Rydberg,
                4 => 0.10 * Q * Rydberg,
                8 => 0.00 * Q * Rydberg,
                11 => 0.01 * Q * Rydberg,
            )
        ),
    ),
    "CdTe" => Dict(
        "latticeconstant" => 0.0,
        "elasticconstant" => Dict(
            "C11" => 10,
            "C12" => 10,
            "C44" => 10,
        ),
        "pseudopotential" => Dict(
            "Fs" => Dict(
                3 => -0.20 * Q * Rydberg,
                4 => 0.00 * Q * Rydberg,
                8 => 0.00 * Q * Rydberg,
                11 => 0.04 * Q * Rydberg,
            ),
            "Fa" => Dict(
                3 => 0.15 * Q * Rydberg,
                4 => 0.09 * Q * Rydberg,
                8 => 0 * Q * Rydberg,
                11 => 0.04 * Q * Rydberg,
            )
        ),
    )
)

end
