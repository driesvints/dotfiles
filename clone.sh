



#!/bin/sh

echo "Cloning repositories..."


#!/bin/sh

echo "Cloning repositories..."

PROJECTS=$HOME/Projects
ACADEMIC=$PROJECTS/academic
ADMIN = $PROJECTS/admin
NOTEBOOKS=$PROJECTS/notebooks
PERSONAL=$PROJECTS/personal
TOOLS=$PROJECTS/tools
TUTORIALS=$PROJECTS/tutorials
WORK=$PROJECTS/work

# Academic
PHD=$ACADEMIC/PhD

git clone https://github.com/thomas-hervey/Dissertation.git $PHD/Dissertation
git clone https://github.com/thomas-hervey/HERVEY_PROPOSAL.git $PHD/HERVEY_PROPOSAL
git clone https://github.com/thomas-hervey/HERVEY_DISSERTATION.git $PHD/HERVEY_DISSERTATION

# Admin
git clone https://github.com/thomas-hervey/dotfiles.git $ADMIN/dotfiles

# Notebooks

# Personal
git clone https://github.com/thomas-hervey/hackintosh.git $PERSONAL/hackintosh
git clone https://github.com/thomas-hervey/thomas-hervey.github.io.git $PERSONAL/thomas-hervey.github.io
git clone https://github.com/thomas-hervey/ticketing.git $PERSONAL/ticketing


# Tools

# Tutorials


# Work
