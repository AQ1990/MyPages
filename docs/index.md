
## Создать проекты, добавить пакеты
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

## Добавить файлы

- **PublicApi**:
  - DependencyInjection.cs 
  - Controllers
    - V1
      - AuthenticationController.cs 
      - PostsController.cs
      - TagsController.cs
      - ErrorController.cs
  - Options
    - ApiSwaggerOptions.cs 
  - DependencyInjection.cs
 
- **Contracts**:
  - V1    
    - Authentication
      - Requests
        - RegisterRequest.cs
        - LoginRequest.cs
      - Responses
        - SuccessResponse.cs
        - FailedResponse.cs
    - Posts
      - Requests
        - CreatePostRequest.cs
        - UpdatePostRequest.cs
      - Responses
        - PostResponse.cs 
    - ApiRoutes.cs

- **Infrastructure**
  - Authentication
    - JwtSettings.cs
    - JwtTokenGenerator.cs 
  - Persistence
    - UserRepository.cs
  - Services
    - DateTimeProvider.cs
   - DependencyInjection.cs

- **Application** 
  - Authentication
    - Commands
      - Register
        - RegisterCommand.cs 
        - RegisterCommandHandler.cs 
    - Common
      - AuthenticationResult.cs 
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
  - DependencyInjection.cs

- **Domain**
  - Aggregates
    - User.cs 

## Код

- DI
  - <details>
      <summary>PublicApi/Program.cs</summary>

      ```csharp
      var builder = WebApplication.CreateBuilder(args);
      {
          builder.Services.AddApplication();
          builder.Services.AddInfrastructure(builder.Configuration);
          builder.Services.AddPresentation();
          builder.Services.AddControllers();
      }

      var app = builder.Build();
      {
          var swaggerOptions = new ApiSwaggerOptions();
  
          builder.Configuration.GetSection(nameof(ApiSwaggerOptions))
              .Bind(swaggerOptions);
  
          app.UseSwagger(option =>
          {
              option.RouteTemplate = swaggerOptions.JsonRoute;
          });
  
          app.UseSwaggerUI(option =>
          {
              option.SwaggerEndpoint(swaggerOptions.UiEndpoint, swaggerOptions.Description);
          });

          app.UseHttpsRedirection();
          app.MapControllers();
          app.Run();
      }
      ```
    </details>
  - <details>
      <summary>PublicApi/DependencyInjection.cs</summary>
      
      ```csharp
      public static IServiceCollection AddPresentation(this IServiceCollection services)
        {
            services.AddSwaggerGen(x =>
            {
                x.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
                {
                    Title = "Api",
                    Version = "v1"
                });
            });
            return services;
        }
      ```
    </details>
  - <details>
      <summary>Infrastructure/DependencyInjection.cs</summary>
      
      ```csharp
      public static IServiceCollection AddInfrastructure(this IServiceCollection services, ConfigurationManager config)
        {
            services.Configure<JwtSettings>(config.GetSection(JwtSettings.SectionName));
            services.AddSingleton<IJwtTokenGenerator, JwtTokenGenerator>();
            services.AddSingleton<IDateTimeProvider, DateTimeProvider>();

            services.AddScoped<IUserRepository, UserRepository>();
            return services;
        }
      ```
    </details>
  - <details>
      <summary>Application/DependencyInjection.cs</summary>
      
      ```csharp
      public static IServiceCollection AddApplication(this IServiceCollection services)
        {
            services.AddMediatR(typeof(DependencyInjection).Assembly);
            return services;
        }
      ```
    </details>

- <details>
  <summary>http-файлы /requests/</summary>
  
  ```http
    /requests/Authentication/Register.http 
    /requests/Authentication/Login.http
  ```
  </details>
  
## Другое
  
- <details>
    <summary>Докер bash-команды</summary>

    `docker images`

    `docker build -t hello-docker:1.0.0 .`
  </details>
