#!/bin/bash

#start
echo "start rails server..."
if [ $RAILS_START_SCRIPT == "rails" ]; then
  cd "$RAILS_HOME/$RAILS_PROJECT" && sudo -u $RAILS_USER -HE bundle exec rails s -d
else
  chmod +x $RAILS_START_SCRIPT
  bash $RAILS_START_SCRIPT
fi

echo "start nginx server..."
sudo service nginx start