
- Blank Solution

- В корне создать dockerfile

```dockerfile
FROM httpd:alpine
COPY ./html/ /usr/local/apache2/htdocs/
```

- Создать проекты
  - /src
  - /src/**PublicApi**
  - /src/**Contracts**
  - /src/**Infrastructure**
  - /src/**Application**
  - /src/**Domain**
  - Shared project: **requests**
  - Shared project: **docs**

- /requests/Authentication/Register.http 
  - /requests/Authentication/Login.http 

- Удалить везде Class1.cs 


- Добавить везде референсы

| PublicApi | Infrastructure | Application |
|-----------|----------------|-------------|
|Contracts| Application | Domain|
|Infrastructure|||
|Application|||


- Добавить пакеты

| PublicApi | Infrastructure | Application |
|-----------|----------------|-------------|
|System.Configuration.ConfigurationManager | Application | Domain|
|Swashbuckle.AspNetCore ||MediatR |
|||MediatR.Extensions.Microsoft.DependencyInjection |
|||Microsoft.Extensions.DependencyInjection.Abstractions |


- **PublicApi**:
  - DependencyInjection.cs 
  - Controllers
    - V1
      - AuthenticationController.cs 
      - ErrorController.cs 
      - PostsController.cs 
      - TagsController.cs 
  - Options
    - ApiSwaggerOptions.cs 
 
- **Contracts**:
  - V1
    - ApiRoutes.cs
    - Authentication
      - Requests
        - RegisterRequest.cs
        - LoginRequest.cs
      - Responses
        - SuccessResponse.cs
        - FailedResponse.cs

- **Application** 
  - DependencyInjection.cs
  - Authentication
    - Common
      - AuthenticationResult.cs 
    - Commands
      - Register
        - RegisterCommand.cs 
        - RegisterCommandHandler.cs 
    - Queries
      - Login
        - LoginQuery.cs
        - LoginQueryHandler.cs 
  - Common
    - Interfaces
      - Authentication
        - IJwtTokenGenerator.cs
    - Services
      - IDateTimeProvider.cs 
  - Persistence
    - IUserRepository.cs 

- **Infrastructure**
  - DependencyInjection.cs
  - Services
    - DateTimeProvider.cs 
      - Persistence
        - UserRepository.cs
  - Authentication
    - JwtSettings.cs
    - JwtTokenGenerator.cs 
- **Domain**
  - Aggregates
    - User.cs 

git-bash:

`docker images`

`docker build -t hello-docker:1.0.0 .`
