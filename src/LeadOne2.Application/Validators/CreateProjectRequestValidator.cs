using FluentValidation;
using LeadOne2.Application.DTOs.Projects;

namespace LeadOne2.Application.Validators;

public class CreateProjectRequestValidator : AbstractValidator<CreateProjectRequest>
{
    public CreateProjectRequestValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("Nome progetto è richiesto")
            .MaximumLength(200).WithMessage("Nome progetto troppo lungo");

        RuleFor(x => x.Description)
            .MaximumLength(1000).WithMessage("Descrizione troppo lunga");
    }
}
