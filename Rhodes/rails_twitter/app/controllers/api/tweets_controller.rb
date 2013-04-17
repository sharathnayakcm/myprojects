# To change this template, choose Tools | Templates
# and open the template in the editor.

class Api::TweetsController < ApplicationController
skip_before_filter :verify_authenticity_token
  respond_to :xml, :json
  
  def tweet_list
    @user_id =  params[:user_id]
    @tweets = Tweet.find_all_by_user_id @user_id

    if @tweets
      data = {:status => 'ok', :tweet => @tweets}
    else
      data = {:status => 'error'}
    end

    respond_with(data.to_json)
=begin
    respond_to do |format|
      format.json{ render :json => data.to_json }
    end
=end
  end

  def tweet_info
    @tweet_id =  params[:tweet_id]
    @tweet = Tweet.find @tweet_id

    if @tweet
      data = {:status => 'ok', :tweet => @tweet}
    else
      data = {:status => 'error'}
    end
respond_with(data.to_json)
#    respond_to do |format|
#      format.json{ render :json => data.to_json }
#    end
  end

  def submit_tweet
    @tweet_data =  JSON.parse(params[:tweet])
    @tweet = Tweet.new(@tweet_data)

    if @tweet.save
      data = {:status => 'ok', :tweet => @tweet}
    else
      data = {:status => 'error'}
    end

    respond_to do |format|
      format.json{ render :json => data.to_json }
    end
  end

  
end
