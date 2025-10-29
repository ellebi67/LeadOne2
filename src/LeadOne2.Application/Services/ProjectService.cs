using LeadOne2.Application.DTOs.Projects;
using LeadOne2.Core.Entities;
using LeadOne2.Core.Interfaces;

namespace LeadOne2.Application.Services;

public class ProjectService
{
    private readonly IUnitOfWork _unitOfWork;

    public ProjectService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<IEnumerable<ProjectDto>> GetAllProjectsAsync()
    {
        var projects = await _unitOfWork.Projects.GetAllAsync();
        return projects.Select(p => new ProjectDto
        {
            Id = p.Id,
            Name = p.Name,
            Description = p.Description,
            IsActive = p.IsActive,
            CreatedAt = p.CreatedAt
        });
    }

    public async Task<IEnumerable<ProjectDto>> GetUserProjectsAsync(int userId)
    {
        var userProjects = await _unitOfWork.UserProjects.FindAsync(
            up => up.UserId == userId && up.IsActive);

        var projectIds = userProjects.Select(up => up.ProjectId).ToList();
        var projects = await _unitOfWork.Projects.FindAsync(p => projectIds.Contains(p.Id));

        return projects.Select(p => new ProjectDto
        {
            Id = p.Id,
            Name = p.Name,
            Description = p.Description,
            IsActive = p.IsActive,
            CreatedAt = p.CreatedAt
        });
    }

    public async Task<ProjectDto?> GetProjectByIdAsync(int projectId)
    {
        var project = await _unitOfWork.Projects.GetByIdAsync(projectId);
        if (project == null)
        {
            return null;
        }

        return new ProjectDto
        {
            Id = project.Id,
            Name = project.Name,
            Description = project.Description,
            IsActive = project.IsActive,
            CreatedAt = project.CreatedAt
        };
    }

    public async Task<ProjectDto> CreateProjectAsync(CreateProjectRequest request)
    {
        var project = new Project
        {
            Name = request.Name,
            Description = request.Description,
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };

        await _unitOfWork.Projects.AddAsync(project);
        await _unitOfWork.SaveChangesAsync();

        return new ProjectDto
        {
            Id = project.Id,
            Name = project.Name,
            Description = project.Description,
            IsActive = project.IsActive,
            CreatedAt = project.CreatedAt
        };
    }

    public async Task<ProjectDto?> UpdateProjectAsync(int projectId, UpdateProjectRequest request)
    {
        var project = await _unitOfWork.Projects.GetByIdAsync(projectId);
        if (project == null)
        {
            return null;
        }

        project.Name = request.Name;
        project.Description = request.Description;
        project.IsActive = request.IsActive;
        project.UpdatedAt = DateTime.UtcNow;

        await _unitOfWork.Projects.UpdateAsync(project);
        await _unitOfWork.SaveChangesAsync();

        return new ProjectDto
        {
            Id = project.Id,
            Name = project.Name,
            Description = project.Description,
            IsActive = project.IsActive,
            CreatedAt = project.CreatedAt
        };
    }

    public async Task<bool> AssignUserToProjectAsync(int userId, int projectId)
    {
        var userExists = await _unitOfWork.Users.ExistsAsync(u => u.Id == userId);
        var projectExists = await _unitOfWork.Projects.ExistsAsync(p => p.Id == projectId);

        if (!userExists || !projectExists)
        {
            return false;
        }

        var existing = await _unitOfWork.UserProjects.FindAsync(
            up => up.UserId == userId && up.ProjectId == projectId);

        if (existing.Any())
        {
            return false; // Already assigned
        }

        var userProject = new UserProject
        {
            UserId = userId,
            ProjectId = projectId,
            AssignedAt = DateTime.UtcNow,
            IsActive = true
        };

        await _unitOfWork.UserProjects.AddAsync(userProject);
        await _unitOfWork.SaveChangesAsync();

        return true;
    }

    public async Task<bool> RemoveUserFromProjectAsync(int userId, int projectId)
    {
        var userProjects = await _unitOfWork.UserProjects.FindAsync(
            up => up.UserId == userId && up.ProjectId == projectId);

        var userProject = userProjects.FirstOrDefault();
        if (userProject == null)
        {
            return false;
        }

        userProject.IsActive = false;
        await _unitOfWork.UserProjects.UpdateAsync(userProject);
        await _unitOfWork.SaveChangesAsync();

        return true;
    }
}
