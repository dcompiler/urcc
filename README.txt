TO USE:
run rake to install this version of urcc as a gem

run urcc on whatever c file you want to generate the cfg for

a file "cfg.png" will be created in that directory, 
which is a graphviz generated visualization of the control flow graph

dependencies:
This depends on all dependencies listed, including a dependency to 
the gem "ruby-graphviz". Notably this is NOT "graphviz", which is an abandoned
gem. Please ensure you have installed "ruby-graphviz" before using this.


IMPLEMENTATION:
Not a lot of crazy things here, just defined a basic block and function class
and use the urcc defined classes to get enough information to implement a
version of the algorithm in the book. 

Each basic block is defined by the label
to get into the block, an array of labels the block can exit to, and an array
of instructions that make up the block. A function is made of an array of basic
blocks which are stitched together to form a graph.

Some shortcuts were made in the implementation that make this code only work
for IR generated from C, namely that the code assumes that all functions are
defined on level 1. As C does not have nested functions this is a sound
assumption for this project.

Additionally I do not draw edges resulting from function calls, as this was not
required either for this project.

The nodes in the CFG must be uniquely identifiable by their contents, so each
node has a header which specifies which function it is from, and what label
starts each block. The rest of the node is every assignment, function call, and
return instruction that makes up the block in order.

I made some changes to the repo, mainly to make the API easier to use, but
also to access the true and false branches to a conditional branch, which as
far as I am aware was difficult to do without the changes. Diffing this current
branch with the master branch should reveal every change, though most of the
work in done in bin/config/PASSES/cfg.rb
