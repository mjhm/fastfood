
Q = require 'q'
Q.longStackSupport = true
router = require('express').Router()
module.exports = router

submitOrder = require('../services/order').submitOrder

indexCtlr = (req, res) ->
  res.render 'index', {
    title: 'Promised Eats'
    subtitle: 'Original Async Restaurant'
    result: req.result
    error: req.error
    elapsed: req.elapsed
  }

orderCtlr = (req, res, next) ->
  startTime = new Date().getTime()
  submitOrderPromise = submitOrder(req.body)
  submitOrderPromise
    .then (result) ->
      req.result = result
    .fail (err) ->
      req.error = err
    .done () ->
      req.elapsed = ((new Date().getTime() - startTime)/1000.0).toFixed(3, 10)
      next()


router.get '/', indexCtlr

router.post '/order', orderCtlr, indexCtlr