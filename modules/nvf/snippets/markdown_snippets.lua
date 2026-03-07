local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

-- Función auxiliar para generar ID aleatorio hexadecimal
local function random_hex(args, parent)
    math.randomseed(os.time())
    local random = math.random(0, 16777215) -- 16^6-1
    return string.format("%06x", random)
end

-- Función para obtener fecha actual con formato
local function current_date(format)
    return os.date(format)
end

-- Función para formatear nombre de archivo
local function format_filename(args, parent, format)
    local filename = vim.fn.expand("%:t:r")
    if format == "capitalize" then
        return filename:gsub("(%a)([%w_']*)", function(first, rest)
            return first:upper() .. rest:lower()
        end)
    elseif format == "downcase" then
        return filename:lower()
    else
        return filename
    end
end

-- New Note
ls.add_snippets("all", {
    s("newNote", fmt([[
---
id: {}
created: {}
modified: {}
tags: {}
alias:
  - {}
  - {}
---

{}
]], {
        f(random_hex),
        f(function() return current_date("%Y-%m-%dT%H:%M") end),
        f(function() return current_date("%Y-%m-%dT%H:%M") end),
        i(1),
        f(function() return format_filename(nil, nil, "capitalize") end),
        f(function() return format_filename(nil, nil, "downcase") end),
        i(2),
    })),
})

-- New Note Header
ls.add_snippets("all", {
    s("newNoteHeader", fmt([[
# {}

🔗: [^ref1]

{}
]], {
        f(function() return format_filename(nil, nil, "capitalize") end),
        i(1),
    })),
})

-- New Seedbed Header
ls.add_snippets("all", {
    s("newSeedbedHeader", fmt([[
# ¿Que he aprendido este mes?

[Last Month](./seedbed {}.{}.md) <-- --> [Next Month](./seedbed {}.{}.md)

{}
]], {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
    })),
})

-- New Random Hex
ls.add_snippets("all", {
    s("newRandomHex", {
        f(random_hex),
    }),
})

-- Seedbed Tags
ls.add_snippets("all", {
    s("seedbedTags", t({
        "",
        "  - type/seedbed",
        "  - queued/seedbed",
    })),
})

-- Sprout Tags
ls.add_snippets("all", {
    s("sproutTags", t({
        "",
        "  - type/sprout",
        "  - queued/note",
    })),
})

-- Signpost Tags
ls.add_snippets("all", {
    s("signpostTags", t({
        "",
        "  - type/signpost",
        "  - queued/signpost",
    })),
})

-- Archived Tags
ls.add_snippets("all", {
    s("archivedTags", t({
        "",
        "  - type/archive",
        "  - queued/archive",
    })),
})

-- Para usar estos snippets, asegúrate de que LuaSnip esté configurado correctamente en tu Neovim
-- y que este archivo se cargue como parte de tu configuración de snippets.
