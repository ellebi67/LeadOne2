using FluentValidation;
using LeadOne2.Application.DTOs.Auth;

namespace LeadOne2.Application.Validators;

public class LoginRequestValidator : AbstractValidator<LoginRequest>
{
    public LoginRequestValidator()
    {
        RuleFor(x => x.Email)
            .NotEmpty().WithMessage("Email è richiesta")
            .EmailAddress().WithMessage("Email non valida");

        RuleFor(x => x.Password)
            .NotEmpty().WithMessage("Password è richiesta")
            .MinimumLength(6).WithMessage("La password deve essere di almeno 6 caratteri");
    }
}
