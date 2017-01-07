class JobDecorator < Draper::Decorator
  delegate_all
  decorates :job
  
  def primary_hiring_manager
    hm = object.job.hiring_managers.first
    hm.nil? ? "" : "#{hm.first} #{hm.last}"
  end
  # For help with Draper, see: https://github.com/drapergem/draper
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
