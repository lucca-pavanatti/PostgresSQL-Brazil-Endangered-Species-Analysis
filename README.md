**Alícia Gonçalves Vieira**
**Lucca Pavanatti Duarte**

## Relational Database Project

### Summary

This project aims to analyze the implementation and effectiveness of the National Action Plans for the Conservation of Endangered Species (PANs) in Brazil. Using public databases provided by ICMBio, we conducted a survey on the geographic and taxonomic coverage of these plans, as well as identified gaps in conservation actions for critically endangered species.
The focus of the analysis lies at the intersection of extinction risk data, species presence in Brazilian biomes, and the existence (or lack) of public policies and actions related to those species.

### Related Sustainable Development Goal (SDG)

This project is directly related to **SDG 15 – Life on Land**,  which aims to:

> "protect, restore and promote sustainable use of terrestrial ecosystems, sustainably manage forests, combat desertification, halt and reverse land degradation and halt biodiversity loss".

In particular, it contributes to the targets:

- **15.5**: Take urgent and significant action to reduce the degradation of natural habitats, halt the loss of biodiversity, and protect and prevent the extinction of threatened species.
- **15.9**: Integrate ecosystem and biodiversity values into national and local planning, development processes, and poverty reduction strategies.

### Explanation of SQL Queries

#### Query 1 – Critically endangered species by biome

This query groups by biome the endemic species of Brazil that are critically endangered and are not included in any National Action Plan (PAN).
It also displays the biomes where there is no record of endangered species.
This allows the identification of territorial gaps in conservation efforts.

---


#### Query 2 – Conservation actions by risk category

This query evaluates the distribution of conservation actions carried out for species across different risk categories.
The pie chart visualization helps determine whether the actions are proportional to the urgency of the threats.

---


#### Query 3 – Critically endangered species with protection issues

This query identifies critically endangered species that show serious protection gaps, such as:

- No active PAN
- No current ordinance
- No associated conservation area

The red-highlighted visualization emphasizes the criticality of the situation.

---


#### Query 4 – PANs currently in effect

This query displays the PANs currently in execution, quantifying:

- The number of species covered
- The number of states involved
- The specific states included

This helps assess the geographic reach and biodiversity coverage of the current plans.

---

#### Query 5 – Species with expired PANs and declining populations

This identifies species that had a completed PAN and are currently showing a declining population trend, with no new plan in place.
This highlights the risk of extinction aggravated by the discontinuity of public policies.

---
