@testset "ReificationSet: SingleVariable" begin
    model = OPTIMIZER
    MOI.empty!(model)

    @test MOI.supports_constraint(model, MOI.SingleVariable, MOI.Integer)
    @test MOI.supports_constraint(model, MOI.SingleVariable, MOI.EqualTo{Int})
    @test MOI.supports_constraint(model, MOI.VectorOfVariables, CP.ReificationSet{MOI.EqualTo{Int}})

    x1, _ = MOI.add_constrained_variable(model, MOI.Integer())
    x2, _ = MOI.add_constrained_variable(model, MOI.Integer())

    c1 = MOI.add_constraint(model, MOI.SingleVariable(x2), MOI.EqualTo(1))
    c2 = MOI.add_constraint(model, MOI.VectorOfVariables(MOI.VariableIndex[x1, x2]), CP.ReificationSet(MOI.EqualTo(2)))

    @test MOI.is_valid(model, x1)
    @test MOI.is_valid(model, x2)
    @test MOI.is_valid(model, c1)
    @test MOI.is_valid(model, c2)

    MOI.optimize!(model)
    @test MOI.get(model, MOI.TerminationStatus()) == MOI.OPTIMAL
    @test MOI.get(model, MOI.PrimalStatus()) == MOI.FEASIBLE_POINT

    @test MOI.get(model, MOI.ResultCount()) >= 1
    @test MOI.get(model, MOI.VariablePrimal(), x1) == 0
    @test MOI.get(model, MOI.VariablePrimal(), x2) == 1
end

@testset "ReificationSet: ScalarAffineFunction" begin
    model = OPTIMIZER
    MOI.empty!(model)

    @test MOI.supports_constraint(model, MOI.SingleVariable, MOI.Integer)
    @test MOI.supports_constraint(model, MOI.ScalarAffineFunction{Int}, MOI.EqualTo{Int})
    @test MOI.supports_constraint(model, MOI.VectorAffineFunction{Int}, CP.ReificationSet{MOI.EqualTo{Int}})

    x1, _ = MOI.add_constrained_variable(model, MOI.Integer())
    x2, _ = MOI.add_constrained_variable(model, MOI.Integer())

    c1 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1], [x2]), 0), MOI.EqualTo(1))
    c2 = MOI.add_constraint(model, MOI.VectorAffineFunction(MOI.VectorAffineTerm.([1, 2], MOI.ScalarAffineTerm.([1, 1], [x1, x2])), [0, 0]), CP.ReificationSet(MOI.EqualTo(2)))

    @test MOI.is_valid(model, x1)
    @test MOI.is_valid(model, x2)
    @test MOI.is_valid(model, c1)
    @test MOI.is_valid(model, c2)

    MOI.optimize!(model)
    @test MOI.get(model, MOI.TerminationStatus()) == MOI.OPTIMAL
    @test MOI.get(model, MOI.PrimalStatus()) == MOI.FEASIBLE_POINT

    @test MOI.get(model, MOI.ResultCount()) >= 1
    @test MOI.get(model, MOI.VariablePrimal(), x1) == 0
    @test MOI.get(model, MOI.VariablePrimal(), x2) == 1
end