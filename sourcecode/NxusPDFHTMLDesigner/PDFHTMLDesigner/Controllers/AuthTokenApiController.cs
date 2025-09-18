using PDFHTMLDesigner.Helpers;
using PDFHTMLDesignerModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using Microsoft.Extensions.Configuration;
using AuthenticationServices.Api.Helpers;
using PDFHTMLDesignerModels.ValidUserOutputmodel;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.OpenApi.Any;
using System.Collections.Generic;

namespace PDFHTMLDesigner.Controllers
{
    public class AuthTokenApiController : Controller
    {
        //public ValidUserOutputmodel AuthorisedUser => ControllerContext.HttpContext.Request.Headers.ContainsKey("loggedin-user") ? ControllerContext.HttpContext.Request.Headers.Values as ValidUserOutputmodel : null;
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
            TimeZoneOffset = Convert.ToInt32(Request.Headers.Where(s => s.Key == "TimeZone-Offset").Select(v => v.Value).FirstOrDefault().FirstOrDefault()),
            TimeZoneString = Request.Headers.Where(s => s.Key.ToLower() == "timezonestring").Select(v => v.Value).FirstOrDefault().FirstOrDefault(),
            CompanyGuid = AuthorisedUser?.CompanyId ?? Guid.Empty,
            Authorization = AuthorisedUser?.Authorization ?? string.Empty,
            RequestedHostAddress = HttpContext.Request.Host.ToString(),
            CurrentUrl = HttpContext.Request.Scheme + "://" + HttpContext.Request.Host.ToString() + "/"

            /*
            //LoggedInUserId = AuthorisedUser?.Id ?? Guid.Empty,
            LoggedInUserId = Guid.Parse("62722219-FE37-4B8E-B9FD-B70B05FEE17C"),
            TimeZoneOffset = Convert.ToInt32(Request.Headers.Where(s => s.Key == "TimeZone-Offset").Select(v => v.Value).FirstOrDefault().FirstOrDefault()),
            TimeZoneString = Request.Headers.Where(s => s.Key.ToLower() == "timezonestring").Select(v => v.Value).FirstOrDefault().FirstOrDefault(),
            //CompanyGuid = AuthorisedUser?.CompanyId ?? Guid.Empty,
            CompanyGuid = Guid.Parse("9D973060-C986-48B4-BDC2-1B3F2CF5136C"),
            RequestedHostAddress = HttpContext.Request.Host.ToString(),
            CurrentUrl = HttpContext.Request.Scheme + "://" + HttpContext.Request.Host.ToString() + "/"*/

            //LoggedInUserId = AuthorisedUser?.Id ?? Guid.Empty,
            //LoggedInUserId = Guid.Parse("62722219-FE37-4B8E-B9FD-B70B05FEE17C"),
            //LoggedInUserId = Guid.Parse("1225aa58-8c59-4c35-bb09-113d39bcfc6d"),
            //LoggedInUserId = Guid.Parse("8405494f-4bba-496b-9e77-2cbbe308f834"),
            //TimeZoneOffset = Convert.ToInt32(Request.Headers.Where(s => s.Key == "TimeZone-Offset").Select(v => v.Value).FirstOrDefault().FirstOrDefault()),
            //TimeZoneString = Request.Headers.Where(s => s.Key.ToLower() == "timezonestring").Select(v => v.Value).FirstOrDefault().FirstOrDefault(),
            //CompanyGuid = AuthorisedUser?.CompanyId ?? Guid.Empty,
            //CompanyGuid = Guid.Parse("9D973060-C986-48B4-BDC2-1B3F2CF5136C"),
            //CompanyGuid = Guid.Parse("33f34d77-2611-4de7-ba19-17b3d4a81b46"),
            //CompanyGuid = Guid.Parse("ad73d631-9f10-46fb-a14f-8bbb2c79b66e"),
            //Authorization = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjJDREQ2RkIzMUY0MEE5REFCNjZEQTlDOTM1NzhCNEFFIiwidHlwIjoiYXQrand0In0.eyJuYmYiOjE2NjM2NTU2MjQsImV4cCI6MTY2MzY2MjgyNCwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo1ODMwMyIsImNsaWVudF9pZCI6Ijg0MDU0OTRGLTRCQkEtNDk2Qi05RTc3LTJDQkJFMzA4RjgzNCAzM0YzNEQ3Ny0yNjExLTRERTctQkExOS0xN0IzRDRBODFCNDYiLCJqdGkiOiIxNzZCRTJGNEU2MjVFQ0IzQjEzNzNERTg5M0M3OTY1MiIsImlhdCI6MTY2MzY1NTYyNCwic2NvcGUiOlsiMzNGMzRENzctMjYxMS00REU3LUJBMTktMTdCM0Q0QTgxQjQ2Il19.BF-pUV7ncqBHk0qrdxqNGc4U1nlBD1OhgeuQQ15UEX7SV2zJc2cTXjP15JU3unsxMQeJScxTc40CNld8JuG8gFfQc5mHYNyVylgBuaiCUDiII3IuiqncrGS3JndXfhm5tSRdq9y5jys7emAtWjAtfCWQeUH-_aA4xYwXhbHjjNUtNHBNc1RyZgDfw6mERaH1vr3aA37cif0Tj3Hr-rO74_HoFG5ycwCTMGzcu3MiKzYtDkMNwrnR2V2p_E085LgSJVHIa4Czoz080Q6Tk9_os1kixuCTxXEgdPjClPT0sA68OfKt6C2d-yWJIyHIXwyYzI7GGRuvltRK33CpFezzBA",
            //RequestedHostAddress = HttpContext.Request.Host.ToString(),
            //CurrentUrl = HttpContext.Request.Scheme + "://" + HttpContext.Request.Host.ToString() + "/"
        };
    }
}
