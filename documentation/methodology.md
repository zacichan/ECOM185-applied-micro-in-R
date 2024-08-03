### Explanation of Empirical Strategy

#### Staggered Difference-in-Differences (DiD) Framework

Our study employs a staggered difference-in-differences (DiD) methodology, leveraging the staggered implementation of metro mayoral elections across different local authority districts. This approach, as outlined by Sun and Abraham (2021), is particularly effective in capturing the dynamic treatment effects and accommodating heterogeneity in treatment timing and effects across different cohorts.

#### Model Specification

The model specification follows a two-way fixed effects structure with additional controls for the treatment's timing:

$$ Y_{it} = \alpha_i + \lambda_t + \sum_{l=-K}^{L} \mu_l D_{it}^l + \epsilon_{it} $$

-   $Y_{it}$: Outcome variable (GVA per hour worked) for unit $i$ at time $t$.
-   $\alpha_i$: Unit fixed effects capturing time-invariant characteristics of each local authority district.
-   $\lambda_t$: Time fixed effects accounting for common shocks affecting all districts.
-   $D_{it}^l$: Indicator variable denoting the relative period $l$ to the treatment (e.g., mayoral election).
-   $\mu_l$: Coefficients representing the treatment effect at different relative periods.

This specification includes leads and lags to capture pre- and post-treatment dynamics. The terms $\sum_{l=-K}^{-1} \mu_l D_{it}^l$ represent pre-treatment periods, while $\sum_{l=0}^{L} \mu_l D_{it}^l$ captures the post-treatment effects.

#### Key Assumptions and Issues

**1. Parallel Trends Assumption**: \
In the absence of the treatment, treated and control units would have followed parallel paths in the outcome variable. This is a fundamental requirement for causal inference in DiD models. However, as Sun and Abraham (2021) highlight, this assumption can be violated if treatment effects vary across cohorts (treatment effect heterogeneity), leading to biased estimates.

**2. No Anticipation Assumption**: \
Units do not alter their behaviour in anticipation of the treatment. If violated, pre-treatment periods may show significant effects, complicating the interpretation of the treatment's impact.

**3. Treatment Effect Homogeneity**: \
The treatment effect is consistent across all treated units and periods. In reality, this assumption may not hold, leading to contamination of the estimated coefficients by other period effects.

#### Addressing Heterogeneity and Contamination

To address treatment effect heterogeneity and ensure robust estimates, the study utilizes the Interaction-Weighted (IW) estimator by Sun and Abraham. This method adjusts for cohort-specific treatment variations by weighting them according to their data representation, yielding a more accurate average treatment effect across cohorts. The IW estimator, implemented via the `sunab()` function in the `{fixest}` package, mitigates contamination issues from traditional two-way fixed effects models. It ensures that the estimated coefficients reflect the true dynamic effects of the treatment, even with varying timings and effects across cohorts.

## 
