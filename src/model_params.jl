# A vector of variational parameters.  The outer index is
# of celestial objects, and the inner index is over individual
# parameters for that object (referenced using ParamIndex).

typealias VariationalParams{NumType <: Number} Vector{Vector{NumType}}
typealias RectVariationalParams{NumType <: Number} Vector{Vector{NumType}}
typealias FreeVariationalParams{NumType <: Number} Vector{Vector{NumType}}


"""
The parameters for a particular image.

Attributes:
 - vp: The variational parameters
 - pp: The prior parameters
 - patches: An (objects X bands) matrix of SkyPatch objects
 - tile_width: The number of pixels across a tile
 - tile_sources: A vector (over bands) of an array (over tiles) of vectors
                 of sources influencing each tile.
 - active_sources: Indices of the sources that are currently being fit by the
                   model.
 - objids: Global object ids for the sources in this ModelParams object.

 - S: The number of sources.
"""
type ModelParams{T <: Number}
    vp::VariationalParams{T}
    pp::PriorParams
    patches::Array{SkyPatch, 2}
    tile_sources::Vector{Array{Vector{Int}, 2}}
    active_sources::Vector{Int}
    objids::Vector{ASCIIString}

    S::Int

    function ModelParams(vp::VariationalParams{T})
        # There must be one patch for each celestial object.
        S = length(vp)
        all_tile_sources = fill(fill(collect(1:S), 1, 1), 5)
        patches = Array(SkyPatch, S, 5)
        active_sources = collect(1:S)
        objids = ASCIIString[string(s) for s in 1:S]

        new(vp, prior, patches, all_tile_sources, active_sources, objids, S)
    end
end


ModelParams{T <: Number}(vp::VariationalParams{T}) = ModelParams{T}(vp)

