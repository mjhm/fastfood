
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
    Q(ingredient)

  prepare: (@prepType) => Q(@)

  package: (@packageType) => Q(@)


orderBurger = (optionList) ->
  burger = new Item('burger')
  burger.gatherIngredients(optionList.concat(['lettuce', 'tomato']))
  .then () ->
    burger.prepare('broil')
    testfail = () ->
      burger.whatever.blah = 5
    testfail()
  .then () ->
    burger.package('wrap')


orderSide = (sideType) ->
  side = new Item(sideType)
  Q(side)

orderDrink = (drinkType) ->
  drink = new Item(drinkType)
  Q(drink)


exports.submitOrder = (itemHash) ->
  itemPromiseList = []

  if itemHash.burger
    burgerWith = []
    if itemHash.bacon
      burgerWith.push('bacon')
    burgerPromise = orderBurger(burgerWith)
    itemPromiseList.push(burgerPromise)

  if itemHash.fries
    itemPromiseList.push(orderSide('fries'))

  if itemHash.pepsi
    itemPromiseList.push(orderDrink('pepsi'))

  Q.all(itemPromiseList)
