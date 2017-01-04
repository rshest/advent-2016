function applyOperation(field, line)
  local patterns = {
    "rect (%d+)x(%d+)", 
    "rotate column x=(%d+) by (%d+)", 
    "rotate row y=(%d+) by (%d+)"
  }

  local operations = {
    -- rect
    function(field, x, y)
      for j = 1, y do
        for i = 1, x do
          field[j][i] = true
        end
      end
    end,
    -- rotate column
    function(field, x, y)
      local col = {}
      local nrows = #field
      for i = 1, nrows do
        col[(i - 1 + y)%nrows + 1] = field[i][x + 1]
      end
      for i = 1, nrows do
        field[i][x + 1] = col[i]
      end
    end,
    -- rotate row
    function(field, x, y)
      local row = {}
      local ncols = #field[1]
      for i = 1, ncols do
        row[(i - 1 + y)%ncols + 1] = field[x + 1][i]
      end
      for i = 1, ncols do
        field[x + 1][i] = row[i]
      end
    end
  }

  for i, p in ipairs(patterns) do
    local x, y = string.match(line, p)
    if (x) then
      operations[i](field, tonumber(x), tonumber(y))
    end
  end
end

function initField(width, height)
  local field = {}
  for i = 1, height do
    field[i] = {}
    for j = 1, width do
      field[i][j] = false
    end
  end
  return field
end

function countLitPixels(field)
  local res = 0
  for j = 1, #field do
    for i = 1, #field[j] do
      res = res + (field[j][i] and 1 or 0)
    end
  end
  return res
end

-- prints the field on the screen, as stated in the problem
function printField(field) 
  for j = 1, #field do
    for i = 1, #field[j] do
      local c = field[j][i] and "#" or "."
      io.write(c)
    end
    io.write("\n")
  end
end


-- parse command line arguments
local file = arg[1] or 'input.txt'
local FIELD_WIDTH = tonumber(arg[2]) or 50
local FIELD_HEIGHT = tonumber(arg[3]) or 6

-- read data
local field = initField(FIELD_WIDTH, FIELD_HEIGHT)

for line in io.lines(file) do 
  applyOperation(field, line)
end

print("Number of lit pixels:", countLitPixels(field))
printField(field)
