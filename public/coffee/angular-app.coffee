# Custom coffee code goes here (client side, angularjs)
# Ideal for AngularJS logic.
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>
# License: Coffeeware <https://github.com/Jmlevick/coffeeware-license>

app = angular.module 'bigdoc-app', []
app.controller 'symCtrl', ($scope, $http) ->
	console.log 'req'
	($http.get 'api/diagnose?symptoms=cold').success((data, status, headers, config) ->
		console.log 'json back' + data
		alert 'json back' + $scope.testinput
		console.log data
		#$scope.testinput = data;
		$scope.testinput2 = data;
		$scope.testinput3 = data;
	).error((data, status, headers, config) ->
		#log error
    );
	#$scope.testinput = "abc"
	return
	
	


