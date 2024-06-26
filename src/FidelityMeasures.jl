"""
    u_fidelity(x::NamedMatrix, clusters::Dict{String, Vector{String}}, method::String)::NamedMatrix

Calculate a Bruelheide u fidelity measure.

### Input

- `x` -- A releve by species matrix, of class NamedArrays::NamedMatrix
- `clusters` -- A dictionary containing the names of the clusters and associated lists of row names belonging to that cluster, of class Dict{String, Vector{String}}
- `method` -- The u fidelity method to use one of: "u_hyp", "u_hyp_adj", "u_binA", "u_binA_adj", "u_binB", "u_binB_adj", of class String

### Output

A cluster by species NamedMatrix containing the selected u fidelity values.

### Notes

### Algorithm

This function implements the Bruelheide fidelity measure of u as outlined in Bruelheide (2000) and Chytrý et al (2002).

### References

Bruelheide, H., 2000. A new measure of fidelity and its application to defining species groups. Journal of Vegetation Science 11, 167–178. https://doi.org/10.2307/3236796
Chytrý, M., Tichý, L., Holt, J., Botta-Dukát, Z., 2002. Determination of diagnostic species with statistical fidelity measures. Journal of Vegetation Science 13, 79–90. https://doi.org/10.1111/j.1654-1103.2002.tb02025.x

"""
function u_fidelity(x::NamedMatrix, clusters::Dict{String, Vector{String}}, method::String = "u_hyp")

    x = Int.(x .!= 0)

    N = size(x)[1]
    n = sum(x, dims = 1)

    u_all = NamedArrays.NamedArray(zeros(length(names(clusters)), size(x)[2]), names = (names(clusters), names(x)[2]))

    for i in names(clusters)
        Np = length(getindex(clusters, i))
        np = sum(x[getindex(clusters, i),:], dims = 1)
        μ = n .* (Np ./ N)

        if method == "u_hyp"
            σ_hyp = sqrt.((n .* Np .* (N .- n) .* (N .- Np)) ./ (N^2 .* (N - 1)))
            σ = σ_hyp
        end

        if method == "u_binA"
            σ_binA = sqrt.(n .* (Np / N) .* (1 - (Np / N)))
            σ = σ_binA
        end

        if method == "u_binB"
            σ_binB = sqrt.(Np .* (n ./ N) .* (1 .- (n ./ N)))            
            σ = σ_binB
        end
        
        u = (np .- μ) ./ σ
        u_all[i,:] = u
    end

    return u_all

end

"""
    phi_fidelity(x::NamedMatrix, clusters::Dict{String, Vector{String}})::NamedMatrix

Calculate the Φ fidelity values for a given releve by species matrix and set of clusters.

### Input

- `x` -- A releve by species matrix of the class NamedArrays::NamedMatrix
- `clusters` -- A dictionary containing the names of the clusters and associated lists of row names belonging to that cluster of the class Dict{String, Vector{String}}

### Output

A cluster by species NamedMatrix containing the fidelity values.

### Notes


### Algorithm

This function implements the Φ fidelity measure as described in Chytrý et al (2002) and Sokal and Rohlf (1995).

### References

Chytrý, M., Tichý, L., Holt, J., Botta-Dukát, Z., 2002. Determination of diagnostic species with statistical fidelity measures. Journal of Vegetation Science 13, 79–90. https://doi.org/10.1111/j.1654-1103.2002.tb02025.x
Sokal, R.R., Rohlf, F.J., 1995. Biometry. W. H. Freeman.

"""
function phi_fidelity(x::NamedMatrix, clusters::Dict{String, Vector{String}})

    x = Int.(x .!= 0)

    N = size(x)[1]
    n = sum(x, dims = 1)

    Φ_all = NamedArrays.NamedArray(zeros(length(names(clusters)), size(x)[2]), names = (names(clusters), names(x)[2]))

    for i in names(clusters)
        Np = length(getindex(clusters, i))
        np = sum(x[getindex(clusters, i),:], dims = 1)
        Φ = ((N .* np) .- (n .* Np)) ./ sqrt.(n .* Np .* (N .- n) .* (N - Np))
        Φ_all[i,:] = Φ
    end

    return Φ_all

end

