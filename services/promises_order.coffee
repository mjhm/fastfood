
Q = require 'q'
Q.longStackSupport = true

class Item
  constructor: (@name) ->
    @ingredients = []
    @prepType = null
    @packageType = null

  gatherIngredients: (list) =>
    ingredPromiseList = list.map(@findIngredient)
    Q.allSettled(ingredPromiseList)
      .then (resultList) =>
        errorStr = resultList
          .filter((r) -> if r.state == 'rejected' then r.reason.message)
          .join(' and ')
        if errorStr
          throw new Error(errorStr)
        @ingredients = list


  findIngredient: (ingredient) ->
    ingredientDeferred = Q.defer()
    if ingredient == 'bacon'
      ingredientDeferred.reject(new Error('Out of bacon'))
    else
      ingredientDeferred.resolve(ingredient)
    ingredientDeferred.promise


  prepare: (@prepType) =>
    prepTime = switch @prepType
      when 'broil' then 3000
      when 'fry' then 2000
      else 0
    prepDeferred = Q.defer()
    setTimeout () =>
      prepDeferred.resolve(@)
    , prepTime
    return prepDeferred.promise

  package: (@packageType) => Q(@)


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
  Q(drink)


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

  Q.all(itemPromiseList)
