require('mkdnflow').setup({
  perspective = {
    priority = 'current'
    },
  links = {
    transform_explicit = function(text)
      return text
    end
    }
})