"""
    chisq_fidelity(x::NamedMatrix, clusters::Dict{String, Vector{String}}, method::String = "chisq")::NamedMatrix

Calculate the Chi-squared fidelity values for a given releve by species matrix and set of clusters.

### Input

- `x` -- A releve by species matrix of the class NamedArrays::NamedMatrix
- `clusters` -- A dictionary containing the names of the clusters and associated lists of row names belonging to that cluster of the class Dict{String, Vector{String}}
- `method` -- The Chi-squared fidelity method to use one of: "chisq" or "chisq_adj", of class String

### Output

A cluster by species NamedMatrix containing the fidelity values.

### Notes


### Algorithm

This function implements the Chi-squared fidelity measure as described in Chytrý et al (2002) and Sokal and Rohlf (1995).

### References

Chytrý, M., Tichý, L., Holt, J., Botta-Dukát, Z., 2002. Determination of diagnostic species with statistical fidelity measures. Journal of Vegetation Science 13, 79–90. https://doi.org/10.1111/j.1654-1103.2002.tb02025.x
Sokal, R.R., Rohlf, F.J., 1995. Biometry. W. H. Freeman.

"""
function chisq_fidelity(x::NamedMatrix, clusters::Dict{String, Vector{String}}, method::String = "chisq")

    x = Int.(x .!= 0)

    N = size(x)[1]
    n = sum(x, dims = 1)

    chisq_all = NamedArrays.NamedArray(zeros(length(names(clusters)), size(x)[2]), names = (names(clusters), names(x)[2]))

    for i in names(clusters)
        Np = length(getindex(clusters, i))
        np = sum(x[getindex(clusters, i),:], dims = 1)

        if method == "chisq"
            chisq = (N .* ((N .* np) .- (n .* Np)).^2) ./ (n .* Np .* (N .- n) .* (N .- Np))
            chisq = chisq
        end

        if method == "chisq_adj"
            chisq_adj = (N .* (abs.((N .* np) .- (n .* Np)) .- (N / 2)).^2) ./ (n .* Np .* (N .- n) .* (N .- Np))
            chisq = chisq_adj
        end

        chisq_all[i,:] = chisq
    end

    return chisq_all

end

"""
    G_fidelity(x::NamedMatrix, clusters::Dict{String, Vector{String}}, method::String = "G")::NamedMatrix

Calculate the G statistic fidelity values for a given releve by species matrix and set of clusters.

### Input

- `x` -- A releve by species matrix of the class NamedArrays::NamedMatrix
- `clusters` -- A dictionary containing the names of the clusters and associated lists of row names belonging to that cluster of the class Dict{String, Vector{String}}
- `method` -- The G statistic fidelity method to use one of: "G" or "G_adj", of class String

### Output

A cluster by species NamedMatrix containing the fidelity values.

### Notes


### Algorithm

This function implements the G statistic fidelity measure as described in Chytrý et al (2002) and Sokal and Rohlf (1995).

### References

Chytrý, M., Tichý, L., Holt, J., Botta-Dukát, Z., 2002. Determination of diagnostic species with statistical fidelity measures. Journal of Vegetation Science 13, 79–90. https://doi.org/10.1111/j.1654-1103.2002.tb02025.x
Sokal, R.R., Rohlf, F.J., 1995. Biometry. W. H. Freeman.

"""           
function G_fidelity(x::NamedMatrix, clusters::Dict{String, Vector{String}}, method::String = "G")

    x = Int.(x .!= 0)

    N = size(x)[1]
    n = sum(x, dims = 1)

    G_all = NamedArrays.NamedArray(zeros(length(names(clusters)), size(x)[2]), names = (names(clusters), names(x)[2]))

    for i in names(clusters)
        Np = length(getindex(clusters, i))
        np = sum(x[getindex(clusters, i),:], dims = 1)
        fo_1 = np
        fo_2 = n .- np
        fo_3 = Np .- np
        fo_4 = N - Np .- n .+ np
        fe_1 = n .* (Np / N)
        fe_2 = n .* ((N - Np) / N)
        fe_3 = (N .- n) .* (Np ./ N)
        fe_4 = (N .- n) .* ((N - Np) / N)
        i1 = fo_1 .* log.(fo_1 ./ fe_1)
        i2 = fo_2 .* log.(fo_2 ./ fe_2)
        i3 = fo_3 .* log.(fo_3 ./ fe_3)
        i4 = fo_4 .* log.(fo_4 ./ fe_4)
        G = 2 .* (i1 .+ i2 .+ i3 .+ i4)

        if method == "G"
            G_return = G
        end

        if method == "G_adj"
            G_adj = G ./ (1 .+ (1 ./ 6 * N) .* ((N ./ n) .+ (N ./ (N .- n)) .- 1) .* ((N / Np) + (N / (N - Np)) - 1))
            G_return = G_adj
        end

        G_all[i,:] = G_return
    end

    return G_all

end

# x = VegSci.generate_test_array(rown = 30, coln = 10, meancoloccs = 7, rowprefix = "", colprefix = "Species")
# # Set clusters manually for now as I don't yet want to commit to making clustering a dependency.
# clusters = Dict("1" => ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
#                 "2" => ["11", "12", "13", "14", "15", "16", "17", "18", "19", "20"],
#                 "3" => ["21", "22", "23", "24", "25", "26", "27", "28", "29", "30"])
# i = "1"
# function fisher_fidelity(x::NamedMatrix, clusters::Dict{String, Vector{String}})

#     x = Int.(x .!= 0)

#     N = size(x)[1]
#     n = sum(x, dims = 1)

#     fisher_all = NamedArrays.NamedArray(zeros(length(names(clusters)), size(x)[2]), names = (names(clusters), names(x)[2]))

#     for i in names(clusters)
#         Np = length(getindex(clusters, i))
#         np = sum(x[getindex(clusters, i),:], dims = 1)
#         # fo_1 = np

