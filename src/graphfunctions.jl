# Base.eltype
eltype(::Type{BondGraph}) = AbstractNode
eltype(bg::BondGraph) = AbstractNode

# edgetype
lg.edgetype(::Type{BondGraph}) = lg.AbstractSimpleEdge{Integer}
lg.edgetype(bg::BondGraph) = lg.AbstractSimpleEdge{Integer}

# edges
lg.edges(bg::BondGraph) = bg.bonds
lg.ne(bg::BondGraph) = length(bg.bonds)
lg.has_edge(bg::BondGraph, b::Bond) = b in bg.bonds
lg.has_edge(bg::BondGraph, n1::AbstractNode, n2::AbstractNode) = 
    any(b -> 
        (lg.src(b) == n1 && lg.dst(b) == n2) || 
        (lg.dst(b) == n1 && lg.src(b) == n2), bg.bonds)

# vertices
lg.vertices(bg::BondGraph) = bg.nodes
lg.nv(bg::BondGraph) = length(bg.nodes)
lg.has_vertex(bg::BondGraph, node::AbstractNode) = node in bg.nodes

# inneighbors, outneighbors
lg.inneighbors(bg::BondGraph, node::AbstractNode) = 
    [lg.src(b) for b in bg.bonds if lg.dst(b) == node]
lg.outneighbors(bg::BondGraph, node::AbstractNode) = 
    [lg.dst(b) for b in values(bg.bonds) if lg.src(b) == node]

# is_directed
lg.is_directed(::Type{BondGraph}) = true
lg.is_directed(bg::BondGraph) = true

# zero
lg.zero(::Type{BondGraph}) = BondGraph()
lg.zero(bg::BondGraph) = BondGraph()

# weights
# TODO

# Mutations
function lg.add_vertex!(bg::BondGraph, node::AbstractNode)
    lg.has_vertex(bg, node) && return false
    push!(bg.nodes, node)
    return true
end

function lg.rem_vertex!(bg::BondGraph, node::AbstractNode)
    lg.has_vertex(bg, node) || return false
    index = findfirst(x -> x == node, bg.nodes)
    deleteat!(bg.nodes, index)
    return true
end

function lg.add_edge!(bg::BondGraph, b::Bond)
    lg.has_edge(bg, b) && return false
    push!(bg.bonds, b)
    return true
end

function lg.rem_edge!(bg::BondGraph, b::Bond)
    lg.has_edge(bg, b) || return false
    index = findfirst(x -> x == b, bg.bonds)
    deleteat!(bg.bonds, index)
    return true
end