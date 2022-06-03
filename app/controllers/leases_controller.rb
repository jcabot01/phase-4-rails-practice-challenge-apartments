class LeasesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  #POST /leases
  def create
    lease = Lease.create!(lease_params)
    render json: lease, status: :accepted 
  end

  #DELETE /leases/:id
  def destroy
    lease = find_lease
    lease.destroy
    head :no_content
  end


  private
  def find_lease
    Lease.find(params[:id])
  end

  def lease_params
    params.permit(:rent, :tenant_id, :apartment_id)
  end

  def render_not_found_response
    render json: { error: "Lease not found" }, status: :not_found
  end

  def render_unprocessable_entity_response(exception)
    render json: { errors:exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end
