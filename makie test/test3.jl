using GLMakie
GLMakie.activate!()

# minimal example for 2D lines

x = range(0, 10, length = 10)
y = sin.(x)

lines(x, y)  # creates a new figure
lines!(y, x) # uses the previous figure

DataInspector()
current_axis().aspect = DataAspect()
current_figure()
