local mapper = require('shared.modules.configMapper')
local test = {}

test.initiate = function(_shopIndex, _selected, _scrollIndex, testOptions)
    local CFG_VEH_DATA = mapper.getVehicle(_shopIndex, _selected, _scrollIndex)
    local CFG_SHOP_DATA = mapper.getShop(_shopIndex)
    return lib.alertDialog({
        header = ('%s - %s'):format(CFG_SHOP_DATA.SHOP_LABEL, locale('testdrive')),
        content = ('You are about to test drive %s at %s'):format(CFG_VEH_DATA.label, testOptions[1]),
        centered = true,
        cancel = true
    }) == 'confirm' and true
end

return test