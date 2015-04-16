$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'load_config'
require 'byebug'

describe "general load_config functionality" do
  before :all do
    CONFIG = load_config("./spec/files/settings.conf", ["ubuntu", :production])
  end

  it "reads in a conf file" do
    expect(CONFIG).to_not be_nil
  end

  it "returns a group" do
    expect(CONFIG.common).to_not be_nil
  end

  it "returns a numeric value" do
    # > CONFIG.common.paid_users_size_limit
    # returns 2147483648
    expect(CONFIG.common.paid_users_size_limit).to eq(2147483648)
  end
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