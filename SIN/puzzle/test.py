def sequences(state: str):
    sequence_order = [0, 1, 2, 5, 8, 7, 6, 3]

    total = 0

    # center
    if state[4] != 0:
        total += 2 * 3 + 1 * 3 # blank not in the center + one in the center
    
    for i in range(len(sequence_order)):
        if int(state[sequence_order[i]]) == 0:
            continue
        if int(state[sequence_order[(i + 1) % len(sequence_order)]]) != int(state[sequence_order[i]]) % 8 + 1:
            total += 3 * 2
    
    return total

# print(sequences("283164705"))
print(sequences("123084765"))

