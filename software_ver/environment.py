import numpy as np
import random
import matplotlib.pyplot as plt

def render(map):
  m = map.copy()
  plt.imshow(m)
  plt.show()

class demon_env:
  def __init__(self, shape, demon_list, start_state=[0,0], treasure=(4,4)):

    self.height = shape[0]
    self.width = shape[1]
    
    self.observation_space = self.height*self.width
    self.action_space = [0,1,2,3]

    self.state = start_state.copy()
    self.map = np.zeros(shape)
    # 0-land  1-demon  2-treasure
    self.demons = demon_list
    self.last_loc_before_demon = start_state.copy()
    self.start_state = start_state.copy()

    self.map[treasure] = 2
    for (x, y) in self.demons:
      self.map[x, y] = 1
    
    self.done = False

  def check_curr_state(self):
    return self.map[self.state[0], self.state[1]]
  
  def step(self, action):
      self.last_loc_before_demon = self.state.copy()
      if action == 0:
        if self.state[0] < self.height - 1:
          self.state[0] += 1
      elif action == 1:
        if self.state[1] < self.width - 1:
          self.state[1] += 1
      elif action == 2:
        if self.state[0] > 0:
          self.state[0] -= 1
      elif action == 3:
        if self.state[1] > 0:
          self.state[1] -= 1

      reward = -0.1

      if self.state == self.last_loc_before_demon:
          reward -= 0.5
      
      elif self.check_curr_state() == 2:
          reward += 1
          self.done = True

      elif self.check_curr_state() == 1:
          self.state = self.last_loc_before_demon.copy()
          reward = -0.5
      

      return self.observe(), reward, self.done

  def observe(self):
    return self.state

  def reset(self):
    self.state = self.start_state.copy()
    self.done = False
    return self.observe()


def get_rollout_state(pos, map_size):
  return pos[0]*map_size[0] + pos[1]

def to_action_name(action_in_number):
  if action_in_number == 0:
    return 'DOWN'
  elif action_in_number == 1:
    return "RIGHT"
  elif action_in_number == 2:
    return 'UP'
  elif action_in_number == 3:
    return 'LEFT'

