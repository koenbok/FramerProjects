
class ScrollView extends Layer
	
	constructor: (options) ->
		
		super options
		
		@contentView = new Layer superLayer:@
		
		# We need this for safari: http://stackoverflow.com/questions/15751012/
		# css-transform-causes-flicker-in-safari-but-only-when-the-browser-is-2000px-w
		# @contentView.style["-webkit-backface-visibility"] = "hidden"

		@contentView.on "change:subLayers", @_changeSubViews
		@contentView.on Events.DragMove, @_scroll

		@_dragger = @contentView.draggable
	
	centerView: (view, animate=false) ->
		@scrollFrame = @_scrollFrameForView view
	
	snapToView: (view, curve="spring(1000,20,1000)") ->
		@contentView.animate
			properties: utils.pointInvert @_scrollFrameForView view
			curve: curve
	
	closestView: =>
		_.first _.sortBy @contentView.subViews, (view) =>
			utils.pointTotal utils.pointDistance(view.frame, @scrollFrame)
	
	@define "scrollFrame",
		get: ->
			return new Framer.Frame utils.pointInvert @contentView
		set: (frame) ->
			@contentView.frame = utils.pointInvert utils.framePoint @contentView.frame

	_scrollFrameForView: (view) ->
		frame = 
			x: view.x + (view.width - @width) / 2.0
			y: view.y + (view.height - @height) / 2.0

	_changeSubViews: (event) =>
		
		# If views change we need to re-calculate the contentView size
		event?.added?.map (view) => view.on "change:frame", @_updateSize
		event?.removed?.map (view) => view.off "change:frame", @_updateSize
		
		@_updateSize()

	_updateSize: =>
		@contentView.frame = @contentView.contentFrame()
	
	_scroll: (event) =>
		event.preventDefault()
		@emit "scroll", event


scrollView = new ScrollView
	width:  window.innerWidth
	height: window.innerHeight

[0..20].map (i) ->
	layer = new Layer
		width: scrollView.width
		height: scrollView.height
		superView: scrollView.contentView
		image: "https://sphotos-b.xx.fbcdn.net/hphotos-ash4/385636_4560048810166_892437424_n.jpg"
	layer.x = i * layer.width
	
	Utils.labelLayer layer, "Slide #{i}"
	layer.style.backgroundColor = utils.randomColor(.8)

# Only drag horizontally
scrollView.contentView.draggable.speedY = 0

scrollView.contentView.on Events.DragEnd, (touchEvent) ->
	
	factor = touchEvent.clientY / scrollView.height
	
	friction = 4 + factor * (150 - 4)
	
	velocity = scrollView.contentView.draggable.calculateVelocity()
	velocity = Math.abs velocity.x * 1
	
	curve = "spring(1000,#{friction},#{velocity})"

	animation = scrollView.snapToView scrollView.closestView(), curve





