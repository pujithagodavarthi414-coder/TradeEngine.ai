using System;
using System.Linq;
using System.Web;
using System.Web.Http;
using Btrak.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.Api
{
    public abstract class AuthTokenApiController : ApiController
    {
        public ValidUserOutputmodel AuthorisedUser => ControllerContext.Request.Properties.ContainsKey("userDetails") ? ControllerContext.Request.Properties["userDetails"] as ValidUserOutputmodel : null;

        public LoggedInContext LoggedInContext => new LoggedInContext
        {
            LoggedInUserId = AuthorisedUser?.Id ?? Guid.Empty,
            TimeZoneOffset = Convert.ToInt32(Request.Headers?.Where(s => s.Key == "TimeZone-Offset").Select(v => v.Value).FirstOrDefault()?.FirstOrDefault()),
            TimeZoneString = Request.Headers?.Where(s => s.Key.ToLower() == "timezonestring").Select(v => v.Value).FirstOrDefault()?.FirstOrDefault(),
            CompanyGuid = AuthorisedUser?.CompanyId ?? Guid.Empty,
            CompanyAuthenticationId = AuthorisedUser?.CompanyId ?? Guid.Empty,
            authorization = AuthorisedUser?.authorization ?? string.Empty,
            RequestedHostAddress = HttpContext.Current?.Request?.UserHostAddress,
            CurrentUrl = HttpContext.Current?.Request?.Url?.Scheme+"://"+ HttpContext.Current.Request.Url.Authority+"/",
            AccessToken = Request.Headers?.Authorization?.Scheme.ToLower() == "bearer" ? Request.Headers?.Authorization?.Parameter != null ? Request.Headers?.Authorization?.Parameter : null : null
        };
    }
}
