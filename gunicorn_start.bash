#!/bin/bash
 
NAME="signup"                                      # Name of the application
DJANGODIR=/home/crakins/en3/signup                 # Django project directory
SOCKFILE=/home/crakins/en3/run/gunicorn.sock       # we will communicte using this unix socket
USER=crakins                                       # the user to run as
GROUP=crakins                                      # the group to run as
NUM_WORKERS=3                                      # how many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=signup.settings             # which settings file should Django use
 
 
echo "Starting $NAME"
 
# Activate the virtual environment
cd $DJANGODIR
# Source virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh
workon $NAME # original entry: source ../bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH
 
# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR
 
# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec gunicorn_django \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --log-level=debug \
  --bind=unix:$SOCKFILE