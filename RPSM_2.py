import random

class RPSM:

    last_throw = 0
    '''
    READ ONLY\n
    2 = paper\n
    1 = rock\n
    0 = scissors\n
    '''

    _previous_result = None
    _tactic_weight = 0.7
    _last_tactic_is_second = False


    def set_last_result(result : int | None):
        '''
           1 = last round was win\n
           0 = last round was draw\n
          -1 = last round was lose\n
        None = to reset model\n
        '''

        # DATA VALIDATION
        if not result in [None, -1, 0, 1]:
            raise Exception('Invalid arguments')
        if not isinstance(RPSM._last_tactic_is_second, bool) or not isinstance(RPSM._tactic_weight, float):
            raise Exception('RPSM class data corruption')
        
        # RESULT SAVING
        RPSM._previous_result = result

        # TACTIC WEIGHT ADJUSTMENT
        if result != None: 
            addition = 0.2 * result
            if RPSM._last_tactic_is_second:
                addition = -addition
            RPSM._tactic_weight = min(max(RPSM._tactic_weight + addition, 0.1), 0.9)
        

    def throw() -> int:
        '''
        Return generated throw\n
        If needed, result can be accessed through public field "last_throw" (READ ONLY)\n 
        2 = paper\n
        1 = rock\n
        0 = scissors\n
        '''


        generated_value = random.random()


        # FIRST MOVE MODULE
        if RPSM._previous_result == None:
            if generated_value < 0.31:
                RPSM.last_throw = 1
            elif generated_value < 0.31+0.33:
                RPSM.last_throw = 0
            else:
                RPSM.last_throw = 2
            return RPSM.last_throw


        # DATA VALIDATION
        if not isinstance(RPSM._previous_result, int) or not isinstance(RPSM.last_throw, int) or not isinstance(RPSM._tactic_weight, float):
            raise Exception('RPSM class data corruption')


        # TACTIC SELECTION
        RPSM._last_tactic_is_second = generated_value > RPSM._tactic_weight
        


        # WIN MODULE
        if RPSM._previous_result == 1:

            # extra tactic
            if RPSM._last_tactic_is_second:
                RPSM.last_throw = RPSM.last_throw           # CS

            # default tactic
            else:    
                RPSM.last_throw = (RPSM.last_throw - 1) % 3 # CB

            return RPSM.last_throw
        

        # TIE MODULE
        elif RPSM._previous_result == 0:
            
            # extra tactic
            if RPSM._last_tactic_is_second:
                RPSM.last_throw = (RPSM.last_throw - 1) % 3 # CB

            # default tactic
            else:  
                RPSM.last_throw = (RPSM.last_throw + 1) % 3 # CF
            
            return RPSM.last_throw
            

        # LOSE MODULE
        elif RPSM._previous_result == -1:
            
            # extra tactic
            if RPSM._last_tactic_is_second:
                RPSM.last_throw = (RPSM.last_throw + 1) % 3 # CF

            # default tactic
            else:  
                RPSM.last_throw = (RPSM.last_throw - 1) % 3 # CB

            return RPSM.last_throw


        # DATA VALIDATION
        else:
            raise Exception('RPSM class data corruption')