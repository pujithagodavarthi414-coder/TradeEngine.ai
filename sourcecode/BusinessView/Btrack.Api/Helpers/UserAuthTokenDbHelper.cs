using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Models;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Dapper.Dal.SpModels;
using Btrak.Models;
using Btrak.Services.Account;
using BTrak.Common;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace BTrak.Api.Helpers
{
    public class UserAuthTokenDbHelper
    {
        private readonly UserAuthTokenFactory _userAuthTokenFactory = new UserAuthTokenFactory();
        private readonly UserAuthTokenRepository _userAuthTokenRepository = new UserAuthTokenRepository();
        private readonly UserRepository _userRepository = new UserRepository();
        private string _apiBasePath;

        public UserAuthTokenDbHelper()
        {
            _apiBasePath = ConfigurationManager.AppSettings["ApiBasePath"];
        }

        public UserAuthToken GetAuthToken(Guid? userId)
        {
            var userAuthToken = _userAuthTokenRepository.GetUserAuthTokenReadItem(userId);
            if (userAuthToken == null)
            {
                return null;
            }

            return ConvertToUserAuthTokenEntity(userAuthToken);
        }


        public bool HasUserAuthorized(System.Web.Http.Controllers.HttpActionContext actionContext, Guid roleId)
        {
            bool byPassApiAuthorization;

            if (bool.TryParse(ConfigurationManager.AppSettings["ByPassApiAuthorization"], out byPassApiAuthorization))
            {
                if (byPassApiAuthorization)
                {
                    return true;
                }
            }
            var absoluteRootPath = actionContext.Request.RequestUri.AbsolutePath.Trim();

            var splitArray = absoluteRootPath.Split('/');
            string rootPath = string.Empty;
            if (splitArray.Length > 2)
            {
                rootPath = splitArray[1] + "/" + splitArray[2] + "/" + splitArray[3];
            }

            if (splitArray.Length > 4)
            {
                rootPath += "/" + splitArray[4];
            }

            rootPath = rootPath.Replace(_apiBasePath, string.Empty);

            var result = _userAuthTokenRepository.EnsureUserCanHaveAccess(roleId, rootPath);

            var hasAuthorizedFailed = result;

            return hasAuthorizedFailed;
        }

        public void InsertAuthToken(UserAuthToken authToken)
        {
            var existingRecord = this.GetAuthToken(authToken.UserId);

            if (existingRecord == null)
            {
                var userAuthTokenDbEntity = new UserAuthTokenDbEntity
                {
                    Id = Guid.NewGuid(),
                    UserId = authToken.UserId,
                    CompanyId = authToken.CompanyId,
                    UserName = authToken.UserName,
                    DateCreated = authToken.DateCreated,
                    AuthToken = authToken.AuthToken
                };
                _userAuthTokenRepository.Insert(userAuthTokenDbEntity);
            }
            else
            {
                existingRecord.AuthToken = authToken.AuthToken;
                existingRecord.DateCreated = authToken.DateCreated;
                var userAuthTokenDbEntity = new UserAuthTokenDbEntity
                {
                    Id = existingRecord.Id,
                    UserId = existingRecord.UserId,
                    CompanyId = existingRecord.CompanyId,
                    UserName = existingRecord.UserName,
                    DateCreated = existingRecord.DateCreated,
                    AuthToken = existingRecord.AuthToken
                };
                _userAuthTokenRepository.Update(userAuthTokenDbEntity);
            }
        }

        public void DeleteAuthToken(Guid userId)
        {
            var existingRecord = this.GetAuthToken(userId);

            if (existingRecord != null)
            {
                _userAuthTokenRepository.Delete(userId);
            }
        }

        public ValidUserOutputmodel IsTokenValid(UserAuthToken authToken, string actionPath)
        {
            var lookupRecord = this.GetAuthToken(authToken.UserId);

            var result = _userAuthTokenRepository.ValidateAuthTokenAndActionPath(authToken.UserId, actionPath, authToken.AuthToken);

            // If we find a record in DB
            if (lookupRecord != null && authToken.AuthToken == lookupRecord.AuthToken)
            {
                return result;
            }

            // No record found in the DB - so return false
            return null;
        }

        public ValidUserOutputmodel GetRootPathAccess(string authToken, string actionPath)
        {
            //var lookupRecord = this.GetAuthToken(authToken.UserId);

            var result = _userAuthTokenRepository.ValidateAuthTokenAndActionPath(Guid.Empty, actionPath, authToken);

            // If we find a record in DB
            //if (lookupRecord != null && authToken.AuthToken == lookupRecord.AuthToken)
            //{
                return result;
            //}

            // No record found in the DB - so return false
            //return null;
        }

        public bool IsApiKeyValid(string apiKey)
        {
            return _userAuthTokenRepository.ValidateApiKey(apiKey);
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

        public string GetUserAuthToken(string userName, string password)
        {
            UserModel userModel = new UserModel();
            if (string.IsNullOrEmpty(password))
            {
                userModel = new BackOfficeService().GetByUserDetails(userName);
            }
            else
            {
                userModel = new BackOfficeService().GetByUsername(userName, password);
            }
            if (userModel.Id != null)
            {
                var hasAuthToken = new UserAuthTokenDbHelper().GetAuthToken(userModel.Id.Value);
                if (hasAuthToken != null)
                {
                    return hasAuthToken.AuthToken;
                }
            }
            else
            {
                throw new Exception("Unexpected exception");
            }

            UserAuthToken userAuthToken = new UserAuthToken
            {
                UserId = userModel.Id.Value,
                UserName = userModel.UserName,
                CompanyId = userModel.CompanyId
            };

            UserAuthToken generateUserAuthToken = new UserAuthTokenDbHelper().GenerateAuth(userAuthToken);
            return generateUserAuthToken.AuthToken;

            //UserAuthToken generateUserAuthToken = _userAuthTokenFactory.GenerateUserAuthToken(userAuthToken);
            //new UserAuthTokenDbHelper().InsertAuthToken(generateUserAuthToken);
            //return generateUserAuthToken.AuthToken;
        }

        public string GetUserAuthTokenFromMobileNumber(string mobileNumber)
        {
            UserModel userModel = new UserModel();

            userModel = new BackOfficeService().GetByMobileNumber(mobileNumber);

            if (userModel.Id != null)
            {
                var hasAuthToken = new UserAuthTokenDbHelper().GetAuthToken(userModel.Id.Value);
                if (hasAuthToken != null)
                {
                    return hasAuthToken.AuthToken;
                }
            }
            else
            {
                throw new Exception("Unexpected exception");
            }

            UserAuthToken userAuthToken = new UserAuthToken
            {
                UserId = userModel.Id.Value,
                UserName = userModel.UserName,
                CompanyId = userModel.CompanyId
            };

            UserAuthToken generateUserAuthToken = new UserAuthTokenDbHelper().GenerateAuth(userAuthToken);
            return generateUserAuthToken.AuthToken;

            //UserAuthToken generateUserAuthToken = _userAuthTokenFactory.GenerateUserAuthToken(userAuthToken);
            //new UserAuthTokenDbHelper().InsertAuthToken(generateUserAuthToken);
            //return generateUserAuthToken.AuthToken;
        }

        public UserAuthToken GenerateAuth(UserAuthToken userAuthToken)
        {
            UserAuthToken generateUserAuthToken = _userAuthTokenFactory.GenerateUserAuthToken(userAuthToken);
            new UserAuthTokenDbHelper().InsertAuthToken(generateUserAuthToken);
            return generateUserAuthToken;
        }

        public Guid GetUserByUserAuthenticationIdAndCompanyId(Guid? userAuthenticationId, LoggedInContext loggedInContext)
        {
            return _userRepository.GetUserByUserAuthenticationIdAndCompanyId(userAuthenticationId, loggedInContext, new List<ValidationMessage>());
        }

        public async Task<ValidUserOutputmodel> ValidateClientRequest(string auth, string actionPath)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    var input = new
                    {
                        RootPath = actionPath,
                        AuthToken = auth
                    };

                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["AuthenticationServiceBasePath"]);
                    client.DefaultRequestHeaders.Add("Authorization", $"Bearer {input.AuthToken}");
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(input), Encoding.UTF8, "application/json");
                    var response = await client.PostAsync(RouteConstants.ASGetRootPathAccess, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string responseString = response.Content.ReadAsStringAsync().Result;
                        JObject result = JObject.Parse(responseString);
                        string data = result["data"].ToString();
                        var user = data != null ? JsonConvert.DeserializeObject<ValidUserOutputmodel>(data) : null;
                        LoggedInContext LoggedInContext = new LoggedInContext()
                        {
                            LoggedInUserId = user?.Id ?? Guid.Empty,
                            CompanyGuid = user?.CompanyId ?? Guid.Empty
                        };
                        var id = GetUserByUserAuthenticationIdAndCompanyId(user.UserAuthenticationId, LoggedInContext);
                        user.Id = id;
                        return user;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}