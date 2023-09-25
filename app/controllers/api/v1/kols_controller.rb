class Api::V1::KolsController < ApplicationController
  def index
    kols = User.with_role(:kol).joins(:profile).where("profile.status = 'valid'")
    pagy, kols = pagy(kols, page: page_number, items: page_size)
    render json: UserSerializer.new(kols, { meta: pagy_metadata(pagy) }), status: 200
  end
end
