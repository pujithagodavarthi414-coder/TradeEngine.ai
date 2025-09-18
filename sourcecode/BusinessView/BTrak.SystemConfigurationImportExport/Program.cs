using Btrak.Models;
using Btrak.Models.Widgets;
using Btrak.Services.SystemConfiguration;
using BTrak.Api;
using BTrak.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using Unity;


namespace BTrak.SystemConfigurationImportExport
{
    class Program
    {
        public static void Main(string[] args)
        {
               
            var filePath = ConfigurationManager.AppSettings["SystemConfigurationFilesPath"].ToString();

            LoggedInContext loggedInUser = new LoggedInContext()
            {
                LoggedInUserId = new Guid(ConfigurationManager.AppSettings["SystemConfigurationUserId"].ToString()),
                CompanyGuid = new Guid(ConfigurationManager.AppSettings["SystemConfigurationCompanyId"].ToString())
            };

            var validationMessages = new List<ValidationMessage>();

            ExportSystemConfiguration(loggedInUser, validationMessages, filePath);

            ImportSystemConfiguration(loggedInUser, validationMessages, filePath);

        }

        public static void ExportSystemConfiguration(LoggedInContext loggedInUser, List<ValidationMessage> validationMessages, string filePath)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Started Exporting System Configuration Data" , "Export Service"));

                using (StreamWriter file = File.CreateText(filePath))
                {
                    var siteAddress = ConfigurationManager.AppSettings["ExportSiteAddress"].ToString();

                    var unityContainer = UnityConfig.SetUpUnityContainer();

                    var systemConfigurationService = unityContainer.Resolve<SystemConfigurationService>();
                    var systemExportInputModel = new SystemExportInputModel();
                    var systemConfigurationJson = systemConfigurationService.ExportSystemConfiguration(systemExportInputModel,loggedInUser, validationMessages, siteAddress);

                    JsonSerializer serializer = new JsonSerializer();

                    serializer.Serialize(file, systemConfigurationJson);
                }
            }
            catch(Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "Program", exception.Message), exception);

            }
        }

        public static string ImportSystemConfiguration(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string filePath)
        {
            var systemConfigurationJson = "";

            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Started Importing System Configuration Data", "Import Service"));

                var unityContainer = UnityConfig.SetUpUnityContainer();

                var systemConfigurationService = unityContainer.Resolve<SystemConfigurationService>();                

                using (StreamReader r = new StreamReader(filePath))
                {
                    string json = r.ReadToEnd();                   
                    SystemConfigurationModel configuredData = JsonConvert.DeserializeObject<SystemConfigurationModel>(json);
                    systemConfigurationJson = systemConfigurationService.ImportSystemConfiguration(configuredData, loggedInContext, validationMessages);                   
                }                
            }            
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ImportSystemConfiguration", "Program", exception.Message), exception);

            }
            return systemConfigurationJson;
        }
    }
}
