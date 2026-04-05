{ lib }:
{
  autocmds = [
    {
      desc = "Updates modified field in markdown YAML";
      pattern = [ "*.md" ];
      event = [ "BufWritePre" ];
      callback = lib.generators.mkLuaInline ''
    function(args)
      local bufnr = args.buf
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 50, false)
      if lines[1] == "---" then
        for i = 2, #lines do
          if lines[i] == "---" then 
            break
          end

          if lines[i]:match("^modified:") then
            local prefix = lines[i]:match("^(.-):")
            local updated_time = os.date("%Y-%m-%dT%H:%M:%SZ")
            vim.api.nvim_buf_set_lines(
              bufnr, 
              i-1, 
              i, 
              false, 
              { prefix .. ": " .. updated_time}
            )
            break
          end
        end
      end
    end
      '';
    }
  ];
}
