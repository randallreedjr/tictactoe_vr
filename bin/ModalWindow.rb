
##
#  This is a modal window.  In glade, you'll see that the "Modal"
#  setting is true (default in VR).  This means that everything
#  will halt until it finishes.
#  
#  Notice that this window doesn't need to set a parent window
#  because having it close with its parent isn't an issue--the user is
#  forced to terminate this window first.
#
#  Note:  The "Cancel" button on this window is directly linked to the
#  destroy_window method (in GladeGUI), so you don't need to write your own method to
#  handle when the Cancel button is clicked. 	
#

class ModalWindow #(change name)

	include GladeGUI

	def show(parent)
		load_glade(__FILE__, parent)
		show_window()
	end	

end
