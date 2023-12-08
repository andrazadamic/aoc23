file = open('inputs/day6.input', 'r').read().split('\n')
ts = [x for x in file[0].split(':')[1].split(' ') if x != '']
t = ""
for tss in ts:
    t += tss

time = int(t)

ts = [x for x in file[1].split(':')[1].split(' ') if x != '']
t = ""
for tss in ts:
    t += tss

dist = int(t)

print(time, dist)

sum = 0

for i in range(time + 1):
    if i + i * (time - i - 1) > dist:
        sum += 1

print(sum)
