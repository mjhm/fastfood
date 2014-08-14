
callback = require './callback_ctlr'
async = require './async_ctlr'
qpromises = require './qpromises_ctlr'
bluebird = require './bluebird_ctlr'

router = require('express').Router()
module.exports = router

router.get '/callback', callback.indexCtlr
router.post '/callback/order', callback.orderCtlr, callback.indexCtlr

router.get '/async', async.indexCtlr
router.post '/async/order', async.orderCtlr, async.indexCtlr

router.get '/qpromises', qpromises.indexCtlr
router.post '/qpromises/order', qpromises.orderCtlr, qpromises.indexCtlr

router.get '/bluebird', bluebird.indexCtlr
router.post '/bluebird/order', bluebird.orderCtlr, bluebird.indexCtlr

router.get '/', (req, res) ->
  res.render 'choose', {}
