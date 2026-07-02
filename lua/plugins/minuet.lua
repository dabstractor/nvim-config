return {
  -- Inline AI completion via z.ai's GLM Coding Plan (OpenAI-compatible endpoint).
  -- Uses the nvim-isolated key Z_AI_API_KEY_NVIM. Surfaced as a blink source.
  'milanglacier/minuet-ai.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('minuet').setup {
      provider = 'openai_compatible',
      provider_options = {
        openai_compatible = {
          model = 'glm-4.6',
          name = 'z.ai',
          end_point = 'https://api.z.ai/api/coding/paas/v4/chat/completions',
          api_key = 'Z_AI_API_KEY_NVIM',
          stream = true,
          optional = {
            max_tokens = 256,
            -- GLM is a reasoning model; disable thinking so completions are fast.
            thinking = { type = 'disabled' },
          },
        },
      },
    }
  end,
}
