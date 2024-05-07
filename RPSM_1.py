class RPSM:

    last_throw = 0
    '''
    READ ONLY\n
    2 = paper\n
    1 = rock\n
    0 = scissors\n
    '''

    _previous_result = None

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
        
        RPSM._previous_result = result


    def throw() -> int:
        '''
        Return generated throw\n
        If needed, result can be accessed through public field "last_throw" (READ ONLY)\n 
        2 = paper\n
        1 = rock\n
        0 = scissors\n
        '''

        # FIRST MOVE MODULE
        if RPSM._previous_result == None:
            RPSM.last_throw = 2
            return RPSM.last_throw

        # DATA VALIDATION
        if (not isinstance(RPSM._previous_result, int)) or (not isinstance(RPSM.last_throw, int)):
            raise Exception('RPSM class data corruption')

        # WIN/LOSE MODULE
        if RPSM._previous_result == 1 or RPSM._previous_result == -1:
            RPSM.last_throw = (RPSM.last_throw - 1) % 3 # CB
            return RPSM.last_throw
        
        # TIE MODULE
        elif RPSM._previous_result == 0:
            RPSM.last_throw = (RPSM.last_throw + 1) % 3 # CF
            return RPSM.last_throw
            
        # DATA VALIDATION
        else:
            raise Exception('RPSM class data corruption')