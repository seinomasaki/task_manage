# frozen_string_literal: true
module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = ("current #{sort_oder}" if column == sort_column)
    oder = column == sort_column && sort_oder == 'asc' ? 'desc' : 'asc'
    link_to title, { sort: column, oder: oder }, class: css_class
  end
end
