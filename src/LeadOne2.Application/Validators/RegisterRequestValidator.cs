using FluentValidation;
using LeadOne2.Application.DTOs.Auth;

namespace LeadOne2.Application.Validators;

public class RegisterRequestValidator : AbstractValidator<RegisterRequest>
{
    public RegisterRequestValidator()
    {
        RuleFor(x => x.Email)
            .NotEmpty().WithMessage("Email è richiesta")
            .EmailAddress().WithMessage("Email non valida");

        RuleFor(x => x.Password)
            .NotEmpty().WithMessage("Password è richiesta")
            .MinimumLength(8).WithMessage("La password deve essere di almeno 8 caratteri");

        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("Nome è richiesto")
            .MaximumLength(100).WithMessage("Nome troppo lungo");

        RuleFor(x => x.Surname)
            .NotEmpty().WithMessage("Cognome è richiesto")
            .MaximumLength(100).WithMessage("Cognome troppo lungo");
    }
}
