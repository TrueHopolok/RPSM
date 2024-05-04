import random

class RPSM:
    previous_result = None
    '''
    READ / WRITE\n
       1 = last round was win\n
       0 = last round was draw\n
      -1 = last round was lose\n
    None = to reset model\n
    '''
    last_throw = 0
    '''
    READ ONLY\n
    2 = paper\n
    1 = rock\n
    0 = scissors\n
    '''
    def throw() -> int:

        # FIRST MOVE MODULE
        if RPSM.previous_result == None:
            generated_value = random.random()
            if generated_value < 0.31:
                RPSM.last_throw = 1
                return 1
            elif generated_value < 0.31+0.33:
                RPSM.last_throw = 0
                return 0
            else:
                RPSM.last_throw = 2
                return 2

        # DATA VALIDATION
        if (not isinstance(RPSM.previous_result, int)) or (not isinstance(RPSM.last_throw, int)):
            raise Exception('RPSM-1 class data corruption')

        # WIN/LOSE MODULE
        if RPSM.previous_result == 1 or RPSM.previous_result == -1:
            RPSM.last_throw = (RPSM.last_throw - 1) % 3 # CB
            return RPSM.last_throw
        
        # TIE MODULE
        elif RPSM.previous_result == 0:
            return RPSM.last_throw                      # CS
            
        # DATA VALIDATION
        else:
            raise Exception('RPSM class data corruption')