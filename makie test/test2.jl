using GLMakie
GLMakie.activate!()

# data values
x = range(0, 10, length = 10)
y = sin.(x)

# create the figure and set axis aspect = equal
# https://docs.makie.org/stable/documentation/figure/
# https://docs.makie.org/stable/examples/blocks/axis/index.html#controlling_axis_aspect_ratios
# https://docs.makie.org/stable/examples/blocks/axis3/index.html#data_aspects_and_view_mode
f = Figure()
ax = Axis3(f[1, 1], aspect = :data)

# plot lines
lines!(ax, x, y, y)

# use the data inspector (show the data value tooltip when hovering the mouse over the line)
# https://docs.makie.org/stable/documentation/inspector/
inspector = DataInspector(f)

# display the figure
# https://docs.makie.org/stable/documentation/backends/glmakie/index.html
#f                           # displays the figure in the current window? creates one if there is none?
display(GLMakie.Screen(), f) # displays the figure in a new window. allows for multiple windows.
reset_limits!(ax)            # when displaying in a new window, the axis may be displayed wrong.
                             # resetting it can correct the problem.

###################
# more references
# https://juliadatascience.io/datavisMakie_attributes
# https://discourse.julialang.org/t/makie-is-there-an-easy-way-to-combine-several-figures-into-a-new-figure-without-re-plotting/64874/4
