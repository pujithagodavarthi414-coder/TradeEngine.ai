using AuthenticationServices.Models;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net.Http.Headers;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.AspNetCore.Http;
using System.Configuration;
using System.Net.Http;
using IdentityModel.Client;
using AuthenticationServices.Repositories.Repositories.UserAuthTokenRepository;
using AuthenticationServices.Repositories.Models;

namespace AuthenticationServices.Api.Helpers
{
    public class UserAuthorizationDetails
    {
        IConfiguration _iconfiguration;
        private readonly UserAuthTokenRepository _userAuthTokenRepository;
        public UserAuthorizationDetails(IConfiguration iconfiguration, UserAuthTokenRepository userAuthTokenRepository)
        {
            _iconfiguration = iconfiguration;
            _userAuthTokenRepository = userAuthTokenRepository;
        }

        public ValidUserOutputmodel AuthorisedUserDetails(HttpRequest Request)
        {
            var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
            var tokenHandler = new JwtSecurityTokenHandler();

            var jsonToken = tokenHandler.ReadToken(authHeader.Parameter);

            var tokenS = jsonToken as JwtSecurityToken;

            var jti1 = tokenS.Claims.First(claim => claim.Type == "client_id").Value;
            var jti2 = tokenS.Claims.First(claim => claim.Type == "scope").Value;

            ValidUserOutputmodel user = new ValidUserOutputmodel();

            var ids = jti1.Split(" ");

            foreach (var id in ids)
            {
                if (id == jti2)
                {
                    user.CompanyId = new Guid(id);
                }
                else
                {
                    user.Id = new Guid(id);
                }
            }

            DateTime date = new DateTime(tokenS.ValidTo.Year, tokenS.ValidTo.Month, tokenS.ValidTo.Day, tokenS.ValidTo.Hour, tokenS.ValidTo.Minute, tokenS.ValidTo.Second);

            //if (date < DateTime.UtcNow)
            //{
            //    var isAllowSupportLogin = ConfigurationManager.AppSettings["IsLoginAllowWithSupport"];
                
            //    UserModel userDetailsModel = new UserModel
            //    {
            //        Id = user.Id,
            //        CompanyId = user.CompanyId,
            //        ClientId = jti1,
            //        Scope = jti2
            //    };
            //}
            return user;
        }

        public async Task<string> RefreshAuthTokenGeneratorAsync(UserModel userDetailsModel)
        {
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
    }
}
