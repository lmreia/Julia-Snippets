using GLMakie
GLMakie.activate!()

x = range(0, 10, length=100)
y = sin.(x)
#fig, = scatterlines(x, y, marker = :cross)
fig, = lines(x, y, y)
inspector = DataInspector(fig)
fig
