function lua_paths(rec)
    return string.format("\npath: %s\n\ncpath: %s\n", package.path, package.cpath)
end
