[1, 2, 3, 4, 5].map(&:to_s)
#=> ['1', '2', '3', '4', '5']

(&:to_s) #this is a shortcut that can be used to call a method on every item in a collection

# & tries to turn the object that follows it into a block. The object must be a Proc to allow for this. If it is not a Proc, & will call #to_proc on the object. Then if succesful, & will turn the newley transformed Proc into a block.

###NOW THAT I HAVE LEARNED ABOUT BLOCKS, PROCS AND WRITING METHODS THAT TAKE BLOCKS######
# I have much more control over how methods are used and what they can allow the user to do...maybe helpful in writing a Farkle game?
