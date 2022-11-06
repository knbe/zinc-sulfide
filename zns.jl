@time begin
	println("loading packages")
	using GLMakie
end

a = 1		# lattice constant
s = 3		# scale (number of unit cells)²
N = s^3		# total number of lattice points

println("")

# x,y,z unit vectors
xhat = [1,0,0]
yhat = [0,1,0]
zhat = [0,0,1]

# primitive lattice vectors
a₁ = xhat.*a
a₂ = yhat.*a
a₃ = zhat.*a

# basis (conventional)
Zn = [[0,0,0], [a/2,a/2,0], [a/2,0,a/2], [0,a/2,a/2]]
S = [[a/4,a/4,3a/4], [a/4,3a/4,a/4], [3a/4,a/4,a/4], [3a/4,3a/4,3a/4]]

function lattice_point(n₁,n₂,n₃)
	point = a₁.*n₁ + a₂.*n₂ + a₃.*n₃
	return point
end

function zn_points(LP)
	points = [ [LP + Zn[1]], [LP + Zn[2]], [LP + Zn[3]], [LP + Zn[4]] ]
	return points
end

# construct array of lattice points
# L should be a set of N 3-tuples
L = [ lattice_point(i,j,k) for i=0:(s-1) for j=0:(s-1) for k=0:(s-1) ]
#

#for n=1:N
#	println("n=", n)
#	println("L=", L[n])
#	println("   Zn=", zn_points(L[n]))
#end

ZZZ = [ zn_points(L[n]) for n=1:N ]

#
L_xyz = [ [L[n][1] for n=1:N],  [L[n][2] for n=1:N], [L[n][3] for n=1:N] ]
#
Zn1_xyz = [ [ZZZ[n][1][1][1] for n=1:N], [ZZZ[n][1][1][2] for n=1:N], [ZZZ[n][1][1][3] for n=1:N] ]
Zn2_xyz = [ [ZZZ[n][2][1][1] for n=1:N], [ZZZ[n][2][1][2] for n=1:N], [ZZZ[n][2][1][3] for n=1:N] ]
Zn3_xyz = [ [ZZZ[n][3][1][1] for n=1:N], [ZZZ[n][3][1][2] for n=1:N], [ZZZ[n][3][1][3] for n=1:N] ]
Zn4_xyz = [ [ZZZ[n][4][1][1] for n=1:N], [ZZZ[n][4][1][2] for n=1:N], [ZZZ[n][4][1][3] for n=1:N] ]
#

struct Lattice
	L::Vector{Vector{Int64}}
	Zn1::Vector{Vector{Float64}}
	Zn2::Vector{Vector{Float64}}
	Zn3::Vector{Vector{Float64}}
	Zn4::Vector{Vector{Float64}}
end

lattice = Lattice(L_xyz, Zn1_xyz, Zn2_xyz, Zn3_xyz, Zn4_xyz)

#println(lattice.Zn2[1])

function make_fig()
	GLMakie.activate!()

	fig = Figure(resolution=(1200,1000))
	ax = Axis3(fig[1,1]; aspect=(1,1,1), perspectiveness=0.4)
	meshscatter!(ax, Zn1_xyz[1], Zn1_xyz[2], Zn1_xyz[3]; markersize=.04)
	#meshscatter!(ax, Zn1x, Zn1y, Zn1z; markersize=.06)
	save("zns.png", fig)
end

make_fig()
