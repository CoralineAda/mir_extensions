require 'singleton'
require 'friendly_id'
require 'core_ext/core_ext'

module MirExtensions
  
  # Constants ======================================================================================
  
  MONTHS = {0 => "JAN", 1 => "FEB", 2 => "MAR", 3 => "APR", 4 => "MAY", 5 => "JUN", 6 => "JUL", 7 => "AUG", 8 => "SEP", 9 => "OCT", 10 => "NOV", 11 => "DEC"}

  STATE_CODES = { 'Alabama' => 'AL', 'Alaska' => 'AK', 'Arizona' => 'AZ', 'Arkansas' => 'AR', 'California' => 'CA', 'Colorado' => 'CO', 'Connecticut' => 'CT', 'Delaware' => 'DE', 'Florida' => 'FL', 'Georgia' => 'GA', 'Hawaii' => 'HI', 'Idaho' => 'ID', 'Illinois' => 'IL', 'Indiana' => 'IN', 'Iowa' => 'IA', 'Kansas' => 'KS', 'Kentucky' => 'KY', 'Louisiana' => 'LA', 'Maine' => 'ME', 'Maryland' => 'MD', 'Massachusetts' => 'MA', 'Michigan' => 'MI', 'Minnesota' => 'MN', 'Mississippi' => 'MS', 'Missouri' => 'MO', 'Montana' => 'MT', 'Nebraska' => 'NE', 'Nevada' => 'NV', 'New Hampshire' => 'NH', 'New Jersey' => 'NJ', 'New Mexico' => 'NM', 'New York' => 'NY', 'North Carolina' => 'NC', 'North Dakota' => 'ND', 'Ohio' => 'OH', 'Oklahoma' => 'OK', 'Oregon' => 'OR', 'Pennsylvania' => 'PA', 'Puerto Rico' => 'PR', 'Rhode Island' => 'RI', 'South Carolina' => 'SC', 'South Dakota' => 'SD', 'Tennessee' => 'TN', 'Texas' => 'TX', 'Utah' => 'UT', 'Vermont' => 'VT', 'Virginia' => 'VA', 'Washington' => 'WA', 'Washington DC' => 'DC', 'West Virginia' => 'WV', 'Wisconsin' => 'WI', 'Wyoming' => 'WY', 'Alberta' => 'AB', 'British Columbia' => 'BC', 'Manitoba' => 'MB', 'New Brunswick' => 'NB', 'Newfoundland and Labrador' => 'NL', 'Northwest Territories' => 'NT', 'Nova Scotia' => 'NS', 'Nunavut' => 'NU', 'Ontario' => 'ON', 'Prince Edward Island' => 'PE', 'Quebec' => 'QC', 'Saskatchewan' => 'SK', 'Yukon' => 'YT' }

  # General Utility Methods ========================================================================

  def self.canonical_url(url)
    (url + '/').gsub(/\/\/$/,'/')
  end

  def self.month_name_for(number)
    MONTHS[number]
  end

  def self.normalize_slug(text)
    _normalized = text.gsub(/[\W]/u, ' ').strip.gsub(/\s+/u, '-').gsub(/-\z/u, '').downcase.to_s
    _normalized.gsub!(/[-]+/, '-') # truncate multiple -
    _normalized
  end
  
  def self.state_code_for(state_name)
    STATE_CODES[state_name]
  end
  
  def self.state_name_for(abbreviation)
    STATE_CODES.invert[abbreviation]
  end

  module HelperExtensions
  
    def action?( expression )
      !! ( expression.class == Regexp ? controller.action_name =~ expression : controller.action_name == expression )
    end
  
    # Formats an array with HTML line breaks, or the specified delimiter.
    def array_to_lines(array, delimiter = '<br />')
      array.blank? ? nil : array * delimiter
    end
  
    def checkmark
      %{<div class="checkmark"></div>}
    end
  
    def controller?( expression )
      !! ( expression.class == Regexp ? controller.controller_name =~ expression : controller.controller_name == expression )
    end
  
    # Display CRUD icons or links, according to setting in use_crud_icons method.
    #
    # In application_helper.rb:
    #
    #   def use_crud_icons
    #     true
    #   end
    #
    # Then use in index views like this:
    #
    # <td class="crud_links"><%= crud_links(my_model, 'my_model', [:show, :edit, :delete]) -%></td>
    #
    def crud_links(model, instance_name, actions, args={})
      _html = ""
      _options = args.keys.empty? ? '' : ", #{args.map{|k,v| ":#{k} => #{v}"}}"
  
      if use_crud_icons
        if actions.include?(:show)
          _html << eval("link_to image_tag('/images/icons/view.png', :class => 'crud_icon'), model, :title => 'View'#{_options}")
        end
        if actions.include?(:edit)
          _html << eval("link_to image_tag('/images/icons/edit.png', :class => 'crud_icon'), edit_#{instance_name}_path(model), :title => 'Edit'#{_options}")
        end
        if actions.include?(:delete)
          _html << eval("link_to image_tag('/images/icons/delete.png', :class => 'crud_icon'), model, :confirm => 'Are you sure? This action cannot be undone.', :method => :delete, :title => 'Delete'#{_options}")
        end
      else
        if actions.include?(:show)
          _html << eval("link_to 'View', model, :title => 'View', :class => 'crud_link'#{_options}")
        end
        if actions.include?(:edit)
          _html << eval("link_to 'Edit', edit_#{instance_name}_path(model), :title => 'Edit', :class => 'crud_link'#{_options}")
        end
        if actions.include?(:delete)
          _html << eval("link_to 'Delete', model, :confirm => 'Are you sure? This action cannot be undone.', :method => :delete, :title => 'Delete', :class => 'crud_link'#{_options}")
        end
      end
      _html
    end
  
    # Display CRUD icons or links, according to setting in use_crud_icons method.
    # This method works with nested resources.
    # Use in index views like this:
    #
    # <td class="crud_links"><%= crud_links_for_nested_resource(@my_model, my_nested_model, 'my_model', 'my_nested_model', [:show, :edit, :delete]) -%></td>
    #
    def crud_links_for_nested_resource(model, nested_model, model_instance_name, nested_model_instance_name, actions, args={})
      _html = ""
      if use_crud_icons
        if actions.include?(:show)
          _html << eval("link_to image_tag('/images/icons/view.png', :class => 'crud_icon'), #{model_instance_name}_#{nested_model_instance_name}_path(model, nested_model), :title => 'View'")
        end
  
        if actions.include?(:edit)
          _html << eval("link_to image_tag('/images/icons/edit.png', :class => 'crud_icon'), edit_#{model_instance_name}_#{nested_model_instance_name}_path(model, nested_model), :title => 'Edit'")
        end
  
        if actions.include?(:delete)
          _html << eval("link_to image_tag('/images/icons/delete.png', :class => 'crud_icon'), #{model_instance_name}_#{nested_model_instance_name}_path(model, nested_model), :method => :delete, :confirm => 'Are you sure? This action cannot be undone.', :title => 'Delete'")
        end
      end
      _html
    end
  
    # DRY way to return a legend tag that renders correctly in all browsers. This variation allows
    # for more "stuff" inside the legend tag, e.g. expand/collapse controls, without having to worry
    # about escape sequences.
    #
    # Sample usage:
    #
    #   <%- legend_block do -%>
    #     <span id="hide_or_show_backlinks" class="show_link" style="background-color: #999999;
    #     border: 1px solid #999999;" onclick="javascript:hide_or_show('backlinks');"></span>Backlinks (<%=
    #     @google_results.size -%>)
    #   <%- end -%>
    #
    def legend_block(&block)
      concat content_tag(:div, capture(&block), :class => "faux_legend")
    end
  
    # DRY way to return a legend tag that renders correctly in all browsers
    def legend_tag(text, args={})
      _html = %{<div id="#{args[:id]}" class="faux_legend">#{text}</div>\r}
      _html.gsub!(/ id=""/,'')
      _html.gsub!(/ class=""/,'')
      _html
    end
  
    def meta_description(content=nil)
      content_for(:meta_description) { content } unless content.blank?
    end
  
    def meta_keywords(content=nil)
      content_for(:meta_keywords) { content } unless content.blank?
    end
  
    def models_for_select( models, label = 'name' )
      models.map{ |m| [m[label], m.id] }.sort_by{ |e| e[0] }
    end
  
    def options_for_array( a, selected = nil, prompt = select_prompt )
      "<option value=''>#{prompt}</option>" + a.map{ |_e| _flag = _e[0].to_s == selected ? 'selected="1"' : ''; _e.is_a?(Array) ? "<option value=\"#{_e[0]}\" #{_flag}>#{_e[1]}</option>" : "<option>#{_e}</option>" }.to_s
    end
  
    # Create a link that is opaque to search engine spiders.
    def obfuscated_link_to(path, image, label, args={})
      _html = %{<form action="#{path}" method="get" class="obfuscated_link">}
      _html << %{ <fieldset><input alt="#{label}" src="#{image}" type="image" /></fieldset>}
      args.each{ |k,v| _html << %{  <div><input id="#{k.to_s}" name="#{k}" type="hidden" value="#{v}" /></div>} }
      _html << %{</form>}
      _html
    end
  
    # Wraps the given HTML in Rails' default style to highlight validation errors, if any.
    def required_field_helper( model, element, html )
      if model && ! model.errors.empty? && element.is_required
        return content_tag( :div, html, :class => 'fieldWithErrors' )
      else
        return html
      end
    end
  
    def select_prompt
      "Select..."
    end
    
    def select_prompt_option
      "<option value=''>#{select_prompt}</option>"
    end
  
    # Use on index pages to create dropdown list of filtering criteria.
    # Populate the filter list using a constant in the model corresponding to named scopes.
    #
    # Usage:
    #
    # - item.rb:
    #
    #     named_scope :active,   :conditions => { :is_active => true }
    #     named_scope :inactive, :conditions => { :is_active => false }
    #
    #     FILTERS = [
    #       {:scope => "all",       :label => "All"},
    #       {:scope => "active",    :label => "Active Only"},
    #       {:scope => "inactive",  :label => "Inactive Only"}
    #     ]
    #
    # - items/index.html.erb:
    #
    #     <%= select_tag_for_filter("items", @filters, params) -%>
    #
    # - items_controller.rb:
    #
    #     def index
    #       @filters = Item::FILTERS
    #       if params[:show] && params[:show] != "all" && @filters.collect{|f| f[:scope]}.include?(params[:show])
    #         @items = eval("@items.#{params[:show]}.order_by(params[:by], params[:dir])")
    #       else
    #         @items = @items.order_by(params[:by], params[:dir])
    #       end
    #       ...
    #     end
    #
    def select_tag_for_filter(model, nvpairs, params)
      return unless model && nvpairs && ! nvpairs.empty?
      options = { :query => params[:query] }
      _url = url_for(eval("#{model}_url(options)"))
      _html = %{<label for="show">Show:</label><br />}
      _html << %{<select name="show" id="show" onchange="window.location='#{_url}' + '?show=' + this.value">}
      nvpairs.each do |pair|
        _html << %{<option value="#{pair[:scope]}"}
        if params[:show] == pair[:scope] || ((params[:show].nil? || params[:show].empty?) && pair[:scope] == "all")
          _html << %{ selected="selected"}
        end
        _html << %{>#{pair[:label]}}
        _html << %{</option>}
      end
      _html << %{</select>}
    end
  
    # Returns a link_to tag with sorting parameters that can be used with ActiveRecord.order_by.
    #
    # To use standard resources, specify the resources as a plural symbol:
    #   sort_link(:users, 'email', params)
    #
    # To use resources aliased with :as (in routes.rb), specify the aliased route as a string.
    #   sort_link('users_admin', 'email', params)
    #
    # You can override the link's label by adding a labels hash to your params in the controller:
    #   params[:labels] = {'user_id' => 'User'}
    def sort_link(model, field, params, html_options={})
      if (field.to_sym == params[:by] || field == params[:by]) && params[:dir] == "ASC"
        classname = "arrow-asc"
        dir = "DESC"
      elsif (field.to_sym == params[:by] || field == params[:by])
        classname = "arrow-desc"
        dir = "ASC"
      else
        dir = "ASC"
      end
  
      options = {
        :anchor => html_options[:anchor] || nil,
        :by => field,
        :dir => dir,
        :query => params[:query],
        :show => params[:show]
      }
  
      options[:show] = params[:show] unless params[:show].blank? || params[:show] == 'all'
  
      html_options = {
        :class => "#{classname} #{html_options[:class]}",
        :style => "color: white; font-weight: #{params[:by] == field ? "bold" : "normal"}; #{html_options[:style]}",
        :title => "Sort by this field"
      }
  
      field_name = params[:labels] && params[:labels][field] ? params[:labels][field] : field.titleize
  
      _link = model.is_a?(Symbol) ? eval("#{model}_url(options)") : "/#{model}?#{options.to_params}"
      link_to(field_name, _link, html_options)
    end
  
    # Tabbed interface helpers =======================================================================
  
    # Returns formatted tabs with appropriate JS for activation. Use in conjunction with tab_body.
    #
    # Usage:
    #
    #   <%- tabset do -%>
    #     <%= tab_tag :id => 'ppc_ads', :label => 'PPC Ads', :state => 'active' %>
    #     <%= tab_tag :id => 'budget' %>
    #     <%= tab_tag :id => 'geotargeting' %>
    #   <%- end -%>
    #
    def tabset(&proc)
      concat %{
        <div class="jump_links">
          <ul>
      }
      yield
      concat %{
          </ul>
        </div>
        <br style="clear: both;" /><br />
        <input type="hidden" id="show_tab" />
        <script type="text/javascript">
          function hide_all_tabs() { $$('.tab_block').invoke('hide'); }
          function activate_tab(tab) {
            $$('.tab_control').each(function(elem){ elem.className = 'tab_control'});
            $('show_' + tab).className = 'tab_control active';
            hide_all_tabs();
            $(tab).toggle();
            $('show_tab').value = tab
          }
          function sticky_tab() { if (location.hash) { activate_tab(location.hash.gsub('#','')); } }
          Event.observe(window, 'load', function() { sticky_tab(); });
        </script>
      }
    end
  
    # Returns a tab body corresponding to tabs in a tabset. Make sure that the id of the tab_body
    # matches the id provided to the tab_tag in the tabset block.
    #
    # Usage:
    #
    #   <%- tab_body :id => 'ppc_ads', :label => 'PPC Ad Details' do -%>
    #     PPC ads form here.
    #   <%- end -%>
    #
    #   <%- tab_body :id => 'budget' do -%>
    #     Budget form here.
    #   <%- end -%>
    #
    #   <%- tab_body :id => 'geotargeting' do -%>
    #     Geotargeting form here.
    #   <%- end -%>
    #
    def tab_body(args, &proc)
      concat %{<div id="#{args[:id]}" class="tab_block form_container" style="display: #{args[:display] || 'none'};">}
      concat %{#{legend_tag args[:label] || args[:id].titleize }}
      concat %{<a name="#{args[:id]}"></a><br />}
      yield
      concat %{</div>}
    end
  
    # Returns the necessary HTML for a particular tab. Use inside a tabset block.
    # Override the default tab label by specifying a :label parameter.
    # Indicate that the tab should be active by setting its :state to 'active'.
    # (NOTE: You must define a corresponding  CSS style for active tabs.)
    #
    # Usage:
    #
    #   <%= tab_tag :id => 'ppc_ads', :label => 'PPC Ads', :state => 'active' %>
    #
    def tab_tag(args, *css_class)
      %{<li id="show_#{args[:id]}" class="tab_control #{args[:state]}" onclick="window.location='##{args[:id]}'; activate_tab('#{args[:id]}');">#{args[:label] || args[:id].to_s.titleize}</li>}
    end
  
    # ================================================================================================
  
    def tag_for_collapsible_row(obj, params)
      _html = ""
      if obj && obj.respond_to?(:parent) && obj.parent
        _html << %{<tr class="#{obj.class.name.downcase}_#{obj.parent.id} #{params[:class]}" style="display: none; #{params[:style]}">}
      else
        _html << %{<tr class="#{params[:class]}" style="#{params[:style]}">}
      end
      _html
    end
  
    def tag_for_collapsible_row_control(obj)
      _base_id = "#{obj.class.name.downcase}_#{obj.id}"
      _html = %{<div id="hide_or_show_#{_base_id}" class="show_link" style="background-color: #999999; border: 1px solid #999999;" onclick="javascript:hide_or_show('#{_base_id}');"></div>}
    end
  
    # Create a set of tags for displaying a field label with inline help.
    # Field label text is appended with a ? icon, which responds to a click
    # by showing or hiding the provided help text.
    #
    # Sample usage:
    #
    #   <%= tag_for_label_with_inline_help 'Relative Frequency', 'rel_frequency', 'Relative frequency of search traffic for this keyword across multiple search engines, as measured by WordTracker.' %>
    #
    # Yields:
    #
    #   <label for="rel_frequency">Relative Frequency: <%= image_tag "/images/help_icon.png", :onclick => "$('rel_frequency_help').toggle();", :class => 'inline_icon' %></label><br />
    #   <div class="inline_help" id="rel_frequency_help" style="display: none;">
    #     <p>Relative frequency of search traffic for this keyword across multiple search engines, as measured by WordTracker.</p>
    #   </div>
    def tag_for_label_with_inline_help( label_text, field_id, help_text )
      _html = ""
      _html << %{<label for="#{field_id}">#{label_text}}
      _html << %{<img src="/images/icons/help_icon.png" onclick="$('#{field_id}_help').toggle();" class='inline_icon' />}
      _html << %{</label><br />}
      _html << %{<div class="inline_help" id="#{field_id}_help" style="display: none;">}
      _html << %{<p>#{help_text}</p>}
      _html << %{</div>}
      _html
    end
  
    # Create a set of tags for displaying a field label followed by instructions.
    # The instructions are displayed on a new line following the field label.
    #
    # Usage:
    #
    #   <%= tag_for_label_with_instructions 'Status', 'is_active', 'Only active widgets will be visible to the public.' %>
    #
    # Yields:
    #
    #   <label for="is_active">
    #     Status<br />
    #     <span class="instructions">Only active widgets will be visible to the public.</span>
    #   <label><br />
    def tag_for_label_with_instructions( label_text, field_id, instructions )
      _html = ""
      _html << %{<label for="#{field_id}">#{label_text}}
      _html << %{<span class="instructions">#{instructions}</span>}
      _html << %{</label><br />}
      _html
    end
  
  end  
  
end

ActionView::Base.send :include, MirExtensions::HelperExtensions
