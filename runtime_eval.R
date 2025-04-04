library("microbenchmark")
Rcpp::sourceCpp("effEval.cpp")

set.seed(1)
n2 = 100
X2 = matrix(rnorm(n*100), ncol = 100)
X2new = new(Cost, X2)

n3 = 1000
X3 = matrix(rnorm(n*100), ncol = 100)
X3new = new(Cost, X3)

n4 = 10000
X4 = matrix(rnorm(n*100), ncol = 100)
X4new = new(Cost, X4)

n5 = 100000
X5 = matrix(rnorm(n*100), ncol = 100)
X5new = new(Cost, X5)

microbenchmark::microbenchmark(R_eval(X2, 0, n2),
                               X2new$Cpp_effEval(0,n2),
                               X2new$Cpp_Eval(0,n2),
                               R_eval(X3, 0, n3),
                               X3new$Cpp_effEval(0,n3),
                               X3new$Cpp_Eval(0,n3),
                               R_eval(X4, 0, n4),
                               X4new$Cpp_effEval(0,n4),
                               X4new$Cpp_Eval(0,n5),
                               R_eval(X5, 0, n5),
                               X5new$Cpp_effEval(0,n5),
                               X5new$Cpp_Eval(0,n5),
                               times = 100) 

## I manually typed the data in a csv file (runtime.csv)
## Technically, microbenchmark can take varying inputs
## However, our inputs belong to different classes and I
## don't want to include the pre-computation time of 
## cumsum matrices to the final results, so it becomes 
## a bit more complicated.

runtime = read.csv("./runtime.csv")
ggplot(runtime, aes(x = n, y = runtime, group = method, color = method)) +
  geom_line() +
  geom_point() + 
  scale_x_log10() +  
  scale_y_log10() +  
  labs(
    title = "Runtime benchmarking for various eval() functions",
    x = "Number of rows (n, log-scale)",
    y = "Median runtime (micro-seconds, log-scale)"
  ) +
  theme_minimal() +
  theme(legend.title = element_blank()) 
