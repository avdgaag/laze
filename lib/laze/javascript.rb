module Laze
  # A special kind of Item aimed at javascript files.
  class Javascript < Asset
    include_plugins :javascript
  end
end