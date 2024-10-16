.reqOpenOrders <- function(twsconn) {
  if( !is.twsConnection(twsconn))
    stop('requires twsConnection object')

  con <- twsconn[[1]]

  VERSION <- "1"

  writeBin(c(.twsOutgoingMSG$REQ_OPEN_ORDERS,VERSION), con)
}

reqOpenOrders <- function(twsconn) {
  .reqOpenOrders(twsconn)

  con <- twsconn[[1]]
  eW  <- eWrapper()
  
  while(TRUE) {
    socketSelect(list(con), FALSE, NULL)
    curMsg <- readBin(con, character(), 1L)
    processMsg(curMsg, con, eW)
  }
}

.reqAutoOpenOrders <- function(twsconn, bAutoBind=TRUE) {
  if( !is.twsConnection(twsconn))
    stop('requires twsConnection object')

  bAutoBind <- as.character(as.integer(bAutoBind))
  con <- twsconn[[1]]

  VERSION <- "1"

  writeBin(c(.twsOutgoingMSG$REQ_AUTO_OPEN_ORDERS,VERSION,bAutoBind), con)
}

.reqAllOpenOrders <- function(twsconn) {
  if( !is.twsConnection(twsconn))
    stop('requires twsConnection object')

  con <- twsconn[[1]]

  VERSION <- "1"

  writeBin(c(.twsOutgoingMSG$REQ_ALL_OPEN_ORDERS,VERSION), con)
}


reqOpenOrders.FUT <- function(tws)
{
  Open.Orders <- function(tws)
  {
    .reqAllOpenOrders(tws)
    con <- tws[[1]]
    eW  <- eWrapper()
    socketSelect(list(con), FALSE, NULL)
    curMsg <- readBin(con, character(), 1L)
    processMsg(curMsg, con, eW, twsconn = tws)
  }
  
  
  open <- data.frame()
  i <- 0
  while(i < 2)
  {
    x <- Open.Orders(tws)
    if(!is.null(x) && x[1] == 53) # OPEN_ORDER_END
    {
      i = i + 1
    } else if(!is.null(x) && x[1] == 5) # For Open Orders
    {
      x <- data.frame(t(x), stringsAsFactors = FALSE)
      open <- bind_rows(open, x)
    }
    rm(x)
  }
  
  if(nrow(open) > 0)
  {
    open <- open %>% distinct() %>%
      rename(conId = X4, symbol = X5, sectype = X6, 
             expiry = X7, multiplier = X10, exch = X11,
             currency = X12, local = X13, action = X15, totalQuantity = X16,
             orderType = X17, lmtPrice = X18, auxPrice = X19,
             tif = X20, outsideRTH = X21, account = X22, orderId = X3
      ) %>%
      select(account, orderId, conId, symbol, local, expiry, sectype, exch, multiplier, currency,
             action, totalQuantity, orderType, lmtPrice, auxPrice, tif) %>%
      mutate(orderId = as.integer(orderId), 
             totalQuantity = as.numeric(totalQuantity), 
             lmtPrice = as.numeric(lmtPrice), 
             multiplier = as.numeric(multiplier),
             auxPrice = as.numeric(auxPrice) )
  } else 
  {
    open <- data.frame(account   = character()
                       , orderId = integer()
                       , conId   = character()
                       , symbol  = character()
                       , local   = character()
                       , expiry  = character()
                       , sectype = character()
                       , exch    = character()
                       , multiplier = character()
                       , currency   = character()
                       , action     = character()
                       , totalQuantity = numeric()
                       , orderType = character()
                       , lmtPrice  = numeric()
                       , auxPrice  = numeric()
                       , tif       = character()
                       , stringsAsFactors = FALSE)
  }
  
  # assign("IB.open.orders", open, envir = .GlobalEnv)
  rm(i, Open.Orders)
  return(open)
}
