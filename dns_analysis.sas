/* ============================================================
   Project: DNS Resolver Performance Analysis
   Author: Ty Hafke
   Institution: Grand Valley State University
   Course: STA 315 - Experimental Design
   Date: Fall 2026

   Objective:
   Compare DNS lookup performance across Google, Cloudflare,
   Quad9, and GVSU Network using a completely randomized design.

   Methods:
   - Statistical power analysis
   - Randomized treatment assignment
   - One-way ANOVA
   - Logarithmic transformation
   - Residual diagnostics
   - Tukey's HSD
   - Welch's ANOVA
   - Kruskal-Wallis test

   Dataset: results.xlsx
   Experimental Units: 60 trials
   Total DNS Lookups: 480
   ============================================================ */
   
/* Calculate sample size needed for the desired power */
proc power;
   onewayanova test=overall
      alpha=0.05
      stddev=8
      npergroup=.
      power=0.8 0.9
      groupmeans=15 | 18 | 22 | 25;
run;

/* Randomly assign 60 trials to four DNS resolvers */
proc plan seed=12345;
   factors units=60 ordered;
   treatments resolver=60 random;
   output out=crd_design
      resolver nvals=(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
                      2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
                      3 3 3 3 3 3 3 3 3 3 3 3 3 3 3
                      4 4 4 4 4 4 4 4 4 4 4 4 4 4 4) random;
run;

/* Assign names to the four DNS resolvers */
data crd_design;
   set crd_design;
   length resolver_name $12;
   if resolver = 1 then resolver_name = 'Google';
   else if resolver = 2 then resolver_name = 'Cloudflare';
   else if resolver = 3 then resolver_name = 'Quad9';
   else if resolver = 4 then resolver_name = 'GVSU_Network';
run;

/* Display the randomized trial assignments */
proc print data=crd_design noobs;
run;

/* Update the file path to match your SAS environment */
proc import datafile="results.xlsx"
   out=work.raw dbms=xlsx replace;
   getnames=yes;
run;

/* Calculate average lookup time for each trial and resolver */
proc means data=work.raw noprint nway;
   class Trial Resolver;
   var Lookup_ms;
   output out=work.trials(drop=_type_ _freq_) mean=mean_ms;
run;

/* Log-transform the average lookup times */
data work.trials;
   set work.trials;
   log_ms = log(mean_ms);
run;

/* Count the number of trials for each resolver */
proc freq data=work.trials;
   tables Resolver;
run;

/* Summarize lookup times for each resolver */
proc means data=work.trials n mean std median min max maxdec=2;
   class Resolver;
   var mean_ms log_ms;
run;

/* Compare average lookup times using ANOVA and test equal variances */
proc glm data=work.trials;
   class Resolver;
   model mean_ms = Resolver;
   means Resolver / hovtest=levene(type=abs);
   means Resolver / welch;
   output out=work.res_raw r=resid p=pred;
run;
quit;

/* Check normality of residuals for the raw data */
proc univariate data=work.res_raw normal;
   var resid;
   qqplot resid / normal(mu=est sigma=est);
   title 'Normality of residuals on raw scale';
run;

/* Analyze log-transformed times and compare resolvers */
proc glm data=work.trials plots=diagnostics;
   class Resolver;
   model log_ms = Resolver;
   means Resolver / hovtest=levene(type=abs);
   means Resolver / welch;
   means Resolver / tukey cldiff;
   lsmeans Resolver / pdiff=all adjust=tukey;
   output out=work.res_log r=resid p=pred;
run;
quit;

/* Check normality of residuals for the log-transformed data */
proc univariate data=work.res_log normal;
   var resid;
   qqplot resid / normal(mu=est sigma=est);
   title 'Normality of residuals on log scale';
run;

/* Perform a nonparametric comparison of lookup times */
proc npar1way data=work.trials wilcoxon;
   class Resolver;
   var mean_ms;
run;
