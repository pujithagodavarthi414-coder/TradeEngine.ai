using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using AuthenticationServices.Models;
using AuthenticationServices.Repositories.Repositories.UserAuthTokenRepository;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace AuthenticationServices.Api.Helpers
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        private readonly IConfiguration _configuration;
        UserAuthTokenRepository _userAuthTokenRepository;
        UserAuthTokenDbHelper _userAuthTokenDbHelper;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public BasicAuthenticationHandler(
            IOptionsMonitor<AuthenticationSchemeOptions> options,
            ILoggerFactory logger,
            UrlEncoder encoder,
            ISystemClock clock,
            IConfiguration iconfiguration, UserAuthTokenRepository userAuthTokenRepository, UserAuthTokenDbHelper userAuthTokenDbHelper, IHttpContextAccessor httpContextAccessor)
            : base(options, logger, encoder, clock)
        {
            _configuration = iconfiguration;
            _userAuthTokenRepository = userAuthTokenRepository;
            _userAuthTokenDbHelper = userAuthTokenDbHelper;
            _httpContextAccessor = httpContextAccessor;
        }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
                return AuthenticateResult.Fail("Missing Authorization Header");

            try
            {
                var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
                //var tokenHandler = new JwtSecurityTokenHandler();

                //var jsonToken = tokenHandler.ReadToken(authHeader.Parameter);

                //var tokenS = jsonToken as JwtSecurityToken;

                //var jti1 = tokenS.Claims.First(claim => claim.Type == "client_id").Value;
                //var jti2 = tokenS.Claims.First(claim => claim.Type == "scope").Value;

                //ValidUserOutputmodel user = new ValidUserOutputmodel();

                //var ids = jti1.Split(" ");

                //foreach (var id in ids)
                //{
                //    if (id == jti2)
                //    {
                //        user.CompanyId = new Guid(id);
                //    }
                //    else
                //    {
                //        user.Id = new Guid(id);
                //    }
                //}
                var user = new UserAuthorizationDetails(_configuration, _userAuthTokenRepository).AuthorisedUserDetails(Request);

                var userAuthToken = _userAuthTokenRepository.GetUserAuthTokenReadItem(user.Id, user.CompanyId);

                UserAuthToken userAuth = new UserAuthToken()
                {
                    UserId = userAuthToken.UserId,
                    CompanyId = userAuthToken.CompanyId,
                    AuthToken = userAuthToken.AuthToken
                };

                var validUser = _userAuthTokenDbHelper.IsTokenValid(userAuth, GetRootPath());

                if (userAuthToken.AuthToken != authHeader.Parameter)
                {
                    return AuthenticateResult.Fail("401 UnAuthorized");
                }
                if (validUser != null)
                {
                    //return AuthenticateResult.Success();
                    var claims = new Claim[]
                    {
                        new Claim("loggedin-user",user.Id.ToString()),
                        new Claim("companyId",user.CompanyId.ToString())

                    };

                    var identity = new ClaimsIdentity(claims, Scheme.Name);
                    var principal = new ClaimsPrincipal(identity);
                    var ticket = new AuthenticationTicket(principal, Scheme.Name);

                    return AuthenticateResult.Success(ticket);  
                }
            }
            catch (Exception exception)
            {
                return AuthenticateResult.Fail("401 UnAuthorized");
            }

            return null;
        }

        protected virtual bool IsAuthorized(System.Web.Http.Controllers.HttpActionContext actionContext)
        {
            actionContext.ControllerContext.Request.Properties.Add("loggedin-user", "");
            return false;
        }

        private string GetRootPath()
        {
            var absoluteRootPath = _httpContextAccessor.HttpContext.Request.GetDisplayUrl().ToString();

            int index = absoluteRootPath.IndexOf("?");
            if (index > 0)
                absoluteRootPath = absoluteRootPath.Substring(0, index);

            var rootPath = absoluteRootPath.Replace(_configuration["ApiBasePath"], string.Empty);
            return rootPath;
        }
    }
}
