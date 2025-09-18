using Microsoft.EntityFrameworkCore;

namespace IdentityServer
{
    public class IdentityContext : DbContext
    {
        public IdentityContext(DbContextOptions<IdentityContext> options)
            : base(options)
        {
        }
    }
}
