
length.cms <- seq(5,200,5)
length.m <- length.cms/100

alpha <- 0.05
beta <- 2.8

weight1 <- alpha *(length.cms^beta)
weight2 <- weight1/1000

lm(log(weight1) ~ log(length.cms))
lm(log(weight2) ~ log(length.cms))
lm(log(weight1) ~ log(length.m))
lm(log(weight2) ~ log(length.m))

