"""

Todo:

- Status bar (light and dark style)
- Alert throwing
- Phone rotation


API:

DeviceView({
	scale: null|0.5,
	padding: 50
	keyboardAnimationCurve: "spring(400,40,0)"
})

DeviceView.setDevice(deviceName|deviceInfo)
DeviceView.showKeyboard()
DeviceView.hideKeyboard()
DeviceView.toggleKeyboard()


"""

DeviceViewHostedImagesUrl = ""
DeviceViewDefaultDevice = "iphone-5s–spacegray"

class DeviceView extends Framer.BaseClass

	constructor: (options={}) ->

		defaults = _.extend Devices[DeviceViewDefaultDevice],
			scale: null
			padding: 50
			keyboardAnimationCurve: "spring(400,40,0)"

		@setup()

		_.extend @, Utils.setDefaultProperties options, defaults

		@setDevice @

		Screen.on "resize", @update

	setup: ->

		@background = new Layer
		@background.backgroundColor = "white"

		@phone = new Layer

		@screen = new Layer superLayer:@phone
		@screen.backgroundColor = "white"

		@keyboard = new Layer superLayer:@screen
		@keyboard.on "click", @toggleKeyboard

# 		@phone.on Events.Click, =>
# 			@phone.animate
# 				properties: {rotationZ: @phone.rotationZ + 90}
# 				curve: "spring(400,40,0)"

	update: =>

		@background.width = Screen.width
		@background.height = Screen.height

		@phone.scale = @_calculatePhoneScale()
		@phone.center()

		@screen.width = @screenWidth
		@screen.height = @screenHeight

		@screen.center()

	_calculatePhoneScale: ->

		# If a scale was given we use that
		return @scale if @scale

		phoneScale = _.min [
			(Screen.width -  (@padding * 2)) / (@phone.width),
			(Screen.height - (@padding * 2)) / (@phone.height)
		]

		return phoneScale

	setDevice: (device) ->

		if _.isString device

			if not Devices.hasOwnProperty device.toLowerCase()
				throw Error "No device named #{device}. Options are: #{_.keys Devices}"

			device = Devices[device.toLowerCase()]

		_.extend @, device

		@phone.image = "images/#{device.deviceImage}"
		@phone.width = device.deviceImageWidth
		@phone.height = device.deviceImageHeight

		@keyboard.image = "images/#{device.keyboardImage}"
		@keyboard.width = device.keyboardWidth
		@keyboard.height = device.keyboardHeight
		@hideKeyboard false

		@update()

	# Keyboard

	showKeyboard: (animate=true) ->
		@_animateKeyboard animate, @screen.height - @keyboard.height
		@_keyboardVisible = true
		@emit "change:keyboard", true

	hideKeyboard: (animate) ->
		@_animateKeyboard animate, @screen.height
		@_keyboardVisible = false
		@emit "change:keyboard", false

	toggleKeyboard: (animate) =>
		if @_keyboardVisible is true
			@hideKeyboard animate
		else
			@showKeyboard animate

	_animateKeyboard: (animate, keyboardY) ->
		@keyboard.bringToFront()
		if animate is false
			@keyboard.y = keyboardY
		else
			@keyboard.animate
				properties: {y:keyboardY}
				curve: @keyboardAnimationCurve



iPhone5BaseDevice =
	deviceImageWidth: 792
	deviceImageHeight: 1632
	screenWidth: 640
	screenHeight: 1136
	keyboardImage: "ios-keyboard.png"
	keyboardWidth: 640
	keyboardHeight: 432

iPadMiniBaseDevice =
	deviceImageWidth: 920
	deviceImageHeight: 1328
	screenWidth: 768
	screenHeight: 1024
	keyboardImage: "ios-keyboard.png"
	keyboardWidth: 768
	keyboardHeight: 432

iPadAirBaseDevice =
	deviceImageWidth: 1856
	deviceImageHeight: 2584
	screenWidth: 1536
	screenHeight: 2048
	keyboardImage: "ios-keyboard.png"
	keyboardWidth: 0
	keyboardHeight: 0


Devices =

	# iPhone 5S
	"iphone-5s–spacegray": _.extend {}, iPhone5BaseDevice,
		name: "iPhone 5S Space Gray"
		deviceImage: "iphone-5S–spacegray.png"
	"iphone-5s–silver": _.extend {}, iPhone5BaseDevice,
		name: "iPhone 5S Silver"
		deviceImage: "iphone-5S–silver.png"
	"iphone-5s–gold": _.extend {}, iPhone5BaseDevice,
		name: "iPhone 5S Gold"
		deviceImage: "iphone-5S–gold.png"

	# iPhone 5C
	"iphone-5c–green": _.extend {}, iPhone5BaseDevice,
		name: "iPhone 5S Green"
		deviceImage: "iphone-5C–green.png"
	"iphone-5c–blue": _.extend {}, iPhone5BaseDevice,
		name: "iPhone 5S Blue"
		deviceImage: "iphone-5C–blue.png"
	"iphone-5c–yellow": _.extend {}, iPhone5BaseDevice,
		name: "iPhone 5S Yellow"
		deviceImage: "iphone-5C–yellow.png"
	"iphone-5c–pink": _.extend {}, iPhone5BaseDevice,
		name: "iPhone 5C Pink"
		deviceImage: "iphone-5C-pink.png"
	"iphone-5c–white": _.extend {}, iPhone5BaseDevice,
		name: "iPhone 5C White"
		deviceImage: "iphone-5C-white.png"

	# iPad Mini
	"ipad-mini-silver": _.extend {}, iPadMiniBaseDevice,
		name: "iPad Mini Silver"
		deviceImage: "ipad-mini-silver.png"
	"ipad-mini-spacegray": _.extend {}, iPadMiniBaseDevice,
		name: "iPad Mini Space Gray"
		deviceImage: "ipad-mini-spacegray.png"

	# iPad Air
# 	"ipad-air-silver": _.extend {}, iPadAirBaseDevice,
# 		name: "iPad Mini Silver"
# 		deviceImage: "ipad-mini-silver.png"
# 	"ipad-air-spacegray": _.extend {}, iPadAirBaseDevice,
# 		name: "iPad Mini Space Gray"
# 		deviceImage: "ipad-mini-spacegray.png"






# @{
# 		@"name": @"iPad Mini Silver",
# 		@"width": @(768), @"height": @(1024),
# 		@"imageName": @"ipad-mini-silver", @"imageFactor": @(1.0)},
# @{
# 		@"name": @"iPad Mini Space Gray",
# 		@"width": @(768), @"height": @(1024),
# 		@"imageName": @"ipad-mini-spacegray", @"imageFactor": @(1.0)},
# @{
# 		@"name": @"iPad Air Silver",
# 		@"width": @(1536), @"height": @(2048),
# 		@"imageName": @"ipad-air-silver", @"imageFactor": @(1.0)},
# @{
# 		@"name": @"iPad Air Space Gray",
# 		@"width": @(1536), @"height": @(2048),
# 		@"imageName": @"ipad-air-spacegray", @"imageFactor": @(1.0)},
# @{
# 		@"name": @"Nexus 5",
# 		@"width": @(1080), @"height": @(1920),
# 		@"imageName": @"lg-nexus-5", @"imageFactor": @(1.0)},
# ];




phone = new DeviceView
phone.showKeyboard false
phone.setDevice "iphone-5c–green"
# phone.screen.backgroundColor = "Red"

phone.background.image = "http://goo.gl/ORsr1P"
phone.background.blur = 10

layer = new Layer superLayer:phone.screen
layer.on Events.Click, -> phone.toggleKeyboard()
