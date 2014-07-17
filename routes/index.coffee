
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
  }

orderCtlr = (req, res, next) ->
  submitOrderPromise = submitOrder(req.body)
  submitOrderPromise
    .then (result) ->
      req.result = result
      next()
    .fail (err) ->
      req.error = err
      next()


router.get '/', indexCtlr

router.post '/order', orderCtlr, indexCtlr