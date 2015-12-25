# Custom coffee code goes here (client side, angularjs)
# Ideal for AngularJS logic.
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>
# License: Coffeeware <https://github.com/Jmlevick/coffeeware-license>

app = angular.module 'bigdoc-app', []
exampleDiseases = 
	cold : "I cough often and have runny, stuffy nose. My troat is sore and congested. I've been sneezing a lot recently and I feel fatigued even when doing usual tasks like going upstairs.",
	#pneumonia :  "I am 60 years old. My main symptom is fever and cough and green mucus sometimes tinged with a bit of blood. My heartbeat is faster than usual and feel more tired and weak than usual.", #No longer used as it its symptoms are too difficult to notice...
	diabetes : "I constanly feel thirsty, like if I couldn't quench my thirst. By this reason I'm going to the bathroom very often, I go pee like 12 or 15 times a day when I would usually go like 4 times as much. Also, waking up and going to pee in the middle of the night is becoming really usual and annoying for me. As an additional symptom my vision is slightly blurred too."
	GERD : "I have a burning sensation in my chest, I describe it like \"fire\" inside my. When eating, I find it more difficult to swallow the food, therefore I eat and immediately drink water, usually cold water because of the \"fire\" feeling... Also I cough a lot and noticed that now I have a bad breath issue."

app.controller 'exampleCtrl', ($scope, $http) ->
	console.log 'exampleCtrl'
	jsonOnly = false
	refreshRate = 500;
	$scope.switchLabel = 'Switch to JSON'
	$scope.jsonDisplay = 'none'
	$scope.cloudDisplay = 'block'

	$scope.$watch 'inputCh', _.debounce((newText) ->
		#console.log 'inputCh changed ' + newText
		($http.get 'api/diagnose?symptoms=' + newText).success((data, status, headers, config) ->
			#console.log JSON.stringify data
			window.wordsMatch = data.diseases
			#console.log window.wordsMatch
			generate()
			$scope.resultJSON = JSON.stringify(data, null, 4)
			console.log data
			#var tags = JSON.parse data.diseases
		).error((data, status, headers, config) ->
			#Log error
		);
	, refreshRate)
		
	$scope.switchData = () ->
		#$scope.quantityResult = calculateService.calculate($scope.quantity, 10);
		jsonOnly = !jsonOnly
		
		if jsonOnly
			$scope.switchLabel = 'Switch to Word Cloud'
			#Enable JSON
			$scope.jsonDisplay = 'block'
			$scope.cloudDisplay = 'none'
			refreshRate = 100
			
		else
			$scope.switchLabel = 'Switch to JSON'
			#Enable Word Cloud
			$scope.jsonDisplay = 'none'
			$scope.cloudDisplay = 'block'
			refreshRate = 500
		return
	return
