#grouped collection select filterj-car-type

jQuery ->


  if document.getElementById('permit_vehicle_fields')   #авто
    if document.getElementById('permit_way_bill').checked   #путевой лист
      $(".permit_drivers").hide()

    $("#permit_way_bill").on "ifChanged", ->
      $(".permit_drivers").toggle()


    if document.getElementById('permit_vehicle_attributes_has_russian_register_sn').checked
      $(".j-num-ino").hide()
    else
      $(".j-num-rus").hide()


    $('#permit_vehicle_attributes_has_russian_register_sn').on "ifChanged", ->
      $(".j-num-ino").toggle()
      $(".j-num-rus").toggle()


  if document.getElementById('temporary_permit_fields')  # разовый
    $('.j-auto').hide()
    if document.getElementById('permit_daily_pass_attributes_has_vehicle').checked
      $('.j-auto').show()

    $("#permit_daily_pass_attributes_has_vehicle").on "ifChanged", ->
      $(".j-auto").toggle()
      if document.getElementById('permit_daily_pass_attributes_has_russian_register_sn').checked
       $(".j-num-ino").hide()
      else
        $(".j-num-rus").hide()

    $('#permit_daily_pass_attributes_has_russian_register_sn').on "ifChanged", ->
      $(".j-num-ino").toggle()
      $(".j-num-rus").toggle()                                                                              #dalee vanin kod

    otherDocInput = $('.js-hidden-field input#permit_daily_pass_attributes_document_type')
    
    viewOtherDocInput = () ->
      $('select#permit_daily_pass_attributes_document_type').prop('disabled', 'disabled').trigger('chosen:updated')
      $('.form-group.js-hidden-field').show().find(otherDocInput).prop('disabled', '').trigger('chosen:updated')
      $('a.js-other_document').hide()

    $('a.js-other_document').on "click", ->
      viewOtherDocInput()

    $('.js-other-document-field-hide').on "click", ->
      $('.form-group.js-hidden-field').hide()
      $('select#permit_daily_pass_attributes_document_type').prop('disabled', '').trigger('chosen:updated')
      $('.js-other_document').show()


    if otherDocInput[0].value
      viewOtherDocInput()
      console.log('dsddf')

      

    




#  carBrands = $('#permit_vehicle_fields optgroup' )
#
#  $('#permit_vehicle_attributes_vehicle_body').change ->
#
#     #active-result result-selected
#
#    carBrancdGroup = $('#permit_vehicle_attributes_brand_chosen .chosen-results .group-result')
#
#
#    selectedType = $('#permit_vehicle_attributes_vehicle_body_chosen .chosen-single')[0].children[0].innerText #удаляем обертку
#
#    targetMark = _.filter(carBrands, (list) ->
#      return list.label is selectedType
#    )

  #$('permit_vehicle_attributes_brand_chosen')



#  states = $('#person_state_id').html()
#  console.log(states)
#  $('#person_country_id').change ->
#    country = $('#person_country_id :selected').text()
#    escaped_country = country.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
#    options = $(states).filter("optgroup[label=#{escaped_country}]").html()
#    console.log(options)
#    if options
#      $('#person_state_id').html(options)
#      $('#person_state_id').parent().show()
#    else
#      $('#person_state_id').empty()
#      $('#person_state_id').parent().hide()

