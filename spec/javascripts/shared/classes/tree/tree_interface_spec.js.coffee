#= require shared/classes/tree/tree_interface
# include models/units.js.coffee
# include models/nested_bubbles.js.coffee

describe "Tree interface methods work properly", ->
  describe "ancestors", ->
    it "returns correct array of parent ids", ->
      unitId = "AEE18CB9-66D4-47F5-9810-A287E64E1462"
      resultArray = ["AEE18CB9-66D4-47F5-9810-A287E64E1469", "30ECE5B5-3AEE-4AD1-BD64-03C4B091C253"]
      expect(window.app.TreeInterface.ancestors(unitId)).toEqual resultArray


  describe "getNumberOfAllBubblesForUnitAndDescendants", ->
    it "returns correct array of bubbles types", ->
      unitId = "30ECE5B5-3AEE-4AD1-BD64-03C4B091C253"
      resultArray = [0, 0, 1, 0]
      expect(window.app.TreeInterface.getNumberOfAllBubblesForUnitAndDescendants(unitId)).toEqual resultArray


  describe "getRootUnitId", ->
    it "returns correct root id", ->
      rootId = "30ECE5B5-3AEE-4AD1-BD64-03C4B091C253"
      expect(window.app.TreeInterface.getRootUnitId()).toEqual rootId


  describe "getModelURLByUnitId", ->
    it "returns correct path to model file", ->
      unitId = "A4B1433E-C117-401F-8BA4-DD6E51419B62"
      pathToModel = "/models/path/to/name"
      expect(window.app.TreeInterface.getModelURLByUnitId(unitId)).toEqual pathToModel
