#= require shared/classes/tree/tree_interface
# include models/units.js.coffee
  #
describe "Tree interface methods work properly", ->
  #
  describe "getRootUnitId", ->
    it "returns correct root id", ->
      expect(window.app.TreeInterface.getRootUnitId()).toEqual "30ECE5B5-3AEE-4AD1-BD64-03C4B091C253"
  #  beforeEach (done) ->
  #    setTimeout ->
  #      expect(literatureBox.state.authors_data.length).not.toEqual 0
  #      done()
  #    , 200
  #
  #    authorsSelect = reactUtils.findAllInRenderedTree(literatureBox,(component) ->
  #      component.getDOMNode().id == "get_books_author"
  #    )[0]
  #    fake_change_object =
  #      target:
  #        value: 2
  #        text: "Мега автор"
  #      fake: true
  #
  #    reactUtils.Simulate.change(authorsSelect.getDOMNode(), fake_change_object)
  #
  #  describe "Author change", ->
  #    it "changes title on author change", (done) ->
  #      setTimeout ->
  #        expect(title.getDOMNode().textContent).toEqual 'Выберите произведение'
  #        done()
  #      , 200
