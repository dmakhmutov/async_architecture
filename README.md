# async_architecture

###### The first attempt of creating microservice architecture [miro](https://miro.com/app/board/o9J_lpLcmJM=/)


To run message broker: `docker compose up`

Auth service:
```
cd auth
bundle exec rails s
```

Tasks service:
```
cd tasks
bundle exec rails s -p 3001
bundle exec karafka server
```

Accounting service:
```
cd accounting
bundle exec rails s -p 3002
bundle exec karafka server
```

Analytics service:
```
cd analytics
bundle exec rails s -p 3003
bundle exec karafka server
```

hints
```
localhost:3000/oauth/applications - oauth app managment
