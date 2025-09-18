using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using PDFHTMLDesignerModels;
using PDFHTMLDesignerModels.ValidUserOutputmodel;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net.Http.Headers;

namespace AuthenticationServices.Api.Helpers
{
    public class UserAuthorizationDetails
    {
        IConfiguration _iconfiguration;
        public UserAuthorizationDetails (IConfiguration iconfiguration)
        {
            _iconfiguration = iconfiguration;
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
            user.Authorization = authHeader.Parameter;

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
    }
}