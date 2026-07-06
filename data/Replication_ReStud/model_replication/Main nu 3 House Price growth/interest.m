function rl = interest(A, p)

rl = 1./(1 + exp(-p.r1*(A - p.r2)))*(p.rh - p.rl) + p.rl;

