local mod = modApi:getCurrentMod()

local palette = {
    id = mod.id,
    name = "Yeti",
    image = "img/units/player/uplink_mech.png",
    colorMap = {
        lights =         { 255, 0, 0 }, 
        main_highlight = { 225, 230, 225 }, 
        main_light =     { 225, 230, 225 }, 
        main_mid =       { 150, 160, 158 }, 
        main_dark =      {  85,  95,  95 }, 
        metal_light =    { 167,  155,  155 }, 
        metal_mid =      {  84,  71,  71 }, 
        metal_dark =     {  37, 28, 28 }, 
    },
}

modApi:addPalette(palette)

 