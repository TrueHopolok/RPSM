class_name RPSM


var _tactic_weight = 0.7
var _previous_throw = 0
var _previous_result = 2
var _previous_tactic_is_second = false
var _random_generator = RandomNumberGenerator.new()


func adapt(last_result : int):
	if _previous_result != 2 && last_result != 2:
		var addition = 0.2 * last_result
		if _previous_tactic_is_second: addition = -addition
		_tactic_weight = clampf(_tactic_weight + addition, 0.1, 0.9)
	_previous_result = last_result


func throw() -> int:
	var generated_value = _random_generator.randf()
	if _previous_result == 2:
		if generated_value < 0.31:
			_previous_throw = 1
		elif generated_value < 0.31+0.33:
			_previous_throw = 0
		else:
			_previous_throw = 2
		return _previous_throw
	_previous_tactic_is_second = generated_value > _tactic_weight
	
	if _previous_result == 1:
		if _previous_tactic_is_second:
			_previous_throw = _previous_throw           #CS
		else:
			_previous_throw = (_previous_throw + 2) % 3 #CB
		return _previous_throw
		
	elif _previous_result == 0:
		if _previous_tactic_is_second:
			_previous_throw = (_previous_throw + 2) % 3 #CB
		else:
			_previous_throw = (_previous_throw + 1) % 3 #CF
		return _previous_throw
		
	else:
		if _previous_tactic_is_second:
			_previous_throw = (_previous_throw + 1) % 3 #CF
		else:
			_previous_throw = (_previous_throw + 2) % 3 #CB
		return _previous_throw