#         fisher = (factorial.(big.(n)) * Np .* factorial.(big.(N .- n)) .* factorial.(big.(N .- Np))) ./ (factorial(i) * factorial(N) .* factorial.(big.(n - i)) .* factorial.(big.(Np - i)) .* factorial.(big.(N - Np - n + i)))

#         fisher_all[i,:] = fisher
#     end

#     return fisher_all

# end

"""
    indval_fidelity(x::NamedMatrix, clusters::Dict{String, Vector{String}})::NamedMatrix

Calculate the Dufrêne-Legendre Indicator Value Index (IndVal) fidelity values for a given releve by species matrix
and set of clusters.

### Input

- `x` -- A releve by species matrix of the class NamedArrays::NamedMatrix
- `clusters` -- A dictionary containing the names of the clusters and associated lists of row names belonging to that cluster of the class Dict{String, Vector{String}}

### Output

A cluster by species NamedMatrix containing the fidelity values.

### Notes


### Algorithm

This function implements the Dufrêne-Legendre Indicator Value Index as described in Dufrêne & Legendre (1997) and Chytrý et al (2002).

### References

Dufrêne, M. & Legendre, P. 1997. Species assemblages and indicator species: the need for a flexible asymmetrical approach. Ecol. Monogr. 67: 345-366.
Chytrý, M., Tichý, L., Holt, J., Botta-Dukát, Z., 2002. Determination of diagnostic species with statistical fidelity measures. Journal of Vegetation Science 13, 79–90. https://doi.org/10.1111/j.1654-1103.2002.tb02025.x

"""
function indval_fidelity(x::NamedMatrix, clusters::Dict{String, Vector{String}})

    x = Int.(x .!= 0)

    N = size(x)[1]
    n = sum(x, dims = 1)

    indval_all = NamedArrays.NamedArray(zeros(length(names(clusters)), size(x)[2]), names = (names(clusters), names(x)[2]))

    for i in names(clusters)
        Np = length(getindex(clusters, i))
        np = sum(x[getindex(clusters, i),:], dims = 1)
        indval = ((np .* (N .- Np)) ./ (((n .* Np) .- (2 .* np)) .+ (np .* N))) .* (np ./ Np)
        indval_all[i,:] = indval
    end

    return indval_all

end

"""
    extract_indicators(fidelity_values::NamedMatrix; p_cut::Float64, n_cut::Union{Float64, Nothing} = nothing)

Extract the positive and negative indicator species from a matrix of fidelity values using a positive and optionally a negative cut value.
Positive indicators are denoted by a value of 1.0 and negative indicators are denoted by a value of -1.0.

### Input

- `x` -- A releve by species matrix, of class NamedArrays::NamedMatrix
- `p_cut` -- A postive number used to filter positive indicator species, of class Float64
- `n_cut` -- A number used to filter negative indicator species, of class Float64

### Output

A cluster by species NamedMatrix containing the positive (1.0) and negative (-1.0) indicator species.

### Notes


"""
function extract_indicators(fidelity_values::NamedMatrix; p_cut::Float64, n_cut::Union{Float64, Nothing} = nothing, tp::Bool = false)

    fidelity_values = copy(fidelity_values)

    replace!(x -> x.>= p_cut ? 1.0 : x, fidelity_values)

    if !isnothing(n_cut)
        replace!(x -> x.<= n_cut ? -1.0 : x, fidelity_values)
        replace!(x -> (x.!= 1.0 && x.!= -1.0) ? 0.0 : x, fidelity_values)
    elseif isnothing(n_cut)
        replace!(x -> x.!= 1.0 ? 0.0 : x, fidelity_values)
    end

    # Remove all columns (species) for which there are no positive or negative indicators
    fidelity_values = fidelity_values[:, vec(map(col -> any(col .!= 0), eachcol(fidelity_values)))]

    if tp == true
        fidelity_values = transpose(fidelity_values)
    end

    return fidelity_values
    
end


function ind_mat_to_df(indicator_species::NamedMatrix)

    df = DataFrames.DataFrame(indicator_species, Symbol.(names(indicator_species)[2]))
    insertcols!(df, 1, Symbol("Species") => names(indicator_species)[1])
    df = string.(df)
    df .= ifelse.(df .== "1.0", "+", df)
    df .= ifelse.(df .== "-1.0", "-", df)
    df .= ifelse.(df .== "0.0", "", df)
    sort!(df, [:Species])
    return df

end

function assign_fidelity_synobj(sto::VegSci.SyntopicTable, fidelity_values::NamedMatrix, p_cut::Float64, n_cut::Float64)

    sto.fidelity = vec(fidelity_values[:, sto.species_names])
    sto.fidelity_p = names(fidelity_values[:, sto.species_names][:, vec(map(col -> any(col .>= p_cut), eachcol(fidelity_values[:, sto.species_names])))])[2]
    sto.fidelity_n = names(fidelity_values[:, sto.species_names][:, vec(map(col -> any(col .<= n_cut), eachcol(fidelity_values[:, sto.species_names])))])[2]

    return sto

end