#!/bin/bash

MOVIES=("Court" "HIT3" "Pushpa2" "Thandel")


echo "first movie name is ${MOVIES[0]}"    # @ or * or %
echo "second movie name is ${MOVIES[1]}"
echo "Third movie name is ${MOVIES[2]}"
echo "fourth movie name is ${MOVIES[3]}"


echo "All movies are displayed here ${MOVIES[@]}"