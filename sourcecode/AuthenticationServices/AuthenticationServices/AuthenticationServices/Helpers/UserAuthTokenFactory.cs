using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AuthenticationServices.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace AuthenticationServices.Api.Helpers
{
    public class UserAuthTokenFactory
    {
        private readonly UserAuthTokenSecret _userAuthTokenSecret = new UserAuthTokenSecret();

        public UserAuthToken DecodeUserAuthToken(string jwtToken)
        {
            string secretKey = _userAuthTokenSecret.GetSecret();

            var signingKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));

            var tokenHandler = new JwtSecurityTokenHandler();

            var tokenValidationParameters = new TokenValidationParameters()
            {
                //ValidAudiences = new string[]
                //{
                //    "http://my.website.com",
                //    "http://my.otherwebsite.com"
                //},
                //ValidIssuers = new string[]
                //{
                //    "http://my.tokenissuer.com",
                //    "http://my.othertokenissuer.com"
                //},
                ValidateIssuer = false,
                ValidateAudience = false,
                IssuerSigningKey = signingKey
            };

            SecurityToken validatedToken;
            tokenHandler.ValidateToken(jwtToken, tokenValidationParameters, out validatedToken);

            // Object to return
            var userAuth = new UserAuthToken();

            // Just the presence of the token & being deserialised with correct SECRET key is a good sign
            var token = validatedToken as JwtSecurityToken;
            if (token != null)
            {
                // Do DateTime conversion from u type back into DateTime object
                // DateTime dateCreated;
                // DateTime.TryParseExact(jsonPayload["date_created"].ToString(), "u", null, DateTimeStyles.AdjustToUniversal, out dateCreated);

                // Get the details of the user from the JWT payload
                userAuth.UserId = new Guid(token.Claims.ToList().Where(x => x.Type == "nameid").Select(x => x.Value).First());
                userAuth.CompanyId = new Guid(token.Claims.ToList().Where(x => x.Type == "Company").Select(x => x.Value).First());
                userAuth.DateCreated = DateTime.Now;
                userAuth.AuthToken = jwtToken;
            }

            // Return the object
            return userAuth;
        }
    }
}
