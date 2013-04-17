require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'json'

class TweetController < Rho::RhoController
  include BrowserHelper

  # GET /Tweet
  def index
    @tweets = @@get_result['tweet']
    @user_id = @params['user_id']
    render :back => url_for(:controller => :Login, :action => :user_info, :id => @user_id, :query => {:goto => 'index'})
  end

  # GET /Tweet/{1}
  def show
    @tweet = @@get_result['tweet']
    @user_id = @params['user_id']
    if @tweet
      render :action => :show, :back => url_for(:action => :tweet_list, :query => {:user_id => @user_id})
    else
      redirect url_for(:action => :tweet_list, :query => {:user_id => @user_id})
    end
  end

  def show_submitted_tweet
    @tweet = @@get_result['tweet']
    @user_id = @params['user_id']
    if @tweet
      render :action => :show, :back => url_for(:action => :tweet_list, :query => {:user_id => @user_id})
    else
      redirect url_for(:action => :tweet_list, :query => {:user_id => @user_id})
    end
  end

  def get_tweet
    @tweet_id = @params['id'].gsub('{','').gsub('}','')
    @user_id = @params['user_id']
    Rho::AsyncHttp.get(
      :url => "#{Rho::RhoConfig.api_server}/tweets/tweet_info.json?tweet_id=#{@tweet_id}",
      :headers => {"Cookie" => "user_id=#{@user_id}"},
      :callback => url_for(:action => :httpget_callback),
      :callback_param => "goto=show&user_id=#{@user_id}"
    )
    #render :action => :wait
    @response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end

  # GET /Tweet/new
  def new
    @user_id = @params['user_id']
    render :action => :new, :back => url_for(:action => :tweet_list, :query => {:user_id => @user_id})
  end


   def show_popup
    @title = "Popup"
    Alert.show_popup "Hello there"
    render :action => :index
  end

  # GET /Tweet/{1}/edit
  def edit
    @tweet = Tweet.find(@params['id'])
    if @tweet
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Tweet/create
  def create
    @tweet = @params['tweet']
    @user_id = @tweet['user_id']
    #redirect :action => :index
    Rho::AsyncHttp.post(
      :url => "#{Rho::RhoConfig.api_server}/tweets/submit_tweet.json",
      :headers => {"Cookie" => "user_id=#{@user_id}"},
      :body => "tweet=#{@tweet.to_json}",
      :callback => url_for(:action => :httpget_callback),
      :callback_param => "goto=show_submitted_tweet&user_id=#{@user_id}"
    )
    #render :action => :wait
    @response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end

  def tweet_list
    @user_id = @params['id']
    #redirect :action => :index
    Rho::AsyncHttp.get(
      :url => "#{Rho::RhoConfig.api_server}/tweets/tweet_list.json?user_id=#{@user_id}",
      :headers => {"Cookie" => "user_id=#{@user_id}"},
      :callback => url_for(:action => :httpget_callback),
      :callback_param => "goto=index&user_id=#{@user_id}"
    )
    #render :action => :wait
    @response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end

  def follow_user
    @user_id = @params['id'].gsub('{','').gsub('}','')
    @following_user = @params['following_user']
    Rho::AsyncHttp.get(:url=>"#{Rho::RhoConfig.api_server}/users/user_follow.json?user_id=#{@user_id}&following_user=#{@following_user}",
      :callback => url_for(:action => :httpget_callback),
      :callback_param => "goto=following_sucess"
    )
  end

  def following_success
    @follower = @@get_result['follower']['user']
    render :back => url_for( :action => :get_user_list)
  
  end
  
  def user_list
    @users = @@get_result['user']
    @user_id = @params['user_id']
    p "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu", @params['user_id']
    render :back => url_for(:controller => :Login, :action => :new)
  end

  def get_user_list
    @user_id = @params['id']
    p "ssssssssssssssssssssssss",@user_id,@params['id']
    Rho::AsyncHttp.get(:url=>"#{Rho::RhoConfig.api_server}/users/user_list.json",
      :headers => {"Cookie" => "user_id=#{@user_id}"},
      :callback => url_for(:action => :httpget_callback),
      :callback_param => "goto=user_list&user_id=#{@user_id}"
    )
  end

  # POST /Tweet/{1}/update
  def update
    @tweet = Tweet.find(@params['id'])
    @tweet.update_attributes(@params['tweet']) if @tweet
    redirect :action => :index
  end

  # POST /Tweet/{1}/delete
  def delete
    @tweet = Tweet.find(@params['id'])
    @tweet.destroy if @tweet
    redirect :action => :index  
  end

  def httpget_callback
    if @params['body']['status'] == 'error'
      @@error_msg = 'Invalid username or password'
      WebView.navigate( url_for(:action => :show_error) )
      #render_transition :action => :show_error
    else
      case @params['goto']
      when 'index'
        @@get_result = @params['body']
        WebView.navigate( url_for(:action => :index, :query => {:user_id => @params['user_id']}) )
        #render_transition :action => :index
      when 'show'
        @@get_result = @params['body']
        WebView.navigate( url_for(:action => :show, :query => {:user_id => @params['user_id']}) )
        #render_transition :action => :index
      when 'show_submitted_tweet'
        @@get_result = @params['body']
        WebView.navigate( url_for(:action => :show_submitted_tweet, :query => {:user_id => @params['user_id']}) )
      when 'user_list'
        @@get_result = @params['body']
        WebView.navigate( url_for(:action => :user_list,:query => {:user_id => @params['user_id']}) )
      when 'following_sucess'
        @@get_result = @params['body']
        WebView.navigate( url_for(:action => :following_success) )

      end
    end
  end
end
