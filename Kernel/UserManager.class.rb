require 'json'
require 'digest/md5'
load './User.class.rb'

class UserManager
  private
    attr_accessor @user
    attr_accessor @file_type = '.json'

  public
    def get_user(user_email)
      md5 = Digest::MD5.hexdigest(user_email)
      char = md5.chars.first
      path = "./#{char}/#{md5}#{@file_type}"
      if File.exist?(path)
        @user = User.new
        return @user.from_json_file path
      end
    end

    def save_user(json_or_user)
      @user = User.new
      @user.from_json json_or_user
    end
end