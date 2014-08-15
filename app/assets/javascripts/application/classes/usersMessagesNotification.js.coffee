# Класс для отображения новых сообщений
class window.app.UsersMessagesNotificationView extends window.app.NotificationModel
  #   url - обьект для хранения путей
  url = {}
  _custom_constructor: (params) ->
    url.messages = document.getElementsByClassName('js-uuid')[0].dataset.apiMessages + '?id=' + document.getElementsByClassName('js-uuid')[0].innerHTML
    console.log '000'

  did_recieve_message: (data) =>
    console.log('111')
    #TODO-justvitalius: Переменовать данный метод в CamelCase стиль
    #Запрос новых сообщений
    this.getNewMessages()


  getNewMessages: () =>
    console.log('222')
    $.when(window.global.sendRequest(url.messages, 'GET', true)).done (data, textStatus) ->
      console.log(data)

      #Отрисовка
      parent = document.getElementsByClassName('_messages-page')[0]
      parent.innerHTML = ''
      _.each data, (message) ->
        messageDiv = document.createElement("div");

        header = document.createElement("h4")

        date = document.createElement("span")
        date.className = 'text-gray-d'
        date.innerHTML = message.created_at

        content = document.createElement("div")
        content.innerHTML = message.text

        header.innerHTML = message.sender.first_name + ' ' + message.sender.last_name

        messageDiv.appendChild (header )
        messageDiv.appendChild (date)
        messageDiv.appendChild (content)

        parent.appendChild(messageDiv);
        return


