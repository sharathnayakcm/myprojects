require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'json'

class LoginController < Rho::RhoController
  include BrowserHelper

  # GET /Login
  def index
    @user_info = @@get_result['user']
    render :back => '/app'
  end


  def new
    @login = Login.new
    render :action => :new, :back => url_for(:action => :index)
  end

  def edit
    @user_info = @@get_result['user']
    render :back => '/app'
  end

  def show
    puts "User Info #{@@get_result['user']}"
    @user_info = @@get_result['user']
    render :back => '/app'
  end

  def download_info
    puts "User Download Info #{@@get_result['user']}"
    @user_info = @@get_result['user']
    Alert.show_popup "Profile image have been downloaded successfully."
    redirect :action => :user_info, :id => @user_info['id'], :query => {:goto => 'show'}
  end

  def update
    user_id = @params['login']['id']
    @params['login'].shift
    Rho::AsyncHttp.post(
      :url => "#{Rho::RhoConfig.api_server}/user/update_user_info.json",
      :headers => {"Cookie" => "username=#{@params['login']['username']}"},
      :body => "user_id=#{user_id}&user=#{@params['login'].to_json}",
      :callback => url_for(:action => :httpget_callback),
      :callback_param => "goto=show"
    )
    #render :action => :wait
    @response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end
  
   # GET /Login2/{1}/edit
  def user_info
    @user_id = @params['id'].gsub('{','').gsub('}','')
    Rho::AsyncHttp.get(
      :url => "#{Rho::RhoConfig.api_server}/user/user_info.json?id=#{@user_id}",
      :headers => {"Content-Type" => "application/json"},
      :callback => url_for(:action => :httpget_callback),
      :callback_param => "goto=#{@params['goto']}"
    )
    #render :action => :wait
    @response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end

  def download_profile_pic
    @user_id = @params['id'].gsub('{','').gsub('}','')
    
    file_name = File.join(Rho::RhoApplication::get_base_app_path, "#{@user_id}.jpg")

    # :filename     Full path to download file target.
    Rho::AsyncHttp.download_file(
      :url => @params['profile_pic_url'],
      :filename => file_name,
      :headers => {},
      :callback => url_for(:action => :httpget_callback),
      :callback_param => "goto=#{@params['goto']}"
    )

    @response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end

  # POST /Login/create
  def login
    Rho::AsyncHttp.post(
      :url => "#{Rho::RhoConfig.api_server}/users/login",
      :headers => {"Cookie" => "username=#{@params['login']['username']}"},
      :body => "username=#{@params['login']['username']}&password=#{@params['login']['password']}",
      :callback => url_for(:action => :httpget_callback),
      :callback_param => "goto=index"
    )
    #render :action => :wait
    @response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end

  def httpget_callback
    if @params['body']['status'] == 'error'
      @@error_msg = 'Invalid username or password'
      WebView.navigate( url_for(:action => :show_error) )
      #render_transition :action => :show_error
    else
      case @params['goto']
      when 'index'
        @@get_result = @params['body']['user_info']
        WebView.navigate( url_for(:action => :index) )
        #render_transition :action => :index
      when 'show'
        @@get_result = @params['body']['user_info']
        WebView.navigate( url_for(:action => :show) )
        #render_transition :action => :index
      when 'edit'
        @@get_result = @params['body']['user_info']
        WebView.navigate( url_for(:action => :edit) )
        #render_transition :action => :index
      end
    end
  end

  def show_error
    @error_msg = @@error_msg
    render :back => '/app'
  end

  def check_log
    Rho::RhoConfig.show_log
    render :back => url_for(:action => :user_info, :id => @params['user_id'])
  end
  
end
