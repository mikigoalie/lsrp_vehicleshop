local caches = {}
caches.scrollCache = function(vehicleCat, scrollIdx)
    if not Config.cacheIndexes then return end
    vehicleCat.cachedIndex = scrollIdx
end

caches.selectCache = function(shopCat, selectIdx)
    if not Config.cacheIndexes then return end
    shopCat.cachedIndex = selectIdx
end

caches.showMenu = function(shopIndex)
    lib.showMenu('vehicleshop', Config.vehicleShops[shopIndex].cachedIndex or 1)
end

return caches