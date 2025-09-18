using System;
using System.Collections.Generic;
using System.Configuration;
using BTrak.Common;
using Btrak.Services.UserStory;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Unity;
using Btrak.Models.CompanyStructure;
using Btrak.Models.SystemManagement;
using Btrak.Services.CompanyStructure;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Services.Email;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("SendTaskEscalationEmailActivity")]
    [ExternalTaskVariableRequirements("CompanyName", "DelayInDays")]
    public class TaskDelayEscalationActivity : IExternalTaskAdapter
    {
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IEmailService _emailService;
        public TaskDelayEscalationActivity(ICompanyStructureService companyStructureService, IEmailService emailService)
        {
            _companyStructureService = companyStructureService;
            _emailService = emailService;
        }
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                string companyName = (string)externalTask.Variables["CompanyName"].Value;
                string delayDaysInString = (string)externalTask.Variables["DelayInDays"].Value;

                var userStorySerice = Unity.UnityContainer.Resolve<UserStoryService>();

                if (!string.IsNullOrWhiteSpace(companyName) && !string.IsNullOrWhiteSpace(delayDaysInString))
                {
                    int delayDays = Convert.ToInt32(delayDaysInString);

                    var delayedTasks = userStorySerice.GetDelayedTaskDetailsByDelayedDays(companyName, delayDays, null);

                    if (delayedTasks != null && delayedTasks.Count > 0)
                    {
                        foreach (var task in delayedTasks)
                        {
                            LoggedInContext loggedInContext = new LoggedInContext()
                            {
                                LoggedInUserId = new Guid(ConfigurationManager.AppSettings["CustomAppImportsUserId"].ToString()),
                                CompanyGuid = new Guid(ConfigurationManager.AppSettings["CustomAppCompanyId"].ToString())
                            };
                            CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, new List<ValidationMessage>());
                            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), companyDetails.SiteAddress);
                            var subject = task.UserStoryName + " escalation alert";
                            var htmlContent = "Dear " + task.ProjectResponsiblePersonName + ",\n" + task.UserStoryName + " crossed the deadline on " + task.DeadLineDate + " and it is not done yet. Here is the link for it " + ConfigurationManager.AppSettings["SiteUrl"] + "/projects/workitem/" + task.UserStoryId;
                            string[] emails = new[] { task.ProjectResponsiblePersonEmail };
                            EmailGenericModel emailModel = new EmailGenericModel
                            {
                                SmtpServer = smtpDetails?.SmtpServer,
                                SmtpServerPort = smtpDetails?.SmtpServerPort,
                                SmtpMail = smtpDetails?.SmtpMail,
                                SmtpPassword = smtpDetails?.SmtpPassword,
                                ToAddresses = emails,
                                HtmlContent = htmlContent,
                                Subject = subject,
                                CCMails = null,
                                BCCMails = null,
                                MailAttachments = null,
                                IsPdf = null
                            };
                            _emailService.SendMail(loggedInContext,emailModel);
                        }
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Execute", "TaskDelayEscalationActivity", exception.Message), exception);

            }
        }
    }
}