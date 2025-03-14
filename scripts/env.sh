#!/bin/bash
if [ ! -f .env ]
then
  #export $(cat .env | xargs)
  export $(sed 's/=.*//' .env)
fi

set -a && source .env && set +a

