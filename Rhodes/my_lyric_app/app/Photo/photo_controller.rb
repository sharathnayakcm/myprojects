require 'rho/rhocontroller'
require 'helpers/browser_helper'

class PhotoController < Rho::RhoController
  include BrowserHelper

  @@photo_list = nil
  @@photo_info = nil
  
  # GET /Photo
  def index
    @@photo_list = @@photo_list || @@get_result['photos'] || []
    @photo_list = @@photo_list
    render :action => :index, :back => url_for(:action => :new)
  end

  # GET /Photo/{1}
  def show
    @@photo_info = @@photo_info || @@get_result['photo'] || []
    @photo_info = @@photo_info
    render :action => :show, :back => url_for(:action => :index)
  end

  # GET /Photo/new
  def new
    @photo = Photo.new
    render :action => :new, :back => "/app"
  end

  # POST /Photo/create
  def create
    @keyword = @params['photo']['name']
    Rho::AsyncHttp.get(
      :url => "https://api.500px.com/v1/photos?term=#{@keyword}&consumer_key=#{Rho::RhoConfig.api_500_key}",
      :callback => url_for(:action => :httpget_callback),
      :headers => {"Content-Type" => "application/json"},
      :callback_param => "action=index"
    )
    #render :action => :wait
    @response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end

  def full_pic
    @photo_id = @params['id'].gsub('{','').gsub('}','')
    Rho::AsyncHttp.get(
      :url => "https://api.500px.com/v1/photos/#{@photo_id}?image_size=4&consumer_key=#{Rho::RhoConfig.api_500_key}",
      :callback => url_for(:action => :httpget_callback),
      :headers => {"Content-Type" => "application/json"},
      :callback_param => "action=show"
    )
    #render :action => :wait
    @response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end

  def httpget_callback
    if @params["status"] != "ok"
      @@error_params = @params
      WebView.navigate( url_for(:action => :show_error) )
      #render_transition :action => :show_error
    else
      @@get_result = @params["body"]
      case @params["action"]
      when "index"
        @@photo_list = nil
        WebView.navigate( url_for(:action => :index) )
        #render_transition :action => :index
      when "show"
        @@photo_info = nil
        WebView.navigate( url_for(:action => :show) )
        #render_transition :action => :album_list
      end
    end
  end

  def show_error

  end

end
