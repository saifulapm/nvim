---@diagnostic disable: undefined-global

local quote = '"'

return {
  snippet('cl', fmt('console.log({})', i(1))),
  snippet('ci', fmt('console.info({})', i(1))),
  snippet('cd', fmt('console.debug({})', i(1))),
  snippet('ce', fmt('console.error({})', i(1))),
  -- Module
  -- TODO: Dynamic node for import name (dynamic because user should be able to change the generated name)
  snippet(
    'im',
    c(1, {
      fmt('import {{ {} }} from ' .. quote .. '{}' .. quote, {
        i(2),
        i(1),
      }),
      fmt('const {{ {} }} = require(' .. quote .. '{}' .. quote .. ')', {
        i(2),
        i(1),
      }),
    })
  ),
  snippet(
    'imd',
    c(1, {
      fmt('import {} from ' .. quote .. '{}' .. quote, {
        i(2, '{}'),
        i(1),
      }),
      fmt('const {} = require(' .. quote .. '{}' .. quote .. ')', {
        i(2, '{}'),
        i(1),
      }),
    })
  ),
  snippet(
    'ex',
    c(1, {
      fmt('export {}', i(1)),
      fmt('module.exports = {{ {} }}', i(1)),
    })
  ),
  snippet(
    'exd',
    c(1, {
      fmt('export default {}', i(1)),
      fmt('module.exports = {}', i(1)),
    })
  ),
  -- Function
  snippet(
    'fun',
    c(1, {
      fmt(
        [[
        const {} = ({}) => {{
          {}
        }}
        ]],
        {
          i(1),
          i(2),
          i(0),
        }
      ),
      fmt(
        [[
        function {}({}) {{
          {}
        }}
        ]],
        {
          i(1),
          i(2),
          i(0),
        }
      ),
    })
  ),
  snippet(
    'afun',
    c(1, {
      fmt(
        [[
        const {} = async ({}) => {{
          {}
        }}
        ]],
        {
          i(1),
          i(2),
          i(0),
        }
      ),
      fmt(
        [[
        async function {}({}) {{
          {}
        }}
        ]],
        {
          i(1),
          i(2),
          i(0),
        }
      ),
    })
  ),
  snippet(
    'fune',
    c(1, {
      fmt(
        [[
        ({}) = {{
          {}
        }}
        ]],
        {
          i(1),
          i(0),
        }
      ),
      fmt(
        [[
        function({}) {{
          {}
        }}
        ]],
        {
          i(1),
          i(0),
        }
      ),
    })
  ),
  snippet(
    'afune',
    c(1, {
      fmt(
        [[
        async ({}) => {{
          {}
        }}
        ]],
        {
          i(1),
          i(0),
        }
      ),
      fmt(
        [[
        async function({}) {{
          {}
        }}
        ]],
        {
          i(1),
          i(0),
        }
      ),
    })
  ),
}
