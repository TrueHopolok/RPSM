# SELECTED MODELS
from RPSM_1 import RPSM as m1
from HM     import HM   as m2

# TESTS AMOUNT
GAMES_AMOUNT = 100000

# STATS INFO
M1_GAMES_WINS = 0
ROUNDS_PLAYED = 0
TIE_FIRST = 0
TIE_TOTAL = 0
M1_FIRST_WINS = 0
M1_TOTAL_WINS = 0

# TESTS INFO
current_game = 1
first_round = True
m1_points = 0
m2_points = 0
is_m1_won = False

# TESTS EXECUTION
while current_game <= GAMES_AMOUNT:
    if m1_points >= 3 or m2_points >= 3:
        if m1_points == 3:
            M1_GAMES_WINS += 1
        m1_points = 0
        m1.previous_result = None
        m2_points = 0
        m2.previous_result = None
        current_game += 1
        first_round = True
        continue
    
    m1.throw()
    m2.throw()

    # TIE
    if m1.last_throw == m2.last_throw:
        m1.previous_result = 0
        m2.previous_result = 0
        if first_round:
            TIE_FIRST += 1
        TIE_TOTAL += 1

    # WIN/LOSE
    else:
        if m1.last_throw > m2.last_throw:
            if m1.last_throw == 2 and m2.last_throw == 0:
                is_m1_won = False
            else:
                is_m1_won = True

        else:
            if m1.last_throw == 0 and m2.last_throw == 2:
                is_m1_won = True
            else:
                is_m1_won = False

        if is_m1_won:
            m1.previous_result = 1
            m2.previous_result = -1
            m1_points += 1
            if first_round:
                M1_FIRST_WINS += 1
            M1_TOTAL_WINS += 1
        else:
            m1.previous_result = -1
            m2.previous_result = 1
            m2_points += 1
    
    ROUNDS_PLAYED += 1
    first_round = False

print(f'''
====   
GAMES PLAYED:    {GAMES_AMOUNT}
M1 WINRATE:      {round(100.0*M1_GAMES_WINS/GAMES_AMOUNT, 2)}%
====
ROUNDS PLAYED:   {ROUNDS_PLAYED}
ALL ROUNDS:
    M1 WINRATE:  {round(100.0*M1_TOTAL_WINS/ROUNDS_PLAYED, 2)}%
    TIES RATE:   {round(100.0*TIE_TOTAL/ROUNDS_PLAYED, 2)}%
FIRST ROUNDS:
    M1 WINRATE:  {round(100.0*M1_FIRST_WINS/GAMES_AMOUNT, 2)}%
    TIES RATE:   {round(100.0*TIE_FIRST/GAMES_AMOUNT, 2)}%
====
''')    