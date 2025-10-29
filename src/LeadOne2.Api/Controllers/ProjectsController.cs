using LeadOne2.Application.DTOs.Projects;
using LeadOne2.Application.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LeadOne2.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ProjectsController : ControllerBase
{
    private readonly ProjectService _projectService;

    public ProjectsController(ProjectService projectService)
    {
        _projectService = projectService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAllProjects()
    {
        try
        {
            var projects = await _projectService.GetAllProjectsAsync();
            return Ok(projects);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Errore durante il recupero dei progetti", error = ex.Message });
        }
    }

    [HttpGet("my-projects")]
    public async Task<IActionResult> GetMyProjects()
    {
        try
        {
            var userIdClaim = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
            {
                return Unauthorized();
            }

            var userId = int.Parse(userIdClaim.Value);
            var projects = await _projectService.GetUserProjectsAsync(userId);
            return Ok(projects);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Errore durante il recupero dei progetti", error = ex.Message });
        }
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetProjectById(int id)
    {
        try
        {
            var project = await _projectService.GetProjectByIdAsync(id);
            if (project == null)
            {
                return NotFound(new { message = "Progetto non trovato" });
            }

            return Ok(project);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Errore durante il recupero del progetto", error = ex.Message });
        }
    }

    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> CreateProject([FromBody] CreateProjectRequest request)
    {
        try
        {
            var project = await _projectService.CreateProjectAsync(request);
            return CreatedAtAction(nameof(GetProjectById), new { id = project.Id }, project);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Errore durante la creazione del progetto", error = ex.Message });
        }
    }

    [HttpPut("{id}")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> UpdateProject(int id, [FromBody] UpdateProjectRequest request)
    {
        try
        {
            var project = await _projectService.UpdateProjectAsync(id, request);
            if (project == null)
            {
                return NotFound(new { message = "Progetto non trovato" });
            }

            return Ok(project);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Errore durante l'aggiornamento del progetto", error = ex.Message });
        }
    }

    [HttpPost("{projectId}/users/{userId}")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> AssignUserToProject(int projectId, int userId)
    {
        try
        {
            var success = await _projectService.AssignUserToProjectAsync(userId, projectId);
            if (!success)
            {
                return BadRequest(new { message = "Impossibile assegnare l'utente al progetto" });
            }

            return Ok(new { message = "Utente assegnato al progetto con successo" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Errore durante l'assegnazione", error = ex.Message });
        }
    }

    [HttpDelete("{projectId}/users/{userId}")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> RemoveUserFromProject(int projectId, int userId)
    {
        try
        {
            var success = await _projectService.RemoveUserFromProjectAsync(userId, projectId);
            if (!success)
            {
                return NotFound(new { message = "Assegnazione non trovata" });
            }

            return Ok(new { message = "Utente rimosso dal progetto con successo" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Errore durante la rimozione", error = ex.Message });
        }
    }
}
