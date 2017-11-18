ui = ui or {}

-- FPSの更新
function ui.UpdateFPS(fps)
    local event = {
        eventId = scaleform.EventTypes.Custom,
        name = "updateFPS",
        data = nil
    }
    event.data = {value = fps}
    scaleform.Stage.dispatch_event(event)
end
