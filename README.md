# FPGA_DynaQ
a FPGA design of Dyna-Q Algorithm. [LSI design Contest 2021](http://www.lsi-contest.com/2021/index_e.html).

We demonstrate our design in [a simple maze search problem](http://www.lsi-contest.com/2021/shiyou_4e.html).

## Dyna-Q Algorithm

Dyna Q learning is among model-based planning reinforcement learning
methods which learns Q function to estimate state-action value. Dyna Q learning is basically
Q-Learning algorithm with extra planning steps.

<img src="report/dynaq.png" align="middle" width="500"/>

## FPGA design.

Our design contains 3 main parts:
- Environment block.
- Training block.
- Q-table Block.

## Results
Experimental result (run on Altera DE2 board) shows that our FPGA design is correct. 
<img src="report/example.png" align="middle" width="500"/>


## Video Demonstration
See video demo at: [Drive](https://drive.google.com/file/d/1g09FqitMydQldYfyPaarD5OEChjlGh0d/view?usp=sharing)

## Acknowledgement
Our source code is inspired by:
- [RL introduction book by Andrew Barto and Richard S. Sutton](http://incompleteideas.net/book/ebook/node96.html)

