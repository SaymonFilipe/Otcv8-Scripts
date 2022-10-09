local ui = setupUI([[
MainWindow
  size: 400 100
  text: Search Bot
  color: orange

  TextEdit
    anchors.top:parent.top
    anchors.left:parent.left
    id:tbox
    width: 150
    font: terminus-14px-bold
    color: #004d04

  Button
    anchors.top:parent.top
    anchors.right: parent.right
    text: Find
    id:check
    font: cipsoftFont

  Label
    id: labelinvisivel
    height: 10
    anchors.top: tbox.bottom
    anchors.left: parent.left
    font: verdana-11px-rounded

  Label
    id: status
    width: 35
    text: Status:
    color: white
    anchors.top: labelinvisivel.bottom
    anchors.left: parent.left
    font: cipsoftFont

  Label
    id: get
    width: 200
    anchors.left: status.right
    anchors.top: labelinvisivel.bottom
    font: cipsoftFont

  Label
    id: invisible
    height: 10
    anchors.top: get.bottom
    anchors.left: parent.left
    font: verdana-11px-rounded

  Panel
    id:image
    size: 100 150
    anchors.right:parent.right
    anchors.left:parent.left
    anchors.top: invisible.bottom

  Button
    id:close
    text: Close
    font: cipsoftFont
    color:red
    anchors.bottom: parent.bottom
    anchors.right: parent.right
]], g_ui.getRootWidget())

ui.image:hide()
ui:hide()

ui.close.onClick = function(widget)
   ui:hide()
   ui.image:hide()
   ui:setHeight(100)
   ui:setWidth(400)
   ui.get:setText("waiting a name...")
   ui.get:setColor("#8c8c8c")
   ui.tbox:setText()
end

local function checkHttpError()
  ui:setHeight(100)
  ui:setWidth(400)
  ui.image:hide()
  ui.get:setColor("yellow")
  ui.get:setText("Player not found, try again.")
end

local function checkHttpSucess()
  ui.get:setText("Player found, informations below:")
  ui.get:setColor("green")
  ui:setHeight(280)
  ui:setWidth(400)
  ui.image:show()
end


ui.check.onClick = function(widget)
  if not ui:isVisible() then return end
  if ui.tbox:getText():len() < 1 then
    return warn("insira o nome de um jogador no campo")
  end

    HTTP.get("https://ntodream.com.br/?subtopic=characters&name=".. ui.tbox:getText(),
    function(data, err) 
        if err then warn("site fora do ar ou url invalida") return end
        if data:find("does not exist or has been deleted") then
            return checkHttpError()
        end

    HTTP.downloadImage("https://ntodream.com.br/?".. ui.tbox:getText():trim().. ".png",
         function(image)
           if not image then return warn("algo deu errado...") end
              checkHttpSucess()
              ui.image:setImageSource(image)
       end)
   end)
end


UI.Button("Search Bot", function()
    if not ui:isVisible() then
        ui:show()
        ui:focus()
        ui:raise()
        ui.get:setText("waiting a name...")
        ui.get:setColor("#8c8c8c")
    else
        ui:hide()
    end
  end)