function unrequire(module)
    package.loaded[module] = nil
    _G[module] = nil
    return nil
end