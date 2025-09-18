using BTrak.Api;
using Unity;

namespace BTrak.Workflow.Activities.Host
{
    public static class Unity
    {
        public static UnityContainer UnityContainer = UnityConfig.SetUpUnityContainer();
    }
}
