import numpy as np
import cvxpy as cp
import matplotlib.pyplot as plt

# DC motor parameters
J = 0.018256
b = 0.168599
kt = 1.595349
kb = 1.56749
R = 1.746171
L = 0  

# State-space matrices (simplified for L = 0 case)
A = np.array([[-b / J, kt / J], [-kb / R, -1]])
B = np.array([[0], [1 / R]])

# MPC parameters
N = 10  # Prediction horizon
x_dim = A.shape[0]  # Number of states
u_dim = B.shape[1]  # Number of control inputs

# Constraints and reference
x0 = np.array([[0], [0]])  # Initial state: [omega, i]
x_ref = np.array([[100], [0]])  # Desired state: [omega_ref, i_ref]

u_max = 24.0  # Max voltage (e.g., 24V)
u_min = -24.0  # Min voltage (e.g., -24V)

# Optimization variables
x = cp.Variable((x_dim, N + 1))
u = cp.Variable((u_dim, N))

# Define the cost function and constraints
cost = 0
constraints = [x[:, 0] == x0.flatten()]

for t in range(N):
    # Quadratic cost: penalize state deviation and control effort
    cost += cp.sum_squares(x[:, t] - x_ref.flatten())
    cost += cp.sum_squares(u[:, t])
    
    # Dynamics constraint: x_{t+1} = A * x_t + B * u_t
    constraints += [x[:, t + 1] == A @ x[:, t] + B @ u[:, t]]
    
    # Input constraints
    constraints += [u_min <= u[:, t], u[:, t] <= u_max]

# Solve the optimization problem
problem = cp.Problem(cp.Minimize(cost), constraints)
problem.solve()

# Extract and print results
u_opt = u.value
x_opt = x.value

print("Optimal control inputs (voltages):")
print(u_opt)
print("\nOptimal state trajectory:")
print(x_opt)

# Plotting
time = np.arange(N + 1)

# Plot state trajectory (omega and i)
plt.figure(figsize=(10, 6))
plt.plot(time, x_opt[0, :], label="Angular Velocity (ω)")
plt.plot(time, x_opt[1, :], label="Current (i)")
plt.axhline(x_ref[0, 0], color='r', linestyle='--', label="Reference ω")
plt.xlabel("Time Step")
plt.ylabel("State")
plt.title("Optimal State Trajectory")
plt.legend()
plt.grid()

# Plot control inputs
plt.figure(figsize=(10, 6))
plt.step(range(N), u_opt[0, :], where='post', label="Control Input (Voltage)")
plt.axhline(u_max, color='r', linestyle='--', label="Max Voltage")
plt.axhline(u_min, color='r', linestyle='--', label="Min Voltage")
plt.xlabel("Time Step")
plt.ylabel("Control Input (V)")
plt.title("Optimal Control Input")
plt.legend()
plt.grid()

plt.show()