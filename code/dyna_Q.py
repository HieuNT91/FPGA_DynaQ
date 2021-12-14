from environment import *

def dyna_Q(env, parameters, num_training_episodes=1001):
    q_values = np.zeros((env.observation_space, len(env.action_space)))
    history_steps = []
    min_step_to_goal = 9999
    episode_count = 0
    models = {}
    optimal_action_list = []
    update_Q_time = 0

    episode_threshold = parameters['episode_threshold']
    gamma = parameters['gamma']
    epsilon_start = parameters['epsilon_start']
    epsilon_min = parameters['epsilon_min']
    epsilon_decay_rate = parameters['epsilon_decay_rate']
    alpha = parameters['alpha']
    steps = parameters['steps']

    for episode in range(1,num_training_episodes):
        state = get_rollout_state(env.reset(), (env.height, env.width))
        action_list = []
        state_list = [state]
        done = False
        cnt = 0
        if epsilon_decay_rate == 0.0:
            epsilon = epsilon_start
        else:
            epsilon = epsilon_min + (epsilon_start - epsilon_min)*np.exp(-epsilon_decay_rate*episode)
        while not done:
            update_Q_time += steps + 1
            cnt += 1
            if np.random.uniform(0,1) < epsilon:
                action = random.choice(env.action_space)
            else:
                action = np.argmax(q_values[state])
            action_list.append(to_action_name(action))
            next_state, reward, done = env.step(action)
            next_state = get_rollout_state(next_state, (env.height, env.width))
            state_list.append(next_state)
            if state not in models.keys():
              models[state] = {}
            models[state][action] = (reward, next_state)
            q_values[state,action] = (1-alpha)*q_values[state,action] + alpha*(reward + gamma * np.max(q_values[next_state]))
            if cnt > 50 * env.observation_space:
              done = True
            state = next_state
            for _ in range(steps):
              _state = np.random.choice(list(models.keys()))
              _action = np.random.choice(list(models[_state].keys()))

              _reward, n_state = models[_state][_action]
              q_values[_state,_action] = (1-alpha)*q_values[_state,_action] + alpha*(_reward + gamma * np.max(q_values[n_state]))

        if cnt -1 < min_step_to_goal:
            min_step_to_goal = cnt - 1
            episode_count = 0
            optimal_action_list = action_list.copy()
            optimal_state_list = state_list.copy()
        if episode_count == episode_threshold:
            #print(f'Found shortest path at episode {episode - episode_count - 1}: {min_step_to_goal} steps ({optimal_action_list[:-1]})')
            return q_values, history_steps, optimal_state_list, update_Q_time
        history_steps.append(cnt-1)
        episode_count += 1
    return q_values, history_steps, optimal_state_list, update_Q_time


def run_multiple_times(env, parameters, algo='Q_Learning', run_time = 100):
    learning_func = dyna_Q
    sum = [0, 0, 0]
    for _ in range(run_time):
        _, h_, _, u_t = learning_func(env, parameters)
        sum[0] += min(h_)
        sum[1] += len(h_)
        sum[2] += u_t
    return round(sum[0]/run_time,3), round(sum[1]/run_time,3), round(sum[2]/run_time, 3)