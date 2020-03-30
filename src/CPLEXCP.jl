module CPLEXCP

using JavaCall

if isfile(joinpath(dirname(@__FILE__), "..", "deps", "deps.jl"))
    include("../deps/deps.jl")
else
    error("CPLEXCP not properly installed. Please run Pkg.build(\"CPLEXCP\") or ]build CPLEXCP")
end

if !@isdefined(libcplexcpojava)
    error("CPLEXCP not properly built. There probably was a problem when running Pkg.build(\"CPLEXCP\") or ]build CPLEXCP")
end

export cpo_java_init, JavaCPOModel, cpo_java_model, cpo_java_intvar_bounded,
       cpo_java_intvar_discrete, cpo_java_intvararray_bounded,
       cpo_java_intvararray_discrete, cpo_java_numvar, cpo_java_numvararray,
       cpo_java_intervalvar, cpo_java_intervalvar_fixedsize,
       cpo_java_intervalvar_boundedsize

include("api_java.jl")

end # module
