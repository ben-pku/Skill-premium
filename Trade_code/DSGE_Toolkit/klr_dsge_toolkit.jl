
#=================================================================================#
# Install required packages (skip if installed already)
#=================================================================================#

using Pkg
Pkg.add("LinearAlgebra")
Pkg.add("Random")
Pkg.add("Distributions")
Pkg.add("Plots")

#=================================================================================#
# Load packages
#=================================================================================#

using LinearAlgebra, Distributions, Plots, Random

#==================================================#
# Parameters and fundamentals
#==================================================#

# Intertemporal elasticity of substitution 
ψ = 1.0
# Discounting factor
β = 0.95^5
# Dispersion of migration shocks 
ρ = β * 3.0
# Trade elasticity
θ = 5.0
# Labor share in production
μ = 0.65
# Depreciation of capital
δ = 1 - 0.95^5

# vector of parameters
params = [β, ρ, θ, μ, δ]

# Make a N0 by N0 grid in latitude and longitude space (resulting in N=N0^2 regions)
N0 = 10
N = N0^2
# generate grids in the latitude and longitude space and convert to radiants
ltd = reverse(range(35, 40, N0))' .* (pi ./ 180) 
lgd = reverse(range(85, 100, N0)) .* (pi ./ 180)
# stack these grids into matrices to compute bilateral distance
latitude = repeat(ltd', N0, 1) * ones(1, N)
longitude = ones(N, 1) * reshape(repeat(lgd, 1, N0)', 1, N)
# apply the Haversine formula for Great Circle Distances
dist_temp = (sin.((latitude - latitude') ./ 2)) .^ 2 + (cos.(latitude) .* cos.(latitude') .* (sin.((longitude - longitude') ./ 2)) .^ 2)
dist = 6367 .* 2 .* asin.(dist_temp .^ 0.5) .+ 1 

# compute trade and migration costs as power functions of distance 
τ = dist .^ (1.25 / θ)
κ = dist .^ (1.25 * ρ)

# set seed 
Random.seed!(100)

# draw random productivity and amenity vectors
z = rand(Uniform(0.8, 1.2), N)
b = rand(Uniform(0.8, 1.2), N)

# generate vector of fundamentals
fundamentals = [z, τ, κ, b]

#==================================================#
# baseline steady state
#==================================================#

# a function to compute the steady state of the economy given fundamentals and parameters
function steadystate(fundamentals::Vector, params::Vector; damp=0.7, ctol=10^-8, displaygap=false, maxiter=10^5, displaysummary=true)

    # get fundamentals
    z, τ, κ, b = fundamentals
    # get parameters
    β, ρ, θ, μ, δ = params
    # number of regions
    N = length(z)

    ### change of varialbes for fundamentals
    # composite of migration frictions and amenities
    κn = (repeat(b', length(b)) ./ κ) .^ (1 / ρ)
    # composite of trade frictions and productivities
    τn = (τ .^ -1 .* repeat(z', length(z))) .^ θ

    ### auxiliary functions
    # update capital-labor ratios from wages and prices
    p2χss(w, p) = (β / (1 - β * (1 - δ))) * ((1 - μ) / μ) * w ./ p
    # update unit-costs from wages and prices
    caux(w, p) = w .* p2χss(w, p) .^ (μ - 1)
    # update bilateral prices from wages and prices
    paux(w, p) = τn .* repeat(caux(w, p)' .^ -θ, N)

    ### initial guesses for wages, prices, population shares, and worker utility levels
    w₀ = z .^ (θ / (θ + 1))
    p₀ = w₀
    l₀ = w₀
    u₀ = w₀

    ### X is the matrix that we iterate over
    X = [p₀ w₀ l₀ u₀]
    newX = similar(X)

    # gap between current guess of X and new guess of x
    gap = 1.0

    # iteration number
    iter = 0

    while (gap > ctol && iter < maxiter)

        iter = iter + 1

        p₀ = X[:, 1]
        w₀ = X[:, 2]
        l₀ = X[:, 3]
        u₀ = X[:, 4]

        # update (u,p,l,w) according to the equilibrium conditions
        u₁ = (w₀ ./ p₀) .^ (β / ρ) .* (κn' * u₀) .^ β
        p₁ = (τn * caux(w₀, p₀) .^ -θ) .^ (-1 / θ)
        l₁ = sharefunc(κn' .* repeat(u₀', N))' * l₀
        w₁ = (sharefunc(paux(w₀, p₀))' * (l₀ .* w₀)) ./ l₀

        # normalize population shares and wages 
        l₁ = l₁ / sum(l₁)
        w₁ = w₁ ./ sum(l₁ .* w₁)

        # new guess for X
        newX = [p₁ w₁ l₁ u₁]

        # update the gap
        gap = maximum(abs.(newX .- X))

        # update the old guess of X
        X = copy(newX)

        if displaygap
            println("Convergence: gap = ", gap, " iter = ", iter)
        end
    end

    if displaysummary
        if iter < maxiter
            println("Successful convergence in ", iter, " iterations.")
        else
            println("Maximum number of iterations reached.")
        end
    end

    # get final values
    p₁ = X[:, 1]
    w₁ = X[:, 2]
    l₁ = X[:, 3]
    u₁ = X[:, 4]

    return w₁, l₁, (ρ / β) * log.(u₁), p2χss(w₁, p₁)

end

# auxiliary function to divide each cell of a matrix by the sum of its row
sharefunc(x::Matrix; dims=2) = x ./ sum(x, dims=dims)

# compute steady-state wages, employment, workers' utility, and capital-labor ratios
wss, lss, vss, χss = steadystate(fundamentals, [β, ρ, θ, μ, δ])
# compute steady-state labor income (recall that total income is given by labor income divided by μ)
qss = wss .* lss
# compute steady-state expenditure and income shares matrices S and T
S = sharefunc((repeat(wss' .* (χss' .^ (μ - 1.0)) ./ z', N) .* τ) .^ (-θ))
T = (S' .* repeat(qss', N)) ./ repeat(qss, 1, N)
# compute steady-state out-migration and in-migration matrices D and E
D = sharefunc((exp.(β * repeat(vss', N)) ./ κ) .^ (1 / ρ))
E = (D' .* repeat(lss', N)) ./ repeat(lss, 1, N)

#==================================================#
# Compute P and R marices
#==================================================#

### compute intermediate matrices as in the toolkit note

# Note: the auxiliary matrix repeat(qss', N) imposes our numeraire, that the total labor income in all locations stays constant and is invariant to shocks
O = (I - T + θ * (I - T * S) + repeat(qss', N))^-1 # O is an auxiliary matrix that enters the definitions of A and B
A = -(I - S) * O * (I - T)
B = (1 - μ) * (S + θ * (I - S) * O * (I - T * S))
C = S + θ * (I - S) * O * (I - T * S)
H = ψ * (1 - β) * (1 - β * (1 - δ)) * C

### compute Γ matrix
# Note: the auxiliary matrix repeat(lss', N) imposes the condition that the total population stays constant and is invariant to shocks
Υ₁₁ = β * D * (I - E * D + repeat(lss', N))^-1 * E + (I - E * D + repeat(lss', N))^-1 - (β / ρ) * A
Υ₁₂ = -(β / ρ) * B
Υ₂₁ = ((1 + β) * I - (1 - β * (1 - δ)) * (ψ - 1 - β * ψ) * A)
Υ₂₂ = (1 + β) * I - (1 - β * (1 - δ)) * (ψ - 1 - β * ψ) * (B - I)
Γ = [Υ₁₁ Υ₁₂; (Υ₂₁)*(I-repeat(lss', N)) (Υ₂₂)]

### compute Θ matrix
Θ₁₁ = -(I - E * D + repeat(lss', N))^-1 * E
Θ₂₁ = (-I - (1 - β * (1 - δ)) * A)
Θ₂₂ = -I - (1 - β * (1 - δ)) * (B - I)
Θ = [Θ₁₁ zeros(N, N); (Θ₂₁)*(I-repeat(lss', N)) (Θ₂₂)]

### compute Ψ matrix
Ψ = [(β*D)*(I-E*D+repeat(lss', N))^-1 zeros(N, N); β*(I-repeat(lss', N)) β*diagm(ones(N))]

### compute Π matrix
Π = [-(β / ρ)*C -(β / ρ)*I; -H zeros(N, N)]

### solve the matrix system of quadratic equations ΨP²-ΓP-Θ=0 to get P
Ξ = [Γ Θ; I zeros(2 * N, 2 * N)]
Δ = [Ψ zeros(2 * N, 2 * N); zeros(2 * N, 2 * N) I]
eigresults = eigen(Δ^-1 * Ξ, sortby=abs)
Λ = diagm(abs.(eigresults.values[1:2*N]))
Ω = eigresults.vectors[2*N+1:4*N, 1:2*N]
P = real(Ω * Λ * (Ω^-1))

# get the R matrix from the equation R=(ΨP+Ψ-Γ)^-1*Π
R = (Ψ * P + Ψ - Γ)^-1 * Π

# normalize the matrices to ensure that the sum of population is equal to 1
auxnorm = [repeat(lss', N) zeros(N, N); zeros(N, N) zeros(N, N)]
P = (I - auxnorm) * P
R = (I - auxnorm) * R

#==================================================#
# Speed of Convergence
#==================================================#

# compute eigenshocks (each column of the matrix F is a different eigenshock)
F = (Π + auxnorm)^-1 * (Ψ * P + Ψ - Γ) * eigen(P).vectors

# compute eigenvalues
λ = eigen((I - auxnorm) * P).values

# compute halflifes of eigenshocks (multiply by 5 since the model's period is 5 years)
hl = -5 * (log(2) ./ log.(λ[2:end]))

# plot halflifes across all eigenshocks
Plots.scatter(hl, xlabel="Eigenshock", ylabel="Halflife", legend=false)

#==================================================#
# Transition path following a general shock
#==================================================#

### choose the shock

# choose region to shock (i∈{1,...,N})
i = 1

# choose whether to shock productivity (shock_prod = true) and/or amenities (shock_amen = true) 
shock_prod = true
shock_amen = false
# choose magnitude of shock (in % of steady-state level)
magnitude_prod = 0.1
magnitude_amen = 0.1
# choose number of periods
T = 200

### generate the shock 
f̃ = zeros(2 * N)
if shock_prod
    f̃[i] = magnitude_prod
end
if shock_amen
    f̃[N+i] = magnitude_amen
end

### compute transition of state variables (labor - first N entries; capital-labor-ratios - last N entries)
x̃ = cumsum([P^s * R * f̃ for s = 0:T-1])
# transition for deviations of population from initial steadystate
l̃ = hcat(x̃...)[1:N, :]
# transition for deviations of capital from initial steadystate (recall that the second state variable is capital-labor ratios)
k̃ = hcat(x̃...)[N+1:end, :] + l̃

### plot transition of state variables
otherinds = (1:N)[(1:N).!=i] # indices for non-shocked regions

plt1 = plot(l̃[i, :], color=:black, title="Labor - shocked region");
hline!([0], line=:dash, color=:red);
plt2 = plot(k̃[i, :], color=:black, title="Capital - shocked region");
hline!([0], line=:dash, color=:red);
plt3 = plot(l̃[otherinds, :]', color=:gray, title="Labor - other regions");
hline!([0], line=:dash, color=:red);
plt4 = plot(k̃[otherinds, :]', color=:gray, title="Capital - other regions");
hline!([0], line=:dash, color=:red);
plot(plt1, plt2, plt3, plt4, legend=false);
ylabel!("Log-deviation from steady-state");
xlabel!("Period");
plot!(titlefont=10, legendfont=8, ytickfont=6, xtickfont=6, yguidefontsize=6, xguidefontsize=6)
