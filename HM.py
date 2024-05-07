import random

class HM:

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
        
        HM._previous_result = result


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
        if HM._previous_result == None:
            if generated_value < 0.31:
                HM.last_throw = 0
            elif generated_value < 0.31+0.33:
                HM.last_throw = 2
            else:
                HM.last_throw = 1
            return HM.last_throw
            
        # DATA VALIDATION
        if (not isinstance(HM._previous_result, int)) or (not isinstance(HM.last_throw, int)):
            raise Exception('HM class data corruption')

        # WIN MODULE
        if HM._previous_result == 1:
            if generated_value < 0.5:
                return HM.last_throw                    # CS
            elif generated_value < 0.5+0.3:
                HM.last_throw = (HM.last_throw - 1) % 3 # CB
                return HM.last_throw
            else:
                HM.last_throw = (HM.last_throw + 1) % 3 # CF
                return HM.last_throw
            
        # LOSE MODULE
        elif HM._previous_result == -1:
            if generated_value < 0.2:
                return HM.last_throw                    # CS
            elif generated_value < 0.2+0.5:
                HM.last_throw = (HM.last_throw - 1) % 3 # CB
                return HM.last_throw
            else:
                HM.last_throw = (HM.last_throw + 1) % 3 # CF
                return HM.last_throw
        
        # TIE MODULE
        elif HM._previous_result == 0:
            if generated_value < 0.5:
                return HM.last_throw                    # CS
            elif generated_value < 0.5+0.2:
                HM.last_throw = (HM.last_throw - 1) % 3 # CB
                return HM.last_throw
            else:
                HM.last_throw = (HM.last_throw + 1) % 3 # CF
                return HM.last_throw
            
        # DATA VALIDATION
        else:
            raise Exception('HM class data corruption')