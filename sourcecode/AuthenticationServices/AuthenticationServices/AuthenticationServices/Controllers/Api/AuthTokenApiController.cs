using AuthenticationServices.Common;
using AuthenticationServices.Models;
using System;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using System.Net.Http.Headers;
using System.IdentityModel.Tokens.Jwt;
using AuthenticationServices.Api.Helpers;
using Microsoft.Extensions.Configuration;
using AuthenticationServices.Repositories.Repositories.UserAuthTokenRepository;

namespace AuthenticationServices.Api.Controllers.Api
{
    public class AuthTokenApiController : Controller
    {
        private readonly IConfiguration _configuration;
        UserAuthTokenRepository _userAuthTokenRepository;
        public ValidUserOutputmodel AuthorisedUser => AuthorisedUserDetails();
        
        private ValidUserOutputmodel AuthorisedUserDetails()
        {
            var user = new UserAuthorizationDetails(_configuration, _userAuthTokenRepository).AuthorisedUserDetails(Request);
            return user;
        }

        public LoggedInContext LoggedInContext => new LoggedInContext
        {
            LoggedInUserId = AuthorisedUser?.Id ?? Guid.Empty,
            TimeZoneOffset = Convert.ToInt32(Request.Headers.Where(s => s.Key == "TimeZone-Offset").Select(v => v.Value).FirstOrDefault().FirstOrDefault()),
            TimeZoneString = Request.Headers.Where(s => s.Key.ToLower() == "timezonestring").Select(v => v.Value).FirstOrDefault().FirstOrDefault(),
            CompanyGuid = AuthorisedUser?.CompanyId ?? Guid.Empty,
            RequestedHostAddress = HttpContext.Request.Host.ToString(),
            CurrentUrl = HttpContext.Request.Scheme + "://"  + HttpContext.Request.Host.ToString() + "/" //+ HttpContext.Request.Url.Authority + "/"
        };
    }
}
