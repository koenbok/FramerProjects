class BackgroundLayer extends Layer
	
	constructor: (options={}) ->
		
		options.width = Screen.width
		options.height = Screen.height
		options.backgroundColor ?= "#fff"
		options.name = "Background"
		
		super options
		
		Screen.on "resize", =>
			
			sizingObject = @superLayer or Screen
			
			@width = sizingObject.width
			@height = sizingObject.height
		
		@sendToBack()

bg = new BackgroundLayer