# Setup

## Platform

|setting  |value                        |
|:--------|:----------------------------|
|version  |R version 3.4.4 (2018-03-15) |
|system   |x86_64, linux-gnu            |
|ui       |RStudio (1.1.453)            |
|language |en_CA:en                     |
|collate  |en_CA.UTF-8                  |
|tz       |America/Edmonton             |
|date     |2018-06-19                   |

## Packages

|package      |*  |version |date       |source                                          |
|:------------|:--|:-------|:----------|:-----------------------------------------------|
|quickPlot    |   |0.1.4   |2018-06-19 |Github (PredictiveEcology/quickPlot@ffc2ddb)    |
|reproducible |   |0.2.0   |2018-06-19 |Github (PredictiveEcology/reproducible@e2bb94f) |
|SpaDES.core  |   |0.2.0   |2018-06-19 |local (PredictiveEcology/SpaDES.core@NA)        |
|SpaDES.tools |   |0.2.0   |2018-06-19 |Github (PredictiveEcology/SpaDES.tools@8498d25) |

# Check results

2 packages with problems

|package       |version | errors| warnings| notes|
|:-------------|:-------|------:|--------:|-----:|
|SpaDES.addins |0.1.1   |      0|        1|     0|
|SpaDES        |2.0.2   |      0|        1|     0|

## SpaDES.addins (0.1.1)
Maintainer: Alex M Chubaty <alex.chubaty@gmail.com>  
Bug reports: https://github.com/PredictiveEcology/SpaDES.addins/issues

0 errors | 1 warning  | 0 notes

```
checking whether package ‘SpaDES.addins’ can be installed ... WARNING
Found the following significant warnings:
  Warning: no DISPLAY variable so Tk is not available
See ‘/home/achubaty/Documents/GitHub/SpaDES/SpaDES.core/revdep/checks/SpaDES.addins.Rcheck/00install.out’ for details.
```

## SpaDES (2.0.2)
Maintainer: Alex M Chubaty <alex.chubaty@gmail.com>  
Bug reports: https://github.com/PredictiveEcology/SpaDES/issues

0 errors | 1 warning  | 0 notes

```
checking whether package ‘SpaDES’ can be installed ... WARNING
Found the following significant warnings:
  Warning: no DISPLAY variable so Tk is not available
  Warning: replacing previous import ‘SpaDES.tools::checkGDALVersion’ by ‘reproducible::checkGDALVersion’ when loading ‘SpaDES’
  Warning: replacing previous import ‘SpaDES.tools::getGDALVersion’ by ‘reproducible::getGDALVersion’ when loading ‘SpaDES’
  Warning: replacing previous import ‘SpaDES.tools::fastMask’ by ‘reproducible::fastMask’ when loading ‘SpaDES’
See ‘/home/achubaty/Documents/GitHub/SpaDES/SpaDES.core/revdep/checks/SpaDES.Rcheck/00install.out’ for details.
```
