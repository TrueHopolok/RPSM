import random

class AM:

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
        
        AM._previous_result = result


    def throw() -> int:
        '''
        Return generated throw\n
        If needed, result can be accessed through public field "last_throw" (READ ONLY)\n 
        2 = paper\n
        1 = rock\n
        0 = scissors\n
        '''

        # FIRST MOVE MODULE
        if AM._previous_result == None:
            AM.last_throw = 0
            return AM.last_throw

        # DATA VALIDATION
        if (not isinstance(AM._previous_result, int)) or (not isinstance(AM.last_throw, int)):
            raise Exception('AM class data corruption')

        # WIN/TIE MODULE
        if AM._previous_result == 1 or AM._previous_result == 0:
            AM.last_throw = (AM.last_throw + random.choice([1, -1])) % 3 # CB/CF
            return AM.last_throw
        
        # LOSE MODULE
        elif AM._previous_result == -1:
            return AM.last_throw
            
        # DATA VALIDATION
        else:
            raise Exception('AM class data corruption')