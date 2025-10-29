using LeadOne2.Application.DTOs.Auth;
using LeadOne2.Core.Entities;
using LeadOne2.Core.Interfaces;

namespace LeadOne2.Application.Services;

public class AuthService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IAuthService _authProvider;

    public AuthService(IUnitOfWork unitOfWork, IAuthService authProvider)
    {
        _unitOfWork = unitOfWork;
        _authProvider = authProvider;
    }

    public async Task<LoginResponse?> LoginAsync(LoginRequest request)
    {
        var users = await _unitOfWork.Users.FindAsync(u => u.Email == request.Email);
        var user = users.FirstOrDefault();

        if (user == null || !_authProvider.VerifyPassword(request.Password, user.PasswordHash))
        {
            return null;
        }

        if (!user.IsActive)
        {
            throw new InvalidOperationException("Utente non attivo");
        }

        user.LastLoginAt = DateTime.UtcNow;
        await _unitOfWork.Users.UpdateAsync(user);
        await _unitOfWork.SaveChangesAsync();

        var token = _authProvider.GenerateJwtToken(user.Id, user.Email, user.IsAdmin);

        return new LoginResponse
        {
            Token = token,
            User = new UserDto
            {
                Id = user.Id,
                Email = user.Email,
                Name = user.Name,
                Surname = user.Surname,
                IsAdmin = user.IsAdmin
            }
        };
    }

    public async Task<LoginResponse> RegisterAsync(RegisterRequest request)
    {
        var existingUser = await _unitOfWork.Users.FindAsync(u => u.Email == request.Email);
        if (existingUser.Any())
        {
            throw new InvalidOperationException("Email già registrata");
        }

        var user = new User
        {
            Email = request.Email,
            PasswordHash = _authProvider.HashPassword(request.Password),
            Name = request.Name,
            Surname = request.Surname,
            IsActive = true,
            IsAdmin = false,
            CreatedAt = DateTime.UtcNow
        };

        await _unitOfWork.Users.AddAsync(user);
        await _unitOfWork.SaveChangesAsync();

        var token = _authProvider.GenerateJwtToken(user.Id, user.Email, user.IsAdmin);

        return new LoginResponse
        {
            Token = token,
            User = new UserDto
            {
                Id = user.Id,
                Email = user.Email,
                Name = user.Name,
                Surname = user.Surname,
                IsAdmin = user.IsAdmin
            }
        };
    }

    public async Task<UserDto?> GetUserByIdAsync(int userId)
    {
        var user = await _unitOfWork.Users.GetByIdAsync(userId);
        if (user == null)
        {
            return null;
        }

        return new UserDto
        {
            Id = user.Id,
            Email = user.Email,
            Name = user.Name,
            Surname = user.Surname,
            IsAdmin = user.IsAdmin
        };
    }
}
