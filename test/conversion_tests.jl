@testset "Simple Reaction System" begin
    rn = @reaction_network ABC begin
        1, A + B --> C
    end

    bg_rn = BondGraph(rn)

    @test bg_rn.name == "ABC"
    @test nv(bg_rn) == 5
    @test ne(bg_rn) == 4
    
    @test any(n -> n.name == "R1", bg_rn.nodes)
    @test any(n -> typeof(n) == Junction && n.type == :𝟏, bg_rn.nodes)

    @test length(getnodes(bg_rn, :Ce)) == 3
    @test length(getnodes(bg_rn, :𝟏)) == 1
    @test length(getnodes(bg_rn, :Re)) == 1

    @test LightGraphs.degree(bg_rn) == [2, 3, 1, 1, 1]
end

@testset "Reversible MM" begin
    rn = @reaction_network MM_reversible begin
        (1, 1), E + S <--> C
        (1, 1), C <--> E + P
    end

    bg_rn = BondGraph(rn; chemostats=["S", "P"])

    @test bg_rn.name == "MM_reversible"
    @test nv(bg_rn) == 10
    @test ne(bg_rn) == 10
    
    @test length(getnodes(bg_rn, :Ce)) == 2
    @test length(getnodes(bg_rn, :Se)) == 2
    @test length(getnodes(bg_rn, :𝟎)) == 2
    @test length(getnodes(bg_rn, :𝟏)) == 2
    @test length(getnodes(bg_rn, :Re)) == 2

    @test LightGraphs.degree(bg_rn) == [2, 3, 1, 1, 1, 2, 3, 1, 3, 3]
end

@testset "Stoichiometry Test" begin
    rn = @reaction_network Stoichiometry begin
        1, 3A + 2B --> 5C
    end

    bg_rn = BondGraph(rn)

    @test nv(bg_rn) == 8
    @test ne(bg_rn) == 7
    
    tfs = getnodes(bg_rn, :TF)
    @test length(tfs) == 3
    @test repr.(tfs) == ["TF:3", "TF:2", "TF:5"]
end