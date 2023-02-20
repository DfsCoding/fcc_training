#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "truncate table games, teams;")"

cat games.csv|while  IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $winner != 'winner' ]]
  then
    #insérer dans teams
    #vérifier si winner existe
    EXIST_WINNER=$($PSQL "select name from teams where name='$winner';")
    echo check winner $winner
    if [[ -z $EXIST_WINNER ]]
    then
      INSERT_TEAMS_RSLT=$($PSQL "insert into teams(name) values('$winner');")
      echo $INSERT_TEAMS_RSLT $winner
    fi
    echo check opponent $opponent
     EXIST_OPPONENT=$($PSQL "select name from teams where name='$oppenent';")
     echo -e "\n Oppenent : $EXIST_OPPONENT"

    if [[ -z $EXIST_OPPONENT ]]
    then
      INSERT_TEAMS_RSLT=$($PSQL "insert into teams(name) values('$opponent');")
      echo $INSERT_TEAMS_RSLT $opponent
    fi


  fi
done

echo -e "\n\n Insertion des games\n\n"
cat games.csv|while  IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $winner != 'winner' ]]
  then
    #récupérer l'ide du winner et de l'opponent
    WINNER_ID="$($PSQL "select team_id from teams where name='$winner'")"
    OPPONENT_ID="$($PSQL "select team_id from teams where name='$opponent'")"

    #insérer les données dans games
    GAMES_RSLT="$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values( $year, '$round', $WINNER_ID, $OPPONENT_ID, $winner_goals, $opponent_goals);")"
    echo "Insertion games : $round $GAMES_RSLT"
  fi
done