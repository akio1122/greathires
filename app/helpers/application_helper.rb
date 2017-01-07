module ApplicationHelper
  def cc_html(options={}, &blk)
    attrs = options.map { |(k, v)| " #{h k}='#{h v}'" }.join('')
    [ "<!--[if lt IE 7]> <html#{attrs} class='lt-ie9 lt-ie8 lt-ie7'> <![endif]-->",
      "<!--[if IE 7]>    <html#{attrs} class='lt-ie9 lt-ie8'> <![endif]-->",
      "<!--[if IE 8]>    <html#{attrs} class='lt-ie9'> <![endif]-->",
      "<!--[if gt IE 8]><!--> <html#{attrs} class=''> <!--<![endif]-->",
      capture_haml(&blk).strip,
      "</html>"
    ].join("\n")
  end
  def h(str); Rack::Utils.escape_html(str); end


  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-danger alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-danger"
      when :alert
        "alert-info" #was 'alert-warning'
      when :notice
        "alert-info"
      else
        "alert-info"
    end
  end

  
#TODO: Examine pre-existing methods below and remove unnecessary ones or move to appropraite modules. 


#TODO: Remove use of urlify in place use Rails parameterize method
  def urlify(str)
    URLify.urlify str, "-"
  end

  def time_by_zone(time)
    l(time.in_time_zone(current_user.try(:time_zone)) , :format => :humanize_time)
  end

  #def setup_job(job)
  #  returning(job) do |p|
  #    p.job_requirements.build if p.job_requirements.empty?
  #  end
  #end

  def link_to_add_fields(name, f, association, extra_html_options={}, locals={}, partial_path=nil)
    partial = association.to_s.singularize + "_fields"
    partial = "#{partial_path}/#{partial}" if partial_path
    extra_html_options[:class] = '' if extra_html_options[:class].nil?
    extra_html_options[:class] += ' add_fields'

    new_object = f.object.send(association).new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(partial, locals.merge(f: builder))
    end
    link_to(name, '#', extra_html_options.merge(data: {id: id, fields: fields.gsub("\n", "")}))
  end

  def nav_active_class(menu)
    return "active" if controller_name == menu
  end

  def nav_highlighted_class(menu)
    return "highlighted" if controller_name == menu
  end
   
end
