class GoogleAuthsController < ApplicationController
  def callback
    puts '##########################################'
    render json: 200, status: 200
  end
end
