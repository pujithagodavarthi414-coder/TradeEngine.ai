using AuthenticationServices.Repositories.Repositories.UserAuthTokenRepository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AuthenticationServices.Models;
using AuthenticationServices.Repositories.SpModels;
using Microsoft.Extensions.Configuration;

namespace AuthenticationServices.Api.Helpers
{
    public class UserAuthTokenDbHelper
    {
        IConfiguration _iconfiguration;
        private readonly UserAuthTokenRepository _userAuthTokenRepository;
        private string _apiBasePath;
        public UserAuthTokenDbHelper(UserAuthTokenRepository userAuthTokenRepository)
        {
            _userAuthTokenRepository = userAuthTokenRepository;
        }

        public UserAuthToken GetAuthToken(Guid? userId, Guid? companyId)
        {
            var userAuthToken = _userAuthTokenRepository.GetUserAuthTokenReadItem(userId, companyId);
            if (userAuthToken == null)
            {
                return null;
            }

            return ConvertToUserAuthTokenEntity(userAuthToken);
        }

        public bool IsApiKeyValid(string apiKey)
        {
            return _userAuthTokenRepository.ValidateApiKey(apiKey);
        }

        public ValidUserOutputmodel IsTokenValid(UserAuthToken authToken, string actionPath)
        {
            var lookupRecord = this.GetAuthToken(authToken.UserId, authToken.CompanyId);

            var result = _userAuthTokenRepository.ValidateAuthTokenAndActionPath(authToken.UserId, authToken.CompanyId, actionPath, authToken.AuthToken);

            // If we find a record in DB
            if (lookupRecord != null && authToken.AuthToken == lookupRecord.AuthToken)
            {
                //return new ValidUserOutputmodel
                //{
                //    CompanyId = authToken.CompanyId,
                //    Id = authToken.UserId,
                //    Email = authToken.UserName,
                //    UserAuthenticationId = authToken.UserId
                //};
                if (result != null)
                {
                    result.UserAuthenticationId = result.Id;
                    return result;
                }
                return null;
            }

            // No record found in the DB - so return false
            return null;
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
