-- C-style line comments for OpenSCAD (replaces the old Comment.ft setup that
-- lived in lua/plugins/openscad.lua). Native `gc` reads this commentstring.
vim.bo.commentstring = '// %s'
