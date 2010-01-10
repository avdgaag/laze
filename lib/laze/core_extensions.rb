class Hash
  def stringify_keys
    inject({}) do |output, (key, value)|
      output[(key.to_s rescue key) || key] = value
      output
    end
  end

  def symbolize_keys
    inject({}) do |output, (key, value)|
      output[(key.to_sym rescue key) || key] = value
      output
    end
  end
end