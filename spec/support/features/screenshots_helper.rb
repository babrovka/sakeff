# coding: utf-8
module Features
  module ScreenshotsHelper

    # метод сохраняет скриншот страницы в папку test_images
    # работает только при запуске теста через js
    # имя файла формируется как
    # custom-<FILENAME>-<LINE>.png
    def create_screenshot(count=-1)
      if example.metadata[:js]
        meta = example.metadata
        filename = File.basename(meta[:file_path])
        line_number = meta[:line_number]
        postfix = (count==-1) ? '' : "#{count}"
        screenshot_name = "custom-#{filename}-#{line_number}-#{postfix}.png"
        screenshot_path = "#{Rails.root.join("test_images")}/#{screenshot_name}"
        page.save_screenshot(screenshot_path, full: true)
      end
    end

  end
end
