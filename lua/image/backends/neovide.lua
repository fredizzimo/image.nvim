local utils = require("image/utils")

---@type Backend
local backend = {
  ---@diagnostic disable-next-line: assign-type-mismatch
  state = nil,
  features = {
    crop = false,
  },
}

backend.setup = function(state)
  backend.state = state
  print("backend setup")
end

backend.render = function(image, x, y, width, height)
  print("rendering")
  local f = vim.uv.fs_open(image.cropped_path, "r", 0)
  local size = vim.uv.fs_fstat(f).size
  print(size)
  local image_data = vim.uv.fs_read(f, size)
  local encoded = utils.base64.encode(image_data)
  print(image.internal_id)

  vim.rpcnotify(vim.g.neovide_channel_id, 'neovide.upload_image', image.internal_id, encoded)
  vim.rpcnotify(vim.g.neovide_channel_id, 'neovide.display_image', image.internal_id, image.buffer, image.geometry.x, image.geometry.y)
end

backend.clear = function(image_id, shallow)
end

return backend
