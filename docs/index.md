
## Создать проекты, добавить пакеты
- Blank Solution

- Создать проекты
  - src/
  - src/**Web** (Empty .Net)
  - src/**Presentation** (Class Library)
  - src/**Infrastructure** (Class Library)
  - src/**Application** (Class Library)
  - src/**Domain** (Class Library)
  - **requests** (Shared Project)
  - **docs** (Shared Project)

- Удалить везде Class1.cs 


- Добавить везде референсы

| Web | Presentation | Infrastructure | Application |
|-----|-----------|----------------|-------------|
| Presentation | Web | Application | Domain|
| Infrastructure | Infrastructure |||
| Application | Application |||

## Добавить файлы
- <details><summary>Web</summary>
  
  - Contracts
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
  - Options
    - ApiSwaggerOptions.cs 
  </details>

- <details>
  <summary>Presentation</summary>  
  
  - Controllers
    - V1
      - AuthenticationController.cs 
      - PostsController.cs
      - TagsController.cs
      - ErrorController.cs
  - DependencyInjection.cs
  </details>
   
- <details><summary>Infrastructure</summary>
  
  - Authentication
    - JwtSettings.cs
    - JwtTokenGenerator.cs 
  - Persistence
    - UserRepository.cs
  - Services
    - DateTimeProvider.cs
   - DependencyInjection.cs
  </details>
  
- <details><summary>Application</summary> 
  
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
  </details>
  
- <details><summary>Domain</summary>
  
  - Aggregates
    - User.cs 
  </details>

## Добавить пакеты

| Presentation | Infrastructure | Application |
|-----------|----------------|-------------|
|System.Configuration.ConfigurationManager | Microsoft.Extensions.Configuration | Microsoft.Extensions.DependencyInjection |
|Swashbuckle.AspNetCore | Microsoft.Extensions.Options.ConfigurationExtension |MediatR|
| - | Microsoft.EntityFrameworkCore.SqlServer | MediatR.Extensions.Microsoft.DependencyInjection |
| - | Microsoft.EntityFrameworkCore.Tools | - |
| - | Microsoft.AspNetCore.Identity.EntityFrameworkCore | - |
| - | System.IdentityModel.Tokens.Jwt | - |

## Код

- ### Dependency Injection
  - <details>
      <summary>Presentation/DependencyInjection.cs</summary>
      
      ```csharp
      public static IServiceCollection AddPresentation(this IServiceCollection services)
        {
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
      <summary>Web/Program.cs</summary>

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
          app.UseHttpsRedirection();
          app.MapControllers();
          app.Run();
      }
      ```
    </details>
  
- ### DateTime Provider
  - **Application**
    <details>
      <summary>Common/Services/IDateTimeProvider.cs</summary>
      
      ```csharp
      public interface IDateTimeProvider
      {
          DateTime UtcNow { get; }
      }
      ```
    </details>
  - **Infrastructure**
    <details>
      <summary>Services/DateTimeProvider.cs</summary>
      
      ```csharp
      public class DateTimeProvider : IDateTimeProvider
      {
          public DateTime UtcNow => DateTime.UtcNow;
      }
      ```
    </details>
    <details>
      <summary>DependencyInjection.cs</summary>
      Добавить
      
      ```csharp
      services.AddSingleton<IDateTimeProvider, DateTimeProvider>();
      ```
    </details>

- ### DbContext
  - **Infrastructure**
    <details>
    <summary>Persistence/ApplicationDbContext.cs</summary>
      
      ```csharp
      ```
    </details>
  </details>    
- ### Repository
  - **Infrastructure**
    <details>
    <summary>Persistence/ApplicationDbContext.cs</summary>
      
      ```csharp
      public class ApplicationDbContext : IdentityDbContext
      {
          public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
          {

          }
      }
      ```
    </details>  
      
    <details>
    <summary>Persistence/UnitOfWork.cs</summary>
      
      ```csharp
      public sealed class UnitOfWork : IUnitOfWork
      {
          private readonly ApplicationDbContext _ctx;

          public UnitOfWork(ApplicationDbContext ctx)
          {
              _ctx = ctx;
          }

          public Task SaveChangesAsync(CancellationToken cancellationToken = default)
          {
              return _ctx.SaveChangesAsync(cancellationToken);
          }
      }
      ```
    </details>
      
  - **Infrastructure**
    <details>
    <summary>Persistence/ApplicationDbContext.cs</summary>
      
      ```csharp
      public class ApplicationDbContext : IdentityDbContext
      {
          public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
          {

          }
      }
      ```
    </details>  

  - **Application**
    <details>
    <summary>Persistence/IUnitOfWork.cs</summary>
      
      ```csharp
     
      ```
    </details>        

  - **Domain**
    <details>
    <summary>Aggregates/User.cs</summary>
      
      ```csharp
        public class User
        {
            public Guid Id { get; set; } = Guid.NewGuid();
            public string FirstName { get; set; } = null!;
            public string LastName { get; set; } = null!;
            public string Email { get; set; } = null!;
            public string Password { get; set; } = null!;
        }
      ```
    </details>  
      
  - **Application**
    <details>
    <summary>Persistence/IUserRepository.cs</summary>
      
      ```csharp
        public interface IUserRepository
        {
            User? GetUserByEmail(string email);
            void Add(User user);
        }
      ```
    </details>
  - **Infrastructure**
    <details>
    <summary>Persistence/UserRepository.cs</summary>
      
      ```csharp
        public class UserRepository : IUserRepository
        {
            private static readonly List<User> _users = new();

            public User? GetUserByEmail(string email)
            {
                return _users.SingleOrDefault(u => u.Email == email);
            }

            public void Add(User user)
            {
                _users.Add(user);
            }
        }
      ```
    </details>
    <details>
    <summary>DependencyInjection.cs</summary>
      
      ```csharp
        public static class DependencyInjection
        {
            public static IServiceCollection AddInfrastructure(this IServiceCollection services)
            {
                services.AddScoped<IUserRepository, UserRepository>();
                return services;
            }
        }
      ```
    </details>   
      
- ### Authentication
  - **Web**
    <details>
      <summary>Contracts/V1/Authentication/Requests/RegisterRequest.cs</summary>

      ```csharp
      public record RegisterRequest(
          string FirstName,
          string LastName,
          string Email,
          string Password);
      ```
    </details>
    <details>
      <summary>Contracts/V1/Authentication/Requests/LoginRequest.cs</summary>

      ```csharp
      public record LoginRequest(
          string Email,
          string Password);
      ```
    </details>
    <details>
      <summary>Contracts/V1/Authentication/Responses/SuccessResponse.cs</summary>

      ```csharp
      public record SuccessResponse(
          Guid Id,
          string FirstName,
          string LastName,
          string Email,
          string Token);
      ```
    </details>
    <details>
      <summary>Contracts/V1/Authentication/Responses/FailedResponse.cs</summary>

      ```csharp
      public class FailedResponse
      {

      }
      ```
    </details>

  - **Application**
    <details>
    <summary>Authentication/Common/AuthenticationResult.cs</summary>
      
      ```csharp
      public record AuthenticationResult(
          User User,
          string Token);
      ```
    </details>    
    <details>
    <summary>Authentication/Commands/Register/RegisterCommand.cs</summary>
      
      ```csharp
        public record RegisterCommand(
          string FirstName,
          string LastName,
          string Email,
          string Password) : IRequest<AuthenticationResult>;
      ```
    </details>
      

    <details>
    <summary>Authentication/Commands/Register/RegisterCommandHandler.cs</summary>
      
      ```csharp
        public class RegisterCommandHandler :
            IRequestHandler<RegisterCommand, AuthenticationResult>
        {
            private readonly IJwtTokenGenerator _jwttokengenerator;
            private readonly IUserRepository _userRepository;

            public RegisterCommandHandler(IJwtTokenGenerator jwtTokenGenerator,
                IUserRepository userRepository)
            {
                _jwttokengenerator = jwtTokenGenerator;
                _userRepository = userRepository;
            }
            public async Task<AuthenticationResult> Handle(RegisterCommand command, CancellationToken cancellationToken)
            {
                if (_userRepository.GetUserByEmail(command.Email) is not null)
                {
                    throw new Exception("User with given email already exists");
                }

                var user = new User
                {
                    FirstName = command.FirstName,
                    LastName = command.LastName,
                    Email = command.Email,
                    Password = command.Password
                };
                _userRepository.Add(user);

                Guid userId = Guid.NewGuid();
                var token = _jwttokengenerator.GenerateToken(user);

                return new AuthenticationResult(
                    user,
                    token);
            }
        }
    ```
    </details>
    <details>
    <summary>Authentication/Queries/Login/LoginQuery.cs</summary>
      
      ```csharp
        public record LoginQuery(string Email, string Password)
                : IRequest<AuthenticationResult>;
      ```
    </details>
    <details>
    <summary>Authentication/Queries/Login/LoginQueryHandler.cs</summary>
      
      ```csharp
        public class LoginQueryHandler :
            IRequestHandler<LoginQuery, AuthenticationResult>
        {
            private readonly IJwtTokenGenerator _jwttokengenerator;
            private readonly IUserRepository _userRepository;

            public LoginQueryHandler(IJwtTokenGenerator jwtTokenGenerator,
                IUserRepository userRepository)
            {
                _jwttokengenerator = jwtTokenGenerator;
                _userRepository = userRepository;
            }

            public async Task<AuthenticationResult> Handle(LoginQuery query, CancellationToken cancellationToken)
            {
                if (_userRepository.GetUserByEmail(query.Email) is not User user)
                {
                    throw new Exception("User with given email does not exist");
                }

                if (user.Password != query.Password)
                {
                    throw new Exception("Invalid password");
                }

                var token = _jwttokengenerator.GenerateToken(user);

                return new AuthenticationResult(
                    user,
                    token);
            }
        }
      ```
    </details>      
      
  - **Presentation**
      
    <details>
      <summary>Controllers/V1/AuthenticationController.cs</summary>
      
      ```csharp
      [ApiController]
      [Route("auth")]
      public class AuthenticationController : ControllerBase
      {
          private readonly ISender _mediator;

          public AuthenticationController(
              IMediator mediator)
          {
              _mediator = mediator;
          }

          [HttpPost("register")]
          public async Task<IActionResult> Register(RegisterRequest request)
          {
              var command = new RegisterCommand(request.FirstName, request.LastName, request.Email, request.Password);
              var authResult = await _mediator.Send(command);

              var authResponse = new SuccessResponse(
                  authResult.User.Id,
                  authResult.User.FirstName,
                  authResult.User.LastName,
                  authResult.User.Email,
                  authResult.Token);
              return Ok(request);
          }

          [HttpPost("login")]
          public async Task<IActionResult> Login(LoginRequest request)
          {
              var query = new LoginQuery(request.Email, request.Password);
              var authResult = await _mediator.Send(query);
              var authResponse = new SuccessResponse(
                  authResult.User.Id,
                  authResult.User.FirstName,
                  authResult.User.LastName,
                  authResult.User.Email,
                  authResult.Token);
              return Ok(request);
          }
      }
      ```
    </details>

- ### Swagger
  - **Web**
    <details>
    <summary>Secrets</summary>
    
    ```json
    {
      "JwtSettings": {
        "Secret": "super-secret-secret"
      }
    }
    ```
    </details>
    <details>
      <summary>appsettings.Development</summary>
      
      ```json
        "ApiSwaggerOptions": {
          "JsonRoute": "swagger/{documentName}/swagger.json",
          "Description": "Our API",
          "UIEndpoint":  "v1/swagger.json"
        }
      ```
    </details>
    <details>
      <summary>Options/ApiSwaggerOptions.cs</summary>
      
      ```csharp
      public record ApiSwaggerOptions(
          string JsonRoute = null!,
          string UiEndpoint = null!,
          string Description = null!);
      ```
    </details>
    <details>
      <summary>DependencyInjection.cs</summary>
      
      ```csharp
      services.AddSwaggerGen(x =>
      {
          x.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
          {
              Title = "Api",
              Version = "v1"
          });
      });
      ```
    </details>
    <details>
    <summary>Program.cs</summary>
    
    Добавить
    
    ```csharp
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
    ```
    </details>
  
- ### JWT
  
## Тесты
  
- Создать проекты
  - tests/
  - tests/**Architecture.Tests**

## Другое
  
- <details>
      <summary>В корне создать dockerfile</summary>
      
      ```dockerfile
      FROM httpd:alpine
      COPY ./html/ /usr/local/apache2/htdocs/
      ```
  </details>
      
- <details>
    <summary>Докер bash-команды</summary>

    `docker images`

    `docker build -t hello-docker:1.0.0 .`
  </details>
  
- <details>
  <summary>http-запросы VS Code</summary>  
  
  **requests**/Authentication/Register.http
  
  ```http
  @host=https://localhost:7056

  POST {{host}}/auth/register
  Content-type: application/json

  {
      "firstName": "Anton",
      "lastName": "K",
      "email": "ak@example.com",
      "password": "P@ssword123!"
  }  
  ```
  
  **requests**/Authentication/Login.http
  
  ```http
  @host=https://localhost:7056

  POST {{host}}/auth/login
  Content-type: application/json

  {
      "email": "ak@example.com",
      "password": "P@ssword123!"
  }
  ```
  </details>
