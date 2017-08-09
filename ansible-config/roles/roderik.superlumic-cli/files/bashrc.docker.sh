
# clear all docker images and containers
alias dockerclean='docker rm $(docker ps -a -q); docker rmi $(docker images -q)'

alias dc='docker-compose'

function dcb() {
  docker exec -it $(docker-compose ps -q $1) bash
}

function dcphp() {
  docker exec -it $(docker-compose ps -q php) "$@"
}

function dcmysql() {
  docker exec -it $(docker-compose ps -q mysql) "$@"
}

function dccomposer() {
  docker exec -it $(docker-compose ps -q php) composer "$@"
}

function dcconsole() {
  docker exec -it $(docker-compose ps -q php) bin/console "$@" || app/console "$@"
}

function dcgulp() {
  docker exec -it $(docker-compose ps -q php) gulp "$@"
}

function dcswagger() {
  docker exec -it $(docker-compose ps -q php) ./generate_swagger_docs.sh
}
