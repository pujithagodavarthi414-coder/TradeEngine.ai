using System;
using System.Collections.Generic;
using System.Configuration;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.User;
using Btrak.Services.User;
using Btrak.Services.UserStory;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Unity;
using Btrak.Models.CompanyStructure;
using Btrak.Models.SystemManagement;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("SendTaskAssignedNotification")]
    [ExternalTaskVariableRequirements("userStoryId", "ownerUserId", "loggedInUserId")]
    public class SendTaskAssignedNotificationActivity : IExternalTaskAdapter
    {
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IEmailService _emailService;
        public SendTaskAssignedNotificationActivity(ICompanyStructureService companyStructureService, IEmailService emailService)
        {
            _companyStructureService = companyStructureService;
            _emailService = emailService;
        }
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                Guid userStoryId = new Guid((string)externalTask.Variables["userStoryId"].Value);
                Guid loggedInUserId = new Guid((string)externalTask.Variables["loggedInUserId"].Value);
                Guid ownerUserId = new Guid((string)externalTask.Variables["ownerUserId"].Value);

                LoggedInContext loggedInContext = new LoggedInContext
                {
                    LoggedInUserId = loggedInUserId
                };

                var userService = Unity.UnityContainer.Resolve<UserService>();
                var userStoryService = Unity.UnityContainer.Resolve<UserStoryService>();

                UserOutputModel receiverDetails = userService.GetUserById(ownerUserId,null, loggedInContext,
                    new List<ValidationMessage>());

                var userStoryDetails =
                    userStoryService.GetUserStoryById(userStoryId, null, loggedInContext, new List<ValidationMessage>());

                if (userStoryDetails != null)
                {
                    UserOutputModel senderDetails = userService.GetUserById(loggedInContext.LoggedInUserId,null, loggedInContext,
                        new List<ValidationMessage>());
                    CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, new List<ValidationMessage>());
                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), companyDetails.SiteAddress);
                    var subject = senderDetails.FirstName + " " + senderDetails.SurName + " assigned a new task";
                    var formattedHtml = "Dear " + receiverDetails.FirstName + " " + receiverDetails.SurName + ",\n" + userStoryDetails.UserStoryName + " is assigned to you by " + senderDetails.FirstName + " " + senderDetails.SurName + ". Here is the link for it " + ConfigurationManager.AppSettings["SiteUrl"] + "/projects/workitem/" + userStoryDetails.UserStoryId;
                    string[] emails = new[] { receiverDetails.Email };
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
                    _emailService.SendMail(loggedInContext, emailModel);
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Execute", "SendTaskAssignedNotificationActivity", exception.Message), exception);

            }
        }
    }
}