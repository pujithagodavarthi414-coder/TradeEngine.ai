using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using BTrak.Common;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Services.PayRoll;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Unity;
using Btrak.Models.CompanyStructure;
using Btrak.Models.SystemManagement;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("SendNotification")]
    [ExternalTaskVariableRequirements("isApproved", "Role", "PayrollName", "TemplateName", "Subject", "companyId", "loggedUserId")]
    //[ExternalTaskVariableRequirements("isApproved", "Role")]
    public class SendNotificationActivity : IExternalTaskAdapter
    {
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IEmailService _emailService;
        public SendNotificationActivity(ICompanyStructureService companyStructureService, IEmailService emailService)
        {
            _companyStructureService = companyStructureService;
            _emailService = emailService;
        }
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
            {
            try
            {
                var payrollService = Unity.UnityContainer.Resolve<PayRollService>();
                var goalRepository = Unity.UnityContainer.Resolve<GoalRepository>();

                //string toAddress = "aravind@snovasys.com";
                string role = (string)externalTask.Variables["Role"].Value;
                //string role = "CEO";
                string templateName = (string)externalTask.Variables["TemplateName"].Value;
                string payrollName = (string)externalTask.Variables["PayrollName"].Value;
                string subject = (string)externalTask.Variables["Subject"].Value;
                var companyId = (string)externalTask.Variables["companyId"].Value;
                var loggedUserId = (string)externalTask.Variables["loggedUserId"].Value;
              
                //var isApproved = externalTask.Variables["isApproved"]?.Value;
             
                var html = goalRepository.GetHtmlTemplateByName(templateName, new Guid(companyId));
               
                var loggedInUser = new LoggedInContext
                {
                    LoggedInUserId = new Guid(loggedUserId),
                    CompanyGuid = new Guid(companyId)
                };
                var userEmails = payrollService.GetUsersByRole(role, loggedInUser, new List<ValidationMessage>()).Select(x => x.Email).ToList();

                var siteAddress = ConfigurationManager.AppSettings["SiteUrl"] + "/payrollmanagement/payrollrun";
                var formattedHtml = html?.Replace("##role##", role)
                    .Replace("##payrollName##", payrollName)
                    .Replace("##payrollrunLink##", siteAddress);
                LoggedInContext loggedInContext = new LoggedInContext()
                {
                    LoggedInUserId = new Guid(ConfigurationManager.AppSettings["CustomAppImportsUserId"].ToString()),
                    CompanyGuid = new Guid(ConfigurationManager.AppSettings["CustomAppCompanyId"].ToString())
                };
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, new List<ValidationMessage>());
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), companyDetails.SiteAddress);
                string[] emails = new[] { userEmails.Distinct().ToString() };
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = emails,
                    HtmlContent = formattedHtml,
                    Subject = subject,
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext,emailModel);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }
    }
}
