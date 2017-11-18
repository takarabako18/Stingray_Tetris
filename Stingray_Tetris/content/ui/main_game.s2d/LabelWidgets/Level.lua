local thisActor = ...



local labelText = scaleform.Actor.component_by_name(thisActor, "Text")



local customListener = scaleform.EventListener.create(customListener, function(e)

    if e.name == "updateLevel" then

        local s = e.data

        

        scaleform.TextComponent.set_text(labelText, s)

        --scaleform.TextComponent.te

        --print(actorName .. " Update")

    end

    

    --print(actorName .. " event Listen")

end);



scaleform.EventListener.connect(customListener, thisActor, scaleform.EventTypes.Custom)