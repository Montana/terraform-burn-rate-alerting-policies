# terraform-burn-rate-alerting-policies

Burn rate indicates the speed at which your error budget is being consumed, relative to the SLO. Using the previous example, if you have an average error rate of 5% for the 30-day period, all your error budget will be consumed, corresponding to a burn rate of 1. If you were to have a burn rate of 2, all available error budget would be consumed in half the time window (15days).

 
![image](https://user-images.githubusercontent.com/20936398/201249900-249944c4-9c08-40fc-8ae2-ac55fa258da0.png)


By configuring alerts based on burn rate, you can be sure a significant portion of your error budget has already been spent and you need to look into it. But you can go one step further.

You can extend the concept of burn rate to consider multiple burn rates and multiple windows. Instead of only looking at all your window you could, for example, look at the last 2h and 24h and consider these as your fast and slow burn rates. These alerts would allow you to catch sudden and large changes in error budget consumption. You could decide, for example,  that a burn rate of 10 in the last 2h would require your immediate attention.

When these are triggered you can be sure actions need to be performed. Maybe engineers need to jump on a conference call and write a postmortem document. Or maybe they need to stop feature work and focus on reliability features for the next sprint. Thank you to @ptsteadman for getting me interested in this topic. 

# Jsonnet example: 

```jsonnet
local slo = import '../slo-libsonnet/slo.libsonnet';
{
local errorburnrate = slo.errorburn({
metric: http_requests_total,
selectors: ['job="prometheus"'],
errorBudget: 1-0.99,
}),
rules:
errorburnrate.recordingrules +
errorburnrate.alerts,
}
```
