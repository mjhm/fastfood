
Q = require 'q'
Q.longStackSupport = true

submitOrder = require('../services/callback_order').submitOrder

exports.indexCtlr = (req, res) ->
  res.render 'index', {
    title: 'Promised Eats'
    subtitle: 'Original Async Restaurant'
    action: '/callback/order'
    result: req.result
    error: req.error
    elapsed: req.elapsed
  }

exports.orderCtlr = (req, res, next) ->
  startTime = new Date().getTime()
  
  submitOrder req.body, (err, result) ->
    if err
      req.error = err
    else
      req.result = result
    req.elapsed = ((new Date().getTime() - startTime)/1000.0).toFixed(3, 10)
    next()
