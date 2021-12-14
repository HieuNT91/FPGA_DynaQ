from environment import *
from dyna_Q import *
from MAP_INFO import *

parameters = {
    'episode_threshold': 10,
    'gamma': 0.5,
    'alpha': 1.0,
    'epsilon_start': 0.05,
    'epsilon_min': 0.001,
    'epsilon_decay_rate': 0.00001,
    'steps': 1,
    'threshold_theta': 1
}


def render(map, name=''):
    m = map.copy()
    plt.imshow(m)
    plt.savefig(f'result/maze_1/{name}.png')

def solve_map(MAP_ID, parameters, size = (5,5)):
    for s in MAP_ID['start_list']:
        env = demon_env( size, MAP_ID['demon_list'], start_state=s, treasure=MAP_ID['treasure'])

        states = dyna_Q(env, parameters)[2]
        for i in range(len(states)):
            states[i] = convert_index_to_point(states[i])

        m = env.map.copy()

        for ss in states:
            m[ss] = 4
        render(m, name=f"{MAP_ID['name']}_{s}")
        print(f"{MAP_ID['name']}_{s}  -- CREATED!")

def convert_index_to_point(index, maze_size=5):
    return (index//maze_size, index%maze_size)


solve_map(MAP_1, parameters)