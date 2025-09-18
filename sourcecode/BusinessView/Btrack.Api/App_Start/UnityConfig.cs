using System.Web.Http;
using Unity;
using Unity.WebApi;
using BTrak.Api.Helpers;

namespace BTrak.Api
{
    public static class UnityConfig
    {
        public static void RegisterComponents()
        {
            var unityContainer = SetUpUnityContainer();

            GlobalConfiguration.Configuration.DependencyResolver = new UnityDependencyResolver(unityContainer);
        }

        public static UnityContainer SetUpUnityContainer()
        {
            return SetUpUnityContainerHelper.SetUpUnityContainer();
        }
    }
}