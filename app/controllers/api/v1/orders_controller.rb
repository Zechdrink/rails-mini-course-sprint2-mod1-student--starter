
module API
    module V1
        class OrdersController < ApplicationController

            def index
                if params[:customer_id].present?
                    @orders = Order.where(customer_id: params[:customer_id])
                else
                    @orders = Order.all

                render json: @orders
            end

            def create
                @order = Order.new(customer_id: params[:customer_id], status: :pending)


                if @order.save
                    render json: @order, status: :created, location: api_v1_order_url(@order)
                else
                    render json: { message: "There was an error creating the order" }, status: :unprocessable_entity
                end
            end

            def show 
                @order = Order.find(params[:id])

                render json: format_customer(@order)
            end

            def ship
                @order = Order.find(params[:id])

                if @order.update(order_params)
                    render json: @order, status: :shipped
                  else
                    render json: @order.errors, status: :unprocessable_entity
                  end
            end

            private 
            def order_params
                params.require(:orders).permit(:status)
            end


        end
    end
end

