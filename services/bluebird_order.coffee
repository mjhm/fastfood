
Promise = require 'bluebird'
Promise.longStackTraces()

class Item
  constructor: (@name) ->
    @ingredients = []
    @prepType = null
    @packageType = null

  gatherIngredients: (list) =>
    Promise.settle(list.map(@findIngredient))
      .then (resultList) =>
        errorStr = resultList
          .filter((r) -> r.isRejected())
          .map((r) -> r.reason())
          .join(' and ')
        if errorStr
          throw new Error(errorStr)
        @ingredients = list


  findIngredient: (ingredient) ->
    if ingredient == 'bacon'
      Promise.reject(new Error('Out of bacon'))
    else
      Promise.resolve(ingredient)


  prepare: (@prepType) =>
    prepTime = switch @prepType
      when 'broil' then 3000
      when 'fry' then 2000
      else 0
    Promise.delay(@, prepTime)

  package: (@packageType) => Promise.resolve(@)


orderBurger = (optionList) ->
  burger = new Item('burger')
  burger.gatherIngredients(optionList.concat(['lettuce', 'tomato']))
    .then () ->
      burger.prepare('broil')
    .then () ->
      burger.package('wrap')


orderSide = (sideType) ->
  side = new Item(sideType)
  side.findIngredient('potatoes')
    .then () ->
      side.prepare('fry')
    .then () ->
      side.package('shovel')

orderDrink = (drinkType) ->
  drink = new Item(drinkType)
  Promise.resolve(drink)


exports.submitOrder = (itemHash) ->
  itemPromiseList = []

  for item of itemHash
    itemPromise = switch item
      when 'burger'
        burgerWith = []
        if itemHash.bacon
          burgerWith.push('bacon')
        orderBurger(burgerWith)
      when 'fries'
        orderSide('fries')
      when 'pepsi'
        orderDrink('pepsi')

    itemPromiseList.push(itemPromise)

  Promise.all(itemPromiseList)
