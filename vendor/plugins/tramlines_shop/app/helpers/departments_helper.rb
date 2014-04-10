module DepartmentsHelper

  def current_department
    @department || @product.try(:department)
  end

  def current_department?(department)
    department == current_department
  end
  
  def department_id_options(stop_at = nil, nodes = Department.roots)
    nodes.inject([]) do |memo, department|
      if department == stop_at
        memo
      else
        node_result = [[department.name_with_depth("-"), department.id]]
        child_results = department_id_options(stop_at, department.children)
        memo + node_result + child_results
      end
    end
  end
  
  def viewing_shop?
    controller_name.in? %w{departments products orders carts carts}
  end
  
end