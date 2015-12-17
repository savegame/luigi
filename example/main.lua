local Layout = require 'luigi.layout'

local layout = Layout(require 'layout.main')
local aboutDialog = Layout(require 'layout.about')
local licenseDialog = Layout(require 'layout.license')

layout:setStyle(require 'style')
aboutDialog:setStyle(require 'style')
licenseDialog:setStyle(require 'style')

layout.slidey:onChange(function (event)
    layout.progressBar.value = event.value
end)

layout.flowToggle:onChange(function (event)
    layout.slidey.flow = event.value and 'y' or 'x'
    layout.progressBar.flow = event.value and 'y' or 'x'
    layout.stepper.flow = event.value and 'y' or 'x'
    local height = layout.flowTest:getHeight()
    layout.flowTest.flow = event.value and 'x' or 'y'
    layout.flowTest.height = height
end)

layout.newButton:onPress(function (event)
    print('creating a new thing!')
end)

layout.mainCanvas.text = [[
This program demonstrates some features of the Luigi UI library.

Luigi is a widget toolkit that runs under Love or LuaJIT.
]]

layout.mainCanvas.align = 'top'

layout.mainCanvas.wrap = true

-- help dialogs

layout.about:onPress(function()
    licenseDialog:hide()
    aboutDialog:show()
end)

layout.license:onPress(function()
    aboutDialog:hide()
    licenseDialog:show()
end)

aboutDialog.closeButton:onPress(function()
    aboutDialog:hide()
end)

licenseDialog.closeButton:onPress(function()
    licenseDialog:hide()
end)

-- menu/view/theme

layout.themeLight:onPress(function (event)
    local light = require 'luigi.theme.light'
    layout:setTheme(light)
    licenseDialog:setTheme(light)
    aboutDialog:setTheme(light)
end)

layout.themeDark:onPress(function (event)
    local dark = require 'luigi.theme.dark'
    layout:setTheme(dark)
    licenseDialog:setTheme(dark)
    aboutDialog:setTheme(dark)
end)

-- menu/file/quit
-- uses Backend for compat with Love or LuaJIT/SDL
local Backend = require 'luigi.backend'
layout.menuQuit:onPress(Backend.quit)

Backend.setWindowIcon('logo.png')

-- show the main layout
layout:show()

-- only needed when using LuaJIT/SDL
Backend.run()
