
using Microsoft.Owin.Security.OAuth;
using System.Collections.Generic;
using System.Threading.Tasks;
using BusinessView.Api.Controllers;
using System.Net;
using System.Security.Claims;
using Newtonsoft.Json;
using Microsoft.Owin.Security;

namespace BusinessView.Api.Providers
{
    public class AuthorizationServerProvider: OAuthAuthorizationServerProvider
    {
        public override async Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
        {
            context.Validated();
        }

        public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        {
            var user = new UserApiController().GetRegistrationEntity(context.UserName, context.Password);

            context.OwinContext.Response.Headers.Add("Access-Control-Allow-Origin", new[] { "*" });

            if (user == null)
            {
                context.Response.StatusCode = 200;
                context.SetError("invalid_grant", "The user name or password is incorrect.");
                context.Response.Headers.Add("X-Challenge", new[] { ((int)HttpStatusCode.OK).ToString() }); //Little trick to get this to throw 401, refer to AuthenticationMiddleware for more
                return;
            }

            var identity = new ClaimsIdentity(context.Options.AuthenticationType);
            identity.AddClaim(new Claim("sub", context.UserName));
            identity.AddClaim(new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()));
            identity.AddClaim(new Claim("role", "user"));
            identity.AddClaim(new Claim(ClaimTypes.Name, user.UserName.ToString()));

            string str = JsonConvert.SerializeObject(user);

            var props = new AuthenticationProperties(new Dictionary<string, string>
            {
                {
                    "user", str
                },
                {
                    "success", "true"
                }
            });

            var ticket = new AuthenticationTicket(identity, props);
            context.Validated(ticket);
        }

        public override Task TokenEndpoint(OAuthTokenEndpointContext context)
        {
            foreach (KeyValuePair<string, string> property in context.Properties.Dictionary)
            {
                context.AdditionalResponseParameters.Add(property.Key, property.Value);
            }

            return Task.FromResult<object>(null);
        }
    }
}