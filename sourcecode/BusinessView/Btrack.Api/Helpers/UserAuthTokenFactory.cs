using System;
using System.Collections.Generic;
//using System.IdentityModel.Protocols.WSTrust;
using System.IdentityModel.Tokens;
using System.Linq;
using System.Security.Claims;
using System.Text;
using Btrak.Models;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;

namespace BTrak.Api.Helpers
{
    public class UserAuthTokenFactory
    {
        private readonly UserAuthTokenSecret _userAuthTokenSecret = new UserAuthTokenSecret();

        /// <summary>
        /// Generates the user authentication token.
        /// </summary>
        /// <param name="authToken">The authentication token.</param>
        /// <returns>User Auth Token</returns>
        public UserAuthToken GenerateUserAuthToken(UserAuthToken authToken)
        {
            string secretKey = _userAuthTokenSecret.GetSecret();

            var signingKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
            var signingCredentials = new SigningCredentials(signingKey,
                SecurityAlgorithms.HmacSha256Signature, SecurityAlgorithms.Sha256Digest);

            var claimsIdentity = new ClaimsIdentity(new List<Claim>()
            {
                new Claim(ClaimTypes.NameIdentifier, authToken.UserId.ToString()),
                new Claim("Company", authToken.CompanyId.ToString()),
            }, "Custom");

            var securityTokenDescriptor = new SecurityTokenDescriptor()
            {
                //AppliesToAddress = "http://my.website.com",
                //TokenIssuerName = "http://my.tokenissuer.com",
                
                Subject = claimsIdentity,
                SigningCredentials = signingCredentials,
                Expires = DateTime.UtcNow.AddDays(5000),

            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var plainToken = tokenHandler.CreateToken(securityTokenDescriptor);
            var signedAndEncodedToken = tokenHandler.WriteToken(plainToken);
            
            // Date Time
            var dateCreated = DateTime.UtcNow;

            // Return same object we passed in (Now with Date Created & Token properties updated)
            authToken.DateCreated = dateCreated;
            authToken.AuthToken = signedAndEncodedToken;
            

            // Return the updated object
            return authToken;
        }

        /// <summary>
        /// Decodes the user authentication token.
        /// </summary>
        /// <param name="jwtToken">The JWT token.</param>
        /// <returns>User Auth Token</returns>
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