module Paginable
  extend ActiveSupport::Concern

  # Returns paginated records with pagination metadata
  def paginate(records)
    paginated = records.page(page).per(per_page)
    
    {
      data: paginated,
      meta: {
        current_page: paginated.current_page,
        total_pages: paginated.total_pages,
        total_count: paginated.total_count,
        per_page: per_page
      }
    }
  end

  private

  def page
    params[:page] || 1
  end

  def per_page
    (params[:per_page] || 25).to_i.clamp(1, 100)
  end
end
