




using Random
using CSV
using DataFrames
Random.seed!(28)
include("CDFJulia.jl")
include("utilities.jl")
sp= CSV.read("D:\\Programing\\Julia\\SMCJulia\\spyData.csv", DataFrame)
rs = getrnd(sp.R, length(sp.R))


using StatsBase
nlag = 50
n2lag = 5*nlag
aR = autocor(sp.R, 1:nlag)
bR = autocor(abs.(sp.R), 1:n2lag)
cR = crosscor(sp.R, abs.(sp.R), -nlag:nlag)
bR2 = autocor((sp.R).^2, 1:n2lag)

cmin = efun6(aR, bR, cR, bR2, rs, nlag, n2lag)



#=Loop=#
cost = cmin
foundMin = False
nTot  = 0
nGood = 0
nAll  = 0
ra    = rs
tini  = temp
E     = matrix(NA,round(maxA/1e6),1)

function wombo(cost, foundMin, nTot, nGood, nALL, ra, tini, E)
    cost = cmin
    foundMin = False
    nTot  = 0
    nGood = 0
    nAll  = 0
    ra    = rs
    tini  = temp
    E     = matrix(NA,round(maxA/1e6),1)
    temp = 1e-4
    maxT = 20000
    maxG = 2000
    maxS = 200
    cgoal= 5e-2  # 1e-3
    wc   = 0.9
    afac = 0.5
    maxA = 120e6
    for(nAll<maxA)
  nTot = nTot+1
  nAll = nAll+1
  if(nAll%%100000 == 0)
    print(nAll/1e6)
    E[round(nAll/1e6)] = tE
end

  cmax = cost-temp*log(runif(1))
  trs  = pfun(rs)
  tE   = efun6(aR,bR,cR,bR2,trs,nLag)

  if(tE<=cmax)
    nGood = nGood+1
    rs    = trs
    cost  = tE
end
  if(cost<=cgoal)
    ra = rs
    foundMin = TRUE
    break
end
  if(nTot<maxT && nGood<maxG)
    if(cost<(cmin*wc))
      cmin = cost
      ra   = rs
  end

  if(temp==tini && nTot>1.5*nGood)
    tini = 10*temp
    temp = tini
end
  else
    if(nGood<=maxS)
      afac=sqrt(afac)
      maxT=maxT*sqrt(2)
      temp=tini
  end
    else
      temp=temp*afac
  end

  nTot  = 0
  nGood = 0
end
