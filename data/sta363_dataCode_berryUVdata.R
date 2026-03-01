#####################################################
## UV Depth & DOC Data
## 
##  A stratified sample from:
##
##    Nicole L. Berry, David B. Bunnell, Thomas J. Fisher,
##      Erin P. Overholt, Elizabeth Mette, Todd Howell, 
##      and Craig E. Williamson. 2026. "Decreased water 
##      transparency of nearshore Laurentian Great Lakes
##      habitats is driven by increased dissolved organic
##      carbon." Canadian Journal of Fisheries and Aquatic 
##      Sciences. 83: 1-9. https://doi.org/10.1139/cjfas-2024-0407
##
##  This demonstrates a non-linear relationship
##    in a regression setting. A log-x log-y
##    relationship works well.

## The fully_processed_data.RData is on the github repo for
##   the Berry et al paper.

library(tidyverse)
load("fully_processed_data.RData")

set.seed(473)
df <- UVdata |> 
  filter(UVdata$BlagraveID != "Open Sea,\nNo River",
         Season != "Fall") |> 
  group_by(SiteID) |> 
  sample_n(1) |>
  ungroup() |>
  select(SiteID, Date, Lake, UV_Depth = ss.1pc.estimate, DOC = DOC)

## Curvature in scatterplot
ggplot(df, aes(x=DOC, y=UV_Depth) ) +
  geom_point() +
  geom_smooth() +
  geom_smooth(method="lm", se=FALSE, color="firebrick")

## Still see some curvature but not as bad
ggplot(df, aes(x=DOC, y=log10(UV_Depth)  ) ) +
  geom_point() +
  geom_smooth() +
  geom_smooth(method="lm", se=FALSE, color="firebrick")

## Pretty darn linear
ggplot(df, aes(x=log10(DOC), y=log10(UV_Depth)  ) ) +
  geom_point() +
  geom_smooth() +
  geom_smooth(method="lm", se=FALSE, color="firebrick")



fit1 <- lm(UV_Depth ~ DOC, data=df)
autoplot(fit1)
## Major problems in Residuals vs Fitted & Normal Q-Q
fit2 <- lm(log10(UV_Depth) ~ DOC, data=df)
autoplot(fit2)
## Normal Q-Q looks better, but still some
##   curvature in Residuals vs Fitted

fit3 <- lm(log10(UV_Depth) ~ log10(DOC), data=df)
autoplot(fit3)
## Much better

write_csv(df, "~/../Desktop/tjfisher19.github.io/data/berry_uv_doc.csv")
