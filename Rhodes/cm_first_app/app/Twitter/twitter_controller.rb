require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TwitterController < Rho::RhoController
  include BrowserHelper

  # GET /Twitter
  @@search_result = nil
  def index
    @twitters = @@search_result || Twitter.find(:all)
    render :back => '/app'
  end

  # GET /Twitter/{1}
  def show
    @twitter = Twitter.find(@params['id'])
    if @twitter
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  def search
    @username = @params['twitter']['username']
    @perpage = @params['twitter']['perpage']
    Rho::AsyncHttp.get(
      :url => "http://search.twitter.com/search.json?q=#{@username}&rrp=#{@perpage}",
      :callback => url_for(:action => :httpget_callback),
      :headers => {"Content-Type" => "application/json"}
    )
    #render :action => :wait
    @response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end


  def httpget_callback
    if @params["status"] != "ok"
      @@error_params = @params
      WebView.navigate( url_for(:action => :show_error ,:id => @params['http_error']) )
      #render_transition :action => :show_error
    else
      @@get_result = @params["body"]
      @@search_result = @@get_result['results']
      WebView.navigate( url_for(:action => :index) )
    end
  end


  # GET /Twitter/new
  def new
    @twitter = Twitter.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Twitter/{1}/edit
  def edit
    @twitter = Twitter.find(@params['id'])
    if @twitter
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Twitter/create
  def create
    @twitter = Twitter.create(@params['twitter'])
    redirect :action => :index
  end

  # POST /Twitter/{1}/update
  def update
    @twitter = Twitter.find(@params['id'])
    @twitter.update_attributes(@params['twitter']) if @twitter
    redirect :action => :index
  end

  # POST /Twitter/{1}/delete
  def delete
    @twitter = Twitter.find(@params['id'])
    @twitter.destroy if @twitter
    redirect :action => :index  
  end
end
