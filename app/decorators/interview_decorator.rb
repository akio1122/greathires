class InterviewDecorator < Draper::Decorator
  delegate_all
  decorates :interview

 def interviewer_stage
    object.interview_round.nil? ? 'N/A' : object.interview_round.name
  end

  def picture_url
    '#'
  end

  def full_name
    object.user.nil? ? 'Break' : object.user.full_name
  end  
  
  
  def start_hours
    object.scheduled_at.strftime('%I').to_i if object.scheduled_at
  end

  def start_minutes
    object.scheduled_at.strftime('%M') if object.scheduled_at
  end

  def appm
    object.scheduled_at.strftime('%P') if object.scheduled_at
  end

  def start_on
    object.scheduled_at.in_time_zone(object.timezone_name)
  end

  def finish_on
    start_on + length.minutes
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


