using System;
using System.Collections.Generic;
using System.Configuration;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.SystemManagement;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using BTrak.Common;
using CamundaClient.Dto;
using CamundaClient.Worker;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("SeriousInjuryNotification")]
    [ExternalTaskVariableRequirements("from", "to", "appid", "html", "isApproved")]
    public class SendEmailWorkerActivity : IExternalTaskAdapter
    {
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IEmailService _emailService;
        public SendEmailWorkerActivity(ICompanyStructureService companyStructureService, IEmailService emailService)
        {
            _companyStructureService = companyStructureService;
            _emailService = emailService;
        }
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                string fromAddress = (string)externalTask.Variables["from"].Value;
                string toAddress = (string)externalTask.Variables["to"].Value;
                string applicationId = (string)externalTask.Variables["appid"].Value;
                bool isApproved = (bool)externalTask.Variables["isApproved"].Value;
                var content = isApproved ? " Notification is approved and created user story" : "Notification is rejected";
                string htmlContent = (string)externalTask.Variables["html"].Value + content;
                LoggedInContext loggedInContext = new LoggedInContext()
                {
                    LoggedInUserId = new Guid(ConfigurationManager.AppSettings["CustomAppImportsUserId"].ToString()),
                    CompanyGuid = new Guid(ConfigurationManager.AppSettings["CustomAppCompanyId"].ToString())
                };
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid,loggedInContext, new List<ValidationMessage>());
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), companyDetails.SiteAddress);
                string[] emails = new[] { toAddress };
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = emails,
                    HtmlContent = htmlContent,
                    Subject = "Notification Submitted",
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
