require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  def initialize
    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    # Super must be called *after* settings @tabs!
    @tabs = nil
    #To remove default toolbar uncomment next line:
   @@toolbar = [
      { :label => "Dashboard", :action => '/app',
        :icon => "/public/images/tabs/dashboard.png", :reload => true, :web_bkg_color => 0x7F7F7F },
      { :label => "Lyrics",  :action => '/app/Lyrics/new',
        :icon => "/public/images/tabs/lyric.png" },
   ]

    @default_menu = {
      "Go Home" => :home,
      "Do Refresh" => :refresh,
      "Perform Sync" => :sync,
      "App Options" => :options,
      "View Log" => :log
    }
    super

    # Uncomment to set sync notification callback to /app/Settings/sync_notify.
    # SyncEngine::set_objectnotify_url("/app/Settings/sync_notify")
    # SyncEngine.set_notification(-1, "/app/Settings/sync_notify", '')
  end
end
