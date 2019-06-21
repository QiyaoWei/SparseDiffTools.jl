abstract type ColoringAlgorithm end
struct GreedyD1Color <: ColoringAlgorithm end
struct BSCColor <: ColoringAlgorithm end
struct ContractionColor <: ColoringAlgorithm end

"""
    matrix_colors(A,alg::ColoringAlgorithm = GreedyD1Color())

    Returns the color vector for the matrix A using the chosen coloring
    algorithm. If a known analytical solution exists, that is used instead.
    The coloring defaults to a greedy distance-1 coloring.

"""
function matrix_colors(A::AbstractMatrix,alg::ColoringAlgorithm = GreedyD1Color())
    _A = A isa SparseMatrixCSC ? A : sparse(A) # Avoid the copy
    A_graph = matrix2graph(_A)
    color_graph(A_graph,alg)
end

"""
    matrix_colors(A::Union{Array,UpperTriangular,LowerTriangular})

    The color vector for dense matrix and triangular matrix is simply 
    `[1,2,3,...,size(A,2)]`
"""
function matrix_colors(A::Union{Array,UpperTriangular,LowerTriangular})
    eachindex(1:size(A,2)) # Vector size matches number of rows
end

function matrix_colors(A::Diagonal)
    repeat(1,size(A,2))
end

function matrix_colors(A::Bidiagonal)
    repeat(1:2,div(size(A,2),2)+1)[1:size(A,2)]
end

function matrix_colors(A::Tridiagonal)
    repeat(1:3,div(size(A,2),3)+1)[1:size(A,2)]
end
