# Custom coffee code goes here (client side, angularjs)
# Ideal for AngularJS logic.
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>
# License: Coffeeware <https://github.com/Jmlevick/coffeeware-license>

app = angular.module 'bigdoc-app', []
app.controller 'symCtrl', ($scope) ->
	$scope.testinput = "abc"
	return


