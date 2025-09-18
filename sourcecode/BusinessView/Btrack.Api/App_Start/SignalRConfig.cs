using System.Web.Routing;
using Microsoft.AspNet.SignalR;

namespace BTrak.Api
{
    public static class SignalRConfig
    {
        public static void ConfigureSignalR(RouteCollection routes, IDependencyResolver dependencyResolver)
        {
#if DEBUG
            routes.MapHubs(new HubConfiguration
            {
                EnableCrossDomain = true
            });
#endif
#if !DEBUG
           routes.MapHubs();
#endif
        }
    }
}
