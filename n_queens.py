import matplotlib.pyplot as plt

# -----------------------------
# Data
# -----------------------------
x = [1,2,3,4,5,6,7,8]
y = [1,2,3,4,5,6,7,8]
z = [1,7,4,6,8,2,5,3]

points = list(zip(x, y, z))
point_set = set(points)

# bounds
MIN, MAX = 1, 8

# all 3D queen directions (26 directions)
directions = [
    (dx, dy, dz)
    for dx in (-1, 0, 1)
    for dy in (-1, 0, 1)
    for dz in (-1, 0, 1)
    if not (dx == 0 and dy == 0 and dz == 0)
]

# -----------------------------
# DETECT ATTACKS
# -----------------------------
attacked = set()

for (x0, y0, z0) in points:
    for dx, dy, dz in directions:

        cx, cy, cz = x0, y0, z0   # renamed (critical fix)

        while True:
            nx, ny, nz = cx + dx, cy + dy, cz + dz

            if nx < MIN or nx > MAX or ny < MIN or ny > MAX or nz < MIN or nz > MAX:
                break

            cx, cy, cz = nx, ny, nz

            if (cx, cy, cz) in point_set and (cx, cy, cz) != (x0, y0, z0):
                attacked.add((cx, cy, cz))

# -----------------------------
# PLOT
# -----------------------------
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

colors = ['red' if p in attacked else 'black' for p in points]

ax.scatter(x, y, z, s=140, c=colors)

for i, (xi, yi, zi) in enumerate(points):
    ax.text(xi, yi, zi, str(i+1), color='black')

# -----------------------------
# QUEEN RAYS (ALL RED)
# -----------------------------
for (x0, y0, z0) in points:
    for dx, dy, dz in directions:

        cx, cy, cz = x0, y0, z0   # renamed here too

        while True:
            nx, ny, nz = cx + dx, cy + dy, cz + dz

            if nx < MIN or nx > MAX or ny < MIN or ny > MAX or nz < MIN or nz > MAX:
                break

            prev = (cx, cy, cz)
            cx, cy, cz = nx, ny, nz

            ax.plot(
                [prev[0], cx],
                [prev[1], cy],
                [prev[2], cz],
                color="red",
                linewidth=0.8,
                alpha=0.6
            )

# -----------------------------
# Styling
# -----------------------------
ax.set_xlabel("X")
ax.set_ylabel("Y")
ax.set_zlabel("Z")
ax.set_title("3D Queen Attack Map (Blue = Attacked)")

plt.show()