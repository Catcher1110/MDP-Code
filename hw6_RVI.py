hH = [0]
hL = 0
epsilon = 0.1
while(1):
    temphH = max(35 + 0.8 * hL + 0.2 * hH[-1], 25 + 0.4 * hL + 0.6 * hH[-1]) -\
            max(5 + 0.3 * hL + 0.7 * hH[-1], 10 + 0.5 * hL + 0.5 * hH[-1])
    hH.append(temphH)
    if abs(hH[-2]-hH[-1]) < epsilon:
        break

print(hH)