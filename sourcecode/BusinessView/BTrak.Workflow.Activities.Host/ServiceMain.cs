using System;
using System.Configuration;
using CamundaClient;

namespace BTrak.Workflow.Activities.Host
{
    internal class ServiceMain
    {
        private readonly CamundaEngineClient _camundaEngineClient;

        public ServiceMain()
        {
            var camundaApiBaseUrl = ConfigurationManager.AppSettings["CamundaApiBaseUrl"];
            _camundaEngineClient = new CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);
        }

        public void Run()
        {
            _camundaEngineClient.Startup();
        }

        public bool Stop()
        {
            _camundaEngineClient.Shutdown();
            return true;
        }

        public bool Shutdown()
        {
            return true;
        }

        public bool Pause()
        {
            return true;
        }

        public bool Continue()
        {
            return true;
        }

    }
}
