require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'time'
class DatetimeController < Rho::RhoController
  include BrowserHelper
  
  @layout = :simplelayout
  $saved = nil
  $choosed = {}

  $datemin = Time.at(0)
  $datemax = Time.at(0)

  $datemin_s = ''
  $datemax_s = ''
  
  # GET /Datetime
  def index
    @datetimes = Datetime.find(:all)
    render :back => '/app'
  end

  # GET /Datetime/{1}
  def show
    @datetime = Datetime.find(@params['id'])
    if @datetime
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Datetime/new
  def new
    @datetime = Datetime.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Datetime/{1}/edit
  def edit
    @datetime = Datetime.find(@params['id'])
    if @datetime
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Datetime/create
  def create
    @datetime = Datetime.create(@params['datetime'])
    redirect :action => :index
  end

  # POST /Datetime/{1}/update
  def update
    @datetime = Datetime.find(@params['id'])
    @datetime.update_attributes(@params['datetime']) if @datetime
    redirect :action => :index
  end

  # POST /Datetime/{1}/delete
  def delete
    @datetime = Datetime.find(@params['id'])
    @datetime.destroy if @datetime
    redirect :action => :index  
  end


    def choose
    puts "Choose date/time"

    flag = @params['flag']
    title = @params['title']

    if flag == '0' or flag == '1' or flag == '2'
      $saved = nil
      # preset_time = Time.parse("2009-10-20 14:30:00")
      # puts "Parsed Time Object: #{preset_time.inspect.to_s}"
      # DateTimePicker.choose( url_for( :action => :datetime_callback ), title, preset_time, flag.to_i, Marshal.dump(flag) )

      ttt = $choosed[flag]
      if ttt.nil?
        preset_time = Time.new
      else
        preset_time = Time.parse(ttt)
      end


      DateTimePicker.choose_with_range( url_for( :action => :datetime_callback ), title, preset_time, flag.to_i, Marshal.dump(flag), $datemin, $datemax )
    end
    #redirect :action => :index
    ""
  end

  def save
    $saved = 1
    redirect :action => :index
  end

  def datetime_callback
    puts "datetime_callback"

    $status = @params['status']
    if $status == 'ok'
      $dt = Time.at( @params['result'].to_i )
      flag = Marshal.load(@params['opaque'])
      format = case flag
        when "0" then '%F %T'
        when "1" then '%F'
        when "2" then '%T'
        else '%F %T'
      end
      $choosed[flag] = $dt.strftime( format )
      #WebView::refresh
    end

    WebView.navigate( url_for :action => :index )

    #reply on the callback
    #render :action => :index
    ""
  end

  def choose_min
    puts "Choose min date"
    flag = @params['flag']
    title = @params['title']
    DateTimePicker.choose( url_for( :action => :mindate_callback ), title, Time.new, flag.to_i, Marshal.dump(flag) )
    ""
  end

  def mindate_callback
    puts "mindate_callback"
    $status = @params['status']
    if $status == 'ok'
      $dt = Time.at( @params['result'].to_i )
      flag = Marshal.load(@params['opaque'])
      format = case flag
        when "0" then '%F %T'
        when "1" then '%F'
        when "2" then '%T'
        else '%F %T'
      end
      $datemin_s = $dt.strftime( format )
      puts '$datemin_s = '+$datemin_s
      $datemin = Time.parse($datemin_s)
      puts '$datemin = '+$datemin.to_s
    end
    WebView.navigate( url_for :action => :index )
    ""
  end

  def choose_max
    puts "Choose max date"
    flag = @params['flag']
    title = @params['title']
    DateTimePicker.choose( url_for( :action => :maxdate_callback ), title, Time.new, flag.to_i, Marshal.dump(flag) )
    ""
  end

  def maxdate_callback
    puts "maxdate_callback"
    $status = @params['status']
    if $status == 'ok'
      $dt = Time.at( @params['result'].to_i )
      flag = Marshal.load(@params['opaque'])
      format = case flag
        when "0" then '%F %T'
        when "1" then '%F'
        when "2" then '%T'
        else '%F %T'
      end
      $datemax_s = $dt.strftime( format )
      $datemax = Time.parse($datemax_s)
    end
    WebView.navigate( url_for :action => :index )
    ""
  end


  def clear_min
    $datemin = Time.at(0)
    $datemin_s = ''
    WebView.navigate( url_for :action => :index )
    ""
  end

  def clear_max
    $datemax = Time.at(0)
    $datemax_s = ''
    WebView.navigate( url_for :action => :index )
    ""
  end
end
