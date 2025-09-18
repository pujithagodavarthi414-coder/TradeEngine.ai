using Formio.Helpers;
using formioModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;

namespace Formio.Controllers
{
    public class AuthTokenApiController : Controller
    {

        //public ValidUserOutputmodel AuthorisedUser => ControllerContext.HttpContext.Request.Headers.ContainsKey("loggedin-user") ? ControllerContext.HttpContext.Request.Headers.Values as ValidUserOutputmodel : null;
        public ValidUserOutputmodel AuthorisedUser => AuthorisedUserDetails();
        private ValidUserOutputmodel AuthorisedUserDetails()
        {
            var user = UiHelper.ValidUserOutput(HttpContext, Request);
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
            RequestedHostAddress = HttpContext.Request.Host.ToString(),
            CurrentUrl = HttpContext.Request.Scheme + "://" + HttpContext.Request.Host.ToString() + "/",
            FullName = HttpContext.User.Claims.First(x => x.Type == "Name").Value
        };
    }
}
