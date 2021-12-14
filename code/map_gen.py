import random
import numpy as np

np.random.seed(32)
random.seed(32)

UP = np.array([-1,0])
RIGHT = np.array([0,1])
DOWN = np.array([1,0])
LEFT = np.array([0,-1])


treasure_spawn_points = [24,23,22,21,20,19,18,17,16,15,14,13,12, 4,9]

def get_adjacent_cell(maze, loc):
    valid_cells = []
    if (loc + UP)[0] > 0 and maze[tuple(loc+UP)] != 1:
        valid_cells.append(tuple(loc+UP))
    if (loc + DOWN)[0] < 5 and maze[tuple(loc+DOWN)] != 1:
        valid_cells.append(tuple(loc+DOWN))
    if (loc + RIGHT)[1] < 5 and maze[tuple(loc+RIGHT)] != 1:
        valid_cells.append(tuple(loc+RIGHT))
    if (loc + LEFT)[1] > 0 and maze[tuple(loc+LEFT)] != 1:
        valid_cells.append(tuple(loc+LEFT))

    return valid_cells

def check_valid_map(maze, spawn_point=np.array([0,0])):
    queue = [[tuple(spawn_point)]]
    visited = []

    best_path = []
    while queue != []:
        path = queue.pop(0)
        last = path[-1]

        if maze[tuple(last)] == 2:
            if len(path) < len(best_path) or len(best_path) == 0:
                best_path = path.copy()

        if last not in visited:
            adj_cell = get_adjacent_cell(maze, last)
            for x in adj_cell:
                if tuple(x) not in visited:
                    newPath = path.copy()
                    newPath.append(x)
                    queue.append(newPath)
                visited.append(tuple(last))

    if len(best_path) == 0:
        return False
    else:
        return len(best_path)


def convert_index_to_point(index, maze_size=5):
    return (index//maze_size, index%maze_size)

def generate_map():
    maze = np.random.randint(2, size=(5,5))
    #maze = np.zeros((5,5))
    maze[0][0] = 0
    treasure_x, treasure_y = convert_index_to_point(random.choice(treasure_spawn_points))
    maze[treasure_x][treasure_y] = 2
    return maze


def generate_map_files(count=10000, dir='map/'):
    cnt = 0
    while cnt < 10000:
        m = generate_map()
        length = check_valid_map(m)
        if length > 0:
            f_path = dir + f'{cnt}' + '.txt'
            file = open(f_path, 'w')
            for i in range(m.shape[0]):
                for j in range(m.shape[1]):
                    if m[i][j] == 0:
                        file.write('00\n')
                    elif m[i][j] == 1:
                        file.write('01\n')
                    else:
                        file.write('11\n')
            file.close()
            cnt += 1
        if cnt % 100:
            print(f'{cnt} maps Generated!')
        
    print('\nAll Done!')

generate_map_files()