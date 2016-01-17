![Zendesk tickets widget for Übersicht](https://raw.githubusercontent.com/unglud/ubersicht-zendesk/master/screenshot.png)

# Zendesk tickets widget for Übersicht

*Display Zendesk new, open and pending tickets on your desktop. You can interact with tickets titles - it's linked to ticket itself on Zendesk site.*

Prerequisites
-------------

- <img src="http://deluge-torrent.org/images/apple-logo.gif" height="17"> **Mac OS X 10.9**
- [Übersicht](http://tracesof.net/uebersicht/)

Getting Started
---------------

1. Open your widgets folder.
    > Select 'Open Widgets Folder' from the Übersicht menu in the top menu bar.
    
2. Move the widget to your widgets folder.
    > Drag the widget from your Downloads folder to the widgets folder you opened in step 1.
  
4. Configure widget   
    > Open index.coffee file
    
        # Specify your Zendesk subdomain.
        # For example for https://obscura.zendesk.com/ it will be "obscura"
        
        subdomain = 'obscura'
        
        # API token
        # you can create one here https://obscura.zendesk.com/agent/admin/api
        token = 'token'
        
        #User email
        email = 'email@gmail.com'
        
        # Position and style
        width = 'auto'
        top = 'auto'
        bottom = '80px'
        left = '1%'
        right = 'auto'
        
        #Show names of lists
        showListsNames: true, # true / false
        
        #Show lists by names
        #Example: ['New', 'Open', 'Pending']
        showLists: [] #show all by default
        
        #Show only a certain number of tasks from a specific list
        iNumbers:
          'new': 10
          'open': 10
          'pending': 10
