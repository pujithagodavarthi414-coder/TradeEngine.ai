using System.Web.Http;
using BTrak.Api.Helpers;
using Unity.WebApi;

namespace BTrak.Api
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {

//#if (!DEBUG)
//            ExceptionlessClient.Default.RegisterWebApi(config);
//#endif
            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
               "DefaultApiAndAction",
               "api/{controller}/{action}/{id}",
               new { id = RouteParameter.Optional }
            );

            config.Routes.MapHttpRoute(
                "DefaultApi",
                "api/{controller}/{id}",
                new { id = RouteParameter.Optional }
            );

            config.Filters.Add(new PortalAuthorizeAttribute());

            var unityContainer = SetUpUnityContainerHelper.SetUpUnityContainer();

            config.DependencyResolver = new UnityDependencyResolver(unityContainer);
        }
    }
}