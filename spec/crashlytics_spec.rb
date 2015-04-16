describe "general load_config functionality" do
  it "reads in a conf file" do
    CONFIG = load_config("./spec/files/settings.conf", ["ubuntu", :production])

    expect(CONFIG).to_not be_nil
  end
# > CONFIG.common.paid_users_size_limit
# returns 2147483648
# > CONFIG.ftp.name
# returns “hello there, ftp uploading”
# > CONFIG.http.params
# returns [“array”, “of”, “values”]
# > CONFIG.ftp.lastname
# returns nil
# > CONFIG.ftp.enabled
# returns false  (permitted bool values are “yes”, “no”, “true”,
# “false”, 1, 0)
# > CONFIG.ftp[:path]
# returns “/etc/var/uploads”
# > CONFIG.ftp
# returns a symbolized hash: {:name => “http uploading”,
# !   !     !     !     !      :path => “/etc/var/uploads”,
#!    !     !     !     !      :enabled => false}
end