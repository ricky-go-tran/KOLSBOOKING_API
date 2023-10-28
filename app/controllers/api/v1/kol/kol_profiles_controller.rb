class Api::V1::Kol::KolProfilesController < Api::V1::Kol::BaseController
  def index
    render json: KolByProfileDetailSerializer.new(current_user.profile), status: 200
  end

  def create
    @kol_profile = KolProfile.new(kol_profile_params)
    current_user.delete_roles
    current_user.add_role(:kol)
    if @kol_profile.save
      render json: KolProfileSerializer.new(@kol_profile), status: 201
    else
      render json: @kol_profile.errors.full_messages, status: 422
    end
  end

  def gallaries
    render json: GallariesSerializer.new(current_user.profile), status: 200
  end

  def edit_kol_profile
    @kol_profile = current_user.profile.kol_profile
    render json: KolWithIndustryAssociationSerializer.new(@kol_profile), status: 200
  end

  def change
    @kol_profile = current_user.profile.kol_profile
    if @kol_profile.update(kol_profile_params)
      render json: KolProfileSerializer.new(@kol_profile), status: 200
    else
      render json: @kol_profile.errors.full_messages, status: 422
    end
  end

  def change_video
    @kol_profile = current_user.profile.kol_profile
    if @kol_profile.update(kol_profile_video_params)
      render json: KolProfileSerializer.new(@kol_profile), status: 200
    else
      render json: @kol_profile.errors.full_messages, status: 422
    end
  end

  def upload_image
    @kol_profile = current_user.profile.kol_profile
    if params[:kol_profile][:gallaries].present?
      params[:kol_profile][:gallaries].each do |image|
        @kol_profile.gallaries.attach(image)
      end
    end
    if @kol_profile.save
      render json: KolProfileSerializer.new(@kol_profile), status: 200
    else
      render json: @kol_profile.errors.full_messages, status: 422
    end
  end

  def delete_image
    params[:kol_profile][:id_list].each do |item|
      image = ActiveStorage::Attachment.find(item[:id])
      image.purge
    end
    render json: { message: 'Successfuly destroy' }, status: 200
  end

  private

  def kol_profile_params
    params.require(:kol_profile).permit(:tiktok_path, :youtube_path, :facebook_path, :instagram_path, :about_me, industry_associations_attributes: [:id, :industry_id, :_destroy])
  end

  def kol_profile_video_params
    params.require(:kol_profile).permit(:intro_video)
  end

  def kol_profile_gallaries_params
    params.require(:kol_profile).permit(gallaries: [])
  end
end
