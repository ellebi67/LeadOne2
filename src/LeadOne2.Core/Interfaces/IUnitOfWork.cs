using LeadOne2.Core.Entities;

namespace LeadOne2.Core.Interfaces;

public interface IUnitOfWork : IDisposable
{
    IRepository<User> Users { get; }
    IRepository<Project> Projects { get; }
    IRepository<UserProject> UserProjects { get; }
    Task<int> SaveChangesAsync();
}
