require 'json'
require 'rest_client'

class Application < Rhoconnect::Base
  class << self
    def authenticate(username,password,session)
     return true if {username=>"sharath",password=>"sharath"}
    end
    
    # Add hooks for application startup here
    # Don't forget to call super at the end!
    def initializer(path)
      @base = 'http://rhostore.heroku.com/customers'
      super
    end
    
    # Calling super here returns rack tempfile path:
    # i.e. /var/folders/J4/J4wGJ-r6H7S313GEZ-Xx5E+++TI
    # Note: This tempfile is removed when server stops or crashes...
    # See http://rack.rubyforge.org/doc/Multipart.html for more info
    # 
    # Override this by creating a copy of the file somewhere
    # and returning the path to that file (then don't call super!):
    # i.e. /mnt/myimages/soccer.png
    def store_blob(object,field_name,blob)
      super #=> returns blob[:tempfile]
    end
  end
end

Application.initializer(ROOT_PATH)

# Support passenger smart spawning/fork mode:
if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      # We're in smart spawning mode.
      Store.db.client.reconnect
    else
      # We're in conservative spawning mode. We don't need to do anything.
    end
  end
end
