class JobSerializer < BaseSerializer
  attributes :title, :description, :price, :status

  attribute :owner do |job|
    ProfileSerializer.new(job.profile).as_json
  end

  attribute :kol do |job|
    return nil if job.kol_id.blank?

    ProfileSerializer.new(Profile.find_by(id: job.kol_id)).as_json
  end
end
