using GLMakie

# 4D projection on 2D plane

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

# creating the 4D hypercube
# a 4D hypercube can be created from 8 3D cubes
nrows = size(cube3d)[1]
ncols = size(cube3d)[2]
cube4d = zeros((nrows * 8, ncols + 1))
for i = 0:7
    c = mod(i, 4) + 1
    e = floor(Int, i/4)
    if c == 1
        cube4d[i*nrows+1:i*nrows+nrows,:] = hcat(ones((nrows, 1)) * e, cube3d)
    elseif c == 5
        cube4d[i*nrows+1:i*nrows+nrows,:] = hcat(cube3d, ones((nrows, 1)) * e)
    else
        cube4d[i*nrows+1:i*nrows+nrows,:] = hcat(cube3d[:,1:c-1], ones((nrows, 1)) * e, cube3d[:,c:end])
    end
end

# 2D plane in 4D space
# represented by two 4D vectors and one point
pc  = [0; 0; 0; 0]
pv1 = [1; 1; 0; 1]
pv2 = [0; 0; 1; 0]
pv1 = pv1 ./ sqrt(sum(pv1.^2))
pv2 = pv2 ./ sqrt(sum(pv2.^2))

# normal vector of the plane
# average of normals from coordinates combined 2 by 2
# does this even make sense?
nv = zeros(size(pv1))
#1 1 1 0
#1 0 1 1
#1 1 0 1
#0 1 1 1
nv[[1,2,3],:] = nv[[1,2,3],:] + cross(pv1[[1,2,3],:][:], pv2[[1,2,3],:][:])
nv[[1,3,4],:] = nv[[1,3,4],:] + cross(pv1[[1,3,4],:][:], pv2[[1,3,4],:][:])
nv[[1,2,4],:] = nv[[1,2,4],:] + cross(pv1[[1,2,4],:][:], pv2[[1,2,4],:][:])
nv[[2,3,4],:] = nv[[2,3,4],:] + cross(pv1[[2,3,4],:][:], pv2[[2,3,4],:][:])
nv = nv ./ sqrt(sum(nv.^2))

# project the cube vertices on the normal
proj_n = zeros((size(cube4d)[1]))
for i = 1:size(proj_n)[1]
    proj_n[i] = (cube4d[i,1:end-1] - pc)' * nv
end

# moves the center of the cube to the origin
cube4d =  cube4d * [1 0 0 0 -0.5; 
                    0 1 0 0 -0.5; 
                    0 0 1 0 -0.5; 
                    0 0 0 1 -0.5; 
                    0 0 0 0    1]'

# make the vertices look "bigger" the closer they are to the plane (the proj_n is lower)
for i = 1:size(cube4d)[1]
    amplification =  1.0 / (1.0 + proj_n[i])
    for j = 1:size(cube4d)[2]-1
        cube4d[i,j] = cube4d[i,j] / (1 + amplification * (1 - cube4d[i,j] * nv[j]))
                                                         # amplification is applied only to the coordinate 
                                                         # perpendicular to the normal of the plane
                                                         # 1 - dot product: [0,...,0,cube4d[i,j],0,...,0] . nv
    end
end

# projecting the cube on the plane
x = cube4d[:,1:end-1] * pv1
y = cube4d[:,1:end-1] * pv2

fig = Figure()
ax = Axis(fig[1,1])
ax.aspect = DataAspect()

for j = 0:7 # cubes
    for i = 0:5 # faces
        lines!(ax, x[j*nrows+i*5+1:j*nrows+i*5+5], y[(j*nrows+i*5+1:j*nrows+i*5+5)])
    end
end

reset_limits!(ax)
fig