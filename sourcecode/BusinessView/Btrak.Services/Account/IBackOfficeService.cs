using Btrak.Models;

namespace Btrak.Services.Account
{
    public interface IBackOfficeService
    {
        bool ValidateBackOfficeCredentials(string userName, string password);
        UserModel GetByUsername(string userName);
    }
}
