using LeadOne2.Core.Entities;
using LeadOne2.Core.Interfaces;
using LeadOne2.Infrastructure.Data;

namespace LeadOne2.Infrastructure.Repositories;

public class UnitOfWork : IUnitOfWork
{
    private readonly ApplicationDbContext _context;
    private IRepository<User>? _users;
    private IRepository<Project>? _projects;
    private IRepository<UserProject>? _userProjects;

    public UnitOfWork(ApplicationDbContext context)
    {
        _context = context;
    }

    public IRepository<User> Users =>
        _users ??= new Repository<User>(_context);

    public IRepository<Project> Projects =>
        _projects ??= new Repository<Project>(_context);

    public IRepository<UserProject> UserProjects =>
        _userProjects ??= new Repository<UserProject>(_context);

    public async Task<int> SaveChangesAsync()
    {
        return await _context.SaveChangesAsync();
    }

    public void Dispose()
    {
        _context.Dispose();
    }
}
