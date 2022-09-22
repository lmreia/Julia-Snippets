using GLMakie
using LinearAlgebra

# 3D projection on 2D plane

# 3D cube in homogeneous coordinates
cube3d = [
    #face 1
    0 0 0 1 #point 1
    1 0 0 1 #point 2
    1 1 0 1 #point 3
    0 1 0 1 #point 4
    0 0 0 1 #point 1
    #face 2
    0 0 0 1
    1 0 0 1
    1 0 1 1
    0 0 1 1
    0 0 0 1
    #face 3
    0 0 0 1
    0 1 0 1
    0 1 1 1
    0 0 1 1
    0 0 0 1
    #face 4
    0 0 1 1
    1 0 1 1
    1 1 1 1
    0 1 1 1
    0 0 1 1
    #face 5
    0 1 0 1
    1 1 0 1
    1 1 1 1
    0 1 1 1
    0 1 0 1
    #face 6
    1 0 0 1
    1 1 0 1
    1 1 1 1
    1 0 1 1
    1 0 0 1
]

# 2D plane in 3D space
# represented by two 3D vectors
pv1 = [1; 0; 0]
pv2 = [0; 1; 0]
pv1 = pv1 ./ sqrt(sum(pv1.^2))
pv2 = pv2 ./ sqrt(sum(pv2.^2))

# normal vector of the plane
nv = cross(pv1, pv2)

# project the cube vertices on the normal
proj_n = x = cube3d[:,1:end-1] * nv

# moves the center of the cube to the origin
cube3d =  cube3d * [1 0 0 -0.5; 
                    0 1 0 -0.5; 
                    0 0 1 -0.5; 
                    0 0 0    1]'

# make the vertices look "bigger" the closer they are to the plane (the proj_n is lower)
for i = 1:size(cube3d)[1]
    amplification = (1.0 - proj_n[i]) + 0.5 
    for j = 1:size(cube3d)[2]-1
        cube3d[i,j] = cube3d[i,j] / (1 + amplification * (1 - cube3d[i,j] * nv[j]))
                                                         # amplification is applied only to the coordinate 
                                                         # perpendicular to the normal of the plane
                                                         # 1 - dot product: [0,...,0,cube3d[i,j],0,...,0] . nv
    end
end

# projecting the cube on the plane
x = cube3d[:,1:end-1] * pv1
y = cube3d[:,1:end-1] * pv2

fig = Figure()
ax = Axis(fig[1,1])
ax.aspect = DataAspect()
DataInspector(fig)

for i = 0:5
    lines!(ax, x[i*5+1:i*5+5], y[i*5+1:i*5+5])
end

reset_limits!(ax)
fig