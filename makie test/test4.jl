using GLMakie

# animation

GLMakie.closeall()

x = range(0, 10, length = 100)
f = 1
w = 2 * pi * f

fig = Figure()
ax = Axis(fig[1,1])
ax.aspect = DataAspect()

display(GLMakie.Screen(), fig)

for t = 0:0.01:10
    # https://github.com/MakieOrg/Makie.jl/pull/1818
    # https://docs.makie.org/stable/examples/blocks/axis/index.html#deleting_plots
    empty!(ax)

    y = sin.(x .+ w * t)
    lines!(ax, x, y, color = :blue)

    sleep(0.001)
end

