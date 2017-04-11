# Statistical things for Doppler/Backscatter Feedback Histology Data

# How many sample replicates do I need per dose?:

samples = 7 # number of doses
alpha   = 0.01
D       = 15 #desired diff in mean cell count to detect with prob beta
sigsq   = 25 #our estimate of sigma^2
ni      = 2:10 #the common sample size for each treatment (try several)
Fcrit   = qf(1-alpha,a-1,a*(ni-1))#value at which we reject H0
lam     = ni*(D^2)/(2*sigsq) #noncentrality paramter (ncp)
beta    = pf(Fcrit,a-1,a*(ni-1),ncp=lam)
power   = 1-beta

cbind(ni,Fcrit,beta,power) #display results by combining in columns
matplot(ni,cbind(beta,power),pch=c("b","p"))
title("Beta and Power vs. Sample Size")
lines(c(1,20),c(.1,.1))
lines(c(1,20),c(.9,.9))



# How many tiles do I need to look at per sample for cell counting?
samples = 6 # the number of replicates per dose
alpha   = 0.01
D       = 10 #desired diff in mean cell count to detect with prob beta
sigsq   = 15 #our estimate of sigma^2
ni      = 2:10 #the common sample size for each treatment (try several)
Fcrit   = qf(1-alpha,a-1,a*(ni-1))#value at which we reject H0
lam     = ni*(D^2)/(2*sigsq) #noncentrality paramter (ncp)
beta    = pf(Fcrit,a-1,a*(ni-1),ncp=lam)
power   = 1-beta

cbind(ni,Fcrit,beta,power) #display results by combining in columns
matplot(ni,cbind(beta,power),pch=c("b","p"))
title("Beta and Power vs. Sample Size")
lines(c(1,20),c(.05,.05))
lines(c(1,20),c(.95,.95))