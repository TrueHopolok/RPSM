from RPSM_2 import RPSM as model

print('====\nMini script to use any RPS model\n====\nTo exit press ctrl+C;\nTo fully reset type "restart";\nTo start as new game type "newgame";\nTo use type game result as integer (1 = win, 0 = tie, -1 = lose);')
model.throw()
while True:
    print('====')
    match model.last_throw:
        case 0:
            print('Model threw SCISSORS')
        case 1:
            print('Model threw ROCK')
        case 2:
            print('Model threw PAPER')
    s = input('Give a round result: ')
    if s == 'restart':
        model._previous_result = None
        try:
            model._tactic_weight = 0.7
            model._last_tactic_is_second = False
        finally:
            model.throw()
            print('Model had been restarted')
        continue
    elif s == 'newgame':
        model.set_last_result(None)
        model.throw()
        print('Model had been prepared')
        continue
    try:
        r = int(s)
        if not r in [-1, 0, 1]:
            print('Invalid input, try again...')
            continue
        model.set_last_result(r)
        model.throw()
    except:
        print('Invalid input, try again...')