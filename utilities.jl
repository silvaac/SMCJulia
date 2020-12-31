

function cfun2(a, A)
    cf = mean(abs.(a-A))
    return cf
end



function  pfun(R)
    Rs = copy(R)
    ts = sample(1:length(R), 2)
    Rs[reverse(ts)] = R[ts]
    return Rs
end


function efun6(a,b,c,b2,R,nlag=50,n2lag=25)
    A = autocor(R, 1:nlag)
    B = autocor(abs.(R), 1:n2lag)
    C = crosscor(R, abs.(R), -nlag:nlag)
    B2 = autocor(R.*R, 1:n2lag)
    Z = cfun2(a,A)+cfun2(b,B)+cfun2(c,C)+cfun2(b2,B2)
    return Z
end
