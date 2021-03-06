describe "Pluralizer", ->
  it "works properly with single entity", ->
    amount = 1
    resultText = "сигнал"

    expect(window.app.Pluralizer.pluralizeString(amount, "сигнал","сигнала","сигналов")).toEqual resultText


  it "works properly with a couple of entities", ->
    amount = 2
    resultText = "аварии"

    expect(window.app.Pluralizer.pluralizeString(amount, "авария","аварии","аварий")).toEqual resultText


  it "works properly with multiple entities", ->
    amount = 5
    resultText = "информаций"

    expect(window.app.Pluralizer.pluralizeString(amount, "информация","информации","информаций")).toEqual resultText
