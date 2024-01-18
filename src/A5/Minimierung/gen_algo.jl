using Metaheuristics
using Plots


# Verwende die negativen Altituden als Fitness-Funktionen

function konz_wellen(X)
    rr::BigFloat = (X[1]-0.5)^2 + (X[2]-0.5)^2
    return -cos(9*π*sqrt(rr))^2*exp(-rr/0.15)
end

function gauss_packs(X)
    rr1::BigFloat = (X[1]-0.5)^2 + (X[2]-0.5)^2
    rr2::BigFloat = (X[1]-0.6)^2 + (X[2]-0.1)^2
    return -((0.8 * exp(-rr1 / 0.3^2)) + (0.879008 * exp(-rr2 / 0.03^2)))
end


# Nutze ECA (Evolutionary Centers Algorithm) zur Optimierung

function genetics(fitness_function, name)

    # Grenzen festlegen 
    if fitness_function == konz_wellen
        bounds=Matrix{Float64}(undef, 2,2)
        bounds[1,1] = 0.49
        bounds[2,1] = 0.51
        bounds[1,2] = 0.49
        bounds[2,2] = 0.51
    elseif fitness_function == gauss_packs
        bounds=Matrix{Float64}(undef, 2,2)
        bounds[1,1] = 0.5
        bounds[2,1] = 0.7
        bounds[1,2] = 0.0
        bounds[2,2] = 0.2
    end

    # Nutze Standardoptionen für den "Evolutionary Centers Algorithm"
    options = Options(seed=1)

    # Führe Optimierung aus, basierend auf dem "Evolutionary Centers Algorithm"
    result = optimize(fitness_function, bounds, ECA(options=options))

    # Trage Punkte in Diagramm ein
    X = positions(result)
    scatter(X[:,1], X[:,2], marker=:xcross, markersize=3, markerstrokewidth=2, markercolor=:black, markeralpha=0.5, label="Population", dpi=300)
    x = minimizer(result)
    scatter!(x[1:1], x[2:2], marker=:xcross, markersize=3, markerstrokewidth=2, markercolor=:orange, label="Beste Lösung")

    # Konsolenausgabe
    println("Beste Lösung für ", name, " : x = ", x[1], " y = ", x[2])

    # Speichere Bild
    savefig(name * ".png")
end


# Funktion zur Generierung der Plots der Funktionen

function function_plots()

    # x- und y-Werte
    x=0:1/999:1
    y=0:1/999:1

    # (x,y)-Grid
    grid = reshape([[x[i], y[j]] for i in 1:1000 for j in 1:1000], 1000, 1000)
    
    # z-Werte durch Funktionsaufrufe
    z_wellen = -konz_wellen.(grid)
    z_gauss  = -gauss_packs.(grid)

    # Generiere und speichere Plots
    surface(x,y,z_wellen, dpi=300)
    savefig("media/A5/P1_PLOT.png")
    surface(x,y,z_gauss, dpi=300)
    savefig("media/A5/P2_PLOT.png")
end





# Aufrufe der Funktionen

function_plots()
genetics(konz_wellen, "P1")
genetics(gauss_packs, "P2")