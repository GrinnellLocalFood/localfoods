module ApplicationHelper
	def title
		base_title ="Local Foods Coop"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
    end
  end



def sortable(column, remote, producer, title = nil)
  title ||= column.titleize
  css_class = column == sort_column ? "current #{sort_direction}" : nil
  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"

  if remote 
  	link_to (title, show_in_index_inventory_path(producer, :sort => column, :direction => direction), :remote => true, :class => css_class)
  else
  	link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
end


end
