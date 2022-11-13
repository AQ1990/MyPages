# Blank Solution 
/src
    
* Shared project: requests 
/requests/Authentication/Register.http 
/requests/Authentication/Login.http 
 

* /src/Domain 
- [ ] /src/Application 
/src/Infrastructure 
/src/Contracts/ 
/src/PublicApi 
 

* Application, Infrastructure, Contracts, Domain Удалить везде Class1.cs 
 

* PublicApi->Contracts 
PublicApi->Application 
PublicApi->Infrastructure 
Infrastructure->Application 
Application->Domain 
 

* PublicApi: 
System.Configuration.ConfigurationManager 
Swashbuckle.AspNetCore 
Application: 
MediatR 
MediatR.Extensions.Microsoft.DependencyInjection 
Microsoft.Extensions.DependencyInjection.Abstractions 
Infrastructure 
 

* PublicApi: 
DependencyInjection.cs 
Controllers/V1/AuthenticationController.cs 
Controllers/V1/ErrorController.cs 
Controllers/V1/PostsController.cs 
Controllers/V1/TagsController.cs 
Options/ApiSwaggerOptions.cs 
 
* Contracts: 
V1/ApiRoutes.cs 
V1/Authentication/Requests/RegisterRequest.cs 
V1/Authentication/Requests/LoginRequest.cs 
V1/Authentication/Responses/SuccessResponse.cs 
V1/Authentication/Responses/FailedResponse.cs 
Application: 
DependencyInjection.cs 
/Authentication/Common/AuthenticationResult.cs 
/Authentication/Commands/Register/RegisterCommand.cs 
/Authentication/Commands/Register/RegisterCommandHandler.cs 
/Authentication/Queries/Login/LoginQuery.cs 
/Authentication/Queries/Login/LoginQueryHandler.cs 
/Common/Interfaces/Authentication/IJwtTokenGenerator.cs 
/Common/Services/IDateTimeProvider.cs 
/Persistence/IUserRepository.cs 
Infrastructure: 
DependencyInjection.cs 
/Services/DateTimeProvider.cs 
/Persistence/UserRepository.cs 
/Authentication/JwtSettings.cs 
/Authentication/JwtTokenGenerator.cs 
Domain: 
/Aggregates/User.cs 
