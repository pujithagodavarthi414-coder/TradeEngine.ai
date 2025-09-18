using System.Configuration;
using System.Linq;
using System.Web;
using Btrak.Dapper.Dal.Models;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using BTrak.Common;

namespace Btrak.Services.Account
{
    public class BackOfficeService
    {
        private readonly UserRepository _userRepository = new UserRepository();

        public bool ValidateBackOfficeCredentials(string userName, string password)
        {
            var isAllowLogin = ConfigurationManager.AppSettings["IsLoginAllowWithSupport"];
            var userDetailsList = CanByPassUserCompanyValidation() ? _userRepository.GetUserDetailsByName(userName, isAllowLogin) : _userRepository.GetUserDetailsByNameAndSiteAddress(userName, HttpContext.Current.Request.Url.Authority, isAllowLogin);

            var userDetails = userDetailsList.FirstOrDefault();
            var validAccountDetailsCount = 0;

            foreach (var user in userDetailsList)
            {
                if (user != null)
                {
                    if (user.IsActive)
                    {
                        var validUser = Utilities.VerifyPassword(user.Password, password);

                        if (validUser)
                        {
                            validAccountDetailsCount = validAccountDetailsCount + 1;
                        }
                        if (validAccountDetailsCount > 0)
                            break;

                    }
                }
            }

            if (validAccountDetailsCount > 0)
                return true;
            else
                return false;
        }

        public bool ValidateBackOfficeCredentials(string userName)
        {
            var isAllowSupportLogin = ConfigurationManager.AppSettings["IsLoginAllowWithSupport"];
            var user = CanByPassUserCompanyValidation() ? _userRepository.GetUserDetailsByName(userName, isAllowSupportLogin) : _userRepository.GetUserDetailsByNameAndSiteAddress(userName, HttpContext.Current.Request.Url.Authority, isAllowSupportLogin);

            if (user != null)
            {
                return true;
            }
            return false;
        }

        public UserModel GetByUsername(string userName, string password)
        {
            var isAllowSupportLogin = ConfigurationManager.AppSettings["IsLoginAllowWithSupport"];
            var userDetailsList = CanByPassUserCompanyValidation() ? _userRepository.GetUserDetailsByName(userName, isAllowSupportLogin) : _userRepository.GetUserDetailsByNameAndSiteAddress(userName, HttpContext.Current.Request.Url.Authority, isAllowSupportLogin);
            var userDetails = new UserDbEntity();
            foreach (var user in userDetailsList)
            {
                if (user != null)
                {
                    if (user.IsActive)
                    {
                        var validUser = Utilities.VerifyPassword(user.Password, password);

                        if (validUser)
                        {
                            userDetails = user;
                            break;
                        }
                    }
                }
            }

            UserModel userModel = new UserModel
            {
                Id = userDetails.Id,
                Name = userDetails.FirstName + ' ' + userDetails.SurName,
                UserName = userDetails.UserName,
                CompanyId = userDetails.CompanyId,
                IsAdmin = userDetails.IsAdmin ?? false,
                MobileNo = userDetails.MobileNo
            };
            return userModel;
        }

        public UserModel GetByUserDetails(string userName)
        {
            var isAllowSupportLogin = ConfigurationManager.AppSettings["IsLoginAllowWithSupport"];
            var userDetailsList = CanByPassUserCompanyValidation() ? _userRepository.GetUserDetailsByName(userName, isAllowSupportLogin) : _userRepository.GetUserDetailsByNameAndSiteAddress(userName, HttpContext.Current.Request.Url.Authority, isAllowSupportLogin);
            var userDetails = new UserDbEntity();
            foreach (var user in userDetailsList)
            {
                if (user != null)
                {
                    if (user.IsActive)
                    {
                        userDetails = user;
                        break;
                    }
                }
            }

            UserModel userModel = new UserModel
            {
                Id = userDetails.Id,
                Name = userDetails.FirstName + ' ' + userDetails.SurName,
                UserName = userDetails.UserName,
                CompanyId = userDetails.CompanyId,
                IsAdmin = userDetails.IsAdmin ?? false,
                MobileNo = userDetails.MobileNo
            };
            return userModel;
        }

        private bool CanByPassUserCompanyValidation()
        {
            if (!ConfigurationManager.AppSettings.AllKeys.Contains("EnvironmentName"))
            {
                return true;
            }

            return ConfigurationManager.AppSettings["EnvironmentName"] != "Production";
        }

        public bool ValidateBackOfficeCredentialsWithMobile(string mobileNumber)
        {
            var isAllowLogin = ConfigurationManager.AppSettings["IsLoginAllowWithSupport"];
            var userDetailsList = CanByPassUserCompanyValidation() ? _userRepository.GetLogInUserDetailsByMobileNumber(mobileNumber, isAllowLogin) : _userRepository.GetUserDetailsByMobileAndSiteAddress(mobileNumber, HttpContext.Current.Request.Url.Authority, isAllowLogin);

            var userDetails = userDetailsList.FirstOrDefault();
            var validAccountDetailsCount = 0;

            foreach (var user in userDetailsList)
            {
                if (user != null)
                {
                    if (user.IsActive)
                    {

                        validAccountDetailsCount = validAccountDetailsCount + 1;
                        if (validAccountDetailsCount > 0)
                            break;

                    }
                }
            }

            if (validAccountDetailsCount > 0)
                return true;
            else
                return false;
        }

        public UserModel GetByMobileNumber(string mobileNumber)
        {
            var isAllowSupportLogin = ConfigurationManager.AppSettings["IsLoginAllowWithSupport"];
            var userDetailsList = CanByPassUserCompanyValidation() ? _userRepository.GetLogInUserDetailsByMobileNumber(mobileNumber, isAllowSupportLogin) : _userRepository.GetUserDetailsByMobileAndSiteAddress(mobileNumber, HttpContext.Current.Request.Url.Authority, isAllowSupportLogin);
            var userDetails = new UserDbEntity();
            foreach (var user in userDetailsList)
            {
                if (user != null)
                {
                    if (user.IsActive)
                    {
                        userDetails = user;
                        break;
                    }
                }
            }

            UserModel userModel = new UserModel
            {
                Id = userDetails.Id,
                Name = userDetails.FirstName + ' ' + userDetails.SurName,
                UserName = userDetails.UserName,
                CompanyId = userDetails.CompanyId,
                IsAdmin = userDetails.IsAdmin ?? false,
                MobileNo = userDetails.MobileNo
            };
            return userModel;
        }
    }
}
