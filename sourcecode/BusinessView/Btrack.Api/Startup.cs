using Btrak.Services;
using Btrak.Services.ActivityTracker;
using Btrak.Services.ComplianceAudit;
using Btrak.Services.HrManagement;
using Btrak.Services.Productivity;
using Btrak.Services.User;
using Btrak.Services.Recruitment;
using Btrak.Services.GenericForm;
using Hangfire;
using Hangfire.SqlServer;
using Microsoft.Owin;
using Owin;
using System.Configuration;
using Unity;
using Btrak.Services.BillingManagement;
using Btrak.Services.Trading;
using Microsoft.AspNet.SignalR;
using Microsoft.Owin.Cors;
using Btrak.Services.ExcelToCustomApplicationRecords;

[assembly: OwinStartup(typeof(BTrak.Api.Startup))]
namespace BTrak.Api
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            var options = new SqlServerStorageOptions
            {
                PrepareSchemaIfNecessary = false
            };

            GlobalConfiguration.Configuration.UseSqlServerStorage(ConfigurationManager
                .ConnectionStrings["HangfirePersistence"].ConnectionString, options);

            var unityContainer = UnityConfig.SetUpUnityContainer();
            GlobalConfiguration.Configuration.UseUnityActivator(unityContainer);
            var updateGoalService = unityContainer.Resolve<IUpdateGoalService>();
            var activityTrackerService = unityContainer.Resolve<IActivityTrackerService>();
            var hrmanagementService = unityContainer.Resolve<IHrManagementService>();
            var complianceService = unityContainer.Resolve<IComplianceAuditService>();
            var productivityservice = unityContainer.Resolve<IProductivityService>();
            var recruitmentService = unityContainer.Resolve<IRecruitmentService>();
            var userService = unityContainer.Resolve<IUserService>();
            var clientService = unityContainer.Resolve<IClientService>();
            var tradingService = unityContainer.Resolve<ITradingService>();
            var genericFormService = unityContainer.Resolve<IGenericFormService>();

            app.UseHangfireDashboard("/jobs", new DashboardOptions
            {
                Authorization = new[] { new BTrakAuthorizationFilter() }
            });

            app.UseHangfireServer();
            app.UseCors(CorsOptions.AllowAll);
            app.Map("/signalr", map =>
            {
                // Setup the CORS middleware to run before SignalR.
                // By default this will allow all origins. You can 
                // configure the set of origins and/or http verbs by
                // providing a cors options with a different policy.
                //map.UseCors(CorsOptions.AllowAll);
                var hubConfiguration = new HubConfiguration
                {
                    // You can enable JSONP by uncommenting line below.
                    // JSONP requests are insecure but some older browsers (and some
                    // versions of IE) require JSONP to work cross domain
                    // EnableJSONP = true
                    EnableCrossDomain = true
                };
                // Run the SignalR pipeline. We're not using MapSignalR
                // since this branch already runs under the "/signalr"
                // path.
                map.MapHubs(hubConfiguration);
            });

            var environmentId = ConfigurationManager.AppSettings["EnvironmentUniqueName"];

            if (ConfigurationManager.AppSettings["IsRecurringJobsNeedtoRun"] == "true")
            {
                //Updating GoalStatuses
                RecurringJob.AddOrUpdate("UpdateGoalColor_" + environmentId,
                    () => updateGoalService.UpdateAllGoalStatusColor(), Cron.Daily);
             
                RunSlackJobs(environmentId,  updateGoalService, hrmanagementService, activityTrackerService , complianceService, clientService,tradingService);
                RecurringJob.AddOrUpdate("SendInterviewRemainder_" + environmentId,
                    () => recruitmentService.ReccurInterviewSchedule(), "0/1 * 1/1 * *");

                //update process instance status 12am, 8am, and 4pm
                RecurringJob.AddOrUpdate("UpdateProcessInstanceStatus_" + environmentId,
                   () => genericFormService.UpdateProcessInstanceStatus(), "0 */8 * * *");
            }

        }

        private static void RunSlackJobs(string environmentId, IUpdateGoalService updateGoalService, IHrManagementService hrManagementService, IActivityTrackerService activityTrackerService , IComplianceAuditService complianceService,IClientService clientService,ITradingService tradingService)
        {
            //TODO: Move this to a table and get an UI for this.

            //QA Status
            //RecurringJob.AddOrUpdate("QaStatus_" + environmentId,
            //    () => updateGoalService.PullData(
            //        "EXEC [dbo].[USP_GetQaDetails] @OperationsPerformedBy=\'0B2921A9-E930-4013-9047-670B5352F308\',@SelectDate = null",
            //        "Qa Status", "Qa Status", ConfigurationManager.AppSettings["processDashboardWebHookUrl"]),
            //    Cron.Daily(04, 00));

            // Check daily reminders
            RecurringJob.AddOrUpdate("CheckReminders_" + environmentId,
                    () => hrManagementService.CheckDailyReminders(), Cron.Daily(04, 00));

            //LeadLevelProductivity
            //RecurringJob.AddOrUpdate("LeadLevelProductivity_" + environmentId,
            //    () => updateGoalService.PullData(
            //        "EXEC [dbo].[USP_GetLeadLevelProductivityIndex] @OperationsPerformedBy=\'0B2921A9-E930-4013-9047-670B5352F308\'",
            //        "LeadLevelProductivity", "LeadLevelProductivity",
            //        ConfigurationManager.AppSettings["processDashboardWebHookUrl"]), Cron.Weekly(DayOfWeek.Tuesday, 04, 00));

            //IndividualProductivity
            //RecurringJob.AddOrUpdate("IndividualProductivity_" + environmentId,
            //    () => updateGoalService.PullData(
            //        "EXEC [dbo].[USP_GetProductivityIndexOfIndividual] @OperationsPerformedBy=\'0B2921A9-E930-4013-9047-670B5352F308\'",
            //        "IndividualProductivity", "IndividualProductivity",
            //        ConfigurationManager.AppSettings["processDashboardWebHookUrl"]), Cron.Weekly(DayOfWeek.Tuesday, 04, 00));

            //LoggingCompliance
            //RecurringJob.AddOrUpdate("LoggingCompliance_" + environmentId,
            //    () => updateGoalService.PullData(
            //        "EXEC [dbo].[USP_GetCompliance] @OperationsPerformedBy=\'0B2921A9-E930-4013-9047-670B5352F308\',@Variant=10",
            //        "LoggingCompliance", "LoggingCompliance", ConfigurationManager.AppSettings["processDashboardWebHookUrl"]),
            //    Cron.Daily(04, 30));

            //UsersWhoDidnotFinishedPreviousDay
            //RecurringJob.AddOrUpdate("UsersWhoDidnotFinishedPreviousDay_" + environmentId,
            //    () => updateGoalService.PullData(
            //        "EXEC [dbo].[USP_GetUsersWhoDidnotFinishedPreviousDay] @OperationsPerformedBy=\'0B2921A9-E930-4013-9047-670B5352F308\'",
            //        "UsersDidnotFinishedPreviousDay", "UsersDidnotFinishedPreviousDay",
            //        ConfigurationManager.AppSettings["ManagementChannelWebHookUrl"]), Cron.Daily(04, 30));

            ////LateUsers
            //RecurringJob.AddOrUpdate("LateUsers_" + environmentId,
            //    () => updateGoalService.PullData(
            //        "EXEC [dbo].[USP_GetLateUsers] @OperationsPerformedBy=\'0B2921A9-E930-4013-9047-670B5352F308\'",
            //        "LateUsers", "LateUsers", ConfigurationManager.AppSettings["ManagementChannelWebHookUrl"]),
            //    Cron.Daily(04, 30));

            ////CompanyLevel
            //RecurringJob.AddOrUpdate("CompanyLevelReport_" + environmentId,
            //    () => updateGoalService.PullData(
            //        "EXEC [dbo].[USP_GetCompanyLevelComplianceAndProductivity] @OperationsPerformedBy=\'0B2921A9-E930-4013-9047-670B5352F308\',@Variant=10",
            //        "CompanylevelComplianceAndProductivity", "CompanylevelComplianceAndProductivity",
            //        ConfigurationManager.AppSettings["processDashboardWebHookUrl"]), Cron.Daily(04, 30));

            //Productivity data points
            RecurringJob.AddOrUpdate("ProductivityDataPoints_" + environmentId, () => updateGoalService.ProduceData("EXEC [dbo].[USP_ProduceProductivityData]"), Cron.Daily(19, 30));

            //PlannedVSUnplannedWork - 
            //RecurringJob.AddOrUpdate("PlannedVSUnplannedWork_" + environmentId, () => updateGoalService.PullData("EXEC [dbo].[USP_PalnnedAndUnPlannedReport]", "Planned VS UnplannedWork", "Planned VS UnplannedWork", ConfigurationManager.AppSettings["processDashboardWebHookUrl"]), Cron.Daily(04, 30));

            //LeadLevelWorkLogPercentage
            //RecurringJob.AddOrUpdate("LeadLevelPlannedWorkLogPercentge_" + environmentId,
            //    () => updateGoalService.PullData(
            //        "EXEC [dbo].[USP_LeadLevelLogpercentge]",
            //        "LeadLevelPlannedWorkLogPercentge", "LeadLevelPlannedWorkLogPercentge", ConfigurationManager.AppSettings["ManagementChannelWebHookUrl"]),
            //    Cron.Daily(04, 30));

            //LeadLevelWorkLogPercentage in leades channel
            //RecurringJob.AddOrUpdate("LeadLevelPlannedWorkLogPercentge_" + environmentId,
            //   () => updateGoalService.PullData(
            //       "EXEC [dbo].[USP_LeadLevelLogpercentge]",
            //       "LeadLevelPlannedWorkLogPercentge", "LeadLevelPlannedWorkLogPercentge", ConfigurationManager.AppSettings["processDashboardWebHookUrl"]),
            //   Cron.Daily(04, 30));

            //Activity tracker timeline backend job
            RecurringJob.AddOrUpdate("ActivityTrackerTimeLineRecurringJob_" + environmentId, () => 
            activityTrackerService.ActivityTrackerProduceData("USP_ActivityTrackerTimeLineRecurringJob"), Cron.Daily(23, 00));

            ////Send Configured Email Reports backend job
            RecurringJob.AddOrUpdate("SendConfiguredEmailReports_" + environmentId, () =>
            activityTrackerService.SendConfiguredEmailReports(), Cron.Daily(00, 10));

            //User tracker report email backend job
            //RecurringJob.AddOrUpdate("UserDailyTrackerReport_" + environmentId, () => 
            //activityTrackerService.SendTrackerReportEmails(), Cron.Daily(00, 10));
             
            //User birthday wishes email backend job
            //RecurringJob.AddOrUpdate("BirthdayWishesToUser_" + environmentId, () => 
            //activityTrackerService.SendBirthdayEmailToUser(), Cron.Daily(01, 00));

            //Activity tracker Idle time calculation weekly job
            RecurringJob.AddOrUpdate("UserActivityHistoricalDataRecurringJob_" + environmentId, () =>
            activityTrackerService.ActivityTrackerProduceData("USP_UserActivityHistoricalDataRecurringJob"), Cron.Daily(01, 15));

            //Activity tracker User Activity time calculation weekly job
            RecurringJob.AddOrUpdate("IdleTimeHistoricalDataRecurringJob_" + environmentId, () =>
            activityTrackerService.ActivityTrackerProduceData("USP_IdleTimeHistoricalDataRecurringJob"), Cron.Daily(00, 30));

            //Delete screenshots weekly job
            //RecurringJob.AddOrUpdate("DeleteScreenshotsRecurringJob_" + environmentId, () =>
            //activityTrackerService.ActivityTrackerProduceData("USP_DeleteScreenshotsRecurringJob"), Cron.Weekly(DayOfWeek.Monday, 02, 00));

            //audit conduct overdue mail notifiatin
            RecurringJob.AddOrUpdate("AuditConductMailNotificaion" + environmentId, () =>
            complianceService.AuditConductMailNotification("USP_AuditConductMailNotification"), Cron.Daily(00, 15));

            //Produce productivity index
            RecurringJob.AddOrUpdate("ProduceProductivityIndex_" + environmentId, () =>
            activityTrackerService.ActivityTrackerProduceData("USP_ProduceProductivityIndex"), Cron.Daily(02, 00));

            //audit start mail notification
            RecurringJob.AddOrUpdate(
                "AuditConductStartMailNotificaion" + environmentId,
                () =>
            complianceService.AuditConductStartMailNotification(), Cron.Daily(00,15));

            //Activity tracker timesheet entry
            RecurringJob.AddOrUpdate("TrackerTimeSheet_" + environmentId, () =>
            activityTrackerService.ActivityTrackerProduceData("USP_TrackerTimeSheetEntry"), "0 */2 * * *");

            //Productivity dashboard stats
            RecurringJob.AddOrUpdate("ProductivityDashboardStats" + environmentId, () =>
            activityTrackerService.ActivityTrackerProduceData("USP_ProductivityJobProcedure"), Cron.Daily(01, 00));

            //RecurringJob.AddOrUpdate("ClientKYCAlert-" + environmentId, () => clientService.SendMailToKYCAlert(), Cron.Daily(00, 02));
            //RecurringJob.AddOrUpdate("ClientKYCRemind-" + environmentId, () => clientService.SendKYCRemindMail(), Cron.Daily(00, 02));
            //RecurringJob.AddOrUpdate("UnsoldQTYEmailAlert-" + environmentId, () => tradingService.UnsoldQTYEmailAlert(), Cron.Daily(00, 02));
        }
    }
}