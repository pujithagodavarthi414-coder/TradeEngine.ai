using BTrak.Api.MSMQ;
using Microsoft.AspNet.SignalR;
using System.Web.Mvc;
using System.Threading;
using System.Web.Routing;
using System;
using BTrak.Common;
using Btrak.Services.PositionTable;
using Unity;

namespace BTrak.Api
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        private Timer _timer;
        private static int maxRetries = 3; // Set the maximum number of retries
        private static int currentRetries = 0;
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            System.Web.Http.GlobalConfiguration.Configure(WebApiConfig.Register);
            SignalRConfig.ConfigureSignalR(RouteTable.Routes, GlobalHost.DependencyResolver);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            UnityConfig.RegisterComponents();

            //new TrackerActivityDataHandler().Init();
            //new TrackerScreenshotDataHandler().Init();
            //new TrackerSummaryDataHandler().Init();

            ///===========---Dashboard backgroup job to save P&L history------=============///
            DateTime now = DateTime.UtcNow;
            DateTime nextExecution = now.Date.AddHours(15).AddMinutes(30).AddSeconds(0); // 09 PM IST == 3:30 PM UTC
            if (now > nextExecution)
            {
                nextExecution = nextExecution.AddDays(1);
            }
            TimeSpan initialDelay = nextExecution - now;

            // Schedule the timer
            _timer = new Timer(RunScheduledJob, null, initialDelay, TimeSpan.FromHours(24)); // 24 hours interval
        }

        private void RunScheduledJob(object state)
        {
            LoggingManager.Info("Entering into Dashborad scheduled job.......");
            // Instantiate your background job logic
            var unityContainer = UnityConfig.SetUpUnityContainer();
            var positionTableDashboard = unityContainer.Resolve<IPositionTableDashboardService>();
            try
            {
                positionTableDashboard.UpdateYTDPandLHistory(); // Execute the job logic
                currentRetries = 0;
                LoggingManager.Info("Exit from Dashborad scheduled job.......");
            }
            catch (Exception exception)
            {
                LoggingManager.Error("Dashboard scheduled job returned error on :" + DateTime.UtcNow + " with exception: " + exception);

                // Retry the job if maximum retries not reached
                if (currentRetries < maxRetries)
                {
                    currentRetries++;
                    LoggingManager.Info($"Retrying job ({currentRetries}/{maxRetries})...");
                }
                else
                {
                    LoggingManager.Info("Maximum retries reached. Will retry tomorrow.");
                    _timer.Change(TimeSpan.FromHours(24), TimeSpan.FromHours(24)); // Retry the job after 24 hours
                }
            }
        }

        protected void Application_End(object sender, EventArgs e)
        {
            _timer.Dispose();
        }
    }
}