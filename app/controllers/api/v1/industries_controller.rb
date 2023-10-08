class Api::V1::IndustriesController < ApplicationController
  def index
    @industries = Industry.all
    render json: IndustryWithoutDescriptionSerializer.new(@industries), status: 200
  end
end
