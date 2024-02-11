

![](dev/logo/wide_logo.png)

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://ZekeMarshall.github.io/EcoVeg.jl/stable/) [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ZekeMarshall.github.io/EcoVeg.jl/dev/) [![Build Status](https://github.com/ZekeMarshall/EcoVeg.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/ZekeMarshall/EcoVeg.jl/actions/workflows/CI.yml?query=branch%3Amain) [![Coverage](https://codecov.io/gh/ZekeMarshall/EcoVeg.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/ZekeMarshall/EcoVeg.jl)

# EcoVeg

`EcoVeg.jl` is a package containing functions for the analysis of vegetation plot sample data….

## Example Pluto Notebook

### Local Tour

To run the tour locally, just clone this repo and start `Pluto.jl` as follows:

``` julia
] add Pluto
using Pluto
Pluto.run()
```

All notebooks are contained in `docs/pluto`.

## Background

## Installation

You can install the latest stable release from the general registry:

``` julia
using Pkg
Pkg.add("EcoVeg")
```

The development version can be installed as follows:

``` julia
using Pkg
Pkg.add(url="https://github.com/ZekeMarshall/EcoVeg.jl")
```

## Usage Example

To demonstrate…

First we begin with generating two example plot by species `NamedArrays.NamedMatrix` object using the function `EcoVeg.generate_test_array` as test data.

``` julia
x = generate_test_array(rown = 20, coln = 30, zerop = 0.6, rowprefix = "SiteA-", colprefix = "Species")
```

### Classification

Let’s artifically create some clusters for now…

``` julia
cluster1 = ["SiteA-1", "SiteA-2", "SiteA-4", "SiteA-7", "SiteA-10", "SiteA-11", "SiteA-12", "SiteA-15", "SiteA-18", "SiteA-19"]
cluster2 = ["SiteA-3", "SiteA-5", "SiteA-6", "SiteA-8", "SiteA-9", "SiteA-13", "SiteA-14", "SiteA-16", "SiteA-17", "SiteA-20"]
```

### Creation of Syntopic Tables

Once the plots have been grouped into clusters, we can proceed to summarise their composition via the creation of `SyntopicTable` objects.

``` julia
syn_1 = EcoVeg.compose_syntopic_table_object("Syn1", x[cluster1,:])
syn_2 = EcoVeg.compose_syntopic_table_object("Syn2", x[cluster2,:])
print_summary_syntopic_table(syn_2)
```

### Identification of High-Fidelity Species

### Generation of Pseudo-Releves

### Assignment of Releves to Vegetation Classes

Let’s generate a second example matrix, consisting of sample 5 releves, against which we want to calculate the similarity.

``` julia
y = generate_test_array(rown = 5, coln = 30, zerop = 0.6, rowprefix = "SiteB-", colprefix = "Species")
```

Three methods will be demonstrated.

### Jaccard Similarity

### Czekanowski Index

First, let’s compose a syntopic table object from the “y” sample data and extract the syntopic tables in matrix format.

``` julia
syn_y = EcoVeg.compose_syntopic_table_object("Sample", y)
syn_y_mat = extract_syntopic_matrix(syn_y)
syn_1_mat = extract_syntopic_matrix(syn_1)
syn_2_mat = extract_syntopic_matrix(syn_2)
```

Now we have three matrices, containg the relative frequencies of each species present in the sample releves which constitute the phytocoenosis’. However, each of the phytocoenosis is composed of a different set of species, in Julia we need a helper function to ensure all columns are present in each of the matrices before joining.

``` julia
# align_array_columns(syn_y_mat, syn_2_mat)
# align_array_columns(syn_y_mat, syn_1_mat)
```

### Multivariate Analysis

### Ecological Trajectory Analysis

## External Resources

## Implemented Methodologies

## Contribute

## Acknowledgements

## References