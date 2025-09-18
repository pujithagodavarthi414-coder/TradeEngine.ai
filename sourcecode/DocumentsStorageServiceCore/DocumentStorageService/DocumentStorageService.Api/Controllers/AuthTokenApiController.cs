using System;
using System.Linq;
using AuthenticationServices.Api.Helpers;
using DocumentStorageService.Api.Helpers;
using DocumentStorageService.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace DocumentStorageService.Api.Controllers
{
    public class AuthTokenApiController : Controller
    {
        public ValidUserOutputmodel AuthorisedUser => AuthorisedUserDetails();
        private readonly IConfiguration _configuration;
        private ValidUserOutputmodel AuthorisedUserDetails()
        {
            var user = new UserAuthorizationDetails(_configuration).AuthorisedUserDetails(Request);
            return user;
        }
        public LoggedInContext LoggedInContext => new LoggedInContext
        {
            LoggedInUserId = AuthorisedUser?.Id ?? Guid.Empty,
            //LoggedInUserId = Guid.Parse("62722219-FE37-4B8E-B9FD-B70B05FEE17C"),
            TimeZoneOffset = Convert.ToInt32(Request.Headers.Where(s => s.Key == "TimeZone-Offset").Select(v => v.Value).FirstOrDefault().FirstOrDefault()),
            TimeZoneString = Request.Headers.Where(s => s.Key.ToLower() == "timezonestring").Select(v => v.Value).FirstOrDefault().FirstOrDefault(),
            CompanyGuid = AuthorisedUser?.CompanyId ?? Guid.Empty,
            //CompanyGuid = Guid.Parse("9D973060-C986-48B4-BDC2-1B3F2CF5136C"),
            Authorization = AuthorisedUser?.Authorization ?? string.Empty,
            RequestedHostAddress = HttpContext.Request.Host.ToString(),
            CurrentUrl = HttpContext.Request.Scheme + "://" + HttpContext.Request.Host.ToString() + "/"
        };
    }
}
