return function (title, msg, _type, id)
    lib.notify({
        id = id,
        title = title or '[_ERROR_]',
        duration = Config.notifDuration,
        description = msg,
        position = Config.menuPosition == 'right' and 'top-left' or 'top-right', 
        type = _type or 'inform'
    })
end
