
Q = require 'q'
Q.longStackSupport = true

submitOrder = require('../services/order').submitOrder

exports.indexCtlr = (req, res) ->
  res.render 'index', {
    title: 'Promised Eats'
    subtitle: 'Original Async Restaurant'
    action: '/promises/order'
    result: req.result
    error: req.error
    elapsed: req.elapsed
  }

exports.orderCtlr = (req, res, next) ->
  startTime = new Date().getTime()
  submitOrder(req.body)
    .then (result) ->
      req.result = result
    .fail (err) ->
      req.error = err
    .done () ->
      req.elapsed = ((new Date().getTime() - startTime)/1000.0).toFixed(3, 10)
      next()