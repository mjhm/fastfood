
fs = require 'fs'
fsutil = require (__dirname + '/../util/fsutil')


# Simulate a database call that gets the number 5 with caching.

cachedNum = null
fetchNum = (callback) ->
  if cachedNum?
    callback(null, cachedNum)
  else
    setTimeout ->
      cachedNum = 5
      callback(null, cachedNum)
    , 50

exports.resetCache = ->
  cachedNum = null


exports.savenum = (file, callback) ->
  fsutil.mkdir_chdir file
  fetchNum (err, num)->
    fs.writeFileSync('num', String(num))
    callback(err)


exports.savenum2 = (file, callback) ->
  fsutil.mkdir_chdir2 file, ->
    fetchNum (err, num)->
      fs.writeFileSync('num', String(num))
      callback()

exports.savenum3 = (file, callback) ->
  fsutil.mkdir_chdir3 file, ->
    fetchNum (err, num)->
      fs.writeFileSync('num', String(num))
      callback()
