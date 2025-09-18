using BTrak.Common;
using Hangfire;
using System;
using System.Configuration;
using Topshelf;

namespace BTrak.Workflow.Activities.Host
{
    public class Program
    {
        public static void Main()
        {
            var serviceName = "WorkflowsService";
            var serviceDisplayName = "Workflows";
            log4net.Config.XmlConfigurator.Configure();

            //GlobalConfiguration.Configuration.UseSqlServerStorage(ConfigurationManager.ConnectionStrings["HangfirePersistence"].ConnectionString);

            LoggedInContext loggedInUser = new LoggedInContext()
            {
                LoggedInUserId = new Guid(ConfigurationManager.AppSettings["CustomAppImportsUserId"].ToString()),
                CompanyGuid = new Guid(ConfigurationManager.AppSettings["CustomAppCompanyId"].ToString())
            };

            var rc = HostFactory.Run(srv =>
            {
                srv.Service<ServiceMain>(setup =>
                {
                    setup.ConstructUsing(init => new ServiceMain());
                    setup.WhenStarted(j => j.Run());
                    setup.WhenStopped(j => j.Stop());
                    setup.WhenPaused(j => j.Pause());
                    setup.WhenContinued(j => j.Continue());
                    setup.WhenShutdown(j => j.Shutdown());
                });
                srv.RunAsLocalSystem();
                srv.StartAutomatically();
                srv.SetServiceName(serviceName);
                srv.SetDescription("Processes Workflows");
                srv.SetDisplayName(serviceDisplayName);
                srv.EnablePauseAndContinue();
                srv.EnableShutdown();
            });
        }
    }
}
