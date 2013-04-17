require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'rho/rhotoolbar'

class LyricsController < Rho::RhoController
  include BrowserHelper

  @@band_list = nil
  @@album_list = nil
  @@track_list = nil
  @@lyric = nil
  
  # GET /Lyrics
  def index
    @@band_list = @@band_list || @@get_result['results'] || []
    @band_list = @@band_list
    render :back => '/app'
  end

  # GET /Lyrics/new
  def new
    @lyrics = Lyrics.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # POST /Lyrics/create
  def create
    @band = @params['lyrics']['band']
    Rho::AsyncHttp.get(
      :url => "http://api.bandcamp.com/api/band/3/search?key=snaefellsjokull&name=#{@band}&debug",
      :callback => url_for(:action => :httpget_callback),
      :headers => {"Content-Type" => "application/json"},
      :callback_param => "action=index"
    )
    #render :action => :wait
    @response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end

  def discography
    @band_id = @params['id'].to_s.gsub('{','').gsub('}','')
    Rho::AsyncHttp.get(
      :url => "http://api.bandcamp.com/api/band/3/discography?key=snaefellsjokull&band_id=#{@band_id}&debug",
      :callback => url_for(:action => :httpget_callback),
      :headers => {"Content-Type" => "application/json"},
      :callback_param => "action=album_list"
    )
    @response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end

  def album_list
    @@album_list = @@album_list || @@get_result['discography'] || []
    @album_list = @@album_list
    render :action => :album_list
    render :back => url_for(:action => :index)
  end

  def album_info
    @album_id = @params['id'].to_s.gsub('{','').gsub('}','')
    Rho::AsyncHttp.get(
      :url => "http://api.bandcamp.com/api/album/2/info?key=snaefellsjokull&album_id=#{@album_id}&debug",
      :callback => url_for(:action => :httpget_callback),
      :headers => {"Content-Type" => "application/json"},
      :callback_param => "action=track_list"
    )
    @response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end

  def track_list
    @@track_list = @@track_list || @@get_result || []
    @track_list = @@track_list
    render :action => :track_list
    render :back => url_for(:action => :album_list)
  end

  def track_info
    @track_id = @params['id'].to_s.gsub('{','').gsub('}','')
    Rho::AsyncHttp.get(
      :url => "http://api.bandcamp.com/api/track/1/info?key=snaefellsjokull&track_id=#{@track_id}&debug",
      :callback => url_for(:action => :httpget_callback),
      :headers => {"Content-Type" => "application/json"},
      :callback_param => "action=show_lyric"
    )
    @response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end

  def show_lyric
    @@lyric = @@lyric || @@get_result || []
    @lyric = @@lyric
    render :action => :show_lyric
    render :back => url_for(:action => :track_list)
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
        @@band_list = nil
        WebView.navigate( url_for(:action => :index) )
        #render_transition :action => :index
      when "album_list"
        @@album_list = nil
        WebView.navigate( url_for(:action => :album_list) )
        #render_transition :action => :album_list
      when "track_list"
        @@track_list = nil
        WebView.navigate( url_for(:action => :track_list) )
        #render_transition :action => :track_list
      when "show_lyric"
        @@lyric = nil
        WebView.navigate( url_for(:action => :show_lyric) )
        #render_transition :action => :show_lyric
      end
    end
  end

  def show_error

  end
  
  def set_toolbar
   toolbar = [
      {:action => :back,    :icon => '/public/images/bar/back_btn.png'},
      {:action => :forward, :icon => '/public/images/bar/forward_btn.png'},
      {:action => :separator},
      {:action => :home,    :icon => '/public/images/bar/colored_btn.png', :colored_icon => true},
      {:action => :refresh },
      {:action => 'callback:' + url_for(:action => :callback), :label => 'Callback'},
      {:action => :options}
    ]
    #NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    Rho::NativeToolbar.create(toolbar)
    $tabbar_active = false
  end

  def map
    map_params = {
     :provider => 'Google',
     :settings => {:map_type => "hybrid",:region => [@params['latitude'], @params['longitude'], 0.2, 0.2],
                   :zoom_enabled => true,:scroll_enabled => true,:shows_user_location => false,
                   :api_key => 'Google Maps API Key'},
     :annotations => [{:latitude => @params['latitude'], :longitude => @params['longitude'], :title => "Current location", :subtitle => ""},
                      {:street_address => "Cupertino, CA 95014", :title => "Cupertino", :subtitle => "zip: 95014",
                       :url => "/app/GeoLocation/show?city=Cupertino"},
                      {:street_address => "Santa Clara, CA 95051", :title => "Santa Clara", :subtitle => "zip: 95051",
                       :url => "/app/GeoLocation/show?city=Santa%20Clara", :pass_location => true}]
    }
    MapView.create map_params
  end
 
end
