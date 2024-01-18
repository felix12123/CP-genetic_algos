using Plots
using DelimitedFiles
using Statistics
using LaTeXStrings
using Metaheuristics





# Lese Daten ein

data = readdlm("data/lichtkurve.csv", ';', header=true)[1]
x = data[:, 1]
y = data[:, 2]





# ************************
# ***** Lineare Fits *****
# ************************


# Fit-Funktion
function lin_fit(a_k::Vector{Float64}, x::Float64)::Float64
    return a_k[1]*x+a_k[2]
end


# Merit-Funktion
function lin_Χ(a_k::Vector{Float64})::Float64

    sum = 0
    σ = 5

    for i in 1:200
        sum += ((lin_fit(a_k, x[i]) - y[i]) / σ)^2
    end
    
    return sum
end


# Fitness-Funktion
function lin_fitness(a_k::Vector{Float64})::Float64
    return -1/lin_Χ(a_k)
end


# Eingrenzung der Parameter
lin_bounds=Matrix{Float64}(undef, 2,2)
lin_bounds[1,1] = 0.0
lin_bounds[2,1] = 10.0
lin_bounds[1,2] = 0.0
lin_bounds[2,2] = 100.0





# **********************
# ***** Sinus Fits *****
# **********************


# Fit-Funktion
function sin_fit(a_k::Vector{Float64}, x::Float64)::Float64

    sum = a_k[1]*x+a_k[2]

    for i in 3:3:M*3
        sum += a_k[i] * sin(2π * ((x/a_k[i+1]) + a_k[i+2]))
    end

    return sum
end


# Merit-Funktion
function sin_Χ(a_k::Vector{Float64})::Float64

    sum = 0
    σ = 5
 
    for i in 1:200

        sum1 = 0

        for j in 3:3:(size(a_k, 1)-2)
            sum1 += a_k[j] * sin(2*π * ((x[i] / a_k[j+1]) + a_k[j+2]))
        end

        sum += ((a_k[1]*x[i] + a_k[2] + sum1 - y[i]) / σ)^2
    end

    return sum
end

# Alte Merit-Funktion für Sinus-Fit
# function sin_Χ(a_k::Vector{Float64})::Float64
    # sum = 0
    # σ = 5
    # for i in 1:200
        # sum += ((sin_fit(a_k, x[i]) - y[i]) / σ)^2
    # end 
    # return sum
# end


# Fitness-Funktion
function sin_fitness(a_k::Vector{Float64})::Float64
    return -1/sin_Χ(a_k)
end


# Eingrenzung der Parameter für Sinus-Fit
M = 1
sin_bounds=Matrix{Float64}(undef, 2,(2+3*M))
sin_bounds[1,1] = 0.0
sin_bounds[2,1] = 10.0
sin_bounds[1,2] = 0.0
sin_bounds[2,2] = 100.0
for i in 3:3:(size(sin_bounds, 2)-2)
    sin_bounds[1,i]   = 0.0
    sin_bounds[2,i]   = 100.0
    sin_bounds[1,i+1] = 1.00502514
    sin_bounds[2,i+1] = 50.0
    sin_bounds[1,i+2] = 0.0
    sin_bounds[2,i+2] = 1.0
end





# *************************************************************
# ***** Nutze gen. Algo. für Ermittlung von Fitparametern *****
# *************************************************************

function genetics(fitness_function::Function)

    # Wähle Randbedinungen 
    if fitness_function == lin_fitness
        bounds = lin_bounds
    elseif fitness_function == sin_fitness
        bounds = sin_bounds
    end

    # Führe Optimierung, basierend auf dem "Evolutionary Centers Algorithm", mit Standardoptionen aus
    options = Options(seed=1)
    result  = optimize(fitness_function, bounds, ECA(options=options))
    x = minimizer(result)

    # Konsolenausgabe
    println("Χ^2 = ", sin_Χ(x))
    println("a = ", x[1], "     b = ", x[2])
    for i in 3:3:(size(x,1)-2)
        println("A_m = ", x[i] ,"     P_m = ", x[i+1], "     Φ_m = ", x[i+2])
    end
    
    # Gebe Fitparameter aus
    return x
end





# ****************************************
# ***** Generiere Plots für lin. Fit *****
# ****************************************

# a,b = genetics(lin_fitness)
# scatter(x, y, label="Messdaten", marker=:xcross, markersize=3, markerstrokewidth=2, markercolor=:black, xlabel=L"t", ylabel=L"f(t)")
# plot!(x, map(xs -> a*xs+b, x), linewidth=2, linecolor=:orange, linealpha=0.5, label=L"Fit: $a \cdot t + b$")
# savefig("media/A5/lin_fit.png")





# ****************************************
# ***** Generiere Plots für Sin. Fit *****
# ****************************************

params = genetics(sin_fitness)
y1     = deepcopy(y)

for i in 1:length(y1)
   y1[i] = params[1]*x[i]+params[2] + params[3]*sin(2*π * (x[i]/params[4] + params[5]))
end
scatter(x, y, label="Messdaten", marker=:xcross, markersize=3, markerstrokewidth=2, markercolor=:black, xlabel=L"t", ylabel=L"f(t)", dpi=300)
plot!(x, y1, linewidth=2, linecolor=:orange, linealpha=0.5, label=L"$a \cdot t + b + A\cdot\sin \left[ 2\pi \cdot \left( \frac{t}{P} + \Phi \right) \right]$", dpi=300, foreground_color_legend = nothing, grid=false, legendfontsize=7) # , background_color_legend=nothing
savefig("media/A5/sin_fit_M1.png")

# for i in 1:length(y1)
#    y1[i] = params[1]*x[i]+params[2] + params[3]*sin(2*π * (x[i]/params[4] + params[5])) + params[6]*sin(2*π * (x[i]/params[7] + params[8]))
# end
# scatter(x, y, label="Messdaten", marker=:xcross, markersize=3, markerstrokewidth=2, markercolor=:black, xlabel=L"t", ylabel=L"f(t)", dpi=300)
# plot!(x, y1, linewidth=2, linecolor=:orange, linealpha=0.5, label=L"$a \cdot t + b + \sum_{m=1}^{3}A_m\cdot\sin \left[ 2\pi \cdot \left( \frac{t}{P_m} + \Phi_m \right) \right]$", dpi=300, foreground_color_legend = nothing, grid=false, legendfontsize=7) # , background_color_legend=nothing
# savefig("media/A5/sin_fit_M3.png")

# for i in 1:length(y1)
#    y1[i] = params[1]*x[i]+params[2] + params[3]*sin(2*π * (x[i]/params[4] + params[5])) + params[6]*sin(2*π * (x[i]/params[7] + params[8])) + params[9]*sin(2*π * (x[i]/params[10] + params[11]))
# end
# scatter(x, y, label="Messdaten", marker=:xcross, markersize=3, markerstrokewidth=2, markercolor=:black, xlabel=L"t", ylabel=L"f(t)", dpi=300)
# plot!(x, y1, linewidth=2, linecolor=:orange, linealpha=0.5, label=L"$a \cdot t + b + \sum_{m=1}^{5}A_m\cdot\sin \left[ 2\pi \cdot \left( \frac{t}{P_m} + \Phi_m \right) \right]$", dpi=300, foreground_color_legend = nothing, grid=false, legendfontsize=7) # , background_color_legend=nothing
# savefig("media/A5/sin_fit_M5.png")