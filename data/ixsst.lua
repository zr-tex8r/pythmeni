--
-- ixsst.lua : Super-Simple Templates (v0.2)<2010/07/24>
--             Created by "ZR" (Takayuki YATO)

--- ixsst.to_code() :
-- Converts to a template string to a Lua code.
-- @param str (string) a template string
-- @returns (string) the Lua code representing the template
local function to_code(str)
  local cs = { "local _G = ...; local _O_ = {}; ",
    "local _I_, _S_ = _G.table.insert, _G.tostring; " }
  local p, tq, tr = 1, "_I_(_O_, %q); ", "_I_(_O_, _S_(%s)); "
  while true do
    local p1, p2, sq, se = str:find("<(%?+)(=?)", p)
    if not p1 then p1 = #str + 1 end
    local s1 = str:sub(p, p1 - 1)
    if #s1 ~= 0 then table.insert(cs, tq:format(s1)) end
    if not p2 then break end
    p = p2 + 1; p1, p2 = str:find(sq..">", p, true)
    if not p1 then p2 = #str; p1 = p2 + 1 end
    s1 = str:sub(p, p1 - 1); p = p2 + 1
    if not s1:find("^%s*$") then
      if #se == 0 then table.insert(cs, s1)
      else table.insert(cs, tr:format(s1)) end
    end
  end
  table.insert(cs, "return _G.table.concat(_O_)")
  return table.concat(cs)
end
--- ixssttemplate:exec() :
-- Merge the template with a given environment.
-- @param env (table) an environment to bind
-- @returns (string) the result of merging
local function exec(self, env)
  setfenv(self.tmpl, env)
  return self.tmpl(self._G)
end
--- ixsst.compile() :
-- Converts to a template string to a ixssttemplate object.
-- @param str (string) a template string
-- @returns (table) the compiled IxSstTemplate object
local function compile(str)
  local tmpl = assert(loadstring(to_code(str)))
  return { tmpl = tmpl, exec = exec, _G = _G }
end

--- the ixsst object
ixsst = {
  to_code = to_code; compile = compile
}
-- EOF
