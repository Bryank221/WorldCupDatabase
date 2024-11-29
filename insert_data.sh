#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate games, teams")

# read every row
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
  #skip first row
  if [[ $WINNER != winner ]]
  then
  #Checks if winner name is inside the database
    TEAM_ID_WINNER=$($PSQL "select team_id from teams where name = '$WINNER'")
    if [[ -z $TEAM_ID_WINNER ]]
    then
    #If not found
      INSERT_TEAM_ID=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_TEAM_ID == 'INSERT 0 1' ]]
      then
        echo "Inserted into teams, $WINNER"
      fi
    fi
    #set team name to team id
    TEAM_ID_WINNER=$($PSQL "select team_id from teams where name = '$WINNER'")



    # Checks for opponenet name in table
    TEAM_ID_OPPO=$($PSQL "select team_id from teams where name = '$OPPONENT'")
    
    if [[ -z $TEAM_ID_OPPO ]]
    then
      # if not found
      INSERT_TEAM_ID=$($PSQL "insert into teams(name) values('$OPPONENT')")
      if [[ $INSERT_TEAM_ID == 'INSERT 0 1' ]]
      then
        echo "Inserted into teams, $OPPONENT"
      fi
    fi

    # Set name to team id
    TEAM_ID_OPPO=$($PSQL "select team_id from teams where name = '$OPPONENT'")

    #insert rest of data into games
    INSERT_ROW=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $TEAM_ID_WINNER, $TEAM_ID_OPPO, $WINNERGOALS, $OPPONENTGOALS)")
    
    if [[ $INSERT_TEAM_ID == 'INSERT 0 1' ]]
    then
      echo "Inserted into games, row"
    fi
  fi
done