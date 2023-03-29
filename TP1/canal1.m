function hn = canal1(d,n)

pn = hann(n);

hn = sinc((-10:10)-d).*pn.';