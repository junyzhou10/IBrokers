### Highlights

This is forked from the original repo of [Joshua Ulrich](https://github.com/joshuaulrich/IBrokers), just to fix one tiny issue related to placing order with `algoParams`. See examples below:

- For order types other than traditional limit (`LMT`) or markert (`MKT`), user can specify the arguments `algoStrategy` and `algoParams` in the function `twsOrder()`. For instance, this is the adaptive order example by [fmair](https://github.com/fmair) in [Issue #40](https://github.com/joshuaulrich/IBrokers/pull/40)
```
library(IBrokers)

tws <- twsConnect(port = 7496, verbose = TRUE)

contract <- twsFuture(symbol = "ES",
                       exch = "CME",
                       expiry = "202312",
                       currency = "USD")

order <- IBrokers::twsOrder(action = "BUY",
                            totalQuantity = 1,
                            orderType = "MKT",
                            tif = "DAY",
                            transmit = FALSE,
                            algoStrategy = "Adaptive",
                            algoParams = c("1", "adaptivePriority", "Patient")
)

placeOrder(twsconn = tws,
           Contract = contract,
           Order = order)
```

- IB TWS also support to place TWAP or VWAP orders by tilting the two arguments:
```
algoStrategy = "Vwap",
algoParams = c("5",
               "maxPctVol", "0.2", 
               "startTime", "09:30:00 US/Eastern",
               "endTime", "12:30:00 US/Eastern",
               "noTakeLiq", "1",
               "allowPastEndTime", "0")
```




---

### About

IBrokers is an [R](https://www.r-project.org) package that provides native R
access to Interactive Brokers Trader Workstation API.

### IBrokers for enterprise

Available as part of the Tidelift Subscription.

The maintainers of `IBrokers` and thousands of other packages are working with Tidelift to deliver commercial support and maintenance for the open source dependencies you use to build your applications. Save time, reduce risk, and improve code health, while paying the maintainers of the exact dependencies you use. [Learn more.](https://tidelift.com/subscription/pkg/cran-ibrokers?utm_source=cran-ibrokers&utm_medium=referral&utm_campaign=enterprise&utm_term=repo)

### Supporting IBrokers

If you are interested in supporting this project, please consider [sponsoring me](https://github.com/sponsors/joshuaulrich).

### Installation

The current release is available on [CRAN](https://CRAN.R-project.org/package=IBrokers),
which you can install via:

```r
install.packages("IBrokers")
```

To install the development version, you need to clone the repository and build
from source, or run one of:

```r
# To install this version
devtools::install_github("junyzhou10/IBrokers")
```

###### Have a question?

Ask your question on [Stack Overflow](http://stackoverflow.com/questions/tagged/r)
or the [R-SIG-Finance](https://stat.ethz.ch/mailman/listinfo/r-sig-finance)
mailing list (you must subscribe to post).

### Contributing

Please see the [contributing guide](.github/CONTRIBUTING.md).

### See Also

- [quantmod](https://CRAN.R-project.org/package=quantmod): quantitative financial modeling framework
- [xts](https://CRAN.R-project.org/package=xts): eXtensible Time Series based
on [zoo](https://CRAN.R-project.org/package=zoo)

### Authors

Jeffrey Ryan, [Joshua Ulrich](https://about.me/joshuaulrich)

### Alternative R Client Implementations

  - [ibilli/rib](https://github.com/lbilli/rib/) - R-native implementation that strives to preserve official C++/Java client programming paradigm. It implements a full decoder but a simplified client functionality.
  - [vspinu/rib](https://github.com/vspinu/rib) - Fully featured implementation that wraps the official C++ tws-api client. It provides an interceptor style message handling for easier message processing and bot creation.
