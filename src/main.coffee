import matching from './matching.js'
import scoring from './scoring.js'
import time_estimates from './time_estimates.js'
import feedback from './feedback.js'

time = -> (new Date()).getTime()

export default (password, user_inputs = []) ->
  start = time()
  # reset the user inputs matcher on a per-request basis to keep things stateless
  sanitized_inputs = []
  for arg in user_inputs
    if typeof arg in ["string", "number", "boolean"]
      sanitized_inputs.push arg.toString().toLowerCase()
  matching.set_user_input_dictionary sanitized_inputs
  matches = matching.omnimatch password
  result = scoring.most_guessable_match_sequence password, matches
  result.calc_time = time() - start
  attack_times = time_estimates.estimate_attack_times result.guesses
  for prop, val of attack_times
    result[prop] = val
  result.feedback = feedback.get_feedback result.score, result.sequence
  result
