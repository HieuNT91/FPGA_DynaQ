from environment import *
from dyna_Q import *
from MAP_INFO import *

parameters = {
    'episode_threshold': 30,
    'gamma': 0.9,
    'alpha': 1.0,
    'epsilon_start': 0.05,
    'epsilon_min': 0.001,
    'epsilon_decay_rate': 0.0001,
    'steps': 1,
    'threshold_theta': 1
}


def render(map, name=''):
    m = map.copy()
    plt.imshow(m)
    plt.savefig(f'result/maze_1/{name}.png')

def solve_map(MAP_ID, parameters, size = (5,5), render = False):
    for s in MAP_ID['start_list']:
        env = demon_env( size, MAP_ID['demon_list'], start_state=s, treasure=MAP_ID['treasure'])

        states = dyna_Q(env, parameters)[2]
        
        if render:
            for i in range(len(states)):
                states[i] = convert_index_to_point(states[i])
            m = env.map.copy()
            for ss in states:
                m[ss] = 4
            render(m, name=f"{MAP_ID['name']}_{s}")
            print(f"{MAP_ID['name']}_{s}  -- CREATED!")
        else:
            return states

def convert_index_to_point(index, maze_size=5):
    return (index//maze_size, index%maze_size)

def read_map(dire='map/0.txt'):
    lines = None
    with open(dire, 'r') as f:
        lines = f.read().splitlines()

    MAP_DICT = {}
    MAP_DICT['name'] = dire[4:-4]
    MAP_DICT['start_list'] = [[0,0]]
    MAP_DICT['demon_list'] = []
    MAP_DICT['treasure'] = None

    for i,s in enumerate(lines):
        if s == '11':
            loc = convert_index_to_point(i)
            MAP_DICT['treasure'] = loc

        elif s == '01':
            loc = convert_index_to_point(i)
            MAP_DICT['demon_list'].append(loc)

    return MAP_DICT

write_file = open('2000_result.txt', 'w')
cnt = 0
for i in range(2000):
    file_name = 'map/' + str(i) + '.txt'
    MAP_DICT = read_map(file_name)
    states = solve_map(MAP_DICT, parameters)
    states = states[1:]
    path_string = ''
    for x in states:
        path_string += str(x) + '_'
    write_file.write(str(len(states)) + " " + path_string[:-1] + '\n')
    cnt += 1
    if cnt % 100 == 0:
        print(f'{cnt}/2000 files saved!')
print(f'\nTotal: {cnt}/2000 files saved!')
write_file.close()