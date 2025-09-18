using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http;
using AuthenticationServices.Api.Helpers;
using AuthenticationServices.Models;
using Microsoft.Extensions.Configuration;

namespace AuthenticationServices.Api.AppStart
{
    [AttributeUsage(AttributeTargets.Method | AttributeTargets.Class, AllowMultiple = true)]
    public class PortalAuthorizeAttribute : AuthorizeAttribute
    {
        IConfiguration _iconfiguration;
        private readonly UserAuthTokenDbHelper _userAuthTokenDbHelper;
        private readonly UserAuthTokenFactory _userAuthTokenFactory;
        private string _apiBasePath;

        public PortalAuthorizeAttribute(IConfiguration iconfiguration, UserAuthTokenDbHelper userAuthTokenDbHelper)
        {
            _userAuthTokenDbHelper = userAuthTokenDbHelper;//new UserAuthTokenDbHelper();
            _userAuthTokenFactory = new UserAuthTokenFactory();
            _iconfiguration = iconfiguration;
        }

        protected override bool IsAuthorized(System.Web.Http.Controllers.HttpActionContext actionContext)
        {
            try
            {
                var absoluteRootPath = actionContext.Request.RequestUri.AbsolutePath.Trim();

                if (absoluteRootPath.Contains("Authorise")) return true;

                if (actionContext.Request.Method == HttpMethod.Options)
                {
                    actionContext.Response = new HttpResponseMessage(HttpStatusCode.Accepted);
                    // //HttpContext.Current.Response.End(); // Added by me
                    return true;
                }

                //Auth the user from the request (HTTP headers)

                absoluteRootPath = actionContext.Request.RequestUri.AbsolutePath.Trim();

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

                    var headers = actionContext.Request.Headers;

                    if (headers.Contains("ApiKey") && headers.GetValues("ApiKey").FirstOrDefault() != null)
                    {
                        return _userAuthTokenDbHelper.IsApiKeyValid(headers.GetValues("ApiKey").FirstOrDefault());
                    }

                    actionContext.Response = new HttpResponseMessage(HttpStatusCode.Unauthorized);
                    return false;
                }

                //Set the user in route data so the WebAPI controller can use this user object & do what needed with it
                actionContext.ControllerContext.Request.Properties.Add("loggedin-user", user);

                return true;
            }
            catch (Exception exception)
            {
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
                var decodeJwt = _userAuthTokenFactory.DecodeUserAuthToken(jwtToken);

                //Commenting the retrieval of cache api details of user to have security
                //if (HttpRuntime.Cache.Get(decodeJwt.AuthToken + "-" + actionPath) != null)
                //{
                //    return (ValidUserOutputmodel)HttpRuntime.Cache.Get(decodeJwt.AuthToken + "-" + actionPath);
                //}

                //Ensure our token is not null (was decoded & valid)
                if (decodeJwt != null)
                {
                    //Just the presence of the token & being deserialised with correct SECRET key is a good sign
                    //Get the user from userService from it's username

                    //var user = ApplicationContext.Current.Services.UserService.GetByProviderKey(decodeJwt.IdentityId);
                    //If user is NOT Approved OR the user is Locked Out
                    //if (!user.IsApproved || user.IsLockedOut)
                    //{
                    //    //Return null (by returning null, base method above will return it as HTTP 401)
                    //    return null;
                    //}

                    //Verify token is what we have on the user
                    var validUser = _userAuthTokenDbHelper.IsTokenValid(decodeJwt, actionPath);

                    //adding to cache
                    //if (validUser != null)
                    //{
                    //    HttpRuntime.Cache.Insert(decodeJwt.AuthToken + "-" + actionPath, validUser, null, DateTime.Now.AddMinutes(30), Cache.NoSlidingExpiration);
                    //}

                    //Token matches what we have in DB
                    if (validUser != null)
                    {
                        return validUser;
                    }

                    //Token does not match in DB
                    return null;
                }

            }

            //JWT token could not be serialised to AuthToken object
            return null;
        }
    }
}
