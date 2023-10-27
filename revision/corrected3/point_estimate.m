 
theta_initial = [121
          2.1
         61.2
           40
          6.9
          101
           93
          437
          360
      -7.8697
       -7.327
      -7.0132
      -7.6021
      -6.9136
      -6.8069
      -6.8827
      -7.1898
      -7.0088
         1.87
         2.12
         61.2
            1
          1.9
         1.46
         1.42
         2.14
         1.85
         0.19
         0.24
         0.24
         0.28
         0.25
        6.699
       6.7875
       7.0792
       6.2856
       6.2041]';

 load("revised1001.mat");
 close all;
 %%
[theta_optimized, cost_minimized] = theta_search(theta_optimized,data,model,pars2,mcmcpars)