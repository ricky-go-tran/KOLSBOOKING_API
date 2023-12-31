require 'factory_bot_rails'

@time = 10
industries = []
users = []
profiles = []
jobs = []
notifications = []
kol_users = []
kol_profiles = []
kol_profiles_kol = []
reports = []
businesses =[]


#Industry

@time.times do
  industries.push(FactoryBot.create(:industry))
end

# Normal User
@time.times do
  user = FactoryBot.create(:user)
  users.push(user)
  profile = FactoryBot.create(:profile, user: user)
  profiles.push(profile)
  businesses.push(FactoryBot.create(:bussiness, profile: profile))

end


# Specilize User
user_admin = FactoryBot.create(:user)
user_admin.delete_roles
profile_admin = FactoryBot.create(:profile, user: user_admin)
user_admin.add_role :admin

@time.times do
  user_kol = FactoryBot.create(:user)
  user_kol.delete_roles
  user_kol.add_role :kol
  kol_users.push(user_kol)
  profile_kol = FactoryBot.create(:profile, user: user_kol)
  profile_kol_kol = FactoryBot.create(:kol_profile, profile: profile_kol)
  kol_profiles.push(profile_kol)
  kol_profiles_kol.push(profile_kol_kol)
end

# Task
kol_profiles_kol.each do |kol_profile|
  FactoryBot.create(:task, kol_profile: kol_profile)
end

# Jobs
profiles.each do |profile|
  @time.times do
    jobs.push(FactoryBot.create(:job, profile: profile))
  end
end

# Notification
profiles.each do |profile|
  @time.times do
    FactoryBot.create(:notification, sender: profile, receiver: kol_profiles[0])
  end
end

# Reports
profiles.each do |profile|
  @time.times do
    FactoryBot.create(:report, profile: profile, reportable:  jobs[0])
  end
end

# Emoji
profiles.each do |profile|
  @time.times do
    FactoryBot.create(:emoji, profile: profile, emojiable:  jobs[0])
  end
end


# user = User.joins(:roles).where(roles: {name: 'base'})
# user.each do |user|
#   if user.profile.present?
#     tp = ['business', 'personal'].sample
#     Bussiness.create(type_profile: tp, overview: "Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec ullamcorper nulla non metus auctor fringilla. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec ullamcorper nulla", profile_id: user.profile.id)
#   end
# end
