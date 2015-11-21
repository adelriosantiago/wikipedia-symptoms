# Custom coffee code goes here (client side, angularjs)
# Ideal for AngularJS logic.
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>
# License: Coffeeware <https://github.com/Jmlevick/coffeeware-license>

app = angular.module 'bigdoc-app', []

app.controller 'exampleCtrl', ($scope, $http) ->
	console.log 'exampleCtrl'
	jsonOnly = false
	$scope.switchLabel = 'Switch to JSON'
	
	$scope.$watch 'inputCh', (newText) ->
		#console.log 'inputCh changed ' + newText
		($http.get 'api/diagnose?symptoms=' + newText).success((data, status, headers, config) ->
			#console.log JSON.stringify data
			
			window.wordsMatch = data.diseases
			console.log window.wordsMatch
			generate()
			
			$scope.resultJSON = data
			#var tags = JSON.parse data.diseases
		).error((data, status, headers, config) ->
			#log error
		);
		
	$scope.switchData = () ->
		#$scope.quantityResult = calculateService.calculate($scope.quantity, 10);
		jsonOnly = !jsonOnly
		
		if jsonOnly
			$scope.switchLabel = 'Switch to JSON'
		else
			$scope.switchLabel = 'Switch to Word Cloud'
		
		return
	
	return
