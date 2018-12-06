import pyomo.environ as pe
import scipy
import matplotlib.pyplot as plt
import numpy as np

prob_of_LS = []
prob_of_HS = []
for iteration in range(100):
    if iteration%10 == 0:
        print(iteration)
    conValue = iteration * 0.1
    c = [5, 10, 35, 25]
    # Create the model
    model = pe.ConcreteModel()

    model.dual = pe.Suffix(direction = pe.Suffix.IMPORT)

    # ------ SETS ---------
    model.variable = pe.Set(initialize = range(4))
    model.states = pe.Set(initialize = range(2))
    # ------PARAMETERS--------

    # -------------VARIABLES------------
    model.x = pe.Var(model.variable, domain = pe.NonNegativeReals)

    # ------CONSTRAINTS-----------
    def rule_1(model, state):
        if state == 0:
            lhs = model.x[0] + model.x[1]
            rhs = 0.3 * model.x[0] + 0.5 * model.x[1] + 0.8 * model.x[2] + 0.4 * model.x[3]
            return lhs == rhs
        if state == 1:
            lhs = model.x[2] + model.x[3]
            rhs = 0.7 * model.x[0] + 0.5 * model.x[1] + 0.2 * model.x[2] + 0.6 * model.x[3]
            return lhs == rhs
    model.ruleCons1 = pe.Constraint(model.states, rule = rule_1)

    def rule_2(model):  
        return sum(model.x[i] for i in range(4)) == 1
    model.ruleCons2 = pe.Constraint(rule = rule_2)

    # This constraint is for (c)
    def rule_3(model):
        return 15 * (model.x[0] + model.x[2]) <= conValue
    model.ruleCons3 = pe.Constraint(rule = rule_3)
    # ------OBJECTIVE-----------

    def obj_rule(model):
        return sum(model.x[i]*c[i] for i in range(4))
        
    model.OBJ = pe.Objective(rule = obj_rule, sense = pe.maximize)

    #----------SOLVING----------
    solver = pe.SolverFactory('gurobi') # Specify Solver

    results = solver.solve(model, tee = False, keepfiles = False)

    prob_of_LS.append(model.x[0].value / (model.x[0].value + model.x[1].value))
    prob_of_HS.append(model.x[2].value / (model.x[2].value + model.x[3].value))
    # print()
    # print("Status:", results.solver.status)
    # print("Termination Condition:", results.solver.termination_condition)
    # print("\nObjective function value: ", model.OBJ())
    # print("\n q(L,S) = %.3f, q(L,D) = %.3f, q(H,S) = %.3f, q(H,D) = %.3f"%(model.x[0].value,model.x[1].value,model.x[2].value,model.x[3].value))

x = np.arange(0,10,0.1)
plt.title('Policy Versus the Cost Constraint')
plt.xlabel('Constraint of average cost per stage of SEND')
plt.ylabel('Probability of SEND')
plt.plot(x, prob_of_LS,'--', label = "Low")
plt.plot(x, prob_of_HS,'-', label = "High")
plt.legend()
plt.savefig("problem1c.png")
plt.show()