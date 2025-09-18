using System;
using System.Configuration;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Repositories.Models;
using AuthenticationServices.Repositories.Repositories.UserAuthTokenRepository;
using AuthenticationServices.Repositories.Repositories.UserManagement;
using AuthenticationServices.Repositories.SpModels;
using IdentityModel.Client;
using Microsoft.Extensions.Configuration;

namespace AuthenticationServices.Services.Account
{
    public class BackOfficeService
    {
        IConfiguration _iconfiguration;
        private readonly IUserManagementRepository _userRepository;
        private readonly UserAuthTokenRepository _userAuthTokenRepository;

        public BackOfficeService(IUserManagementRepository userManagementRepository, IConfiguration iconfiguration, UserAuthTokenRepository userAuthTokenRepository)
        {
            _iconfiguration = iconfiguration;
            _userAuthTokenRepository = userAuthTokenRepository;
            _userRepository = userManagementRepository;
        }
        public bool ValidateBackOfficeCredentials(string userName, string password, string url)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue,"ValidateBackOfficeCredentials", "BackOfficeService"));
            var isAllowLogin = _iconfiguration["IsLoginAllowWithSupport"];

            var userDetailsList = CanByPassUserCompanyValidation() ? _userRepository.GetUserDetailsByName(userName, isAllowLogin) : _userRepository.GetUserDetailsByNameAndSiteAddress(userName, url, isAllowLogin);
           
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "User Details Count", userDetailsList.Count));

            var validAccountDetailsCount = 0;

            foreach (var user in userDetailsList)
            {
                if (user != null)
                {
                    if (user.IsActive)
                    {
                        var validUser = Utilities.VerifyPassword(user.Password, password);
                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Password check", validUser));

                        if (validUser)
                        {
                            validAccountDetailsCount = validAccountDetailsCount + 1;
                        }
                        if (validAccountDetailsCount > 0)
                            break;

                    }
                }
            }
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ValidateBackOfficeCredentials", "BackOfficeService"));
            if (validAccountDetailsCount > 0)
                return true;
            else
                return false;
        }

        public bool ValidateBackOfficeCredentials(string userName, string url)
        {
            var isAllowSupportLogin = _iconfiguration["IsLoginAllowWithSupport"];
            var user = CanByPassUserCompanyValidation() ? _userRepository.GetUserDetailsByName(userName, isAllowSupportLogin) : _userRepository.GetUserDetailsByNameAndSiteAddress(userName, url, isAllowSupportLogin);

            if (user != null)
            {
                return true;
            }
            return false;
        }

        public async Task<UserAccessToken> GetUserAuthTokenAsync(string userName, string password, string url)
        {
            LoggingManager.Info("Generating User Auth Token for Email = " + userName);
            UserModel userModel = new UserModel();
            if (string.IsNullOrEmpty(password))
            {
                userModel = this.GetByUserDetails(userName, url);
            }
            else
            {
                userModel = this.GetByUsername(userName, password, url);
            }
            if (userModel.Id != null)
            {
                LoggingManager.Info("Generating User Auth Token for Email = " + userName + " User details retrived = " + userModel.ToString());
                UserAccessToken userAccessToken = new UserAccessToken();
                userAccessToken.UserId = new Guid(userModel.Id.ToString());
                userAccessToken.CompanyId = userModel.CompanyId;
                

                var userAuthToken = _userAuthTokenRepository.GetUserAuthTokenReadItem(userModel.Id, userModel.CompanyId);
                //if (userAuthToken == null)
                //{
                //    return null;
                //}

                var hasAuthToken = (userAuthToken == null || userAuthToken.AuthToken == null) ? null : ConvertToUserAuthTokenEntity(userAuthToken);

                if (hasAuthToken != null)
                {
                    LoggingManager.Info("Generating User Auth Token for Email = " + userName + " token already exists");
                    userAccessToken.AccessToken = hasAuthToken.AuthToken;
                    return userAccessToken;
                }
                else
                {
                    LoggingManager.Info("Generating User Auth Token for Email = " + userName + " generating");
                    var client = new HttpClient();
                    ServicePointManager.ServerCertificateValidationCallback += (sender, certificate, chain, sslPolicyErrors) => true;
                    var disco = await client.GetDiscoveryDocumentAsync(new DiscoveryDocumentRequest
                    {
                        Address = _iconfiguration["IdentityServerUrl"],
                        Policy =
                        {
                            RequireHttps = false
                        }
                    });
                    //await client.GetDiscoveryDocumentAsync(_iconfiguration["IdentityServerUrl"]);
                    LoggingManager.Info("Generating User Auth Token Error occured , Error = " + disco.Error + "\n Error message = " + disco.ErrorType);
                    var tokenResponse = await client.RequestClientCredentialsTokenAsync(
                        new ClientCredentialsTokenRequest
                        {
                            Address = disco.TokenEndpoint,
                            ClientId = userModel.ClientId,
                            ClientSecret = "SuperSecretPassword",
                            Scope = userModel.Scope
                        });

                    //var tokenHandler = new JwtSecurityTokenHandler();

                    //var jsonToken = tokenHandler.ReadToken(tokenResponse.AccessToken);

                    //var tokenS = jsonToken as JwtSecurityToken;

                    userAccessToken.AccessToken = tokenResponse.AccessToken;
                    LoggingManager.Info("Generating User Auth Token for Email = " + userName + " generating completed");

                    var userAuthTokenDbEntity = new UserAuthTokenDbEntity
                    {
                        Id = Guid.NewGuid(),
                        UserId = userModel.Id,
                        CompanyId = userModel.CompanyId,
                        UserName = userModel.UserName,
                        DateCreated = DateTime.UtcNow,
                        AuthToken = tokenResponse.AccessToken
                    };

                    _userAuthTokenRepository.Insert(userAuthTokenDbEntity);
                    LoggingManager.Info("Generated User Auth Token for Email = " + userName + "returning");
                    return userAccessToken;
                }
            }
            else
            {
                throw new Exception("Unexpected exception");
            }
        }

        public async Task<string> AuthTokenGeneratorAsync(UserModel userModel)
        {
            var isAllowSupportLogin = _iconfiguration["IsLoginAllowWithSupport"];
            var userDetails = _userRepository.GetUserDetailsByUserIdAndCompanyId(new Guid(userModel.Id.ToString()), userModel.CompanyId, isAllowSupportLogin);

            UserModel userDetailsModel = new UserModel
            {
                Id = userDetails.Id,
                Name = userDetails.FirstName + ' ' + userDetails.SurName,
                UserName = userDetails.UserName,
                CompanyId = userDetails.CompanyId,
                IsAdmin = userDetails.IsAdmin ?? false,
                MobileNo = userDetails.MobileNo,
                ClientId = userDetails.ClientId,
                Scope = userDetails.Scope
            };


            var userAuthToken = _userAuthTokenRepository.GetUserAuthTokenReadItem(userModel.Id, userModel.CompanyId);

            var hasAuthToken = (userAuthToken == null || userAuthToken.AuthToken == null) ? null : ConvertToUserAuthTokenEntity(userAuthToken);

            if (hasAuthToken != null)
            {
                if (hasAuthToken.AuthToken != null)
                {
                    return hasAuthToken.AuthToken;
                }
            }

            var client = new HttpClient();
            var disco = await client.GetDiscoveryDocumentAsync(_iconfiguration["IdentityServerUrl"]);
            var tokenResponse = await client.RequestClientCredentialsTokenAsync(new ClientCredentialsTokenRequest
            {
                Address = disco.TokenEndpoint,
                ClientId = userDetailsModel.ClientId,
                ClientSecret = "SuperSecretPassword",
                Scope = userDetailsModel.Scope
            });

            var userAuthTokenDbEntity = new UserAuthTokenDbEntity
            {
                Id = Guid.NewGuid(),
                UserId = userModel.Id,
                CompanyId = userModel.CompanyId,
                UserName = userModel.UserName,
                DateCreated = DateTime.UtcNow,
                AuthToken = tokenResponse.AccessToken
            };

            _userAuthTokenRepository.Insert(userAuthTokenDbEntity);

            return tokenResponse.AccessToken;
        }

        public async Task<string> RefreshAuthTokenGeneratorAsync(UserModel userModel)
        {
            var isAllowSupportLogin = _iconfiguration["IsLoginAllowWithSupport"];
            var userDetails = _userRepository.GetUserDetailsByUserIdAndCompanyId(new Guid(userModel.Id.ToString()), userModel.CompanyId, isAllowSupportLogin);

            UserModel userDetailsModel = new UserModel
            {
                Id = userDetails.Id,
                Name = userDetails.FirstName + ' ' + userDetails.SurName,
                UserName = userDetails.UserName,
                CompanyId = userDetails.CompanyId,
                IsAdmin = userDetails.IsAdmin ?? false,
                MobileNo = userDetails.MobileNo,
                ClientId = userDetails.ClientId,
                Scope = userDetails.Scope
            };

            var client = new HttpClient();
            var disco = await client.GetDiscoveryDocumentAsync(_iconfiguration["IdentityServerUrl"]);
            var tokenResponse = await client.RequestClientCredentialsTokenAsync(new ClientCredentialsTokenRequest
            {
                Address = disco.TokenEndpoint,
                ClientId = userDetailsModel.ClientId,
                ClientSecret = "SuperSecretPassword",
                Scope = userDetailsModel.Scope
            });

            var userAuthTokenDbEntity = new UserAuthTokenDbEntity
            {
                Id = Guid.NewGuid(),
                UserId = userDetailsModel.Id,
                CompanyId = userDetailsModel.CompanyId,
                UserName = userDetailsModel.UserName,
                DateCreated = DateTime.UtcNow,
                AuthToken = tokenResponse.AccessToken
            };

            _userAuthTokenRepository.UpdateAuthToken(userAuthTokenDbEntity);

            return tokenResponse.AccessToken;
        }

        public UserModel GetByUsername(string userName, string password, string url)
        {
            var isAllowSupportLogin = _iconfiguration["IsLoginAllowWithSupport"];
            var userDetailsList = CanByPassUserCompanyValidation() ? _userRepository.GetUserDetailsByName(userName, isAllowSupportLogin) : _userRepository.GetUserDetailsByNameAndSiteAddress(userName, url, isAllowSupportLogin);
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
                MobileNo = userDetails.MobileNo,
                ClientId = userDetails.ClientId,
                Scope = userDetails.Scope
            };
            return userModel;
        }

        public string GetUserAuthToken(Guid CompanyId, Guid UserId)
        {
           var authToken = _userAuthTokenRepository.GetUserAuthTokenReadItem(UserId,CompanyId)?.AuthToken;
            
            return authToken;
        }


        public UserModel GetByUserDetails(string userName, string url)
        {
            var isAllowSupportLogin = _iconfiguration["IsLoginAllowWithSupport"];
            var userDetailsList = CanByPassUserCompanyValidation() ? _userRepository.GetUserDetailsByName(userName, isAllowSupportLogin) : _userRepository.GetUserDetailsByNameAndSiteAddress(userName, url, isAllowSupportLogin);
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
            string environmentName = _iconfiguration["EnvironmentName"];

            if (!string.IsNullOrWhiteSpace(environmentName) && environmentName == "Production")
            {
                return false;
            }

            return true;
        }

        private UserAuthToken ConvertToUserAuthTokenEntity(UserAuthTokenSpEntity userAuthToken)
        {
            return new UserAuthToken
            {
                AuthToken = userAuthToken.AuthToken,
                DateCreated = userAuthToken.DateCreated,
                Id = userAuthToken.Id,
                UserId = userAuthToken.UserId,
                UserName = userAuthToken.UserName,
            };
        }
    }
}
