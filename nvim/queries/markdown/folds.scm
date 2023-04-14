; avoids folding sections without headings
; adapted from: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/markdown/folds.scm
(
  [
    (fenced_code_block)
    (indented_code_block)
    (list)
    (section (atx_heading))
  ] @fold
  (#trim! @fold)
)
