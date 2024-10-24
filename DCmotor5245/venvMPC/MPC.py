#command [code .]to use venv in parrent folder in VS code
import numpy as np
import cvxpy as cp

# Define system dynamics (A, B matrices for the state-space model)
A = np.array([[1.0, 1.0], [0, 1.0]])  # State transition matrix
B = np.array([[0.5], [1.0]])          # Control input matrix

# MPC parameters
N = 10  # Prediction horizon
x_dim = A.shape[0]  # Number of states
u_dim = B.shape[1]  # Number of control inputs

# Constraints and objective coefficients
x0 = np.array([[0], [0]])  # Initial state
x_ref = np.array([[5], [0]])  # Reference state we want to reach

u_max = 1.0  # Maximum control input
u_min = -1.0  # Minimum control input

# Define optimization variables
x = cp.Variable((x_dim, N + 1))
u = cp.Variable((u_dim, N))

# Define the cost function (objective)
cost = 0
constraints = [x[:, 0] == x0.flatten()]

# Define cost and constraints over the prediction horizon
for t in range(N):
    # Quadratic cost (penalize distance from reference state and control effort)
    cost += cp.sum_squares(x[:, t] - x_ref.flatten())
    cost += cp.sum_squares(u[:, t])
    
    # Dynamics constraint: x_{t+1} = A * x_t + B * u_t
    constraints += [x[:, t + 1] == A @ x[:, t] + B @ u[:, t]]
    
    # Input constraints
    constraints += [u_min <= u[:, t], u[:, t] <= u_max]

# Define and solve the optimization problem
problem = cp.Problem(cp.Minimize(cost), constraints)
problem.solve()

# Extract and print the optimal control sequence
u_opt = u.value
print("Optimal control inputs:")
print(u_opt)

# Extract and print the optimal state trajectory
x_opt = x.value
print("Optimal state trajectory:")
print(x_opt)
