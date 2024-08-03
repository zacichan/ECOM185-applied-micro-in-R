### Data and Methodology

**Dependent Variable**: Current Price (Smooth) Gross Value Added (GVA) per hour worked (£)

**Data Source**: The analysis uses annual labour productivity data published by the Office for National Statistics (ONS). The dataset covers the period from 2004 to 2022, encompassing 361 local authority districts in England.

**Sample**: - **Treatment Group**: 82 local authority districts within 10 Mayoral Combined Authorities (MCAs) that elected a mayor by 2022. - **Control Group**: 279 local authority districts not in an MCA with an elected mayor by 2022.

**Econometric Model**: - The primary model employed is a staggered difference-in-difference approach, which leverages the timeline of mayoral elections across different regions to isolate the impact of metro mayoral devolution on productivity. - The model specification is `feols(y ~ sunab(year_treated, year) | id + year, data, vcov = newey_west ~ id + year)`, where `y` represents the GVA per hour worked, `year_treated` indicates the year when a mayor was elected, and fixed effects for `id` (local authority districts) and `year` are included to control for unobserved heterogeneity.

**Fixed Effects**: - **id**: Captures time-invariant characteristics of each local authority district. - **year**: Accounts for common shocks affecting all districts in a given year.

**Clustered Standard Errors**: - Errors are clustered by `id` to account for serial correlation within districts over time.

### Interpretation of Results

#### Impact Over Time

The regression results indicate a generally negative impact of metro mayoral devolution on productivity, as measured by GVA per hour worked, in the short to medium term. The coefficients for the years immediately following the introduction of metro mayors show significant declines:

-   **Year 0**: A decline of -0.2615\*\* (p \< 0.01)
-   **Year 1**: A more pronounced decline of -0.5359\*\*\* (p \< 0.001)
-   **Year 2**: Continued decline of -0.8374\*\*\* (p \< 0.001)
-   **Year 3 to Year 5**: Persistent negative impacts, with coefficients ranging from -0.8983\*\* to -1.098\* (p-values indicating varying levels of statistical significance).

#### Cohort Analysis

The cohort analysis highlights the variability in the impact of devolution across different periods: - **2017 Cohort**: Significant negative impact of -0.829034\*\* (p \< 0.01) - **2018 Cohort**: Even stronger negative impact of -1.120256\*\*\* (p \< 0.001) - **2019 Cohort**: Positive impact of 0.437500\* (p \< 0.05), suggesting some regions may have started to realize benefits more quickly. - **2021 Cohort**: No significant impact observed, which could be due to the limited time since implementation or external factors such as the COVID-19 pandemic.

### Contextualizing the Findings

1.  **Centralization and Local Governance**:
    -   The UK's highly centralized governance structure has historically limited local governments' ability to drive economic change independently. Devolution aims to mitigate these limitations by transferring specific powers to local authorities, allowing for more tailored and region-specific economic strategies (Centre for Cities, 2023; Institute for Government, 2024).
2.  **Initial Transition Challenges**:
    -   The negative short-term impacts observed in the analysis can be attributed to the initial disruption and adjustment period associated with the transition to a new governance model. This aligns with findings from the Institute for Government, which suggests that metro mayors, while beneficial in the long run, face significant initial implementation challenges (Institute for Government, 2024).
3.  **Long-term Potential and Variability**:
    -   The mixed results across different cohorts highlight the importance of local context and the capacity of regional institutions. Successful devolution depends on the ability of local leaders to effectively leverage new powers, which can vary significantly across regions (Centre for Cities, 2023; Institute for Government, 2024).
4.  **Policy Recommendations**:
    -   To maximize the benefits of devolution, it is crucial to enhance support for local institutions, provide long-term and flexible funding arrangements, and ensure that the devolution of powers is accompanied by capacity-building initiatives. Additionally, a more coherent and standardized approach to devolution could help mitigate some of the initial negative impacts observed (Institute for Government, 2024).

### Conclusion

The findings of this study provide valuable insights into the complexities and challenges of metro mayoral devolution in England. While the initial impacts on productivity appear negative, these results highlight the importance of ongoing support and refinement of the devolution process to realize its full potential in the long term. Future research should continue to monitor the long-term effects and explore ways to enhance the effectiveness of devolution as a tool for regional economic development.

### References

Centre for Cities, 2023. In place of centralisation: A devolution deal for London, Greater Manchester, and the West Midlands. [online] Available at: <https://www.centreforcities.org> [Accessed 20 July 2024].

Crafts, N. and Mills, T.C., 2020. Is the UK Productivity Slowdown Unprecedented?. [online] Available at: <https://www.economics.ox.ac.uk> [Accessed 20 July 2024].

Gibbons, S., Lyytikäinen, T., Overman, H.G. and Sanchis-Guarner, R., 2019. New road infrastructure: the effects on firms. Journal of Urban Economics, 110, pp.35-50.

Institute for Government, 2024. How metro mayors can help level up England. [online] Available at: <https://www.instituteforgovernment.org.uk> [Accessed 20 July 2024].

McCann, P., 2020. Perceptions of Regional Inequality and the Geography of Discontent: Insights from the UK. Regional Studies, 54(2), pp.256-267.

OECD, 2010. Regional Development Policies in OECD Countries. OECD Publishing.

Rodríguez-Pose, A., 2013. Do institutions matter for regional development?. Regional Studies, 47(7), pp.1034-1047.

Sandford, M., 2016. Devolution to local government in England. House of Commons Library Research Briefing.

Stansbury, A., Summers, L.H., and Bell, A., 2023. The Decline of Agglomeration Economies in the United Kingdom. Working Paper.

Tenreyro, S., 2018. The UK Productivity Puzzle. Bank of England.
