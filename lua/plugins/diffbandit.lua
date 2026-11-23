-- Diff viewer with a connector gutter: both sides keep their own
-- shape and line numbers. `g?` inside a view shows its keys.
--
-- :DiffBandit left right          two files
-- :DiffBanditGit                  repo changes (commit panel: C)
-- :DiffBanditFolderDiff a b       two trees
-- :DiffBanditGitLog / GitCommit / GitCompare / GitCheckout / Merge
return {
  'CoreyKaylor/diffbandit.nvim',
  cmd = {
    'DiffBandit',
    'DiffBanditBuffers',
    'DiffBanditFolderDiff',
    'DiffBanditGit',
    'DiffBanditGitCurrent',
    'DiffBanditCommitPanel',
    'DiffBanditGitMenu',
    'DiffBanditGitLog',
    'DiffBanditGitCommit',
    'DiffBanditGitCompare',
    'DiffBanditGitCheckout',
    'DiffBanditMerge',
    'DiffBanditLaunch',
  },
  opts = {},
}
