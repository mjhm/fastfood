
callback = require './callback_ctlr'
async = require './async_ctlr'
promises = require './promises_ctlr'

router = require('express').Router()
module.exports = router

router.get '/callback', callback.indexCtlr
router.post '/callback/order', callback.orderCtlr, callback.indexCtlr

router.get '/async', async.indexCtlr
router.post '/async/order', async.orderCtlr, async.indexCtlr

router.get '/promises', promises.indexCtlr
router.post '/promises/order', promises.orderCtlr, promises.indexCtlr

