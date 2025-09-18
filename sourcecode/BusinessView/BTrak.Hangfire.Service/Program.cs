using System.Configuration;
using Hangfire;
using log4net;
using Topshelf;

namespace BTrak.Hangfire.service
{
    public class Program
    {
        public static ILog Logger = LogManager.GetLogger("LoggingManager");

        public static void Main()
        {
            var serviceName = "HangFireService";
            var serviceDisplayName = "HangFire";
            log4net.Config.XmlConfigurator.Configure();

            GlobalConfiguration.Configuration.UseSqlServerStorage(ConfigurationManager.ConnectionStrings["HangfirePersistence"].ConnectionString);
            
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
                srv.SetDescription("Processes Hangfire");
                srv.SetDisplayName(serviceDisplayName);
                srv.EnablePauseAndContinue();
                srv.EnableShutdown();
            });
        }
    }
}
