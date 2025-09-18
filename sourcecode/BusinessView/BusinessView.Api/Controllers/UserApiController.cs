using BusinessView.Common;
using BusinessView.DAL;
using BusinessView.Models;
using System;
using System.Linq;
using System.Web.Http;

namespace BusinessView.Api.Controllers
{
    public class UserApiController : ApiController
    {
        private readonly BViewEntities _entities = new BViewEntities();

        private static string _password = string.Empty;

        private string _errorMessage = string.Empty;

        public UserDto GetRegistrationEntity(string userName, string password)
        {
            try
            {
                LoggingManager.Debug("Entered into get user entity.");

                if (!string.IsNullOrEmpty(userName) && !string.IsNullOrEmpty(password))
                {
                    LoggingManager.Debug("Trying to get the user entity from db.");

                    var returnedRegistrationEntity = _entities.Users.FirstOrDefault(registrationEntity => registrationEntity.UserName.ToUpper() == userName.ToUpper());

                    LoggingManager.Debug("Got the db" + returnedRegistrationEntity);

                    var localLoginLoggedInSuccessful = returnedRegistrationEntity != null && AppUtilities.VerifyPassword(returnedRegistrationEntity.Password, password);

                    if (!localLoginLoggedInSuccessful)
                    {
                        _errorMessage = returnedRegistrationEntity == null ? "Sorry, we can not find this email / user name in our database." : "Wrong password. Try again.";

                        return new UserDto
                        {
                            UserName = _errorMessage
                        };
                    }

                    _password = password;

                    var regiserUserData = ConvertRegistrationEntityToDto(returnedRegistrationEntity);

                    return regiserUserData;
                }

                return null;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }

        private static UserDto ConvertRegistrationEntityToDto(User registrationEntity)
        {
            if (registrationEntity == null)
            {
                return null;
            }

            return new UserDto
            {
                Id = registrationEntity.Id,
                RoleId = Convert.ToInt32(registrationEntity.RoleId),
                UserName = registrationEntity.UserName,
                Password = _password,
                Name = registrationEntity.Name,
                IsActive = Convert.ToBoolean(registrationEntity.IsActive)
            };
        }
    }
}
