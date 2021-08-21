local Module = {}

Module.DEFAULT_OPTIONS = {
    colors = {
        up_to_date = "#3C4048",
        outdated = "#d19a66",
    },
    icons = {
        enable = true,
        style = {
            up_to_date = "|  ",
            outdated = "|  ",
        },
    },
    autostart = false
}

Module.HIGHLIGHT_GROUPS = {
    outdated   = "CratesOutdatedVersion",
    up_to_date = "CratesUpToDateVersion",
}

return Module
