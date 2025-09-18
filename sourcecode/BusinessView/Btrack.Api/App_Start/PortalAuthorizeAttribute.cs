using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http.Controllers;
using Btrak.Models;
using BTrak.Common;
using System.Configuration;
using System.Web.Caching;
using System.Threading.Tasks;
using System.Net.Http.Headers;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Threading;
using System.Globalization;
using BTrak.Api.Helpers;

namespace BTrak.Api
{
    [AttributeUsage(AttributeTargets.Method | AttributeTargets.Class, AllowMultiple = true)]
    public class PortalAuthorizeAttribute : System.Web.Http.AuthorizeAttribute
    {
        private string _apiBasePath;
        private readonly UserAuthTokenDbHelper _userAuthTokenDbHelper;
        private readonly UserAuthTokenFactory _userAuthTokenFactory;

        public PortalAuthorizeAttribute()
        {
            _userAuthTokenDbHelper = new UserAuthTokenDbHelper();
            _userAuthTokenFactory = new UserAuthTokenFactory();
            _apiBasePath = ConfigurationManager.AppSettings["ApiBasePath"];
        }

        protected override bool IsAuthorized(HttpActionContext actionContext)
        {
            try
            {
                var absoluteRootPath = actionContext.Request.RequestUri.AbsolutePath.Trim();

                if (absoluteRootPath.Contains("Authorise")) return true;

                if (actionContext.Request.Method == HttpMethod.Options)
                {
                    actionContext.Response = new HttpResponseMessage(HttpStatusCode.Accepted);
                    HttpContext.Current.Response.End();
                    return true;
                }

                var splitArray = absoluteRootPath.Split('/');
                string rootPath = string.Empty;
                if (splitArray.Length > 2)
                {
                    rootPath = splitArray[1] + "/" + splitArray[2] + "/" + splitArray[3];
                }

                if (splitArray.Length > 4)
                {
                    rootPath += "/" + splitArray[4];
                }

                rootPath = rootPath.Replace(_apiBasePath, string.Empty);
                var user = Authenticate(actionContext.Request, rootPath);
                 
                //User details not correct (as user obj null)
                if (user == null)
                {
                    //Return a HTTP 401 Unauthorised header

                    user = ValidateClientRequest(actionContext.Request, rootPath).GetAwaiter().GetResult();
                    if (user == null)
                    {
                        var headers = actionContext.Request.Headers;

                        if (headers.Contains("ApiKey") && headers.GetValues("ApiKey").FirstOrDefault() != null)
                        {
                            return _userAuthTokenDbHelper.IsApiKeyValid(headers.GetValues("ApiKey").FirstOrDefault());
                        }

                        actionContext.Response = new HttpResponseMessage(HttpStatusCode.Unauthorized);
                        return false;
                    }

                   
                }

                //Set the user in route data so the WebAPI controller can use this user object & do what needed with it
                string auth = actionContext.Request.Headers.Authorization.ToString();
                user.authorization = auth.Replace("Bearer ", "");
                actionContext.ControllerContext.Request.Properties.Add("userDetails", user);

                return true;
            }
            catch (Exception ex)
            {
                //Return a HTTP 401 Unauthorised header
                actionContext.Response = new HttpResponseMessage(HttpStatusCode.Unauthorized);
            }
            return false;
        }

        private ValidUserOutputmodel Authenticate(HttpRequestMessage request, string actionPath)
        {

            //Try to get the Authorization header in the request
            var ah = request.Headers.Authorization;

            var re = request;
            var headers = re.Headers;

            //If no Auth header sent or the scheme is not bearer aka TOKEN
            if (ah != null && ah.Scheme.ToLower() == "bearer")
            {
                string token = null;
                if (headers.Contains("CurrentCulture"))
                {
                    token = headers.GetValues("CurrentCulture").FirstOrDefault();
                }
                if (token != null && token != "null")
                {
                    Thread.CurrentThread.CurrentCulture = new CultureInfo(token);
                    Thread.CurrentThread.CurrentUICulture = Thread.CurrentThread.CurrentCulture;
                }
                else
                {
                    Thread.CurrentThread.CurrentCulture = new CultureInfo("En");
                    Thread.CurrentThread.CurrentUICulture = Thread.CurrentThread.CurrentCulture;
                }

                //Get the JWT token from auth HTTP header param  param (Base64 encoded - username:password)
                var jwtToken = ah.Parameter;
                //Decode & verify token was signed with our secret
                // // var decodeJwt = _userAuthTokenFactory.DecodeUserAuthToken(jwtToken);  // Commented by 

                //Commenting the retrieval of cache api details of user to have security
                //if (HttpRuntime.Cache.Get(decodeJwt.AuthToken + "-" + actionPath) != null)
                //{
                //    return (ValidUserOutputmodel)HttpRuntime.Cache.Get(decodeJwt.AuthToken + "-" + actionPath);
                //}

                var user = ValidateClientRequest(request, actionPath).GetAwaiter().GetResult();

                if (user != null)
                {
                    return user;
                }
                else
                {
                    return null;
                }
                
                ////Ensure our token is not null (was decoded & valid)
                //if (decodeJwt != null)
                //{
                //    //Just the presence of the token & being deserialised with correct SECRET key is a good sign
                //    //Get the user from userService from it's username

                //    //var user = ApplicationContext.Current.Services.UserService.GetByProviderKey(decodeJwt.IdentityId);
                //    //If user is NOT Approved OR the user is Locked Out
                //    //if (!user.IsApproved || user.IsLockedOut)
                //    //{
                //    //    //Return null (by returning null, base method above will return it as HTTP 401)
                //    //    return null;
                //    //}

                //    //Verify token is what we have on the user
                //    var validUser = _userAuthTokenDbHelper.IsTokenValid(decodeJwt, actionPath);

                //    //adding to cache
                //    //if (validUser != null)
                //    //{
                //    //    HttpRuntime.Cache.Insert(decodeJwt.AuthToken + "-" + actionPath, validUser, null, DateTime.Now.AddMinutes(30), Cache.NoSlidingExpiration);
                //    //}

                //    //Token matches what we have in DB
                //    if (validUser != null)
                //    {
                //        return validUser;
                //    }

                //    //Token does not match in DB
                //    return null;
                //}

            }

            //JWT token could not be serialised to AuthToken object
            return null;
        }

        public async Task<ValidUserOutputmodel> ValidateClientRequest(HttpRequestMessage request, string actionPath)
        {
            try
            {
                using (var client = new HttpClient())
                {  

                    var input = new
                    {
                        RootPath = actionPath,
                        AuthToken = request.Headers.Authorization.Parameter
                    };

                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["AuthenticationServiceBasePath"]);
                    client.DefaultRequestHeaders.Add("Authorization", $"Bearer {input.AuthToken}");
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(input), Encoding.UTF8, "application/json");
                    var response = await client.PostAsync(RouteConstants.ASGetRootPathAccess, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string responseString = response.Content.ReadAsStringAsync().Result;
                        JObject result = JObject.Parse(responseString);
                        string data = result["data"].ToString();
                        var user = data != null ? JsonConvert.DeserializeObject<ValidUserOutputmodel>(data) : null;
                        LoggedInContext LoggedInContext = new LoggedInContext()
                        {
                            LoggedInUserId = user?.Id ?? Guid.Empty,
                            CompanyGuid = user?.CompanyId ?? Guid.Empty
                        };
                        var id = _userAuthTokenDbHelper.GetUserByUserAuthenticationIdAndCompanyId(user.UserAuthenticationId, LoggedInContext);
                        user.Id = id;
                        return user;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}