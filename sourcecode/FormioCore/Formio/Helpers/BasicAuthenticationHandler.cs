using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.Extensions.Configuration;
using formioModels;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Mvc;
using Formio.Models;
using formioCommon.Constants;
using System.Security.Claims;
using Newtonsoft.Json.Linq;

namespace Formio.Helpers
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public BasicAuthenticationHandler(
        IOptionsMonitor<AuthenticationSchemeOptions> options,
        ILoggerFactory logger,
        UrlEncoder encoder,
        ISystemClock clock,
        IHttpContextAccessor httpContextAccessor,
        IConfiguration iconfiguration)
        : base(options, logger, encoder, clock)
        {
            _httpContextAccessor = httpContextAccessor;
            _configuration = iconfiguration;
        }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
                return AuthenticateResult.Fail("Missing Authorization Header");

            try
            {
                var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
                
                var root = GetRootPath();
                var user = await GetUserAuthTokenReadItem(Request.Headers["Authorization"], root);
                if (user == null)
                {
                     return AuthenticateResult.Fail("401 UnAuthorized");
                }
                var claims = new Claim[]
                {
                    new Claim("loggedin-user",user.Id.ToString()),
                    new Claim("companyId",user.CompanyId.ToString()),
                    new Claim("Name",user.FullName)
                };

                var identity = new ClaimsIdentity(claims, Scheme.Name);
                var principal = new ClaimsPrincipal(identity);
                var ticket = new AuthenticationTicket(principal, Scheme.Name);

                return AuthenticateResult.Success(ticket);
            }
            catch (Exception exception)
            {

            }

            return null;
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

        public async Task<ValidUserOutputmodel> GetUserAuthTokenReadItem(string auth, string root)
        {
            try
            {
               
                using (var client = new HttpClient())
                {
                    AuthUser responseObj = new AuthUser();
                    responseObj.RootPath = root;
                    responseObj.AuthToken = auth.Replace("Bearer ", "");
                    client.BaseAddress = new Uri(_configuration["AuthConnectionString"] +"api/LoginApi/GetRootPathAccess");

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", auth.Replace("Bearer ", ""));
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(responseObj), Encoding.UTF8, "application/json");

                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        var result = response.Content.ReadAsStringAsync().Result;
                        JObject jobject = JObject.Parse(result);

                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Auth", "BasicAuth", result.ToString()), null);

                        if ((bool)jobject["success"])
                        {
                            string data = jobject["data"].ToString();

                            var user = JsonConvert.DeserializeObject<ValidUserOutputmodel>(data);

                            return user;
                        }
                        else
                        {
                            return null;
                        }
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserAuthTokenReadItem", " GetUserAuthTokenReadItem", exception.Message), exception);
                return null;
            }
        }
    }
}
