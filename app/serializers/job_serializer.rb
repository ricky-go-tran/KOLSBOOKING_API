# == Schema Information
#
# Table name: jobs
#
#  id          :bigint           not null, primary key
#  profile_id  :bigint           not null
#  kol_id      :bigint           not null
#  title       :string           not null
#  description :text
#  price       :float            not null
#  status      :string           default("post"), not null
#  stripe_id   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  requirement :text             default("Requirement content"), not null
#
class JobSerializer < BaseSerializer
  attributes :id, :title, :description, :requirement, :benefits, :time_work, :price, :status, :created_at, :stripe_id

  attribute :owner do |job|
    ProfileSerializer.new(job.profile).as_json
  end

  attribute :image do |job|
    if job.image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(job.image, only_path: true)
    else
      'null'
    end
  end
end
