#= require dropzone

window.Dropzone.autoDiscover = false


window.Dropzone.dictDefaultMessage  = "Перетащите сюда файлы для загрузки"
window.Dropzone.dictFallbackMessage = "Ваш браузер не поддерживает данный способ загрузки файлов!=("
window.Dropzone.dictFallbackText    = "Используйте стандартные средства загрузки в разделе 'Редактирование'."

window.Dropzone.dictFileTooBig      = "Размер файла слишком большой ({{filesize}} MB). Максимально допустимый размер файла - {{maxFilesize}} MB."
window.Dropzone.dictInvalidFileType = "Вы не можете загружать файлы данного типа!"

window.Dropzone.dictResponseError             = "Ошибка загрузки. Код ошибки - {{statusCode}}."
window.Dropzone.dictCancelUpload              = "Загрузка отменена."
window.Dropzone.dictCancelUploadConfirmation  = "Вы уверены, что хотите отменить загрузку?"

window.Dropzone.dictRemoveFile              = "Удалить"
window.Dropzone.dictRemoveFileConfirmation  = null

window.Dropzone.dictMaxFilesExceeded  = "Загрузка невозможна. Достигнут максимум количества загружаемых файлов."


link_regexp = /^\s*https?:\/\/[^\s]+\s*$/

if window.FileReader
  window.setCopyAndPasteFor = (el)->
    unless el.has_clipboard_callback
      _pasteCallback = (event)->
        dropzone = $(el).find(".rails_admin_multiple_file_upload_block .dropzone:visible")
        return if dropzone.length == 0
        dropzone = dropzone[0].dropzone

        items = (event.clipboardData or event.originalEvent.clipboardData).items
        blob = null
        i = 0
        while i < items.length
          if items[i].type.indexOf('image') == 0
            blob = items[i].getAsFile()

          else
            if items[i].kind == "string"
              items[i].getAsString (text)->
                if link_regexp.test(text)
                  xhr = new XMLHttpRequest()
                  xhr.open("GET", text)
                  xhr.responseType = "blob"
                  xhr.onload = ()->
                    _blob = xhr.response
                    if _blob != null
                      dropzone.addFile(_blob)
                  xhr.send()

          i++
        if blob != null
          dropzone.addFile(blob)

      el.addEventListener 'paste', _pasteCallback

      el.has_clipboard_callback = true


  window.setCopyAndPasteFor(document.body)
