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

  it "returns a string", string: true do
    # > CONFIG.ftp.name
    # returns “hello there, ftp uploading”
    expect(CONFIG.ftp.name).to eq("hello there, ftp uploading")
  end

  it "returns an array of values" do
    # > CONFIG.http.params
    # returns [“array”, “of”, “values”]
    expect(CONFIG.http.params).to be_kind_of(Array)
    expect(CONFIG.http.params[0]).to eq("array")
    expect(CONFIG.http.params[1]).to eq("of")
    expect(CONFIG.http.params[2]).to eq("values")
  end

  it "returns nil for undefined values" do
    # > CONFIG.ftp.lastname
    # returns nil
    expect(CONFIG.ftp.lastname).to be_nil
  end

  it "returns boolean values" do
    # > CONFIG.ftp.enabled
    # returns false  (permitted bool values are “yes”, “no”, “true”,
    # “false”, 1, 0)
    expect(CONFIG.ftp.enabled).to eq(false)
  end

  it "supports overrides" do
    # > CONFIG.ftp[:path]
    # returns “/etc/var/uploads”
    expect(CONFIG.ftp[:path]).to eq("/etc/var/uploads")
  end

  it "returns a symbolized hash" do
    # > CONFIG.ftp
    # returns a symbolized hash: {:name => “http uploading”,
    # !   !     !     !     !      :path => “/etc/var/uploads”,
    #!    !     !     !     !      :enabled => false}
    expect(CONFIG.ftp).to be_kind_of(Hash)
    expect(CONFIG.ftp[:name]).to eq("hello there, ftp uploading")
    expect(CONFIG.ftp[:path]).to eq("/etc/var/uploads")
    expect(CONFIG.ftp[:enabled]).to eq(false)
  end
end