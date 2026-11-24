# DNS Resolver Performance Analysis

## Overview

An experimental and statistical analysis comparing DNS lookup performance across four DNS resolvers: Google, Cloudflare, Quad9, and Grand Valley State University's network resolver.

This project combines computer networking and statistical analysis to investigate whether DNS resolver selection significantly affects lookup latency.

## Experimental Design

- **Design:** Completely Randomized Design (CRD)
- **Treatments:** Four DNS resolvers
- **Sample Size:** 60 trials, 15 per resolver
- **Total DNS Lookups:** 480
- **Response Variable:** Average DNS lookup time in milliseconds
- **Significance Level:** 0.05
- **Testing Environment:** GVSU network

Treatment assignments were randomized using SAS PROC PLAN. Each trial consisted of eight DNS lookups across consistent domains, with the local DNS cache flushed before each trial.

## Statistical Methods

- Statistical power and sample size analysis
- Exploratory data analysis
- One-way ANOVA
- Logarithmic transformation
- Residual diagnostics
- Shapiro-Wilk normality test
- Levene's test for equal variances
- Tukey's HSD pairwise comparisons
- Welch's ANOVA
- Kruskal-Wallis test

## Technologies Used

- SAS
- PROC PLAN
- PROC POWER
- DNS
- Network performance testing
- Statistical visualization

## Key Findings

| DNS Resolver | Mean Lookup Time | Standard Deviation |
|---|---:|---:|
| GVSU Network | 2.20 ms | 1.85 ms |
| Quad9 | 6.63 ms | 1.40 ms |
| Google | 15.46 ms | 2.89 ms |
| Cloudflare | 24.97 ms | 18.53 ms |

The one-way ANOVA identified statistically significant differences in log-transformed lookup times across resolvers (F = 120.22, p < 0.0001).

Welch's ANOVA and the Kruskal-Wallis test supported the overall conclusion despite violations of normality and equal-variance assumptions.

Tukey's HSD comparisons indicated significant differences between all resolver pairs except Google and Cloudflare, although these comparisons should be interpreted cautiously given the assumption violations.

## Limitations

- Testing was conducted on a single device and network.
- Results may vary by geographic location, network conditions, and time of day.
- Statistical assumptions were not fully satisfied after transformation.
- Additional testing is necessary to establish broader performance conclusions.

## Full Research Report

[View Full Research Report (PDF)](dns-resolver-report.pdf)

The report includes experimental methodology, statistical output, visualizations, hypothesis testing, and conclusions.

## Project Background

Developed as an experimental design project for STA 315 at Grand Valley State University in Fall 2026.
