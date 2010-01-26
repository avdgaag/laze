module Laze
  # A special Item aimed at Cascading Stylesheets (CSS-files)
  class Stylesheet < Asset
    include_plugins :stylesheet
  end
end