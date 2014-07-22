
Q = require 'q'
_ = require 'lodash'

class Item
  constructor: (@name) ->
    @ingredients = []
    @prepType = null
    @packageType = null

  gatherIngredients: (ingredList, callback) =>

    if ingredList.length == 0
      callback(null, [])
      return

    finishedCount = 0
    errList = []

    ingredList.forEach (ingred) =>
      @findIngredient ingred, (err, ingred) =>
        finishedCount += 1
        if err
          errList.push(err)

        if finishedCount == ingredList.length
          errorAll = null
          if errList.length
            errorAll = new Error(errList.map((err) -> err.message).join(' and '))
          else
            @ingredients = ingredList
          callback(errorAll)


  findIngredient: (ingredient, callback) ->
    if ingredient == 'bacon'
      callback(new Error('Out of bacon'))
    else
      callback(null, ingredient)


  prepare: (@prepType, callback) =>
    prepTime = switch @prepType
      when 'broil' then 3000
      when 'fry' then 2000
      else 0
    setTimeout () =>
      callback(null, @)
    , prepTime

  package: (@packageType, callback) => callback(null, @)


orderBurger = (optionList, callback) ->
  burger = new Item('burger')
  burger.gatherIngredients optionList.concat(['lettuce', 'tomato']), (err) ->
    if err
      callback(err)
      return
    burger.prepare 'broil', (err) ->
      if err
        callback(err)
        return
      burger.package 'wrap', (err) ->
        callback(err, burger)


orderSide = (sideType, callback) ->
  side = new Item(sideType)
  side.findIngredient 'potatoes', (err) ->
    if err
      callback(err)
      return
    side.prepare 'fry', (err) ->
      if err
        callback(err)
        return
      side.package 'shovel', (err) ->
        callback(err, side)


orderDrink = (drinkType, callback) ->
  drink = new Item(drinkType)
  callback(null, drink)


exports.submitOrder = (itemHash, soCallback) ->
  itemPromiseList = []
  resultHash = {}
  gotItem = false
  for item of itemHash
    if item != 'bacon'
      resultHash[item] = null
      gotItem = true
  if !gotItem
    soCallback(null, [])
    return

  finished = false
  maybeFinished = (err, resultHash, mfCallback) ->
    if !finished
      if err
        finished = true
        mfCallback(err)
      else
        allFinished = true
        for item of resultHash
          if !resultHash[item]
            allFinished = false
        if allFinished
          finished = true
          mfCallback(null, _.values(resultHash))


  for item of itemHash
    switch item
      when 'burger'
        burgerWith = []
        if itemHash.bacon
          burgerWith.push('bacon')
        orderBurger burgerWith, (err, result) ->
          if !err
            resultHash.burger = result
          maybeFinished(err, resultHash, soCallback)
      when 'fries'
        orderSide 'fries', (err, result) ->
          if !err
            resultHash.fries = result
          maybeFinished(err, resultHash, soCallback)
      when 'pepsi'
        orderDrink 'pepsi', (err, result) ->
          if !err
            resultHash.pepsi = result
          maybeFinished(err, resultHash, soCallback)


