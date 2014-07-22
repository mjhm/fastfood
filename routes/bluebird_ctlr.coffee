
Promise = require 'bluebird'
Promise.longStackTraces()

submitOrder = require('../services/bluebird_order').submitOrder

exports.indexCtlr = (req, res) ->
  res.render 'index', {
    title: 'Promised Eats'
    subtitle: 'Original Async Restaurant'
    action: '/bluebird/order'
    result: req.result
    error: req.error
    elapsed: req.elapsed
  }

exports.orderCtlr = (req, res, next) ->
  startTime = new Date().getTime()
  submitOrder(req.body)
    .then (result) ->
      req.result = result
    .catch (err) ->
      req.error = err
    .done () ->
      req.elapsed = ((new Date().getTime() - startTime)/1000.0).toFixed(3, 10)
      next()