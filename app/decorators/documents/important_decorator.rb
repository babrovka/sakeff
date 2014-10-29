module Documents
  ImportantDecorator = Struct.new(:collection) do

    # определяем имя css-класса важных сообщений.
    # т.е.тех по которым есть нотификации
    def row_class(document)
      important = collection.select { |d| d.id == document.id }.join
      important.present? ? 'tr-unread' : 'tr-read'
    end
  end
end
