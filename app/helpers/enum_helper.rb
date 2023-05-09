module EnumHelper
  def enum_options_for_select(model, enum, selected = nil)
    localized = Hash[
      model.public_send(enum).map do |k, v|
        [model.human_attribute_name("#{enum}.#{k}"), k]
      end
    ]
    options_for_select(localized, selected)
  end
end
