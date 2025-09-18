using System;
using System.Linq;
using Microsoft.Owin;
using Owin;
using Microsoft.Owin.Security.OAuth;
using BusinessView.Api.Models;
using System.Web.Http;
using BusinessView.Api.Providers;
using System.Threading.Tasks;

[assembly: OwinStartup(typeof(BusinessView.Api.Startup))]

namespace BusinessView.Api
{
    public static class ServerGlobalVariables
    {
        public const string OwinChallengeFlag = "X-Challenge";
    }

    public class CustomAuthenticationMiddleware : OwinMiddleware
    {
        public CustomAuthenticationMiddleware(OwinMiddleware next)
        : base(next)
        {
        }

        public override async Task Invoke(IOwinContext context)
        {
            await Next.Invoke(context);

            if (context.Response.StatusCode == 400
                && context.Response.Headers.ContainsKey(
                    ServerGlobalVariables.OwinChallengeFlag))
            {
                var headerValues = context.Response.Headers.GetValues
                                   (ServerGlobalVariables.OwinChallengeFlag);

                context.Response.StatusCode =
                    Convert.ToInt16(headerValues.FirstOrDefault());

                context.Response.Headers.Remove(
                    ServerGlobalVariables.OwinChallengeFlag);
            }
        }
    }
    public partial class Startup
    {
        public static OAuthBearerAuthenticationOptions OAuthBearerOptions
        {
            get;
            set;
        }

        public void Configuration(IAppBuilder app)
        {
            app.Use<CustomAuthenticationMiddleware>();

            app.CreatePerOwinContext(ApplicationDbContext.Create);

            #region OAuth Configuration
            OAuthAuthorizationServerOptions oAuthServerOptions = new OAuthAuthorizationServerOptions()
            {
                AllowInsecureHttp = true,
                TokenEndpointPath = new PathString("/api/login"),
                AccessTokenExpireTimeSpan = TimeSpan.FromDays(1000),
                Provider = new AuthorizationServerProvider()
            };

            // Token Generation
            app.UseOAuthAuthorizationServer(oAuthServerOptions);
            app.UseOAuthBearerAuthentication(new OAuthBearerAuthenticationOptions());
            #endregion

            var config = new HttpConfiguration();
            WebApiConfig.Register(config);

            app.UseCors(Microsoft.Owin.Cors.CorsOptions.AllowAll);

            app.UseWebApi(config);
        }
    }
}
