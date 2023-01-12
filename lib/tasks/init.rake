# encoding: UTF-8

task :init => :environment do
  unless User.find_by_ident("admin")
    user = User.create! email: "admin@taskover.com",
                        ident: "admin",
                        password: "admin123",
                        password_confirmation: "admin123",
                        confirmed_at: Time.now
  end
end
