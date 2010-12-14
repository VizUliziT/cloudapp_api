module CloudApp
  
  # A client interface through which to interract with the CloudApp API.
  # 
  # @example Creating a client instance and set authentication credentials
  #   @client = CloudApp::Client.new
  #   @client.authenticate "username", "password"
  #
  # @example Creating editing and deleting cl.ly items
  #   # Find a single item by it's slug
  #   item = @client.item "2wr4"
  #   
  #   # Get a list of all items
  #   items = @client.all
  #   
  #   # Create a new bookmark
  #   item = @client.bookmark "http://getcloudapp.com", "CloudApp"
  #   
  #   # Upload a file
  #   item = @client.upload "/path/to/image.png"
  #   
  #   # Rename a file
  #   @client.rename "2wr4", "Big Screenshot"
  #   
  #   # Set an items privacy
  #   @client.privacy "2wr4", true
  #   
  #   # Delete an item
  #   @client.delete "2wr4"
  #
  class Client
    
    # Creates a new CloudApp::Client instance.
    # @example Optionally provide an authentication hash
    #   { :username => "testuser@test.com", :password => "password" }
    # @param [Hash] authentication credentials.
    # @return [CloudApp::Client]
    def initialize(opts = {})
      if opts[:username] && opts[:password]
        Base.authenticate(opts[:username], opts[:password])
      end
    end
    
    # Sets the authentication credentials in a class variable.
    # @param [String] cl.ly username
    # @param [String] cl.ly password
    # @return [Hash] authentication credentials
    def authenticate(username, password)
      Base.authenticate(username, password)
    end
    
    # Get metadata about a cl.ly URL like name, type, or view count.
    # Finds the item by it's slug id, for example "2wr4".
    # @param [String] cl.ly slug id
    # @return [CloudApp::Item]
    def item(id)
      Item.find(id)
    end
    
    # Page through your items.
    # @example Optionally pass a hash of parameters.
    #   :page => 1        # Page number starting at 1
    #   :per_page => 5    # Number of items per page
    #   :type => image    # Filter items by type (image, bookmark, text, archive, audio, video, or unknown)
    #   :deleted => true  # Show trashed items
    # Requires authentication.
    # @param [Hash] options parameters
    # @return [Array] of CloudApp::Item items
    def items(opts = {})
      Item.all(opts)
    end
    
    # Create a new cl.ly item by bookmarking a link.
    # Requires authentication.
    # @param [String] url to bookmark
    # @param [String] name of bookmark
    # @return [CloudApp::Item]
    def bookmark(url, name = "")
      Item.create(:bookmark, {:name => name, :redirect_url => url})
    end
    
    # Create a new cl.ly item by uploading a file.
    # Requires authentication.
    # @param [String] local path to file
    # @return [CloudApp::Item]
    def upload(file)
      Item.create(:upload, :file => file)
    end
    
    # Change the name of an item.
    # Finds the item by it's slug id, for example "2wr4".
    # Requires authentication.
    # @param [String] cl.ly item id
    # @param [String] new item name
    # @return [CloudApp::Item]
    def rename(id, name = "")
      item = Item.find(id)
      item.class == Item ? item.update(:name => name) : item
    end
    
    # Modify an item with a private URL to have a public URL or vice versa.
    # Finds the item by it's slug id, for example "2wr4".
    # Requires authentication.
    # @param [String] cl.ly item id
    # @param [Boolean] privacy setting
    # @return [CloudApp::Item]
    def privacy(id, privacy = false)
      item = Item.find(id)
      item.class == Item ? item.update(:private => privacy) : item
    end
    
    # Send an item to the trash.
    # Finds the item by it's slug id, for example "2wr4".
    # Requires authentication.
    # @param [String] cl.ly item id
    # @return [CloudApp::Item]
    def delete(id)
      item = Item.find(id)
      item.class == Item ? item.delete : item
    end
        
  end
  
end